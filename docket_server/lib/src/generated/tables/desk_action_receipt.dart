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
import '../enums/action_outcome.dart' as _iq4q6c7t;
import '../enums/docket_error_code.dart' as _i1jhh8n2;

abstract class DeskActionReceipt
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  DeskActionReceipt._({
    this.id,
    required this.actionId,
    required this.deviceId,
    required this.seq,
    required this.clinicId,
    required this.outcome,
    this.code,
    this.message,
    this.ticketId,
    required this.appliedAt,
  });

  factory DeskActionReceipt({
    _is.UuidValue? id,
    required _is.UuidValue actionId,
    required _is.UuidValue deviceId,
    required int seq,
    required _is.UuidValue clinicId,
    required _iq4q6c7t.ActionOutcome outcome,
    _i1jhh8n2.DocketErrorCode? code,
    String? message,
    _is.UuidValue? ticketId,
    required DateTime appliedAt,
  }) = _DeskActionReceiptImpl;

  factory DeskActionReceipt.fromJson(Map<String, dynamic> jsonSerialization) {
    return DeskActionReceipt(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      actionId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['actionId'],
      ),
      deviceId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['deviceId'],
      ),
      seq: jsonSerialization['seq'] as int,
      clinicId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['clinicId'],
      ),
      outcome: _iq4q6c7t.ActionOutcome.fromJson(
        (jsonSerialization['outcome'] as String),
      ),
      code: jsonSerialization['code'] == null
          ? null
          : _i1jhh8n2.DocketErrorCode.fromJson(
              (jsonSerialization['code'] as String),
            ),
      message: jsonSerialization['message'] as String?,
      ticketId: jsonSerialization['ticketId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['ticketId']),
      appliedAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['appliedAt'],
      ),
    );
  }

  static final t = DeskActionReceiptTable();

  static const db = DeskActionReceiptRepository._();

  @override
  _is.UuidValue? id;

  _is.UuidValue actionId;

  _is.UuidValue deviceId;

  int seq;

  _is.UuidValue clinicId;

  _iq4q6c7t.ActionOutcome outcome;

  _i1jhh8n2.DocketErrorCode? code;

  String? message;

  _is.UuidValue? ticketId;

  DateTime appliedAt;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [DeskActionReceipt]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  DeskActionReceipt copyWith({
    _is.UuidValue? id,
    _is.UuidValue? actionId,
    _is.UuidValue? deviceId,
    int? seq,
    _is.UuidValue? clinicId,
    _iq4q6c7t.ActionOutcome? outcome,
    _i1jhh8n2.DocketErrorCode? code,
    String? message,
    _is.UuidValue? ticketId,
    DateTime? appliedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DeskActionReceipt',
      if (id != null) 'id': id?.toJson(),
      'actionId': actionId.toJson(),
      'deviceId': deviceId.toJson(),
      'seq': seq,
      'clinicId': clinicId.toJson(),
      'outcome': outcome.toJson(),
      if (code != null) 'code': code?.toJson(),
      if (message != null) 'message': message,
      if (ticketId != null) 'ticketId': ticketId?.toJson(),
      'appliedAt': appliedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DeskActionReceipt',
      if (id != null) 'id': id?.toJson(),
      'actionId': actionId.toJson(),
      'deviceId': deviceId.toJson(),
      'seq': seq,
      'clinicId': clinicId.toJson(),
      'outcome': outcome.toJson(),
      if (code != null) 'code': code?.toJson(),
      if (message != null) 'message': message,
      if (ticketId != null) 'ticketId': ticketId?.toJson(),
      'appliedAt': appliedAt.toJson(),
    };
  }

  static DeskActionReceiptInclude include() {
    return DeskActionReceiptInclude._();
  }

  static DeskActionReceiptIncludeList includeList({
    _is.WhereExpressionBuilder<DeskActionReceiptTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DeskActionReceiptTable>? orderBy,
    _is.OrderByListBuilder<DeskActionReceiptTable>? orderByList,
    DeskActionReceiptInclude? include,
  }) {
    return DeskActionReceiptIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DeskActionReceipt.t),
      orderByList: orderByList?.call(DeskActionReceipt.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DeskActionReceiptImpl extends DeskActionReceipt {
  _DeskActionReceiptImpl({
    _is.UuidValue? id,
    required _is.UuidValue actionId,
    required _is.UuidValue deviceId,
    required int seq,
    required _is.UuidValue clinicId,
    required _iq4q6c7t.ActionOutcome outcome,
    _i1jhh8n2.DocketErrorCode? code,
    String? message,
    _is.UuidValue? ticketId,
    required DateTime appliedAt,
  }) : super._(
         id: id,
         actionId: actionId,
         deviceId: deviceId,
         seq: seq,
         clinicId: clinicId,
         outcome: outcome,
         code: code,
         message: message,
         ticketId: ticketId,
         appliedAt: appliedAt,
       );

  /// Returns a shallow copy of this [DeskActionReceipt]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  DeskActionReceipt copyWith({
    Object? id = _Undefined,
    _is.UuidValue? actionId,
    _is.UuidValue? deviceId,
    int? seq,
    _is.UuidValue? clinicId,
    _iq4q6c7t.ActionOutcome? outcome,
    Object? code = _Undefined,
    Object? message = _Undefined,
    Object? ticketId = _Undefined,
    DateTime? appliedAt,
  }) {
    return DeskActionReceipt(
      id: id is _is.UuidValue? ? id : this.id,
      actionId: actionId ?? this.actionId,
      deviceId: deviceId ?? this.deviceId,
      seq: seq ?? this.seq,
      clinicId: clinicId ?? this.clinicId,
      outcome: outcome ?? this.outcome,
      code: code is _i1jhh8n2.DocketErrorCode? ? code : this.code,
      message: message is String? ? message : this.message,
      ticketId: ticketId is _is.UuidValue? ? ticketId : this.ticketId,
      appliedAt: appliedAt ?? this.appliedAt,
    );
  }
}

