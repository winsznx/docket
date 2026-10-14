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
import '../enums/staff_role.dart' as _igwmwxyi;

abstract class StaffMember
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  StaffMember._({
    this.id,
    required this.clinicId,
    required this.userIdentifier,
    required this.displayName,
    required this.role,
    bool? active,
    DateTime? createdAt,
  }) : active = active ?? true,
       createdAt = createdAt ?? DateTime.now();

  factory StaffMember({
    _is.UuidValue? id,
    required _is.UuidValue clinicId,
    required String userIdentifier,
    required String displayName,
    required _igwmwxyi.StaffRole role,
    bool? active,
    DateTime? createdAt,
  }) = _StaffMemberImpl;

  factory StaffMember.fromJson(Map<String, dynamic> jsonSerialization) {
    return StaffMember(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      clinicId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['clinicId'],
      ),
      userIdentifier: jsonSerialization['userIdentifier'] as String,
      displayName: jsonSerialization['displayName'] as String,
      role: _igwmwxyi.StaffRole.fromJson((jsonSerialization['role'] as String)),
      active: jsonSerialization['active'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['active']),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = StaffMemberTable();

  static const db = StaffMemberRepository._();

  @override
  _is.UuidValue? id;

  _is.UuidValue clinicId;

  String userIdentifier;

  String displayName;

  _igwmwxyi.StaffRole role;

  bool active;

  DateTime createdAt;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [StaffMember]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  StaffMember copyWith({
    _is.UuidValue? id,
    _is.UuidValue? clinicId,
    String? userIdentifier,
    String? displayName,
    _igwmwxyi.StaffRole? role,
    bool? active,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'StaffMember',
      if (id != null) 'id': id?.toJson(),
      'clinicId': clinicId.toJson(),
      'userIdentifier': userIdentifier,
      'displayName': displayName,
      'role': role.toJson(),
      'active': active,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'StaffMember',
      if (id != null) 'id': id?.toJson(),
      'clinicId': clinicId.toJson(),
      'userIdentifier': userIdentifier,
      'displayName': displayName,
      'role': role.toJson(),
      'active': active,
      'createdAt': createdAt.toJson(),
    };
  }

  static StaffMemberInclude include() {
    return StaffMemberInclude._();
  }

  static StaffMemberIncludeList includeList({
    _is.WhereExpressionBuilder<StaffMemberTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<StaffMemberTable>? orderBy,
    _is.OrderByListBuilder<StaffMemberTable>? orderByList,
    StaffMemberInclude? include,
  }) {
    return StaffMemberIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(StaffMember.t),
      orderByList: orderByList?.call(StaffMember.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _StaffMemberImpl extends StaffMember {
  _StaffMemberImpl({
    _is.UuidValue? id,
    required _is.UuidValue clinicId,
    required String userIdentifier,
    required String displayName,
    required _igwmwxyi.StaffRole role,
    bool? active,
    DateTime? createdAt,
  }) : super._(
         id: id,
         clinicId: clinicId,
         userIdentifier: userIdentifier,
         displayName: displayName,
         role: role,
         active: active,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [StaffMember]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  StaffMember copyWith({
    Object? id = _Undefined,
    _is.UuidValue? clinicId,
    String? userIdentifier,
    String? displayName,
    _igwmwxyi.StaffRole? role,
    bool? active,
    DateTime? createdAt,
  }) {
    return StaffMember(
      id: id is _is.UuidValue? ? id : this.id,
      clinicId: clinicId ?? this.clinicId,
      userIdentifier: userIdentifier ?? this.userIdentifier,
      displayName: displayName ?? this.displayName,
      role: role ?? this.role,
      active: active ?? this.active,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class StaffMemberUpdateTable extends _is.UpdateTable<StaffMemberTable> {
  StaffMemberUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> clinicId(_is.UuidValue value) =>
      _is.ColumnValue(
        table.clinicId,
        value,
      );

  _is.ColumnValue<String, String> userIdentifier(String value) =>
      _is.ColumnValue(
        table.userIdentifier,
        value,
      );

  _is.ColumnValue<String, String> displayName(String value) => _is.ColumnValue(
    table.displayName,
    value,
  );

  _is.ColumnValue<_igwmwxyi.StaffRole, _igwmwxyi.StaffRole> role(
    _igwmwxyi.StaffRole value,
  ) => _is.ColumnValue(
    table.role,
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

class StaffMemberTable extends _is.Table<_is.UuidValue?> {
  StaffMemberTable({super.tableRelation}) : super(tableName: 'staff_member') {
    updateTable = StaffMemberUpdateTable(this);
    clinicId = _is.ColumnUuid(
      'clinicId',
      this,
    );
    userIdentifier = _is.ColumnString(
      'userIdentifier',
      this,
    );
    displayName = _is.ColumnString(
      'displayName',
      this,
    );
    role = _is.ColumnEnum(
      'role',
      this,
      _is.EnumSerialization.byName,
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

  late final StaffMemberUpdateTable updateTable;

  late final _is.ColumnUuid clinicId;

  late final _is.ColumnString userIdentifier;

  late final _is.ColumnString displayName;

  late final _is.ColumnEnum<_igwmwxyi.StaffRole> role;

  late final _is.ColumnBool active;

  late final _is.ColumnDateTime createdAt;

  @override
  List<_is.Column> get columns => [
    id,
    clinicId,
    userIdentifier,
    displayName,
    role,
    active,
    createdAt,
  ];
}

class StaffMemberInclude extends _is.IncludeObject {
  StaffMemberInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => StaffMember.t;
}

class StaffMemberIncludeList extends _is.IncludeList {
  StaffMemberIncludeList._({
    _is.WhereExpressionBuilder<StaffMemberTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(StaffMember.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => StaffMember.t;
}

class StaffMemberRepository {
  const StaffMemberRepository._();

  /// Returns a list of [StaffMember]s matching the given query parameters.
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
  Future<List<StaffMember>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<StaffMemberTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<StaffMemberTable>? orderBy,
    _is.OrderByListBuilder<StaffMemberTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<StaffMember>(
      where: where?.call(StaffMember.t),
      orderBy: orderBy?.call(StaffMember.t),
      orderByList: orderByList?.call(StaffMember.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [StaffMember] matching the given query parameters.
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
  Future<StaffMember?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<StaffMemberTable>? where,
    int? offset,
    _is.OrderByBuilder<StaffMemberTable>? orderBy,
    _is.OrderByListBuilder<StaffMemberTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<StaffMember>(
      where: where?.call(StaffMember.t),
      orderBy: orderBy?.call(StaffMember.t),
      orderByList: orderByList?.call(StaffMember.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [StaffMember] by its [id] or null if no such row exists.
  Future<StaffMember?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<StaffMember>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [StaffMember]s in the list and returns the inserted rows.
  ///
  /// The returned [StaffMember]s will have their `id` fields set.
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
  Future<List<StaffMember>> insert(
    _is.DatabaseSession session,
    List<StaffMember> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<StaffMember>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [StaffMember] and returns the inserted row.
  ///
  /// The returned [StaffMember] will have its `id` field set.
  Future<StaffMember> insertRow(
    _is.DatabaseSession session,
    StaffMember row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<StaffMember>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [StaffMember]s in the list and returns the resulting rows.
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
  /// The returned [StaffMember]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<StaffMember>> upsert(
    _is.DatabaseSession session,
    List<StaffMember> rows, {
    required _is.ColumnSelections<StaffMemberTable> conflictColumns,
    _is.ColumnSelections<StaffMemberTable>? updateColumns,
    _is.WhereExpressionBuilder<StaffMemberTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<StaffMember>(
      rows,
      conflictColumns: conflictColumns(StaffMember.t),
      updateColumns: updateColumns?.call(StaffMember.t),
      updateWhere: updateWhere?.call(StaffMember.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [StaffMember] and returns the resulting row.
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
  /// The returned [StaffMember] will have its `id` field set.
  Future<StaffMember?> upsertRow(
    _is.DatabaseSession session,
    StaffMember row, {
    required _is.ColumnSelections<StaffMemberTable> conflictColumns,
    _is.ColumnSelections<StaffMemberTable>? updateColumns,
    _is.WhereExpressionBuilder<StaffMemberTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<StaffMember>(
      row,
      conflictColumns: conflictColumns(StaffMember.t),
      updateColumns: updateColumns?.call(StaffMember.t),
      updateWhere: updateWhere?.call(StaffMember.t),
      transaction: transaction,
    );
  }

  /// Updates all [StaffMember]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<StaffMember>> update(
    _is.DatabaseSession session,
    List<StaffMember> rows, {
    _is.ColumnSelections<StaffMemberTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<StaffMember>(
      rows,
      columns: columns?.call(StaffMember.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [StaffMember]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<StaffMember> updateRow(
    _is.DatabaseSession session,
    StaffMember row, {
    _is.ColumnSelections<StaffMemberTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<StaffMember>(
      row,
      columns: columns?.call(StaffMember.t),
      transaction: transaction,
    );
  }

  /// Updates a single [StaffMember] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<StaffMember?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<StaffMemberUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<StaffMember>(
      id,
      columnValues: columnValues(StaffMember.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [StaffMember]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<StaffMember>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<StaffMemberUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<StaffMemberTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<StaffMemberTable>? orderBy,
    _is.OrderByListBuilder<StaffMemberTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<StaffMember>(
      columnValues: columnValues(StaffMember.t.updateTable),
      where: where(StaffMember.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(StaffMember.t),
      orderByList: orderByList?.call(StaffMember.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [StaffMember]s in the list and returns the deleted rows.
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
  Future<List<StaffMember>> delete(
    _is.DatabaseSession session,
    List<StaffMember> rows, {
    _is.OrderByBuilder<StaffMemberTable>? orderBy,
    _is.OrderByListBuilder<StaffMemberTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<StaffMember>(
      rows,
      orderBy: orderBy?.call(StaffMember.t),
      orderByList: orderByList?.call(StaffMember.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [StaffMember].
  Future<StaffMember> deleteRow(
    _is.DatabaseSession session,
    StaffMember row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<StaffMember>(
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
  Future<List<StaffMember>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<StaffMemberTable> where,
    _is.OrderByBuilder<StaffMemberTable>? orderBy,
    _is.OrderByListBuilder<StaffMemberTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<StaffMember>(
      where: where(StaffMember.t),
      orderBy: orderBy?.call(StaffMember.t),
      orderByList: orderByList?.call(StaffMember.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<StaffMemberTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<StaffMember>(
      where: where?.call(StaffMember.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [StaffMember] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<StaffMemberTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<StaffMember>(
      where: where(StaffMember.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
