import 'dart:ui' show Size;

import 'package:docket_client/docket_client.dart';

import '../../shared/strings.dart';

final _labelPattern = RegExp(r'^([A-Z])-(\d+)$');

/// How a label is read aloud: the code letter, then the number without its
/// leading zeros, so `C-031` becomes "C 31" (PRD 4.4). Returns null for a
/// label the server hasn't numbered yet, such as `C-?` on an offline desk.
String? spokenLabel(String label) {
  final match = _labelPattern.firstMatch(label.trim());
  if (match == null) return null;
  return '${match.group(1)} ${int.parse(match.group(2)!)}';
}

/// The sentence the board says for one call, such as
/// "C 31, please go to Room 2". Null when the label can't be read aloud.
String? speechFor(BoardCall call) {
  final spoken = spokenLabel(call.label);
  if (spoken == null) return null;
  return BoardStrings.speech(spoken, call.roomName);
}

/// One call, told apart from a later call of the same ticket by its call
/// version and call time.
String callKey(BoardCall call) =>
    '${call.label}|${call.callVersion}|${call.calledAt.toUtc().toIso8601String()}';

/// Finds the calls in each view that the board hasn't announced yet.
///
/// The first view only records what's already on screen, so opening the
/// board never replays the morning. A call older than [freshFor] is shown
/// but not announced. A call made at an offline desk is announced from the
/// desk's database, then reaches the server on sync with a new call time, so
/// a server call for a label already said from the desk within [freshFor]
/// stays quiet.
class CallTracker {
  CallTracker({this.freshFor = const Duration(minutes: 2)});

  final Duration freshFor;

  static const _keepKeys = 200;

  final _seen = <String>{};
  final _saidFromDesk = <String, DateTime>{};
  bool _seeded = false;

  /// Returns the new calls in [calls] that should be announced, oldest
  /// first. [calls] is newest first, as the server sends it. [now] is in the
  /// same clock as the calls' `calledAt`, and [deviceNow] is this device's
  /// clock, which stays the same whichever source the calls came from.
  List<BoardCall> observe(
    List<BoardCall> calls, {
    required bool local,
    required DateTime now,
    required DateTime deviceNow,
  }) {
    if (!_seeded) {
      _seeded = true;
      _seen.addAll(calls.map(callKey));
      return const [];
    }
    final fresh = <BoardCall>[];
    for (final call in calls.reversed) {
      if (!_seen.add(callKey(call))) continue;
      if (now.difference(call.calledAt) > freshFor) continue;
      if (local) {
        _saidFromDesk[call.label] = deviceNow;
      } else {
        final said = _saidFromDesk[call.label];
        if (said != null && deviceNow.difference(said) < freshFor) continue;
      }
      fresh.add(call);
    }
    _prune(calls);
    return fresh;
  }

  void _prune(List<BoardCall> current) {
    if (_seen.length <= _keepKeys) return;
    _seen
      ..clear()
      ..addAll(current.map(callKey));
  }
}

const _activeInRoom = {
  TicketState.called,
  TicketState.confirmed,
  TicketState.inService,
};

/// Builds the board from the desk's local database, for when the board's own
/// stream is down (PRD 15.5). Room and line names come from the desk's last
/// [DeskView], and the calls from its `LocalTicket` rows.
BoardView localBoardView({
  required DeskView desk,
  required List<LocalTicket> tickets,
  required DateTime now,
  int recentLimit = 5,
}) {
  final roomNames = {for (final r in desk.rooms) r.id: r.name};

  final inRoom = <UuidValue, LocalTicket>{};
  for (final t in tickets) {
    final room = t.roomId;
    if (room == null || !_activeInRoom.contains(t.state)) continue;
    final current = inRoom[room];
    if (current == null || _calledLater(t, current)) inRoom[room] = t;
  }

  final called =
      tickets
          .where((t) => t.calledAt != null && roomNames.containsKey(t.roomId))
          .toList()
        ..sort((a, b) => b.calledAt!.compareTo(a.calledAt!));

  return BoardView(
    clinicName: desk.clinicName,
    rooms: [
      for (final r in desk.rooms)
        BoardRoom(
          roomName: r.name,
          state: r.state,
          nowServingLabel: inRoom[r.id]?.label,
        ),
    ],
    recentCalls: [
      for (final t in called.take(recentLimit))
        BoardCall(
          label: t.label,
          roomName: roomNames[t.roomId]!,
          calledAt: t.calledAt!,
          callVersion: t.callVersion,
        ),
    ],
    waitingByLine: {
      for (final line in desk.lines)
        line.name: tickets
            .where(
              (t) => t.lineId == line.id && t.state == TicketState.waiting,
            )
            .length,
    },
    joinUrl: desk.joinUrl,
    serverTime: now,
  );
}

