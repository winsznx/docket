import 'package:serverpod/serverpod.dart';

import '../app_config.dart';
import '../generated/future_calls.dart';
import '../generated/protocol.dart';
import '../security/phone.dart';
import '../security/tokens.dart';
import '../strings.dart';
import '../util/ttl_cache.dart';
import 'actor.dart';
import 'clinic_time.dart';
import 'eta.dart';
import 'heads_up.dart';
import 'line_queue.dart';
import 'miss_rule.dart';
import 'notification_policy.dart';
import 'ordering.dart';
import 'timers.dart';
import 'transitions.dart';
import 'views.dart';

/// The only code that changes ticket state (PRD 10). Endpoints and future
/// calls both come through here.
///
/// Each command runs in one transaction: lock the affected lines in id
/// order, validate against the PRD 5.1 table, write the ticket, one
/// TicketEvent, the bumped line version, notifications and receipts, then
/// commit. Timers, dispatch and channel posts happen after commit, and the
/// 30-second timer sweep covers a crash in that gap.
abstract final class QueueService {
  static const int maxJoinsPerClinicDay = 2000;

  // Serverpod Cloud measured about 50 ms per database round trip from the
  // podlet (docs/SPONSOR_FINDINGS.md F7), so the hot path caches what
  // rarely changes. Each cache lives on this podlet only.
  static final _medians = TtlCache<UuidValue, int>(const Duration(seconds: 30));
  static final _openDays = TtlCache<String, bool>(const Duration(seconds: 30));
  static const int maxSandboxTickets = 200;

  // ---------------------------------------------------------------- patient

  static Future<({Ticket ticket, String token})> join(
    Session session, {
    required Clinic clinic,
    required Line line,
    required String displayName,
    String? phoneE164,
    bool smsConsent = false,
    bool isDemo = false,
    Actor actor = Actor.patient,
  }) async {
    final fx = _Effects();
    final result = await session.db.transaction((t) async {
      final lines = await _lockLines(session, t, [line.id!]);
      return _addTicket(
        session,
        t,
        fx,
        clinic: clinic,
        line: lines[line.id]!,
        displayName: displayName,
        phoneE164: phoneE164,
        smsConsent: smsConsent,
        isDemo: isDemo,
        actor: actor,
        eventType: TicketEventType.joined,
      );
    });
    await _afterCommit(session, fx);
    return result;
  }

  static Future<void> confirm(Session session, Ticket ticket) async {
    final fx = _Effects();
    await session.db.transaction((t) async {
      final clinic = (await Clinic.db.findById(session, ticket.clinicId))!;
      final lines = await _lockLines(session, t, [ticket.lineId]);
      final current = await _ticket(session, t, ticket.id!);
      _guard(TicketCommand.confirm, current);
      final graceEnd = current.calledAt!.add(
        Duration(seconds: clinic.graceSeconds),
      );
      if (DateTime.now().toUtc().isAfter(graceEnd)) {
        throw DocketException(
          code: DocketErrorCode.invalidTransition,
          message:
              "The time to confirm ran out. You'll be back in line in a moment.",
        );
      }
      final now = DateTime.now().toUtc();
      final updated = current.copyWith(
        state: TicketState.confirmed,
        confirmedAt: now,
      );
      await Ticket.db.updateRow(session, updated, transaction: t);
      final line = await _bump(
        session,
        t,
        fx,
        lines[ticket.lineId]!,
        'confirmed',
      );
      await _event(
        session,
        t,
        updated,
        TicketEventType.confirmed,
        from: current.state,
        actor: Actor.patient,
        line: line,
      );
      _cancelGrace(fx, updated);
      final arrivalEnd = now.add(Duration(seconds: clinic.arrivalSeconds));
      final id = updated.id!;
      final version = updated.callVersion;
      fx.after.add(
        (s) => s.serverpod.futureCalls
            .callAtTime(arrivalEnd, identifier: 'arrival:$id:$version')
            .ticketTimers
            .arrivalExpired(id, version),
      );
    });
    await _afterCommit(session, fx);
  }

  static Future<void> leave(Session session, Ticket ticket) async {
    final fx = _Effects();
    await session.db.transaction((t) async {
      final lines = await _lockLines(session, t, [ticket.lineId]);
      final current = await _ticket(session, t, ticket.id!);
      final clinic = (await Clinic.db.findById(session, current.clinicId))!;
      await _terminate(
        session,
        t,
        fx,
        clinic: clinic,
        line: lines[current.lineId]!,
        ticket: current,
        command: TicketCommand.leave,
        eventType: TicketEventType.cancelled,
        actor: Actor.patient,
        reason: null,
      );
    });
    await _afterCommit(session, fx);
  }

  /// Push or SMS targets changed, which the desk shows as an alerts chip.
  static Future<void> alertsChanged(Session session, Ticket ticket) async {
    final fx = _Effects();
    await session.db.transaction((t) async {
      final lines = await _lockLines(session, t, [ticket.lineId]);
      await _bump(session, t, fx, lines[ticket.lineId]!, 'alerts');
    });
    await _afterCommit(session, fx);
  }

  // ------------------------------------------------------------------- desk

  static Future<DeskActionResult> applyDeskAction(
    Session session,
    Clinic clinic,
    DeskAction action,
    Actor actor,
  ) async {
    final stored = await DeskActionReceipt.db.findFirstRow(
      session,
      where: (t) => t.actionId.equals(action.actionId),
    );
    if (stored != null) return _duplicate(session, clinic, stored);

    final fx = _Effects();
    final who = actor.forAction(action);
    try {
      final outcome = await session.db.transaction((t) async {
        final applied = await _applyAction(session, t, fx, clinic, action, who);
        await DeskActionReceipt.db.insertRow(
          session,
          DeskActionReceipt(
            actionId: action.actionId,
            deviceId: action.deviceId,
            seq: action.seq,
            clinicId: clinic.id!,
            outcome: ActionOutcome.applied,
            ticketId: applied.ticket?.id,
            appliedAt: DateTime.now().toUtc(),
          ),
          transaction: t,
        );
        return applied;
      });
      await _afterCommit(session, fx);
      final ticket = outcome.ticket;
      session.log(
        '[queue] ${action.runtimeType} applied ${ticket?.label ?? ''}',
        level: LogLevel.info,
      );
      return DeskActionResult(
        actionId: action.actionId,
        outcome: ActionOutcome.applied,
        ticket: ticket == null ? null : Views.ticketView(ticket, clinic),
        ticketUrl: outcome.token == null
            ? null
            : AppConfig.ticketUrl(session.serverpod, outcome.token!),
      );
    } on DatabaseUniqueViolationException {
      final race = await DeskActionReceipt.db.findFirstRow(
        session,
        where: (t) => t.actionId.equals(action.actionId),
      );
      if (race != null) return _duplicate(session, clinic, race);
      rethrow;
    } on DocketException catch (e) {
      session.log(
        '[queue] ${action.runtimeType} rejected: ${e.message}',
        level: LogLevel.info,
      );
      await DeskActionReceipt.db.insert(
        session,
        [
          DeskActionReceipt(
            actionId: action.actionId,
            deviceId: action.deviceId,
            seq: action.seq,
            clinicId: clinic.id!,
            outcome: ActionOutcome.rejected,
            code: e.code,
            message: e.message,
            ticketId: _actionTicketId(action),
            appliedAt: DateTime.now().toUtc(),
          ),
        ],
        ignoreConflicts: true,
      );
      return DeskActionResult(
        actionId: action.actionId,
        outcome: ActionOutcome.rejected,
        code: e.code,
        message: e.message,
      );
    }
  }

