/// Copy for the owner console, `/owner`, and the staff invite page,
/// `/invite/<code>` (PRD 17.5).
abstract final class OwnerStrings {
  // Signing in and picking a clinic.
  static const signInTitle = 'Set up and run your clinic';
  static const signInLead =
      "Sign in with your email, or create an account. We'll send a code to "
      'confirm the address.';
  static const openSandbox = 'Open my sandbox clinic';
  static const sandboxNote =
      "This is your sandbox clinic. It's deleted 24 hours after you made it.";
  static const signInForReal = 'Sign in to set up a real clinic';
  static const pickTitle = 'Your clinics';
  static const pickLead = 'Pick a clinic to manage, or set up a new one.';
  static const noClinicsYet = "You don't own a clinic yet. Set one up here.";
  static const setUpNew = 'Set up a new clinic';
  static String deskOnly(String clinic) =>
      "You're on the desk staff at $clinic.";
  static const openDesk = 'Open the desk';
  static const sandboxRowNote = 'Sandbox, deleted after 24 hours';
  static const switchClinic = 'Switch clinic';
  static const signOut = 'Sign out';
  static const loading = 'Loading';
  static const networkError =
      "Docket couldn't be reached. Check the connection and try again.";
  static const tryAgain = 'Try again';

  // Setup wizard.
  static String step(int n, int of) => 'Step $n of $of';
  static const wizardTitle = 'Set up your clinic';
  static const clinicStep = 'The clinic';
  static const hoursStep = 'Opening hours';
  static const linesStep = 'Lines';
  static const roomsStep = 'Rooms';
  static const reviewStep = 'Check and create';
  static const clinicName = 'Clinic name';
  static const clinicNameHint = 'Ikeja Family Clinic';
  static const slug = 'Link name';
  static String slugExplain(String origin, String slug) =>
      'Patients join at $origin/j/${slug.isEmpty ? 'your-clinic' : slug}';
  static const timezone = 'Timezone';
  static const timezoneExplain =
      'All times in Docket use this zone. Pick one below or type its name.';
  static const linesExplain =
      'A line is a queue patients join, such as Consultation, Lab or '
      'Pharmacy. Each has a one-letter code that starts its ticket numbers.';
  static const lineName = 'Line name';
  static const lineCode = 'Code';
  static const lineMinutes = 'Usual minutes per patient';
  static const lineMinutesExplain =
      'Seeds the wait estimate until the line has 3 real visits.';
  static const addLine = 'Add a line';
  static const removeLine = 'Remove this line';
  static const roomsExplain =
      'A room is where patients are seen. Each room calls from one line.';
  static const roomName = 'Room name';
  static const roomLine = 'Calls from';
  static const addRoom = 'Add a room';
  static const defaultLineName = 'Consultation';
  static const defaultLineCode = 'C';
  static String defaultRoomName(int n) => 'Room $n';
  static const removeRoom = 'Remove this room';
  static const hoursExplain =
      'Patients can join between opening and the last join time. The desk '
      'is asked to close the day at closing time.';
  static const next = 'Next';
  static const back = 'Back';
  static const create = 'Set up the clinic';
  static const creating = 'Setting up the clinic';
  static String reviewLine(String name, String code, int minutes) =>
      '$name, code $code, about $minutes min per patient';
  static String reviewRoom(String name, String line) =>
      '$name calls from $line';
  static String reviewHours(String open, String cutoff, String close) =>
      'Opens $open, last join $cutoff, closes $close';
  static const defaultsNote =
      'Every other setting starts at its default. You can change any of them '
      'later under Settings.';

  // Setup done.
  static String readyTitle(String clinic) => '$clinic is ready';
  static const readyLead =
      'The desk, the board, the posters and your first invite. You can find '
      'all of them again in the console.';
  static const deskLinkTitle = 'The desk';
  static const deskLinkExplain =
      'Your staff open this on the reception computer to call patients.';
  static const boardLinkTitle = 'The waiting-room board';
  static const boardLinkExplain =
      'Open this on a TV in the waiting room. It shows each call and says it '
      'aloud.';
  static const postersTitle = 'Posters';
  static const postersExplain =
      'An A4 page for each line with a QR code patients scan to join. Print '
      'one for the desk and one for the door.';
  static String openPoster(String line) => 'Open the $line poster';
  static const firstInviteTitle = 'Your first desk user';
  static const firstInviteExplain =
      'Send this link to the person at the desk. They sign in with it once.';
  static const createDeskInvite = 'Create a desk invite';
  static const openConsole = 'Open the console';

  // Shared link actions.
  static const copyLink = 'Copy link';
  static const openLink = 'Open';
  static const linkCopied = 'Link copied.';

  // Console header and sections.
  static const today = 'Today';
  static const settings = 'Settings';
  static const linesAndRooms = 'Lines and rooms';
  static const staff = 'Staff';
  static const posters = 'Posters';
  static const board = 'Board';
  static const reports = 'Reports';
  static const audit = 'Audit';
  static const sections = 'Console sections';
  static const dayOpen = 'Open today';
  static const dayClosed = 'Closed for today';
  static const dayNotOpened = 'Not opened yet today';

