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

abstract class DeskPresence
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  DeskPresence._({
    this.id,
    required this.clinicId,
    required this.deviceId,
    this.roomId,
    required this.actorRef,
    required this.lastSeenAt,
  });

  factory DeskPresence({
    _is.UuidValue? id,
    required _is.UuidValue clinicId,
    required _is.UuidValue deviceId,
    _is.UuidValue? roomId,
    required String actorRef,
    required DateTime lastSeenAt,
  }) = _DeskPresenceImpl;

  factory DeskPresence.fromJson(Map<String, dynamic> jsonSerialization) {
    return DeskPresence(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      clinicId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['clinicId'],
      ),
      deviceId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['deviceId'],
      ),
      roomId: jsonSerialization['roomId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['roomId']),
      actorRef: jsonSerialization['actorRef'] as String,
      lastSeenAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['lastSeenAt'],
      ),
    );
  }

  static final t = DeskPresenceTable();

  static const db = DeskPresenceRepository._();

  @override
  _is.UuidValue? id;

  _is.UuidValue clinicId;

  _is.UuidValue deviceId;

  _is.UuidValue? roomId;

  String actorRef;

  DateTime lastSeenAt;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [DeskPresence]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  DeskPresence copyWith({
    _is.UuidValue? id,
    _is.UuidValue? clinicId,
    _is.UuidValue? deviceId,
    _is.UuidValue? roomId,
    String? actorRef,
    DateTime? lastSeenAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DeskPresence',
      if (id != null) 'id': id?.toJson(),
      'clinicId': clinicId.toJson(),
      'deviceId': deviceId.toJson(),
      if (roomId != null) 'roomId': roomId?.toJson(),
      'actorRef': actorRef,
      'lastSeenAt': lastSeenAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DeskPresence',
      if (id != null) 'id': id?.toJson(),
      'clinicId': clinicId.toJson(),
      'deviceId': deviceId.toJson(),
      if (roomId != null) 'roomId': roomId?.toJson(),
      'actorRef': actorRef,
      'lastSeenAt': lastSeenAt.toJson(),
    };
  }

  static DeskPresenceInclude include() {
    return DeskPresenceInclude._();
  }

  static DeskPresenceIncludeList includeList({
    _is.WhereExpressionBuilder<DeskPresenceTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DeskPresenceTable>? orderBy,
    _is.OrderByListBuilder<DeskPresenceTable>? orderByList,
    DeskPresenceInclude? include,
  }) {
    return DeskPresenceIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DeskPresence.t),
      orderByList: orderByList?.call(DeskPresence.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DeskPresenceImpl extends DeskPresence {
  _DeskPresenceImpl({
    _is.UuidValue? id,
    required _is.UuidValue clinicId,
    required _is.UuidValue deviceId,
    _is.UuidValue? roomId,
    required String actorRef,
    required DateTime lastSeenAt,
  }) : super._(
         id: id,
         clinicId: clinicId,
         deviceId: deviceId,
         roomId: roomId,
         actorRef: actorRef,
         lastSeenAt: lastSeenAt,
       );

  /// Returns a shallow copy of this [DeskPresence]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  DeskPresence copyWith({
    Object? id = _Undefined,
    _is.UuidValue? clinicId,
    _is.UuidValue? deviceId,
    Object? roomId = _Undefined,
    String? actorRef,
    DateTime? lastSeenAt,
  }) {
    return DeskPresence(
      id: id is _is.UuidValue? ? id : this.id,
      clinicId: clinicId ?? this.clinicId,
      deviceId: deviceId ?? this.deviceId,
      roomId: roomId is _is.UuidValue? ? roomId : this.roomId,
      actorRef: actorRef ?? this.actorRef,
      lastSeenAt: lastSeenAt ?? this.lastSeenAt,
    );
  }
}

class DeskPresenceUpdateTable extends _is.UpdateTable<DeskPresenceTable> {
  DeskPresenceUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> clinicId(_is.UuidValue value) =>
      _is.ColumnValue(
        table.clinicId,
        value,
      );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> deviceId(_is.UuidValue value) =>
      _is.ColumnValue(
        table.deviceId,
        value,
      );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> roomId(_is.UuidValue? value) =>
      _is.ColumnValue(
        table.roomId,
        value,
      );

  _is.ColumnValue<String, String> actorRef(String value) => _is.ColumnValue(
    table.actorRef,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> lastSeenAt(DateTime value) =>
      _is.ColumnValue(
        table.lastSeenAt,
        value,
      );
}

class DeskPresenceTable extends _is.Table<_is.UuidValue?> {
  DeskPresenceTable({super.tableRelation}) : super(tableName: 'desk_presence') {
    updateTable = DeskPresenceUpdateTable(this);
    clinicId = _is.ColumnUuid(
      'clinicId',
      this,
    );
    deviceId = _is.ColumnUuid(
      'deviceId',
      this,
    );
    roomId = _is.ColumnUuid(
      'roomId',
      this,
    );
    actorRef = _is.ColumnString(
      'actorRef',
      this,
    );
    lastSeenAt = _is.ColumnDateTime(
      'lastSeenAt',
      this,
    );
  }

  late final DeskPresenceUpdateTable updateTable;

  late final _is.ColumnUuid clinicId;

  late final _is.ColumnUuid deviceId;

  late final _is.ColumnUuid roomId;

  late final _is.ColumnString actorRef;

  late final _is.ColumnDateTime lastSeenAt;

