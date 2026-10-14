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
import '../enums/room_state.dart' as _is416j1i;

abstract class Room
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  Room._({
    this.id,
    required this.clinicId,
    required this.lineId,
    required this.name,
    _is416j1i.RoomState? state,
    int? sortOrder,
  }) : state = state ?? _is416j1i.RoomState.open,
       sortOrder = sortOrder ?? 0;

  factory Room({
    _is.UuidValue? id,
    required _is.UuidValue clinicId,
    required _is.UuidValue lineId,
    required String name,
    _is416j1i.RoomState? state,
    int? sortOrder,
  }) = _RoomImpl;

  factory Room.fromJson(Map<String, dynamic> jsonSerialization) {
    return Room(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      clinicId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['clinicId'],
      ),
      lineId: _is.UuidValueJsonExtension.fromJson(jsonSerialization['lineId']),
      name: jsonSerialization['name'] as String,
      state: jsonSerialization['state'] == null
          ? null
          : _is416j1i.RoomState.fromJson(
              (jsonSerialization['state'] as String),
            ),
      sortOrder: jsonSerialization['sortOrder'] as int?,
    );
  }

  static final t = RoomTable();

  static const db = RoomRepository._();

  @override
  _is.UuidValue? id;

  _is.UuidValue clinicId;

  _is.UuidValue lineId;

  String name;

  _is416j1i.RoomState state;

  int sortOrder;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [Room]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  Room copyWith({
    _is.UuidValue? id,
    _is.UuidValue? clinicId,
    _is.UuidValue? lineId,
    String? name,
    _is416j1i.RoomState? state,
    int? sortOrder,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Room',
      if (id != null) 'id': id?.toJson(),
      'clinicId': clinicId.toJson(),
      'lineId': lineId.toJson(),
      'name': name,
      'state': state.toJson(),
      'sortOrder': sortOrder,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Room',
      if (id != null) 'id': id?.toJson(),
      'clinicId': clinicId.toJson(),
      'lineId': lineId.toJson(),
      'name': name,
      'state': state.toJson(),
      'sortOrder': sortOrder,
    };
  }

  static RoomInclude include() {
    return RoomInclude._();
  }

  static RoomIncludeList includeList({
    _is.WhereExpressionBuilder<RoomTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<RoomTable>? orderBy,
    _is.OrderByListBuilder<RoomTable>? orderByList,
    RoomInclude? include,
  }) {
    return RoomIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Room.t),
      orderByList: orderByList?.call(Room.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RoomImpl extends Room {
  _RoomImpl({
    _is.UuidValue? id,
    required _is.UuidValue clinicId,
    required _is.UuidValue lineId,
    required String name,
    _is416j1i.RoomState? state,
    int? sortOrder,
  }) : super._(
         id: id,
         clinicId: clinicId,
         lineId: lineId,
         name: name,
         state: state,
         sortOrder: sortOrder,
       );

  /// Returns a shallow copy of this [Room]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  Room copyWith({
    Object? id = _Undefined,
    _is.UuidValue? clinicId,
    _is.UuidValue? lineId,
    String? name,
    _is416j1i.RoomState? state,
    int? sortOrder,
  }) {
    return Room(
      id: id is _is.UuidValue? ? id : this.id,
      clinicId: clinicId ?? this.clinicId,
      lineId: lineId ?? this.lineId,
      name: name ?? this.name,
      state: state ?? this.state,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }
}

class RoomUpdateTable extends _is.UpdateTable<RoomTable> {
  RoomUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> clinicId(_is.UuidValue value) =>
      _is.ColumnValue(
        table.clinicId,
        value,
      );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> lineId(_is.UuidValue value) =>
      _is.ColumnValue(
        table.lineId,
        value,
      );

  _is.ColumnValue<String, String> name(String value) => _is.ColumnValue(
    table.name,
    value,
  );

  _is.ColumnValue<_is416j1i.RoomState, _is416j1i.RoomState> state(
    _is416j1i.RoomState value,
  ) => _is.ColumnValue(
    table.state,
    value,
  );

  _is.ColumnValue<int, int> sortOrder(int value) => _is.ColumnValue(
    table.sortOrder,
    value,
  );
}

class RoomTable extends _is.Table<_is.UuidValue?> {
  RoomTable({super.tableRelation}) : super(tableName: 'room') {
    updateTable = RoomUpdateTable(this);
    clinicId = _is.ColumnUuid(
      'clinicId',
      this,
    );
    lineId = _is.ColumnUuid(
      'lineId',
      this,
    );
    name = _is.ColumnString(
      'name',
      this,
    );
    state = _is.ColumnEnum(
      'state',
      this,
      _is.EnumSerialization.byName,
      hasDefault: true,
    );
    sortOrder = _is.ColumnInt(
      'sortOrder',
      this,
      hasDefault: true,
    );
  }