  // Today.
  static const waiting = 'waiting';
  static const served = 'served';
  static const medianWait = 'median wait';
  static const noWaitYet = 'None yet';
  static const takingPatients = 'Taking new patients';
  static const notTakingPatients = 'Not taking new patients';
  static String updatedAt(String time) => 'Updated $time';
  static const noLines =
      'This clinic has no lines yet. Add one under Lines '
      'and rooms.';

  // Settings.
  static const callingGroup = 'When a patient is called';
  static const headsUpGroup = 'Heads-up';
  static const missGroup = 'Missed calls';
  static const hoursGroup = 'Hours';
  static const textsGroup = 'Texts';
  static const graceLabel = 'Time to confirm';
  static const graceExplain =
      "How long a called patient has to tap I'm coming.";
  static const reminderLabel = 'Reminder before that time runs out';
  static const reminderExplain =
      "A push reminder goes out this long before the time to confirm ends.";
  static const arrivalLabel = 'Time to reach the room';
  static const arrivalExplain =
      'How long a patient has to get to the room after confirming.';
  static const headsUpPlaceLabel = 'Heads-up place';
  static const headsUpPlaceExplain =
      "Patients get a heads-up once they're this close to the front.";
  static const headsUpMinutesLabel = 'Heads-up minutes';
  static const headsUpMinutesExplain =
      'Or once their wait is down to this many minutes, whichever comes '
      'first.';
  static const reslotLabel = 'Places back after a miss';
  static const reslotExplain =
      'A patient who misses a call goes back this many places behind the '
      'front.';
  static const maxReslotsLabel = 'Misses allowed';
  static const maxReslotsExplain =
      'How many misses a ticket gets before it expires.';
  static const openLabel = 'Opens';
  static const openExplain = 'Patients can join from this time.';
  static const cutoffLabel = 'Last join';
  static const cutoffExplain = 'Joins are refused after this time.';
  static const closeLabel = 'Closes';
  static const closeExplain =
      'The desk is asked to close the day at this time.';
  static const autoCloseLabel = 'Auto close after';
  static const autoCloseExplain =
      'The day closes on its own this long after closing time. 0 turns it '
      'off.';
  static const timezoneLabel = 'Timezone';
  static const timezoneSettingExplain = 'All the times above are in this zone.';
  static const smsLabel = 'Text patients';
  static const smsExplain =
      'Patients who give a number get a text when their turn comes.';
  static const smsUnavailable =
      'Texts need Twilio set up on the server. Until then Docket uses push '
      'alerts only.';
  static const smsSandbox = "Sandboxes don't send texts.";
  static const saveSettings = 'Save settings';
  static const settingsSaved = 'Settings saved.';
  static const seconds = 'seconds';
  static const minutes = 'minutes';
  static const places = 'places';
  static const misses = 'misses';
  static String range(int min, int max, String unit) => '$min to $max $unit.';
  static const timeFormat = '24-hour time, like 08:00.';

  // Validation, matching the server's wording.
  static String between(String what, int min, int max) =>
      '$what has to be between $min and $max.';
  static const wholeNumber = 'Use a whole number.';
  static const timeInvalid = 'Use 24-hour times like 08:00.';
  static const hoursOrder =
      'Opening has to come before the last join, and that before closing.';
  static const timezoneInvalid = "That timezone isn't known.";
  static const nameMissing = 'Give the clinic a name.';
  static const slugInvalid =
      'Use 3 to 40 lowercase letters, numbers or hyphens for the link.';
  static const lineNameMissing = 'Give the line a name.';
  static const lineCodeInvalid = 'The line code is one capital letter.';
  static const lineCodesClash = 'Each line needs its own one-letter code.';
  static const serviceMinutesInvalid =
      'Usual time per patient has to be between 1 and 60 minutes.';
  static const roomNameMissing = 'Give the room a name.';
  static const roomLineMissing = 'Pick a line for the room to call from.';

  // Lines and rooms.
  static const linesTitle = 'Lines';
  static const roomsTitle = 'Rooms';
  static const saveLine = 'Save line';
  static const lineSaved = 'Line saved.';
  static const saveRoom = 'Save room';
  static const roomSaved = 'Room saved.';
  static const newLine = 'New line';
  static const newRoom = 'New room';
  static const cancel = 'Cancel';

  // Staff.
  static const inviteTitle = 'Invite someone';
  static const inviteExplain =
      'An invite link works once and runs out after 48 hours.';
  static const roleDesk = 'Desk';
  static const roleOwner = 'Owner';
  static const roleDeskExplain = 'Can run the desk.';
  static const roleOwnerExplain =
      'Can run the desk and change everything here.';
  static const createInvite = 'Create invite link';
  static String inviteExpires(String when) => 'Works once, until $when.';
  static String inviteFor(String role) => 'Invite for $role';
  static const staffList = 'People';
  static const noStaff = 'No one has joined yet. Send an invite above.';
  static const deactivate = 'Deactivate';
  static const deactivated = 'Deactivated';
  static String deactivateTitle(String name) => 'Deactivate $name?';
  static const deactivateBody =
      "They can't use the desk or this console until you invite them again.";
  static String wasDeactivated(String name) => '$name was deactivated.';
  static String deskAt(String url) => 'Your staff use the desk at $url';

