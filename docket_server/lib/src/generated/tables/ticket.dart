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
import '../enums/priority_reason.dart' as _ic48vmv6;
import '../enums/ticket_state.dart' as _imwmdlft;

abstract class Ticket
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  Ticket._({
    this.id,
    required this.clinicId,
    required this.lineId,
    required this.serviceDate,
    required this.number,
    required this.label,
    this.tokenHash,
    required this.displayName,
    required this.state,
    int? priorityRank,
    this.priorityReason,
    this.priorityNote,
    required this.sortKey,
    int? reslotCount,
    int? callVersion,
    this.roomId,
    required this.joinedAt,
    this.calledAt,
    this.confirmedAt,
    this.serviceStartedAt,
    this.finishedAt,
    this.headsUpSentAt,
    this.transferredFromTicketId,
    this.transferredToTicketId,
    this.closedReason,
    this.transferTokenCipher,
    bool? isDemo,
  }) : priorityRank = priorityRank ?? 1,
       reslotCount = reslotCount ?? 0,
       callVersion = callVersion ?? 0,
       isDemo = isDemo ?? false;

  factory Ticket({
    _is.UuidValue? id,
    required _is.UuidValue clinicId,
    required _is.UuidValue lineId,
    required String serviceDate,
    required int number,
    required String label,
    String? tokenHash,
    required String displayName,
    required _imwmdlft.TicketState state,
    int? priorityRank,
    _ic48vmv6.PriorityReason? priorityReason,
    String? priorityNote,
    required double sortKey,
    int? reslotCount,
    int? callVersion,
    _is.UuidValue? roomId,
    required DateTime joinedAt,
    DateTime? calledAt,
    DateTime? confirmedAt,
    DateTime? serviceStartedAt,
    DateTime? finishedAt,
    DateTime? headsUpSentAt,
    _is.UuidValue? transferredFromTicketId,
    _is.UuidValue? transferredToTicketId,
    String? closedReason,
    String? transferTokenCipher,
    bool? isDemo,
  }) = _TicketImpl;

  factory Ticket.fromJson(Map<String, dynamic> jsonSerialization) {
    return Ticket(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      clinicId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['clinicId'],
      ),
      lineId: _is.UuidValueJsonExtension.fromJson(jsonSerialization['lineId']),
      serviceDate: jsonSerialization['serviceDate'] as String,
      number: jsonSerialization['number'] as int,
      label: jsonSerialization['label'] as String,
      tokenHash: jsonSerialization['tokenHash'] as String?,
      displayName: jsonSerialization['displayName'] as String,
      state: _imwmdlft.TicketState.fromJson(
        (jsonSerialization['state'] as String),
      ),
      priorityRank: jsonSerialization['priorityRank'] as int?,
      priorityReason: jsonSerialization['priorityReason'] == null
          ? null
          : _ic48vmv6.PriorityReason.fromJson(
              (jsonSerialization['priorityReason'] as String),
            ),
      priorityNote: jsonSerialization['priorityNote'] as String?,
      sortKey: (jsonSerialization['sortKey'] as num).toDouble(),
      reslotCount: jsonSerialization['reslotCount'] as int?,
      callVersion: jsonSerialization['callVersion'] as int?,
      roomId: jsonSerialization['roomId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['roomId']),
      joinedAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['joinedAt'],
      ),
      calledAt: jsonSerialization['calledAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['calledAt']),
      confirmedAt: jsonSerialization['confirmedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['confirmedAt'],
            ),
      serviceStartedAt: jsonSerialization['serviceStartedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['serviceStartedAt'],
            ),
      finishedAt: jsonSerialization['finishedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['finishedAt']),
      headsUpSentAt: jsonSerialization['headsUpSentAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['headsUpSentAt'],
            ),
      transferredFromTicketId:
          jsonSerialization['transferredFromTicketId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(
              jsonSerialization['transferredFromTicketId'],
            ),
      transferredToTicketId: jsonSerialization['transferredToTicketId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(
              jsonSerialization['transferredToTicketId'],
            ),
      closedReason: jsonSerialization['closedReason'] as String?,
      transferTokenCipher: jsonSerialization['transferTokenCipher'] as String?,
      isDemo: jsonSerialization['isDemo'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['isDemo']),
    );
  }

  static final t = TicketTable();

  static const db = TicketRepository._();

  @override
  _is.UuidValue? id;

  _is.UuidValue clinicId;

  _is.UuidValue lineId;

  String serviceDate;

  int number;

  String label;

  String? tokenHash;

  String displayName;

  _imwmdlft.TicketState state;

  int priorityRank;

  _ic48vmv6.PriorityReason? priorityReason;

  String? priorityNote;

  double sortKey;

  int reslotCount;

  int callVersion;

  _is.UuidValue? roomId;

  DateTime joinedAt;

  DateTime? calledAt;

  DateTime? confirmedAt;

  DateTime? serviceStartedAt;

  DateTime? finishedAt;

  DateTime? headsUpSentAt;

  _is.UuidValue? transferredFromTicketId;

  _is.UuidValue? transferredToTicketId;

  String? closedReason;

  String? transferTokenCipher;

  bool isDemo;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [Ticket]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  Ticket copyWith({
    _is.UuidValue? id,
    _is.UuidValue? clinicId,
    _is.UuidValue? lineId,
    String? serviceDate,
    int? number,
    String? label,
    String? tokenHash,
    String? displayName,
    _imwmdlft.TicketState? state,
    int? priorityRank,
    _ic48vmv6.PriorityReason? priorityReason,
    String? priorityNote,
    double? sortKey,
    int? reslotCount,
    int? callVersion,
    _is.UuidValue? roomId,
    DateTime? joinedAt,
    DateTime? calledAt,
    DateTime? confirmedAt,
    DateTime? serviceStartedAt,
    DateTime? finishedAt,
    DateTime? headsUpSentAt,
    _is.UuidValue? transferredFromTicketId,
    _is.UuidValue? transferredToTicketId,
    String? closedReason,
    String? transferTokenCipher,
    bool? isDemo,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Ticket',
      if (id != null) 'id': id?.toJson(),
      'clinicId': clinicId.toJson(),
      'lineId': lineId.toJson(),
      'serviceDate': serviceDate,
      'number': number,
      'label': label,
      if (tokenHash != null) 'tokenHash': tokenHash,
      'displayName': displayName,
      'state': state.toJson(),
      'priorityRank': priorityRank,
      if (priorityReason != null) 'priorityReason': priorityReason?.toJson(),
      if (priorityNote != null) 'priorityNote': priorityNote,
      'sortKey': sortKey,
      'reslotCount': reslotCount,
      'callVersion': callVersion,
      if (roomId != null) 'roomId': roomId?.toJson(),
      'joinedAt': joinedAt.toJson(),
      if (calledAt != null) 'calledAt': calledAt?.toJson(),
      if (confirmedAt != null) 'confirmedAt': confirmedAt?.toJson(),
      if (serviceStartedAt != null)
        'serviceStartedAt': serviceStartedAt?.toJson(),
      if (finishedAt != null) 'finishedAt': finishedAt?.toJson(),
      if (headsUpSentAt != null) 'headsUpSentAt': headsUpSentAt?.toJson(),
      if (transferredFromTicketId != null)
        'transferredFromTicketId': transferredFromTicketId?.toJson(),
      if (transferredToTicketId != null)
        'transferredToTicketId': transferredToTicketId?.toJson(),
      if (closedReason != null) 'closedReason': closedReason,
      if (transferTokenCipher != null)
        'transferTokenCipher': transferTokenCipher,
      'isDemo': isDemo,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Ticket',
      if (id != null) 'id': id?.toJson(),
      'clinicId': clinicId.toJson(),
      'lineId': lineId.toJson(),
      'serviceDate': serviceDate,
      'number': number,
      'label': label,
      'displayName': displayName,
      'state': state.toJson(),
      'priorityRank': priorityRank,
      if (priorityReason != null) 'priorityReason': priorityReason?.toJson(),
      if (priorityNote != null) 'priorityNote': priorityNote,
      'sortKey': sortKey,
      'reslotCount': reslotCount,
      'callVersion': callVersion,
      if (roomId != null) 'roomId': roomId?.toJson(),
      'joinedAt': joinedAt.toJson(),
      if (calledAt != null) 'calledAt': calledAt?.toJson(),
      if (confirmedAt != null) 'confirmedAt': confirmedAt?.toJson(),
      if (serviceStartedAt != null)
        'serviceStartedAt': serviceStartedAt?.toJson(),
      if (finishedAt != null) 'finishedAt': finishedAt?.toJson(),
      if (headsUpSentAt != null) 'headsUpSentAt': headsUpSentAt?.toJson(),
      if (transferredFromTicketId != null)
        'transferredFromTicketId': transferredFromTicketId?.toJson(),
      if (transferredToTicketId != null)
        'transferredToTicketId': transferredToTicketId?.toJson(),
      if (closedReason != null) 'closedReason': closedReason,
      'isDemo': isDemo,
    };
  }

  static TicketInclude include() {
    return TicketInclude._();
  }

  static TicketIncludeList includeList({
    _is.WhereExpressionBuilder<TicketTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<TicketTable>? orderBy,
    _is.OrderByListBuilder<TicketTable>? orderByList,
    TicketInclude? include,
  }) {
    return TicketIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Ticket.t),
      orderByList: orderByList?.call(Ticket.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TicketImpl extends Ticket {
  _TicketImpl({
    _is.UuidValue? id,
    required _is.UuidValue clinicId,
    required _is.UuidValue lineId,
    required String serviceDate,
    required int number,
    required String label,
    String? tokenHash,
    required String displayName,
    required _imwmdlft.TicketState state,
    int? priorityRank,
    _ic48vmv6.PriorityReason? priorityReason,
    String? priorityNote,
    required double sortKey,
    int? reslotCount,
    int? callVersion,
    _is.UuidValue? roomId,
    required DateTime joinedAt,
    DateTime? calledAt,
    DateTime? confirmedAt,
    DateTime? serviceStartedAt,
    DateTime? finishedAt,
    DateTime? headsUpSentAt,
    _is.UuidValue? transferredFromTicketId,
    _is.UuidValue? transferredToTicketId,
    String? closedReason,
    String? transferTokenCipher,
    bool? isDemo,
  }) : super._(
         id: id,
         clinicId: clinicId,
         lineId: lineId,
         serviceDate: serviceDate,
         number: number,
         label: label,
         tokenHash: tokenHash,
         displayName: displayName,
         state: state,
         priorityRank: priorityRank,
         priorityReason: priorityReason,
         priorityNote: priorityNote,
         sortKey: sortKey,
         reslotCount: reslotCount,
         callVersion: callVersion,
         roomId: roomId,
         joinedAt: joinedAt,
         calledAt: calledAt,
         confirmedAt: confirmedAt,
         serviceStartedAt: serviceStartedAt,
         finishedAt: finishedAt,
         headsUpSentAt: headsUpSentAt,
         transferredFromTicketId: transferredFromTicketId,
         transferredToTicketId: transferredToTicketId,
         closedReason: closedReason,
         transferTokenCipher: transferTokenCipher,
         isDemo: isDemo,
       );

  /// Returns a shallow copy of this [Ticket]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  Ticket copyWith({
    Object? id = _Undefined,
    _is.UuidValue? clinicId,
    _is.UuidValue? lineId,
    String? serviceDate,
    int? number,
    String? label,
    Object? tokenHash = _Undefined,
    String? displayName,
    _imwmdlft.TicketState? state,
    int? priorityRank,
    Object? priorityReason = _Undefined,
    Object? priorityNote = _Undefined,
    double? sortKey,
    int? reslotCount,
    int? callVersion,
    Object? roomId = _Undefined,
    DateTime? joinedAt,
    Object? calledAt = _Undefined,
    Object? confirmedAt = _Undefined,
    Object? serviceStartedAt = _Undefined,
    Object? finishedAt = _Undefined,
    Object? headsUpSentAt = _Undefined,
    Object? transferredFromTicketId = _Undefined,
    Object? transferredToTicketId = _Undefined,
    Object? closedReason = _Undefined,
    Object? transferTokenCipher = _Undefined,
    bool? isDemo,
  }) {
    return Ticket(
      id: id is _is.UuidValue? ? id : this.id,
      clinicId: clinicId ?? this.clinicId,
      lineId: lineId ?? this.lineId,
      serviceDate: serviceDate ?? this.serviceDate,
      number: number ?? this.number,
      label: label ?? this.label,
      tokenHash: tokenHash is String? ? tokenHash : this.tokenHash,
      displayName: displayName ?? this.displayName,
      state: state ?? this.state,
      priorityRank: priorityRank ?? this.priorityRank,
      priorityReason: priorityReason is _ic48vmv6.PriorityReason?
          ? priorityReason
          : this.priorityReason,
      priorityNote: priorityNote is String? ? priorityNote : this.priorityNote,
      sortKey: sortKey ?? this.sortKey,
      reslotCount: reslotCount ?? this.reslotCount,
      callVersion: callVersion ?? this.callVersion,
      roomId: roomId is _is.UuidValue? ? roomId : this.roomId,
      joinedAt: joinedAt ?? this.joinedAt,
      calledAt: calledAt is DateTime? ? calledAt : this.calledAt,
      confirmedAt: confirmedAt is DateTime? ? confirmedAt : this.confirmedAt,
      serviceStartedAt: serviceStartedAt is DateTime?
          ? serviceStartedAt
          : this.serviceStartedAt,
      finishedAt: finishedAt is DateTime? ? finishedAt : this.finishedAt,
      headsUpSentAt: headsUpSentAt is DateTime?
          ? headsUpSentAt
          : this.headsUpSentAt,
      transferredFromTicketId: transferredFromTicketId is _is.UuidValue?
          ? transferredFromTicketId
          : this.transferredFromTicketId,
      transferredToTicketId: transferredToTicketId is _is.UuidValue?
          ? transferredToTicketId
          : this.transferredToTicketId,
      closedReason: closedReason is String? ? closedReason : this.closedReason,
      transferTokenCipher: transferTokenCipher is String?
          ? transferTokenCipher
          : this.transferTokenCipher,
      isDemo: isDemo ?? this.isDemo,
    );
  }
}

