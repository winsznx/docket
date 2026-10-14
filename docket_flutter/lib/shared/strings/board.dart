/// Copy for the waiting-room board, `/b/<token>` (PRD 17.4).
abstract final class BoardStrings {
  static const tapToTurnOn = 'Tap anywhere to turn on announcements';
  static const localMode = 'Local mode';
  static const localModeHint =
      "Showing calls from this computer's desk while the connection is down.";
  static const onBreak = 'On a short break';
  static const closed = 'Closed';
  static const open = 'Open';
  static const recentCalls = 'Recent calls';
  static const noCallsYet = 'No calls yet today';
  static const waiting = 'Waiting';
  static const scanToJoin = 'Scan to join. No app needed.';
  static const joinQr = 'QR code to join the line';
  static const loading = 'Loading the board';
  static const reconnecting = 'Reconnecting';
  static String reconnectingSince(String time) =>
      'Reconnecting. Last update $time';

  static const settings = 'Settings';
  static const settingsTitle = 'Board settings';
  static const sayAloud = 'Say each call aloud';
  static const voiceUnavailable = "Voice isn't available in this browser";
  static const voiceChecking = 'Checking for a voice in this browser';
  static const playChime = 'Play a chime before each call';
  static const testSound = 'Test the sound';
  static const testSpeech = 'Announcements are on.';
  static const fullScreen = 'Full screen';
  static const leaveFullScreen = 'Leave full screen';
  static const done = 'Done';

  /// What the board says aloud, such as "C 31, please go to Room 2".
  static String speech(String spokenLabel, String roomName) =>
      roomName.isEmpty ? spokenLabel : '$spokenLabel, please go to $roomName';

  /// What a screen reader hears when a call lands on the board.
  static String callAnnouncement(String label, String roomName) =>
      roomName.isEmpty ? label : '$label, $roomName';

  static String roomNowCalling(String roomName, String label) =>
      '$roomName, now calling $label';
  static String waitingFor(int count, String lineName) =>
      '$count waiting for $lineName';
  static String calledTo(String label, String roomName) =>
      '$label called to $roomName';
}
