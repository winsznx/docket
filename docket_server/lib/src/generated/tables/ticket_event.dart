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
import '../enums/actor_type.dart' as _iau4lzx2;
import '../enums/ticket_event_type.dart' as _iartk5zh;
import '../enums/ticket_state.dart' as _imwmdlft;

abstract class TicketEvent
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  TicketEvent._({
    this.id,
    required this.clinicId,
    required this.lineId,
    required this.ticketId,
    required this.ticketLabel,
    required this.type,
    this.fromState,
    this.toState,
    required this.actor,
    this.actorRef,
    this.deviceId,
    this.actionId,
    this.roomId,
    this.reason,
    required this.lineVersion,
    required this.at,
  });

  factory TicketEvent({
    _is.UuidValue? id,
    required _is.UuidValue clinicId,
    required _is.UuidValue lineId,
    required _is.UuidValue ticketId,
    required String ticketLabel,
    required _iartk5zh.TicketEventType type,
    _imwmdlft.TicketState? fromState,
    _imwmdlft.TicketState? toState,
    required _iau4lzx2.ActorType actor,
    String? actorRef,
    _is.UuidValue? deviceId,
    _is.UuidValue? actionId,
    _is.UuidValue? roomId,
    String? reason,
    required int lineVersion,
    required DateTime at,
  }) = _TicketEventImpl;

  factory TicketEvent.fromJson(Map<String, dynamic> jsonSerialization) {
    return TicketEvent(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      clinicId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['clinicId'],
      ),
      lineId: _is.UuidValueJsonExtension.fromJson(jsonSerialization['lineId']),
      ticketId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['ticketId'],
      ),
      ticketLabel: jsonSerialization['ticketLabel'] as String,
      type: _iartk5zh.TicketEventType.fromJson(
        (jsonSerialization['type'] as String),
      ),
      fromState: jsonSerialization['fromState'] == null
          ? null
          : _imwmdlft.TicketState.fromJson(
              (jsonSerialization['fromState'] as String),
            ),
      toState: jsonSerialization['toState'] == null
          ? null
          : _imwmdlft.TicketState.fromJson(
              (jsonSerialization['toState'] as String),
            ),
      actor: _iau4lzx2.ActorType.fromJson(
        (jsonSerialization['actor'] as String),
      ),
      actorRef: jsonSerialization['actorRef'] as String?,
      deviceId: jsonSerialization['deviceId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['deviceId']),
      actionId: jsonSerialization['actionId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['actionId']),
      roomId: jsonSerialization['roomId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['roomId']),
      reason: jsonSerialization['reason'] as String?,
      lineVersion: jsonSerialization['lineVersion'] as int,
      at: _is.DateTimeJsonExtension.fromJson(jsonSerialization['at']),
    );
  }

  static final t = TicketEventTable();

  static const db = TicketEventRepository._();

  @override
  _is.UuidValue? id;

  _is.UuidValue clinicId;

  _is.UuidValue lineId;

  _is.UuidValue ticketId;

  String ticketLabel;

  _iartk5zh.TicketEventType type;

  _imwmdlft.TicketState? fromState;

  _imwmdlft.TicketState? toState;

  _iau4lzx2.ActorType actor;

  String? actorRef;

  _is.UuidValue? deviceId;

  _is.UuidValue? actionId;

  _is.UuidValue? roomId;

  String? reason;

  int lineVersion;

  DateTime at;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [TicketEvent]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  TicketEvent copyWith({
    _is.UuidValue? id,
    _is.UuidValue? clinicId,
    _is.UuidValue? lineId,
    _is.UuidValue? ticketId,
    String? ticketLabel,
    _iartk5zh.TicketEventType? type,
    _imwmdlft.TicketState? fromState,
    _imwmdlft.TicketState? toState,
    _iau4lzx2.ActorType? actor,
    String? actorRef,
    _is.UuidValue? deviceId,
    _is.UuidValue? actionId,
    _is.UuidValue? roomId,
    String? reason,
    int? lineVersion,
    DateTime? at,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TicketEvent',
      if (id != null) 'id': id?.toJson(),
      'clinicId': clinicId.toJson(),
      'lineId': lineId.toJson(),
      'ticketId': ticketId.toJson(),
      'ticketLabel': ticketLabel,
      'type': type.toJson(),
      if (fromState != null) 'fromState': fromState?.toJson(),
      if (toState != null) 'toState': toState?.toJson(),
      'actor': actor.toJson(),
      if (actorRef != null) 'actorRef': actorRef,
      if (deviceId != null) 'deviceId': deviceId?.toJson(),
      if (actionId != null) 'actionId': actionId?.toJson(),
      if (roomId != null) 'roomId': roomId?.toJson(),
      if (reason != null) 'reason': reason,
      'lineVersion': lineVersion,
      'at': at.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'TicketEvent',
      if (id != null) 'id': id?.toJson(),
      'clinicId': clinicId.toJson(),
      'lineId': lineId.toJson(),
      'ticketId': ticketId.toJson(),
      'ticketLabel': ticketLabel,
      'type': type.toJson(),
      if (fromState != null) 'fromState': fromState?.toJson(),
      if (toState != null) 'toState': toState?.toJson(),
      'actor': actor.toJson(),
      if (actorRef != null) 'actorRef': actorRef,
      if (deviceId != null) 'deviceId': deviceId?.toJson(),
      if (actionId != null) 'actionId': actionId?.toJson(),
      if (roomId != null) 'roomId': roomId?.toJson(),
      if (reason != null) 'reason': reason,
      'lineVersion': lineVersion,
      'at': at.toJson(),
    };
  }

  static TicketEventInclude include() {
    return TicketEventInclude._();
  }

  static TicketEventIncludeList includeList({
    _is.WhereExpressionBuilder<TicketEventTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<TicketEventTable>? orderBy,
    _is.OrderByListBuilder<TicketEventTable>? orderByList,
    TicketEventInclude? include,
  }) {
    return TicketEventIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(TicketEvent.t),
      orderByList: orderByList?.call(TicketEvent.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TicketEventImpl extends TicketEvent {
  _TicketEventImpl({
    _is.UuidValue? id,
    required _is.UuidValue clinicId,
    required _is.UuidValue lineId,
    required _is.UuidValue ticketId,
    required String ticketLabel,
    required _iartk5zh.TicketEventType type,
    _imwmdlft.TicketState? fromState,
    _imwmdlft.TicketState? toState,
    required _iau4lzx2.ActorType actor,
    String? actorRef,
    _is.UuidValue? deviceId,
    _is.UuidValue? actionId,
    _is.UuidValue? roomId,
    String? reason,
    required int lineVersion,
    required DateTime at,
  }) : super._(
         id: id,
         clinicId: clinicId,
         lineId: lineId,
         ticketId: ticketId,
         ticketLabel: ticketLabel,
         type: type,
         fromState: fromState,
         toState: toState,
         actor: actor,
         actorRef: actorRef,
         deviceId: deviceId,
         actionId: actionId,
         roomId: roomId,
         reason: reason,
         lineVersion: lineVersion,
         at: at,
       );

  /// Returns a shallow copy of this [TicketEvent]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  TicketEvent copyWith({
    Object? id = _Undefined,
    _is.UuidValue? clinicId,
    _is.UuidValue? lineId,
    _is.UuidValue? ticketId,
    String? ticketLabel,
    _iartk5zh.TicketEventType? type,
    Object? fromState = _Undefined,
    Object? toState = _Undefined,
    _iau4lzx2.ActorType? actor,
    Object? actorRef = _Undefined,
    Object? deviceId = _Undefined,
    Object? actionId = _Undefined,
    Object? roomId = _Undefined,
    Object? reason = _Undefined,
    int? lineVersion,
    DateTime? at,
  }) {
    return TicketEvent(
      id: id is _is.UuidValue? ? id : this.id,
      clinicId: clinicId ?? this.clinicId,
      lineId: lineId ?? this.lineId,
      ticketId: ticketId ?? this.ticketId,
      ticketLabel: ticketLabel ?? this.ticketLabel,
      type: type ?? this.type,
      fromState: fromState is _imwmdlft.TicketState?
          ? fromState
          : this.fromState,
      toState: toState is _imwmdlft.TicketState? ? toState : this.toState,
      actor: actor ?? this.actor,
      actorRef: actorRef is String? ? actorRef : this.actorRef,
      deviceId: deviceId is _is.UuidValue? ? deviceId : this.deviceId,
      actionId: actionId is _is.UuidValue? ? actionId : this.actionId,
      roomId: roomId is _is.UuidValue? ? roomId : this.roomId,
      reason: reason is String? ? reason : this.reason,
      lineVersion: lineVersion ?? this.lineVersion,
      at: at ?? this.at,
    );
  }
}

class TicketEventUpdateTable extends _is.UpdateTable<TicketEventTable> {
  TicketEventUpdateTable(super.table);

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

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> ticketId(_is.UuidValue value) =>
      _is.ColumnValue(
        table.ticketId,
        value,
      );

  _is.ColumnValue<String, String> ticketLabel(String value) => _is.ColumnValue(
    table.ticketLabel,
    value,
  );

  _is.ColumnValue<_iartk5zh.TicketEventType, _iartk5zh.TicketEventType> type(
    _iartk5zh.TicketEventType value,
  ) => _is.ColumnValue(
    table.type,
    value,
  );

  _is.ColumnValue<_imwmdlft.TicketState, _imwmdlft.TicketState> fromState(
    _imwmdlft.TicketState? value,
  ) => _is.ColumnValue(
    table.fromState,
    value,
  );

  _is.ColumnValue<_imwmdlft.TicketState, _imwmdlft.TicketState> toState(
    _imwmdlft.TicketState? value,
  ) => _is.ColumnValue(
    table.toState,
    value,
  );

  _is.ColumnValue<_iau4lzx2.ActorType, _iau4lzx2.ActorType> actor(
    _iau4lzx2.ActorType value,
  ) => _is.ColumnValue(
    table.actor,
    value,
  );

  _is.ColumnValue<String, String> actorRef(String? value) => _is.ColumnValue(
    table.actorRef,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> deviceId(
    _is.UuidValue? value,
  ) => _is.ColumnValue(
    table.deviceId,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> actionId(
    _is.UuidValue? value,
  ) => _is.ColumnValue(
    table.actionId,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> roomId(_is.UuidValue? value) =>
      _is.ColumnValue(
        table.roomId,
        value,
      );

  _is.ColumnValue<String, String> reason(String? value) => _is.ColumnValue(
    table.reason,
    value,
  );

  _is.ColumnValue<int, int> lineVersion(int value) => _is.ColumnValue(
    table.lineVersion,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> at(DateTime value) => _is.ColumnValue(
    table.at,
    value,
  );
}

class TicketEventTable extends _is.Table<_is.UuidValue?> {
  TicketEventTable({super.tableRelation}) : super(tableName: 'ticket_event') {
    updateTable = TicketEventUpdateTable(this);
    clinicId = _is.ColumnUuid(
      'clinicId',
      this,
    );
    lineId = _is.ColumnUuid(
      'lineId',
      this,
    );
    ticketId = _is.ColumnUuid(
      'ticketId',
      this,
    );
    ticketLabel = _is.ColumnString(
      'ticketLabel',
      this,
    );
    type = _is.ColumnEnum(
      'type',
      this,
      _is.EnumSerialization.byName,
    );
    fromState = _is.ColumnEnum(
      'fromState',
      this,
      _is.EnumSerialization.byName,
    );
    toState = _is.ColumnEnum(
      'toState',
      this,
      _is.EnumSerialization.byName,
    );
    actor = _is.ColumnEnum(
      'actor',
      this,
      _is.EnumSerialization.byName,
    );
    actorRef = _is.ColumnString(
      'actorRef',
      this,
    );
    deviceId = _is.ColumnUuid(
      'deviceId',
      this,
    );
    actionId = _is.ColumnUuid(
      'actionId',
      this,
    );
    roomId = _is.ColumnUuid(
      'roomId',
      this,
    );
    reason = _is.ColumnString(
      'reason',
      this,
    );
    lineVersion = _is.ColumnInt(
      'lineVersion',
      this,
    );
    at = _is.ColumnDateTime(
      'at',
      this,
    );
  }

  late final TicketEventUpdateTable updateTable;

  late final _is.ColumnUuid clinicId;

  late final _is.ColumnUuid lineId;

  late final _is.ColumnUuid ticketId;

  late final _is.ColumnString ticketLabel;

  late final _is.ColumnEnum<_iartk5zh.TicketEventType> type;

  late final _is.ColumnEnum<_imwmdlft.TicketState> fromState;

  late final _is.ColumnEnum<_imwmdlft.TicketState> toState;

  late final _is.ColumnEnum<_iau4lzx2.ActorType> actor;

  late final _is.ColumnString actorRef;

  late final _is.ColumnUuid deviceId;

  late final _is.ColumnUuid actionId;

  late final _is.ColumnUuid roomId;

  late final _is.ColumnString reason;

  late final _is.ColumnInt lineVersion;

  late final _is.ColumnDateTime at;

  @override
  List<_is.Column> get columns => [
    id,
    clinicId,
    lineId,
    ticketId,
    ticketLabel,
    type,
    fromState,
    toState,
    actor,
    actorRef,
    deviceId,
    actionId,
    roomId,
    reason,
    lineVersion,
    at,
  ];
}

class TicketEventInclude extends _is.IncludeObject {
  TicketEventInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => TicketEvent.t;
}

class TicketEventIncludeList extends _is.IncludeList {
  TicketEventIncludeList._({
    _is.WhereExpressionBuilder<TicketEventTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(TicketEvent.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => TicketEvent.t;
}

class TicketEventRepository {
  const TicketEventRepository._();

  /// Returns a list of [TicketEvent]s matching the given query parameters.
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
  Future<List<TicketEvent>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<TicketEventTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<TicketEventTable>? orderBy,
    _is.OrderByListBuilder<TicketEventTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<TicketEvent>(
      where: where?.call(TicketEvent.t),
      orderBy: orderBy?.call(TicketEvent.t),
      orderByList: orderByList?.call(TicketEvent.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [TicketEvent] matching the given query parameters.
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
  Future<TicketEvent?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<TicketEventTable>? where,
    int? offset,
    _is.OrderByBuilder<TicketEventTable>? orderBy,
    _is.OrderByListBuilder<TicketEventTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<TicketEvent>(
      where: where?.call(TicketEvent.t),
      orderBy: orderBy?.call(TicketEvent.t),
      orderByList: orderByList?.call(TicketEvent.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [TicketEvent] by its [id] or null if no such row exists.
  Future<TicketEvent?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<TicketEvent>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [TicketEvent]s in the list and returns the inserted rows.
  ///
  /// The returned [TicketEvent]s will have their `id` fields set.
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
  Future<List<TicketEvent>> insert(
    _is.DatabaseSession session,
    List<TicketEvent> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<TicketEvent>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [TicketEvent] and returns the inserted row.
  ///
  /// The returned [TicketEvent] will have its `id` field set.
  Future<TicketEvent> insertRow(
    _is.DatabaseSession session,
    TicketEvent row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<TicketEvent>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [TicketEvent]s in the list and returns the resulting rows.
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
  /// The returned [TicketEvent]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<TicketEvent>> upsert(
    _is.DatabaseSession session,
    List<TicketEvent> rows, {
    required _is.ColumnSelections<TicketEventTable> conflictColumns,
    _is.ColumnSelections<TicketEventTable>? updateColumns,
    _is.WhereExpressionBuilder<TicketEventTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<TicketEvent>(
      rows,
      conflictColumns: conflictColumns(TicketEvent.t),
      updateColumns: updateColumns?.call(TicketEvent.t),
      updateWhere: updateWhere?.call(TicketEvent.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [TicketEvent] and returns the resulting row.
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
  /// The returned [TicketEvent] will have its `id` field set.
  Future<TicketEvent?> upsertRow(
    _is.DatabaseSession session,
    TicketEvent row, {
    required _is.ColumnSelections<TicketEventTable> conflictColumns,
    _is.ColumnSelections<TicketEventTable>? updateColumns,
    _is.WhereExpressionBuilder<TicketEventTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<TicketEvent>(
      row,
      conflictColumns: conflictColumns(TicketEvent.t),
      updateColumns: updateColumns?.call(TicketEvent.t),
      updateWhere: updateWhere?.call(TicketEvent.t),
      transaction: transaction,
    );
  }

  /// Updates all [TicketEvent]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<TicketEvent>> update(
    _is.DatabaseSession session,
    List<TicketEvent> rows, {
    _is.ColumnSelections<TicketEventTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<TicketEvent>(
      rows,
      columns: columns?.call(TicketEvent.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [TicketEvent]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<TicketEvent> updateRow(
    _is.DatabaseSession session,
    TicketEvent row, {
    _is.ColumnSelections<TicketEventTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<TicketEvent>(
      row,
      columns: columns?.call(TicketEvent.t),
      transaction: transaction,
    );
  }

  /// Updates a single [TicketEvent] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<TicketEvent?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<TicketEventUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<TicketEvent>(
      id,
      columnValues: columnValues(TicketEvent.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [TicketEvent]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<TicketEvent>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<TicketEventUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<TicketEventTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<TicketEventTable>? orderBy,
    _is.OrderByListBuilder<TicketEventTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<TicketEvent>(
      columnValues: columnValues(TicketEvent.t.updateTable),
      where: where(TicketEvent.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(TicketEvent.t),
      orderByList: orderByList?.call(TicketEvent.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [TicketEvent]s in the list and returns the deleted rows.
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
  Future<List<TicketEvent>> delete(
    _is.DatabaseSession session,
    List<TicketEvent> rows, {
    _is.OrderByBuilder<TicketEventTable>? orderBy,
    _is.OrderByListBuilder<TicketEventTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<TicketEvent>(
      rows,
      orderBy: orderBy?.call(TicketEvent.t),
      orderByList: orderByList?.call(TicketEvent.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [TicketEvent].
  Future<TicketEvent> deleteRow(
    _is.DatabaseSession session,
    TicketEvent row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<TicketEvent>(
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
  Future<List<TicketEvent>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<TicketEventTable> where,
    _is.OrderByBuilder<TicketEventTable>? orderBy,
    _is.OrderByListBuilder<TicketEventTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<TicketEvent>(
      where: where(TicketEvent.t),
      orderBy: orderBy?.call(TicketEvent.t),
      orderByList: orderByList?.call(TicketEvent.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<TicketEventTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<TicketEvent>(
      where: where?.call(TicketEvent.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [TicketEvent] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<TicketEventTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<TicketEvent>(
      where: where(TicketEvent.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
