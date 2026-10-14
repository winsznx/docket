import 'dart:async';

/// A small in-memory cache with a lifetime per entry, for values that only
/// need to live on this podlet. Loads are single-flight: when many callers
/// miss the same key at once, one load runs and they all share its result,
/// so a line change that wakes 300 phones builds the line snapshot once.
class TtlCache<K, V> {
  TtlCache(this.lifetime, {this.maxEntries = 2000});

  final Duration lifetime;
  final int maxEntries;
  final _entries = <K, ({DateTime expires, Future<V> value})>{};

  Future<V> get(K key, Future<V> Function() load) {
    final now = DateTime.now();
    final hit = _entries[key];
    if (hit != null && hit.expires.isAfter(now)) return hit.value;
    if (_entries.length >= maxEntries) {
      _entries.removeWhere((_, e) => !e.expires.isAfter(now));
      if (_entries.length >= maxEntries) _entries.remove(_entries.keys.first);
    }
    final future = load();
    _entries[key] = (expires: now.add(lifetime), value: future);
    unawaited(
      future.then<void>(
        (_) {},
        onError: (Object _) => _entries.remove(key),
      ),
    );
    return future;
  }

  void invalidate(K key) => _entries.remove(key);
}
