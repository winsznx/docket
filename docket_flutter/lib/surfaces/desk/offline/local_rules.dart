import 'package:docket_client/docket_client.dart' hide Notification;

import '../../../shared/strings.dart';

/// What the local rules need to know about the clinic beyond its tickets.
class LocalContext {
  const LocalContext({
    required this.roomLines,
    required this.lineCodes,
    required this.now,
    this.reslotOffset = MissDefaults.reslotOffset,
    this.maxReslots = MissDefaults.maxReslots,
  });

  /// The clinic's miss rule, from the last desk view.
  final int reslotOffset;
  final int maxReslots;

  /// The line each room calls from.
  final Map<UuidValue, UuidValue> roomLines;

  /// Each line's one-letter code, for the "C-?" label of a new ticket.
  final Map<UuidValue, String> lineCodes;

  final DateTime now;
}

/// PRD 4.2 defaults for the miss rule, used only before the first desk view
/// arrives with the clinic's own values.
abstract final class MissDefaults {
  static const reslotOffset = 3;
  static const maxReslots = 1;
}

/// PRD 15.3: each desk action applied to the local mirror with local data
/// only, the way `QueueService` would apply it on the server. Every row it
/// returns is marked `pendingSync` until the server answers.
abstract final class LocalRules {
  static const joinGap = 1024.0;

  static const _active = {
    TicketState.waiting,
    TicketState.called,
    TicketState.confirmed,
    TicketState.inService,
  };

  /// The label a ticket shows until the server gives it a number.
  static String pendingLabel(String lineCode) => '$lineCode-?';

  /// Waiting tickets of [lineId] in call order: priority first, then sort
  /// key (PRD 4.3).
  static List<LocalTicket> eligible(
    Iterable<LocalTicket> tickets,
    UuidValue lineId,
  ) =>
      tickets
          .where((t) => t.lineId == lineId && t.state == TicketState.waiting)
          .toList()
        ..sort(callOrder);

  static int callOrder(LocalTicket a, LocalTicket b) {
    final rank = a.priorityRank.compareTo(b.priorityRank);
    return rank != 0 ? rank : a.sortKey.compareTo(b.sortKey);
  }

  static bool isActive(TicketState state) => _active.contains(state);

  /// The rows [action] changes or adds. An action the local data can't
  /// apply, such as a call with no one waiting, changes nothing here and
  /// the server's answer decides.
  static List<LocalTicket> apply(
    DeskAction action,
    List<LocalTicket> tickets,
    LocalContext context,
  ) {
    final byId = {for (final t in tickets) t.id!: t};
    LocalTicket? find(UuidValue id) => byId[id];

    LocalTicket change(LocalTicket t, TicketState state, {UuidValue? roomId}) =>
        t.copyWith(
          state: state,
          roomId: roomId ?? t.roomId,
          pendingSync: true,
          updatedAt: context.now,
        );

    LocalTicket call(LocalTicket t, UuidValue roomId) => t.copyWith(
      state: TicketState.called,
      roomId: roomId,
      calledAt: context.now,
      callVersion: t.callVersion + 1,
      pendingSync: true,
      updatedAt: context.now,
    );

    switch (action) {
      case CallNextAction(:final roomId):
        final lineId = context.roomLines[roomId];
        if (lineId == null) return const [];
        final next = eligible(tickets, lineId).firstOrNull;
        return next == null ? const [] : [call(next, roomId)];

      case CallSpecificAction(:final roomId, :final ticketId):
        final ticket = find(ticketId);
        if (ticket == null ||
            ticket.state != TicketState.waiting ||
            ticket.lineId != context.roomLines[roomId]) {
          return const [];
        }
        return [call(ticket, roomId)];

      case RecallAction():
        return const [];

      case StartServiceAction(:final ticketId, :final roomId):
        final ticket = find(ticketId);
        if (ticket == null ||
            !{
              TicketState.called,
              TicketState.confirmed,
            }.contains(ticket.state)) {
          return const [];
        }
        return [change(ticket, TicketState.inService, roomId: roomId)];

      case FinishAction(:final ticketId):
        final ticket = find(ticketId);
        if (ticket == null || ticket.state != TicketState.inService) {
          return const [];
        }
        return [change(ticket, TicketState.served)];

      case MarkNoShowAction(:final ticketId):
        final ticket = find(ticketId);
        if (ticket == null ||
            !{
              TicketState.called,
              TicketState.confirmed,
            }.contains(ticket.state)) {
          return const [];
        }
        return [_miss(ticket, tickets, context)];

      case RemoveAction(:final ticketId):
        final ticket = find(ticketId);
        if (ticket == null ||
            !{
              TicketState.waiting,
              TicketState.called,
              TicketState.confirmed,
            }.contains(ticket.state)) {
          return const [];
        }
        return [change(ticket, TicketState.removed)];

      case AddWalkInAction(:final ticketId, :final lineId, :final displayName):
        return [
          _added(
            id: ticketId,
            lineId: lineId,
            displayName: displayName,
            rank: 1,
            tickets: tickets,
            context: context,
          ),
        ];

      case AddPriorityAction(
        :final ticketId,
        :final lineId,
        :final displayName,
        :final reason,
      ):
        return [
          _added(
            id: ticketId,
            lineId: lineId,
            displayName: displayName,
            rank: 0,
            reason: reason,
            tickets: tickets,
            context: context,
          ),
        ];

      case TransferAction(
        :final ticketId,
        :final targetLineId,
        :final newTicketId,
      ):
        final ticket = find(ticketId);
        if (ticket == null ||
            ticket.state != TicketState.inService ||
            ticket.lineId == targetLineId) {
          return const [];
        }
        return [
          change(ticket, TicketState.transferred),
          _added(
            id: newTicketId,
            lineId: targetLineId,
            displayName: ticket.displayName,
            rank: 1,
            isDemo: ticket.isDemo,
            tickets: tickets,
            context: context,
          ),
        ];

      case SetRoomStateAction():
        return const [];

      case CloseDayAction():
        return [
          for (final t in tickets)
            if (t.state == TicketState.inService)
              change(t, TicketState.served)
            else if (isActive(t.state))
              change(t, TicketState.closed),
        ];
    }
  }

