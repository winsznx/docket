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
import '../enums/channel.dart' as _i1ikwq8c;
import '../enums/delivery_status.dart' as _ik1evhid;
import '../enums/notification_kind.dart' as _ic51rir1;

abstract class Notification
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  Notification._({
    this.id,
    required this.ticketId,
    required this.clinicId,
    required this.ticketLabel,
    required this.kind,
    required this.channel,
    required this.status,
    required this.dedupeKey,
    int? callVersion,
    int? attempts,
    this.providerRef,
    this.error,
    DateTime? createdAt,
    this.sentAt,
  }) : callVersion = callVersion ?? 0,
       attempts = attempts ?? 0,
       createdAt = createdAt ?? DateTime.now();

  factory Notification({
    _is.UuidValue? id,
    required _is.UuidValue ticketId,
    required _is.UuidValue clinicId,
    required String ticketLabel,
    required _ic51rir1.NotificationKind kind,
    required _i1ikwq8c.Channel channel,
    required _ik1evhid.DeliveryStatus status,
    required String dedupeKey,
    int? callVersion,
    int? attempts,
    String? providerRef,
    String? error,
    DateTime? createdAt,
    DateTime? sentAt,
  }) = _NotificationImpl;

  factory Notification.fromJson(Map<String, dynamic> jsonSerialization) {
    return Notification(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      ticketId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['ticketId'],
      ),
      clinicId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['clinicId'],
      ),
      ticketLabel: jsonSerialization['ticketLabel'] as String,
      kind: _ic51rir1.NotificationKind.fromJson(
        (jsonSerialization['kind'] as String),
      ),
      channel: _i1ikwq8c.Channel.fromJson(
        (jsonSerialization['channel'] as String),
      ),
      status: _ik1evhid.DeliveryStatus.fromJson(
        (jsonSerialization['status'] as String),
      ),
      dedupeKey: jsonSerialization['dedupeKey'] as String,
      callVersion: jsonSerialization['callVersion'] as int?,
      attempts: jsonSerialization['attempts'] as int?,
      providerRef: jsonSerialization['providerRef'] as String?,
      error: jsonSerialization['error'] as String?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      sentAt: jsonSerialization['sentAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['sentAt']),
    );
  }

  static final t = NotificationTable();

  static const db = NotificationRepository._();

  @override
  _is.UuidValue? id;

  _is.UuidValue ticketId;

  _is.UuidValue clinicId;

  String ticketLabel;

  _ic51rir1.NotificationKind kind;

  _i1ikwq8c.Channel channel;

  _ik1evhid.DeliveryStatus status;

  String dedupeKey;

  int callVersion;

  int attempts;

  String? providerRef;

  String? error;

  DateTime createdAt;

  DateTime? sentAt;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [Notification]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  Notification copyWith({
    _is.UuidValue? id,
    _is.UuidValue? ticketId,
    _is.UuidValue? clinicId,
    String? ticketLabel,
    _ic51rir1.NotificationKind? kind,
    _i1ikwq8c.Channel? channel,
    _ik1evhid.DeliveryStatus? status,
    String? dedupeKey,
    int? callVersion,
    int? attempts,
    String? providerRef,
    String? error,
    DateTime? createdAt,
    DateTime? sentAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Notification',
      if (id != null) 'id': id?.toJson(),
      'ticketId': ticketId.toJson(),
      'clinicId': clinicId.toJson(),
      'ticketLabel': ticketLabel,
      'kind': kind.toJson(),
      'channel': channel.toJson(),
      'status': status.toJson(),
      'dedupeKey': dedupeKey,
      'callVersion': callVersion,
      'attempts': attempts,
      if (providerRef != null) 'providerRef': providerRef,
      if (error != null) 'error': error,
      'createdAt': createdAt.toJson(),
      if (sentAt != null) 'sentAt': sentAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Notification',
      if (id != null) 'id': id?.toJson(),
      'ticketId': ticketId.toJson(),
      'clinicId': clinicId.toJson(),
      'ticketLabel': ticketLabel,
      'kind': kind.toJson(),
      'channel': channel.toJson(),
      'status': status.toJson(),
      'dedupeKey': dedupeKey,
      'callVersion': callVersion,
      'attempts': attempts,
      if (providerRef != null) 'providerRef': providerRef,
      if (error != null) 'error': error,
      'createdAt': createdAt.toJson(),
      if (sentAt != null) 'sentAt': sentAt?.toJson(),
    };
  }

  static NotificationInclude include() {
    return NotificationInclude._();
  }

  static NotificationIncludeList includeList({
    _is.WhereExpressionBuilder<NotificationTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<NotificationTable>? orderBy,
    _is.OrderByListBuilder<NotificationTable>? orderByList,
    NotificationInclude? include,
  }) {
    return NotificationIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Notification.t),
      orderByList: orderByList?.call(Notification.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _NotificationImpl extends Notification {
  _NotificationImpl({
    _is.UuidValue? id,
    required _is.UuidValue ticketId,
    required _is.UuidValue clinicId,
    required String ticketLabel,
    required _ic51rir1.NotificationKind kind,
    required _i1ikwq8c.Channel channel,
    required _ik1evhid.DeliveryStatus status,
    required String dedupeKey,
    int? callVersion,
    int? attempts,
    String? providerRef,
    String? error,
    DateTime? createdAt,
    DateTime? sentAt,
  }) : super._(
         id: id,
         ticketId: ticketId,
         clinicId: clinicId,
         ticketLabel: ticketLabel,
         kind: kind,
         channel: channel,
         status: status,
         dedupeKey: dedupeKey,
         callVersion: callVersion,
         attempts: attempts,
         providerRef: providerRef,
         error: error,
         createdAt: createdAt,
         sentAt: sentAt,
       );

  /// Returns a shallow copy of this [Notification]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  Notification copyWith({
    Object? id = _Undefined,
    _is.UuidValue? ticketId,
    _is.UuidValue? clinicId,
    String? ticketLabel,
    _ic51rir1.NotificationKind? kind,
    _i1ikwq8c.Channel? channel,
    _ik1evhid.DeliveryStatus? status,
    String? dedupeKey,
    int? callVersion,
    int? attempts,
    Object? providerRef = _Undefined,
    Object? error = _Undefined,
    DateTime? createdAt,
    Object? sentAt = _Undefined,
  }) {
    return Notification(
      id: id is _is.UuidValue? ? id : this.id,
      ticketId: ticketId ?? this.ticketId,
      clinicId: clinicId ?? this.clinicId,
      ticketLabel: ticketLabel ?? this.ticketLabel,
      kind: kind ?? this.kind,
      channel: channel ?? this.channel,
      status: status ?? this.status,
      dedupeKey: dedupeKey ?? this.dedupeKey,
      callVersion: callVersion ?? this.callVersion,
      attempts: attempts ?? this.attempts,
      providerRef: providerRef is String? ? providerRef : this.providerRef,
      error: error is String? ? error : this.error,
      createdAt: createdAt ?? this.createdAt,
      sentAt: sentAt is DateTime? ? sentAt : this.sentAt,
    );
  }
}

