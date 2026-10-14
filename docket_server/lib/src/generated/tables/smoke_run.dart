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
import 'package:serverpod/serverpod.dart' as _is;

abstract class SmokeRun
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  SmokeRun._({
    this.id,
    required this.label,
    required this.scheduledFor,
    this.firedAt,
    this.serverId,
  });

  factory SmokeRun({
    _is.UuidValue? id,
    required String label,
    required DateTime scheduledFor,
    DateTime? firedAt,
    String? serverId,
  }) = _SmokeRunImpl;

  factory SmokeRun.fromJson(Map<String, dynamic> jsonSerialization) {
    return SmokeRun(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      label: jsonSerialization['label'] as String,
      scheduledFor: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['scheduledFor'],
      ),
      firedAt: jsonSerialization['firedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['firedAt']),
      serverId: jsonSerialization['serverId'] as String?,
    );
  }

  static final t = SmokeRunTable();

  static const db = SmokeRunRepository._();

  @override
  _is.UuidValue? id;

  String label;

  DateTime scheduledFor;

  DateTime? firedAt;

  String? serverId;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [SmokeRun]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  SmokeRun copyWith({
    _is.UuidValue? id,
    String? label,
    DateTime? scheduledFor,
    DateTime? firedAt,
    String? serverId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SmokeRun',
      if (id != null) 'id': id?.toJson(),
      'label': label,
      'scheduledFor': scheduledFor.toJson(),
      if (firedAt != null) 'firedAt': firedAt?.toJson(),
      if (serverId != null) 'serverId': serverId,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SmokeRun',
      if (id != null) 'id': id?.toJson(),
      'label': label,
      'scheduledFor': scheduledFor.toJson(),
      if (firedAt != null) 'firedAt': firedAt?.toJson(),
      if (serverId != null) 'serverId': serverId,
    };
  }

  static SmokeRunInclude include() {
    return SmokeRunInclude._();
  }

  static SmokeRunIncludeList includeList({
    _is.WhereExpressionBuilder<SmokeRunTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SmokeRunTable>? orderBy,
    _is.OrderByListBuilder<SmokeRunTable>? orderByList,
    SmokeRunInclude? include,
  }) {
    return SmokeRunIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SmokeRun.t),
      orderByList: orderByList?.call(SmokeRun.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SmokeRunImpl extends SmokeRun {
  _SmokeRunImpl({
    _is.UuidValue? id,
    required String label,
    required DateTime scheduledFor,
    DateTime? firedAt,
    String? serverId,
  }) : super._(
         id: id,
         label: label,
         scheduledFor: scheduledFor,
         firedAt: firedAt,
         serverId: serverId,
       );

  /// Returns a shallow copy of this [SmokeRun]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  SmokeRun copyWith({
    Object? id = _Undefined,
    String? label,
    DateTime? scheduledFor,
    Object? firedAt = _Undefined,
    Object? serverId = _Undefined,
  }) {
    return SmokeRun(
      id: id is _is.UuidValue? ? id : this.id,
      label: label ?? this.label,
      scheduledFor: scheduledFor ?? this.scheduledFor,
      firedAt: firedAt is DateTime? ? firedAt : this.firedAt,
      serverId: serverId is String? ? serverId : this.serverId,
    );
  }
}

class SmokeRunUpdateTable extends _is.UpdateTable<SmokeRunTable> {
  SmokeRunUpdateTable(super.table);

