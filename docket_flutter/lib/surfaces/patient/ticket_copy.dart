import 'dart:math' as math;

import 'package:docket_client/docket_client.dart';

import '../../shared/server_clock.dart';
import '../../shared/strings/patient.dart';

/// The rows of the PRD 17.2 state table. Waiting splits three ways, since a
/// heads-up and a re-slot each change what the ticket says.
enum TicketPhase {
  waiting,
  headsUp,
  reslotted,
  called,
  confirmed,
  inService,
  served,
  transferred,
  expired,
  cancelled,
  removed,
  closed;

  bool get isWaiting => this == waiting || this == headsUp || this == reslotted;

  /// The ticket still holds a place, so the desk's connection matters.
  bool get isActive => isWaiting || this == called || this == confirmed;
}

TicketPhase phaseOf(PatientView view) => switch (view.state) {
  TicketState.waiting when view.headsUpSent => TicketPhase.headsUp,
  TicketState.waiting when view.reslotCount > 0 => TicketPhase.reslotted,
  TicketState.waiting => TicketPhase.waiting,
  TicketState.called => TicketPhase.called,
  TicketState.confirmed => TicketPhase.confirmed,
  TicketState.inService => TicketPhase.inService,
  TicketState.served => TicketPhase.served,
  TicketState.transferred => TicketPhase.transferred,
  TicketState.expired => TicketPhase.expired,
  TicketState.cancelled => TicketPhase.cancelled,
  TicketState.removed => TicketPhase.removed,
  TicketState.closed => TicketPhase.closed,
};

enum TicketAction { getAlerts, confirm, leave }

enum CountdownKind { grace, arrival }

/// A live countdown, drawn from server time.
@immutable
class TicketCountdown {
  const TicketCountdown(this.kind, this.endsAt);

  final CountdownKind kind;
  final DateTime endsAt;

  String get suffix => switch (kind) {
    CountdownKind.grace => PatientStrings.toConfirm,
    CountdownKind.arrival => PatientStrings.toArrive,
  };

  /// "2:41", never negative.
  String digits(ServerClock clock) =>
      ServerClock.mmss(clock.secondsUntil(endsAt));
}

/// Everything the ticket says in one state.
@immutable
class TicketCopy {
  const TicketCopy({
    required this.headline,
    this.headlinePosition,
    this.supporting,
    this.strip = const [],
    this.countdown,
    this.note,
    this.actions = const {},
  });

  final String headline;

  /// The position inside [headline], which rolls to its new value.
  final int? headlinePosition;
  final String? supporting;

  /// The cause-and-effect strip, at most three facts, one per line.
  final List<String> strip;
  final TicketCountdown? countdown;

  /// A line beside the actions, such as what to do when called next.
  final String? note;
  final Set<TicketAction> actions;

  /// What a screen reader hears when this copy first shows.
  String announcement(String label, {String? countdownText}) => [
    label,
    headline,
    ?supporting,
    ?countdownText,
  ].map(_sentence).join(' ');

  static String _sentence(String text) => text.endsWith('.') ? text : '$text.';
}

