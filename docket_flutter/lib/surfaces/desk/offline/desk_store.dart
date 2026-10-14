import 'dart:convert';

import 'package:docket_client/docket_client.dart' hide Notification;
import 'package:serverpod_database/serverpod_database.dart'
    show ClientDatabaseSession;

import '../../../shared/local_db.dart';
import '../../../shared/strings.dart';
import 'local_rules.dart';

/// The fields every desk action carries, minted on this device (PRD 8.5).
typedef ActionStamp = ({
  UuidValue actionId,
  UuidValue deviceId,
  int seq,
  DateTime issuedAtLocal,
});

/// The desk's tables in the browser's SQLite database: the device identity,
/// the local mirror of the clinic's tickets and the outbox (PRD 8.4, 15).
///
/// Every change runs in one client-database transaction, so a crash or a
/// second tab never sees half of it.
class DeskStore {
  DeskStore._(this._db, this.deviceId);

  final ClientDatabaseSession _db;

  /// This device's id, a UUID v7 made on first run and kept (PRD 15.7).
  final UuidValue deviceId;

  /// Settled actions the server accepted are kept this long for reference.
  static const keepSettled = Duration(days: 1);

  static final _protocol = Protocol();

  static Future<DeskStore> open() async {
    final db = await LocalDb.open();
    final meta = await db.db.transaction((tx) async {
      final existing = await DeskMeta.db.findFirstRow(
        db,
        orderBy: (t) => t.id,
        transaction: tx,
      );
      return existing ??
          await DeskMeta.db.insertRow(
            db,
            DeskMeta(deviceId: UuidValue.fromString(const Uuid().v7())),
            transaction: tx,
          );
    });
    final before = DateTime.now().toUtc().subtract(keepSettled);
    await OutboxAction.db.deleteWhere(
      db,
      where: (t) =>
          t.outcome.inSet({ActionOutcome.applied, ActionOutcome.duplicate}) &
          (t.settledAt < before),
    );
    return DeskStore._(db, meta.deviceId);
  }

  Future<DeskMeta> meta() async => (await DeskMeta.db.findFirstRow(
    _db,
    orderBy: (t) => t.id,
  ))!;

  /// Points the mirror at [clinicId]. Moving to a different clinic clears
  /// the mirror, and any action still waiting for the old clinic is settled
  /// as never sent, so it shows up for review instead of vanishing.
  Future<DeskMeta> useClinic(UuidValue clinicId) => _db.db.transaction((
    tx,
  ) async {
    final meta = (await DeskMeta.db.findFirstRow(
      _db,
      orderBy: (t) => t.id,
      transaction: tx,
    ))!;
    if (meta.clinicId == clinicId) return meta;
    await LocalTicket.db.deleteWhere(
      _db,
      where: (t) => t.id.notEquals(null),
      transaction: tx,
    );
    if (meta.clinicId != null) {
      final stranded = await OutboxAction.db.find(
        _db,
        where: (t) => t.outcome.equals(null),
        transaction: tx,
      );
      final now = DateTime.now().toUtc();
      await OutboxAction.db.update(_db, [
        for (final row in stranded)
          row.copyWith(
            outcome: ActionOutcome.rejected,
            code: DocketErrorCode.validation,
            message: DeskStrings.otherClinic,
            settledAt: now,
          ),
      ], transaction: tx);
    }
    return DeskMeta.db.updateRow(
      _db,
      meta.copyWith(
        clinicId: clinicId,
        roomId: null,
        lastViewJson: null,
        lastSnapshotAt: null,
        lineVersionsJson: '{}',
      ),
      transaction: tx,
    );
  });

  Future<void> useRoom(UuidValue roomId) async {
    final current = await meta();
    await DeskMeta.db.updateRow(_db, current.copyWith(roomId: roomId));
  }

  /// The last server view this device saw for [meta]'s clinic, so a reload
  /// while offline still draws the desk.
  DeskView? lastView(DeskMeta meta) {
    final raw = meta.lastViewJson;
    if (raw == null) return null;
    return _protocol.deserialize<DeskView>(jsonDecode(raw));
  }

  Future<List<LocalTicket>> tickets() => LocalTicket.db.find(_db);

  /// Actions not yet answered by the server, in `seq` order.
  Future<List<OutboxAction>> unsettled() => OutboxAction.db.find(
    _db,
    where: (t) => t.outcome.equals(null),
    orderBy: (t) => t.seq,
  );

  /// Actions the server turned down that nobody has dismissed yet.
  Future<List<OutboxAction>> rejected() => OutboxAction.db.find(
    _db,
    where: (t) => t.outcome.equals(ActionOutcome.rejected),
    orderBy: (t) => t.seq,
  );

  DeskAction decode(OutboxAction row) =>
      _protocol.deserialize<DeskAction>(jsonDecode(row.actionJson));