  static Future<DeskActionResult> _duplicate(
    Session session,
    Clinic clinic,
    DeskActionReceipt receipt,
  ) async {
    final ticket = receipt.ticketId == null
        ? null
        : await Ticket.db.findById(session, receipt.ticketId!);
    return DeskActionResult(
      actionId: receipt.actionId,
      outcome: ActionOutcome.duplicate,
      code: receipt.code,
      message: receipt.message,
      ticket: ticket == null ? null : Views.ticketView(ticket, clinic),
    );
  }

  static UuidValue? _actionTicketId(DeskAction action) => switch (action) {
    CallNextAction() => null,
    SetRoomStateAction() => null,
    CloseDayAction() => null,
    CallSpecificAction(:final ticketId) => ticketId,
    RecallAction(:final ticketId) => ticketId,
    StartServiceAction(:final ticketId) => ticketId,
    FinishAction(:final ticketId) => ticketId,
    MarkNoShowAction(:final ticketId) => ticketId,
    RemoveAction(:final ticketId) => ticketId,
    AddWalkInAction(:final ticketId) => ticketId,
    AddPriorityAction(:final ticketId) => ticketId,
    TransferAction(:final ticketId) => ticketId,
  };

  static Future<_Applied> _applyAction(
    Session session,
    Transaction t,
    _Effects fx,
    Clinic clinic,
    DeskAction action,
    Actor actor,
  ) async {
    switch (action) {
      case CallNextAction(:final roomId):
        final room = await _room(session, t, clinic, roomId);
        final lines = await _lockLines(session, t, [room.lineId]);
        await _ensureDay(session, t, fx, clinic, forJoin: false);
        final queue = await LineQueue.waiting(
          session,
          t,
          room.lineId,
          LineQueue.serviceDateNow(clinic),
        );
        if (queue.isEmpty) {
          throw DocketException(
            code: DocketErrorCode.invalidTransition,
            message: Copy.noOneWaiting,
          );
        }
        final called = await _call(
          session,
          t,
          fx,
          clinic,
          lines[room.lineId]!,
          room,
          queue.first,
          actor,
          waitingAfter: queue.skip(1).toList(),
        );
        return _Applied(called);

      case CallSpecificAction(:final roomId, :final ticketId):
        final room = await _room(session, t, clinic, roomId);
        final lines = await _lockLines(session, t, [room.lineId]);
        await _ensureDay(session, t, fx, clinic, forJoin: false);
        final ticket = await _ticket(session, t, ticketId, clinic: clinic);
        if (ticket.lineId != room.lineId) {
          throw DocketException(
            code: DocketErrorCode.validation,
            message: '${room.name} calls from a different line.',
          );
        }
        final called = await _call(
          session,
          t,
          fx,
          clinic,
          lines[room.lineId]!,
          room,
          ticket,
          actor,
        );
        return _Applied(called);

      case RecallAction(:final ticketId):
        final pre = await _ticket(session, t, ticketId, clinic: clinic);
        final lines = await _lockLines(session, t, [pre.lineId]);
        final ticket = await _ticket(session, t, ticketId);
        _guard(TicketCommand.recall, ticket);
        final line = await _bump(
          session,
          t,
          fx,
          lines[ticket.lineId]!,
          'recall',
        );
        final event = await _event(
          session,
          t,
          ticket,
          TicketEventType.recalled,
          from: ticket.state,
          actor: actor,
          line: line,
        );
        await _notify(
          session,
          t,
          fx,
          clinic,
          ticket,
          NotificationKind.called,
          suffix: 'recall-${event.id}',
        );
        fx.ticketChanged[ticket.id!] = line.version;
        return _Applied(ticket);

      case StartServiceAction(:final ticketId, :final roomId):
        final pre = await _ticket(session, t, ticketId, clinic: clinic);
        final lines = await _lockLines(session, t, [pre.lineId]);
        final ticket = await _ticket(session, t, ticketId);
        _guard(TicketCommand.startService, ticket);
        final room = await _room(session, t, clinic, roomId);
        final updated = ticket.copyWith(
          state: TicketState.inService,
          serviceStartedAt: DateTime.now().toUtc(),
          roomId: room.id,
        );
        await Ticket.db.updateRow(session, updated, transaction: t);
        final line = await _bump(
          session,
          t,
          fx,
          lines[ticket.lineId]!,
          'start',
        );
        await _event(
          session,
          t,
          updated,
          TicketEventType.serviceStarted,
          from: ticket.state,
          actor: actor,
          line: line,
        );
        _cancelGrace(fx, updated);
        _cancelArrival(fx, updated);
        return _Applied(updated);

      case FinishAction(:final ticketId):
        final pre = await _ticket(session, t, ticketId, clinic: clinic);
        final lines = await _lockLines(session, t, [pre.lineId]);
        final ticket = await _ticket(session, t, ticketId);
        _guard(TicketCommand.finish, ticket);
        final now = DateTime.now().toUtc();
        final updated = ticket.copyWith(
          state: TicketState.served,
          finishedAt: now,
        );
        await Ticket.db.updateRow(session, updated, transaction: t);
        await _sample(session, t, updated, now);
        final line = await _bump(
          session,
          t,
          fx,
          lines[ticket.lineId]!,
          'finish',
        );
        await _event(
          session,
          t,
          updated,
          TicketEventType.served,
          from: ticket.state,
          actor: actor,
          line: line,
        );
        await _headsUpCheck(session, t, fx, clinic, line);
        return _Applied(updated);

      case MarkNoShowAction(:final ticketId):
        final pre = await _ticket(session, t, ticketId, clinic: clinic);
        final lines = await _lockLines(session, t, [pre.lineId]);
        final ticket = await _ticket(session, t, ticketId);
        _guard(TicketCommand.markNoShow, ticket);
        final updated = await _miss(
          session,
          t,
          fx,
          clinic,
          lines[ticket.lineId]!,
          ticket,
          TicketEventType.markedNoShow,
          actor,
        );
        return _Applied(updated);

      case RemoveAction(:final ticketId, :final reason):
        if (reason.trim().isEmpty) {
          throw DocketException(
            code: DocketErrorCode.validation,
            message: Copy.reasonNeeded,
          );
        }
        final pre = await _ticket(session, t, ticketId, clinic: clinic);
        final lines = await _lockLines(session, t, [pre.lineId]);
        final ticket = await _ticket(session, t, ticketId);
        final updated = await _terminate(
          session,
          t,
          fx,
          clinic: clinic,
          line: lines[ticket.lineId]!,
          ticket: ticket,
          command: TicketCommand.remove,
          eventType: TicketEventType.removed,
          actor: actor,
          reason: _clip(reason, 60),
        );
        return _Applied(updated);

      case AddWalkInAction(
        :final ticketId,
        :final lineId,
        :final displayName,
        :final phoneE164,
      ):
        final line = await _line(session, t, clinic, lineId);
        final lines = await _lockLines(session, t, [line.id!]);
        final added = await _addTicket(
          session,
          t,
          fx,
          clinic: clinic,
          line: lines[line.id]!,
          displayName: displayName,
          phoneE164: phoneE164,
          smsConsent: phoneE164 != null,
          isDemo: false,
          actor: actor,
          eventType: TicketEventType.walkInAdded,
          ticketId: ticketId,
        );
        return _Applied(added.ticket, token: added.token);

      case AddPriorityAction(
        :final ticketId,
        :final lineId,
        :final displayName,
        :final reason,
        :final note,
        :final phoneE164,
      ):
        final line = await _line(session, t, clinic, lineId);
        final lines = await _lockLines(session, t, [line.id!]);
        final added = await _addTicket(
          session,
          t,
          fx,
          clinic: clinic,
          line: lines[line.id]!,
          displayName: displayName,
          phoneE164: phoneE164,
          smsConsent: phoneE164 != null,
          isDemo: false,
          actor: actor,
          eventType: TicketEventType.priorityInserted,
          ticketId: ticketId,
          priorityReason: reason,
          priorityNote: note == null ? null : _clip(note, 60),
        );
        return _Applied(added.ticket, token: added.token);

      case TransferAction(
        :final ticketId,
        :final targetLineId,
        :final newTicketId,
      ):
        final pre = await _ticket(session, t, ticketId, clinic: clinic);
        final target = await _line(session, t, clinic, targetLineId);
        if (target.id == pre.lineId) {
          throw DocketException(
            code: DocketErrorCode.validation,
            message: 'Pick a different line to transfer to.',
          );
        }
        final lines = await _lockLines(session, t, [pre.lineId, target.id!]);
        final ticket = await _ticket(session, t, ticketId);
        final moved = await _transfer(
          session,
          t,
          fx,
          clinic,
          lines[ticket.lineId]!,
          lines[target.id]!,
          ticket,
          newTicketId,
          actor,
        );
        return _Applied(moved.ticket, token: moved.token);

      case SetRoomStateAction(:final roomId, :final state):
        final room = await _room(session, t, clinic, roomId);
        final lines = await _lockLines(session, t, [room.lineId]);
        await Room.db.updateRow(
          session,
          room.copyWith(state: state),
          transaction: t,
        );
        await _bump(session, t, fx, lines[room.lineId]!, 'room');
        fx.clinicChanged.add(clinic.id!);
        return const _Applied(null);

      case CloseDayAction(:final clinicId):
        if (clinicId != clinic.id) {
          throw DocketException(
            code: DocketErrorCode.validation,
            message: 'That action belongs to another clinic.',
          );
        }
        await _closeDay(session, t, fx, clinic, actor);
        return const _Applied(null);
    }
  }

