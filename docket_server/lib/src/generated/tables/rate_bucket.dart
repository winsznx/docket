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

abstract class RateBucket
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  RateBucket._({
    this.id,
    required this.bucketKey,
    required this.windowStart,
    required this.hits,
  });

  factory RateBucket({
    _is.UuidValue? id,
    required String bucketKey,
    required DateTime windowStart,
    required int hits,
  }) = _RateBucketImpl;

  factory RateBucket.fromJson(Map<String, dynamic> jsonSerialization) {
    return RateBucket(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      bucketKey: jsonSerialization['bucketKey'] as String,
      windowStart: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['windowStart'],
      ),
      hits: jsonSerialization['hits'] as int,
    );
  }

  static final t = RateBucketTable();

  static const db = RateBucketRepository._();

  @override
  _is.UuidValue? id;

  String bucketKey;

  DateTime windowStart;

  int hits;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [RateBucket]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  RateBucket copyWith({
    _is.UuidValue? id,
    String? bucketKey,
    DateTime? windowStart,
    int? hits,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RateBucket',
      if (id != null) 'id': id?.toJson(),
      'bucketKey': bucketKey,
      'windowStart': windowStart.toJson(),
      'hits': hits,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static RateBucketInclude include() {
    return RateBucketInclude._();
  }

  static RateBucketIncludeList includeList({
    _is.WhereExpressionBuilder<RateBucketTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<RateBucketTable>? orderBy,
    _is.OrderByListBuilder<RateBucketTable>? orderByList,
    RateBucketInclude? include,
  }) {
    return RateBucketIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(RateBucket.t),
      orderByList: orderByList?.call(RateBucket.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RateBucketImpl extends RateBucket {
  _RateBucketImpl({
    _is.UuidValue? id,
    required String bucketKey,
    required DateTime windowStart,
    required int hits,
  }) : super._(
         id: id,
         bucketKey: bucketKey,
         windowStart: windowStart,
         hits: hits,
       );

  /// Returns a shallow copy of this [RateBucket]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  RateBucket copyWith({
    Object? id = _Undefined,
    String? bucketKey,
    DateTime? windowStart,
    int? hits,
  }) {
    return RateBucket(
      id: id is _is.UuidValue? ? id : this.id,
      bucketKey: bucketKey ?? this.bucketKey,
      windowStart: windowStart ?? this.windowStart,
      hits: hits ?? this.hits,
    );
  }
}

class RateBucketUpdateTable extends _is.UpdateTable<RateBucketTable> {
  RateBucketUpdateTable(super.table);

  _is.ColumnValue<String, String> bucketKey(String value) => _is.ColumnValue(
    table.bucketKey,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> windowStart(DateTime value) =>
      _is.ColumnValue(
        table.windowStart,
        value,
      );

  _is.ColumnValue<int, int> hits(int value) => _is.ColumnValue(
    table.hits,
    value,
  );
}

class RateBucketTable extends _is.Table<_is.UuidValue?> {
  RateBucketTable({super.tableRelation}) : super(tableName: 'rate_bucket') {
    updateTable = RateBucketUpdateTable(this);
    bucketKey = _is.ColumnString(
      'bucketKey',
      this,
    );
    windowStart = _is.ColumnDateTime(
      'windowStart',
      this,
    );
    hits = _is.ColumnInt(
      'hits',
      this,
    );
  }

  late final RateBucketUpdateTable updateTable;

  late final _is.ColumnString bucketKey;

  late final _is.ColumnDateTime windowStart;

  late final _is.ColumnInt hits;

  @override
  List<_is.Column> get columns => [
    id,
    bucketKey,
    windowStart,
    hits,
  ];
}

class RateBucketInclude extends _is.IncludeObject {
  RateBucketInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => RateBucket.t;
}

class RateBucketIncludeList extends _is.IncludeList {
  RateBucketIncludeList._({
    _is.WhereExpressionBuilder<RateBucketTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(RateBucket.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => RateBucket.t;
}

class RateBucketRepository {
  const RateBucketRepository._();

  /// Returns a list of [RateBucket]s matching the given query parameters.
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
  Future<List<RateBucket>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<RateBucketTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<RateBucketTable>? orderBy,
    _is.OrderByListBuilder<RateBucketTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<RateBucket>(
      where: where?.call(RateBucket.t),
      orderBy: orderBy?.call(RateBucket.t),
      orderByList: orderByList?.call(RateBucket.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [RateBucket] matching the given query parameters.
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
  Future<RateBucket?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<RateBucketTable>? where,
    int? offset,
    _is.OrderByBuilder<RateBucketTable>? orderBy,
    _is.OrderByListBuilder<RateBucketTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<RateBucket>(
      where: where?.call(RateBucket.t),
      orderBy: orderBy?.call(RateBucket.t),
      orderByList: orderByList?.call(RateBucket.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [RateBucket] by its [id] or null if no such row exists.
  Future<RateBucket?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<RateBucket>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [RateBucket]s in the list and returns the inserted rows.
  ///
  /// The returned [RateBucket]s will have their `id` fields set.
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
  Future<List<RateBucket>> insert(
    _is.DatabaseSession session,
    List<RateBucket> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<RateBucket>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [RateBucket] and returns the inserted row.
  ///
  /// The returned [RateBucket] will have its `id` field set.
  Future<RateBucket> insertRow(
    _is.DatabaseSession session,
    RateBucket row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<RateBucket>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [RateBucket]s in the list and returns the resulting rows.
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
  /// The returned [RateBucket]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<RateBucket>> upsert(
    _is.DatabaseSession session,
    List<RateBucket> rows, {
    required _is.ColumnSelections<RateBucketTable> conflictColumns,
    _is.ColumnSelections<RateBucketTable>? updateColumns,
    _is.WhereExpressionBuilder<RateBucketTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<RateBucket>(
      rows,
      conflictColumns: conflictColumns(RateBucket.t),
      updateColumns: updateColumns?.call(RateBucket.t),
      updateWhere: updateWhere?.call(RateBucket.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [RateBucket] and returns the resulting row.
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
  /// The returned [RateBucket] will have its `id` field set.
  Future<RateBucket?> upsertRow(
    _is.DatabaseSession session,
    RateBucket row, {
    required _is.ColumnSelections<RateBucketTable> conflictColumns,
    _is.ColumnSelections<RateBucketTable>? updateColumns,
    _is.WhereExpressionBuilder<RateBucketTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<RateBucket>(
      row,
      conflictColumns: conflictColumns(RateBucket.t),
      updateColumns: updateColumns?.call(RateBucket.t),
      updateWhere: updateWhere?.call(RateBucket.t),
      transaction: transaction,
    );
  }

  /// Updates all [RateBucket]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<RateBucket>> update(
    _is.DatabaseSession session,
    List<RateBucket> rows, {
    _is.ColumnSelections<RateBucketTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<RateBucket>(
      rows,
      columns: columns?.call(RateBucket.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [RateBucket]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<RateBucket> updateRow(
    _is.DatabaseSession session,
    RateBucket row, {
    _is.ColumnSelections<RateBucketTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<RateBucket>(
      row,
      columns: columns?.call(RateBucket.t),
      transaction: transaction,
    );
  }

  /// Updates a single [RateBucket] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<RateBucket?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<RateBucketUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<RateBucket>(
      id,
      columnValues: columnValues(RateBucket.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [RateBucket]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<RateBucket>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<RateBucketUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<RateBucketTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<RateBucketTable>? orderBy,
    _is.OrderByListBuilder<RateBucketTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<RateBucket>(
      columnValues: columnValues(RateBucket.t.updateTable),
      where: where(RateBucket.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(RateBucket.t),
      orderByList: orderByList?.call(RateBucket.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [RateBucket]s in the list and returns the deleted rows.
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
  Future<List<RateBucket>> delete(
    _is.DatabaseSession session,
    List<RateBucket> rows, {
    _is.OrderByBuilder<RateBucketTable>? orderBy,
    _is.OrderByListBuilder<RateBucketTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<RateBucket>(
      rows,
      orderBy: orderBy?.call(RateBucket.t),
      orderByList: orderByList?.call(RateBucket.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [RateBucket].
  Future<RateBucket> deleteRow(
    _is.DatabaseSession session,
    RateBucket row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<RateBucket>(
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
  Future<List<RateBucket>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<RateBucketTable> where,
    _is.OrderByBuilder<RateBucketTable>? orderBy,
    _is.OrderByListBuilder<RateBucketTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<RateBucket>(
      where: where(RateBucket.t),
      orderBy: orderBy?.call(RateBucket.t),
      orderByList: orderByList?.call(RateBucket.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<RateBucketTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<RateBucket>(
      where: where?.call(RateBucket.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [RateBucket] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<RateBucketTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<RateBucket>(
      where: where(RateBucket.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
