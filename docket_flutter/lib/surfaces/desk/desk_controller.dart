import 'dart:async';

import 'package:docket_client/docket_client.dart' hide Notification;
import 'package:flutter/foundation.dart';

import '../../client.dart';
import '../../shared/live_stream.dart';
import '../../shared/server_clock.dart';
import 'desk_access.dart';
import 'desk_board.dart';
import 'offline/browser_network.dart';
import 'offline/desk_store.dart';
import 'offline/local_rules.dart';
import 'offline/outbox_engine.dart';

/// The desk's connection as PRD 5.4 names it.
enum DeskConnection { online, offline, syncing }

/// An action the server turned down, waiting in the corrections drawer.
class Correction {
  const Correction(this.row, this.action);

  final OutboxAction row;
  final DeskAction action;

  UuidValue get id => row.id!;
  String get message => row.message ?? '';
}

/// Runs one desk: the live view, the local mirror, the outbox and its sync,
/// the heartbeat and the connection state (PRD 15 and 17.3).
///
/// Every action takes the same path whatever the connection: written to the
/// outbox, applied to the mirror, then sent when the server can hear it.
class DeskController extends ChangeNotifier {
  DeskController(this.access);

  final DeskAccess access;

  static const heartbeatEvery = Duration(seconds: 15);

  /// How long a dropped stream may keep failing before the desk calls itself
  /// offline (PRD 5.4).
  static const offlineAfter = Duration(seconds: 5);

  static const demoBatch = 5;

  DeskStore? _store;
  OutboxEngine? _engine;
  LiveStream<DeskView>? _live;
  BrowserNetwork? _network;
  Timer? _heartbeat;
  Timer? _downTimer;
  bool _disposed = false;

  DeskView? _view;
  List<LocalTicket> _tickets = const [];
  List<DeskAction> _pending = const [];
  DateTime? _latestServerTime;
  int _reloadSeq = 0;
  bool _smsChecked = false;

  bool _browserOnline = true;
  bool _streamDown = false;

  final _rejections = StreamController<void>.broadcast();

  /// Fires when the server turns down an action, so the drawer can open.
  Stream<void> get rejections => _rejections.stream;

  /// Null until the first view, from the server or from this device's copy.
  DeskBoard? board;

  UuidValue? roomId;

  List<Correction> corrections = const [];

  /// The clinic sends texts, so the add sheets offer a phone field.
  bool smsEnabled = false;

  /// A refusal no retry can fix, such as an expired sandbox.
  DocketException? fatal;

  /// The local database couldn't open.
  Object? openError;

  bool opened = false;

  int get pendingCount => _pending.length;

  bool get canSend => _browserOnline && !_streamDown;

  DeskConnection get connection {
    if (!canSend) return DeskConnection.offline;
    if ((_engine?.needsSync ?? false) && _pending.isNotEmpty) {
      return DeskConnection.syncing;
    }
    return DeskConnection.online;
  }

  Future<void> open() async {
    try {
      final store = await DeskStore.open();
      final meta = await store.useClinic(access.clinicId);
      _store = store;
      _view = store.lastView(meta);
      _latestServerTime = _view?.serverTime;
      roomId = meta.roomId;
    } on Object catch (e, stack) {
      debugPrint('Docket desk storage failed to open: $e\n$stack');
      openError = e;
      _notify();
      return;
    }
    if (_disposed) return;

    final store = _store!;
    _engine = OutboxEngine(
      store: store,
      act: (action) => client.desk.act(action, access.sandboxToken),
      sync: (batch) => client.desk.sync(batch, access.sandboxToken),
      fetchView: () =>
          client.desk.getView(access.clinicId, access.sandboxToken),
      canSend: () => canSend,
      applyView: _applyView,
      onChanged: () => unawaited(_reload()),
      onRejected: () => _rejections.add(null),
    );
    _network = BrowserNetwork(_onNetwork)..start();
    _browserOnline = _network!.online;

    await _reload();
    if (_pending.isNotEmpty || !_browserOnline) _engine!.markOffline();
    _ensureRoom();
    opened = true;
    _notify();

    _live = LiveStream<DeskView>(
      snapshot: () => client.desk.getView(access.clinicId, access.sandboxToken),
      open: () => client.desk.watch(
        access.clinicId,
        store.deviceId,
        access.sandboxToken,
      ),
      onValue: (view) => unawaited(
        _applyView(view, keepPending: _engine?.running ?? false),
      ),
      onFatal: _fatal,
    )..addListener(_onLiveState);
    _live!.start();
    _heartbeat = Timer.periodic(heartbeatEvery, (_) => unawaited(_beat()));
    unawaited(_beat());
  }