  static Future<({String token, String url})> linkPhone(
    Session session,
    Clinic clinic,
    UuidValue ticketId,
  ) async {
    final fx = _Effects();
    final token = Tokens.mint();
    await session.db.transaction((t) async {
      final pre = await _ticket(session, t, ticketId, clinic: clinic);
      final lines = await _lockLines(session, t, [pre.lineId]);
      final ticket = await _ticket(session, t, ticketId);
      if (Transitions.terminal.contains(ticket.state)) {
        throw DocketException(
          code: DocketErrorCode.invalidTransition,
          message: Copy.invalidTransition(ticket.label, ticket.state),
        );
      }
      await Ticket.db.updateRow(
        session,
        ticket.copyWith(tokenHash: Tokens.hash(token)),
        transaction: t,
      );
      await _resealTargets(session, t, ticket.id!, token);
      await _bump(session, t, fx, lines[ticket.lineId]!, 'relink');
    });
    await _afterCommit(session, fx);
    return (token: token, url: AppConfig.ticketUrl(session.serverpod, token));
  }

  // ----------------------------------------------------------------- system

  static Future<void> graceReminder(
    Session session,
    UuidValue ticketId,
    int callVersion,
  ) async {
    final fx = _Effects();
    await session.db.transaction((t) async {
      final pre = await Ticket.db.findById(session, ticketId, transaction: t);
      if (pre == null) return;
      final lines = await _lockLines(session, t, [pre.lineId]);
      final ticket = await _ticket(session, t, ticketId);
      if (ticket.state != TicketState.called ||
          ticket.callVersion != callVersion) {
        return;
      }
      final sent = await TicketEvent.db.findFirstRow(
        session,
        where: (x) =>
            x.ticketId.equals(ticketId) &
            x.type.equals(TicketEventType.graceReminderSent) &
            (x.at >= ticket.calledAt!),
        transaction: t,
      );
      if (sent != null) return;
      final clinic = (await Clinic.db.findById(session, ticket.clinicId))!;
      await _event(
        session,
        t,
        ticket,
        TicketEventType.graceReminderSent,
        from: ticket.state,
        actor: Actor.system,
        line: lines[ticket.lineId]!,
      );
      await _notify(
        session,
        t,
        fx,
        clinic,
        ticket,
        NotificationKind.graceReminder,
      );
    });
    await _afterCommit(session, fx);
  }

