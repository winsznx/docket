import 'package:docket_client/docket_client.dart' hide Notification;

/// Every string on `/desk` and `/try` (PRD 17.3, 17.6, 15 and DESIGN 5.4).
abstract final class DeskStrings {
  // `/try`
  static const tryTitle = 'Try a live clinic';
  static const tryBody =
      "You run the front desk of a throwaway clinic. Join the line from your "
      "phone, then press Call next and watch it move. It's deleted after 24 "
      'hours.';
  static const tryStart = 'Open my sandbox desk';
  static const tryStartFresh = 'Start a new sandbox instead';
  static const tryStarting = 'Making your clinic';
  static String tryExisting(int hoursLeft) => hoursLeft < 2
      ? "You already have a sandbox. It's deleted within the hour."
      : 'You already have a sandbox. It stays for $hoursLeft more hours.';
  static const tryReopen = 'Reopen my sandbox desk';
  static const tryLoading = 'Making your sandbox clinic';

  // Entry.
  static const signInTitle = 'Sign in to the desk';
  static const signInBody =
      'Use the email your clinic owner invited. The desk opens once you are in.';
  static const tryInstead = 'Try a sandbox clinic instead';
  static const loadingClinics = 'Finding your clinics';
  static const noClinicsTitle = "You're not on a clinic's staff yet.";
  static const noClinicsBody =
      'Ask the clinic owner for an invite link, or set up your own clinic.';
  static const setUpClinic = 'Set up a clinic';
  static const signOut = 'Sign out';
  static const pickClinicTitle = 'Which clinic are you working at?';
  static const switchClinic = 'Switch clinic';
  static const pickRoomTitle = 'Which room is this desk?';
  static const pickRoomBody =
      'This device remembers the room. You can change it from the top bar.';
  static String roomServes(String line) => 'Calls from $line';
  static String roomChoice(String room, String line) =>
      '$room, calls from $line';
  static const openingDesk = 'Opening the desk';
  static const leaveSandbox = 'Leave the sandbox';
  static const leaveBlocked =
      'Some actions haven\'t synced yet. Stay until they do.';
  static const offlineNoDesk =
      "Docket can't be reached, and this device hasn't opened this desk "
      'before. It keeps trying and opens the desk once the connection is back.';

  // Top bar.
  static String changeRoom(String room) => 'Change room, now $room';
  static const dayOpen = 'Day open';
  static const dayClosed = 'Day closed';
  static const dayNotStarted = 'Day not started';
  static const online = 'Online';
  static String offlineSaved(int count) =>
      count == 0 ? 'Offline' : 'Offline, ${_actions(count)} saved';
  static String syncing(int count) => 'Syncing ${_actions(count)}';
  static String toReview(int count) =>
      count == 1 ? '1 to review' : '$count to review';
  static const closeDay = 'Close day';
  static const closeDayTitle = 'Close the day?';
  static const closeDayBody =
      'Everyone still waiting gets a closed ticket and a message. '
      'Patients in service are marked as seen. Calls stop until tomorrow.';
  static const closeDayConfirm = 'Close the day';
  static const keepOpen = 'Keep it open';

  // Connection band, PRD 5.4.
  static const offlineBand = 'Offline, calls are saved on this device';
  static String waitingActions(int count) => '${_actions(count)} waiting';
  static String syncingBand(int count) => 'Syncing ${_actions(count)}';
  static const backOnline = 'Back online. Everything is synced.';
  static const wentOffline = 'Offline. Calls are saved on this device.';

  static String _actions(int count) =>
      count == 1 ? '1 action' : '$count actions';

  // Now serving.
  static String roomFree(String room) => '$room is free.';
  static const roomFreeBody = 'Call next when you are ready.';
  static const nowServing = 'Now serving';
  static const stateCalled = 'Called, waiting for them to confirm';
  static const stateConfirmed = 'On the way to the room';
  static const stateInService = 'In service';
  static const toConfirm = 'to confirm';
  static const toArrive = 'to arrive';
  static const pendingCall =
      'Waiting to sync. The patient is notified and their grace window '
      'starts when the clinic is back online.';
  static const pendingChange = 'Saved on this device. It syncs when online.';
  static const startService = 'Start service';
  static const recall = 'Recall';
  static const noShow = 'No-show';
  static const finish = 'Finish';
  static const transfer = 'Transfer to another line';
  static const alsoHere = 'Also called to this room';
  static const showHere = 'Show';
  static String ticketSemantics(String label, String name, String state) =>
      '$label, $name, $state';

  // Delivery chips.
  static String delivery(Channel channel, DeliveryStatus status) {
    final via = channel == Channel.push ? 'Push' : 'SMS';
    return switch (status) {
      DeliveryStatus.queued => '$via queued',
      DeliveryStatus.sent => '$via sent',
      DeliveryStatus.failed => '$via failed',
      DeliveryStatus.skipped => '$via skipped',
      DeliveryStatus.delivered => '$via delivered',
      DeliveryStatus.undelivered => '$via not delivered',
    };
  }

  // Call next.
  static const callNext = 'Call next';
  static const blockedRoomPaused = 'Room on a break';
  static const blockedRoomClosed = 'Room closed';
  static const blockedNoOne = 'No one is waiting';
  static const blockedDayClosed = 'Day closed';
  static const shortcutsHint =
      'Space calls next. R recalls, S starts service, F finishes and N marks '
      'a no-show.';

