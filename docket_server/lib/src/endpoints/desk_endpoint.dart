import 'package:async/async.dart';
import 'package:serverpod/serverpod.dart';

import '../domain/eta.dart';
import '../domain/queue_service.dart';
import '../domain/views.dart';
import '../generated/protocol.dart';
import '../security/clinic_auth.dart';
import '../util/coalesce.dart';

/// The desk. `requireLogin` stays false so sandbox tokens work, and every
/// method authorizes through [ClinicAuth.desk] first (PRD 9.3).
class DeskEndpoint extends Endpoint {
  static const heartbeatEvery = Duration(seconds: 20);
  static const maxBatch = 200;

  Future<DeskView> getView(
    Session session,
    UuidValue clinicId,
    String? sandboxToken,
  ) async {
    await ClinicAuth.desk(session, clinicId, sandboxToken);
    return Views.desk(session, clinicId);
  }

  Stream<DeskView> watch(
    Session session,
    UuidValue clinicId,
    UuidValue deviceId,
    String? sandboxToken,
  ) async* {
    await ClinicAuth.desk(session, clinicId, sandboxToken);
    yield await Views.desk(session, clinicId);
    final lines = await Line.db.find(
      session,
      where: (t) => t.clinicId.equals(clinicId),
    );
    final events = StreamGroup.merge<Object?>([
      session.messages.createStream<ClinicChanged>('clinic.$clinicId'),
      for (final line in lines)
        session.messages.createStream<LineChanged>('line.${line.id}'),
      Stream<Object?>.periodic(heartbeatEvery),
    ]);
    await for (final _ in events.transform(
      const Coalesce<Object?>(Duration(milliseconds: 100)),
    )) {
      yield await Views.desk(session, clinicId);
    }
  }

  Future<DeskActionResult> act(
    Session session,
    DeskAction action,
    String? sandboxToken,
  ) async {
    final clinicId = await _clinicOf(session, action);
    final auth = await ClinicAuth.desk(session, clinicId, sandboxToken);
    return QueueService.applyDeskAction(
      session,
      auth.clinic,
      action,
      auth.actor,
    );
  }

  /// Replays an offline outbox in `seq` order. Authorization is checked
  /// again for every action, and the server's answer always wins (PRD 15.4).
  Future<SyncResult> sync(
    Session session,
    SyncBatch batch,
    String? sandboxToken,
  ) async {
    if (batch.actions.isEmpty) {
      throw DocketException(
        code: DocketErrorCode.validation,
        message: 'There was nothing to sync.',
      );
    }
    final actions = [...batch.actions]..sort((a, b) => a.seq.compareTo(b.seq));
    final results = <DeskActionResult>[];
    UuidValue? clinicId;
    for (final action in actions.take(maxBatch)) {
      if (action.deviceId != batch.deviceId) {
        results.add(
          DeskActionResult(
            actionId: action.actionId,
            outcome: ActionOutcome.rejected,
            code: DocketErrorCode.validation,
            message: 'That action came from a different device.',
          ),
        );
        continue;
      }
      try {
        final id = await _clinicOf(session, action);
        clinicId ??= id;
        final auth = await ClinicAuth.desk(session, id, sandboxToken);
        results.add(
          await QueueService.applyDeskAction(
            session,
            auth.clinic,
            action,
            auth.actor,
          ),
        );
      } on DocketException catch (e) {
        results.add(
          DeskActionResult(
            actionId: action.actionId,
            outcome: ActionOutcome.rejected,
            code: e.code,
            message: e.message,
          ),
        );
      }
    }
    session.log(
      '[sync] ${results.length} actions from ${batch.deviceId}: '
      '${results.where((r) => r.outcome == ActionOutcome.applied).length} applied, '
      '${results.where((r) => r.outcome == ActionOutcome.rejected).length} rejected',
    );
    if (clinicId == null) {
      throw DocketException(
        code: DocketErrorCode.validation,
        message: 'None of those actions belong to a clinic you can see.',
      );
    }
    return SyncResult(
      results: results,
      view: await Views.desk(session, clinicId),
    );
  }