  /// Grace or arrival window ended. A no-op unless the ticket is still in
  /// the same state with the same `callVersion`, so duplicate and late runs
  /// are safe.
  static Future<bool> windowExpired(
    Session session,
    UuidValue ticketId,
    int callVersion, {
    required bool arrival,
  }) async {
    final fx = _Effects();
    final applied = await session.db.transaction((t) async {
      final pre = await Ticket.db.findById(session, ticketId, transaction: t);
      if (pre == null) return false;
      final lines = await _lockLines(session, t, [pre.lineId]);
      final ticket = await _ticket(session, t, ticketId);
      final expected = arrival ? TicketState.confirmed : TicketState.called;
      if (ticket.state != expected || ticket.callVersion != callVersion) {
        return false;
      }
      final clinic = (await Clinic.db.findById(session, ticket.clinicId))!;
      await _miss(
        session,
        t,
        fx,
        clinic,
        lines[ticket.lineId]!,
        ticket,
        arrival ? TicketEventType.arrivalExpired : TicketEventType.graceExpired,
        Actor.system,
      );
      return true;
    });
    await _afterCommit(session, fx);
    if (applied) {
      session.log(
        '[timer] ${arrival ? 'arrival' : 'grace'} window ended for $ticketId '
        'v$callVersion',
        level: LogLevel.info,
      );
    }
    return applied;
  }

  /// Opens today's service day if it isn't yet, as the first desk action
  /// would (PRD 5.3).
  static Future<void> openDay(Session session, Clinic clinic) async {
    final fx = _Effects();
    await session.db.transaction(
      (t) => _ensureDay(session, t, fx, clinic, forJoin: false),
    );
    await _afterCommit(session, fx);
  }

  static Future<void> closeDay(
    Session session,
    Clinic clinic,
    Actor actor,
  ) async {
    final fx = _Effects();
    await session.db.transaction(
      (t) => _closeDay(session, t, fx, clinic, actor),
    );
    await _afterCommit(session, fx);
  }

  // -------------------------------------------------------------- internals

  static Future<Map<UuidValue, Line>> _lockLines(
    Session session,
    Transaction t,
    Iterable<UuidValue> ids,
  ) async {
    final ordered = ids.toSet().toList()
      ..sort((a, b) => a.toString().compareTo(b.toString()));
    final locked = <UuidValue, Line>{};
    for (final id in ordered) {
      final line = await Line.db.findById(
        session,
        id,
        lockMode: LockMode.forUpdate,
        transaction: t,
      );
      if (line == null) {
        throw DocketException(
          code: DocketErrorCode.validation,
          message: 'That line no longer exists.',
        );
      }
      locked[id] = line;
    }
    return locked;
  }

  static Future<Ticket> _ticket(
    Session session,
    Transaction t,
    UuidValue id, {
    Clinic? clinic,
  }) async {
    final ticket = await Ticket.db.findById(session, id, transaction: t);
    if (ticket == null || (clinic != null && ticket.clinicId != clinic.id)) {
      throw DocketException(
        code: DocketErrorCode.ticketNotFound,
        message: "That ticket isn't in this clinic's line any more.",
      );
    }
    return ticket;
  }

  static Future<Room> _room(
    Session session,
    Transaction t,
    Clinic clinic,
    UuidValue id,
  ) async {
    final room = await Room.db.findById(session, id, transaction: t);
    if (room == null || room.clinicId != clinic.id) {
      throw DocketException(
        code: DocketErrorCode.validation,
        message: "That room isn't part of this clinic.",
      );
    }
    return room;
  }

  static Future<Line> _line(
    Session session,
    Transaction t,
    Clinic clinic,
    UuidValue id,
  ) async {
    final line = await Line.db.findById(session, id, transaction: t);
    if (line == null || line.clinicId != clinic.id) {
      throw DocketException(
        code: DocketErrorCode.validation,
        message: "That line isn't part of this clinic.",
      );
    }
    return line;
  }

  static void _guard(TicketCommand command, Ticket ticket) {
    if (!Transitions.allowed(command, ticket.state)) {
      throw DocketException(
        code: DocketErrorCode.invalidTransition,
        message: Copy.invalidTransition(ticket.label, ticket.state),
      );
    }
  }

  static String _clip(String value, int max) {
    final clean = value.replaceAll(RegExp(r'[\x00-\x1F\x7F]'), '').trim();
    return clean.length > max ? clean.substring(0, max) : clean;
  }

  static String cleanName(String? raw) {
    final name = _clip(raw ?? '', 40);
    return name.isEmpty ? 'Patient' : name;
  }

  static Future<Line> _bump(
    Session session,
    Transaction t,
    _Effects fx,
    Line line,
    String reason,
  ) async {
    final current = fx.lineVersions[line.id] ?? line.version;
    final bumped = line.copyWith(version: current + 1);
    await Line.db.updateRow(session, bumped, transaction: t);
    fx.lineVersions[line.id!] = bumped.version;
    fx.lineReasons[line.id!] = reason;
    return bumped;
  }

  static Future<TicketEvent> _event(
    Session session,
    Transaction t,
    Ticket ticket,
    TicketEventType type, {
    required TicketState? from,
    required Actor actor,
    required Line line,
    String? reason,
  }) => TicketEvent.db.insertRow(
    session,
    TicketEvent(
      clinicId: ticket.clinicId,
      lineId: ticket.lineId,
      ticketId: ticket.id!,
      ticketLabel: ticket.label,
      type: type,
      fromState: from,
      toState: ticket.state,
      actor: actor.type,
      actorRef: actor.ref,
      deviceId: actor.deviceId,
      actionId: actor.actionId,
      roomId: ticket.roomId,
      reason: reason,
      lineVersion: line.version,
      at: DateTime.now().toUtc(),
    ),
    transaction: t,
  );

