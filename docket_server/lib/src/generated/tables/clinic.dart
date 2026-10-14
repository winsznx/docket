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

abstract class Clinic
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  Clinic._({
    this.id,
    required this.name,
    required this.slug,
    String? timezone,
    String? openTime,
    String? joinCutoffTime,
    String? closeTime,
    int? autoCloseAfterMinutes,
    int? graceSeconds,
    int? graceReminderSeconds,
    int? arrivalSeconds,
    int? headsUpPositions,
    int? headsUpMinutes,
    int? reslotOffset,
    int? maxReslots,
    bool? smsEnabled,
    bool? isSandbox,
    this.sandboxExpiresAt,
    this.boardTokenHash,
    this.sandboxTokenHash,
    DateTime? createdAt,
  }) : timezone = timezone ?? 'Africa/Lagos',
       openTime = openTime ?? '08:00',
       joinCutoffTime = joinCutoffTime ?? '17:00',
       closeTime = closeTime ?? '18:00',
       autoCloseAfterMinutes = autoCloseAfterMinutes ?? 120,
       graceSeconds = graceSeconds ?? 180,
       graceReminderSeconds = graceReminderSeconds ?? 60,
       arrivalSeconds = arrivalSeconds ?? 600,
       headsUpPositions = headsUpPositions ?? 2,
       headsUpMinutes = headsUpMinutes ?? 10,
       reslotOffset = reslotOffset ?? 3,
       maxReslots = maxReslots ?? 1,
       smsEnabled = smsEnabled ?? false,
       isSandbox = isSandbox ?? false,
       createdAt = createdAt ?? DateTime.now();

  factory Clinic({
    _is.UuidValue? id,
    required String name,
    required String slug,
    String? timezone,
    String? openTime,
    String? joinCutoffTime,
    String? closeTime,
    int? autoCloseAfterMinutes,
    int? graceSeconds,
    int? graceReminderSeconds,
    int? arrivalSeconds,
    int? headsUpPositions,
    int? headsUpMinutes,
    int? reslotOffset,
    int? maxReslots,
    bool? smsEnabled,
    bool? isSandbox,
    DateTime? sandboxExpiresAt,
    String? boardTokenHash,
    String? sandboxTokenHash,
    DateTime? createdAt,
  }) = _ClinicImpl;

  factory Clinic.fromJson(Map<String, dynamic> jsonSerialization) {
    return Clinic(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      name: jsonSerialization['name'] as String,
      slug: jsonSerialization['slug'] as String,
      timezone: jsonSerialization['timezone'] as String?,
      openTime: jsonSerialization['openTime'] as String?,
      joinCutoffTime: jsonSerialization['joinCutoffTime'] as String?,
      closeTime: jsonSerialization['closeTime'] as String?,
      autoCloseAfterMinutes: jsonSerialization['autoCloseAfterMinutes'] as int?,
      graceSeconds: jsonSerialization['graceSeconds'] as int?,
      graceReminderSeconds: jsonSerialization['graceReminderSeconds'] as int?,
      arrivalSeconds: jsonSerialization['arrivalSeconds'] as int?,
      headsUpPositions: jsonSerialization['headsUpPositions'] as int?,
      headsUpMinutes: jsonSerialization['headsUpMinutes'] as int?,
      reslotOffset: jsonSerialization['reslotOffset'] as int?,
      maxReslots: jsonSerialization['maxReslots'] as int?,
      smsEnabled: jsonSerialization['smsEnabled'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['smsEnabled']),
      isSandbox: jsonSerialization['isSandbox'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['isSandbox']),
      sandboxExpiresAt: jsonSerialization['sandboxExpiresAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['sandboxExpiresAt'],
            ),
      boardTokenHash: jsonSerialization['boardTokenHash'] as String?,
      sandboxTokenHash: jsonSerialization['sandboxTokenHash'] as String?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = ClinicTable();

  static const db = ClinicRepository._();

  @override
  _is.UuidValue? id;

  String name;

  String slug;

  String timezone;

  String openTime;

  String joinCutoffTime;

  String closeTime;

  int autoCloseAfterMinutes;

  int graceSeconds;

  int graceReminderSeconds;

  int arrivalSeconds;

  int headsUpPositions;

  int headsUpMinutes;

  int reslotOffset;

  int maxReslots;

  bool smsEnabled;

  bool isSandbox;

  DateTime? sandboxExpiresAt;

  String? boardTokenHash;

  String? sandboxTokenHash;

  DateTime createdAt;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [Clinic]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  Clinic copyWith({
    _is.UuidValue? id,
    String? name,
    String? slug,
    String? timezone,
    String? openTime,
    String? joinCutoffTime,
    String? closeTime,
    int? autoCloseAfterMinutes,
    int? graceSeconds,
    int? graceReminderSeconds,
    int? arrivalSeconds,
    int? headsUpPositions,
    int? headsUpMinutes,
    int? reslotOffset,
    int? maxReslots,
    bool? smsEnabled,
    bool? isSandbox,
    DateTime? sandboxExpiresAt,
    String? boardTokenHash,
    String? sandboxTokenHash,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Clinic',
      if (id != null) 'id': id?.toJson(),
      'name': name,
      'slug': slug,
      'timezone': timezone,
      'openTime': openTime,
      'joinCutoffTime': joinCutoffTime,
      'closeTime': closeTime,
      'autoCloseAfterMinutes': autoCloseAfterMinutes,
      'graceSeconds': graceSeconds,
      'graceReminderSeconds': graceReminderSeconds,
      'arrivalSeconds': arrivalSeconds,
      'headsUpPositions': headsUpPositions,
      'headsUpMinutes': headsUpMinutes,
      'reslotOffset': reslotOffset,
      'maxReslots': maxReslots,
      'smsEnabled': smsEnabled,
      'isSandbox': isSandbox,
      if (sandboxExpiresAt != null)
        'sandboxExpiresAt': sandboxExpiresAt?.toJson(),
      if (boardTokenHash != null) 'boardTokenHash': boardTokenHash,
      if (sandboxTokenHash != null) 'sandboxTokenHash': sandboxTokenHash,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Clinic',
      if (id != null) 'id': id?.toJson(),
      'name': name,
      'slug': slug,
      'timezone': timezone,
      'openTime': openTime,
      'joinCutoffTime': joinCutoffTime,
      'closeTime': closeTime,
      'autoCloseAfterMinutes': autoCloseAfterMinutes,
      'graceSeconds': graceSeconds,
      'graceReminderSeconds': graceReminderSeconds,
      'arrivalSeconds': arrivalSeconds,
      'headsUpPositions': headsUpPositions,
      'headsUpMinutes': headsUpMinutes,
      'reslotOffset': reslotOffset,
      'maxReslots': maxReslots,
      'smsEnabled': smsEnabled,
      'isSandbox': isSandbox,
      if (sandboxExpiresAt != null)
        'sandboxExpiresAt': sandboxExpiresAt?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  static ClinicInclude include() {
    return ClinicInclude._();
  }

  static ClinicIncludeList includeList({
    _is.WhereExpressionBuilder<ClinicTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ClinicTable>? orderBy,
    _is.OrderByListBuilder<ClinicTable>? orderByList,
    ClinicInclude? include,
  }) {
    return ClinicIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Clinic.t),
      orderByList: orderByList?.call(Clinic.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ClinicImpl extends Clinic {
  _ClinicImpl({
    _is.UuidValue? id,
    required String name,
    required String slug,
    String? timezone,
    String? openTime,
    String? joinCutoffTime,
    String? closeTime,
    int? autoCloseAfterMinutes,
    int? graceSeconds,
    int? graceReminderSeconds,
    int? arrivalSeconds,
    int? headsUpPositions,
    int? headsUpMinutes,
    int? reslotOffset,
    int? maxReslots,
    bool? smsEnabled,
    bool? isSandbox,
    DateTime? sandboxExpiresAt,
    String? boardTokenHash,
    String? sandboxTokenHash,
    DateTime? createdAt,
  }) : super._(
         id: id,
         name: name,
         slug: slug,
         timezone: timezone,
         openTime: openTime,
         joinCutoffTime: joinCutoffTime,
         closeTime: closeTime,
         autoCloseAfterMinutes: autoCloseAfterMinutes,
         graceSeconds: graceSeconds,
         graceReminderSeconds: graceReminderSeconds,
         arrivalSeconds: arrivalSeconds,
         headsUpPositions: headsUpPositions,
         headsUpMinutes: headsUpMinutes,
         reslotOffset: reslotOffset,
         maxReslots: maxReslots,
         smsEnabled: smsEnabled,
         isSandbox: isSandbox,
         sandboxExpiresAt: sandboxExpiresAt,
         boardTokenHash: boardTokenHash,
         sandboxTokenHash: sandboxTokenHash,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [Clinic]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  Clinic copyWith({
    Object? id = _Undefined,
    String? name,
    String? slug,
    String? timezone,
    String? openTime,
    String? joinCutoffTime,
    String? closeTime,
    int? autoCloseAfterMinutes,
    int? graceSeconds,
    int? graceReminderSeconds,
    int? arrivalSeconds,
    int? headsUpPositions,
    int? headsUpMinutes,
    int? reslotOffset,
    int? maxReslots,
    bool? smsEnabled,
    bool? isSandbox,
    Object? sandboxExpiresAt = _Undefined,
    Object? boardTokenHash = _Undefined,
    Object? sandboxTokenHash = _Undefined,
    DateTime? createdAt,
  }) {
    return Clinic(
      id: id is _is.UuidValue? ? id : this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      timezone: timezone ?? this.timezone,
      openTime: openTime ?? this.openTime,
      joinCutoffTime: joinCutoffTime ?? this.joinCutoffTime,
      closeTime: closeTime ?? this.closeTime,
      autoCloseAfterMinutes:
          autoCloseAfterMinutes ?? this.autoCloseAfterMinutes,
      graceSeconds: graceSeconds ?? this.graceSeconds,
      graceReminderSeconds: graceReminderSeconds ?? this.graceReminderSeconds,
      arrivalSeconds: arrivalSeconds ?? this.arrivalSeconds,
      headsUpPositions: headsUpPositions ?? this.headsUpPositions,
      headsUpMinutes: headsUpMinutes ?? this.headsUpMinutes,
      reslotOffset: reslotOffset ?? this.reslotOffset,
      maxReslots: maxReslots ?? this.maxReslots,
      smsEnabled: smsEnabled ?? this.smsEnabled,
      isSandbox: isSandbox ?? this.isSandbox,
      sandboxExpiresAt: sandboxExpiresAt is DateTime?
          ? sandboxExpiresAt
          : this.sandboxExpiresAt,
      boardTokenHash: boardTokenHash is String?
          ? boardTokenHash
          : this.boardTokenHash,
      sandboxTokenHash: sandboxTokenHash is String?
          ? sandboxTokenHash
          : this.sandboxTokenHash,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class ClinicUpdateTable extends _is.UpdateTable<ClinicTable> {
  ClinicUpdateTable(super.table);

  _is.ColumnValue<String, String> name(String value) => _is.ColumnValue(
    table.name,
    value,
  );

  _is.ColumnValue<String, String> slug(String value) => _is.ColumnValue(
    table.slug,
    value,
  );

  _is.ColumnValue<String, String> timezone(String value) => _is.ColumnValue(
    table.timezone,
    value,
  );

  _is.ColumnValue<String, String> openTime(String value) => _is.ColumnValue(
    table.openTime,
    value,
  );

  _is.ColumnValue<String, String> joinCutoffTime(String value) =>
      _is.ColumnValue(
        table.joinCutoffTime,
        value,
      );

  _is.ColumnValue<String, String> closeTime(String value) => _is.ColumnValue(
    table.closeTime,
    value,
  );

  _is.ColumnValue<int, int> autoCloseAfterMinutes(int value) => _is.ColumnValue(
    table.autoCloseAfterMinutes,
    value,
  );

  _is.ColumnValue<int, int> graceSeconds(int value) => _is.ColumnValue(
    table.graceSeconds,
    value,
  );

  _is.ColumnValue<int, int> graceReminderSeconds(int value) => _is.ColumnValue(
    table.graceReminderSeconds,
    value,
  );

  _is.ColumnValue<int, int> arrivalSeconds(int value) => _is.ColumnValue(
    table.arrivalSeconds,
    value,
  );

  _is.ColumnValue<int, int> headsUpPositions(int value) => _is.ColumnValue(
    table.headsUpPositions,
    value,
  );

  _is.ColumnValue<int, int> headsUpMinutes(int value) => _is.ColumnValue(
    table.headsUpMinutes,
    value,
  );

  _is.ColumnValue<int, int> reslotOffset(int value) => _is.ColumnValue(
    table.reslotOffset,
    value,
  );

  _is.ColumnValue<int, int> maxReslots(int value) => _is.ColumnValue(
    table.maxReslots,
    value,
  );

  _is.ColumnValue<bool, bool> smsEnabled(bool value) => _is.ColumnValue(
    table.smsEnabled,
    value,
  );

  _is.ColumnValue<bool, bool> isSandbox(bool value) => _is.ColumnValue(
    table.isSandbox,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> sandboxExpiresAt(DateTime? value) =>
      _is.ColumnValue(
        table.sandboxExpiresAt,
        value,
      );

  _is.ColumnValue<String, String> boardTokenHash(String? value) =>
      _is.ColumnValue(
        table.boardTokenHash,
        value,
      );

  _is.ColumnValue<String, String> sandboxTokenHash(String? value) =>
      _is.ColumnValue(
        table.sandboxTokenHash,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );
}

class ClinicTable extends _is.Table<_is.UuidValue?> {
  ClinicTable({super.tableRelation}) : super(tableName: 'clinic') {
    updateTable = ClinicUpdateTable(this);
    name = _is.ColumnString(
      'name',
      this,
    );
    slug = _is.ColumnString(
      'slug',
      this,
    );
    timezone = _is.ColumnString(
      'timezone',
      this,
      hasDefault: true,
    );
    openTime = _is.ColumnString(
      'openTime',
      this,
      hasDefault: true,
    );
    joinCutoffTime = _is.ColumnString(
      'joinCutoffTime',
      this,
      hasDefault: true,
    );
    closeTime = _is.ColumnString(
      'closeTime',
      this,
      hasDefault: true,
    );
    autoCloseAfterMinutes = _is.ColumnInt(
      'autoCloseAfterMinutes',
      this,
      hasDefault: true,
    );
    graceSeconds = _is.ColumnInt(
      'graceSeconds',
      this,
      hasDefault: true,
    );
    graceReminderSeconds = _is.ColumnInt(
      'graceReminderSeconds',
      this,
      hasDefault: true,
    );
    arrivalSeconds = _is.ColumnInt(
      'arrivalSeconds',
      this,
      hasDefault: true,
    );
    headsUpPositions = _is.ColumnInt(
      'headsUpPositions',
      this,
      hasDefault: true,
    );
    headsUpMinutes = _is.ColumnInt(
      'headsUpMinutes',
      this,
      hasDefault: true,
    );
    reslotOffset = _is.ColumnInt(
      'reslotOffset',
      this,
      hasDefault: true,
    );
    maxReslots = _is.ColumnInt(
      'maxReslots',
      this,
      hasDefault: true,
    );
    smsEnabled = _is.ColumnBool(
      'smsEnabled',
      this,
      hasDefault: true,
    );
    isSandbox = _is.ColumnBool(
      'isSandbox',
      this,
      hasDefault: true,
    );
    sandboxExpiresAt = _is.ColumnDateTime(
      'sandboxExpiresAt',
      this,
    );
    boardTokenHash = _is.ColumnString(
      'boardTokenHash',
      this,
    );
    sandboxTokenHash = _is.ColumnString(
      'sandboxTokenHash',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
  }

  late final ClinicUpdateTable updateTable;

  late final _is.ColumnString name;

  late final _is.ColumnString slug;

  late final _is.ColumnString timezone;

  late final _is.ColumnString openTime;

  late final _is.ColumnString joinCutoffTime;

  late final _is.ColumnString closeTime;

  late final _is.ColumnInt autoCloseAfterMinutes;

  late final _is.ColumnInt graceSeconds;

  late final _is.ColumnInt graceReminderSeconds;

  late final _is.ColumnInt arrivalSeconds;

  late final _is.ColumnInt headsUpPositions;

  late final _is.ColumnInt headsUpMinutes;

  late final _is.ColumnInt reslotOffset;

  late final _is.ColumnInt maxReslots;

  late final _is.ColumnBool smsEnabled;

  late final _is.ColumnBool isSandbox;

  late final _is.ColumnDateTime sandboxExpiresAt;

  late final _is.ColumnString boardTokenHash;

  late final _is.ColumnString sandboxTokenHash;

  late final _is.ColumnDateTime createdAt;

  @override
  List<_is.Column> get columns => [
    id,
    name,
    slug,
    timezone,
    openTime,
    joinCutoffTime,
    closeTime,
    autoCloseAfterMinutes,
    graceSeconds,
    graceReminderSeconds,
    arrivalSeconds,
    headsUpPositions,
    headsUpMinutes,
    reslotOffset,
    maxReslots,
    smsEnabled,
    isSandbox,
    sandboxExpiresAt,
    boardTokenHash,
    sandboxTokenHash,
    createdAt,
  ];
}

class ClinicInclude extends _is.IncludeObject {
  ClinicInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => Clinic.t;
}

class ClinicIncludeList extends _is.IncludeList {
  ClinicIncludeList._({
    _is.WhereExpressionBuilder<ClinicTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Clinic.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => Clinic.t;
}

class ClinicRepository {
  const ClinicRepository._();

  /// Returns a list of [Clinic]s matching the given query parameters.
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
  Future<List<Clinic>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ClinicTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ClinicTable>? orderBy,
    _is.OrderByListBuilder<ClinicTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Clinic>(
      where: where?.call(Clinic.t),
      orderBy: orderBy?.call(Clinic.t),
      orderByList: orderByList?.call(Clinic.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Clinic] matching the given query parameters.
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
  Future<Clinic?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ClinicTable>? where,
    int? offset,
    _is.OrderByBuilder<ClinicTable>? orderBy,
    _is.OrderByListBuilder<ClinicTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Clinic>(
      where: where?.call(Clinic.t),
      orderBy: orderBy?.call(Clinic.t),
      orderByList: orderByList?.call(Clinic.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Clinic] by its [id] or null if no such row exists.
  Future<Clinic?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Clinic>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Clinic]s in the list and returns the inserted rows.
  ///
  /// The returned [Clinic]s will have their `id` fields set.
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
  Future<List<Clinic>> insert(
    _is.DatabaseSession session,
    List<Clinic> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<Clinic>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [Clinic] and returns the inserted row.
  ///
  /// The returned [Clinic] will have its `id` field set.
  Future<Clinic> insertRow(
    _is.DatabaseSession session,
    Clinic row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<Clinic>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [Clinic]s in the list and returns the resulting rows.
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
  /// The returned [Clinic]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Clinic>> upsert(
    _is.DatabaseSession session,
    List<Clinic> rows, {
    required _is.ColumnSelections<ClinicTable> conflictColumns,
    _is.ColumnSelections<ClinicTable>? updateColumns,
    _is.WhereExpressionBuilder<ClinicTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<Clinic>(
      rows,
      conflictColumns: conflictColumns(Clinic.t),
      updateColumns: updateColumns?.call(Clinic.t),
      updateWhere: updateWhere?.call(Clinic.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [Clinic] and returns the resulting row.
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
  /// The returned [Clinic] will have its `id` field set.
  Future<Clinic?> upsertRow(
    _is.DatabaseSession session,
    Clinic row, {
    required _is.ColumnSelections<ClinicTable> conflictColumns,
    _is.ColumnSelections<ClinicTable>? updateColumns,
    _is.WhereExpressionBuilder<ClinicTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<Clinic>(
      row,
      conflictColumns: conflictColumns(Clinic.t),
      updateColumns: updateColumns?.call(Clinic.t),
      updateWhere: updateWhere?.call(Clinic.t),
      transaction: transaction,
    );
  }

  /// Updates all [Clinic]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Clinic>> update(
    _is.DatabaseSession session,
    List<Clinic> rows, {
    _is.ColumnSelections<ClinicTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<Clinic>(
      rows,
      columns: columns?.call(Clinic.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [Clinic]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Clinic> updateRow(
    _is.DatabaseSession session,
    Clinic row, {
    _is.ColumnSelections<ClinicTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<Clinic>(
      row,
      columns: columns?.call(Clinic.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Clinic] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Clinic?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<ClinicUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<Clinic>(
      id,
      columnValues: columnValues(Clinic.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Clinic]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Clinic>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<ClinicUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<ClinicTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ClinicTable>? orderBy,
    _is.OrderByListBuilder<ClinicTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<Clinic>(
      columnValues: columnValues(Clinic.t.updateTable),
      where: where(Clinic.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Clinic.t),
      orderByList: orderByList?.call(Clinic.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [Clinic]s in the list and returns the deleted rows.
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
  Future<List<Clinic>> delete(
    _is.DatabaseSession session,
    List<Clinic> rows, {
    _is.OrderByBuilder<ClinicTable>? orderBy,
    _is.OrderByListBuilder<ClinicTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<Clinic>(
      rows,
      orderBy: orderBy?.call(Clinic.t),
      orderByList: orderByList?.call(Clinic.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [Clinic].
  Future<Clinic> deleteRow(
    _is.DatabaseSession session,
    Clinic row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Clinic>(
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
  Future<List<Clinic>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ClinicTable> where,
    _is.OrderByBuilder<ClinicTable>? orderBy,
    _is.OrderByListBuilder<ClinicTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<Clinic>(
      where: where(Clinic.t),
      orderBy: orderBy?.call(Clinic.t),
      orderByList: orderByList?.call(Clinic.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ClinicTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<Clinic>(
      where: where?.call(Clinic.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Clinic] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ClinicTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Clinic>(
      where: where(Clinic.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
