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
import 'package:docket_server/src/generated/protocol.dart' as _in3ld48g;
import 'package:serverpod/serverpod.dart' as _is;
import '../wire/day_report_data.dart' as _ib20ove7;

abstract class DayReport
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  DayReport._({
    this.id,
    required this.clinicId,
    required this.serviceDate,
    required this.generatedAt,
    required this.data,
  });

  factory DayReport({
    _is.UuidValue? id,
    required _is.UuidValue clinicId,
    required String serviceDate,
    required DateTime generatedAt,
    required _ib20ove7.DayReportData data,
  }) = _DayReportImpl;

  factory DayReport.fromJson(Map<String, dynamic> jsonSerialization) {
    return DayReport(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      clinicId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['clinicId'],
      ),
      serviceDate: jsonSerialization['serviceDate'] as String,
      generatedAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['generatedAt'],
      ),
      data: _in3ld48g.Protocol().deserialize<_ib20ove7.DayReportData>(
        jsonSerialization['data'],
      ),
    );
  }

  static final t = DayReportTable();

  static const db = DayReportRepository._();

  @override
  _is.UuidValue? id;

  _is.UuidValue clinicId;

  String serviceDate;

  DateTime generatedAt;

  _ib20ove7.DayReportData data;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [DayReport]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  DayReport copyWith({
    _is.UuidValue? id,
    _is.UuidValue? clinicId,
    String? serviceDate,
    DateTime? generatedAt,
    _ib20ove7.DayReportData? data,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DayReport',
      if (id != null) 'id': id?.toJson(),
      'clinicId': clinicId.toJson(),
      'serviceDate': serviceDate,
      'generatedAt': generatedAt.toJson(),
      'data': data.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DayReport',
      if (id != null) 'id': id?.toJson(),
      'clinicId': clinicId.toJson(),
      'serviceDate': serviceDate,
      'generatedAt': generatedAt.toJson(),
      'data': data.toJsonForProtocol(),
    };
  }

  static DayReportInclude include() {
    return DayReportInclude._();
  }

  static DayReportIncludeList includeList({
    _is.WhereExpressionBuilder<DayReportTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DayReportTable>? orderBy,
    _is.OrderByListBuilder<DayReportTable>? orderByList,
    DayReportInclude? include,
  }) {
    return DayReportIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DayReport.t),
      orderByList: orderByList?.call(DayReport.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DayReportImpl extends DayReport {
  _DayReportImpl({
    _is.UuidValue? id,
    required _is.UuidValue clinicId,
    required String serviceDate,
    required DateTime generatedAt,
    required _ib20ove7.DayReportData data,
  }) : super._(
         id: id,
         clinicId: clinicId,
         serviceDate: serviceDate,
         generatedAt: generatedAt,
         data: data,
       );

  /// Returns a shallow copy of this [DayReport]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  DayReport copyWith({
    Object? id = _Undefined,
    _is.UuidValue? clinicId,
    String? serviceDate,
    DateTime? generatedAt,
    _ib20ove7.DayReportData? data,
  }) {
    return DayReport(
      id: id is _is.UuidValue? ? id : this.id,
      clinicId: clinicId ?? this.clinicId,
      serviceDate: serviceDate ?? this.serviceDate,
      generatedAt: generatedAt ?? this.generatedAt,
      data: data ?? this.data.copyWith(),
    );
  }
}

class DayReportUpdateTable extends _is.UpdateTable<DayReportTable> {
  DayReportUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> clinicId(_is.UuidValue value) =>
      _is.ColumnValue(
        table.clinicId,
        value,
      );

  _is.ColumnValue<String, String> serviceDate(String value) => _is.ColumnValue(
    table.serviceDate,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> generatedAt(DateTime value) =>
      _is.ColumnValue(
        table.generatedAt,
        value,
      );

  _is.ColumnValue<_ib20ove7.DayReportData, _ib20ove7.DayReportData> data(
    _ib20ove7.DayReportData value,
  ) => _is.ColumnValue(
    table.data,
    value,
  );
}

class DayReportTable extends _is.Table<_is.UuidValue?> {
  DayReportTable({super.tableRelation}) : super(tableName: 'day_report') {
    updateTable = DayReportUpdateTable(this);
    clinicId = _is.ColumnUuid(
      'clinicId',
      this,
    );
    serviceDate = _is.ColumnString(
      'serviceDate',
      this,
    );
    generatedAt = _is.ColumnDateTime(
      'generatedAt',
      this,
    );
    data = _is.ColumnStructured<_ib20ove7.DayReportData>(
      'data',
      this,
    );
  }

  late final DayReportUpdateTable updateTable;

  late final _is.ColumnUuid clinicId;

  late final _is.ColumnString serviceDate;

  late final _is.ColumnDateTime generatedAt;

  late final _is.ColumnStructured<_ib20ove7.DayReportData> data;

