import 'package:serverpod/serverpod.dart';

import '../app_config.dart';
import '../generated/protocol.dart';
import 'eta.dart';
import 'line_queue.dart';
import '../util/ttl_cache.dart';

/// Builds every view a client sees. Patient and board views share one cached
/// line snapshot per line version, so a hundred phones on one line cost one
/// query per change (PRD 12).
abstract final class Views {
  static const _cacheLifetime = Duration(seconds: 10);

  static final _snapshots = TtlCache<String, LineView>(_cacheLifetime);

  static Future<LineSnapshot> lineSnapshot(Session session, Line line) async {
    final view = await _snapshots.get(
      'line:${line.id}:${line.version}',
      () => _buildLineView(session, line, withDelivery: false),
    );
    return LineSnapshot(line, view);
  }

  static Future<LineView> _buildLineView(
    Session session,
    Line line, {
    required bool withDelivery,
    Clinic? clinic,
  }) async {
    final c = clinic ?? (await Clinic.db.findById(session, line.clinicId))!;
    final today = await currentServiceDate(session, c);
    final tickets = await Ticket.db.find(
      session,
      where: (t) =>
          t.lineId.equals(line.id!) &
          t.serviceDate.equals(today) &
          t.state.inSet({
            TicketState.waiting,
            TicketState.called,
            TicketState.confirmed,
            TicketState.inService,
          }),
      orderByList: (t) => [t.priorityRank.asc(), t.sortKey.asc()],
    );
    final servedToday = await Ticket.db.count(
      session,
      where: (t) =>
          t.lineId.equals(line.id!) &
          t.serviceDate.equals(today) &
          t.state.equals(TicketState.served),
    );
    final ids = tickets.map((t) => t.id!).toSet();
    final pushTargets = ids.isEmpty
        ? <PushTarget>[]
        : await PushTarget.db.find(
            session,
            where: (t) => t.ticketId.inSet(ids) & t.active.equals(true),
          );
    final smsTargets = ids.isEmpty
        ? <SmsTarget>[]
        : await SmsTarget.db.find(
            session,
            where: (t) => t.ticketId.inSet(ids) & t.active.equals(true),
          );
    final pushIds = pushTargets.map((p) => p.ticketId).toSet();
    final smsIds = smsTargets.map((s) => s.ticketId).toSet();

    final calledIds = tickets
        .where((t) => t.state != TicketState.waiting)
        .map((t) => t.id!)
        .toSet();
    final delivery = <UuidValue, Map<Channel, DeliveryStatus>>{};
    if (withDelivery && calledIds.isNotEmpty) {
      final notes = await Notification.db.find(
        session,
        where: (t) =>
            t.ticketId.inSet(calledIds) &
            t.kind.equals(NotificationKind.called),
        orderBy: (t) => t.createdAt,
      );
      final byTicket = {for (final t in tickets) t.id!: t};
      for (final n in notes) {
        final ticket = byTicket[n.ticketId];
        if (ticket == null || n.callVersion != ticket.callVersion) continue;
        delivery.putIfAbsent(n.ticketId, () => {})[n.channel] = n.status;
      }
    }

    final samples = await ServiceSample.db.find(
      session,
      where: (t) => t.lineId.equals(line.id!),
      orderBy: (t) => t.at.desc(),
      limit: Eta.samplesForMedian,
    );
    final median = Eta.medianServiceSeconds(
      samples.map((s) => s.serviceSeconds).toList(),
      line.defaultServiceSeconds,
    );

    return LineView(
      id: line.id!,
      name: line.name,
      code: line.code,
      version: line.version,
      acceptingJoins: line.acceptingJoins,
      tickets: [
        for (final t in tickets)
          ticketView(
            t,
            c,
            hasPush: pushIds.contains(t.id),
            hasSms: smsIds.contains(t.id),
            pushStatus: delivery[t.id]?[Channel.push],
            smsStatus: delivery[t.id]?[Channel.sms],
          ),
      ],
      medianServiceSeconds: median,
      sampleCount: samples.length,
      servedToday: servedToday,
    );
  }

