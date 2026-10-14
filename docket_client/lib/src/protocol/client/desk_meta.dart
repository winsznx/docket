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

abstract class DeskMeta
    implements _isd.TableRow<int?>, _isc.ProtocolSerialization {
  DeskMeta._({
    this.id,
    required this.deviceId,
    this.clinicId,
    this.roomId,
    int? nextSeq,
    String? lineVersionsJson,
    this.lastSnapshotAt,
    this.lastViewJson,
  }) : nextSeq = nextSeq ?? 1,
       lineVersionsJson = lineVersionsJson ?? '{}';

  factory DeskMeta({
    int? id,
    required _isc.UuidValue deviceId,
    _isc.UuidValue? clinicId,
    _isc.UuidValue? roomId,
    int? nextSeq,
    String? lineVersionsJson,
    DateTime? lastSnapshotAt,
    String? lastViewJson,
  }) = _DeskMetaImpl;

  factory DeskMeta.fromJson(Map<String, dynamic> jsonSerialization) {
    return DeskMeta(
      id: jsonSerialization['id'] as int?,
      deviceId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['deviceId'],
      ),
      clinicId: jsonSerialization['clinicId'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['clinicId']),
      roomId: jsonSerialization['roomId'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['roomId']),
      nextSeq: jsonSerialization['nextSeq'] as int?,
      lineVersionsJson: jsonSerialization['lineVersionsJson'] as String?,
      lastSnapshotAt: jsonSerialization['lastSnapshotAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['lastSnapshotAt'],
            ),
      lastViewJson: jsonSerialization['lastViewJson'] as String?,
    );
  }

  static final t = DeskMetaTable();

  static const db = DeskMetaRepository._();

  @override
  int? id;

  _isc.UuidValue deviceId;

  _isc.UuidValue? clinicId;

  _isc.UuidValue? roomId;

  int nextSeq;

  String lineVersionsJson;

  DateTime? lastSnapshotAt;

  String? lastViewJson;

  @override
  _isd.Table<int?> get table => t;

  /// Returns a shallow copy of this [DeskMeta]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  DeskMeta copyWith({
    int? id,
    _isc.UuidValue? deviceId,
    _isc.UuidValue? clinicId,
    _isc.UuidValue? roomId,
    int? nextSeq,
    String? lineVersionsJson,
    DateTime? lastSnapshotAt,
    String? lastViewJson,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DeskMeta',
      if (id != null) 'id': id,
      'deviceId': deviceId.toJson(),
      if (clinicId != null) 'clinicId': clinicId?.toJson(),
      if (roomId != null) 'roomId': roomId?.toJson(),
      'nextSeq': nextSeq,
      'lineVersionsJson': lineVersionsJson,
      if (lastSnapshotAt != null) 'lastSnapshotAt': lastSnapshotAt?.toJson(),
      if (lastViewJson != null) 'lastViewJson': lastViewJson,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DeskMeta',
      if (id != null) 'id': id,
      'deviceId': deviceId.toJson(),
      if (clinicId != null) 'clinicId': clinicId?.toJson(),
      if (roomId != null) 'roomId': roomId?.toJson(),
      'nextSeq': nextSeq,
      'lineVersionsJson': lineVersionsJson,
      if (lastSnapshotAt != null) 'lastSnapshotAt': lastSnapshotAt?.toJson(),
      if (lastViewJson != null) 'lastViewJson': lastViewJson,
    };
  }

  static DeskMetaInclude include() {
    return DeskMetaInclude._();
  }

  static DeskMetaIncludeList includeList({
    _isd.WhereExpressionBuilder<DeskMetaTable>? where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<DeskMetaTable>? orderBy,
    _isd.OrderByListBuilder<DeskMetaTable>? orderByList,
    DeskMetaInclude? include,
  }) {
    return DeskMetaIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DeskMeta.t),
      orderByList: orderByList?.call(DeskMeta.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DeskMetaImpl extends DeskMeta {
  _DeskMetaImpl({
    int? id,
    required _isc.UuidValue deviceId,
    _isc.UuidValue? clinicId,
    _isc.UuidValue? roomId,
    int? nextSeq,
    String? lineVersionsJson,
    DateTime? lastSnapshotAt,
    String? lastViewJson,
  }) : super._(
         id: id,
         deviceId: deviceId,
         clinicId: clinicId,
         roomId: roomId,
         nextSeq: nextSeq,
         lineVersionsJson: lineVersionsJson,
         lastSnapshotAt: lastSnapshotAt,
         lastViewJson: lastViewJson,
       );

  /// Returns a shallow copy of this [DeskMeta]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  DeskMeta copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? deviceId,
    Object? clinicId = _Undefined,
    Object? roomId = _Undefined,
    int? nextSeq,
    String? lineVersionsJson,
    Object? lastSnapshotAt = _Undefined,
    Object? lastViewJson = _Undefined,
  }) {
    return DeskMeta(
      id: id is int? ? id : this.id,
      deviceId: deviceId ?? this.deviceId,
      clinicId: clinicId is _isc.UuidValue? ? clinicId : this.clinicId,
      roomId: roomId is _isc.UuidValue? ? roomId : this.roomId,
      nextSeq: nextSeq ?? this.nextSeq,
      lineVersionsJson: lineVersionsJson ?? this.lineVersionsJson,
      lastSnapshotAt: lastSnapshotAt is DateTime?
          ? lastSnapshotAt
          : this.lastSnapshotAt,
      lastViewJson: lastViewJson is String? ? lastViewJson : this.lastViewJson,
    );
  }
}

