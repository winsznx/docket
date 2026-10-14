import 'package:docket_client/docket_client.dart';

import '../../shared/strings.dart';

/// Common IANA zones offered in the setup wizard. Any other zone can be
/// typed in, and the server checks it.
const commonTimezones = [
  'Africa/Lagos',
  'Africa/Accra',
  'Africa/Abidjan',
  'Africa/Nairobi',
  'Africa/Johannesburg',
  'Africa/Cairo',
  'Europe/London',
  'Europe/Berlin',
  'America/New_York',
  'America/Los_Angeles',
  'Asia/Dubai',
  'Asia/Kolkata',
];

const defaultTimezone = 'Africa/Lagos';

const _accents = {
  'à': 'a', 'á': 'a', 'â': 'a', 'ã': 'a', 'ä': 'a', 'å': 'a', //
  'è': 'e', 'é': 'e', 'ê': 'e', 'ë': 'e', //
  'ì': 'i', 'í': 'i', 'î': 'i', 'ï': 'i', //
  'ò': 'o', 'ó': 'o', 'ô': 'o', 'õ': 'o', 'ö': 'o', 'ọ': 'o', //
  'ù': 'u', 'ú': 'u', 'û': 'u', 'ü': 'u', 'ụ': 'u', //
  'ñ': 'n', 'ń': 'n', 'ç': 'c', 'ẹ': 'e', 'ṣ': 's', //
};

const maxSlugLength = 40;

/// A link name suggested from the clinic name: lowercase letters, numbers
/// and single hyphens, such as "St. Mary's Clinic, Ikeja" to
/// `st-marys-clinic-ikeja`.
String suggestSlug(String name) {
  final plain = name
      .toLowerCase()
      .split('')
      .map((c) => _accents[c] ?? c)
      .join()
      .replaceAll(RegExp(r"['’]"), '');
  var slug = plain
      .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
      .replaceAll(RegExp(r'^-+|-+$'), '');
  if (slug.length > maxSlugLength) {
    slug = slug.substring(0, maxSlugLength).replaceAll(RegExp(r'-+$'), '');
  }
  return slug;
}

final _slugPattern = RegExp(r'^[a-z0-9](?:[a-z0-9-]{1,38}[a-z0-9])$');
final _codePattern = RegExp(r'^[A-Z]$');
final _timePattern = RegExp(r'^([01]\d|2[0-3]):[0-5]\d$');
final _zonePattern = RegExp(r'^[A-Za-z_]+(/[A-Za-z0-9_+\-]+){0,2}$');

String? validateClinicName(String value) {
  final name = value.trim();
  return name.isEmpty || name.length > 60 ? OwnerStrings.nameMissing : null;
}

String? validateSlug(String value) {
  final slug = value.trim();
  return _slugPattern.hasMatch(slug) && !slug.startsWith('sandbox')
      ? null
      : OwnerStrings.slugInvalid;
}

String? validateTimezone(String value) =>
    _zonePattern.hasMatch(value.trim()) ? null : OwnerStrings.timezoneInvalid;

String? validateLineName(String value) {
  final name = value.trim();
  return name.isEmpty || name.length > 40 ? OwnerStrings.lineNameMissing : null;
}

String? validateLineCode(String value) =>
    _codePattern.hasMatch(value.trim().toUpperCase())
    ? null
    : OwnerStrings.lineCodeInvalid;

String? validateServiceMinutes(String value) {
  final minutes = int.tryParse(value.trim());
  return minutes == null || minutes < 1 || minutes > 60
      ? OwnerStrings.serviceMinutesInvalid
      : null;
}

String? validateRoomName(String value) {
  final name = value.trim();
  return name.isEmpty || name.length > 40 ? OwnerStrings.roomNameMissing : null;
}

String? validateTime(String value) =>
    _timePattern.hasMatch(value.trim()) ? null : OwnerStrings.timeInvalid;