  late final RoomUpdateTable updateTable;

  late final _is.ColumnUuid clinicId;

  late final _is.ColumnUuid lineId;

  late final _is.ColumnString name;

  late final _is.ColumnEnum<_is416j1i.RoomState> state;

  late final _is.ColumnInt sortOrder;

  @override
  List<_is.Column> get columns => [
    id,
    clinicId,
    lineId,
    name,
    state,
    sortOrder,
  ];
}

class RoomInclude extends _is.IncludeObject {
  RoomInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => Room.t;
}

class RoomIncludeList extends _is.IncludeList {
  RoomIncludeList._({
    _is.WhereExpressionBuilder<RoomTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Room.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => Room.t;
}

class RoomRepository {
  const RoomRepository._();

  /// Returns a list of [Room]s matching the given query parameters.
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
  Future<List<Room>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<RoomTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<RoomTable>? orderBy,
    _is.OrderByListBuilder<RoomTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Room>(
      where: where?.call(Room.t),
      orderBy: orderBy?.call(Room.t),
      orderByList: orderByList?.call(Room.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Room] matching the given query parameters.
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
  Future<Room?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<RoomTable>? where,
    int? offset,
    _is.OrderByBuilder<RoomTable>? orderBy,
    _is.OrderByListBuilder<RoomTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Room>(
      where: where?.call(Room.t),
      orderBy: orderBy?.call(Room.t),
      orderByList: orderByList?.call(Room.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Room] by its [id] or null if no such row exists.
  Future<Room?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Room>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Room]s in the list and returns the inserted rows.
  ///
  /// The returned [Room]s will have their `id` fields set.
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
  Future<List<Room>> insert(
    _is.DatabaseSession session,
    List<Room> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<Room>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [Room] and returns the inserted row.
  ///
  /// The returned [Room] will have its `id` field set.
  Future<Room> insertRow(
    _is.DatabaseSession session,
    Room row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<Room>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [Room]s in the list and returns the resulting rows.
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
  /// The returned [Room]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Room>> upsert(
    _is.DatabaseSession session,
    List<Room> rows, {
    required _is.ColumnSelections<RoomTable> conflictColumns,
    _is.ColumnSelections<RoomTable>? updateColumns,
    _is.WhereExpressionBuilder<RoomTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<Room>(
      rows,
      conflictColumns: conflictColumns(Room.t),
      updateColumns: updateColumns?.call(Room.t),
      updateWhere: updateWhere?.call(Room.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [Room] and returns the resulting row.
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
  /// The returned [Room] will have its `id` field set.
  Future<Room?> upsertRow(
    _is.DatabaseSession session,
    Room row, {
    required _is.ColumnSelections<RoomTable> conflictColumns,
    _is.ColumnSelections<RoomTable>? updateColumns,
    _is.WhereExpressionBuilder<RoomTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<Room>(
      row,
      conflictColumns: conflictColumns(Room.t),
      updateColumns: updateColumns?.call(Room.t),
      updateWhere: updateWhere?.call(Room.t),
      transaction: transaction,
    );
  }

  /// Updates all [Room]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Room>> update(
    _is.DatabaseSession session,
    List<Room> rows, {
    _is.ColumnSelections<RoomTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<Room>(
      rows,
      columns: columns?.call(Room.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [Room]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Room> updateRow(
    _is.DatabaseSession session,
    Room row, {
    _is.ColumnSelections<RoomTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<Room>(
      row,
      columns: columns?.call(Room.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Room] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Room?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<RoomUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<Room>(
      id,
      columnValues: columnValues(Room.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Room]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Room>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<RoomUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<RoomTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<RoomTable>? orderBy,
    _is.OrderByListBuilder<RoomTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<Room>(
      columnValues: columnValues(Room.t.updateTable),
      where: where(Room.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Room.t),
      orderByList: orderByList?.call(Room.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [Room]s in the list and returns the deleted rows.
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
  Future<List<Room>> delete(
    _is.DatabaseSession session,
    List<Room> rows, {
    _is.OrderByBuilder<RoomTable>? orderBy,
    _is.OrderByListBuilder<RoomTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<Room>(
      rows,
      orderBy: orderBy?.call(Room.t),
      orderByList: orderByList?.call(Room.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [Room].
  Future<Room> deleteRow(
    _is.DatabaseSession session,
    Room row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Room>(
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
  Future<List<Room>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<RoomTable> where,
    _is.OrderByBuilder<RoomTable>? orderBy,
    _is.OrderByListBuilder<RoomTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<Room>(
      where: where(Room.t),
      orderBy: orderBy?.call(Room.t),
      orderByList: orderByList?.call(Room.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<RoomTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<Room>(
      where: where?.call(Room.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Room] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<RoomTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Room>(
      where: where(Room.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