class DeskMetaUpdateTable extends _isd.UpdateTable<DeskMetaTable> {
  DeskMetaUpdateTable(super.table);

  _isd.ColumnValue<_isc.UuidValue, _isc.UuidValue> deviceId(
    _isc.UuidValue value,
  ) => _isd.ColumnValue(
    table.deviceId,
    value,
  );

  _isd.ColumnValue<_isc.UuidValue, _isc.UuidValue> clinicId(
    _isc.UuidValue? value,
  ) => _isd.ColumnValue(
    table.clinicId,
    value,
  );

  _isd.ColumnValue<_isc.UuidValue, _isc.UuidValue> roomId(
    _isc.UuidValue? value,
  ) => _isd.ColumnValue(
    table.roomId,
    value,
  );

  _isd.ColumnValue<int, int> nextSeq(int value) => _isd.ColumnValue(
    table.nextSeq,
    value,
  );

  _isd.ColumnValue<String, String> lineVersionsJson(String value) =>
      _isd.ColumnValue(
        table.lineVersionsJson,
        value,
      );

  _isd.ColumnValue<DateTime, DateTime> lastSnapshotAt(DateTime? value) =>
      _isd.ColumnValue(
        table.lastSnapshotAt,
        value,
      );

  _isd.ColumnValue<String, String> lastViewJson(String? value) =>
      _isd.ColumnValue(
        table.lastViewJson,
        value,
      );
}

class DeskMetaTable extends _isd.Table<int?> {
  DeskMetaTable({super.tableRelation}) : super(tableName: 'desk_meta') {
    updateTable = DeskMetaUpdateTable(this);
    deviceId = _isd.ColumnUuid(
      'deviceId',
      this,
    );
    clinicId = _isd.ColumnUuid(
      'clinicId',
      this,
    );
    roomId = _isd.ColumnUuid(
      'roomId',
      this,
    );
    nextSeq = _isd.ColumnInt(
      'nextSeq',
      this,
      hasDefault: true,
    );
    lineVersionsJson = _isd.ColumnString(
      'lineVersionsJson',
      this,
      hasDefault: true,
    );
    lastSnapshotAt = _isd.ColumnDateTime(
      'lastSnapshotAt',
      this,
    );
    lastViewJson = _isd.ColumnString(
      'lastViewJson',
      this,
    );
  }

  late final DeskMetaUpdateTable updateTable;

  late final _isd.ColumnUuid deviceId;

  late final _isd.ColumnUuid clinicId;

