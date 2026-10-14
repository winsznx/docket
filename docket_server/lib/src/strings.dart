import 'generated/protocol.dart';

/// Every patient-facing and desk-facing server string, in one place
/// (PRD 14.1). Clinic names, labels and numbers always come from data.
abstract final class Copy {
  static String ordinal(int n) {
    final mod100 = n % 100;
    if (mod100 >= 11 && mod100 <= 13) return '${n}th';
    return switch (n % 10) {
      1 => '${n}st',
      2 => '${n}nd',
      3 => '${n}rd',
      _ => '${n}th',
    };
  }

  static String minutesWords(int seconds) {
    final m = (seconds / 60).ceil();
    return m == 1 ? '1 minute' : '$m minutes';
  }

  static String minShort(int seconds) => '${(seconds / 60).ceil()} min';

  static String smsJoined(String label, String clinic, String link) =>
      "Docket: you're $label at $clinic. Track your place: $link";

  static String headsUp(String label, int position, String etaText) =>
      "$label: you're ${ordinal(position)} in line, $etaText. "
      'Start heading back.';

  static String called(String label, String room, int graceSeconds) =>
      "$label: it's your turn. Go to $room and tap to confirm within "
      '${minShort(graceSeconds)}.';

  static String calledSms(
    String label,
    String room,
    int graceSeconds,
    String link,
  ) =>
      "$label: it's your turn. Go to $room and tap to confirm within "
      '${minShort(graceSeconds)}: $link';

  static String graceReminder(String label, String room, int seconds) =>
      '$label: ${minutesWords(seconds)} left to confirm for $room.';

  static String reslotted(String label, int position) =>
      "$label: you missed your call, so you're back in line, "
      '${ordinal(position)} from the front.';

  static String expired(String label, int misses) =>
      '$label expired after ${_missWords(misses)}. Please see the desk.';

  static String _missWords(int misses) => switch (misses) {
    1 => 'a missed call',
    2 => 'two missed calls',
    3 => 'three missed calls',
    4 => 'four missed calls',
    _ => '$misses missed calls',
  };

  static String dayClosed(String clinic, String label) =>
      '$clinic has closed for today. Ticket $label is closed.';

  static String transferred(String lineName, String label, String link) =>
      'Next stop: $lineName, ticket $label. Track it: $link';

  static String pushTitle(NotificationKind kind, String label) =>
      switch (kind) {
        NotificationKind.joined => "You're in line",
        NotificationKind.headsUp => 'Start heading back',
        NotificationKind.called => "It's your turn",
        NotificationKind.graceReminder => "Confirm you're coming",
        NotificationKind.reslotted => 'You missed your call',
        NotificationKind.expired => 'Ticket expired',
        NotificationKind.dayClosed => 'Closed for today',
        NotificationKind.transferred => 'Next stop',
      };

  // Refusals, shown to people verbatim.
  static const clinicNotFound =
      "There's no clinic at that link. Check the code at the desk.";
  static String lineNotAccepting(String line) =>
      '$line has stopped taking new patients for today.';
  static String dayClosedJoin(String clinic) =>
      '$clinic has closed for today. Please come back tomorrow.';
  static String notOpenYet(String clinic, String openTime) =>
      '$clinic opens at $openTime. Joining starts then.';
  static String cutoffPassed(String clinic, String cutoff) =>
      '$clinic stopped taking new patients at $cutoff.';
  static const ticketNotFound =
      "That ticket link doesn't work. It may have been replaced at the desk.";
  static String invalidTransition(String label, TicketState state) =>
      switch (state) {
        TicketState.cancelled => '$label had already left the line.',
        TicketState.removed => '$label was already removed.',
        TicketState.served => '$label has already been seen.',
        TicketState.expired => '$label had already expired.',
        TicketState.closed => '$label was closed with the day.',
        TicketState.transferred => '$label was already transferred.',
        TicketState.waiting => '$label is waiting and hasn\'t been called.',
        TicketState.called =>
          '$label has been called and is waiting to confirm.',
        TicketState.confirmed => '$label is on the way to the room.',
        TicketState.inService => '$label is already being seen.',
      };
  static const noOneWaiting = 'No one is waiting.';
  static String roomNotOpen(String room) =>
      '$room is on a break or closed. Open it to call.';
  static const notStaff =
      "You're not on this clinic's staff. Ask the owner for an invite.";
  static const notOwner = 'Only the clinic owner can do that.';
  static const rateLimited = 'Too many tries. Wait a minute and try again.';
  static const sandboxExpired =
      'This sandbox has expired. Start a new one from the try page.';
  static const inviteInvalid =
      'That invite link has expired or was already used. Ask for a new one.';
  static const smsDisabled = "This clinic doesn't send texts.";
  static const pushInvalid =
      "This browser's alert subscription wasn't accepted. Try Get alerts again.";
  static const sandboxFull =
      'This sandbox holds 200 tickets at most. Start a fresh one to keep going.';
  static const clinicFull =
      'This clinic has reached 2,000 joins today. Please see the desk.';
  static const phoneInvalid =
      "That phone number doesn't look right. Use a number like 0803 123 4567.";
  static const consentNeeded = 'Tick the box to get texts first.';
  static const dayClosedDesk = 'The day is closed. Calls start again tomorrow.';
  static const reasonNeeded = 'Pick a reason first.';
  static const lastOwner = "You can't remove the last owner.";
}