  static TicketView ticketView(
    Ticket t,
    Clinic clinic, {
    bool hasPush = false,
    bool hasSms = false,
    DeliveryStatus? pushStatus,
    DeliveryStatus? smsStatus,
  }) {
    final grace = t.calledAt != null && t.state == TicketState.called
        ? t.calledAt!.add(Duration(seconds: clinic.graceSeconds))
        : null;
    final arrival = t.confirmedAt != null && t.state == TicketState.confirmed
        ? t.confirmedAt!.add(Duration(seconds: clinic.arrivalSeconds))
        : null;
    return TicketView(
      id: t.id!,
      lineId: t.lineId,
      label: t.label,
      displayName: t.displayName,
      state: t.state,
      priorityRank: t.priorityRank,
      priorityReason: t.priorityReason,
      priorityNote: t.priorityNote,
      sortKey: t.sortKey,
      roomId: t.roomId,
      calledAt: t.calledAt,
      graceEndsAt: grace,
      arrivalEndsAt: arrival,
      callVersion: t.callVersion,
      reslotCount: t.reslotCount,
      isDemo: t.isDemo,
      hasPush: hasPush,
      hasSms: hasSms,
      pushStatus: pushStatus,
      smsStatus: smsStatus,
    );
  }

  static Future<String> currentServiceDate(
    Session session,
    Clinic clinic,
  ) async => LineQueue.serviceDateNow(clinic);

  static final _clinics = TtlCache<UuidValue, Clinic>(
    const Duration(seconds: 5),
  );
  static final _presence = TtlCache<UuidValue, LinePresence>(
    const Duration(seconds: 3),
  );
  static final _lastMove = TtlCache<String, DateTime?>(
    const Duration(seconds: 30),
  );

  static Future<Clinic> clinic(Session session, UuidValue id) =>
      _clinics.get(id, () async => (await Clinic.db.findById(session, id))!);

  /// Rooms that count for the ETA and the patient's desk-offline banner:
  /// open rooms of the line with a desk heartbeat in the last 45 seconds.
  /// Cached for 3 seconds per line, so a full waiting room costs two
  /// queries every few seconds instead of two per phone.
  static Future<LinePresence> presence(Session session, Line line) =>
      _presence.get(line.id!, () => _loadPresence(session, line));

  /// Drops cached presence when a desk comes or goes, so the next view
  /// shows it straight away.
  static void presenceChanged(UuidValue lineId) => _presence.invalidate(lineId);

  static Future<LinePresence> _loadPresence(Session session, Line line) async {
    final rooms = await Room.db.find(
      session,
      where: (t) => t.lineId.equals(line.id!),
    );
    final since = DateTime.now().toUtc().subtract(Eta.presenceWindow);
    final present = await DeskPresence.db.find(
      session,
      where: (t) => t.clinicId.equals(line.clinicId) & (t.lastSeenAt > since),
    );
    final roomIds = rooms.map((r) => r.id!).toSet();
    final clinicWide = present.any((p) => p.roomId == null);
    final presentRooms = present
        .where((p) => p.roomId != null && roomIds.contains(p.roomId))
        .map((p) => p.roomId!)
        .toSet();
    final active = rooms
        .where((r) => r.state == RoomState.open && presentRooms.contains(r.id))
        .length;
    return LinePresence(
      activeRooms: active < 1 ? 1 : active,
      deskOnline: clinicWide || presentRooms.isNotEmpty,
      roomNames: {for (final r in rooms) r.id!: r.name},
    );
  }

  /// When the line last moved for its patients, cached per line version.
  static Future<DateTime?> lineMovedAt(Session session, Line line) =>
      _lastMove.get('${line.id}:${line.version}', () async {
        final event = await TicketEvent.db.findFirstRow(
          session,
          where: (t) =>
              t.lineId.equals(line.id!) &
              t.type.inSet({
                TicketEventType.called,
                TicketEventType.cancelled,
                TicketEventType.removed,
                TicketEventType.reslotted,
                TicketEventType.graceExpired,
                TicketEventType.arrivalExpired,
                TicketEventType.markedNoShow,
                TicketEventType.priorityInserted,
              }),
          orderBy: (t) => t.at.desc(),
        );
        return event?.at;
      });