  // Posters and board.
  static const postersLead =
      'Each poster is an A4 PDF with a large QR code to join that line and '
      'three steps in plain words.';
  static String posterFor(String line, String code) =>
      '$line poster, code $code';
  static const boardLead =
      'It shows each call and says it aloud. Open the link in a browser on '
      'the TV.';
  static const boardHidden =
      "The board link is only shown when it's made. Make a new one to see it "
      'here.';
  static const rotateBoard = 'Rotate the board link';
  static const rotateWarning =
      'The screen using the old link stops working. Open the new link on it.';
  static const rotateTitle = 'Make a new board link?';
  static const rotateConfirm = 'Make a new link';
  static const boardRotated = 'New board link made. The old one has stopped.';

  // Reports.
  static const reportDate = 'Date';
  static const changeDate = 'Change date';
  static const arrivalsTitle = 'Arrivals by hour';
  static String arrivalsSummary(int total, String? busiest, int? peak) =>
      busiest == null
      ? 'Arrivals by hour. No one joined on this day.'
      : 'Arrivals by hour. $total in all, busiest at $busiest with $peak.';
  static String arrivalsCell(int n) => n == 1 ? '1 arrival' : '$n arrivals';
  static const noArrivals = 'No one joined on this day.';
  static const waitMedian = 'median wait to be called';
  static const waitP90 = '9 in 10 were called sooner than this';
  static const serviceMedian = 'median visit';
  static const serviceP90 = '9 in 10 visits were shorter';
  static const joined = 'joined';
  static const cancelled = 'left the line';
  static const removed = 'removed';
  static const expired = 'expired';
  static const reslotted = 're-slotted';
  static const underAMinute = 'under 1 min';
  static String minutesShort(int m) => '$m min';
  static String hoursShort(int h, int m) => m == 0 ? '$h h' : '$h h $m min';
  static const downloadCsv = 'Download CSV';
  static const csvReady = 'CSV downloaded.';

  // Audit.
  static const filterLabel = 'Filter by ticket label';
  static const filterHint = 'C-031';
  static const eventsTitle = 'Events';
  static const noEvents = 'Nothing happened on this day.';
  static const noMatches = 'No events for that label on this day.';
  static const showOlder = 'Show older';
  static const messagesTitle = 'Messages to patients';
  static const noMessages = 'No messages went out on this day.';

  static const eventJoined = 'Joined the line';
  static const eventWalkIn = 'Added at the desk';
  static const eventPriority = 'Added with priority';
  static const eventCalled = 'Called';
  static const eventRecalled = 'Called again';
  static const eventConfirmed = "Tapped I'm coming";
  static const eventReminder = 'Reminder sent';
  static const eventHeadsUp = 'Heads-up sent';
  static const eventGraceExpired = "Didn't confirm in time";
  static const eventArrivalExpired = "Didn't reach the room in time";
  static const eventNoShow = 'Marked as a no-show';
  static const eventReslotted = 'Sent back in line';
  static const eventExpired = 'Expired';
  static const eventStarted = 'Seen in a room';
  static const eventServed = 'Finished';
  static const eventTransferred = 'Moved to another line';
  static const eventCancelled = 'Left the line';
  static const eventRemoved = 'Removed';
  static const eventClosed = 'Closed with the day';

  static const byPatient = 'By the patient';
  static const byDesk = 'By the desk';
  static const byOwner = 'By an owner';
  static const bySystem = 'By Docket';
  static const bySandbox = 'In the sandbox';

  static const kindJoined = 'Joined';
  static const kindHeadsUp = 'Heads-up';
  static const kindCalled = 'Your turn';
  static const kindReminder = 'Reminder';
  static const kindReslotted = 'Back in line';
  static const kindExpired = 'Ticket expired';
  static const kindDayClosed = 'Day closed';
  static const kindTransferred = 'Moved to another line';

  static const channelPush = 'Push';
  static const channelSms = 'Text';

  static const statusQueued = 'Waiting to send';
  static const statusSent = 'Sent';
  static const statusFailed = 'Failed';
  static const statusSkipped = 'Not sent';
  static const statusDelivered = 'Delivered';
  static const statusUndelivered = 'Not delivered';

  // Invite page.
  static const inviteSignInTitle = "Join your clinic's staff";
  static const inviteSignInLead =
      'Sign in with your email, or create an account, to accept the invite.';
  static const accepting = 'Accepting the invite';
  static String joinedAs(String clinic, String role) =>
      "You're on the staff at $clinic as $role.";
  static const openOwnerConsole = 'Open the owner console';
  static const roleOwnerName = 'an owner';
  static const roleDeskName = 'desk staff';
}
