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

abstract class Line
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  Line._({
    this.id,
    required this.clinicId,
    required this.name,
    required this.code,
    int? defaultServiceSeconds,
    bool? acceptingJoins,
    int? version,
    int? sortOrder,
  }) : defaultServiceSeconds = defaultServiceSeconds ?? 480,
       acceptingJoins = acceptingJoins ?? true,
       version = version ?? 0,
       sortOrder = sortOrder ?? 0;

  factory Line({
    _is.UuidValue? id,
    required _is.UuidValue clinicId,
    required String name,
    required String code,
    int? defaultServiceSeconds,
    bool? acceptingJoins,
    int? version,
    int? sortOrder,
  }) = _LineImpl;

  factory Line.fromJson(Map<String, dynamic> jsonSerialization) {
    return Line(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      clinicId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['clinicId'],
      ),
      name: jsonSerialization['name'] as String,
      code: jsonSerialization['code'] as String,
      defaultServiceSeconds: jsonSerialization['defaultServiceSeconds'] as int?,
      acceptingJoins: jsonSerialization['acceptingJoins'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['acceptingJoins']),
      version: jsonSerialization['version'] as int?,
      sortOrder: jsonSerialization['sortOrder'] as int?,
    );
  }

  static final t = LineTable();

  static const db = LineRepository._();

  @override
  _is.UuidValue? id;

  _is.UuidValue clinicId;

  String name;

  String code;

  int defaultServiceSeconds;

  bool acceptingJoins;

  int version;

  int sortOrder;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [Line]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  Line copyWith({
    _is.UuidValue? id,
    _is.UuidValue? clinicId,
    String? name,
    String? code,
    int? defaultServiceSeconds,
    bool? acceptingJoins,
    int? version,
    int? sortOrder,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Line',
      if (id != null) 'id': id?.toJson(),
      'clinicId': clinicId.toJson(),
      'name': name,
      'code': code,
      'defaultServiceSeconds': defaultServiceSeconds,
      'acceptingJoins': acceptingJoins,
      'version': version,
      'sortOrder': sortOrder,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Line',
      if (id != null) 'id': id?.toJson(),
      'clinicId': clinicId.toJson(),
      'name': name,
      'code': code,
      'defaultServiceSeconds': defaultServiceSeconds,
      'acceptingJoins': acceptingJoins,
      'version': version,
      'sortOrder': sortOrder,
    };
  }

  static LineInclude include() {
    return LineInclude._();
  }

  static LineIncludeList includeList({
    _is.WhereExpressionBuilder<LineTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<LineTable>? orderBy,
    _is.OrderByListBuilder<LineTable>? orderByList,
    LineInclude? include,
  }) {
    return LineIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Line.t),
      orderByList: orderByList?.call(Line.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _LineImpl extends Line {
  _LineImpl({
    _is.UuidValue? id,
    required _is.UuidValue clinicId,
    required String name,
    required String code,
    int? defaultServiceSeconds,
    bool? acceptingJoins,
    int? version,
    int? sortOrder,
  }) : super._(
         id: id,
         clinicId: clinicId,
         name: name,
         code: code,
         defaultServiceSeconds: defaultServiceSeconds,
         acceptingJoins: acceptingJoins,
         version: version,
         sortOrder: sortOrder,
       );

  /// Returns a shallow copy of this [Line]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  Line copyWith({
    Object? id = _Undefined,
    _is.UuidValue? clinicId,
    String? name,
    String? code,
    int? defaultServiceSeconds,
    bool? acceptingJoins,
    int? version,
    int? sortOrder,
  }) {
    return Line(
      id: id is _is.UuidValue? ? id : this.id,
      clinicId: clinicId ?? this.clinicId,
      name: name ?? this.name,
      code: code ?? this.code,
      defaultServiceSeconds:
          defaultServiceSeconds ?? this.defaultServiceSeconds,
      acceptingJoins: acceptingJoins ?? this.acceptingJoins,
      version: version ?? this.version,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }
}

class LineUpdateTable extends _is.UpdateTable<LineTable> {
  LineUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> clinicId(_is.UuidValue value) =>
      _is.ColumnValue(
        table.clinicId,
        value,
      );

  _is.ColumnValue<String, String> name(String value) => _is.ColumnValue(
    table.name,
    value,
  );

  _is.ColumnValue<String, String> code(String value) => _is.ColumnValue(
    table.code,
    value,
  );

  _is.ColumnValue<int, int> defaultServiceSeconds(int value) => _is.ColumnValue(
    table.defaultServiceSeconds,
    value,
  );

  _is.ColumnValue<bool, bool> acceptingJoins(bool value) => _is.ColumnValue(
    table.acceptingJoins,
    value,
  );

  _is.ColumnValue<int, int> version(int value) => _is.ColumnValue(
    table.version,
    value,
  );

  _is.ColumnValue<int, int> sortOrder(int value) => _is.ColumnValue(
    table.sortOrder,
    value,
  );
}