  Future<void> heartbeat(
    Session session,
    UuidValue clinicId,
    UuidValue deviceId,
    UuidValue? roomId,
    String? sandboxToken,
  ) async {
    final auth = await ClinicAuth.desk(session, clinicId, sandboxToken);
    final now = DateTime.now().toUtc();
    final existing = await DeskPresence.db.findFirstRow(
      session,
      where: (t) => t.deviceId.equals(deviceId),
    );
    final wasPresent =
        existing != null &&
        existing.clinicId == clinicId &&
        existing.roomId == roomId &&
        now.difference(existing.lastSeenAt) < Eta.presenceWindow;
    final row = DeskPresence(
      clinicId: clinicId,
      deviceId: deviceId,
      roomId: roomId,
      actorRef: auth.actor.ref ?? auth.actor.type.name,
      lastSeenAt: now,
    );
    if (existing == null) {
      await DeskPresence.db.insert(session, [row], ignoreConflicts: true);
    } else {
      await DeskPresence.db.updateRow(session, row.copyWith(id: existing.id));
    }
    if (!wasPresent) {
      final lines = await Line.db.find(
        session,
        where: (t) => t.clinicId.equals(clinicId),
      );
      for (final line in lines) {
        Views.presenceChanged(line.id!);
        await session.messages.postMessage(
          'line.${line.id}',
          LineChanged(
            lineId: line.id!,
            version: line.version,
            reason: 'presence',
          ),
        );
      }
    }
  }

  /// Rotates a ticket's token so the desk can show a fresh QR to a walk-in.
  /// The old link stops working (PRD 18).
  Future<String> linkPhone(
    Session session,
    UuidValue ticketId,
    String? sandboxToken,
  ) async {
    final ticket = await Ticket.db.findById(session, ticketId);
    if (ticket == null) {
      throw DocketException(
        code: DocketErrorCode.ticketNotFound,
        message: "That ticket isn't in the line any more.",
      );
    }
    final auth = await ClinicAuth.desk(session, ticket.clinicId, sandboxToken);
    final linked = await QueueService.linkPhone(session, auth.clinic, ticketId);
    return linked.url;
  }

  static Future<UuidValue> _clinicOf(Session session, DeskAction action) async {
    Future<UuidValue> ofRoom(UuidValue id) async =>
        (await Room.db.findById(session, id))?.clinicId ?? _missing();
    Future<UuidValue> ofLine(UuidValue id) async =>
        (await Line.db.findById(session, id))?.clinicId ?? _missing();
    Future<UuidValue> ofTicket(UuidValue id) async =>
        (await Ticket.db.findById(session, id))?.clinicId ?? _missing();
    return switch (action) {
      CallNextAction(:final roomId) => ofRoom(roomId),
      CallSpecificAction(:final roomId) => ofRoom(roomId),
      SetRoomStateAction(:final roomId) => ofRoom(roomId),
      StartServiceAction(:final ticketId) => ofTicket(ticketId),
      RecallAction(:final ticketId) => ofTicket(ticketId),
      FinishAction(:final ticketId) => ofTicket(ticketId),
      MarkNoShowAction(:final ticketId) => ofTicket(ticketId),
      RemoveAction(:final ticketId) => ofTicket(ticketId),
      TransferAction(:final ticketId) => ofTicket(ticketId),
      AddWalkInAction(:final lineId) => ofLine(lineId),
      AddPriorityAction(:final lineId) => ofLine(lineId),
      CloseDayAction(:final clinicId) => Future.value(clinicId),
    };
  }

  static Never _missing() => throw DocketException(
    code: DocketErrorCode.ticketNotFound,
    message: "That ticket isn't in the line any more.",
  );
}
