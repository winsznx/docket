/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'package:serverpod_database/serverpod_database.dart' as _isd;
import '../enums/priority_reason.dart' as _ic48vmv6;
import '../enums/ticket_state.dart' as _imwmdlft;

abstract class LocalTicket
    implements _isd.TableRow<_isc.UuidValue?>, _isc.ProtocolSerialization {
  LocalTicket._({
    _isc.UuidValue? id,
    required this.lineId,
    required this.label,
    required this.displayName,
    required this.state,
    required this.priorityRank,
    this.priorityReason,
    required this.sortKey,
    this.roomId,
    this.calledAt,
    int? callVersion,
    int? reslotCount,
    required this.isDemo,
    bool? pendingSync,
    required this.updatedAt,
  }) : id = id ?? const _isc.Uuid().v7obj(),
       callVersion = callVersion ?? 0,
       reslotCount = reslotCount ?? 0,
       pendingSync = pendingSync ?? false;

  factory LocalTicket({
    _isc.UuidValue? id,
    required _isc.UuidValue lineId,
    required String label,
    required String displayName,
    required _imwmdlft.TicketState state,
    required int priorityRank,
    _ic48vmv6.PriorityReason? priorityReason,
    required double sortKey,
    _isc.UuidValue? roomId,
    DateTime? calledAt,
    int? callVersion,
    int? reslotCount,
    required bool isDemo,
    bool? pendingSync,
    required DateTime updatedAt,
  }) = _LocalTicketImpl;

  factory LocalTicket.fromJson(Map<String, dynamic> jsonSerialization) {
    return LocalTicket(
      id: jsonSerialization['id'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      lineId: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['lineId']),
      label: jsonSerialization['label'] as String,
      displayName: jsonSerialization['displayName'] as String,
      state: _imwmdlft.TicketState.fromJson(
        (jsonSerialization['state'] as String),
      ),
      priorityRank: jsonSerialization['priorityRank'] as int,
      priorityReason: jsonSerialization['priorityReason'] == null
          ? null
          : _ic48vmv6.PriorityReason.fromJson(
              (jsonSerialization['priorityReason'] as String),
            ),
      sortKey: (jsonSerialization['sortKey'] as num).toDouble(),
      roomId: jsonSerialization['roomId'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['roomId']),
      calledAt: jsonSerialization['calledAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['calledAt']),
      callVersion: jsonSerialization['callVersion'] as int?,
      reslotCount: jsonSerialization['reslotCount'] as int?,
      isDemo: _isc.BoolJsonExtension.fromJson(jsonSerialization['isDemo']),
      pendingSync: jsonSerialization['pendingSync'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['pendingSync']),
      updatedAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  static final t = LocalTicketTable();

  static const db = LocalTicketRepository._();

  @override
  _isc.UuidValue? id;

  _isc.UuidValue lineId;

  String label;

  String displayName;

  _imwmdlft.TicketState state;

  int priorityRank;

  _ic48vmv6.PriorityReason? priorityReason;

  double sortKey;

  _isc.UuidValue? roomId;

  DateTime? calledAt;

  int callVersion;

  int reslotCount;

  bool isDemo;

  bool pendingSync;

  DateTime updatedAt;

  @override
  _isd.Table<_isc.UuidValue?> get table => t;

  /// Returns a shallow copy of this [LocalTicket]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  LocalTicket copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? lineId,
    String? label,
    String? displayName,
    _imwmdlft.TicketState? state,
    int? priorityRank,
    _ic48vmv6.PriorityReason? priorityReason,
    double? sortKey,
    _isc.UuidValue? roomId,
    DateTime? calledAt,
    int? callVersion,
    int? reslotCount,
    bool? isDemo,
    bool? pendingSync,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'LocalTicket',
      if (id != null) 'id': id?.toJson(),
      'lineId': lineId.toJson(),
      'label': label,
      'displayName': displayName,
      'state': state.toJson(),
      'priorityRank': priorityRank,
      if (priorityReason != null) 'priorityReason': priorityReason?.toJson(),
      'sortKey': sortKey,
      if (roomId != null) 'roomId': roomId?.toJson(),
      if (calledAt != null) 'calledAt': calledAt?.toJson(),
      'callVersion': callVersion,
      'reslotCount': reslotCount,
      'isDemo': isDemo,
      'pendingSync': pendingSync,
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'LocalTicket',
      if (id != null) 'id': id?.toJson(),
      'lineId': lineId.toJson(),
      'label': label,
      'displayName': displayName,
      'state': state.toJson(),
      'priorityRank': priorityRank,
      if (priorityReason != null) 'priorityReason': priorityReason?.toJson(),
      'sortKey': sortKey,
      if (roomId != null) 'roomId': roomId?.toJson(),
      if (calledAt != null) 'calledAt': calledAt?.toJson(),
      'callVersion': callVersion,
      'reslotCount': reslotCount,
      'isDemo': isDemo,
      'pendingSync': pendingSync,
      'updatedAt': updatedAt.toJson(),
    };
  }

  static LocalTicketInclude include() {
    return LocalTicketInclude._();
  }

  static LocalTicketIncludeList includeList({
    _isd.WhereExpressionBuilder<LocalTicketTable>? where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<LocalTicketTable>? orderBy,
    _isd.OrderByListBuilder<LocalTicketTable>? orderByList,
    LocalTicketInclude? include,
  }) {
    return LocalTicketIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(LocalTicket.t),
      orderByList: orderByList?.call(LocalTicket.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _LocalTicketImpl extends LocalTicket {
  _LocalTicketImpl({
    _isc.UuidValue? id,
    required _isc.UuidValue lineId,
    required String label,
    required String displayName,
    required _imwmdlft.TicketState state,
    required int priorityRank,
    _ic48vmv6.PriorityReason? priorityReason,
    required double sortKey,
    _isc.UuidValue? roomId,
    DateTime? calledAt,
    int? callVersion,
    int? reslotCount,
    required bool isDemo,
    bool? pendingSync,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         lineId: lineId,
         label: label,
         displayName: displayName,
         state: state,
         priorityRank: priorityRank,
         priorityReason: priorityReason,
         sortKey: sortKey,
         roomId: roomId,
         calledAt: calledAt,
         callVersion: callVersion,
         reslotCount: reslotCount,
         isDemo: isDemo,
         pendingSync: pendingSync,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [LocalTicket]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  LocalTicket copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? lineId,
    String? label,
    String? displayName,
    _imwmdlft.TicketState? state,
    int? priorityRank,
    Object? priorityReason = _Undefined,
    double? sortKey,
    Object? roomId = _Undefined,
    Object? calledAt = _Undefined,
    int? callVersion,
    int? reslotCount,
    bool? isDemo,
    bool? pendingSync,
    DateTime? updatedAt,
  }) {
    return LocalTicket(
      id: id is _isc.UuidValue? ? id : this.id,
      lineId: lineId ?? this.lineId,
      label: label ?? this.label,
      displayName: displayName ?? this.displayName,
      state: state ?? this.state,
      priorityRank: priorityRank ?? this.priorityRank,
      priorityReason: priorityReason is _ic48vmv6.PriorityReason?
          ? priorityReason
          : this.priorityReason,
      sortKey: sortKey ?? this.sortKey,
      roomId: roomId is _isc.UuidValue? ? roomId : this.roomId,
      calledAt: calledAt is DateTime? ? calledAt : this.calledAt,
      callVersion: callVersion ?? this.callVersion,
      reslotCount: reslotCount ?? this.reslotCount,
      isDemo: isDemo ?? this.isDemo,
      pendingSync: pendingSync ?? this.pendingSync,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class LocalTicketUpdateTable extends _isd.UpdateTable<LocalTicketTable> {
  LocalTicketUpdateTable(super.table);

  _isd.ColumnValue<_isc.UuidValue, _isc.UuidValue> lineId(
    _isc.UuidValue value,
  ) => _isd.ColumnValue(
    table.lineId,
    value,
  );

  _isd.ColumnValue<String, String> label(String value) => _isd.ColumnValue(
    table.label,
    value,
  );

  _isd.ColumnValue<String, String> displayName(String value) =>
      _isd.ColumnValue(
        table.displayName,
        value,
      );

  _isd.ColumnValue<_imwmdlft.TicketState, _imwmdlft.TicketState> state(
    _imwmdlft.TicketState value,
  ) => _isd.ColumnValue(
    table.state,
    value,
  );

  _isd.ColumnValue<int, int> priorityRank(int value) => _isd.ColumnValue(
    table.priorityRank,
    value,
  );

  _isd.ColumnValue<_ic48vmv6.PriorityReason, _ic48vmv6.PriorityReason>
  priorityReason(_ic48vmv6.PriorityReason? value) => _isd.ColumnValue(
    table.priorityReason,
    value,
  );

  _isd.ColumnValue<double, double> sortKey(double value) => _isd.ColumnValue(
    table.sortKey,
    value,
  );

  _isd.ColumnValue<_isc.UuidValue, _isc.UuidValue> roomId(
    _isc.UuidValue? value,
  ) => _isd.ColumnValue(
    table.roomId,
    value,
  );

  _isd.ColumnValue<DateTime, DateTime> calledAt(DateTime? value) =>
      _isd.ColumnValue(
        table.calledAt,
        value,
      );

  _isd.ColumnValue<int, int> callVersion(int value) => _isd.ColumnValue(
    table.callVersion,
    value,
  );

  _isd.ColumnValue<int, int> reslotCount(int value) => _isd.ColumnValue(
    table.reslotCount,
    value,
  );

  _isd.ColumnValue<bool, bool> isDemo(bool value) => _isd.ColumnValue(
    table.isDemo,
    value,
  );

  _isd.ColumnValue<bool, bool> pendingSync(bool value) => _isd.ColumnValue(
    table.pendingSync,
    value,
  );

  _isd.ColumnValue<DateTime, DateTime> updatedAt(DateTime value) =>
      _isd.ColumnValue(
        table.updatedAt,
        value,
      );
}

class LocalTicketTable extends _isd.Table<_isc.UuidValue?> {
  LocalTicketTable({super.tableRelation}) : super(tableName: 'local_ticket') {
    updateTable = LocalTicketUpdateTable(this);
    lineId = _isd.ColumnUuid(
      'lineId',
      this,
    );
    label = _isd.ColumnString(
      'label',
      this,
    );
    displayName = _isd.ColumnString(
      'displayName',
      this,
    );
    state = _isd.ColumnEnum(
      'state',
      this,
      _isd.EnumSerialization.byName,
    );
    priorityRank = _isd.ColumnInt(
      'priorityRank',
      this,
    );
    priorityReason = _isd.ColumnEnum(
      'priorityReason',
      this,
      _isd.EnumSerialization.byName,
    );
    sortKey = _isd.ColumnDouble(
      'sortKey',
      this,
    );
    roomId = _isd.ColumnUuid(
      'roomId',
      this,
    );
    calledAt = _isd.ColumnDateTime(
      'calledAt',
      this,
    );
    callVersion = _isd.ColumnInt(
      'callVersion',
      this,
      hasDefault: true,
    );
    reslotCount = _isd.ColumnInt(
      'reslotCount',
      this,
      hasDefault: true,
    );
    isDemo = _isd.ColumnBool(
      'isDemo',
      this,
    );
    pendingSync = _isd.ColumnBool(
      'pendingSync',
      this,
      hasDefault: true,
    );
    updatedAt = _isd.ColumnDateTime(
      'updatedAt',
      this,
    );
  }

  late final LocalTicketUpdateTable updateTable;

  late final _isd.ColumnUuid lineId;

  late final _isd.ColumnString label;

  late final _isd.ColumnString displayName;

  late final _isd.ColumnEnum<_imwmdlft.TicketState> state;

  late final _isd.ColumnInt priorityRank;

  late final _isd.ColumnEnum<_ic48vmv6.PriorityReason> priorityReason;

  late final _isd.ColumnDouble sortKey;

  late final _isd.ColumnUuid roomId;

  late final _isd.ColumnDateTime calledAt;

  late final _isd.ColumnInt callVersion;

  late final _isd.ColumnInt reslotCount;

  late final _isd.ColumnBool isDemo;

  late final _isd.ColumnBool pendingSync;

  late final _isd.ColumnDateTime updatedAt;

  @override
  List<_isd.Column> get columns => [
    id,
    lineId,
    label,
    displayName,
    state,
    priorityRank,
    priorityReason,
    sortKey,
    roomId,
    calledAt,
    callVersion,
    reslotCount,
    isDemo,
    pendingSync,
    updatedAt,
  ];
}

class LocalTicketInclude extends _isd.IncludeObject {
  LocalTicketInclude._();

  @override
  Map<String, _isd.Include?> get includes => {};

  @override
  _isd.Table<_isc.UuidValue?> get table => LocalTicket.t;
}

class LocalTicketIncludeList extends _isd.IncludeList {
  LocalTicketIncludeList._({
    _isd.WhereExpressionBuilder<LocalTicketTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(LocalTicket.t);
  }

  @override
  Map<String, _isd.Include?> get includes => include?.includes ?? {};

  @override
  _isd.Table<_isc.UuidValue?> get table => LocalTicket.t;
}

class LocalTicketRepository {
  const LocalTicketRepository._();

  /// Returns a list of [LocalTicket]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<LocalTicket>> find(
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<LocalTicketTable>? where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<LocalTicketTable>? orderBy,
    _isd.OrderByListBuilder<LocalTicketTable>? orderByList,
    _isd.Transaction? transaction,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<LocalTicket>(
      where: where?.call(LocalTicket.t),
      orderBy: orderBy?.call(LocalTicket.t),
      orderByList: orderByList?.call(LocalTicket.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [LocalTicket] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<LocalTicket?> findFirstRow(
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<LocalTicketTable>? where,
    int? offset,
    _isd.OrderByBuilder<LocalTicketTable>? orderBy,
    _isd.OrderByListBuilder<LocalTicketTable>? orderByList,
    _isd.Transaction? transaction,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<LocalTicket>(
      where: where?.call(LocalTicket.t),
      orderBy: orderBy?.call(LocalTicket.t),
      orderByList: orderByList?.call(LocalTicket.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [LocalTicket] by its [id] or null if no such row exists.
  Future<LocalTicket?> findById(
    _isd.DatabaseSession session,
    _isc.UuidValue id, {
    _isd.Transaction? transaction,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<LocalTicket>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [LocalTicket]s in the list and returns the inserted rows.
  ///
  /// The returned [LocalTicket]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  ///
  /// If [noReturn] is set to `true`, the inserted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<LocalTicket>> insert(
    _isd.DatabaseSession session,
    List<LocalTicket> rows, {
    _isd.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<LocalTicket>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [LocalTicket] and returns the inserted row.
  ///
  /// The returned [LocalTicket] will have its `id` field set.
  Future<LocalTicket> insertRow(
    _isd.DatabaseSession session,
    LocalTicket row, {
    _isd.Transaction? transaction,
  }) async {
    return session.db.insertRow<LocalTicket>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [LocalTicket]s in the list and returns the resulting rows.
  ///
  /// If a row conflicts on the given [conflictColumns], the existing row is
  /// updated with the new values. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies to rows matching the
  /// given expression. Conflicting rows that don't match are skipped and not
  /// returned, so the resulting list may be shorter than [rows].
  ///
  /// The returned [LocalTicket]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<LocalTicket>> upsert(
    _isd.DatabaseSession session,
    List<LocalTicket> rows, {
    required _isd.ColumnSelections<LocalTicketTable> conflictColumns,
    _isd.ColumnSelections<LocalTicketTable>? updateColumns,
    _isd.WhereExpressionBuilder<LocalTicketTable>? updateWhere,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<LocalTicket>(
      rows,
      conflictColumns: conflictColumns(LocalTicket.t),
      updateColumns: updateColumns?.call(LocalTicket.t),
      updateWhere: updateWhere?.call(LocalTicket.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [LocalTicket] and returns the resulting row.
  ///
  /// If the row conflicts on the given [conflictColumns], the existing row is
  /// updated. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies when the existing
  /// row matches the expression. Returns `null` if no row was affected — for
  /// example when [updateWhere] does not match the conflicting row.
  ///
  /// The returned [LocalTicket] will have its `id` field set.
  Future<LocalTicket?> upsertRow(
    _isd.DatabaseSession session,
    LocalTicket row, {
    required _isd.ColumnSelections<LocalTicketTable> conflictColumns,
    _isd.ColumnSelections<LocalTicketTable>? updateColumns,
    _isd.WhereExpressionBuilder<LocalTicketTable>? updateWhere,
    _isd.Transaction? transaction,
  }) async {
    return session.db.upsertRow<LocalTicket>(
      row,
      conflictColumns: conflictColumns(LocalTicket.t),
      updateColumns: updateColumns?.call(LocalTicket.t),
      updateWhere: updateWhere?.call(LocalTicket.t),
      transaction: transaction,
    );
  }

  /// Updates all [LocalTicket]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<LocalTicket>> update(
    _isd.DatabaseSession session,
    List<LocalTicket> rows, {
    _isd.ColumnSelections<LocalTicketTable>? columns,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<LocalTicket>(
      rows,
      columns: columns?.call(LocalTicket.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [LocalTicket]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<LocalTicket> updateRow(
    _isd.DatabaseSession session,
    LocalTicket row, {
    _isd.ColumnSelections<LocalTicketTable>? columns,
    _isd.Transaction? transaction,
  }) async {
    return session.db.updateRow<LocalTicket>(
      row,
      columns: columns?.call(LocalTicket.t),
      transaction: transaction,
    );
  }

  /// Updates a single [LocalTicket] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<LocalTicket?> updateById(
    _isd.DatabaseSession session,
    _isc.UuidValue id, {
    required _isd.ColumnValueListBuilder<LocalTicketUpdateTable> columnValues,
    _isd.Transaction? transaction,
  }) async {
    return session.db.updateById<LocalTicket>(
      id,
      columnValues: columnValues(LocalTicket.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [LocalTicket]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<LocalTicket>> updateWhere(
    _isd.DatabaseSession session, {
    required _isd.ColumnValueListBuilder<LocalTicketUpdateTable> columnValues,
    required _isd.WhereExpressionBuilder<LocalTicketTable> where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<LocalTicketTable>? orderBy,
    _isd.OrderByListBuilder<LocalTicketTable>? orderByList,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<LocalTicket>(
      columnValues: columnValues(LocalTicket.t.updateTable),
      where: where(LocalTicket.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(LocalTicket.t),
      orderByList: orderByList?.call(LocalTicket.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [LocalTicket]s in the list and returns the deleted rows.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<LocalTicket>> delete(
    _isd.DatabaseSession session,
    List<LocalTicket> rows, {
    _isd.OrderByBuilder<LocalTicketTable>? orderBy,
    _isd.OrderByListBuilder<LocalTicketTable>? orderByList,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<LocalTicket>(
      rows,
      orderBy: orderBy?.call(LocalTicket.t),
      orderByList: orderByList?.call(LocalTicket.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [LocalTicket].
  Future<LocalTicket> deleteRow(
    _isd.DatabaseSession session,
    LocalTicket row, {
    _isd.Transaction? transaction,
  }) async {
    return session.db.deleteRow<LocalTicket>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<LocalTicket>> deleteWhere(
    _isd.DatabaseSession session, {
    required _isd.WhereExpressionBuilder<LocalTicketTable> where,
    _isd.OrderByBuilder<LocalTicketTable>? orderBy,
    _isd.OrderByListBuilder<LocalTicketTable>? orderByList,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<LocalTicket>(
      where: where(LocalTicket.t),
      orderBy: orderBy?.call(LocalTicket.t),
      orderByList: orderByList?.call(LocalTicket.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<LocalTicketTable>? where,
    int? limit,
    _isd.Transaction? transaction,
  }) async {
    return session.db.count<LocalTicket>(
      where: where?.call(LocalTicket.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [LocalTicket] rows matching the [where] expression.
  Future<void> lockRows(
    _isd.DatabaseSession session, {
    required _isd.WhereExpressionBuilder<LocalTicketTable> where,
    required _isd.LockMode lockMode,
    required _isd.Transaction transaction,
    _isd.LockBehavior lockBehavior = _isd.LockBehavior.wait,
  }) async {
    return session.db.lockRows<LocalTicket>(
      where: where(LocalTicket.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
