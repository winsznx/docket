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

abstract class PushTarget
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  PushTarget._({
    this.id,
    required this.ticketId,
    required this.endpoint,
    required this.p256dh,
    required this.authSecret,
    required this.linkCipher,
    bool? active,
    DateTime? createdAt,
  }) : active = active ?? true,
       createdAt = createdAt ?? DateTime.now();

  factory PushTarget({
    _is.UuidValue? id,
    required _is.UuidValue ticketId,
    required String endpoint,
    required String p256dh,
    required String authSecret,
    required String linkCipher,
    bool? active,
    DateTime? createdAt,
  }) = _PushTargetImpl;

  factory PushTarget.fromJson(Map<String, dynamic> jsonSerialization) {
    return PushTarget(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      ticketId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['ticketId'],
      ),
      endpoint: jsonSerialization['endpoint'] as String,
      p256dh: jsonSerialization['p256dh'] as String,
      authSecret: jsonSerialization['authSecret'] as String,
      linkCipher: jsonSerialization['linkCipher'] as String,
      active: jsonSerialization['active'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['active']),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = PushTargetTable();

  static const db = PushTargetRepository._();

  @override
  _is.UuidValue? id;

  _is.UuidValue ticketId;

  String endpoint;

  String p256dh;

  String authSecret;

  String linkCipher;

  bool active;

  DateTime createdAt;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [PushTarget]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  PushTarget copyWith({
    _is.UuidValue? id,
    _is.UuidValue? ticketId,
    String? endpoint,
    String? p256dh,
    String? authSecret,
    String? linkCipher,
    bool? active,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PushTarget',
      if (id != null) 'id': id?.toJson(),
      'ticketId': ticketId.toJson(),
      'endpoint': endpoint,
      'p256dh': p256dh,
      'authSecret': authSecret,
      'linkCipher': linkCipher,
      'active': active,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static PushTargetInclude include() {
    return PushTargetInclude._();
  }

  static PushTargetIncludeList includeList({
    _is.WhereExpressionBuilder<PushTargetTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PushTargetTable>? orderBy,
    _is.OrderByListBuilder<PushTargetTable>? orderByList,
    PushTargetInclude? include,
  }) {
    return PushTargetIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PushTarget.t),
      orderByList: orderByList?.call(PushTarget.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PushTargetImpl extends PushTarget {
  _PushTargetImpl({
    _is.UuidValue? id,
    required _is.UuidValue ticketId,
    required String endpoint,
    required String p256dh,
    required String authSecret,
    required String linkCipher,
    bool? active,
    DateTime? createdAt,
  }) : super._(
         id: id,
         ticketId: ticketId,
         endpoint: endpoint,
         p256dh: p256dh,
         authSecret: authSecret,
         linkCipher: linkCipher,
         active: active,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [PushTarget]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  PushTarget copyWith({
    Object? id = _Undefined,
    _is.UuidValue? ticketId,
    String? endpoint,
    String? p256dh,
    String? authSecret,
    String? linkCipher,
    bool? active,
    DateTime? createdAt,
  }) {
    return PushTarget(
      id: id is _is.UuidValue? ? id : this.id,
      ticketId: ticketId ?? this.ticketId,
      endpoint: endpoint ?? this.endpoint,
      p256dh: p256dh ?? this.p256dh,
      authSecret: authSecret ?? this.authSecret,
      linkCipher: linkCipher ?? this.linkCipher,
      active: active ?? this.active,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class PushTargetUpdateTable extends _is.UpdateTable<PushTargetTable> {
  PushTargetUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> ticketId(_is.UuidValue value) =>
      _is.ColumnValue(
        table.ticketId,
        value,
      );

  _is.ColumnValue<String, String> endpoint(String value) => _is.ColumnValue(
    table.endpoint,
    value,
  );

  _is.ColumnValue<String, String> p256dh(String value) => _is.ColumnValue(
    table.p256dh,
    value,
  );

  _is.ColumnValue<String, String> authSecret(String value) => _is.ColumnValue(
    table.authSecret,
    value,
  );

  _is.ColumnValue<String, String> linkCipher(String value) => _is.ColumnValue(
    table.linkCipher,
    value,
  );

  _is.ColumnValue<bool, bool> active(bool value) => _is.ColumnValue(
    table.active,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );
}

class PushTargetTable extends _is.Table<_is.UuidValue?> {
  PushTargetTable({super.tableRelation}) : super(tableName: 'push_target') {
    updateTable = PushTargetUpdateTable(this);
    ticketId = _is.ColumnUuid(
      'ticketId',
      this,
    );
    endpoint = _is.ColumnString(
      'endpoint',
      this,
    );
    p256dh = _is.ColumnString(
      'p256dh',
      this,
    );
    authSecret = _is.ColumnString(
      'authSecret',
      this,
    );
    linkCipher = _is.ColumnString(
      'linkCipher',
      this,
    );
    active = _is.ColumnBool(
      'active',
      this,
      hasDefault: true,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
  }

  late final PushTargetUpdateTable updateTable;

  late final _is.ColumnUuid ticketId;

  late final _is.ColumnString endpoint;

  late final _is.ColumnString p256dh;

  late final _is.ColumnString authSecret;

  late final _is.ColumnString linkCipher;

  late final _is.ColumnBool active;

  late final _is.ColumnDateTime createdAt;

  @override
  List<_is.Column> get columns => [
    id,
    ticketId,
    endpoint,
    p256dh,
    authSecret,
    linkCipher,
    active,
    createdAt,
  ];
}

class PushTargetInclude extends _is.IncludeObject {
  PushTargetInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => PushTarget.t;
}

class PushTargetIncludeList extends _is.IncludeList {
  PushTargetIncludeList._({
    _is.WhereExpressionBuilder<PushTargetTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(PushTarget.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => PushTarget.t;
}

class PushTargetRepository {
  const PushTargetRepository._();

  /// Returns a list of [PushTarget]s matching the given query parameters.
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
  Future<List<PushTarget>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PushTargetTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PushTargetTable>? orderBy,
    _is.OrderByListBuilder<PushTargetTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<PushTarget>(
      where: where?.call(PushTarget.t),
      orderBy: orderBy?.call(PushTarget.t),
      orderByList: orderByList?.call(PushTarget.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [PushTarget] matching the given query parameters.
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
  Future<PushTarget?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PushTargetTable>? where,
    int? offset,
    _is.OrderByBuilder<PushTargetTable>? orderBy,
    _is.OrderByListBuilder<PushTargetTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<PushTarget>(
      where: where?.call(PushTarget.t),
      orderBy: orderBy?.call(PushTarget.t),
      orderByList: orderByList?.call(PushTarget.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [PushTarget] by its [id] or null if no such row exists.
  Future<PushTarget?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<PushTarget>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [PushTarget]s in the list and returns the inserted rows.
  ///
  /// The returned [PushTarget]s will have their `id` fields set.
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
  Future<List<PushTarget>> insert(
    _is.DatabaseSession session,
    List<PushTarget> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<PushTarget>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [PushTarget] and returns the inserted row.
  ///
  /// The returned [PushTarget] will have its `id` field set.
  Future<PushTarget> insertRow(
    _is.DatabaseSession session,
    PushTarget row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<PushTarget>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [PushTarget]s in the list and returns the resulting rows.
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
  /// The returned [PushTarget]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<PushTarget>> upsert(
    _is.DatabaseSession session,
    List<PushTarget> rows, {
    required _is.ColumnSelections<PushTargetTable> conflictColumns,
    _is.ColumnSelections<PushTargetTable>? updateColumns,
    _is.WhereExpressionBuilder<PushTargetTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<PushTarget>(
      rows,
      conflictColumns: conflictColumns(PushTarget.t),
      updateColumns: updateColumns?.call(PushTarget.t),
      updateWhere: updateWhere?.call(PushTarget.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [PushTarget] and returns the resulting row.
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
  /// The returned [PushTarget] will have its `id` field set.
  Future<PushTarget?> upsertRow(
    _is.DatabaseSession session,
    PushTarget row, {
    required _is.ColumnSelections<PushTargetTable> conflictColumns,
    _is.ColumnSelections<PushTargetTable>? updateColumns,
    _is.WhereExpressionBuilder<PushTargetTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<PushTarget>(
      row,
      conflictColumns: conflictColumns(PushTarget.t),
      updateColumns: updateColumns?.call(PushTarget.t),
      updateWhere: updateWhere?.call(PushTarget.t),
      transaction: transaction,
    );
  }

  /// Updates all [PushTarget]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<PushTarget>> update(
    _is.DatabaseSession session,
    List<PushTarget> rows, {
    _is.ColumnSelections<PushTargetTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<PushTarget>(
      rows,
      columns: columns?.call(PushTarget.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [PushTarget]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<PushTarget> updateRow(
    _is.DatabaseSession session,
    PushTarget row, {
    _is.ColumnSelections<PushTargetTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<PushTarget>(
      row,
      columns: columns?.call(PushTarget.t),
      transaction: transaction,
    );
  }

  /// Updates a single [PushTarget] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<PushTarget?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<PushTargetUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<PushTarget>(
      id,
      columnValues: columnValues(PushTarget.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [PushTarget]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<PushTarget>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<PushTargetUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<PushTargetTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PushTargetTable>? orderBy,
    _is.OrderByListBuilder<PushTargetTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<PushTarget>(
      columnValues: columnValues(PushTarget.t.updateTable),
      where: where(PushTarget.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PushTarget.t),
      orderByList: orderByList?.call(PushTarget.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [PushTarget]s in the list and returns the deleted rows.
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
  Future<List<PushTarget>> delete(
    _is.DatabaseSession session,
    List<PushTarget> rows, {
    _is.OrderByBuilder<PushTargetTable>? orderBy,
    _is.OrderByListBuilder<PushTargetTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<PushTarget>(
      rows,
      orderBy: orderBy?.call(PushTarget.t),
      orderByList: orderByList?.call(PushTarget.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [PushTarget].
  Future<PushTarget> deleteRow(
    _is.DatabaseSession session,
    PushTarget row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<PushTarget>(
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
  Future<List<PushTarget>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<PushTargetTable> where,
    _is.OrderByBuilder<PushTargetTable>? orderBy,
    _is.OrderByListBuilder<PushTargetTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<PushTarget>(
      where: where(PushTarget.t),
      orderBy: orderBy?.call(PushTarget.t),
      orderByList: orderByList?.call(PushTarget.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PushTargetTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<PushTarget>(
      where: where?.call(PushTarget.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [PushTarget] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<PushTargetTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<PushTarget>(
      where: where(PushTarget.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
