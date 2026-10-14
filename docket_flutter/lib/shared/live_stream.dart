import 'dart:async';

import 'package:flutter/foundation.dart';

/// Connection state shared by every live surface (PRD 5.4 and 5.5).
enum LiveState { connecting, live, stale }

/// Opens a server stream, and when it fails marks itself stale, retries
/// after 1, 2, 4, 8 and then every 15 seconds, takes a snapshot on
/// reconnect, then reopens the stream (PRD 12).
class LiveStream<T> extends ChangeNotifier {
  LiveStream({
    required this.snapshot,
    required this.open,
    this.onValue,
    this.onFatal,
  });

  final Future<T> Function() snapshot;
  final Stream<T> Function() open;
  final void Function(T value)? onValue;

  /// Called for errors that a retry can't fix, such as a revoked link.
  /// Returning true stops retrying.
  final bool Function(Object error)? onFatal;

  static const _backoff = [1, 2, 4, 8];

  T? value;
  LiveState state = LiveState.connecting;
  DateTime? lastUpdate;
  Object? lastError;

  StreamSubscription<T>? _sub;
  Timer? _retry;
  int _attempt = 0;
  bool _closed = false;

  void start() {
    _connect(first: true);
  }

  Future<void> _connect({bool first = false}) async {
    if (_closed) return;
    try {
      if (!first) _set(await snapshot());
      _sub = open().listen(
        (v) {
          _attempt = 0;
          state = LiveState.live;
          _set(v);
        },
        onError: _fail,
        onDone: () => _fail(StateError('The stream closed.')),
        cancelOnError: true,
      );
    } on Object catch (e) {
      _fail(e);
    }
  }

  void _set(T v) {
    value = v;
    lastUpdate = DateTime.now();
    lastError = null;
    onValue?.call(v);
    notifyListeners();
  }

  void _fail(Object error) {
    if (_closed) return;
    _sub?.cancel();
    _sub = null;
    lastError = error;
    if (onFatal?.call(error) ?? false) {
      notifyListeners();
      return;
    }
    state = LiveState.stale;
    notifyListeners();
    final delay = _attempt < _backoff.length ? _backoff[_attempt] : 15;
    _attempt++;
    _retry?.cancel();
    _retry = Timer(Duration(seconds: delay), _connect);
  }

  /// Retry right away, for example when the browser reports it's online.
  void reconnectNow() {
    if (state != LiveState.stale) return;
    _retry?.cancel();
    _attempt = 0;
    _connect();
  }

  @override
  void dispose() {
    _closed = true;
    _retry?.cancel();
    _sub?.cancel();
    super.dispose();
  }
}