  bool _fatal(Object error) {
    if (error is! DocketException) return false;
    const fatalCodes = {
      DocketErrorCode.notStaff,
      DocketErrorCode.sandboxExpired,
      DocketErrorCode.clinicNotFound,
    };
    if (!fatalCodes.contains(error.code)) return false;
    fatal = error;
    _notify();
    return true;
  }

  void _onLiveState() {
    final live = _live;
    if (live == null) return;
    if (live.state == LiveState.live) {
      _downTimer?.cancel();
      _downTimer = null;
      if (_streamDown) {
        _streamDown = false;
        _notify();
      }
      if (_pending.isNotEmpty) unawaited(_engine?.kick());
    } else if (live.state == LiveState.stale && _downTimer == null) {
      _downTimer = Timer(offlineAfter, () {
        _downTimer = null;
        if (_live?.state == LiveState.live) return;
        _streamDown = true;
        _engine?.markOffline();
        _notify();
      });
    }
  }

  void _onNetwork(bool online) {
    _browserOnline = online;
    if (online) {
      _live?.reconnectNow();
      unawaited(_engine?.kick());
      unawaited(_beat());
    } else {
      _engine?.markOffline();
    }
    _notify();
  }

  /// Takes a server view into the mirror. Views can arrive out of order,
  /// from the stream, a sync or a refresh, so an older one than the last is
  /// never mirrored. The mirror write starts before any await, which keeps
  /// the database writes in the order the views were accepted.
  Future<void> _applyView(DeskView view, {required bool keepPending}) async {
    final store = _store;
    final latest = _latestServerTime;
    var target = view;
    if (latest != null && view.serverTime.isBefore(latest)) {
      // A newer view already arrived, built after this one, so it holds
      // everything this one does. A settling caller still needs its pending
      // rows replaced, so the newer view settles them instead.
      final newer = _view;
      if (keepPending || newer == null) return;
      target = newer;
    } else {
      _latestServerTime = view.serverTime;
      ServerClock.instance.observe(view.serverTime);
      _view = view;
    }
    if (store == null) return;
    await store.mirror(target, keepPending: keepPending);
    _ensureRoom();
    if (!_smsChecked) {
      _smsChecked = true;
      unawaited(_loadSms());
    }
    await _reload();
  }

  Future<void> _reload() async {
    final store = _store;
    if (store == null || _disposed) return;
    final mine = ++_reloadSeq;
    final tickets = await store.tickets();
    final unsettled = await store.unsettled();
    final rejected = await store.rejected();
    if (mine != _reloadSeq || _disposed) return;
    _tickets = tickets;
    _pending = [for (final row in unsettled) store.decode(row)];
    corrections = [
      for (final row in rejected) Correction(row, store.decode(row)),
    ];
    _compose();
    _notify();
  }

  void _compose() {
    final view = _view;
    board = view == null
        ? null
        : DeskBoard.compose(
            view: view,
            tickets: _tickets,
            pending: _pending,
            roomId: roomId,
          );
  }

  /// Keeps the remembered room when it's still in the clinic. A sandbox, or a
  /// clinic with one room, starts on its first room so the desk opens ready.
  void _ensureRoom() {
    final view = _view;
    if (view == null) return;
    final ids = {for (final r in view.rooms) r.id};
    if (roomId != null && ids.contains(roomId)) return;
    roomId = null;
    if (view.rooms.isNotEmpty && (access.isSandbox || view.rooms.length == 1)) {
      unawaited(selectRoom(view.rooms.first.id));
    } else {
      _compose();
    }
  }

