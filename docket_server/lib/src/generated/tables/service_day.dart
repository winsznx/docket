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
import '../enums/day_state.dart' as _iglmd807;

abstract class ServiceDay
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  ServiceDay._({
    this.id,
    required this.clinicId,
    required this.serviceDate,
    required this.state,
    required this.openedAt,
    this.closedAt,
  });

  factory ServiceDay({
    _is.UuidValue? id,
    required _is.UuidValue clinicId,
    required String serviceDate,
    required _iglmd807.DayState state,
    required DateTime openedAt,
    DateTime? closedAt,
  }) = _ServiceDayImpl;

  factory ServiceDay.fromJson(Map<String, dynamic> jsonSerialization) {
    return ServiceDay(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      clinicId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['clinicId'],
      ),
      serviceDate: jsonSerialization['serviceDate'] as String,
      state: _iglmd807.DayState.fromJson(
        (jsonSerialization['state'] as String),
      ),
      openedAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['openedAt'],
      ),
      closedAt: jsonSerialization['closedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['closedAt']),
    );
  }

  static final t = ServiceDayTable();

  static const db = ServiceDayRepository._();

  @override
  _is.UuidValue? id;

  _is.UuidValue clinicId;

  String serviceDate;

  _iglmd807.DayState state;

  DateTime openedAt;

  DateTime? closedAt;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [ServiceDay]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ServiceDay copyWith({
    _is.UuidValue? id,
    _is.UuidValue? clinicId,
    String? serviceDate,
    _iglmd807.DayState? state,
    DateTime? openedAt,
    DateTime? closedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ServiceDay',
      if (id != null) 'id': id?.toJson(),
      'clinicId': clinicId.toJson(),
      'serviceDate': serviceDate,
      'state': state.toJson(),
      'openedAt': openedAt.toJson(),
      if (closedAt != null) 'closedAt': closedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ServiceDay',
      if (id != null) 'id': id?.toJson(),
      'clinicId': clinicId.toJson(),
      'serviceDate': serviceDate,
      'state': state.toJson(),
      'openedAt': openedAt.toJson(),
      if (closedAt != null) 'closedAt': closedAt?.toJson(),
    };
  }

  static ServiceDayInclude include() {
    return ServiceDayInclude._();
  }

  static ServiceDayIncludeList includeList({
    _is.WhereExpressionBuilder<ServiceDayTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ServiceDayTable>? orderBy,
    _is.OrderByListBuilder<ServiceDayTable>? orderByList,
    ServiceDayInclude? include,
  }) {
    return ServiceDayIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ServiceDay.t),
      orderByList: orderByList?.call(ServiceDay.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ServiceDayImpl extends ServiceDay {
  _ServiceDayImpl({
    _is.UuidValue? id,
    required _is.UuidValue clinicId,
    required String serviceDate,
    required _iglmd807.DayState state,
    required DateTime openedAt,
    DateTime? closedAt,
  }) : super._(
         id: id,
         clinicId: clinicId,
         serviceDate: serviceDate,
         state: state,
         openedAt: openedAt,
         closedAt: closedAt,
       );

  /// Returns a shallow copy of this [ServiceDay]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ServiceDay copyWith({
    Object? id = _Undefined,
    _is.UuidValue? clinicId,
    String? serviceDate,
    _iglmd807.DayState? state,
    DateTime? openedAt,
    Object? closedAt = _Undefined,
  }) {
    return ServiceDay(
      id: id is _is.UuidValue? ? id : this.id,
      clinicId: clinicId ?? this.clinicId,
      serviceDate: serviceDate ?? this.serviceDate,
      state: state ?? this.state,
      openedAt: openedAt ?? this.openedAt,
      closedAt: closedAt is DateTime? ? closedAt : this.closedAt,
    );
  }
}

class ServiceDayUpdateTable extends _is.UpdateTable<ServiceDayTable> {
  ServiceDayUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> clinicId(_is.UuidValue value) =>
      _is.ColumnValue(
        table.clinicId,
        value,
      );

  _is.ColumnValue<String, String> serviceDate(String value) => _is.ColumnValue(
    table.serviceDate,
    value,
  );