  static Future<void> _ensureDay(
    Session session,
    Transaction t,
    _Effects fx,
    Clinic clinic, {
    required bool forJoin,
  }) async {
    final now = DateTime.now().toUtc();
    final date = ClinicTime.serviceDate(clinic.timezone, now);
    final minutes = ClinicTime.localMinutes(clinic.timezone, now);
    final key = '${clinic.id}:$date';
    void checkCutoff() {
      if (forJoin && minutes >= ClinicTime.minutesOf(clinic.joinCutoffTime)) {
        throw DocketException(
          code: DocketErrorCode.joinCutoffPassed,
          message: Copy.cutoffPassed(clinic.name, clinic.joinCutoffTime),
        );
      }
    }

    if (_openDays.has(key)) {
      checkCutoff();
      return;
    }
    final existing = await ServiceDay.db.findFirstRow(
      session,
      where: (x) => x.clinicId.equals(clinic.id!) & x.serviceDate.equals(date),
      transaction: t,
    );
    if (existing != null) {
      if (existing.state == DayState.closed) {
        throw DocketException(
          code: DocketErrorCode.dayClosed,
          message: forJoin
              ? Copy.dayClosedJoin(clinic.name)
              : Copy.dayClosedDesk,
        );
      }
    } else if (forJoin && minutes < ClinicTime.minutesOf(clinic.openTime)) {
      throw DocketException(
        code: DocketErrorCode.dayClosed,
        message: Copy.notOpenYet(clinic.name, clinic.openTime),
      );
    }
    checkCutoff();
    if (existing != null) {
      _openDays.put(key, true);
      return;
    }

    await ServiceDay.db.insert(
      session,
      [
        ServiceDay(
          clinicId: clinic.id!,
          serviceDate: date,
          state: DayState.open,
          openedAt: now,
        ),
      ],
      ignoreConflicts: true,
      transaction: t,
    );
    final closeAt = ClinicTime.atLocal(
      clinic.timezone,
      date,
      clinic.closeTime,
      addMinutes: clinic.autoCloseAfterMinutes,
    );
    final clinicId = clinic.id!;
    fx.after.add(
      (s) => s.serverpod.futureCalls
          .callAtTime(closeAt, identifier: 'autoclose:$clinicId:$date')
          .clinicJobs
          .autoCloseDay(clinicId, date),
    );
    fx.openedDays.add(key);
    fx.clinicChanged.add(clinicId);
  }

  static Future<({Ticket ticket, String token})> _addTicket(
    Session session,
    Transaction t,
    _Effects fx, {
    required Clinic clinic,
    required Line line,
    required String displayName,
    required String? phoneE164,
    required bool smsConsent,
    required bool isDemo,
    required Actor actor,
    required TicketEventType eventType,
    UuidValue? ticketId,
    PriorityReason? priorityReason,
    String? priorityNote,
  }) async {
    if (eventType == TicketEventType.priorityInserted &&
        priorityReason == null) {
      throw DocketException(
        code: DocketErrorCode.validation,
        message: Copy.reasonNeeded,
      );
    }
    if (clinic.isSandbox &&
        clinic.sandboxExpiresAt != null &&
        DateTime.now().toUtc().isAfter(clinic.sandboxExpiresAt!)) {
      throw DocketException(
        code: DocketErrorCode.sandboxExpired,
        message: Copy.sandboxExpired,
      );
    }
    if (!line.acceptingJoins) {
      throw DocketException(
        code: DocketErrorCode.lineNotAccepting,
        message: Copy.lineNotAccepting(line.name),
      );
    }
    await _ensureDay(session, t, fx, clinic, forJoin: true);
    final date = LineQueue.serviceDateNow(clinic);

    if (clinic.isSandbox) {
      final count = await Ticket.db.count(
        session,
        where: (x) => x.clinicId.equals(clinic.id!),
        transaction: t,
      );
      if (count >= maxSandboxTickets) {
        throw DocketException(
          code: DocketErrorCode.rateLimited,
          message: Copy.sandboxFull,
        );
      }
    }
    await _countJoin(session, t, clinic, date);

    String? phone;
    if (phoneE164 != null && phoneE164.trim().isNotEmpty) {
      if (!clinic.smsEnabled || clinic.isSandbox) {
        throw DocketException(
          code: DocketErrorCode.smsDisabled,
          message: Copy.smsDisabled,
        );
      }
      if (!smsConsent) {
        throw DocketException(
          code: DocketErrorCode.validation,
          message: Copy.consentNeeded,
        );
      }
      phone = normalizePhoneE164(phoneE164);
      if (phone == null) {
        throw DocketException(
          code: DocketErrorCode.validation,
          message: Copy.phoneInvalid,
        );
      }
    }

    final number = await LineQueue.nextNumber(session, t, line.id!, date);
    final rank = priorityReason == null ? 1 : 0;
    final key = await LineQueue.appendKey(session, t, line.id!, date, rank);
    final token = Tokens.mint();
    final now = DateTime.now().toUtc();
    final ticket = await Ticket.db.insertRow(
      session,
      Ticket(
        id: ticketId,
        clinicId: clinic.id!,
        lineId: line.id!,
        serviceDate: date,
        number: number,
        label: LineQueue.label(line.code, number),
        tokenHash: Tokens.hash(token),
        displayName: cleanName(displayName),
        state: TicketState.waiting,
        priorityRank: rank,
        priorityReason: priorityReason,
        priorityNote: priorityNote,
        sortKey: key,
        joinedAt: now,
        isDemo: isDemo,
      ),
      transaction: t,
    );
    final bumped = await _bump(session, t, fx, line, eventType.name);
    await _event(
      session,
      t,
      ticket,
      eventType,
      from: null,
      actor: actor,
      line: bumped,
      reason: priorityReason?.name,
    );
    if (phone != null) {
      final sealer = AppConfig.sealer(session);
      await SmsTarget.db.insertRow(
        session,
        SmsTarget(
          ticketId: ticket.id!,
          phoneCipher: sealer.encrypt(phone),
          phoneLast4: phone.substring(phone.length - 4),
          consentAt: now,
          linkCipher: sealer.encrypt(
            AppConfig.ticketUrl(session.serverpod, token),
          ),
        ),
        transaction: t,
      );
      await _notify(session, t, fx, clinic, ticket, NotificationKind.joined);
    }
    await _headsUpCheck(session, t, fx, clinic, bumped);
    return (ticket: ticket, token: token);
  }

  static Future<void> _countJoin(
    Session session,
    Transaction t,
    Clinic clinic,
    String date,
  ) async {
    final key = 'joins:${clinic.id}';
    final window = DateTime.parse('${date}T00:00:00Z');
    await session.db.unsafeExecute(
      'INSERT INTO rate_bucket (id, "bucketKey", "windowStart", hits) '
      r'VALUES (gen_random_uuid(), $1, $2, 1) '
      'ON CONFLICT ("bucketKey", "windowStart") '
      'DO UPDATE SET hits = rate_bucket.hits + 1',
      parameters: QueryParameters.positional([key, window]),
      transaction: t,
    );
    final bucket = await RateBucket.db.findFirstRow(
      session,
      where: (x) => x.bucketKey.equals(key) & x.windowStart.equals(window),
      transaction: t,
    );
    if ((bucket?.hits ?? 0) > maxJoinsPerClinicDay) {
      throw DocketException(
        code: DocketErrorCode.rateLimited,
        message: Copy.clinicFull,
      );
    }
  }