class NotificationUpdateTable extends _is.UpdateTable<NotificationTable> {
  NotificationUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> ticketId(_is.UuidValue value) =>
      _is.ColumnValue(
        table.ticketId,
        value,
      );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> clinicId(_is.UuidValue value) =>
      _is.ColumnValue(
        table.clinicId,
        value,
      );

  _is.ColumnValue<String, String> ticketLabel(String value) => _is.ColumnValue(
    table.ticketLabel,
    value,
  );

  _is.ColumnValue<_ic51rir1.NotificationKind, _ic51rir1.NotificationKind> kind(
    _ic51rir1.NotificationKind value,
  ) => _is.ColumnValue(
    table.kind,
    value,
  );

  _is.ColumnValue<_i1ikwq8c.Channel, _i1ikwq8c.Channel> channel(
    _i1ikwq8c.Channel value,
  ) => _is.ColumnValue(
    table.channel,
    value,
  );

  _is.ColumnValue<_ik1evhid.DeliveryStatus, _ik1evhid.DeliveryStatus> status(
    _ik1evhid.DeliveryStatus value,
  ) => _is.ColumnValue(
    table.status,
    value,
  );

  _is.ColumnValue<String, String> dedupeKey(String value) => _is.ColumnValue(
    table.dedupeKey,
    value,
  );