  Future<void> selectRoom(UuidValue id) async {
    roomId = id;
    _compose();
    _notify();
    await _store?.useRoom(id);
    unawaited(_beat());
  }

  Future<void> _loadSms() async {
    final view = _view;
    if (view == null || view.isSandbox) return;
    try {
      final info = await client.publicClinic.getClinic(view.clinicSlug);
      smsEnabled = info.smsEnabled;
      _notify();
    } on Exception catch (e) {
      _smsChecked = false;
      debugPrint('Desk could not read whether the clinic sends texts: $e');
    }
  }

  Future<void> _beat() async {
    final store = _store;
    if (store == null || !canSend || _disposed) return;
    try {
      await client.desk.heartbeat(
        access.clinicId,
        store.deviceId,
        roomId,
        access.sandboxToken,
      );
    } on Exception catch (e) {
      debugPrint('Desk heartbeat missed: $e');
    }
    if (_pending.isNotEmpty) unawaited(_engine?.kick());
  }

  /// Writes an action to the outbox and the mirror, then sends it when the
  /// server can hear it. Completes with the server's answer when online, or
  /// null when the action waits for the connection.
  Future<DeskActionResult?> _submit(
    DeskAction Function(ActionStamp stamp) build,
  ) async {
    final store = _store;
    final engine = _engine;
    final view = _view;
    if (store == null || engine == null || view == null) return null;
    // The answer is awaited before the action exists, so a drain already
    // running can't settle it unseen.
    final actionId = _mint();
    final answer = engine.resultOf(actionId);
    await store.enqueue(
      actionId,
      build,
      LocalContext(
        roomLines: {for (final r in view.rooms) r.id: r.lineId},
        lineCodes: {for (final l in view.lines) l.id: l.code},
        now: DateTime.now().toUtc(),
        reslotOffset: view.reslotOffset,
        maxReslots: view.maxReslots,
      ),
    );
    if (!canSend) engine.forget(actionId);
    await _reload();
    unawaited(engine.kick());
    return answer;
  }

  /// A new ticket's id, minted here so the mirror can show it at once and
  /// the server accepts the same id on replay (PRD 8.5).
  static UuidValue _mint() => UuidValue.fromString(const Uuid().v7());

  Future<void> callNext() async {
    final room = board?.room;
    if (room == null || board!.callNextBlock != null) return;
    await _submit(
      (s) => CallNextAction(
        actionId: s.actionId,
        deviceId: s.deviceId,
        seq: s.seq,
        issuedAtLocal: s.issuedAtLocal,
        roomId: room.id,
      ),
    );
  }

  Future<void> callSpecific(UuidValue ticketId) async {
    final room = board?.room;
    if (room == null) return;
    await _submit(
      (s) => CallSpecificAction(
        actionId: s.actionId,
        deviceId: s.deviceId,
        seq: s.seq,
        issuedAtLocal: s.issuedAtLocal,
        roomId: room.id,
        ticketId: ticketId,
      ),
    );
  }

  Future<void> recall(UuidValue ticketId) => _submit(
    (s) => RecallAction(
      actionId: s.actionId,
      deviceId: s.deviceId,
      seq: s.seq,
      issuedAtLocal: s.issuedAtLocal,
      ticketId: ticketId,
    ),
  );

  Future<void> startService(UuidValue ticketId) async {
    final room = board?.room;
    if (room == null) return;
    await _submit(
      (s) => StartServiceAction(
        actionId: s.actionId,
        deviceId: s.deviceId,
        seq: s.seq,
        issuedAtLocal: s.issuedAtLocal,
        ticketId: ticketId,
        roomId: room.id,
      ),
    );
  }

  Future<void> finish(UuidValue ticketId) => _submit(
    (s) => FinishAction(
      actionId: s.actionId,
      deviceId: s.deviceId,
      seq: s.seq,
      issuedAtLocal: s.issuedAtLocal,
      ticketId: ticketId,
    ),
  );