bool _calledLater(LocalTicket a, LocalTicket b) {
  final at = a.calledAt;
  final bt = b.calledAt;
  if (at == null) return false;
  if (bt == null) return true;
  return at.isAfter(bt);
}

/// The clinic slug a board view belongs to, read from its join link.
String? slugOfJoinUrl(String joinUrl) {
  final segments = Uri.tryParse(joinUrl)?.pathSegments ?? const <String>[];
  final j = segments.indexOf('j');
  if (j < 0 || j + 1 >= segments.length) return null;
  return segments[j + 1];
}

/// Sizes for one 16:9 board frame, measured from its height so the label is
/// readable across a room (DESIGN.md 5.5). Every length is a share of the
/// frame height, so the board looks the same on a 720p and a 4K screen.
class BoardMetrics {
  const BoardMetrics._({
    required this.frame,
    required this.labelSize,
    required this.roomsPerRow,
    required this.rows,
  });

  /// The label is at least this share of the frame height whenever the
  /// rooms can fit, and at most [maxLabelShare].
  static const minLabelShare = 0.18;
  static const maxLabelShare = 0.2;

  /// The 16:9 frame that fits the viewport, with the board laid out inside.
  final Size frame;
  final double labelSize;
  final int roomsPerRow;
  final int rows;

  double get unit => frame.height / 100;
  double get gutter => unit * 3;
  double get top => unit * 2.5;
  double get headerGap => unit * 2.5;
  double get footerGap => unit * 3;
  double get columnGap => unit * 2.4;
  double get rowGap => unit * 2;
  double get columnPadding => unit * 1.6;
  double get roomNameSize => unit * (rows > 1 ? 3.6 : 4.4);
  double get nameGap => unit * 1.2;
  double get footerHeight => unit * (rows > 1 ? 24 : 30);

  /// [labelWidth] measures the widest label at a font size, so the choice
  /// follows the real font rather than a guess.
  factory BoardMetrics.of(
    Size viewport,
    int roomCount,
    double Function(double fontSize) labelWidth,
  ) {
    final height = viewport.height < viewport.width * 9 / 16
        ? viewport.height
        : viewport.width * 9 / 16;
    final frame = Size(height * 16 / 9, height);
    final u = height / 100;
    final rooms = roomCount < 1 ? 1 : roomCount;
    const probe = 100.0;
    final perEm = labelWidth(probe) / probe;

    double fits(int perRow) {
      final rows = (rooms / perRow).ceil();
      final usable = frame.width - 2 * (3 - 1.6) * u;
      final column = (usable - (perRow - 1) * 2.4 * u) / perRow - 2 * 1.6 * u;
      final across = perEm <= 0 ? double.infinity : column / perEm;
      final footer = (rows > 1 ? 24 : 30) * u;
      final area = height - 2.5 * u - 6 * u - 2.5 * u - 3 * u - 3 * u - footer;
      final perRowHeight = (area - (rows - 1) * 2 * u) / rows;
      final name = (rows > 1 ? 3.6 : 4.4) * u * 1.2;
      final down = (perRowHeight - 2 * 1.6 * u - name - 1.2 * u) / 0.95;
      final best = [across, down, height * maxLabelShare].reduce(
        (a, b) => a < b ? a : b,
      );
      return best;
    }

    var chosen = rooms;
    var size = fits(rooms);
    for (var perRow = rooms; perRow >= 1; perRow--) {
      final candidate = fits(perRow);
      if (candidate >= height * minLabelShare) {
        chosen = perRow;
        size = candidate;
        break;
      }
      if (candidate > size) {
        chosen = perRow;
        size = candidate;
      }
    }
    return BoardMetrics._(
      frame: frame,
      labelSize: size,
      roomsPerRow: chosen,
      rows: (rooms / chosen).ceil(),
    );
  }
}
