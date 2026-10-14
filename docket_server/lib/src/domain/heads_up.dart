/// PRD 4.6: one heads-up per wait, at a position or an ETA threshold,
/// whichever comes first.
abstract final class HeadsUp {
  static bool due({
    required bool alreadySent,
    required int position,
    required int etaSeconds,
    required int headsUpPositions,
    required int headsUpMinutes,
  }) {
    if (alreadySent) return false;
    return position <= headsUpPositions || etaSeconds <= headsUpMinutes * 60;
  }
}