  @override
  List<_is.Column> get columns => [
    id,
    clinicId,
    deviceId,
    roomId,
    actorRef,
    lastSeenAt,
  ];
}

class DeskPresenceInclude extends _is.IncludeObject {
  DeskPresenceInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => DeskPresence.t;
}

class DeskPresenceIncludeList extends _is.IncludeList {
  DeskPresenceIncludeList._({
    _is.WhereExpressionBuilder<DeskPresenceTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(DeskPresence.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => DeskPresence.t;
}

class DeskPresenceRepository {
  const DeskPresenceRepository._();

  /// Returns a list of [DeskPresence]s matching the given query parameters.
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
  Future<List<DeskPresence>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DeskPresenceTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DeskPresenceTable>? orderBy,
    _is.OrderByListBuilder<DeskPresenceTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<DeskPresence>(
      where: where?.call(DeskPresence.t),
      orderBy: orderBy?.call(DeskPresence.t),
      orderByList: orderByList?.call(DeskPresence.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [DeskPresence] matching the given query parameters.
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
  Future<DeskPresence?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DeskPresenceTable>? where,
    int? offset,
    _is.OrderByBuilder<DeskPresenceTable>? orderBy,
    _is.OrderByListBuilder<DeskPresenceTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<DeskPresence>(
      where: where?.call(DeskPresence.t),
      orderBy: orderBy?.call(DeskPresence.t),
      orderByList: orderByList?.call(DeskPresence.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [DeskPresence] by its [id] or null if no such row exists.
  Future<DeskPresence?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<DeskPresence>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [DeskPresence]s in the list and returns the inserted rows.
  ///
  /// The returned [DeskPresence]s will have their `id` fields set.
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
  Future<List<DeskPresence>> insert(
    _is.DatabaseSession session,
    List<DeskPresence> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<DeskPresence>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [DeskPresence] and returns the inserted row.
  ///
  /// The returned [DeskPresence] will have its `id` field set.
  Future<DeskPresence> insertRow(
    _is.DatabaseSession session,
    DeskPresence row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<DeskPresence>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [DeskPresence]s in the list and returns the resulting rows.
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
  /// The returned [DeskPresence]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DeskPresence>> upsert(
    _is.DatabaseSession session,
    List<DeskPresence> rows, {
    required _is.ColumnSelections<DeskPresenceTable> conflictColumns,
    _is.ColumnSelections<DeskPresenceTable>? updateColumns,
    _is.WhereExpressionBuilder<DeskPresenceTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<DeskPresence>(
      rows,
      conflictColumns: conflictColumns(DeskPresence.t),
      updateColumns: updateColumns?.call(DeskPresence.t),
      updateWhere: updateWhere?.call(DeskPresence.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [DeskPresence] and returns the resulting row.
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
  /// The returned [DeskPresence] will have its `id` field set.
  Future<DeskPresence?> upsertRow(
    _is.DatabaseSession session,
    DeskPresence row, {
    required _is.ColumnSelections<DeskPresenceTable> conflictColumns,
    _is.ColumnSelections<DeskPresenceTable>? updateColumns,
    _is.WhereExpressionBuilder<DeskPresenceTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<DeskPresence>(
      row,
      conflictColumns: conflictColumns(DeskPresence.t),
      updateColumns: updateColumns?.call(DeskPresence.t),
      updateWhere: updateWhere?.call(DeskPresence.t),
      transaction: transaction,
    );
  }

  /// Updates all [DeskPresence]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DeskPresence>> update(
    _is.DatabaseSession session,
    List<DeskPresence> rows, {
    _is.ColumnSelections<DeskPresenceTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<DeskPresence>(
      rows,
      columns: columns?.call(DeskPresence.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [DeskPresence]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<DeskPresence> updateRow(
    _is.DatabaseSession session,
    DeskPresence row, {
    _is.ColumnSelections<DeskPresenceTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<DeskPresence>(
      row,
      columns: columns?.call(DeskPresence.t),
      transaction: transaction,
    );
  }

  /// Updates a single [DeskPresence] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<DeskPresence?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<DeskPresenceUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<DeskPresence>(
      id,
      columnValues: columnValues(DeskPresence.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [DeskPresence]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DeskPresence>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<DeskPresenceUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<DeskPresenceTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DeskPresenceTable>? orderBy,
    _is.OrderByListBuilder<DeskPresenceTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<DeskPresence>(
      columnValues: columnValues(DeskPresence.t.updateTable),
      where: where(DeskPresence.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DeskPresence.t),
      orderByList: orderByList?.call(DeskPresence.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [DeskPresence]s in the list and returns the deleted rows.
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
  Future<List<DeskPresence>> delete(
    _is.DatabaseSession session,
    List<DeskPresence> rows, {
    _is.OrderByBuilder<DeskPresenceTable>? orderBy,
    _is.OrderByListBuilder<DeskPresenceTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<DeskPresence>(
      rows,
      orderBy: orderBy?.call(DeskPresence.t),
      orderByList: orderByList?.call(DeskPresence.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [DeskPresence].
  Future<DeskPresence> deleteRow(
    _is.DatabaseSession session,
    DeskPresence row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<DeskPresence>(
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
  Future<List<DeskPresence>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<DeskPresenceTable> where,
    _is.OrderByBuilder<DeskPresenceTable>? orderBy,
    _is.OrderByListBuilder<DeskPresenceTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<DeskPresence>(
      where: where(DeskPresence.t),
      orderBy: orderBy?.call(DeskPresence.t),
      orderByList: orderByList?.call(DeskPresence.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DeskPresenceTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<DeskPresence>(
      where: where?.call(DeskPresence.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [DeskPresence] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<DeskPresenceTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<DeskPresence>(
      where: where(DeskPresence.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