  /// PRD 15.1: one transaction upserts every ticket of the clinic's lines and
  /// deletes rows the server no longer lists. Rows still `pendingSync` stay
  /// as they are while their actions are in flight, so a view built before
  /// the server applied them can't undo what the desk already shows. Once
  /// nothing is in flight, the server's view wins outright.
  Future<void> mirror(
    DeskView view, {
    required bool keepPending,
  }) => _db.db.transaction((tx) async {
    final inFlight = await OutboxAction.db.count(
      _db,
      where: (t) => t.outcome.equals(null),
      transaction: tx,
    );
    final keep = keepPending || inFlight > 0;
    final local = {
      for (final t in await LocalTicket.db.find(_db, transaction: tx)) t.id!: t,
    };
    final now = DateTime.now().toUtc();
    final incoming = [
      for (final line in view.lines) ...line.tickets,
    ];
    final listed = {for (final t in incoming) t.id};
    final rows = [
      for (final t in incoming)
        if (!(keep && (local[t.id]?.pendingSync ?? false))) _fromServer(t, now),
    ];
    final gone = [
      for (final t in local.values)
        if (!listed.contains(t.id) && !(keep && t.pendingSync)) t,
    ];
    if (gone.isNotEmpty) {
      await LocalTicket.db.delete(_db, gone, transaction: tx);
    }
    if (rows.isNotEmpty) {
      await LocalTicket.db.upsert(
        _db,
        rows,
        conflictColumns: (t) => [t.id],
        transaction: tx,
        noReturn: true,
      );
    }
    final meta = (await DeskMeta.db.findFirstRow(
      _db,
      orderBy: (t) => t.id,
      transaction: tx,
    ))!;
    await DeskMeta.db.updateRow(
      _db,
      meta.copyWith(
        lastViewJson: jsonEncode(view.toJson()),
        lineVersionsJson: jsonEncode({
          for (final line in view.lines) line.id.uuid: line.version,
        }),
        lastSnapshotAt: view.serverTime,
      ),
      transaction: tx,
    );
  });

  /// PRD 15.2: the action goes into the outbox first, then onto the local
  /// mirror, in the same transaction. `seq` comes from [DeskMeta.nextSeq],
  /// which only ever grows.
  Future<DeskAction> enqueue(
    UuidValue actionId,
    DeskAction Function(ActionStamp stamp) build,
    LocalContext context,
  ) => _db.db.transaction((tx) async {
    final meta = (await DeskMeta.db.findFirstRow(
      _db,
      orderBy: (t) => t.id,
      transaction: tx,
    ))!;
    await DeskMeta.db.updateRow(
      _db,
      meta.copyWith(nextSeq: meta.nextSeq + 1),
      transaction: tx,
    );
    final action = build((
      actionId: actionId,
      deviceId: meta.deviceId,
      seq: meta.nextSeq,
      issuedAtLocal: context.now,
    ));
    await OutboxAction.db.insertRow(
      _db,
      OutboxAction(
        id: action.actionId,
        seq: action.seq,
        actionJson: jsonEncode(action.toJson()),
        createdAt: context.now,
      ),
      transaction: tx,
    );
    final changes = LocalRules.apply(
      action,
      await LocalTicket.db.find(_db, transaction: tx),
      context,
    );
    if (changes.isNotEmpty) {
      await LocalTicket.db.upsert(
        _db,
        changes,
        conflictColumns: (t) => [t.id],
        transaction: tx,
        noReturn: true,
      );
    }
    return action;
  });

  /// Marks outbox rows settled with the server's answer. A duplicate of an
  /// action the server had turned down is still a rejection, so it lands in
  /// the corrections drawer instead of settling silently.
  Future<void> settle(List<DeskActionResult> results) =>
      _db.db.transaction((tx) async {
        final now = DateTime.now().toUtc();
        for (final result in results) {
          final row = await OutboxAction.db.findById(
            _db,
            result.actionId,
            transaction: tx,
          );
          if (row == null || row.outcome != null) continue;
          final outcome =
              result.outcome == ActionOutcome.duplicate && result.code != null
              ? ActionOutcome.rejected
              : result.outcome;
          await OutboxAction.db.updateRow(
            _db,
            row.copyWith(
              outcome: outcome,
              code: result.code,
              message: result.message,
              settledAt: now,
            ),
            transaction: tx,
          );
        }
      });

  Future<void> dismiss(UuidValue id) =>
      OutboxAction.db.deleteWhere(_db, where: (t) => t.id.equals(id));

  Future<void> dismissAllRejected() => OutboxAction.db.deleteWhere(
    _db,
    where: (t) => t.outcome.equals(ActionOutcome.rejected),
  );

  static LocalTicket _fromServer(TicketView t, DateTime now) => LocalTicket(
    id: t.id,
    lineId: t.lineId,
    label: t.label,
    displayName: t.displayName,
    state: t.state,
    priorityRank: t.priorityRank,
    priorityReason: t.priorityReason,
    sortKey: t.sortKey,
    roomId: t.roomId,
    calledAt: t.calledAt,
    callVersion: t.callVersion,
    reslotCount: t.reslotCount,
    isDemo: t.isDemo,
    pendingSync: false,
    updatedAt: now,
  );
}