class DeskActionReceiptUpdateTable
    extends _is.UpdateTable<DeskActionReceiptTable> {
  DeskActionReceiptUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> actionId(_is.UuidValue value) =>
      _is.ColumnValue(
        table.actionId,
        value,
      );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> deviceId(_is.UuidValue value) =>
      _is.ColumnValue(
        table.deviceId,
        value,
      );

  _is.ColumnValue<int, int> seq(int value) => _is.ColumnValue(
    table.seq,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> clinicId(_is.UuidValue value) =>
      _is.ColumnValue(
        table.clinicId,
        value,
      );

  _is.ColumnValue<_iq4q6c7t.ActionOutcome, _iq4q6c7t.ActionOutcome> outcome(
    _iq4q6c7t.ActionOutcome value,
  ) => _is.ColumnValue(
    table.outcome,
    value,
  );

  _is.ColumnValue<_i1jhh8n2.DocketErrorCode, _i1jhh8n2.DocketErrorCode> code(
    _i1jhh8n2.DocketErrorCode? value,
  ) => _is.ColumnValue(
    table.code,
    value,
  );

  _is.ColumnValue<String, String> message(String? value) => _is.ColumnValue(
    table.message,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> ticketId(
    _is.UuidValue? value,
  ) => _is.ColumnValue(
    table.ticketId,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> appliedAt(DateTime value) =>
      _is.ColumnValue(
        table.appliedAt,
        value,
      );
}

class DeskActionReceiptTable extends _is.Table<_is.UuidValue?> {
  DeskActionReceiptTable({super.tableRelation})
    : super(tableName: 'desk_action_receipt') {
    updateTable = DeskActionReceiptUpdateTable(this);
    actionId = _is.ColumnUuid(
      'actionId',
      this,
    );
    deviceId = _is.ColumnUuid(
      'deviceId',
      this,
    );
    seq = _is.ColumnInt(
      'seq',
      this,
    );
    clinicId = _is.ColumnUuid(
      'clinicId',
      this,
    );
    outcome = _is.ColumnEnum(
      'outcome',
      this,
      _is.EnumSerialization.byName,
    );
    code = _is.ColumnEnum(
      'code',
      this,
      _is.EnumSerialization.byName,
    );
    message = _is.ColumnString(
      'message',
      this,
    );
    ticketId = _is.ColumnUuid(
      'ticketId',
      this,
    );
    appliedAt = _is.ColumnDateTime(
      'appliedAt',
      this,
    );
  }

  late final DeskActionReceiptUpdateTable updateTable;

  late final _is.ColumnUuid actionId;

  late final _is.ColumnUuid deviceId;

  late final _is.ColumnInt seq;

  late final _is.ColumnUuid clinicId;

  late final _is.ColumnEnum<_iq4q6c7t.ActionOutcome> outcome;

  late final _is.ColumnEnum<_i1jhh8n2.DocketErrorCode> code;

  late final _is.ColumnString message;

  late final _is.ColumnUuid ticketId;

  late final _is.ColumnDateTime appliedAt;

  @override
  List<_is.Column> get columns => [
    id,
    actionId,
    deviceId,
    seq,
    clinicId,
    outcome,
    code,
    message,
    ticketId,
    appliedAt,
  ];
}

class DeskActionReceiptInclude extends _is.IncludeObject {
  DeskActionReceiptInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => DeskActionReceipt.t;
}

class DeskActionReceiptIncludeList extends _is.IncludeList {
  DeskActionReceiptIncludeList._({
    _is.WhereExpressionBuilder<DeskActionReceiptTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(DeskActionReceipt.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => DeskActionReceipt.t;
}

class DeskActionReceiptRepository {
  const DeskActionReceiptRepository._();

  /// Returns a list of [DeskActionReceipt]s matching the given query parameters.
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
  Future<List<DeskActionReceipt>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DeskActionReceiptTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DeskActionReceiptTable>? orderBy,
    _is.OrderByListBuilder<DeskActionReceiptTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<DeskActionReceipt>(
      where: where?.call(DeskActionReceipt.t),
      orderBy: orderBy?.call(DeskActionReceipt.t),
      orderByList: orderByList?.call(DeskActionReceipt.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [DeskActionReceipt] matching the given query parameters.
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
  Future<DeskActionReceipt?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DeskActionReceiptTable>? where,
    int? offset,
    _is.OrderByBuilder<DeskActionReceiptTable>? orderBy,
    _is.OrderByListBuilder<DeskActionReceiptTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<DeskActionReceipt>(
      where: where?.call(DeskActionReceipt.t),
      orderBy: orderBy?.call(DeskActionReceipt.t),
      orderByList: orderByList?.call(DeskActionReceipt.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [DeskActionReceipt] by its [id] or null if no such row exists.
  Future<DeskActionReceipt?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<DeskActionReceipt>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [DeskActionReceipt]s in the list and returns the inserted rows.
  ///
  /// The returned [DeskActionReceipt]s will have their `id` fields set.
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
  Future<List<DeskActionReceipt>> insert(
    _is.DatabaseSession session,
    List<DeskActionReceipt> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<DeskActionReceipt>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [DeskActionReceipt] and returns the inserted row.
  ///
  /// The returned [DeskActionReceipt] will have its `id` field set.
  Future<DeskActionReceipt> insertRow(
    _is.DatabaseSession session,
    DeskActionReceipt row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<DeskActionReceipt>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [DeskActionReceipt]s in the list and returns the resulting rows.
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
  /// The returned [DeskActionReceipt]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DeskActionReceipt>> upsert(
    _is.DatabaseSession session,
    List<DeskActionReceipt> rows, {
    required _is.ColumnSelections<DeskActionReceiptTable> conflictColumns,
    _is.ColumnSelections<DeskActionReceiptTable>? updateColumns,
    _is.WhereExpressionBuilder<DeskActionReceiptTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<DeskActionReceipt>(
      rows,
      conflictColumns: conflictColumns(DeskActionReceipt.t),
      updateColumns: updateColumns?.call(DeskActionReceipt.t),
      updateWhere: updateWhere?.call(DeskActionReceipt.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [DeskActionReceipt] and returns the resulting row.
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
  /// The returned [DeskActionReceipt] will have its `id` field set.
  Future<DeskActionReceipt?> upsertRow(
    _is.DatabaseSession session,
    DeskActionReceipt row, {
    required _is.ColumnSelections<DeskActionReceiptTable> conflictColumns,
    _is.ColumnSelections<DeskActionReceiptTable>? updateColumns,
    _is.WhereExpressionBuilder<DeskActionReceiptTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<DeskActionReceipt>(
      row,
      conflictColumns: conflictColumns(DeskActionReceipt.t),
      updateColumns: updateColumns?.call(DeskActionReceipt.t),
      updateWhere: updateWhere?.call(DeskActionReceipt.t),
      transaction: transaction,
    );
  }

  /// Updates all [DeskActionReceipt]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DeskActionReceipt>> update(
    _is.DatabaseSession session,
    List<DeskActionReceipt> rows, {
    _is.ColumnSelections<DeskActionReceiptTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<DeskActionReceipt>(
      rows,
      columns: columns?.call(DeskActionReceipt.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [DeskActionReceipt]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<DeskActionReceipt> updateRow(
    _is.DatabaseSession session,
    DeskActionReceipt row, {
    _is.ColumnSelections<DeskActionReceiptTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<DeskActionReceipt>(
      row,
      columns: columns?.call(DeskActionReceipt.t),
      transaction: transaction,
    );
  }

  /// Updates a single [DeskActionReceipt] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<DeskActionReceipt?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<DeskActionReceiptUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<DeskActionReceipt>(
      id,
      columnValues: columnValues(DeskActionReceipt.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [DeskActionReceipt]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DeskActionReceipt>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<DeskActionReceiptUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<DeskActionReceiptTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DeskActionReceiptTable>? orderBy,
    _is.OrderByListBuilder<DeskActionReceiptTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<DeskActionReceipt>(
      columnValues: columnValues(DeskActionReceipt.t.updateTable),
      where: where(DeskActionReceipt.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DeskActionReceipt.t),
      orderByList: orderByList?.call(DeskActionReceipt.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [DeskActionReceipt]s in the list and returns the deleted rows.
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
  Future<List<DeskActionReceipt>> delete(
    _is.DatabaseSession session,
    List<DeskActionReceipt> rows, {
    _is.OrderByBuilder<DeskActionReceiptTable>? orderBy,
    _is.OrderByListBuilder<DeskActionReceiptTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<DeskActionReceipt>(
      rows,
      orderBy: orderBy?.call(DeskActionReceipt.t),
      orderByList: orderByList?.call(DeskActionReceipt.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [DeskActionReceipt].
  Future<DeskActionReceipt> deleteRow(
    _is.DatabaseSession session,
    DeskActionReceipt row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<DeskActionReceipt>(
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
  Future<List<DeskActionReceipt>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<DeskActionReceiptTable> where,
    _is.OrderByBuilder<DeskActionReceiptTable>? orderBy,
    _is.OrderByListBuilder<DeskActionReceiptTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<DeskActionReceipt>(
      where: where(DeskActionReceipt.t),
      orderBy: orderBy?.call(DeskActionReceipt.t),
      orderByList: orderByList?.call(DeskActionReceipt.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DeskActionReceiptTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<DeskActionReceipt>(
      where: where?.call(DeskActionReceipt.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [DeskActionReceipt] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<DeskActionReceiptTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<DeskActionReceipt>(
      where: where(DeskActionReceipt.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
