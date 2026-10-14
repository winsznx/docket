/// ETA rules from PRD 13.
abstract final class Eta {
  static const int samplesForMedian = 10;
  static const int samplesForConfidence = 3;
  static const Duration presenceWindow = Duration(seconds: 45);

  /// Median of the newest samples, or [defaultSeconds] until there are
  /// [samplesForConfidence] of them.
  static int medianServiceSeconds(List<int> newestFirst, int defaultSeconds) {
    if (newestFirst.length < samplesForConfidence) return defaultSeconds;
    final window = newestFirst.take(samplesForMedian).toList()..sort();
    final mid = window.length ~/ 2;
    if (window.length.isOdd) return window[mid];
    return ((window[mid - 1] + window[mid]) / 2).round();
  }

  static int seconds({
    required int position,
    required int activeRooms,
    required int medianServiceSeconds,
  }) {
    final rooms = activeRooms < 1 ? 1 : activeRooms;
    final rounds = (position / rooms).ceil();
    final value = (rounds < 1 ? 1 : rounds) * medianServiceSeconds;
    return value < 1 ? 1 : value;
  }

  static int minutes(int seconds) {
    final m = (seconds / 60).ceil();
    return m < 1 ? 1 : m;
  }

  /// "under 5 min", "8 min", "about 25 min" or "over an hour", with
  /// ", early estimate" while the line has fewer than three samples.
  static String text(int seconds, {required bool early}) {
    final m = minutes(seconds);
    final String base;
    if (m < 5) {
      base = 'under 5 min';
    } else if (m < 15) {
      base = 'about $m min';
    } else if (m <= 60) {
      final rounded = ((m / 5).round() * 5).clamp(15, 60);
      base = 'about $rounded min';
    } else {
      base = 'over an hour';
    }
    return early ? '$base, early estimate' : base;
  }
}
