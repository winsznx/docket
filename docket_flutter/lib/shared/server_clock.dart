/// Keeps the offset between this device and the server, so countdowns are
/// drawn in server time and a phone with a wrong clock still shows the right
/// seconds (PRD 12).
class ServerClock {
  ServerClock._();

  static final instance = ServerClock._();

  Duration _offset = Duration.zero;

  void observe(DateTime serverTime) {
    _offset = serverTime.toUtc().difference(DateTime.now().toUtc());
  }

  DateTime now() => DateTime.now().toUtc().add(_offset);

  /// Whole seconds left until [end], never negative.
  int secondsUntil(DateTime end) {
    final left = end.toUtc().difference(now()).inMilliseconds;
    return left <= 0 ? 0 : (left / 1000).ceil();
  }

  static String mmss(int seconds) {
    final m = seconds ~/ 60;
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }
}