int minutesOfDay(String hhmm) {
  final parts = hhmm.split(':');
  return int.parse(parts[0]) * 60 + int.parse(parts[1]);
}

/// Opening has to come before the last join, and that no later than
/// closing, as the server checks.
String? validateHours(String open, String cutoff, String close) {
  for (final t in [open, cutoff, close]) {
    final error = validateTime(t);
    if (error != null) return error;
  }
  final o = minutesOfDay(open.trim());
  final j = minutesOfDay(cutoff.trim());
  final c = minutesOfDay(close.trim());
  return o < j && j <= c ? null : OwnerStrings.hoursOrder;
}

/// The first unused capital letter of [name], or of the alphabet, as a
/// line code suggestion.
String suggestLineCode(String name, Iterable<String> taken) {
  final used = taken.map((c) => c.toUpperCase()).toSet();
  for (final c in [
    ...name.toUpperCase().split(''),
    ...'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split(''),
  ]) {
    if (_codePattern.hasMatch(c) && !used.contains(c)) return c;
  }
  return '';
}

/// One clinic setting from PRD 4.2, with its range and plain explanation.
class SettingSpec {
  const SettingSpec({
    required this.label,
    required this.explanation,
    required this.min,
    required this.max,
    required this.unit,
    required this.read,
    required this.write,
    this.serverName,
  });

  final String label;
  final String explanation;
  final int min;
  final int max;
  final String unit;
  final int Function(ClinicSettings s) read;
  final ClinicSettings Function(ClinicSettings s, int value) write;

  /// What the server calls this setting in its range message, when that
  /// differs from [label].
  final String? serverName;

  String get rangeText => OwnerStrings.range(min, max, unit);

  String? validate(String raw) {
    final value = int.tryParse(raw.trim());
    if (value == null) return OwnerStrings.wholeNumber;
    if (value < min || value > max) {
      return OwnerStrings.between(serverName ?? label, min, max);
    }
    return null;
  }
}

/// The number settings, grouped as the settings page shows them.
final settingGroups = <(String, List<SettingSpec>)>[
  (
    OwnerStrings.callingGroup,
    [
      SettingSpec(
        label: OwnerStrings.graceLabel,
        explanation: OwnerStrings.graceExplain,
        min: 60,
        max: 900,
        unit: OwnerStrings.seconds,
        read: (s) => s.graceSeconds,
        write: (s, v) => s.copyWith(graceSeconds: v),
      ),
      SettingSpec(
        label: OwnerStrings.reminderLabel,
        explanation: OwnerStrings.reminderExplain,
        min: 15,
        max: 120,
        unit: OwnerStrings.seconds,
        serverName: 'The reminder',
        read: (s) => s.graceReminderSeconds,
        write: (s, v) => s.copyWith(graceReminderSeconds: v),
      ),
      SettingSpec(
        label: OwnerStrings.arrivalLabel,
        explanation: OwnerStrings.arrivalExplain,
        min: 120,
        max: 1800,
        unit: OwnerStrings.seconds,
        read: (s) => s.arrivalSeconds,
        write: (s, v) => s.copyWith(arrivalSeconds: v),
      ),
    ],
  ),
  (
    OwnerStrings.headsUpGroup,
    [
      SettingSpec(
        label: OwnerStrings.headsUpPlaceLabel,
        explanation: OwnerStrings.headsUpPlaceExplain,
        min: 1,
        max: 5,
        unit: OwnerStrings.places,
        read: (s) => s.headsUpPositions,
        write: (s, v) => s.copyWith(headsUpPositions: v),
      ),
      SettingSpec(
        label: OwnerStrings.headsUpMinutesLabel,
        explanation: OwnerStrings.headsUpMinutesExplain,
        min: 3,
        max: 30,
        unit: OwnerStrings.minutes,
        read: (s) => s.headsUpMinutes,
        write: (s, v) => s.copyWith(headsUpMinutes: v),
      ),
    ],
  ),
  (
    OwnerStrings.missGroup,
    [
      SettingSpec(
        label: OwnerStrings.reslotLabel,
        explanation: OwnerStrings.reslotExplain,
        min: 1,
        max: 10,
        unit: OwnerStrings.places,
        read: (s) => s.reslotOffset,
        write: (s, v) => s.copyWith(reslotOffset: v),
      ),
      SettingSpec(
        label: OwnerStrings.maxReslotsLabel,
        explanation: OwnerStrings.maxReslotsExplain,
        min: 0,
        max: 3,
        unit: OwnerStrings.misses,
        read: (s) => s.maxReslots,
        write: (s, v) => s.copyWith(maxReslots: v),
      ),
    ],
  ),
];

