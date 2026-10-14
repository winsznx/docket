import 'package:docket_client/docket_client.dart' hide Notification;

import 'offline/local_rules.dart';

/// Why Call next can't run right now. The button shows the reason as its
/// label (PRD 17.3).
enum CallNextBlock { dayClosed, roomPaused, roomClosed, noOneWaiting }

/// The first reason Call next is blocked, or null when it can run. A day
/// that hasn't started yet opens with the first call (PRD 5.3).
CallNextBlock? callNextBlockFor({
  required DayState? day,
  required RoomState roomState,
  required int waiting,
}) {
  if (day == DayState.closed) return CallNextBlock.dayClosed;
  if (roomState == RoomState.paused) return CallNextBlock.roomPaused;
  if (roomState == RoomState.closed) return CallNextBlock.roomClosed;
  if (waiting == 0) return CallNextBlock.noOneWaiting;
  return null;
}

/// One ticket as the desk shows it: the local mirror decides its state and
/// order, and the last server view adds the details the mirror doesn't keep.
class DeskTicket {
  const DeskTicket(this.local, this.server);

  final LocalTicket local;

  /// The same ticket in the last server view, if the server knows it.
  final TicketView? server;

  UuidValue get id => local.id!;
  String get label => local.label;
  String get displayName => local.displayName;
  TicketState get state => local.state;
  UuidValue get lineId => local.lineId;
  bool get pending => local.pendingSync;
  bool get isDemo => local.isDemo;
  bool get reslotted => local.reslotCount > 0;
  PriorityReason? get priorityReason => local.priorityReason;
  String? get priorityNote => server?.priorityNote;
  bool get alertsOn => (server?.hasPush ?? false) || (server?.hasSms ?? false);

  /// True once the server has numbered the ticket, so it can get a QR.
  bool get known => server != null;

  /// Server details that describe the state the desk shows. A change still
  /// waiting to sync has none, so no countdown runs for it.
  TicketView? get _current =>
      !pending && server?.state == local.state ? server : null;

  DateTime? get graceEndsAt => _current?.graceEndsAt;
  DateTime? get arrivalEndsAt => _current?.arrivalEndsAt;
  DeliveryStatus? get pushStatus => _current?.pushStatus;
  DeliveryStatus? get smsStatus => _current?.smsStatus;
}

class DeskRoom {
  const DeskRoom(this.view, this.state);

  final RoomView view;

  /// The room's state with any change still waiting to sync applied.
  final RoomState state;

  UuidValue get id => view.id;
  String get name => view.name;
  UuidValue get lineId => view.lineId;
}

class DeskLine {
  const DeskLine(this.view, this.waiting);

  final LineView view;

  /// Waiting tickets in call order.
  final List<DeskTicket> waiting;

  UuidValue get id => view.id;
  String get name => view.name;
  String get code => view.code;
  int get servedToday => view.servedToday;
}

/// Everything the desk screen draws, composed from the last server view,
/// the local mirror and the outbox (PRD 15).
class DeskBoard {
  DeskBoard._({
    required this.view,
    required this.day,
    required this.rooms,
    required this.lines,
    required this.room,
    required this.inRoom,
    required Map<UuidValue, DeskTicket> tickets,
  }) : _byId = tickets;

  factory DeskBoard.compose({
    required DeskView view,
    required List<LocalTicket> tickets,
    required List<DeskAction> pending,
    required UuidValue? roomId,
  }) {
    final serverTickets = {
      for (final line in view.lines)
        for (final t in line.tickets) t.id: t,
    };
    final lineIds = {for (final line in view.lines) line.id};
    final all = {
      for (final t in tickets)
        if (lineIds.contains(t.lineId))
          t.id!: DeskTicket(t, serverTickets[t.id]),
    };

    final roomStates = {for (final r in view.rooms) r.id: r.state};
    var day = view.day;
    for (final action in pending) {
      switch (action) {
        case SetRoomStateAction(:final roomId, :final state):
          roomStates[roomId] = state;
        case CloseDayAction():
          day = DayState.closed;
        default:
          break;
      }
    }

    final rooms = [for (final r in view.rooms) DeskRoom(r, roomStates[r.id]!)];
    final lines = [
      for (final line in view.lines)
        DeskLine(line, [
          for (final t in LocalRules.eligible(
            all.values.map((d) => d.local),
            line.id,
          ))
            all[t.id]!,
        ]),
    ];
    final room = rooms.where((r) => r.id == roomId).firstOrNull;
    final inRoom =
        all.values
            .where(
              (t) =>
                  room != null &&
                  t.local.roomId == room.id &&
                  t.state != TicketState.waiting &&
                  LocalRules.isActive(t.state),
            )
            .toList()
          ..sort((a, b) {
            final at = a.local.calledAt;
            final bt = b.local.calledAt;
            if (at == null || bt == null) return at == null ? 1 : -1;
            return bt.compareTo(at);
          });

    return DeskBoard._(
      view: view,
      day: day,
      rooms: rooms,
      lines: lines,
      room: room,
      inRoom: inRoom,
      tickets: all,
    );
  }

  final DeskView view;
  final DayState? day;
  final List<DeskRoom> rooms;
  final List<DeskLine> lines;

  /// The room this desk calls for, once one is picked.
  final DeskRoom? room;

  /// Tickets called to this room and not finished, the latest call first.
  final List<DeskTicket> inRoom;

  final Map<UuidValue, DeskTicket> _byId;

  DeskTicket? ticket(UuidValue id) => _byId[id];

  DeskTicket? get nowServing => inRoom.firstOrNull;

  DeskLine? get roomLine => room == null ? null : line(room!.lineId);

  DeskLine? line(UuidValue id) => lines.where((l) => l.id == id).firstOrNull;

  DeskRoom? roomById(UuidValue id) =>
      rooms.where((r) => r.id == id).firstOrNull;

  List<DeskLine> get otherLines =>
      lines.where((l) => l.id != room?.lineId).toList();

  CallNextBlock? get callNextBlock => room == null
      ? CallNextBlock.noOneWaiting
      : callNextBlockFor(
          day: day,
          roomState: room!.state,
          waiting: roomLine?.waiting.length ?? 0,
        );
}