  static Future<Ticket> _call(
    Session session,
    Transaction t,
    _Effects fx,
    Clinic clinic,
    Line line,
    Room room,
    Ticket ticket,
    Actor actor, {
    List<Ticket>? waitingAfter,
  }) async {
    _guard(TicketCommand.callNext, ticket);
    if (room.state != RoomState.open) {
      throw DocketException(
        code: DocketErrorCode.roomNotOpen,
        message: Copy.roomNotOpen(room.name),
      );
    }
    if (room.lineId != ticket.lineId) {
      throw DocketException(
        code: DocketErrorCode.validation,
        message: '${room.name} calls from a different line.',
      );
    }
    final now = DateTime.now().toUtc();
    final called = ticket.copyWith(
      state: TicketState.called,
      calledAt: now,
      confirmedAt: null,
      roomId: room.id,
      callVersion: ticket.callVersion + 1,
    );
    await Ticket.db.updateRow(session, called, transaction: t);
    final bumped = await _bump(session, t, fx, line, 'called');
    await _event(
      session,
      t,
      called,
      TicketEventType.called,
      from: ticket.state,
      actor: actor,
      line: bumped,
    );
    await _notify(session, t, fx, clinic, called, NotificationKind.called);

    final graceEnd = now.add(Duration(seconds: clinic.graceSeconds));
    final id = called.id!;
    final version = called.callVersion;
    if (clinic.graceReminderSeconds < clinic.graceSeconds) {
      final remindAt = graceEnd.subtract(
        Duration(seconds: clinic.graceReminderSeconds),
      );
      fx.after.add(
        (s) => s.serverpod.futureCalls
            .callAtTime(remindAt, identifier: 'grace-reminder:$id:$version')
            .ticketTimers
            .graceReminder(id, version),
      );
    }
    fx.after.add(
      (s) => s.serverpod.futureCalls
          .callAtTime(graceEnd, identifier: 'grace:$id:$version')
          .ticketTimers
          .graceExpired(id, version),
    );
    await _headsUpCheck(
      session,
      t,
      fx,
      clinic,
      bumped,
      waiting: waitingAfter,
    );
    return called;
  }

  static Future<Ticket> _miss(
    Session session,
    Transaction t,
    _Effects fx,
    Clinic clinic,
    Line line,
    Ticket ticket,
    TicketEventType trigger,
    Actor actor,
  ) async {
    final outcome = MissRule.decide(
      reslotCount: ticket.reslotCount,
      maxReslots: clinic.maxReslots,
    );
    _cancelGrace(fx, ticket);
    _cancelArrival(fx, ticket);
    final Ticket updated;
    if (outcome == MissOutcome.reslot) {
      var queue = await LineQueue.waiting(
        session,
        t,
        ticket.lineId,
        ticket.serviceDate,
      );
      var normal = queue
          .where((x) => x.priorityRank == 1)
          .map((x) => x.sortKey)
          .toList();
      var placement = Ordering.reslot(normal, clinic.reslotOffset);
      if (placement.needsRenumber) {
        queue = await LineQueue.renumber(
          session,
          t,
          ticket.lineId,
          ticket.serviceDate,
        );
        normal = queue
            .where((x) => x.priorityRank == 1)
            .map((x) => x.sortKey)
            .toList();
        placement = Ordering.reslot(normal, clinic.reslotOffset);
      }
      updated = ticket.copyWith(
        state: TicketState.waiting,
        priorityRank: 1,
        sortKey: placement.sortKey,
        reslotCount: ticket.reslotCount + 1,
        roomId: null,
        confirmedAt: null,
        headsUpSentAt: null,
      );
    } else {
      updated = ticket.copyWith(
        state: TicketState.expired,
        finishedAt: DateTime.now().toUtc(),
      );
    }
    await Ticket.db.updateRow(session, updated, transaction: t);
    final bumped = await _bump(session, t, fx, line, trigger.name);
    await _event(
      session,
      t,
      updated,
      trigger,
      from: ticket.state,
      actor: actor,
      line: bumped,
      reason: outcome == MissOutcome.reslot ? 'reslotted' : 'expired',
    );
    await _notify(
      session,
      t,
      fx,
      clinic,
      updated,
      outcome == MissOutcome.reslot
          ? NotificationKind.reslotted
          : NotificationKind.expired,
    );
    await _headsUpCheck(session, t, fx, clinic, bumped);
    return updated;
  }

  static Future<Ticket> _terminate(
    Session session,
    Transaction t,
    _Effects fx, {
    required Clinic clinic,
    required Line line,
    required Ticket ticket,
    required TicketCommand command,
    required TicketEventType eventType,
    required Actor actor,
    required String? reason,
  }) async {
    _guard(command, ticket);
    final updated = ticket.copyWith(
      state: Transitions.target(command, ticket.state),
      finishedAt: DateTime.now().toUtc(),
      closedReason: reason,
    );
    await Ticket.db.updateRow(session, updated, transaction: t);
    final bumped = await _bump(session, t, fx, line, eventType.name);
    await _event(
      session,
      t,
      updated,
      eventType,
      from: ticket.state,
      actor: actor,
      line: bumped,
      reason: reason,
    );
    _cancelGrace(fx, ticket);
    _cancelArrival(fx, ticket);
    await _deactivateTargets(session, t, ticket.id!);
    await _headsUpCheck(session, t, fx, clinic, bumped);
    return updated;
  }