  @override
  List<_is.Column> get columns => [
    id,
    clinicId,
    serviceDate,
    generatedAt,
    data,
  ];
}

class DayReportInclude extends _is.IncludeObject {
  DayReportInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => DayReport.t;
}

class DayReportIncludeList extends _is.IncludeList {
  DayReportIncludeList._({
    _is.WhereExpressionBuilder<DayReportTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(DayReport.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => DayReport.t;
}

class DayReportRepository {
  const DayReportRepository._();

  /// Returns a list of [DayReport]s matching the given query parameters.
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
  Future<List<DayReport>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DayReportTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DayReportTable>? orderBy,
    _is.OrderByListBuilder<DayReportTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<DayReport>(
      where: where?.call(DayReport.t),
      orderBy: orderBy?.call(DayReport.t),
      orderByList: orderByList?.call(DayReport.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [DayReport] matching the given query parameters.
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
  Future<DayReport?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DayReportTable>? where,
    int? offset,
    _is.OrderByBuilder<DayReportTable>? orderBy,
    _is.OrderByListBuilder<DayReportTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<DayReport>(
      where: where?.call(DayReport.t),
      orderBy: orderBy?.call(DayReport.t),
      orderByList: orderByList?.call(DayReport.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [DayReport] by its [id] or null if no such row exists.
  Future<DayReport?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<DayReport>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [DayReport]s in the list and returns the inserted rows.
  ///
  /// The returned [DayReport]s will have their `id` fields set.
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
  Future<List<DayReport>> insert(
    _is.DatabaseSession session,
    List<DayReport> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<DayReport>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [DayReport] and returns the inserted row.
  ///
  /// The returned [DayReport] will have its `id` field set.
  Future<DayReport> insertRow(
    _is.DatabaseSession session,
    DayReport row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<DayReport>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [DayReport]s in the list and returns the resulting rows.
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
  /// The returned [DayReport]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DayReport>> upsert(
    _is.DatabaseSession session,
    List<DayReport> rows, {
    required _is.ColumnSelections<DayReportTable> conflictColumns,
    _is.ColumnSelections<DayReportTable>? updateColumns,
    _is.WhereExpressionBuilder<DayReportTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<DayReport>(
      rows,
      conflictColumns: conflictColumns(DayReport.t),
      updateColumns: updateColumns?.call(DayReport.t),
      updateWhere: updateWhere?.call(DayReport.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [DayReport] and returns the resulting row.
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
  /// The returned [DayReport] will have its `id` field set.
  Future<DayReport?> upsertRow(
    _is.DatabaseSession session,
    DayReport row, {
    required _is.ColumnSelections<DayReportTable> conflictColumns,
    _is.ColumnSelections<DayReportTable>? updateColumns,
    _is.WhereExpressionBuilder<DayReportTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<DayReport>(
      row,
      conflictColumns: conflictColumns(DayReport.t),
      updateColumns: updateColumns?.call(DayReport.t),
      updateWhere: updateWhere?.call(DayReport.t),
      transaction: transaction,
    );
  }

  /// Updates all [DayReport]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DayReport>> update(
    _is.DatabaseSession session,
    List<DayReport> rows, {
    _is.ColumnSelections<DayReportTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<DayReport>(
      rows,
      columns: columns?.call(DayReport.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [DayReport]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<DayReport> updateRow(
    _is.DatabaseSession session,
    DayReport row, {
    _is.ColumnSelections<DayReportTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<DayReport>(
      row,
      columns: columns?.call(DayReport.t),
      transaction: transaction,
    );
  }

  /// Updates a single [DayReport] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<DayReport?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<DayReportUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<DayReport>(
      id,
      columnValues: columnValues(DayReport.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [DayReport]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DayReport>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<DayReportUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<DayReportTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DayReportTable>? orderBy,
    _is.OrderByListBuilder<DayReportTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<DayReport>(
      columnValues: columnValues(DayReport.t.updateTable),
      where: where(DayReport.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DayReport.t),
      orderByList: orderByList?.call(DayReport.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [DayReport]s in the list and returns the deleted rows.
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
  Future<List<DayReport>> delete(
    _is.DatabaseSession session,
    List<DayReport> rows, {
    _is.OrderByBuilder<DayReportTable>? orderBy,
    _is.OrderByListBuilder<DayReportTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<DayReport>(
      rows,
      orderBy: orderBy?.call(DayReport.t),
      orderByList: orderByList?.call(DayReport.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [DayReport].
  Future<DayReport> deleteRow(
    _is.DatabaseSession session,
    DayReport row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<DayReport>(
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
  Future<List<DayReport>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<DayReportTable> where,
    _is.OrderByBuilder<DayReportTable>? orderBy,
    _is.OrderByListBuilder<DayReportTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<DayReport>(
      where: where(DayReport.t),
      orderBy: orderBy?.call(DayReport.t),
      orderByList: orderByList?.call(DayReport.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DayReportTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<DayReport>(
      where: where?.call(DayReport.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [DayReport] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<DayReportTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<DayReport>(
      where: where(DayReport.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
