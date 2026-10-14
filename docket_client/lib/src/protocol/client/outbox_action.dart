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
import '../enums/action_outcome.dart' as _iq4q6c7t;
import '../enums/docket_error_code.dart' as _i1jhh8n2;

abstract class OutboxAction
    implements _isd.TableRow<_isc.UuidValue?>, _isc.ProtocolSerialization {
  OutboxAction._({
    _isc.UuidValue? id,
    required this.seq,
    required this.actionJson,
    required this.createdAt,
    this.outcome,
    this.code,
    this.message,
    this.settledAt,
  }) : id = id ?? const _isc.Uuid().v7obj();

  factory OutboxAction({
    _isc.UuidValue? id,
    required int seq,
    required String actionJson,
    required DateTime createdAt,
    _iq4q6c7t.ActionOutcome? outcome,
    _i1jhh8n2.DocketErrorCode? code,
    String? message,
    DateTime? settledAt,
  }) = _OutboxActionImpl;

  factory OutboxAction.fromJson(Map<String, dynamic> jsonSerialization) {
    return OutboxAction(
      id: jsonSerialization['id'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      seq: jsonSerialization['seq'] as int,
      actionJson: jsonSerialization['actionJson'] as String,
      createdAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      outcome: jsonSerialization['outcome'] == null
          ? null
          : _iq4q6c7t.ActionOutcome.fromJson(
              (jsonSerialization['outcome'] as String),
            ),
      code: jsonSerialization['code'] == null
          ? null
          : _i1jhh8n2.DocketErrorCode.fromJson(
              (jsonSerialization['code'] as String),
            ),
      message: jsonSerialization['message'] as String?,
      settledAt: jsonSerialization['settledAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['settledAt']),
    );
  }

  static final t = OutboxActionTable();

  static const db = OutboxActionRepository._();

  @override
  _isc.UuidValue? id;

  int seq;

  String actionJson;

  DateTime createdAt;

  _iq4q6c7t.ActionOutcome? outcome;

  _i1jhh8n2.DocketErrorCode? code;

  String? message;

  DateTime? settledAt;

  @override
  _isd.Table<_isc.UuidValue?> get table => t;

  /// Returns a shallow copy of this [OutboxAction]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  OutboxAction copyWith({
    _isc.UuidValue? id,
    int? seq,
    String? actionJson,
    DateTime? createdAt,
    _iq4q6c7t.ActionOutcome? outcome,
    _i1jhh8n2.DocketErrorCode? code,
    String? message,
    DateTime? settledAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'OutboxAction',
      if (id != null) 'id': id?.toJson(),
      'seq': seq,
      'actionJson': actionJson,
      'createdAt': createdAt.toJson(),
      if (outcome != null) 'outcome': outcome?.toJson(),
      if (code != null) 'code': code?.toJson(),
      if (message != null) 'message': message,
      if (settledAt != null) 'settledAt': settledAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'OutboxAction',
      if (id != null) 'id': id?.toJson(),
      'seq': seq,
      'actionJson': actionJson,
      'createdAt': createdAt.toJson(),
      if (outcome != null) 'outcome': outcome?.toJson(),
      if (code != null) 'code': code?.toJson(),
      if (message != null) 'message': message,
      if (settledAt != null) 'settledAt': settledAt?.toJson(),
    };
  }

  static OutboxActionInclude include() {
    return OutboxActionInclude._();
  }

  static OutboxActionIncludeList includeList({
    _isd.WhereExpressionBuilder<OutboxActionTable>? where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<OutboxActionTable>? orderBy,
    _isd.OrderByListBuilder<OutboxActionTable>? orderByList,
    OutboxActionInclude? include,
  }) {
    return OutboxActionIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(OutboxAction.t),
      orderByList: orderByList?.call(OutboxAction.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _OutboxActionImpl extends OutboxAction {
  _OutboxActionImpl({
    _isc.UuidValue? id,
    required int seq,
    required String actionJson,
    required DateTime createdAt,
    _iq4q6c7t.ActionOutcome? outcome,
    _i1jhh8n2.DocketErrorCode? code,
    String? message,
    DateTime? settledAt,
  }) : super._(
         id: id,
         seq: seq,
         actionJson: actionJson,
         createdAt: createdAt,
         outcome: outcome,
         code: code,
         message: message,
         settledAt: settledAt,
       );

  /// Returns a shallow copy of this [OutboxAction]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  OutboxAction copyWith({
    Object? id = _Undefined,
    int? seq,
    String? actionJson,
    DateTime? createdAt,
    Object? outcome = _Undefined,
    Object? code = _Undefined,
    Object? message = _Undefined,
    Object? settledAt = _Undefined,
  }) {
    return OutboxAction(
      id: id is _isc.UuidValue? ? id : this.id,
      seq: seq ?? this.seq,
      actionJson: actionJson ?? this.actionJson,
      createdAt: createdAt ?? this.createdAt,
      outcome: outcome is _iq4q6c7t.ActionOutcome? ? outcome : this.outcome,
      code: code is _i1jhh8n2.DocketErrorCode? ? code : this.code,
      message: message is String? ? message : this.message,
      settledAt: settledAt is DateTime? ? settledAt : this.settledAt,
    );
  }
}

class OutboxActionUpdateTable extends _isd.UpdateTable<OutboxActionTable> {
  OutboxActionUpdateTable(super.table);

  _isd.ColumnValue<int, int> seq(int value) => _isd.ColumnValue(
    table.seq,
    value,
  );

  _isd.ColumnValue<String, String> actionJson(String value) => _isd.ColumnValue(
    table.actionJson,
    value,
  );

  _isd.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _isd.ColumnValue(
        table.createdAt,
        value,
      );

  _isd.ColumnValue<_iq4q6c7t.ActionOutcome, _iq4q6c7t.ActionOutcome> outcome(
    _iq4q6c7t.ActionOutcome? value,
  ) => _isd.ColumnValue(
    table.outcome,
    value,
  );

  _isd.ColumnValue<_i1jhh8n2.DocketErrorCode, _i1jhh8n2.DocketErrorCode> code(
    _i1jhh8n2.DocketErrorCode? value,
  ) => _isd.ColumnValue(
    table.code,
    value,
  );

  _isd.ColumnValue<String, String> message(String? value) => _isd.ColumnValue(
    table.message,
    value,
  );

  _isd.ColumnValue<DateTime, DateTime> settledAt(DateTime? value) =>
      _isd.ColumnValue(
        table.settledAt,
        value,
      );
}

class OutboxActionTable extends _isd.Table<_isc.UuidValue?> {
  OutboxActionTable({super.tableRelation}) : super(tableName: 'outbox_action') {
    updateTable = OutboxActionUpdateTable(this);
    seq = _isd.ColumnInt(
      'seq',
      this,
    );
    actionJson = _isd.ColumnString(
      'actionJson',
      this,
    );
    createdAt = _isd.ColumnDateTime(
      'createdAt',
      this,
    );
    outcome = _isd.ColumnEnum(
      'outcome',
      this,
      _isd.EnumSerialization.byName,
    );
    code = _isd.ColumnEnum(
      'code',
      this,
      _isd.EnumSerialization.byName,
    );
    message = _isd.ColumnString(
      'message',
      this,
    );
    settledAt = _isd.ColumnDateTime(
      'settledAt',
      this,
    );
  }

  late final OutboxActionUpdateTable updateTable;

  late final _isd.ColumnInt seq;

  late final _isd.ColumnString actionJson;

  late final _isd.ColumnDateTime createdAt;

  late final _isd.ColumnEnum<_iq4q6c7t.ActionOutcome> outcome;

  late final _isd.ColumnEnum<_i1jhh8n2.DocketErrorCode> code;

  late final _isd.ColumnString message;

  late final _isd.ColumnDateTime settledAt;

  @override
  List<_isd.Column> get columns => [
    id,
    seq,
    actionJson,
    createdAt,
    outcome,
    code,
    message,
    settledAt,
  ];
}

class OutboxActionInclude extends _isd.IncludeObject {
  OutboxActionInclude._();

  @override
  Map<String, _isd.Include?> get includes => {};

  @override
  _isd.Table<_isc.UuidValue?> get table => OutboxAction.t;
}

class OutboxActionIncludeList extends _isd.IncludeList {
  OutboxActionIncludeList._({
    _isd.WhereExpressionBuilder<OutboxActionTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(OutboxAction.t);
  }

  @override
  Map<String, _isd.Include?> get includes => include?.includes ?? {};

  @override
  _isd.Table<_isc.UuidValue?> get table => OutboxAction.t;
}

class OutboxActionRepository {
  const OutboxActionRepository._();

  /// Returns a list of [OutboxAction]s matching the given query parameters.
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
  Future<List<OutboxAction>> find(
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<OutboxActionTable>? where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<OutboxActionTable>? orderBy,
    _isd.OrderByListBuilder<OutboxActionTable>? orderByList,
    _isd.Transaction? transaction,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<OutboxAction>(
      where: where?.call(OutboxAction.t),
      orderBy: orderBy?.call(OutboxAction.t),
      orderByList: orderByList?.call(OutboxAction.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [OutboxAction] matching the given query parameters.
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
  Future<OutboxAction?> findFirstRow(
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<OutboxActionTable>? where,
    int? offset,
    _isd.OrderByBuilder<OutboxActionTable>? orderBy,
    _isd.OrderByListBuilder<OutboxActionTable>? orderByList,
    _isd.Transaction? transaction,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<OutboxAction>(
      where: where?.call(OutboxAction.t),
      orderBy: orderBy?.call(OutboxAction.t),
      orderByList: orderByList?.call(OutboxAction.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [OutboxAction] by its [id] or null if no such row exists.
  Future<OutboxAction?> findById(
    _isd.DatabaseSession session,
    _isc.UuidValue id, {
    _isd.Transaction? transaction,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<OutboxAction>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [OutboxAction]s in the list and returns the inserted rows.
  ///
  /// The returned [OutboxAction]s will have their `id` fields set.
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
  Future<List<OutboxAction>> insert(
    _isd.DatabaseSession session,
    List<OutboxAction> rows, {
    _isd.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<OutboxAction>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [OutboxAction] and returns the inserted row.
  ///
  /// The returned [OutboxAction] will have its `id` field set.
  Future<OutboxAction> insertRow(
    _isd.DatabaseSession session,
    OutboxAction row, {
    _isd.Transaction? transaction,
  }) async {
    return session.db.insertRow<OutboxAction>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [OutboxAction]s in the list and returns the resulting rows.
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
  /// The returned [OutboxAction]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<OutboxAction>> upsert(
    _isd.DatabaseSession session,
    List<OutboxAction> rows, {
    required _isd.ColumnSelections<OutboxActionTable> conflictColumns,
    _isd.ColumnSelections<OutboxActionTable>? updateColumns,
    _isd.WhereExpressionBuilder<OutboxActionTable>? updateWhere,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<OutboxAction>(
      rows,
      conflictColumns: conflictColumns(OutboxAction.t),
      updateColumns: updateColumns?.call(OutboxAction.t),
      updateWhere: updateWhere?.call(OutboxAction.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [OutboxAction] and returns the resulting row.
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
  /// The returned [OutboxAction] will have its `id` field set.
  Future<OutboxAction?> upsertRow(
    _isd.DatabaseSession session,
    OutboxAction row, {
    required _isd.ColumnSelections<OutboxActionTable> conflictColumns,
    _isd.ColumnSelections<OutboxActionTable>? updateColumns,
    _isd.WhereExpressionBuilder<OutboxActionTable>? updateWhere,
    _isd.Transaction? transaction,
  }) async {
    return session.db.upsertRow<OutboxAction>(
      row,
      conflictColumns: conflictColumns(OutboxAction.t),
      updateColumns: updateColumns?.call(OutboxAction.t),
      updateWhere: updateWhere?.call(OutboxAction.t),
      transaction: transaction,
    );
  }

  /// Updates all [OutboxAction]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<OutboxAction>> update(
    _isd.DatabaseSession session,
    List<OutboxAction> rows, {
    _isd.ColumnSelections<OutboxActionTable>? columns,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<OutboxAction>(
      rows,
      columns: columns?.call(OutboxAction.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [OutboxAction]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<OutboxAction> updateRow(
    _isd.DatabaseSession session,
    OutboxAction row, {
    _isd.ColumnSelections<OutboxActionTable>? columns,
    _isd.Transaction? transaction,
  }) async {
    return session.db.updateRow<OutboxAction>(
      row,
      columns: columns?.call(OutboxAction.t),
      transaction: transaction,
    );
  }

  /// Updates a single [OutboxAction] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<OutboxAction?> updateById(
    _isd.DatabaseSession session,
    _isc.UuidValue id, {
    required _isd.ColumnValueListBuilder<OutboxActionUpdateTable> columnValues,
    _isd.Transaction? transaction,
  }) async {
    return session.db.updateById<OutboxAction>(
      id,
      columnValues: columnValues(OutboxAction.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [OutboxAction]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<OutboxAction>> updateWhere(
    _isd.DatabaseSession session, {
    required _isd.ColumnValueListBuilder<OutboxActionUpdateTable> columnValues,
    required _isd.WhereExpressionBuilder<OutboxActionTable> where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<OutboxActionTable>? orderBy,
    _isd.OrderByListBuilder<OutboxActionTable>? orderByList,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<OutboxAction>(
      columnValues: columnValues(OutboxAction.t.updateTable),
      where: where(OutboxAction.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(OutboxAction.t),
      orderByList: orderByList?.call(OutboxAction.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [OutboxAction]s in the list and returns the deleted rows.
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
  Future<List<OutboxAction>> delete(
    _isd.DatabaseSession session,
    List<OutboxAction> rows, {
    _isd.OrderByBuilder<OutboxActionTable>? orderBy,
    _isd.OrderByListBuilder<OutboxActionTable>? orderByList,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<OutboxAction>(
      rows,
      orderBy: orderBy?.call(OutboxAction.t),
      orderByList: orderByList?.call(OutboxAction.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [OutboxAction].
  Future<OutboxAction> deleteRow(
    _isd.DatabaseSession session,
    OutboxAction row, {
    _isd.Transaction? transaction,
  }) async {
    return session.db.deleteRow<OutboxAction>(
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
  Future<List<OutboxAction>> deleteWhere(
    _isd.DatabaseSession session, {
    required _isd.WhereExpressionBuilder<OutboxActionTable> where,
    _isd.OrderByBuilder<OutboxActionTable>? orderBy,
    _isd.OrderByListBuilder<OutboxActionTable>? orderByList,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<OutboxAction>(
      where: where(OutboxAction.t),
      orderBy: orderBy?.call(OutboxAction.t),
      orderByList: orderByList?.call(OutboxAction.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<OutboxActionTable>? where,
    int? limit,
    _isd.Transaction? transaction,
  }) async {
    return session.db.count<OutboxAction>(
      where: where?.call(OutboxAction.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [OutboxAction] rows matching the [where] expression.
  Future<void> lockRows(
    _isd.DatabaseSession session, {
    required _isd.WhereExpressionBuilder<OutboxActionTable> where,
    required _isd.LockMode lockMode,
    required _isd.Transaction transaction,
    _isd.LockBehavior lockBehavior = _isd.LockBehavior.wait,
  }) async {
    return session.db.lockRows<OutboxAction>(
      where: where(OutboxAction.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