  _is.ColumnValue<_iglmd807.DayState, _iglmd807.DayState> state(
    _iglmd807.DayState value,
  ) => _is.ColumnValue(
    table.state,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> openedAt(DateTime value) =>
      _is.ColumnValue(
        table.openedAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> closedAt(DateTime? value) =>
      _is.ColumnValue(
        table.closedAt,
        value,
      );
}

class ServiceDayTable extends _is.Table<_is.UuidValue?> {
  ServiceDayTable({super.tableRelation}) : super(tableName: 'service_day') {
    updateTable = ServiceDayUpdateTable(this);
    clinicId = _is.ColumnUuid(
      'clinicId',
      this,
    );
    serviceDate = _is.ColumnString(
      'serviceDate',
      this,
    );
    state = _is.ColumnEnum(
      'state',
      this,
      _is.EnumSerialization.byName,
    );
    openedAt = _is.ColumnDateTime(
      'openedAt',
      this,
    );
    closedAt = _is.ColumnDateTime(
      'closedAt',
      this,
    );
  }

  late final ServiceDayUpdateTable updateTable;

  late final _is.ColumnUuid clinicId;

  late final _is.ColumnString serviceDate;

  late final _is.ColumnEnum<_iglmd807.DayState> state;

  late final _is.ColumnDateTime openedAt;

  late final _is.ColumnDateTime closedAt;

  @override
  List<_is.Column> get columns => [
    id,
    clinicId,
    serviceDate,
    state,
    openedAt,
    closedAt,
  ];
}

class ServiceDayInclude extends _is.IncludeObject {
  ServiceDayInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => ServiceDay.t;
}

class ServiceDayIncludeList extends _is.IncludeList {
  ServiceDayIncludeList._({
    _is.WhereExpressionBuilder<ServiceDayTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ServiceDay.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => ServiceDay.t;
}

class ServiceDayRepository {
  const ServiceDayRepository._();

  /// Returns a list of [ServiceDay]s matching the given query parameters.
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
  Future<List<ServiceDay>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ServiceDayTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ServiceDayTable>? orderBy,
    _is.OrderByListBuilder<ServiceDayTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ServiceDay>(
      where: where?.call(ServiceDay.t),
      orderBy: orderBy?.call(ServiceDay.t),
      orderByList: orderByList?.call(ServiceDay.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [ServiceDay] matching the given query parameters.
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
  Future<ServiceDay?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ServiceDayTable>? where,
    int? offset,
    _is.OrderByBuilder<ServiceDayTable>? orderBy,
    _is.OrderByListBuilder<ServiceDayTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ServiceDay>(
      where: where?.call(ServiceDay.t),
      orderBy: orderBy?.call(ServiceDay.t),
      orderByList: orderByList?.call(ServiceDay.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ServiceDay] by its [id] or null if no such row exists.
  Future<ServiceDay?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ServiceDay>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ServiceDay]s in the list and returns the inserted rows.
  ///
  /// The returned [ServiceDay]s will have their `id` fields set.
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
  Future<List<ServiceDay>> insert(
    _is.DatabaseSession session,
    List<ServiceDay> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<ServiceDay>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [ServiceDay] and returns the inserted row.
  ///
  /// The returned [ServiceDay] will have its `id` field set.
  Future<ServiceDay> insertRow(
    _is.DatabaseSession session,
    ServiceDay row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<ServiceDay>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [ServiceDay]s in the list and returns the resulting rows.
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
  /// The returned [ServiceDay]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ServiceDay>> upsert(
    _is.DatabaseSession session,
    List<ServiceDay> rows, {
    required _is.ColumnSelections<ServiceDayTable> conflictColumns,
    _is.ColumnSelections<ServiceDayTable>? updateColumns,
    _is.WhereExpressionBuilder<ServiceDayTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<ServiceDay>(
      rows,
      conflictColumns: conflictColumns(ServiceDay.t),
      updateColumns: updateColumns?.call(ServiceDay.t),
      updateWhere: updateWhere?.call(ServiceDay.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [ServiceDay] and returns the resulting row.
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
  /// The returned [ServiceDay] will have its `id` field set.
  Future<ServiceDay?> upsertRow(
    _is.DatabaseSession session,
    ServiceDay row, {
    required _is.ColumnSelections<ServiceDayTable> conflictColumns,
    _is.ColumnSelections<ServiceDayTable>? updateColumns,
    _is.WhereExpressionBuilder<ServiceDayTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<ServiceDay>(
      row,
      conflictColumns: conflictColumns(ServiceDay.t),
      updateColumns: updateColumns?.call(ServiceDay.t),
      updateWhere: updateWhere?.call(ServiceDay.t),
      transaction: transaction,
    );
  }

  /// Updates all [ServiceDay]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ServiceDay>> update(
    _is.DatabaseSession session,
    List<ServiceDay> rows, {
    _is.ColumnSelections<ServiceDayTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<ServiceDay>(
      rows,
      columns: columns?.call(ServiceDay.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [ServiceDay]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ServiceDay> updateRow(
    _is.DatabaseSession session,
    ServiceDay row, {
    _is.ColumnSelections<ServiceDayTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<ServiceDay>(
      row,
      columns: columns?.call(ServiceDay.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ServiceDay] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ServiceDay?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<ServiceDayUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<ServiceDay>(
      id,
      columnValues: columnValues(ServiceDay.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ServiceDay]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ServiceDay>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<ServiceDayUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<ServiceDayTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ServiceDayTable>? orderBy,
    _is.OrderByListBuilder<ServiceDayTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<ServiceDay>(
      columnValues: columnValues(ServiceDay.t.updateTable),
      where: where(ServiceDay.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ServiceDay.t),
      orderByList: orderByList?.call(ServiceDay.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [ServiceDay]s in the list and returns the deleted rows.
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
  Future<List<ServiceDay>> delete(
    _is.DatabaseSession session,
    List<ServiceDay> rows, {
    _is.OrderByBuilder<ServiceDayTable>? orderBy,
    _is.OrderByListBuilder<ServiceDayTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<ServiceDay>(
      rows,
      orderBy: orderBy?.call(ServiceDay.t),
      orderByList: orderByList?.call(ServiceDay.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [ServiceDay].
  Future<ServiceDay> deleteRow(
    _is.DatabaseSession session,
    ServiceDay row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ServiceDay>(
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
  Future<List<ServiceDay>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ServiceDayTable> where,
    _is.OrderByBuilder<ServiceDayTable>? orderBy,
    _is.OrderByListBuilder<ServiceDayTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<ServiceDay>(
      where: where(ServiceDay.t),
      orderBy: orderBy?.call(ServiceDay.t),
      orderByList: orderByList?.call(ServiceDay.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ServiceDayTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<ServiceDay>(
      where: where?.call(ServiceDay.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ServiceDay] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ServiceDayTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ServiceDay>(
      where: where(ServiceDay.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