  static Future<({Ticket ticket, String token})> _transfer(
    Session session,
    Transaction t,
    _Effects fx,
    Clinic clinic,
    Line from,
    Line to,
    Ticket ticket,
    UuidValue newTicketId,
    Actor actor,
  ) async {
    _guard(TicketCommand.transfer, ticket);
    if (!to.acceptingJoins) {
      throw DocketException(
        code: DocketErrorCode.lineNotAccepting,
        message: Copy.lineNotAccepting(to.name),
      );
    }
    final date = ticket.serviceDate;
    final now = DateTime.now().toUtc();
    final number = await LineQueue.nextNumber(session, t, to.id!, date);
    final key = await LineQueue.appendKey(session, t, to.id!, date, 1);
    final token = Tokens.mint();
    final sealer = AppConfig.sealer(session);
    final next = await Ticket.db.insertRow(
      session,
      Ticket(
        id: newTicketId,
        clinicId: clinic.id!,
        lineId: to.id!,
        serviceDate: date,
        number: number,
        label: LineQueue.label(to.code, number),
        tokenHash: Tokens.hash(token),
        displayName: ticket.displayName,
        state: TicketState.waiting,
        sortKey: key,
        joinedAt: now,
        transferredFromTicketId: ticket.id,
        isDemo: ticket.isDemo,
      ),
      transaction: t,
    );
    final old = ticket.copyWith(
      state: TicketState.transferred,
      finishedAt: now,
      transferredToTicketId: next.id,
      transferTokenCipher: sealer.encrypt(token),
    );
    await Ticket.db.updateRow(session, old, transaction: t);
    if (old.serviceStartedAt != null) await _sample(session, t, old, now);

    final fromBumped = await _bump(session, t, fx, from, 'transferred');
    await _event(
      session,
      t,
      old,
      TicketEventType.transferred,
      from: ticket.state,
      actor: actor,
      line: fromBumped,
      reason: to.name,
    );
    final toBumped = await _bump(session, t, fx, to, 'joined');
    await _event(
      session,
      t,
      next,
      TicketEventType.joined,
      from: null,
      actor: actor,
      line: toBumped,
      reason: 'transfer from ${ticket.label}',
    );

    await PushTarget.db.updateWhere(
      session,
      where: (x) => x.ticketId.equals(ticket.id!),
      columnValues: (x) => [x.ticketId(next.id!)],
      transaction: t,
    );
    await SmsTarget.db.updateWhere(
      session,
      where: (x) => x.ticketId.equals(ticket.id!),
      columnValues: (x) => [x.ticketId(next.id!)],
      transaction: t,
    );
    await _resealTargets(session, t, next.id!, token);
    await _notify(session, t, fx, clinic, next, NotificationKind.transferred);
    fx.ticketChanged[ticket.id!] = fromBumped.version;
    await _headsUpCheck(session, t, fx, clinic, toBumped);
    return (ticket: next, token: token);
  }

  static Future<void> _closeDay(
    Session session,
    Transaction t,
    _Effects fx,
    Clinic clinic,
    Actor actor,
  ) async {
    final lineIds = (await Line.db.find(
      session,
      where: (x) => x.clinicId.equals(clinic.id!),
      transaction: t,
    )).map((l) => l.id!);
    final lines = await _lockLines(session, t, lineIds);
    final date = LineQueue.serviceDateNow(clinic);
    final now = DateTime.now().toUtc();
    final open = await Ticket.db.find(
      session,
      where: (x) =>
          x.clinicId.equals(clinic.id!) &
          x.state.inSet({
            TicketState.waiting,
            TicketState.called,
            TicketState.confirmed,
            TicketState.inService,
          }),
      transaction: t,
    );
    final bumped = <UuidValue, Line>{};
    for (final line in lines.values) {
      bumped[line.id!] = await _bump(session, t, fx, line, 'dayClosed');
    }
    for (final ticket in open) {
      final target = Transitions.target(TicketCommand.closeDay, ticket.state)!;
      final updated = ticket.copyWith(
        state: target,
        finishedAt: now,
        closedReason: target == TicketState.served
            ? 'auto-finished at close'
            : 'day closed',
      );
      await Ticket.db.updateRow(session, updated, transaction: t);
      if (target == TicketState.served) await _sample(session, t, updated, now);
      await _event(
        session,
        t,
        updated,
        target == TicketState.served
            ? TicketEventType.served
            : TicketEventType.closed,
        from: ticket.state,
        actor: actor,
        line: bumped[ticket.lineId]!,
        reason: updated.closedReason,
      );
      _cancelGrace(fx, ticket);
      _cancelArrival(fx, ticket);
      if (target == TicketState.closed) {
        await _notify(
          session,
          t,
          fx,
          clinic,
          updated,
          NotificationKind.dayClosed,
        );
      }
    }
    final day = await ServiceDay.db.findFirstRow(
      session,
      where: (x) => x.clinicId.equals(clinic.id!) & x.serviceDate.equals(date),
      transaction: t,
    );
    if (day == null) {
      await ServiceDay.db.insertRow(
        session,
        ServiceDay(
          clinicId: clinic.id!,
          serviceDate: date,
          state: DayState.closed,
          openedAt: now,
          closedAt: now,
        ),
        transaction: t,
      );
    } else if (day.state == DayState.open) {
      await ServiceDay.db.updateRow(
        session,
        day.copyWith(state: DayState.closed, closedAt: now),
        transaction: t,
      );
    }
    fx.cancels.add('autoclose:${clinic.id}:$date');
    _openDays.invalidate('${clinic.id}:$date');
    fx.clinicChanged.add(clinic.id!);
  }

  static Future<void> _sample(
    Session session,
    Transaction t,
    Ticket ticket,
    DateTime finishedAt,
  ) async {
    final started = ticket.serviceStartedAt;
    if (started == null || ticket.roomId == null) return;
    final called = ticket.calledAt ?? started;
    _medians.invalidate(ticket.lineId);
    await ServiceSample.db.insertRow(
      session,
      ServiceSample(
        lineId: ticket.lineId,
        roomId: ticket.roomId!,
        serviceSeconds: finishedAt
            .difference(started)
            .inSeconds
            .clamp(1, 86400),
        callToStartSeconds: started
            .difference(called)
            .inSeconds
            .clamp(0, 86400),
        at: finishedAt,
      ),
      transaction: t,
    );
  }

  /// PRD 4.6, run inside the same transaction as every queue change.
  static Future<void> _headsUpCheck(
    Session session,
    Transaction t,
    _Effects fx,
    Clinic clinic,
    Line line, {
    List<Ticket>? waiting,
  }) async {
    final date = LineQueue.serviceDateNow(clinic);
    final queue =
        waiting ?? await LineQueue.waiting(session, t, line.id!, date);
    if (queue.isEmpty) return;
    final median = await _medians.get(line.id!, () async {
      final samples = await ServiceSample.db.find(
        session,
        where: (x) => x.lineId.equals(line.id!),
        orderBy: (x) => x.at.desc(),
        limit: Eta.samplesForMedian,
        transaction: t,
      );
      return Eta.medianServiceSeconds(
        samples.map((s) => s.serviceSeconds).toList(),
        line.defaultServiceSeconds,
      );
    });
    final presence = await Views.presence(session, line);
    final now = DateTime.now().toUtc();
    for (var i = 0; i < queue.length; i++) {
      final ticket = queue[i];
      final eta = Eta.seconds(
        position: i + 1,
        activeRooms: presence.activeRooms,
        medianServiceSeconds: median,
      );
      final due = HeadsUp.due(
        alreadySent: ticket.headsUpSentAt != null,
        position: i + 1,
        etaSeconds: eta,
        headsUpPositions: clinic.headsUpPositions,
        headsUpMinutes: clinic.headsUpMinutes,
      );
      if (!due) continue;
      final updated = ticket.copyWith(headsUpSentAt: now);
      await Ticket.db.updateRow(session, updated, transaction: t);
      await _event(
        session,
        t,
        updated,
        TicketEventType.headsUpSent,
        from: ticket.state,
        actor: Actor.system,
        line: line,
      );
      await _notify(session, t, fx, clinic, updated, NotificationKind.headsUp);
    }
  }