  // Queue.
  static String queueTitle(String line) => line;
  static String waitingCount(int count) =>
      count == 1 ? '1 waiting' : '$count waiting';
  static const queueEmpty = 'No one is waiting in this line.';
  static const queueEmptyBody =
      'Add a walk-in, or share the join code so patients can join from '
      'their phones.';
  static const chipDemo = 'DEMO';
  static const chipReslotted = 'Re-slotted';
  static const chipAlerts = 'Alerts on';
  static const chipUnsynced = 'Not synced yet';
  static String rowOptions(String label) => 'Options for $label';
  static const callThis = 'Call this patient';
  static const remove = 'Remove';
  static const showQr = 'Show QR for this patient';
  static const showQrOffline = 'QR needs a connection';

  static String priorityReason(PriorityReason reason) => switch (reason) {
    PriorityReason.emergency => 'Emergency',
    PriorityReason.elderly => 'Older patient',
    PriorityReason.pregnant => 'Pregnant',
    PriorityReason.disability => 'Disability',
    PriorityReason.returningWithResults => 'Back with results',
    PriorityReason.staffDiscretion => 'Staff priority',
  };

  // Remove sheet.
  static String removeTitle(String label) => 'Remove $label from the line?';
  static const removeBody = 'Pick the reason. The patient sees that they left.';
  static const removeReasons = [
    'Left without telling us',
    'Came by mistake',
    'Duplicate ticket',
    'Seen elsewhere',
    'Other',
  ];
  static const cancel = 'Cancel';

  // Add sheets.
  static const addWalkIn = 'Add walk-in';
  static const addPriority = 'Add priority';
  static const addWalkInTitle = 'Add a walk-in';
  static const addPriorityTitle = 'Add a priority patient';
  static const addPriorityBody =
      'Priority patients go ahead of everyone else waiting. Pick the reason.';
  static const nameLabel = 'Name or initials';

  /// What the server calls a patient added without a name.
  static const defaultName = 'Patient';
  static const nameHint = 'Initials are enough';
  static const lineLabel = 'Line';
  static const reasonLabel = 'Reason';
  static const noteLabel = 'Note for the desk';
  static const noteHint = 'No medical details';
  static const phoneLabel = 'Phone for texts';
  static const phoneHint = 'Optional, for example 0803 123 4567';
  static const phoneConsent =
      'The patient agreed to get texts about their place in line.';
  static const addToLine = 'Add to the line';
  static const adding = 'Adding';
  static const pickReason = 'Pick a reason first.';
  static const consentNeeded = 'Tick the box to send texts first.';
  static const scanToFollow = 'Scan to follow your place';
  static String addedAs(String label) => '$label is in the line.';
  static const addedOfflineTitle = 'Saved on this device';
  static const addedOffline =
      'The patient joins the line as soon as the clinic is back online. '
      'Then use Show QR for this patient in their row.';
  static const done = 'Done';
  static const qrReplaces =
      "This replaces the patient's old link. Their place doesn't change.";

  // Transfer sheet.
  static String transferTitle(String label) => 'Send $label to another line';
  static const transferBody =
      'They finish here and join the end of the line you pick.';
  static const noOtherLines = 'This clinic has no other line to send them to.';

  // Room state.
  static const roomStateTitle = 'Room';
  static String roomState(RoomState state) => switch (state) {
    RoomState.open => 'Open',
    RoomState.paused => 'On a break',
    RoomState.closed => 'Closed',
  };

  // Other lines.
  static const otherLinesTitle = 'Other lines';
  static String servedToday(int count) => '$count served today';

  // Corrections drawer, PRD 15.4.
  static const correctionsTitle = "The server didn't take these";
  static const correctionsBody =
      'The server has the final say. Nothing here is retried on its own.';
  static const gotIt = 'Got it';
  static const dismissAll = 'Dismiss all';
  static String describe(DeskAction action, String? label, String? room) {
    final who = label ?? 'a patient';
    final where = room ?? 'this room';
    return switch (action) {
      CallNextAction() => 'Call next from $where',
      CallSpecificAction() => 'Call $who to $where',
      RecallAction() => 'Recall $who',
      StartServiceAction() => 'Start service for $who',
      FinishAction() => 'Finish $who',
      MarkNoShowAction() => 'No-show for $who',
      RemoveAction() => 'Remove $who',
      AddWalkInAction(:final displayName) => 'Add walk-in $displayName',
      AddPriorityAction(:final displayName) => 'Add priority $displayName',
      TransferAction() => 'Transfer $who',
      SetRoomStateAction(:final state) =>
        'Set $where to ${roomState(state).toLowerCase()}',
      CloseDayAction() => 'Close the day',
    };
  }

  static const otherClinic =
      'This was saved for a different clinic, so it was never sent.';

  // Sandbox panel, PRD 17.6.
  static const sandboxTitle = 'Join from your own phone';
  static const sandboxBody =
      'Scan this, join the line, then press Call next and watch your phone.';
  static const addDemo = 'Add 5 demo walk-ins';
  static const addingDemo = 'Adding demo patients';
  static const openBoard = 'Open the waiting-room board in a new tab';
  static const openOwner = 'Open the owner view in a new tab';
  static const needsConnection = 'Needs a connection';
  static const joinQrSemantics = 'QR code to join this clinic';
  static const ticketQrSemantics = "QR code for the patient's ticket";

  // Errors and fatal states.
  static const storageError =
      "This browser couldn't open the desk's storage on this device. "
      'Reload the page, or open the desk in another browser.';
  static const tooManyTries = 'Too many tries. Wait a minute and try again.';
  static const serverRefused =
      "The server couldn't apply this one. Check the line and do it again "
      "if it's still needed.";
  static const networkError =
      "Couldn't reach Docket. Check the connection and try again.";
  static const sandboxGone = 'Start a new sandbox';
  static const retry = 'Try again';
}
