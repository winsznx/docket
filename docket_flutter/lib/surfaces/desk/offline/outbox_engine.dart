import 'dart:async';

import 'package:docket_client/docket_client.dart' hide Notification;
import 'package:flutter/foundation.dart';

import '../../../shared/strings.dart';
import '../desk_errors.dart';
import 'desk_store.dart';

/// Drains the outbox to the server (PRD 15.2 and 15.4).
///
/// Online, each action goes to `desk.act` in `seq` order the moment it's
/// written. After the connection drops, everything left goes to `desk.sync`
/// in batches of up to 200, and the returned view replaces the mirror. The
/// server is the source of truth: rejected actions settle and wait for a
/// person, and nothing is retried on its own except actions the server never
/// received, which are safe to send again because the server applies each
/// `actionId` once.
class OutboxEngine {
  OutboxEngine({
    required this.store,
    required this.act,
    required this.sync,
    required this.fetchView,
    required this.canSend,
    required this.applyView,
    required this.onChanged,
    required this.onRejected,
  });

  static const maxBatch = 200;

  final DeskStore store;
  final Future<DeskActionResult> Function(DeskAction action) act;
  final Future<SyncResult> Function(SyncBatch batch) sync;
  final Future<DeskView> Function() fetchView;
  final bool Function() canSend;
  final Future<void> Function(DeskView view, {required bool keepPending})
  applyView;
  final VoidCallback onChanged;
  final VoidCallback onRejected;

  /// True once an action may not have reached the server, so the next drain
  /// replays the outbox through `sync` instead of `act`.
  bool needsSync = false;

  bool get running => _running;
  bool _running = false;
  bool _again = false;
  bool _disposed = false;

  final _waiters = <UuidValue, Completer<DeskActionResult?>>{};

  /// Completes with the server's answer to [actionId], or null if the
  /// action waits for the connection to come back.
  Future<DeskActionResult?> resultOf(UuidValue actionId) =>
      _waiters.putIfAbsent(actionId, Completer.new).future;

  void forget(UuidValue actionId) => _waiters.remove(actionId)?.complete(null);

  void markOffline() {
    needsSync = true;
    for (final id in _waiters.keys.toList()) {
      forget(id);
    }
  }

  Future<void> kick() async {
    if (_disposed) return;
    if (_running) {
      _again = true;
      return;
    }
    _running = true;
    var sent = false;
    var viewIsFresh = false;
    try {
      while (canSend()) {
        _again = false;
        final pending = await store.unsettled();
        if (pending.isEmpty) break;
        sent = true;
        final syncing = needsSync;
        final progressed = syncing
            ? await _sync(pending.take(maxBatch).toList())
            : await _act(pending);
        if (!progressed) break;
        viewIsFresh = syncing;
      }
      if (sent && !viewIsFresh && canSend()) {
        final left = await store.unsettled();
        if (left.isEmpty) await _refresh();
      }
    } finally {
      _running = false;
      if (!_disposed) onChanged();
    }
    if (_again && !_disposed) unawaited(kick());
  }

  Future<bool> _act(List<OutboxAction> pending) async {
    for (final row in pending) {
      if (!canSend()) return false;
      final action = store.decode(row);
      final DeskActionResult result;
      try {
        result = await act(action);
      } on DocketException catch (e) {
        await _settle([_rejected(action.actionId, e.code, e.message)]);
        continue;
      } on Exception catch (e) {
        if (!isTransient(e)) {
          debugPrint('Desk action ${action.actionId} refused: $e');
          await _settle([
            _rejected(action.actionId, null, DeskStrings.serverRefused),
          ]);
          continue;
        }
        debugPrint('Desk action ${action.actionId} not sent yet: $e');
        forget(action.actionId);
        needsSync = true;
        onChanged();
        return false;
      }
      await _settle([result]);
    }
    return true;
  }

  Future<bool> _sync(List<OutboxAction> batch) async {
    final actions = [for (final row in batch) store.decode(row)];
    try {
      final result = await sync(
        SyncBatch(deviceId: store.deviceId, actions: actions),
      );
      await _settle(result.results);
      final left = await store.unsettled();
      if (left.isEmpty) needsSync = false;
      await applyView(result.view, keepPending: false);
      final answered = {for (final r in result.results) r.actionId};
      return actions.any((a) => answered.contains(a.actionId));
    } on DocketException catch (e) {
      await _settle([
        for (final a in actions) _rejected(a.actionId, e.code, e.message),
      ]);
      return true;
    } on Exception catch (e) {
      if (!isTransient(e)) {
        debugPrint('Desk sync of ${actions.length} actions refused: $e');
        await _settle([
          for (final a in actions)
            _rejected(a.actionId, null, DeskStrings.serverRefused),
        ]);
        return true;
      }
      debugPrint('Desk sync of ${actions.length} actions not sent yet: $e');
      return false;
    }
  }

  Future<void> _refresh() async {
    try {
      await applyView(await fetchView(), keepPending: false);
    } on Exception catch (e) {
      debugPrint(
        'Desk view refresh after sync failed, the stream will '
        'catch up: $e',
      );
    }
  }

  Future<void> _settle(List<DeskActionResult> results) async {
    await store.settle(results);
    var rejected = false;
    for (final result in results) {
      final turnedDown =
          result.outcome == ActionOutcome.rejected ||
          (result.outcome == ActionOutcome.duplicate && result.code != null);
      rejected = rejected || turnedDown;
      _waiters.remove(result.actionId)?.complete(result);
    }
    onChanged();
    if (rejected) onRejected();
  }

  static DeskActionResult _rejected(
    UuidValue actionId,
    DocketErrorCode? code,
    String message,
  ) => DeskActionResult(
    actionId: actionId,
    outcome: ActionOutcome.rejected,
    code: code,
    message: message,
  );

  void dispose() {
    _disposed = true;
    for (final id in _waiters.keys.toList()) {
      forget(id);
    }
  }
}