final autoCloseSpec = SettingSpec(
  label: OwnerStrings.autoCloseLabel,
  explanation: OwnerStrings.autoCloseExplain,
  min: 0,
  max: 600,
  unit: OwnerStrings.minutes,
  serverName: 'Auto close',
  read: (s) => s.autoCloseAfterMinutes,
  write: (s, v) => s.copyWith(autoCloseAfterMinutes: v),
);

/// The settings a clinic has now, in the shape `updateSettings` takes.
ClinicSettings settingsOf(Clinic c) => ClinicSettings(
  graceSeconds: c.graceSeconds,
  graceReminderSeconds: c.graceReminderSeconds,
  arrivalSeconds: c.arrivalSeconds,
  headsUpPositions: c.headsUpPositions,
  headsUpMinutes: c.headsUpMinutes,
  reslotOffset: c.reslotOffset,
  maxReslots: c.maxReslots,
  openTime: c.openTime,
  joinCutoffTime: c.joinCutoffTime,
  closeTime: c.closeTime,
  autoCloseAfterMinutes: c.autoCloseAfterMinutes,
  timezone: c.timezone,
  smsEnabled: c.smsEnabled,
);

/// A wait or visit length the way a person says it, such as "14 min".
String formatDuration(int? seconds) {
  if (seconds == null) return OwnerStrings.noWaitYet;
  if (seconds < 60) return OwnerStrings.underAMinute;
  final minutes = (seconds / 60).round();
  if (minutes < 60) return OwnerStrings.minutesShort(minutes);
  return OwnerStrings.hoursShort(minutes ~/ 60, minutes % 60);
}

/// A service date as the server writes it, `YYYY-MM-DD`.
String serviceDateOf(DateTime day) =>
    '${day.year.toString().padLeft(4, '0')}-'
    '${day.month.toString().padLeft(2, '0')}-'
    '${day.day.toString().padLeft(2, '0')}';

DateTime parseServiceDate(String value) {
  final parts = value.split('-').map(int.parse).toList();
  return DateTime(parts[0], parts[1], parts[2]);
}

const _weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
const _months = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', //
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec', //
];

/// A service date for reading, such as "Wed 14 Oct 2026".
String readableDate(String serviceDate) {
  final d = parseServiceDate(serviceDate);
  return '${_weekdays[d.weekday - 1]} ${d.day} ${_months[d.month - 1]} '
      '${d.year}';
}

/// The hours an arrivals chart shows: the clinic's opening hours, widened
/// to take in any hour that had arrivals.
(int, int) chartHours(List<int> counts, String openTime, String closeTime) {
  var first = minutesOfDay(openTime) ~/ 60;
  var last = (minutesOfDay(closeTime) - 1) ~/ 60;
  for (var h = 0; h < counts.length; h++) {
    if (counts[h] == 0) continue;
    if (h < first) first = h;
    if (h > last) last = h;
  }
  if (last < first) last = first;
  return (first, last);
}