  static Future<void> _notify(
    Session session,
    Transaction t,
    _Effects fx,
    Clinic clinic,
    Ticket ticket,
    NotificationKind kind, {
    String? suffix,
  }) async {
    final targets = await session.db.unsafeQuery(
      'SELECT '
      '(SELECT count(*) FROM push_target WHERE "ticketId" = @id::uuid AND active), '
      '(SELECT count(*) FROM sms_target WHERE "ticketId" = @id::uuid AND active)',
      parameters: QueryParameters.named({'id': ticket.id.toString()}),
      transaction: t,
    );
    final row = targets.first;
    final pushActive = (row[0] as int) > 0;
    final smsActive = (row[1] as int) > 0;
    final channels = NotificationPolicy.channels(
      kind: kind,
      pushActive: pushActive,
      smsActive: smsActive && clinic.smsEnabled && !clinic.isSandbox,
    );
    for (final channel in channels) {
      final rows = await Notification.db.insert(
        session,
        [
          Notification(
            ticketId: ticket.id!,
            clinicId: clinic.id!,
            ticketLabel: ticket.label,
            kind: kind,
            channel: channel,
            status: DeliveryStatus.queued,
            callVersion: ticket.callVersion,
            dedupeKey: NotificationPolicy.dedupeKey(
              ticketId: ticket.id!,
              kind: kind,
              channel: channel,
              callVersion: ticket.callVersion,
              reslotCount: ticket.reslotCount,
              suffix: suffix,
            ),
          ),
        ],
        ignoreConflicts: true,
        transaction: t,
      );
      fx.notifications.addAll(rows.map((r) => r.id!));
    }
  }

  static Future<void> _deactivateTargets(
    Session session,
    Transaction t,
    UuidValue ticketId,
  ) async {
    await PushTarget.db.updateWhere(
      session,
      where: (x) => x.ticketId.equals(ticketId),
      columnValues: (x) => [x.active(false)],
      transaction: t,
    );
    await SmsTarget.db.updateWhere(
      session,
      where: (x) => x.ticketId.equals(ticketId),
      columnValues: (x) => [x.active(false)],
      transaction: t,
    );
  }

  static Future<void> _resealTargets(
    Session session,
    Transaction t,
    UuidValue ticketId,
    String token,
  ) async {
    final sealed = AppConfig.sealer(session).encrypt(
      AppConfig.ticketUrl(session.serverpod, token),
    );
    await PushTarget.db.updateWhere(
      session,
      where: (x) => x.ticketId.equals(ticketId),
      columnValues: (x) => [x.linkCipher(sealed)],
      transaction: t,
    );
    await SmsTarget.db.updateWhere(
      session,
      where: (x) => x.ticketId.equals(ticketId),
      columnValues: (x) => [x.linkCipher(sealed)],
      transaction: t,
    );
  }

  static void _cancelGrace(_Effects fx, Ticket ticket) {
    fx.cancels
      ..add('grace:${ticket.id}:${ticket.callVersion}')
      ..add('grace-reminder:${ticket.id}:${ticket.callVersion}');
  }

  static void _cancelArrival(_Effects fx, Ticket ticket) {
    fx.cancels.add('arrival:${ticket.id}:${ticket.callVersion}');
  }

  /// Timers, dispatch and channel posts. Future-call scheduling can't join
  /// the commit, so a failure here is logged and left to the sweeps and the
  /// 20-second stream heartbeat (PRD 10).
  static Future<void> _afterCommit(Session session, _Effects fx) async {
    for (final key in fx.openedDays) {
      _openDays.put(key, true);
    }
    if (Timers.scheduling(session.serverpod)) {
      await _scheduleTimers(session, fx);
    }
    for (final entry in fx.lineVersions.entries) {
      await _post(
        session,
        'line.${entry.key}',
        LineChanged(
          lineId: entry.key,
          version: entry.value,
          reason: fx.lineReasons[entry.key] ?? 'changed',
        ),
      );
    }
    for (final entry in fx.ticketChanged.entries) {
      await _post(
        session,
        'ticket.${entry.key}',
        TicketChanged(ticketId: entry.key, version: entry.value),
      );
    }
    for (final clinicId in fx.clinicChanged) {
      await _post(
        session,
        'clinic.$clinicId',
        ClinicChanged(clinicId: clinicId),
      );
    }
  }

  static Future<void> _scheduleTimers(Session session, _Effects fx) async {
    final calls = session.serverpod.futureCalls;
    for (final id in fx.cancels) {
      try {
        await calls.cancel(id);
      } on Exception catch (e) {
        session.log('[timer] cancel $id failed: $e', level: LogLevel.warning);
      }
    }
    for (final schedule in fx.after) {
      try {
        await schedule(session);
      } on Exception catch (e) {
        session.log('[timer] schedule failed: $e', level: LogLevel.error);
      }
    }
    for (final id in fx.notifications) {
      try {
        await calls
            .callWithDelay(Duration.zero, identifier: 'dispatch:$id:1')
            .dispatch
            .send(id);
      } on Exception catch (e) {
        session.log('[notify] enqueue $id failed: $e', level: LogLevel.error);
      }
    }
  }

  static Future<void> _post(
    Session session,
    String channel,
    SerializableModel message,
  ) async {
    try {
      await session.messages.postMessage(channel, message);
    } on Exception catch (e) {
      session.log(
        '[queue] post to $channel failed: $e',
        level: LogLevel.warning,
      );
    }
  }
}

class _Applied {
  const _Applied(this.ticket, {this.token});

  final Ticket? ticket;
  final String? token;
}

class _Effects {
  final lineVersions = <UuidValue, int>{};
  final lineReasons = <UuidValue, String>{};
  final ticketChanged = <UuidValue, int>{};
  final clinicChanged = <UuidValue>{};
  final notifications = <UuidValue>[];
  final after = <Future<void> Function(Session)>[];
  final cancels = <String>{};
  final openedDays = <String>{};
}