  /// One patient's view. On a line change every phone on the line rebuilds,
  /// so this reads the ticket and the line and takes everything else from
  /// caches keyed by line version (PRD 12).
  static Future<PatientView> patient(
    Session session,
    UuidValue ticketId,
  ) async {
    final ticket = await Ticket.db.findById(session, ticketId);
    if (ticket == null) {
      throw DocketException(
        code: DocketErrorCode.ticketNotFound,
        message: 'That ticket no longer exists.',
      );
    }
    final clinic = await Views.clinic(session, ticket.clinicId);
    final line = (await Line.db.findById(session, ticket.lineId))!;
    final snap = await lineSnapshot(session, line);
    final presence = await Views.presence(session, line);

    final waiting = snap.waiting;
    final index = waiting.indexWhere((t) => t.id == ticket.id);
    final position = ticket.state == TicketState.waiting && index >= 0
        ? index + 1
        : null;
    int? etaSeconds;
    if (position != null) {
      etaSeconds = Eta.seconds(
        position: position,
        activeRooms: presence.activeRooms,
        medianServiceSeconds: snap.view.medianServiceSeconds,
      );
    }
    final early = snap.view.sampleCount < Eta.samplesForConfidence;
    final nowServing = snap.nowServing(ticket.roomId);
    final nextAfter = position != null && index > 0
        ? waiting[index - 1].label
        : null;

    final inSnapshot = snap.view.tickets.where((t) => t.id == ticket.id);
    final bool pushActive;
    final bool smsActive;
    if (inSnapshot.isNotEmpty) {
      pushActive = inSnapshot.first.hasPush;
      smsActive = inSnapshot.first.hasSms;
    } else {
      pushActive =
          await PushTarget.db.count(
            session,
            where: (t) => t.ticketId.equals(ticket.id!) & t.active.equals(true),
          ) >
          0;
      smsActive =
          await SmsTarget.db.count(
            session,
            where: (t) => t.ticketId.equals(ticket.id!) & t.active.equals(true),
          ) >
          0;
    }
    final sms = smsActive
        ? await SmsTarget.db.findFirstRow(
            session,
            where: (t) => t.ticketId.equals(ticket.id!) & t.active.equals(true),
          )
        : null;

    String? toToken;
    String? toLabel;
    String? toLine;
    if (ticket.transferredToTicketId != null &&
        ticket.transferTokenCipher != null) {
      toToken = AppConfig.sealer(session).decrypt(ticket.transferTokenCipher!);
      final next = await Ticket.db.findById(
        session,
        ticket.transferredToTicketId!,
      );
      if (next != null) {
        toLabel = next.label;
        toLine = (await Line.db.findById(session, next.lineId))?.name;
      }
    }

    final graceEnds =
        ticket.state == TicketState.called && ticket.calledAt != null
        ? ticket.calledAt!.add(Duration(seconds: clinic.graceSeconds))
        : null;
    final arrivalEnds =
        ticket.state == TicketState.confirmed && ticket.confirmedAt != null
        ? ticket.confirmedAt!.add(Duration(seconds: clinic.arrivalSeconds))
        : null;

    return PatientView(
      ticketId: ticket.id!,
      clinicName: clinic.name,
      label: ticket.label,
      lineName: line.name,
      state: ticket.state,
      position: position,
      etaMinutes: etaSeconds == null ? null : Eta.minutes(etaSeconds),
      etaText: etaSeconds == null ? null : Eta.text(etaSeconds, early: early),
      etaIsEstimate: early,
      roomName: ticket.roomId == null
          ? null
          : presence.roomNames[ticket.roomId],
      nowServingLabel: nowServing,
      nextAfterLabel: nextAfter,
      graceEndsAt: graceEnds,
      arrivalEndsAt: arrivalEnds,
      graceSeconds: clinic.graceSeconds,
      reslotCount: ticket.reslotCount,
      maxReslots: clinic.maxReslots,
      headsUpSent: ticket.headsUpSentAt != null,
      lineMovedAt: await lineMovedAt(session, line),
      deskOnline: presence.deskOnline,
      transferredToToken: toToken,
      transferredToLabel: toLabel,
      transferredToLineName: toLine,
      closedReason: ticket.closedReason,
      pushActive: pushActive,
      smsActive: smsActive,
      smsEnabled: clinic.smsEnabled && !clinic.isSandbox,
      smsLast4: sms?.phoneLast4,
      isDemo: ticket.isDemo,
      serverTime: DateTime.now().toUtc(),
      version: line.version,
    );
  }