class TicketUpdateTable extends _is.UpdateTable<TicketTable> {
  TicketUpdateTable(super.table);

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

  _is.ColumnValue<String, String> serviceDate(String value) => _is.ColumnValue(
    table.serviceDate,
    value,
  );

  _is.ColumnValue<int, int> number(int value) => _is.ColumnValue(
    table.number,
    value,
  );

  _is.ColumnValue<String, String> label(String value) => _is.ColumnValue(
    table.label,
    value,
  );

  _is.ColumnValue<String, String> tokenHash(String? value) => _is.ColumnValue(
    table.tokenHash,
    value,
  );

  _is.ColumnValue<String, String> displayName(String value) => _is.ColumnValue(
    table.displayName,
    value,
  );

  _is.ColumnValue<_imwmdlft.TicketState, _imwmdlft.TicketState> state(
    _imwmdlft.TicketState value,
  ) => _is.ColumnValue(
    table.state,
    value,
  );

  _is.ColumnValue<int, int> priorityRank(int value) => _is.ColumnValue(
    table.priorityRank,
    value,
  );

  _is.ColumnValue<_ic48vmv6.PriorityReason, _ic48vmv6.PriorityReason>
  priorityReason(_ic48vmv6.PriorityReason? value) => _is.ColumnValue(
    table.priorityReason,
    value,
  );