  late final _isd.ColumnUuid roomId;

  late final _isd.ColumnInt nextSeq;

  late final _isd.ColumnString lineVersionsJson;

  late final _isd.ColumnDateTime lastSnapshotAt;

  late final _isd.ColumnString lastViewJson;

  @override
  List<_isd.Column> get columns => [
    id,
    deviceId,
    clinicId,
    roomId,
    nextSeq,
    lineVersionsJson,
    lastSnapshotAt,
    lastViewJson,
  ];
}

class DeskMetaInclude extends _isd.IncludeObject {
  DeskMetaInclude._();

  @override
  Map<String, _isd.Include?> get includes => {};

  @override
  _isd.Table<int?> get table => DeskMeta.t;
}

class DeskMetaIncludeList extends _isd.IncludeList {
  DeskMetaIncludeList._({
    _isd.WhereExpressionBuilder<DeskMetaTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(DeskMeta.t);
  }

  @override
  Map<String, _isd.Include?> get includes => include?.includes ?? {};

  @override
  _isd.Table<int?> get table => DeskMeta.t;
}

class DeskMetaRepository {
  const DeskMetaRepository._();

  /// Returns a list of [DeskMeta]s matching the given query parameters.
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
  Future<List<DeskMeta>> find(
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<DeskMetaTable>? where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<DeskMetaTable>? orderBy,
    _isd.OrderByListBuilder<DeskMetaTable>? orderByList,
    _isd.Transaction? transaction,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<DeskMeta>(
      where: where?.call(DeskMeta.t),
      orderBy: orderBy?.call(DeskMeta.t),
      orderByList: orderByList?.call(DeskMeta.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [DeskMeta] matching the given query parameters.
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
  Future<DeskMeta?> findFirstRow(
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<DeskMetaTable>? where,
    int? offset,
    _isd.OrderByBuilder<DeskMetaTable>? orderBy,
    _isd.OrderByListBuilder<DeskMetaTable>? orderByList,
    _isd.Transaction? transaction,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<DeskMeta>(
      where: where?.call(DeskMeta.t),
      orderBy: orderBy?.call(DeskMeta.t),
      orderByList: orderByList?.call(DeskMeta.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [DeskMeta] by its [id] or null if no such row exists.
  Future<DeskMeta?> findById(
    _isd.DatabaseSession session,
    int id, {
    _isd.Transaction? transaction,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<DeskMeta>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [DeskMeta]s in the list and returns the inserted rows.
  ///
  /// The returned [DeskMeta]s will have their `id` fields set.
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
  Future<List<DeskMeta>> insert(
    _isd.DatabaseSession session,
    List<DeskMeta> rows, {
    _isd.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<DeskMeta>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [DeskMeta] and returns the inserted row.
  ///
  /// The returned [DeskMeta] will have its `id` field set.
  Future<DeskMeta> insertRow(
    _isd.DatabaseSession session,
    DeskMeta row, {
    _isd.Transaction? transaction,
  }) async {
    return session.db.insertRow<DeskMeta>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [DeskMeta]s in the list and returns the resulting rows.
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
  /// The returned [DeskMeta]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DeskMeta>> upsert(
    _isd.DatabaseSession session,
    List<DeskMeta> rows, {
    required _isd.ColumnSelections<DeskMetaTable> conflictColumns,
    _isd.ColumnSelections<DeskMetaTable>? updateColumns,
    _isd.WhereExpressionBuilder<DeskMetaTable>? updateWhere,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<DeskMeta>(
      rows,
      conflictColumns: conflictColumns(DeskMeta.t),
      updateColumns: updateColumns?.call(DeskMeta.t),
      updateWhere: updateWhere?.call(DeskMeta.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [DeskMeta] and returns the resulting row.
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
  /// The returned [DeskMeta] will have its `id` field set.
  Future<DeskMeta?> upsertRow(
    _isd.DatabaseSession session,
    DeskMeta row, {
    required _isd.ColumnSelections<DeskMetaTable> conflictColumns,
    _isd.ColumnSelections<DeskMetaTable>? updateColumns,
    _isd.WhereExpressionBuilder<DeskMetaTable>? updateWhere,
    _isd.Transaction? transaction,
  }) async {
    return session.db.upsertRow<DeskMeta>(
      row,
      conflictColumns: conflictColumns(DeskMeta.t),
      updateColumns: updateColumns?.call(DeskMeta.t),
      updateWhere: updateWhere?.call(DeskMeta.t),
      transaction: transaction,
    );
  }

  /// Updates all [DeskMeta]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DeskMeta>> update(
    _isd.DatabaseSession session,
    List<DeskMeta> rows, {
    _isd.ColumnSelections<DeskMetaTable>? columns,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<DeskMeta>(
      rows,
      columns: columns?.call(DeskMeta.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [DeskMeta]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<DeskMeta> updateRow(
    _isd.DatabaseSession session,
    DeskMeta row, {
    _isd.ColumnSelections<DeskMetaTable>? columns,
    _isd.Transaction? transaction,
  }) async {
    return session.db.updateRow<DeskMeta>(
      row,
      columns: columns?.call(DeskMeta.t),
      transaction: transaction,
    );
  }

  /// Updates a single [DeskMeta] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<DeskMeta?> updateById(
    _isd.DatabaseSession session,
    int id, {
    required _isd.ColumnValueListBuilder<DeskMetaUpdateTable> columnValues,
    _isd.Transaction? transaction,
  }) async {
    return session.db.updateById<DeskMeta>(
      id,
      columnValues: columnValues(DeskMeta.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [DeskMeta]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DeskMeta>> updateWhere(
    _isd.DatabaseSession session, {
    required _isd.ColumnValueListBuilder<DeskMetaUpdateTable> columnValues,
    required _isd.WhereExpressionBuilder<DeskMetaTable> where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<DeskMetaTable>? orderBy,
    _isd.OrderByListBuilder<DeskMetaTable>? orderByList,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<DeskMeta>(
      columnValues: columnValues(DeskMeta.t.updateTable),
      where: where(DeskMeta.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DeskMeta.t),
      orderByList: orderByList?.call(DeskMeta.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [DeskMeta]s in the list and returns the deleted rows.
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
  Future<List<DeskMeta>> delete(
    _isd.DatabaseSession session,
    List<DeskMeta> rows, {
    _isd.OrderByBuilder<DeskMetaTable>? orderBy,
    _isd.OrderByListBuilder<DeskMetaTable>? orderByList,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<DeskMeta>(
      rows,
      orderBy: orderBy?.call(DeskMeta.t),
      orderByList: orderByList?.call(DeskMeta.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [DeskMeta].
  Future<DeskMeta> deleteRow(
    _isd.DatabaseSession session,
    DeskMeta row, {
    _isd.Transaction? transaction,
  }) async {
    return session.db.deleteRow<DeskMeta>(
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
  Future<List<DeskMeta>> deleteWhere(
    _isd.DatabaseSession session, {
    required _isd.WhereExpressionBuilder<DeskMetaTable> where,
    _isd.OrderByBuilder<DeskMetaTable>? orderBy,
    _isd.OrderByListBuilder<DeskMetaTable>? orderByList,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<DeskMeta>(
      where: where(DeskMeta.t),
      orderBy: orderBy?.call(DeskMeta.t),
      orderByList: orderByList?.call(DeskMeta.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<DeskMetaTable>? where,
    int? limit,
    _isd.Transaction? transaction,
  }) async {
    return session.db.count<DeskMeta>(
      where: where?.call(DeskMeta.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [DeskMeta] rows matching the [where] expression.
  Future<void> lockRows(
    _isd.DatabaseSession session, {
    required _isd.WhereExpressionBuilder<DeskMetaTable> where,
    required _isd.LockMode lockMode,
    required _isd.Transaction transaction,
    _isd.LockBehavior lockBehavior = _isd.LockBehavior.wait,
  }) async {
    return session.db.lockRows<DeskMeta>(
      where: where(DeskMeta.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
