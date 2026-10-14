import 'package:timezone/data/latest_10y.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

/// Clinic-local dates and times. Every rule that says "clinic local" in
/// PRD 4.2 goes through here.
abstract final class ClinicTime {
  static bool _loaded = false;

  static void ensureLoaded() {
    if (_loaded) return;
    tzdata.initializeTimeZones();
    _loaded = true;
  }

  static bool isValidZone(String name) {
    ensureLoaded();
    try {
      tz.getLocation(name);
      return true;
    } on tz.LocationNotFoundException {
      return false;
    }
  }

  static tz.TZDateTime local(String zone, DateTime utc) {
    ensureLoaded();
    return tz.TZDateTime.from(utc, tz.getLocation(zone));
  }

  /// `YYYY-MM-DD` of [utc] in [zone].
  static String serviceDate(String zone, DateTime utc) {
    final l = local(zone, utc);
    return '${l.year.toString().padLeft(4, '0')}-'
        '${l.month.toString().padLeft(2, '0')}-'
        '${l.day.toString().padLeft(2, '0')}';
  }

  /// Minutes since local midnight for an `HH:MM` string.
  static int minutesOf(String hhmm) {
    final parts = hhmm.split(':');
    return int.parse(parts[0]) * 60 + int.parse(parts[1]);
  }

  static bool isValidHhmm(String value) {
    final match = RegExp(r'^([01]\d|2[0-3]):([0-5]\d)$').hasMatch(value);
    return match;
  }

  static int localMinutes(String zone, DateTime utc) {
    final l = local(zone, utc);
    return l.hour * 60 + l.minute;
  }

  /// The UTC instant of `HH:MM` on [serviceDate] in [zone], plus [addMinutes].
  static DateTime atLocal(
    String zone,
    String serviceDate,
    String hhmm, {
    int addMinutes = 0,
  }) {
    ensureLoaded();
    final d = serviceDate.split('-').map(int.parse).toList();
    final m = minutesOf(hhmm) + addMinutes;
    final t = tz.TZDateTime(tz.getLocation(zone), d[0], d[1], d[2], 0, m);
    return t.toUtc();
  }

  static String hhmmLocal(String zone, DateTime utc) {
    final l = local(zone, utc);
    return '${l.hour.toString().padLeft(2, '0')}:'
        '${l.minute.toString().padLeft(2, '0')}';
  }
}
