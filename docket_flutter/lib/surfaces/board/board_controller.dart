import 'dart:async';

import 'package:docket_client/docket_client.dart';
import 'package:flutter/foundation.dart';

import '../../shared/live_stream.dart';
import '../../shared/server_clock.dart';
import '../../shared/strings.dart';
import 'announcer.dart';
import 'board_logic.dart';
import 'local_board_source.dart';

/// Everything the board shows and says, kept apart from the widgets so the
/// call logic can be tested without a browser.
///
/// The board follows the server's stream. When that stream fails, it reads
/// the desk's local database every [localPoll] and, if this browser has the
/// clinic's desk, shows those calls with a "Local mode" badge (PRD 15.5).
class BoardController extends ChangeNotifier {
  BoardController({
    required Future<BoardView> Function() snapshot,
    required Stream<BoardView> Function() watch,
    required this.local,
    required this.announcer,
    BoardView? cached,
    this.onCall,
    this.onServerView,
    this.localPoll = const Duration(seconds: 2),
    DateTime Function()? serverNow,
    DateTime Function()? deviceNow,
  }) : _serverNow = serverNow ?? ServerClock.instance.now,
       _deviceNow = deviceNow ?? (() => DateTime.now().toUtc()),
       _lastServer = cached,
       view = cached {
    _live = LiveStream<BoardView>(
      snapshot: snapshot,
      open: watch,
      onValue: _onServer,
      onFatal: _onFatal,
    );
    if (cached != null) {
      _tracker.observe(
        cached.recentCalls,
        local: false,
        now: _serverNow(),
        deviceNow: _deviceNow(),
      );
    }
  }

  final LocalBoardSource local;
  final Announcer announcer;

  /// Called once for each new call, after it's queued to be announced.
  final void Function(BoardCall call)? onCall;

  /// Called with every view from the server, so the screen can keep a copy
  /// for a reload during an outage.
  final void Function(BoardView view)? onServerView;

  final Duration localPoll;
  final DateTime Function() _serverNow;
  final DateTime Function() _deviceNow;

  late final LiveStream<BoardView> _live;
  final _tracker = CallTracker();
  Timer? _poll;
  bool _reading = false;
  bool _disposed = false;
  BoardView? _lastServer;

  /// What's on screen, from the server or from the desk's database.
  BoardView? view;

  /// True while [view] comes from the desk's local database.
  bool isLocal = false;

  /// The server's message when the board link stopped working.
  String? fatalMessage;

  bool speak = true;
  bool chime = true;

  /// How many times each room has been called while the board was open, so
  /// a room column floods with danfo each time its count goes up.
  final flashes = <String, int>{};

  LiveState get liveState => _live.state;
  DateTime? get lastServerUpdate => _live.lastUpdate;

  /// True while the browser says it has no network. An open socket can
  /// look healthy for a while after the network goes, so the board doesn't
  /// wait for it to time out.
  bool _browserOffline = false;

  /// The stream is down right now, as opposed to reconnecting with a fresh
  /// snapshot already in hand.
  bool get _failed =>
      _browserOffline ||
      (_live.state == LiveState.stale && _live.lastError != null);

  /// Whether the board shows the connection as down.
  bool get isStale => _browserOffline || _live.state == LiveState.stale;

  void start() {
    _live.addListener(_onLiveChanged);
    _live.start();
  }

  /// The browser lost its network: read the desk's database straight away.
  void browserOffline() {
    _browserOffline = true;
    _onLiveChanged();
  }

  /// The browser is back online: reconnect right away and follow the server
  /// again from its next view.
  void browserOnline() {
    _browserOffline = false;
    _live.reconnectNow();
    _onLiveChanged();
  }

  void setSpeak(bool value) {
    speak = value;
    notifyListeners();
  }

  void setChime(bool value) {
    chime = value;
    notifyListeners();
  }

  void testSound() =>
      announcer.announce(BoardStrings.testSpeech, chime: chime, speak: speak);

  void _onServer(BoardView fresh) {
    ServerClock.instance.observe(fresh.serverTime);
    _lastServer = fresh;
    onServerView?.call(fresh);
    if (_browserOffline) return;
    _apply(fresh, local: false);
  }

  bool _onFatal(Object error) {
    if (error is! DocketException) return false;
    fatalMessage = error.message;
    _stopPolling();
    return true;
  }

  void _onLiveChanged() {
    if (fatalMessage != null) {
      notifyListeners();
      return;
    }
    if (_failed) {
      _startPolling();
    } else {
      _stopPolling();
      final last = _lastServer;
      if (isLocal && last != null) _apply(last, local: false);
    }
    notifyListeners();
  }

  void _startPolling() {
    if (_poll != null) return;
    _poll = Timer.periodic(localPoll, (_) => _readLocal());
    _readLocal();
  }

  void _stopPolling() {
    _poll?.cancel();
    _poll = null;
  }

  Future<void> _readLocal() async {
    if (_reading) return;
    _reading = true;
    try {
      final last = _lastServer;
      final slug = last == null ? null : slugOfJoinUrl(last.joinUrl);
      final fromDesk = await local.read(clinicSlug: slug);
      if (fromDesk != null && _failed && !_disposed) {
        _apply(fromDesk, local: true);
      }
    } finally {
      _reading = false;
    }
  }

  void _apply(BoardView next, {required bool local}) {
    if (_disposed) return;
    final calls = _tracker.observe(
      next.recentCalls,
      local: local,
      now: local ? _deviceNow() : _serverNow(),
      deviceNow: _deviceNow(),
    );
    for (final call in calls) {
      flashes[call.roomName] = (flashes[call.roomName] ?? 0) + 1;
      final sentence = speechFor(call);
      announcer.announce(
        sentence ?? '',
        chime: chime,
        speak: speak && sentence != null,
      );
      onCall?.call(call);
    }
    view = next;
    isLocal = local;
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _stopPolling();
    _live
      ..removeListener(_onLiveChanged)
      ..dispose();
    super.dispose();
  }
}
