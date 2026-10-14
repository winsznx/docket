/// Sort-key arithmetic for a line, PRD 4.3 and 4.5.
///
/// Eligible tickets order by `priorityRank` then `sortKey`. Joins append with
/// a gap of [joinGap], re-slots take the midpoint of their neighbours, and a
/// gap under [minGap] asks the caller to renumber the line.
abstract final class Ordering {
  static const double joinGap = 1024;
  static const double minGap = 0.000001;

  static double appendKey(double? currentMax) => (currentMax ?? 0) + joinGap;

  /// Where a re-slotted ticket lands among the normal-priority waiting keys,
  /// sorted ascending. It ends up at 1-based position [offset] among them, or
  /// last when fewer tickets wait.
  static Placement reslot(List<double> normalKeysAscending, int offset) {
    final keys = normalKeysAscending;
    final ahead = offset - 1;
    if (ahead >= keys.length) {
      return Placement(appendKey(keys.isEmpty ? null : keys.last));
    }
    if (ahead <= 0) {
      return Placement(keys.first - joinGap);
    }
    final before = keys[ahead - 1];
    final after = keys[ahead];
    final gap = after - before;
    return Placement(before + gap / 2, needsRenumber: gap / 2 < minGap);
  }

  /// Fresh evenly spaced keys for [count] tickets already in order.
  static List<double> renumbered(int count) => [
    for (var i = 1; i <= count; i++) i * joinGap,
  ];
}

class Placement {
  const Placement(this.sortKey, {this.needsRenumber = false});

  final double sortKey;
  final bool needsRenumber;
}