  static Future<DeskView> desk(Session session, UuidValue clinicId) async {
    final clinic = (await Clinic.db.findById(session, clinicId))!;
    final lines = await Line.db.find(
      session,
      where: (t) => t.clinicId.equals(clinicId),
      orderByList: (t) => [t.sortOrder.asc(), t.code.asc()],
    );
    final rooms = await Room.db.find(
      session,
      where: (t) => t.clinicId.equals(clinicId),
      orderByList: (t) => [t.sortOrder.asc(), t.name.asc()],
    );
    final today = LineQueue.serviceDateNow(clinic);
    final day = await ServiceDay.db.findFirstRow(
      session,
      where: (t) => t.clinicId.equals(clinicId) & t.serviceDate.equals(today),
    );
    final lineViews = <LineView>[];
    for (final line in lines) {
      lineViews.add(
        await _buildLineView(session, line, withDelivery: true, clinic: clinic),
      );
    }
    final since = DateTime.now().toUtc().subtract(Eta.presenceWindow);
    final present = await DeskPresence.db.find(
      session,
      where: (t) => t.clinicId.equals(clinicId) & (t.lastSeenAt > since),
    );
    final presentRooms = present.map((p) => p.roomId).toSet();
    final current = <UuidValue, UuidValue>{};
    for (final lv in lineViews) {
      for (final t in lv.tickets) {
        if (t.roomId != null && t.state != TicketState.waiting) {
          current[t.roomId!] = t.id;
        }
      }
    }
    return DeskView(
      clinicId: clinicId,
      clinicName: clinic.name,
      clinicSlug: clinic.slug,
      isSandbox: clinic.isSandbox,
      day: day?.state,
      lines: lineViews,
      rooms: [
        for (final r in rooms)
          RoomView(
            id: r.id!,
            name: r.name,
            lineId: r.lineId,
            state: r.state,
            currentTicketId: current[r.id],
            deskOnline: presentRooms.contains(r.id),
          ),
      ],
      joinUrl: AppConfig.joinUrl(session.serverpod, clinic.slug),
      serverTime: DateTime.now().toUtc(),
    );
  }

  static Future<BoardView> board(Session session, Clinic clinic) async {
    final lines = await Line.db.find(
      session,
      where: (t) => t.clinicId.equals(clinic.id!),
      orderByList: (t) => [t.sortOrder.asc(), t.code.asc()],
    );
    final rooms = await Room.db.find(
      session,
      where: (t) => t.clinicId.equals(clinic.id!),
      orderByList: (t) => [t.sortOrder.asc(), t.name.asc()],
    );
    final roomNames = {for (final r in rooms) r.id!: r.name};
    final waitingByLine = <String, int>{};
    final serving = <UuidValue, String>{};
    for (final line in lines) {
      final snap = await lineSnapshot(session, line);
      waitingByLine[line.name] = snap.waiting.length;
      for (final t in snap.view.tickets) {
        if (t.roomId != null && t.state != TicketState.waiting) {
          serving[t.roomId!] = t.label;
        }
      }
    }
    final today = LineQueue.serviceDateNow(clinic);
    final calls = await Ticket.db.find(
      session,
      where: (t) =>
          t.clinicId.equals(clinic.id!) &
          t.serviceDate.equals(today) &
          t.calledAt.notEquals(null) &
          t.roomId.notEquals(null),
      orderBy: (t) => t.calledAt.desc(),
      limit: 5,
    );
    return BoardView(
      clinicName: clinic.name,
      rooms: [
        for (final r in rooms)
          BoardRoom(
            roomName: r.name,
            state: r.state,
            nowServingLabel: serving[r.id],
          ),
      ],
      recentCalls: [
        for (final t in calls)
          BoardCall(
            label: t.label,
            roomName: roomNames[t.roomId] ?? '',
            calledAt: t.calledAt!,
            callVersion: t.callVersion,
          ),
      ],
      waitingByLine: waitingByLine,
      joinUrl: AppConfig.joinUrl(session.serverpod, clinic.slug),
      serverTime: DateTime.now().toUtc(),
    );
  }
}

/// Desk presence for one line, shared by every patient on it.
class LinePresence {
  const LinePresence({
    required this.activeRooms,
    required this.deskOnline,
    required this.roomNames,
  });

  final int activeRooms;
  final bool deskOnline;
  final Map<UuidValue, String> roomNames;
}

/// One line's cached ordering, shared by every patient on it.
class LineSnapshot {
  LineSnapshot(this.line, this.view);

  final Line line;
  final LineView view;

  List<TicketView> get waiting =>
      view.tickets.where((t) => t.state == TicketState.waiting).toList();

  /// The label in front of the room this ticket was called to, or the most
  /// recently called ticket on the line.
  String? nowServing(UuidValue? roomId) {
    final active =
        view.tickets
            .where((t) => t.state != TicketState.waiting && t.calledAt != null)
            .toList()
          ..sort((a, b) => b.calledAt!.compareTo(a.calledAt!));
    if (active.isEmpty) return null;
    if (roomId != null) {
      for (final t in active) {
        if (t.roomId == roomId) return t.label;
      }
    }
    return active.first.label;
  }
}