  _is.ColumnValue<String, String> label(String value) => _is.ColumnValue(
    table.label,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> scheduledFor(DateTime value) =>
      _is.ColumnValue(
        table.scheduledFor,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> firedAt(DateTime? value) =>
      _is.ColumnValue(
        table.firedAt,
        value,
      );

  _is.ColumnValue<String, String> serverId(String? value) => _is.ColumnValue(
    table.serverId,
    value,
  );
}

class SmokeRunTable extends _is.Table<_is.UuidValue?> {
  SmokeRunTable({super.tableRelation}) : super(tableName: 'smoke_run') {
    updateTable = SmokeRunUpdateTable(this);
    label = _is.ColumnString(
      'label',
      this,
    );
    scheduledFor = _is.ColumnDateTime(
      'scheduledFor',
      this,
    );
    firedAt = _is.ColumnDateTime(
      'firedAt',
      this,
    );
    serverId = _is.ColumnString(
      'serverId',
      this,
    );
  }

  late final SmokeRunUpdateTable updateTable;

  late final _is.ColumnString label;

  late final _is.ColumnDateTime scheduledFor;

  late final _is.ColumnDateTime firedAt;

  late final _is.ColumnString serverId;

  @override
  List<_is.Column> get columns => [
    id,
    label,
    scheduledFor,
    firedAt,
    serverId,
  ];
}

class SmokeRunInclude extends _is.IncludeObject {
  SmokeRunInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => SmokeRun.t;
}

class SmokeRunIncludeList extends _is.IncludeList {
  SmokeRunIncludeList._({
    _is.WhereExpressionBuilder<SmokeRunTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(SmokeRun.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => SmokeRun.t;
}

class SmokeRunRepository {
  const SmokeRunRepository._();

  /// Returns a list of [SmokeRun]s matching the given query parameters.
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
  Future<List<SmokeRun>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<SmokeRunTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SmokeRunTable>? orderBy,
    _is.OrderByListBuilder<SmokeRunTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<SmokeRun>(
      where: where?.call(SmokeRun.t),
      orderBy: orderBy?.call(SmokeRun.t),
      orderByList: orderByList?.call(SmokeRun.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [SmokeRun] matching the given query parameters.
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
  Future<SmokeRun?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<SmokeRunTable>? where,
    int? offset,
    _is.OrderByBuilder<SmokeRunTable>? orderBy,
    _is.OrderByListBuilder<SmokeRunTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<SmokeRun>(
      where: where?.call(SmokeRun.t),
      orderBy: orderBy?.call(SmokeRun.t),
      orderByList: orderByList?.call(SmokeRun.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [SmokeRun] by its [id] or null if no such row exists.
  Future<SmokeRun?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<SmokeRun>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [SmokeRun]s in the list and returns the inserted rows.
  ///
  /// The returned [SmokeRun]s will have their `id` fields set.
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
  Future<List<SmokeRun>> insert(
    _is.DatabaseSession session,
    List<SmokeRun> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<SmokeRun>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [SmokeRun] and returns the inserted row.
  ///
  /// The returned [SmokeRun] will have its `id` field set.
  Future<SmokeRun> insertRow(
    _is.DatabaseSession session,
    SmokeRun row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<SmokeRun>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [SmokeRun]s in the list and returns the resulting rows.
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
  /// The returned [SmokeRun]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<SmokeRun>> upsert(
    _is.DatabaseSession session,
    List<SmokeRun> rows, {
    required _is.ColumnSelections<SmokeRunTable> conflictColumns,
    _is.ColumnSelections<SmokeRunTable>? updateColumns,
    _is.WhereExpressionBuilder<SmokeRunTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<SmokeRun>(
      rows,
      conflictColumns: conflictColumns(SmokeRun.t),
      updateColumns: updateColumns?.call(SmokeRun.t),
      updateWhere: updateWhere?.call(SmokeRun.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [SmokeRun] and returns the resulting row.
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
  /// The returned [SmokeRun] will have its `id` field set.
  Future<SmokeRun?> upsertRow(
    _is.DatabaseSession session,
    SmokeRun row, {
    required _is.ColumnSelections<SmokeRunTable> conflictColumns,
    _is.ColumnSelections<SmokeRunTable>? updateColumns,
    _is.WhereExpressionBuilder<SmokeRunTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<SmokeRun>(
      row,
      conflictColumns: conflictColumns(SmokeRun.t),
      updateColumns: updateColumns?.call(SmokeRun.t),
      updateWhere: updateWhere?.call(SmokeRun.t),
      transaction: transaction,
    );
  }

  /// Updates all [SmokeRun]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<SmokeRun>> update(
    _is.DatabaseSession session,
    List<SmokeRun> rows, {
    _is.ColumnSelections<SmokeRunTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<SmokeRun>(
      rows,
      columns: columns?.call(SmokeRun.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [SmokeRun]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<SmokeRun> updateRow(
    _is.DatabaseSession session,
    SmokeRun row, {
    _is.ColumnSelections<SmokeRunTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<SmokeRun>(
      row,
      columns: columns?.call(SmokeRun.t),
      transaction: transaction,
    );
  }

  /// Updates a single [SmokeRun] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<SmokeRun?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<SmokeRunUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<SmokeRun>(
      id,
      columnValues: columnValues(SmokeRun.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [SmokeRun]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<SmokeRun>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<SmokeRunUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<SmokeRunTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SmokeRunTable>? orderBy,
    _is.OrderByListBuilder<SmokeRunTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<SmokeRun>(
      columnValues: columnValues(SmokeRun.t.updateTable),
      where: where(SmokeRun.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SmokeRun.t),
      orderByList: orderByList?.call(SmokeRun.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [SmokeRun]s in the list and returns the deleted rows.
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
  Future<List<SmokeRun>> delete(
    _is.DatabaseSession session,
    List<SmokeRun> rows, {
    _is.OrderByBuilder<SmokeRunTable>? orderBy,
    _is.OrderByListBuilder<SmokeRunTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<SmokeRun>(
      rows,
      orderBy: orderBy?.call(SmokeRun.t),
      orderByList: orderByList?.call(SmokeRun.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [SmokeRun].
  Future<SmokeRun> deleteRow(
    _is.DatabaseSession session,
    SmokeRun row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<SmokeRun>(
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
  Future<List<SmokeRun>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<SmokeRunTable> where,
    _is.OrderByBuilder<SmokeRunTable>? orderBy,
    _is.OrderByListBuilder<SmokeRunTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<SmokeRun>(
      where: where(SmokeRun.t),
      orderBy: orderBy?.call(SmokeRun.t),
      orderByList: orderByList?.call(SmokeRun.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<SmokeRunTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<SmokeRun>(
      where: where?.call(SmokeRun.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [SmokeRun] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<SmokeRunTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<SmokeRun>(
      where: where(SmokeRun.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
