/// Copy for the patient's join page and live ticket (PRD 17.1, 17.2, 14.3).
/// Labels, rooms, lines and clinic names always come from the server.
abstract final class PatientStrings {
  // Shared by both screens.
  static const wordmark = 'Docket';
  static const goHome = 'Go to the home page';
  static const networkError =
      "Couldn't reach the clinic. Check your connection and try again.";
  static const retry = 'Try again';
  static const loadingClinic = 'Loading the clinic';
  static const loadingTicket = 'Loading your ticket';

  static String ordinal(int n) {
    final lastTwo = n % 100;
    if (lastTwo >= 11 && lastTwo <= 13) return '${n}th';
    return switch (n % 10) {
      1 => '${n}st',
      2 => '${n}nd',
      3 => '${n}rd',
      _ => '${n}th',
    };
  }

  /// The server's ETA text as its own sentence, "About 14 min.".
  static String etaSentence(String etaText) {
    final capital = etaForNewJoin(etaText);
    return capital.isEmpty ? capital : '$capital.';
  }

  /// The server's ETA text with a capital, "About 8 min, early estimate".
  static String etaForNewJoin(String etaText) {
    final trimmed = etaText.trim();
    if (trimmed.isEmpty) return trimmed;
    return '${trimmed[0].toUpperCase()}${trimmed.substring(1)}';
  }

  // Join page, PRD 17.1.
  static const sandboxNote =
      "This is a sandbox clinic for trying Docket. It's deleted after 24 hours.";
  static const openNow = 'Open now and taking patients.';
  static const noLineOpen = 'No line is taking new patients right now.';
  static const pickLine = 'Pick a line';
  static const pickLineFirst = 'Pick a line to join first.';
  static String waitingCount(int count) =>
      count == 0 ? 'No one waiting' : '$count waiting';
  static const lineClosed = 'Not taking new patients today';
  static const nameLabel = 'Initials or first name';
  static const nameHelper = 'Optional';
  static const phoneLabel = 'Phone number';
  static const phoneHint = '0803 123 4567';
  static const smsConsent = "Text me when it's my turn";
  static const phoneMissing = 'Add your phone number to get texts.';
  static const join = 'Join the line';
  static const joining = 'Joining the line';
  static const privacy =
      'Docket keeps your initials and, if you choose, your phone number to '
      'alert you. Both are deleted the day after your visit.';
  static String alreadyInLine(String label, String line) =>
      'You already have $label in $line.';
  static String openTicket(String label) => 'Open $label';

  // Ticket headlines and supporting copy, PRD 17.2.
  static String inLine(int position, String line) =>
      "You're ${ordinal(position)} in line for $line.";
  static String inLineNoPosition(String line) => "You're in line for $line.";
  static const headsUp = 'Start heading back';
  static String nextAfter(String label) => "You're next after $label.";
  static const nextUp = "You're next.";
  static const missedCall = 'You missed your call';
  static String backInLine(int position) =>
      "You're back in line, ${ordinal(position)} from the front.";
  static const backInLineNoPosition = "You're back in line.";
  static String missesLeft(int missesBeforeExpiry) =>
      switch (missesBeforeExpiry) {
        1 => 'One more miss and the ticket expires.',
        2 => 'Two more misses and the ticket expires.',
        3 => 'Three more misses and the ticket expires.',
        4 => 'Four more misses and the ticket expires.',
        _ => '$missesBeforeExpiry more misses and the ticket expires.',
      };
  static const comingWhenCalled = "When you're called, tap I'm coming.";
  static String yourTurn(String? room) =>
      room == null ? 'Your turn.' : 'Your turn. Go to $room.';
  static String expecting(String? room) =>
      room == null ? 'The room is expecting you' : '$room is expecting you';
  static String beingSeen(String? room) =>
      room == null ? "You're being seen now" : "You're being seen in $room";
  static const served = 'Done. Thanks for waiting with Docket.';
  static String nextStop(String? line, String? label) => switch ((
    line,
    label,
  )) {
    (final String l, final String t) => 'Next stop: $l, $t',
    (final String l, null) => 'Next stop: $l',
    _ => 'Next stop',
  };
  static const openingNextTicket = 'Opening your new ticket.';
  static String openNextTicket(String? label) =>
      label == null ? 'Open the new ticket' : 'Open $label';
  static const expired = 'This ticket expired';
  static String expiredAfter(int misses) => switch (misses) {
    1 => 'It missed its call. Please see the desk.',
    2 => 'It missed two calls. Please see the desk.',
    3 => 'It missed three calls. Please see the desk.',
    4 => 'It missed four calls. Please see the desk.',
    _ => 'It missed $misses calls. Please see the desk.',
  };
  static const cancelled = 'You left the line';
  static const cancelledDetail =
      'This ticket is closed. To join again, scan the code at the desk.';
  static const removed = 'The desk took this ticket out of the line';
  static String removedReason(String reason) => "The desk's reason: $reason";
  static const removedDetail = 'If that looks wrong, please see the desk.';
  static const closed = 'Closed for today';
  static String closedDetail(String clinic, String label) =>
      '$clinic has closed for today. Ticket $label is closed.';
  static String ticketContext(String line, String clinic) => '$line at $clinic';