  Future<void> noShow(UuidValue ticketId) => _submit(
    (s) => MarkNoShowAction(
      actionId: s.actionId,
      deviceId: s.deviceId,
      seq: s.seq,
      issuedAtLocal: s.issuedAtLocal,
      ticketId: ticketId,
    ),
  );

  Future<void> remove(UuidValue ticketId, String reason) => _submit(
    (s) => RemoveAction(
      actionId: s.actionId,
      deviceId: s.deviceId,
      seq: s.seq,
      issuedAtLocal: s.issuedAtLocal,
      ticketId: ticketId,
      reason: reason,
    ),
  );

  Future<DeskActionResult?> addWalkIn({
    required UuidValue lineId,
    required String displayName,
    String? phoneE164,
  }) => _submit(
    (s) => AddWalkInAction(
      actionId: s.actionId,
      deviceId: s.deviceId,
      seq: s.seq,
      issuedAtLocal: s.issuedAtLocal,
      ticketId: _mint(),
      lineId: lineId,
      displayName: displayName,
      phoneE164: phoneE164,
    ),
  );

  Future<DeskActionResult?> addPriority({
    required UuidValue lineId,
    required String displayName,
    required PriorityReason reason,
    String? note,
    String? phoneE164,
  }) => _submit(
    (s) => AddPriorityAction(
      actionId: s.actionId,
      deviceId: s.deviceId,
      seq: s.seq,
      issuedAtLocal: s.issuedAtLocal,
      ticketId: _mint(),
      lineId: lineId,
      displayName: displayName,
      reason: reason,
      note: note,
      phoneE164: phoneE164,
    ),
  );

  Future<void> transfer(UuidValue ticketId, UuidValue targetLineId) => _submit(
    (s) => TransferAction(
      actionId: s.actionId,
      deviceId: s.deviceId,
      seq: s.seq,
      issuedAtLocal: s.issuedAtLocal,
      ticketId: ticketId,
      targetLineId: targetLineId,
      newTicketId: _mint(),
    ),
  );

  Future<void> setRoomState(RoomState state) async {
    final room = board?.room;
    if (room == null || room.state == state) return;
    await _submit(
      (s) => SetRoomStateAction(
        actionId: s.actionId,
        deviceId: s.deviceId,
        seq: s.seq,
        issuedAtLocal: s.issuedAtLocal,
        roomId: room.id,
        state: state,
      ),
    );
  }

  Future<void> closeDay() => _submit(
    (s) => CloseDayAction(
      actionId: s.actionId,
      deviceId: s.deviceId,
      seq: s.seq,
      issuedAtLocal: s.issuedAtLocal,
      clinicId: access.clinicId,
    ),
  );

  /// A fresh ticket link for a patient's phone. The server rotates the
  /// token, so the old link stops working (PRD 18).
  Future<String> linkPhone(UuidValue ticketId) =>
      client.desk.linkPhone(ticketId, access.sandboxToken);

  /// PRD 9.7: demo patients through the normal join path, labelled DEMO.
  Future<void> addDemoWalkIns() async {
    final token = access.sandboxToken;
    final lineId = board?.room?.lineId;
    if (token == null || lineId == null) return;
    final view = await client.sandbox.addDemoWalkIns(token, lineId, demoBatch);
    await _applyView(view, keepPending: _engine?.running ?? false);
  }

  Future<void> dismiss(Correction correction) async {
    await _store?.dismiss(correction.id);
    await _reload();
  }

  /// Dismisses a rejection the person already saw where they acted.
  Future<void> dismissAction(UuidValue actionId) async {
    await _store?.dismiss(actionId);
    await _reload();
  }

  Future<void> dismissAll() async {
    await _store?.dismissAllRejected();
    await _reload();
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _heartbeat?.cancel();
    _downTimer?.cancel();
    _live?.removeListener(_onLiveState);
    _live?.dispose();
    _network?.dispose();
    _engine?.dispose();
    unawaited(_rejections.close());
    super.dispose();
  }
}