  static LocalTicket _added({
    required UuidValue id,
    required UuidValue lineId,
    required String displayName,
    required int rank,
    required List<LocalTicket> tickets,
    required LocalContext context,
    PriorityReason? reason,
    bool isDemo = false,
  }) {
    final keys = tickets
        .where(
          (t) =>
              t.lineId == lineId &&
              t.state == TicketState.waiting &&
              t.priorityRank == rank,
        )
        .map((t) => t.sortKey);
    final last = keys.isEmpty ? 0.0 : keys.reduce((a, b) => a > b ? a : b);
    final name = displayName.trim();
    return LocalTicket(
      id: id,
      lineId: lineId,
      label: pendingLabel(context.lineCodes[lineId] ?? ''),
      displayName: name.isEmpty ? DeskStrings.defaultName : name,
      state: TicketState.waiting,
      priorityRank: rank,
      priorityReason: reason,
      sortKey: last + joinGap,
      isDemo: isDemo,
      pendingSync: true,
      updatedAt: context.now,
    );
  }

  /// PRD 4.5: back into the line `reslotOffset` places behind
  /// the front of the normal queue, or expired once the misses run out.
  static LocalTicket _miss(
    LocalTicket ticket,
    List<LocalTicket> tickets,
    LocalContext context,
  ) {
    if (ticket.reslotCount >= context.maxReslots) {
      return ticket.copyWith(
        state: TicketState.expired,
        pendingSync: true,
        updatedAt: context.now,
      );
    }
    final keys =
        tickets
            .where(
              (t) =>
                  t.id != ticket.id &&
                  t.lineId == ticket.lineId &&
                  t.state == TicketState.waiting &&
                  t.priorityRank == 1,
            )
            .map((t) => t.sortKey)
            .toList()
          ..sort();
    return ticket.copyWith(
      state: TicketState.waiting,
      priorityRank: 1,
      sortKey: reslotKey(keys, context.reslotOffset),
      reslotCount: ticket.reslotCount + 1,
      pendingSync: true,
      updatedAt: context.now,
    );
  }

  /// The sort key that lands a ticket at 1-based position [offset] among
  /// [keysAscending], or last when fewer tickets wait (PRD 4.3 and 4.5).
  static double reslotKey(List<double> keysAscending, int offset) {
    final ahead = offset - 1;
    if (ahead >= keysAscending.length) {
      return (keysAscending.isEmpty ? 0.0 : keysAscending.last) + joinGap;
    }
    if (ahead <= 0) return keysAscending.first - joinGap;
    final before = keysAscending[ahead - 1];
    final after = keysAscending[ahead];
    return before + (after - before) / 2;
  }
}