  _is.ColumnValue<String, String> priorityNote(String? value) =>
      _is.ColumnValue(
        table.priorityNote,
        value,
      );

  _is.ColumnValue<double, double> sortKey(double value) => _is.ColumnValue(
    table.sortKey,
    value,
  );

  _is.ColumnValue<int, int> reslotCount(int value) => _is.ColumnValue(
    table.reslotCount,
    value,
  );

  _is.ColumnValue<int, int> callVersion(int value) => _is.ColumnValue(
    table.callVersion,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> roomId(_is.UuidValue? value) =>
      _is.ColumnValue(
        table.roomId,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> joinedAt(DateTime value) =>
      _is.ColumnValue(
        table.joinedAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> calledAt(DateTime? value) =>
      _is.ColumnValue(
        table.calledAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> confirmedAt(DateTime? value) =>
      _is.ColumnValue(
        table.confirmedAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> serviceStartedAt(DateTime? value) =>
      _is.ColumnValue(
        table.serviceStartedAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> finishedAt(DateTime? value) =>
      _is.ColumnValue(
        table.finishedAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> headsUpSentAt(DateTime? value) =>
      _is.ColumnValue(
        table.headsUpSentAt,
        value,
      );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> transferredFromTicketId(
    _is.UuidValue? value,
  ) => _is.ColumnValue(
    table.transferredFromTicketId,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> transferredToTicketId(
    _is.UuidValue? value,
  ) => _is.ColumnValue(
    table.transferredToTicketId,
    value,
  );

  _is.ColumnValue<String, String> closedReason(String? value) =>
      _is.ColumnValue(
        table.closedReason,
        value,
      );

  _is.ColumnValue<String, String> transferTokenCipher(String? value) =>
      _is.ColumnValue(
        table.transferTokenCipher,
        value,
      );

  _is.ColumnValue<bool, bool> isDemo(bool value) => _is.ColumnValue(
    table.isDemo,
    value,
  );
}

class TicketTable extends _is.Table<_is.UuidValue?> {
  TicketTable({super.tableRelation}) : super(tableName: 'ticket') {
    updateTable = TicketUpdateTable(this);
    clinicId = _is.ColumnUuid(
      'clinicId',
      this,
    );
    lineId = _is.ColumnUuid(
      'lineId',
      this,
    );
    serviceDate = _is.ColumnString(
      'serviceDate',
      this,
    );
    number = _is.ColumnInt(
      'number',
      this,
    );
    label = _is.ColumnString(
      'label',
      this,
    );
    tokenHash = _is.ColumnString(
      'tokenHash',
      this,
    );
    displayName = _is.ColumnString(
      'displayName',
      this,
    );
    state = _is.ColumnEnum(
      'state',
      this,
      _is.EnumSerialization.byName,
    );
    priorityRank = _is.ColumnInt(
      'priorityRank',
      this,
      hasDefault: true,
    );
    priorityReason = _is.ColumnEnum(
      'priorityReason',
      this,
      _is.EnumSerialization.byName,
    );
    priorityNote = _is.ColumnString(
      'priorityNote',
      this,
    );
    sortKey = _is.ColumnDouble(
      'sortKey',
      this,
    );
    reslotCount = _is.ColumnInt(
      'reslotCount',
      this,
      hasDefault: true,
    );
    callVersion = _is.ColumnInt(
      'callVersion',
      this,
      hasDefault: true,
    );
    roomId = _is.ColumnUuid(
      'roomId',
      this,
    );
    joinedAt = _is.ColumnDateTime(
      'joinedAt',
      this,
    );
    calledAt = _is.ColumnDateTime(
      'calledAt',
      this,
    );
    confirmedAt = _is.ColumnDateTime(
      'confirmedAt',
      this,
    );
    serviceStartedAt = _is.ColumnDateTime(
      'serviceStartedAt',
      this,
    );
    finishedAt = _is.ColumnDateTime(
      'finishedAt',
      this,
    );
    headsUpSentAt = _is.ColumnDateTime(
      'headsUpSentAt',
      this,
    );
    transferredFromTicketId = _is.ColumnUuid(
      'transferredFromTicketId',
      this,
    );
    transferredToTicketId = _is.ColumnUuid(
      'transferredToTicketId',
      this,
    );
    closedReason = _is.ColumnString(
      'closedReason',
      this,
    );
    transferTokenCipher = _is.ColumnString(
      'transferTokenCipher',
      this,
    );
    isDemo = _is.ColumnBool(
      'isDemo',
      this,
      hasDefault: true,
    );
  }

  late final TicketUpdateTable updateTable;

  late final _is.ColumnUuid clinicId;

  late final _is.ColumnUuid lineId;

  late final _is.ColumnString serviceDate;

  late final _is.ColumnInt number;

  late final _is.ColumnString label;

  late final _is.ColumnString tokenHash;

  late final _is.ColumnString displayName;

  late final _is.ColumnEnum<_imwmdlft.TicketState> state;

  late final _is.ColumnInt priorityRank;

  late final _is.ColumnEnum<_ic48vmv6.PriorityReason> priorityReason;

  late final _is.ColumnString priorityNote;

  late final _is.ColumnDouble sortKey;

  late final _is.ColumnInt reslotCount;

  late final _is.ColumnInt callVersion;

  late final _is.ColumnUuid roomId;

  late final _is.ColumnDateTime joinedAt;

  late final _is.ColumnDateTime calledAt;

  late final _is.ColumnDateTime confirmedAt;

  late final _is.ColumnDateTime serviceStartedAt;

  late final _is.ColumnDateTime finishedAt;

  late final _is.ColumnDateTime headsUpSentAt;

  late final _is.ColumnUuid transferredFromTicketId;

  late final _is.ColumnUuid transferredToTicketId;

  late final _is.ColumnString closedReason;

  late final _is.ColumnString transferTokenCipher;

  late final _is.ColumnBool isDemo;

  @override
  List<_is.Column> get columns => [
    id,
    clinicId,
    lineId,
    serviceDate,
    number,
    label,
    tokenHash,
    displayName,
    state,
    priorityRank,
    priorityReason,
    priorityNote,
    sortKey,
    reslotCount,
    callVersion,
    roomId,
    joinedAt,
    calledAt,
    confirmedAt,
    serviceStartedAt,
    finishedAt,
    headsUpSentAt,
    transferredFromTicketId,
    transferredToTicketId,
    closedReason,
    transferTokenCipher,
    isDemo,
  ];
}

class TicketInclude extends _is.IncludeObject {
  TicketInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => Ticket.t;
}

class TicketIncludeList extends _is.IncludeList {
  TicketIncludeList._({
    _is.WhereExpressionBuilder<TicketTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Ticket.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => Ticket.t;
}

class TicketRepository {
  const TicketRepository._();

  /// Returns a list of [Ticket]s matching the given query parameters.
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
  Future<List<Ticket>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<TicketTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<TicketTable>? orderBy,
    _is.OrderByListBuilder<TicketTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Ticket>(
      where: where?.call(Ticket.t),
      orderBy: orderBy?.call(Ticket.t),
      orderByList: orderByList?.call(Ticket.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Ticket] matching the given query parameters.
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
  Future<Ticket?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<TicketTable>? where,
    int? offset,
    _is.OrderByBuilder<TicketTable>? orderBy,
    _is.OrderByListBuilder<TicketTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Ticket>(
      where: where?.call(Ticket.t),
      orderBy: orderBy?.call(Ticket.t),
      orderByList: orderByList?.call(Ticket.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Ticket] by its [id] or null if no such row exists.
  Future<Ticket?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Ticket>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Ticket]s in the list and returns the inserted rows.
  ///
  /// The returned [Ticket]s will have their `id` fields set.
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
  Future<List<Ticket>> insert(
    _is.DatabaseSession session,
    List<Ticket> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<Ticket>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [Ticket] and returns the inserted row.
  ///
  /// The returned [Ticket] will have its `id` field set.
  Future<Ticket> insertRow(
    _is.DatabaseSession session,
    Ticket row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<Ticket>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [Ticket]s in the list and returns the resulting rows.
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
  /// The returned [Ticket]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Ticket>> upsert(
    _is.DatabaseSession session,
    List<Ticket> rows, {
    required _is.ColumnSelections<TicketTable> conflictColumns,
    _is.ColumnSelections<TicketTable>? updateColumns,
    _is.WhereExpressionBuilder<TicketTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<Ticket>(
      rows,
      conflictColumns: conflictColumns(Ticket.t),
      updateColumns: updateColumns?.call(Ticket.t),
      updateWhere: updateWhere?.call(Ticket.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [Ticket] and returns the resulting row.
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
  /// The returned [Ticket] will have its `id` field set.
  Future<Ticket?> upsertRow(
    _is.DatabaseSession session,
    Ticket row, {
    required _is.ColumnSelections<TicketTable> conflictColumns,
    _is.ColumnSelections<TicketTable>? updateColumns,
    _is.WhereExpressionBuilder<TicketTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<Ticket>(
      row,
      conflictColumns: conflictColumns(Ticket.t),
      updateColumns: updateColumns?.call(Ticket.t),
      updateWhere: updateWhere?.call(Ticket.t),
      transaction: transaction,
    );
  }

  /// Updates all [Ticket]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Ticket>> update(
    _is.DatabaseSession session,
    List<Ticket> rows, {
    _is.ColumnSelections<TicketTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<Ticket>(
      rows,
      columns: columns?.call(Ticket.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [Ticket]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Ticket> updateRow(
    _is.DatabaseSession session,
    Ticket row, {
    _is.ColumnSelections<TicketTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<Ticket>(
      row,
      columns: columns?.call(Ticket.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Ticket] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Ticket?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<TicketUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<Ticket>(
      id,
      columnValues: columnValues(Ticket.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Ticket]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Ticket>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<TicketUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<TicketTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<TicketTable>? orderBy,
    _is.OrderByListBuilder<TicketTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<Ticket>(
      columnValues: columnValues(Ticket.t.updateTable),
      where: where(Ticket.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Ticket.t),
      orderByList: orderByList?.call(Ticket.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [Ticket]s in the list and returns the deleted rows.
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
  Future<List<Ticket>> delete(
    _is.DatabaseSession session,
    List<Ticket> rows, {
    _is.OrderByBuilder<TicketTable>? orderBy,
    _is.OrderByListBuilder<TicketTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<Ticket>(
      rows,
      orderBy: orderBy?.call(Ticket.t),
      orderByList: orderByList?.call(Ticket.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [Ticket].
  Future<Ticket> deleteRow(
    _is.DatabaseSession session,
    Ticket row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Ticket>(
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
  Future<List<Ticket>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<TicketTable> where,
    _is.OrderByBuilder<TicketTable>? orderBy,
    _is.OrderByListBuilder<TicketTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<Ticket>(
      where: where(Ticket.t),
      orderBy: orderBy?.call(Ticket.t),
      orderByList: orderByList?.call(Ticket.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<TicketTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<Ticket>(
      where: where?.call(Ticket.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Ticket] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<TicketTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Ticket>(
      where: where(Ticket.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