class LineTable extends _is.Table<_is.UuidValue?> {
  LineTable({super.tableRelation}) : super(tableName: 'line') {
    updateTable = LineUpdateTable(this);
    clinicId = _is.ColumnUuid(
      'clinicId',
      this,
    );
    name = _is.ColumnString(
      'name',
      this,
    );
    code = _is.ColumnString(
      'code',
      this,
    );
    defaultServiceSeconds = _is.ColumnInt(
      'defaultServiceSeconds',
      this,
      hasDefault: true,
    );
    acceptingJoins = _is.ColumnBool(
      'acceptingJoins',
      this,
      hasDefault: true,
    );
    version = _is.ColumnInt(
      'version',
      this,
      hasDefault: true,
    );
    sortOrder = _is.ColumnInt(
      'sortOrder',
      this,
      hasDefault: true,
    );
  }

  late final LineUpdateTable updateTable;

  late final _is.ColumnUuid clinicId;

  late final _is.ColumnString name;

  late final _is.ColumnString code;

  late final _is.ColumnInt defaultServiceSeconds;

  late final _is.ColumnBool acceptingJoins;

  late final _is.ColumnInt version;

  late final _is.ColumnInt sortOrder;

  @override
  List<_is.Column> get columns => [
    id,
    clinicId,
    name,
    code,
    defaultServiceSeconds,
    acceptingJoins,
    version,
    sortOrder,
  ];
}

class LineInclude extends _is.IncludeObject {
  LineInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => Line.t;
}

class LineIncludeList extends _is.IncludeList {
  LineIncludeList._({
    _is.WhereExpressionBuilder<LineTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Line.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => Line.t;
}

class LineRepository {
  const LineRepository._();

  /// Returns a list of [Line]s matching the given query parameters.
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
  Future<List<Line>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<LineTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<LineTable>? orderBy,
    _is.OrderByListBuilder<LineTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Line>(
      where: where?.call(Line.t),
      orderBy: orderBy?.call(Line.t),
      orderByList: orderByList?.call(Line.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Line] matching the given query parameters.
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
  Future<Line?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<LineTable>? where,
    int? offset,
    _is.OrderByBuilder<LineTable>? orderBy,
    _is.OrderByListBuilder<LineTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Line>(
      where: where?.call(Line.t),
      orderBy: orderBy?.call(Line.t),
      orderByList: orderByList?.call(Line.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Line] by its [id] or null if no such row exists.
  Future<Line?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Line>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Line]s in the list and returns the inserted rows.
  ///
  /// The returned [Line]s will have their `id` fields set.
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
  Future<List<Line>> insert(
    _is.DatabaseSession session,
    List<Line> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<Line>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [Line] and returns the inserted row.
  ///
  /// The returned [Line] will have its `id` field set.
  Future<Line> insertRow(
    _is.DatabaseSession session,
    Line row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<Line>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [Line]s in the list and returns the resulting rows.
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
  /// The returned [Line]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Line>> upsert(
    _is.DatabaseSession session,
    List<Line> rows, {
    required _is.ColumnSelections<LineTable> conflictColumns,
    _is.ColumnSelections<LineTable>? updateColumns,
    _is.WhereExpressionBuilder<LineTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<Line>(
      rows,
      conflictColumns: conflictColumns(Line.t),
      updateColumns: updateColumns?.call(Line.t),
      updateWhere: updateWhere?.call(Line.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [Line] and returns the resulting row.
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
  /// The returned [Line] will have its `id` field set.
  Future<Line?> upsertRow(
    _is.DatabaseSession session,
    Line row, {
    required _is.ColumnSelections<LineTable> conflictColumns,
    _is.ColumnSelections<LineTable>? updateColumns,
    _is.WhereExpressionBuilder<LineTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<Line>(
      row,
      conflictColumns: conflictColumns(Line.t),
      updateColumns: updateColumns?.call(Line.t),
      updateWhere: updateWhere?.call(Line.t),
      transaction: transaction,
    );
  }

  /// Updates all [Line]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Line>> update(
    _is.DatabaseSession session,
    List<Line> rows, {
    _is.ColumnSelections<LineTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<Line>(
      rows,
      columns: columns?.call(Line.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [Line]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Line> updateRow(
    _is.DatabaseSession session,
    Line row, {
    _is.ColumnSelections<LineTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<Line>(
      row,
      columns: columns?.call(Line.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Line] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Line?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<LineUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<Line>(
      id,
      columnValues: columnValues(Line.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Line]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Line>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<LineUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<LineTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<LineTable>? orderBy,
    _is.OrderByListBuilder<LineTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<Line>(
      columnValues: columnValues(Line.t.updateTable),
      where: where(Line.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Line.t),
      orderByList: orderByList?.call(Line.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [Line]s in the list and returns the deleted rows.
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
  Future<List<Line>> delete(
    _is.DatabaseSession session,
    List<Line> rows, {
    _is.OrderByBuilder<LineTable>? orderBy,
    _is.OrderByListBuilder<LineTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<Line>(
      rows,
      orderBy: orderBy?.call(Line.t),
      orderByList: orderByList?.call(Line.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [Line].
  Future<Line> deleteRow(
    _is.DatabaseSession session,
    Line row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Line>(
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
  Future<List<Line>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<LineTable> where,
    _is.OrderByBuilder<LineTable>? orderBy,
    _is.OrderByListBuilder<LineTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<Line>(
      where: where(Line.t),
      orderBy: orderBy?.call(Line.t),
      orderByList: orderByList?.call(Line.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<LineTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<Line>(
      where: where?.call(Line.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Line] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<LineTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Line>(
      where: where(Line.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