/// Maps a view onto the PRD 17.2 table. [now] is the server's time, for the
/// strip's "Line moved 40 s ago".
TicketCopy ticketCopy(PatientView view, {required DateTime now}) {
  final position = view.position;
  return switch (phaseOf(view)) {
    TicketPhase.waiting => TicketCopy(
      headline: position == null
          ? PatientStrings.inLineNoPosition(view.lineName)
          : PatientStrings.inLine(position, view.lineName),
      headlinePosition: position,
      supporting: view.etaText == null
          ? null
          : PatientStrings.etaSentence(view.etaText!),
      strip: waitingStrip(view, now: now),
      actions: const {TicketAction.getAlerts, TicketAction.leave},
    ),
    // A re-slot near the front of a short line brings the heads-up at once,
    // so the heads-up still carries the warning about the next miss.
    TicketPhase.headsUp => TicketCopy(
      headline: PatientStrings.headsUp,
      supporting: [
        view.nextAfterLabel == null
            ? PatientStrings.nextUp
            : PatientStrings.nextAfter(view.nextAfterLabel!),
        if (view.reslotCount > 0)
          PatientStrings.missesLeft(missesBeforeExpiry(view)),
      ].join(' '),
      strip: headsUpStrip(view, now: now),
      actions: const {TicketAction.getAlerts, TicketAction.leave},
    ),
    TicketPhase.reslotted => TicketCopy(
      headline: PatientStrings.missedCall,
      supporting: [
        position == null
            ? PatientStrings.backInLineNoPosition
            : PatientStrings.backInLine(position),
        PatientStrings.missesLeft(missesBeforeExpiry(view)),
      ].join(' '),
      strip: waitingStrip(view, now: now),
      note: PatientStrings.comingWhenCalled,
      actions: const {TicketAction.getAlerts, TicketAction.leave},
    ),
    TicketPhase.called => TicketCopy(
      headline: PatientStrings.yourTurn(view.roomName),
      countdown: view.graceEndsAt == null
          ? null
          : TicketCountdown(CountdownKind.grace, view.graceEndsAt!),
      actions: const {TicketAction.confirm},
    ),
    TicketPhase.confirmed => TicketCopy(
      headline: PatientStrings.expecting(view.roomName),
      countdown: view.arrivalEndsAt == null
          ? null
          : TicketCountdown(CountdownKind.arrival, view.arrivalEndsAt!),
      actions: const {TicketAction.leave},
    ),
    TicketPhase.inService => TicketCopy(
      headline: PatientStrings.beingSeen(view.roomName),
    ),
    TicketPhase.served => const TicketCopy(headline: PatientStrings.served),
    TicketPhase.transferred => TicketCopy(
      headline: PatientStrings.nextStop(
        view.transferredToLineName,
        view.transferredToLabel,
      ),
      supporting: view.transferredToToken == null
          ? null
          : PatientStrings.openingNextTicket,
    ),
    TicketPhase.expired => TicketCopy(
      headline: PatientStrings.expired,
      supporting: PatientStrings.expiredAfter(view.reslotCount + 1),
    ),
    TicketPhase.cancelled => const TicketCopy(
      headline: PatientStrings.cancelled,
      supporting: PatientStrings.cancelledDetail,
    ),
    TicketPhase.removed => TicketCopy(
      headline: PatientStrings.removed,
      supporting: PatientStrings.removedDetail,
      strip: [
        if (_hasText(view.closedReason))
          PatientStrings.removedReason(view.closedReason!.trim()),
      ],
    ),
    TicketPhase.closed => TicketCopy(
      headline: PatientStrings.closed,
      supporting: PatientStrings.closedDetail(view.clinicName, view.label),
    ),
  };
}

/// Misses left before the ticket expires, counting the one that expires it.
int missesBeforeExpiry(PatientView view) =>
    math.max(0, view.maxReslots - view.reslotCount) + 1;

/// What just happened, who's being seen and what happens next.
List<String> waitingStrip(PatientView view, {required DateTime now}) {
  final position = view.position;
  return [
    lineMovedText(view.lineMovedAt, now: now),
    ?_nowServing(view),
    if (position == 1)
      PatientStrings.nextToBeCalled
    else if (position != null && view.nextAfterLabel != null)
      PatientStrings.positionWhenCalled(position - 1, view.nextAfterLabel!),
  ];
}

/// The heads-up headline already says who's ahead, so the last line gives
/// the place and the time instead.
List<String> headsUpStrip(PatientView view, {required DateTime now}) => [
  lineMovedText(view.lineMovedAt, now: now),
  ?_nowServing(view),
  if (view.position != null)
    PatientStrings.positionAndEta(view.position!, view.etaText),
];

String? _nowServing(PatientView view) {
  final serving = view.nowServingLabel;
  if (!_hasText(serving) || serving == view.label) return null;
  final room = view.nowServingRoomName;
  return _hasText(room)
      ? PatientStrings.roomIsSeeing(room!, serving!)
      : PatientStrings.nowServing(serving!);
}

/// "Line moved 40 s ago", in steps of five seconds so it doesn't flicker.
String lineMovedText(DateTime? movedAt, {required DateTime now}) {
  if (movedAt == null) return PatientStrings.lineNotMoved;
  final seconds = now.toUtc().difference(movedAt.toUtc()).inSeconds;
  if (seconds < 10) return PatientStrings.lineMovedJustNow;
  if (seconds < 60) return PatientStrings.lineMovedSeconds(seconds ~/ 5 * 5);
  if (seconds < 3600) return PatientStrings.lineMovedMinutes(seconds ~/ 60);
  return PatientStrings.lineMovedLongAgo;
}

/// The time of the last update as the phone's clock shows it, "10:42:03".
String clockTime(DateTime time) {
  final local = time.toLocal();
  String two(int n) => n.toString().padLeft(2, '0');
  return '${two(local.hour)}:${two(local.minute)}:${two(local.second)}';
}

bool _hasText(String? value) => value != null && value.trim().isNotEmpty;