  _is.ColumnValue<int, int> callVersion(int value) => _is.ColumnValue(
    table.callVersion,
    value,
  );

  _is.ColumnValue<int, int> attempts(int value) => _is.ColumnValue(
    table.attempts,
    value,
  );

  _is.ColumnValue<String, String> providerRef(String? value) => _is.ColumnValue(
    table.providerRef,
    value,
  );

  _is.ColumnValue<String, String> error(String? value) => _is.ColumnValue(
    table.error,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> sentAt(DateTime? value) =>
      _is.ColumnValue(
        table.sentAt,
        value,
      );
}

class NotificationTable extends _is.Table<_is.UuidValue?> {
  NotificationTable({super.tableRelation}) : super(tableName: 'notification') {
    updateTable = NotificationUpdateTable(this);
    ticketId = _is.ColumnUuid(
      'ticketId',
      this,
    );
    clinicId = _is.ColumnUuid(
      'clinicId',
      this,
    );
    ticketLabel = _is.ColumnString(
      'ticketLabel',
      this,
    );
    kind = _is.ColumnEnum(
      'kind',
      this,
      _is.EnumSerialization.byName,
    );
    channel = _is.ColumnEnum(
      'channel',
      this,
      _is.EnumSerialization.byName,
    );
    status = _is.ColumnEnum(
      'status',
      this,
      _is.EnumSerialization.byName,
    );
    dedupeKey = _is.ColumnString(
      'dedupeKey',
      this,
    );
    callVersion = _is.ColumnInt(
      'callVersion',
      this,
      hasDefault: true,
    );
    attempts = _is.ColumnInt(
      'attempts',
      this,
      hasDefault: true,
    );
    providerRef = _is.ColumnString(
      'providerRef',
      this,
    );
    error = _is.ColumnString(
      'error',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
    sentAt = _is.ColumnDateTime(
      'sentAt',
      this,
    );
  }

  late final NotificationUpdateTable updateTable;

  late final _is.ColumnUuid ticketId;

  late final _is.ColumnUuid clinicId;

  late final _is.ColumnString ticketLabel;

  late final _is.ColumnEnum<_ic51rir1.NotificationKind> kind;

  late final _is.ColumnEnum<_i1ikwq8c.Channel> channel;

  late final _is.ColumnEnum<_ik1evhid.DeliveryStatus> status;

  late final _is.ColumnString dedupeKey;

  late final _is.ColumnInt callVersion;

  late final _is.ColumnInt attempts;

  late final _is.ColumnString providerRef;

  late final _is.ColumnString error;

  late final _is.ColumnDateTime createdAt;

  late final _is.ColumnDateTime sentAt;

  @override
  List<_is.Column> get columns => [
    id,
    ticketId,
    clinicId,
    ticketLabel,
    kind,
    channel,
    status,
    dedupeKey,
    callVersion,
    attempts,
    providerRef,
    error,
    createdAt,
    sentAt,
  ];
}

class NotificationInclude extends _is.IncludeObject {
  NotificationInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => Notification.t;
}

class NotificationIncludeList extends _is.IncludeList {
  NotificationIncludeList._({
    _is.WhereExpressionBuilder<NotificationTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Notification.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => Notification.t;
}

class NotificationRepository {
  const NotificationRepository._();

  /// Returns a list of [Notification]s matching the given query parameters.
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
  Future<List<Notification>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<NotificationTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<NotificationTable>? orderBy,
    _is.OrderByListBuilder<NotificationTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Notification>(
      where: where?.call(Notification.t),
      orderBy: orderBy?.call(Notification.t),
      orderByList: orderByList?.call(Notification.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Notification] matching the given query parameters.
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
  Future<Notification?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<NotificationTable>? where,
    int? offset,
    _is.OrderByBuilder<NotificationTable>? orderBy,
    _is.OrderByListBuilder<NotificationTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Notification>(
      where: where?.call(Notification.t),
      orderBy: orderBy?.call(Notification.t),
      orderByList: orderByList?.call(Notification.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Notification] by its [id] or null if no such row exists.
  Future<Notification?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Notification>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Notification]s in the list and returns the inserted rows.
  ///
  /// The returned [Notification]s will have their `id` fields set.
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
  Future<List<Notification>> insert(
    _is.DatabaseSession session,
    List<Notification> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<Notification>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [Notification] and returns the inserted row.
  ///
  /// The returned [Notification] will have its `id` field set.
  Future<Notification> insertRow(
    _is.DatabaseSession session,
    Notification row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<Notification>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [Notification]s in the list and returns the resulting rows.
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
  /// The returned [Notification]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Notification>> upsert(
    _is.DatabaseSession session,
    List<Notification> rows, {
    required _is.ColumnSelections<NotificationTable> conflictColumns,
    _is.ColumnSelections<NotificationTable>? updateColumns,
    _is.WhereExpressionBuilder<NotificationTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<Notification>(
      rows,
      conflictColumns: conflictColumns(Notification.t),
      updateColumns: updateColumns?.call(Notification.t),
      updateWhere: updateWhere?.call(Notification.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [Notification] and returns the resulting row.
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
  /// The returned [Notification] will have its `id` field set.
  Future<Notification?> upsertRow(
    _is.DatabaseSession session,
    Notification row, {
    required _is.ColumnSelections<NotificationTable> conflictColumns,
    _is.ColumnSelections<NotificationTable>? updateColumns,
    _is.WhereExpressionBuilder<NotificationTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<Notification>(
      row,
      conflictColumns: conflictColumns(Notification.t),
      updateColumns: updateColumns?.call(Notification.t),
      updateWhere: updateWhere?.call(Notification.t),
      transaction: transaction,
    );
  }

  /// Updates all [Notification]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Notification>> update(
    _is.DatabaseSession session,
    List<Notification> rows, {
    _is.ColumnSelections<NotificationTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<Notification>(
      rows,
      columns: columns?.call(Notification.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [Notification]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Notification> updateRow(
    _is.DatabaseSession session,
    Notification row, {
    _is.ColumnSelections<NotificationTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<Notification>(
      row,
      columns: columns?.call(Notification.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Notification] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Notification?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<NotificationUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<Notification>(
      id,
      columnValues: columnValues(Notification.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Notification]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Notification>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<NotificationUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<NotificationTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<NotificationTable>? orderBy,
    _is.OrderByListBuilder<NotificationTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<Notification>(
      columnValues: columnValues(Notification.t.updateTable),
      where: where(Notification.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Notification.t),
      orderByList: orderByList?.call(Notification.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [Notification]s in the list and returns the deleted rows.
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
  Future<List<Notification>> delete(
    _is.DatabaseSession session,
    List<Notification> rows, {
    _is.OrderByBuilder<NotificationTable>? orderBy,
    _is.OrderByListBuilder<NotificationTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<Notification>(
      rows,
      orderBy: orderBy?.call(Notification.t),
      orderByList: orderByList?.call(Notification.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [Notification].
  Future<Notification> deleteRow(
    _is.DatabaseSession session,
    Notification row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Notification>(
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
  Future<List<Notification>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<NotificationTable> where,
    _is.OrderByBuilder<NotificationTable>? orderBy,
    _is.OrderByListBuilder<NotificationTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<Notification>(
      where: where(Notification.t),
      orderBy: orderBy?.call(Notification.t),
      orderByList: orderByList?.call(Notification.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<NotificationTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<Notification>(
      where: where?.call(Notification.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Notification] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<NotificationTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Notification>(
      where: where(Notification.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