  // The cause-and-effect strip, one fact per line.
  static const lineMovedJustNow = 'Line moved just now';
  static String lineMovedSeconds(int seconds) => 'Line moved $seconds s ago';
  static String lineMovedMinutes(int minutes) => 'Line moved $minutes min ago';
  static const lineMovedLongAgo = 'Line moved over an hour ago';
  static const lineNotMoved = "Line hasn't moved yet";
  static String nowServing(String label) => 'Now serving $label';
  static String roomIsSeeing(String room, String label) =>
      '$room is seeing $label';
  static String positionWhenCalled(int position, String label) =>
      "You're ${ordinal(position)} when $label is called";
  static const nextToBeCalled = "You're next to be called";
  static String positionAndEta(int position, String? etaText) => etaText == null
      ? "You're ${ordinal(position)} in line"
      : "You're ${ordinal(position)} in line, $etaText";

  // Countdowns, digits drawn from server time.
  static const toConfirm = ' to confirm';
  static const toArrive = ' to reach the room';

  // Connection, PRD 5.5.
  static String reconnecting(String time) => 'Reconnecting, last update $time';
  static const deskOffline =
      'No desk is calling this line right now. Your place is safe.';

  // Actions.
  static const confirm = "I'm coming";
  static const confirming = 'Telling the room';
  static const leave = 'Leave line';
  static const leaveTitle = 'Leave the line?';
  static String leaveBody(String label) =>
      "You'll give up $label and your place. If you join again, you start at "
      'the back.';
  static const leaveConfirm = 'Leave the line';
  static const leaveKeep = 'Stay in line';
  static const linkWarning =
      'Anyone with this link can see and cancel this ticket.';

  // Alerts, PRD 14.3 and 17.2.
  static const getAlerts = 'Get alerts';
  static const gettingAlerts = 'Turning on alerts';
  static const alertsOn = 'Alerts on';
  static const alertsByPush = 'Notifications in this browser';
  static String alertsBySms(String last4) =>
      'Texts to the number ending $last4';
  static const alertsBySmsNoNumber = 'Texts to your phone';
  static const turnOffAlerts = 'Turn off alerts';
  static const turningOffAlerts = 'Turning off alerts';
  static const installTitle = 'Add to Home Screen to get alerts';
  static const installIntro =
      'iPhone shows alerts only for web apps on the Home Screen. It takes '
      'three taps.';
  static const installSteps = [
    "Tap the Share button in Safari's toolbar, the square with an arrow "
        'pointing up.',
    'Scroll down and tap Add to Home Screen, then tap Add.',
    'Open Docket from your Home Screen and tap Get alerts there.',
  ];
  static const smsInstead = "Or get a text when it's your turn";
  static const smsTitle = "Get a text when it's your turn";
  static const smsTurnOn = 'Text me';
  static const smsTurningOn = 'Saving your number';
  static const getTextsInstead = 'Get texts instead';
  static const close = 'Close';
  static const pushDenied =
      'Alerts are blocked for this site. Allow notifications for it in your '
      'browser settings, then tap Get alerts again.';
  static const pushDismissed =
      'Alerts stay off until you allow notifications. Tap Get alerts to '
      'try again.';
  static const pushUnsupported =
      "This browser can't show alerts. Keep this page open, or open the link "
      'in Chrome, Firefox or Edge.';
  static const pushInsecure =
      'Alerts need the secure https link to this ticket.';
  static const pushNotConfigured =
      "This clinic's server can't send alerts yet.";
  static const pushFailed =
      "The browser didn't finish turning on alerts. Tap Get alerts to try "
      'again.';
}