/// Every line's arrivals added together, hour by hour.
List<int> totalArrivals(List<LineReport> lines) {
  final total = List<int>.filled(24, 0);
  for (final line in lines) {
    for (var h = 0; h < 24 && h < line.arrivalsByHour.length; h++) {
      total[h] += line.arrivalsByHour[h];
    }
  }
  return total;
}

String hourLabel(int hour) => '${hour.toString().padLeft(2, '0')}:00';

String describeEvent(TicketEventType type) => switch (type) {
  TicketEventType.joined => OwnerStrings.eventJoined,
  TicketEventType.walkInAdded => OwnerStrings.eventWalkIn,
  TicketEventType.priorityInserted => OwnerStrings.eventPriority,
  TicketEventType.called => OwnerStrings.eventCalled,
  TicketEventType.recalled => OwnerStrings.eventRecalled,
  TicketEventType.confirmed => OwnerStrings.eventConfirmed,
  TicketEventType.graceReminderSent => OwnerStrings.eventReminder,
  TicketEventType.headsUpSent => OwnerStrings.eventHeadsUp,
  TicketEventType.graceExpired => OwnerStrings.eventGraceExpired,
  TicketEventType.arrivalExpired => OwnerStrings.eventArrivalExpired,
  TicketEventType.markedNoShow => OwnerStrings.eventNoShow,
  TicketEventType.reslotted => OwnerStrings.eventReslotted,
  TicketEventType.expired => OwnerStrings.eventExpired,
  TicketEventType.serviceStarted => OwnerStrings.eventStarted,
  TicketEventType.served => OwnerStrings.eventServed,
  TicketEventType.transferred => OwnerStrings.eventTransferred,
  TicketEventType.cancelled => OwnerStrings.eventCancelled,
  TicketEventType.removed => OwnerStrings.eventRemoved,
  TicketEventType.closed => OwnerStrings.eventClosed,
};

String describeActor(ActorType actor) => switch (actor) {
  ActorType.patient => OwnerStrings.byPatient,
  ActorType.desk => OwnerStrings.byDesk,
  ActorType.owner => OwnerStrings.byOwner,
  ActorType.system => OwnerStrings.bySystem,
  ActorType.sandbox => OwnerStrings.bySandbox,
};

String describeKind(NotificationKind kind) => switch (kind) {
  NotificationKind.joined => OwnerStrings.kindJoined,
  NotificationKind.headsUp => OwnerStrings.kindHeadsUp,
  NotificationKind.called => OwnerStrings.kindCalled,
  NotificationKind.graceReminder => OwnerStrings.kindReminder,
  NotificationKind.reslotted => OwnerStrings.kindReslotted,
  NotificationKind.expired => OwnerStrings.kindExpired,
  NotificationKind.dayClosed => OwnerStrings.kindDayClosed,
  NotificationKind.transferred => OwnerStrings.kindTransferred,
};

String describeChannel(Channel channel) => switch (channel) {
  Channel.push => OwnerStrings.channelPush,
  Channel.sms => OwnerStrings.channelSms,
};

String describeStatus(DeliveryStatus status) => switch (status) {
  DeliveryStatus.queued => OwnerStrings.statusQueued,
  DeliveryStatus.sent => OwnerStrings.statusSent,
  DeliveryStatus.failed => OwnerStrings.statusFailed,
  DeliveryStatus.skipped => OwnerStrings.statusSkipped,
  DeliveryStatus.delivered => OwnerStrings.statusDelivered,
  DeliveryStatus.undelivered => OwnerStrings.statusUndelivered,
};

/// The words to show for a failed call: the server's own message for a
/// refusal, which is written as product copy, or a plain line for a network
/// failure.
String messageOf(Object error) =>
    error is DocketException ? error.message : OwnerStrings.networkError;

/// The A4 poster for one line, made on the server (PRD 16).
String posterUrl(String base, String slug, String code) => Uri.parse(
  '$base/api/poster/${Uri.encodeComponent(slug)}',
).replace(queryParameters: {'line': code}).toString();
