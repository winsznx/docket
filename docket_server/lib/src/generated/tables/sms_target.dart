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

abstract class SmsTarget
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  SmsTarget._({
    this.id,
    required this.ticketId,
    required this.phoneCipher,
    required this.phoneLast4,
    required this.consentAt,
    required this.linkCipher,
    bool? active,
  }) : active = active ?? true;

  factory SmsTarget({
    _is.UuidValue? id,
    required _is.UuidValue ticketId,
    required String phoneCipher,
    required String phoneLast4,
    required DateTime consentAt,
    required String linkCipher,
    bool? active,
  }) = _SmsTargetImpl;

  factory SmsTarget.fromJson(Map<String, dynamic> jsonSerialization) {
    return SmsTarget(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      ticketId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['ticketId'],
      ),
      phoneCipher: jsonSerialization['phoneCipher'] as String,
      phoneLast4: jsonSerialization['phoneLast4'] as String,
      consentAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['consentAt'],
      ),
      linkCipher: jsonSerialization['linkCipher'] as String,
      active: jsonSerialization['active'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['active']),
    );
  }

  static final t = SmsTargetTable();

  static const db = SmsTargetRepository._();

  @override
  _is.UuidValue? id;

  _is.UuidValue ticketId;

  String phoneCipher;

  String phoneLast4;

  DateTime consentAt;

  String linkCipher;

  bool active;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [SmsTarget]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  SmsTarget copyWith({
    _is.UuidValue? id,
    _is.UuidValue? ticketId,
    String? phoneCipher,
    String? phoneLast4,
    DateTime? consentAt,
    String? linkCipher,
    bool? active,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SmsTarget',
      if (id != null) 'id': id?.toJson(),
      'ticketId': ticketId.toJson(),
      'phoneCipher': phoneCipher,
      'phoneLast4': phoneLast4,
      'consentAt': consentAt.toJson(),
      'linkCipher': linkCipher,
      'active': active,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static SmsTargetInclude include() {
    return SmsTargetInclude._();
  }

  static SmsTargetIncludeList includeList({
    _is.WhereExpressionBuilder<SmsTargetTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SmsTargetTable>? orderBy,
    _is.OrderByListBuilder<SmsTargetTable>? orderByList,
    SmsTargetInclude? include,
  }) {
    return SmsTargetIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SmsTarget.t),
      orderByList: orderByList?.call(SmsTarget.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SmsTargetImpl extends SmsTarget {
  _SmsTargetImpl({
    _is.UuidValue? id,
    required _is.UuidValue ticketId,
    required String phoneCipher,
    required String phoneLast4,
    required DateTime consentAt,
    required String linkCipher,
    bool? active,
  }) : super._(
         id: id,
         ticketId: ticketId,
         phoneCipher: phoneCipher,
         phoneLast4: phoneLast4,
         consentAt: consentAt,
         linkCipher: linkCipher,
         active: active,
       );

  /// Returns a shallow copy of this [SmsTarget]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  SmsTarget copyWith({
    Object? id = _Undefined,
    _is.UuidValue? ticketId,
    String? phoneCipher,
    String? phoneLast4,
    DateTime? consentAt,
    String? linkCipher,
    bool? active,
  }) {
    return SmsTarget(
      id: id is _is.UuidValue? ? id : this.id,
      ticketId: ticketId ?? this.ticketId,
      phoneCipher: phoneCipher ?? this.phoneCipher,
      phoneLast4: phoneLast4 ?? this.phoneLast4,
      consentAt: consentAt ?? this.consentAt,
      linkCipher: linkCipher ?? this.linkCipher,
      active: active ?? this.active,
    );
  }
}

class SmsTargetUpdateTable extends _is.UpdateTable<SmsTargetTable> {
  SmsTargetUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> ticketId(_is.UuidValue value) =>
      _is.ColumnValue(
        table.ticketId,
        value,
      );

  _is.ColumnValue<String, String> phoneCipher(String value) => _is.ColumnValue(
    table.phoneCipher,
    value,
  );

  _is.ColumnValue<String, String> phoneLast4(String value) => _is.ColumnValue(
    table.phoneLast4,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> consentAt(DateTime value) =>
      _is.ColumnValue(
        table.consentAt,
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
}

class SmsTargetTable extends _is.Table<_is.UuidValue?> {
  SmsTargetTable({super.tableRelation}) : super(tableName: 'sms_target') {
    updateTable = SmsTargetUpdateTable(this);
    ticketId = _is.ColumnUuid(
      'ticketId',
      this,
    );
    phoneCipher = _is.ColumnString(
      'phoneCipher',
      this,
    );
    phoneLast4 = _is.ColumnString(
      'phoneLast4',
      this,
    );
    consentAt = _is.ColumnDateTime(
      'consentAt',
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
  }

  late final SmsTargetUpdateTable updateTable;

  late final _is.ColumnUuid ticketId;

  late final _is.ColumnString phoneCipher;

  late final _is.ColumnString phoneLast4;

  late final _is.ColumnDateTime consentAt;

  late final _is.ColumnString linkCipher;

  late final _is.ColumnBool active;

  @override
  List<_is.Column> get columns => [
    id,
    ticketId,
    phoneCipher,
    phoneLast4,
    consentAt,
    linkCipher,
    active,
  ];
}

class SmsTargetInclude extends _is.IncludeObject {
  SmsTargetInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => SmsTarget.t;
}

class SmsTargetIncludeList extends _is.IncludeList {
  SmsTargetIncludeList._({
    _is.WhereExpressionBuilder<SmsTargetTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(SmsTarget.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => SmsTarget.t;
}

class SmsTargetRepository {
  const SmsTargetRepository._();

  /// Returns a list of [SmsTarget]s matching the given query parameters.
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
  Future<List<SmsTarget>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<SmsTargetTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SmsTargetTable>? orderBy,
    _is.OrderByListBuilder<SmsTargetTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<SmsTarget>(
      where: where?.call(SmsTarget.t),
      orderBy: orderBy?.call(SmsTarget.t),
      orderByList: orderByList?.call(SmsTarget.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [SmsTarget] matching the given query parameters.
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
  Future<SmsTarget?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<SmsTargetTable>? where,
    int? offset,
    _is.OrderByBuilder<SmsTargetTable>? orderBy,
    _is.OrderByListBuilder<SmsTargetTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<SmsTarget>(
      where: where?.call(SmsTarget.t),
      orderBy: orderBy?.call(SmsTarget.t),
      orderByList: orderByList?.call(SmsTarget.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [SmsTarget] by its [id] or null if no such row exists.
  Future<SmsTarget?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<SmsTarget>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [SmsTarget]s in the list and returns the inserted rows.
  ///
  /// The returned [SmsTarget]s will have their `id` fields set.
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
  Future<List<SmsTarget>> insert(
    _is.DatabaseSession session,
    List<SmsTarget> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<SmsTarget>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [SmsTarget] and returns the inserted row.
  ///
  /// The returned [SmsTarget] will have its `id` field set.
  Future<SmsTarget> insertRow(
    _is.DatabaseSession session,
    SmsTarget row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<SmsTarget>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [SmsTarget]s in the list and returns the resulting rows.
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
  /// The returned [SmsTarget]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<SmsTarget>> upsert(
    _is.DatabaseSession session,
    List<SmsTarget> rows, {
    required _is.ColumnSelections<SmsTargetTable> conflictColumns,
    _is.ColumnSelections<SmsTargetTable>? updateColumns,
    _is.WhereExpressionBuilder<SmsTargetTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<SmsTarget>(
      rows,
      conflictColumns: conflictColumns(SmsTarget.t),
      updateColumns: updateColumns?.call(SmsTarget.t),
      updateWhere: updateWhere?.call(SmsTarget.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [SmsTarget] and returns the resulting row.
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
  /// The returned [SmsTarget] will have its `id` field set.
  Future<SmsTarget?> upsertRow(
    _is.DatabaseSession session,
    SmsTarget row, {
    required _is.ColumnSelections<SmsTargetTable> conflictColumns,
    _is.ColumnSelections<SmsTargetTable>? updateColumns,
    _is.WhereExpressionBuilder<SmsTargetTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<SmsTarget>(
      row,
      conflictColumns: conflictColumns(SmsTarget.t),
      updateColumns: updateColumns?.call(SmsTarget.t),
      updateWhere: updateWhere?.call(SmsTarget.t),
      transaction: transaction,
    );
  }

  /// Updates all [SmsTarget]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<SmsTarget>> update(
    _is.DatabaseSession session,
    List<SmsTarget> rows, {
    _is.ColumnSelections<SmsTargetTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<SmsTarget>(
      rows,
      columns: columns?.call(SmsTarget.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [SmsTarget]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<SmsTarget> updateRow(
    _is.DatabaseSession session,
    SmsTarget row, {
    _is.ColumnSelections<SmsTargetTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<SmsTarget>(
      row,
      columns: columns?.call(SmsTarget.t),
      transaction: transaction,
    );
  }

  /// Updates a single [SmsTarget] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<SmsTarget?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<SmsTargetUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<SmsTarget>(
      id,
      columnValues: columnValues(SmsTarget.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [SmsTarget]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<SmsTarget>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<SmsTargetUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<SmsTargetTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SmsTargetTable>? orderBy,
    _is.OrderByListBuilder<SmsTargetTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<SmsTarget>(
      columnValues: columnValues(SmsTarget.t.updateTable),
      where: where(SmsTarget.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SmsTarget.t),
      orderByList: orderByList?.call(SmsTarget.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [SmsTarget]s in the list and returns the deleted rows.
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
  Future<List<SmsTarget>> delete(
    _is.DatabaseSession session,
    List<SmsTarget> rows, {
    _is.OrderByBuilder<SmsTargetTable>? orderBy,
    _is.OrderByListBuilder<SmsTargetTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<SmsTarget>(
      rows,
      orderBy: orderBy?.call(SmsTarget.t),
      orderByList: orderByList?.call(SmsTarget.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [SmsTarget].
  Future<SmsTarget> deleteRow(
    _is.DatabaseSession session,
    SmsTarget row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<SmsTarget>(
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
  Future<List<SmsTarget>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<SmsTargetTable> where,
    _is.OrderByBuilder<SmsTargetTable>? orderBy,
    _is.OrderByListBuilder<SmsTargetTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<SmsTarget>(
      where: where(SmsTarget.t),
      orderBy: orderBy?.call(SmsTarget.t),
      orderByList: orderByList?.call(SmsTarget.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<SmsTargetTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<SmsTarget>(
      where: where?.call(SmsTarget.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [SmsTarget] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<SmsTargetTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<SmsTarget>(
      where: where(SmsTarget.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
