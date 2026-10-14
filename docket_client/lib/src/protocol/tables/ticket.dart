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
import '../enums/priority_reason.dart' as _ic48vmv6;
import '../enums/ticket_state.dart' as _imwmdlft;

abstract class Ticket
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Ticket._({
    this.id,
    required this.clinicId,
    required this.lineId,
    required this.serviceDate,
    required this.number,
    required this.label,
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
    bool? isDemo,
  }) : priorityRank = priorityRank ?? 1,
       reslotCount = reslotCount ?? 0,
       callVersion = callVersion ?? 0,
       isDemo = isDemo ?? false;

  factory Ticket({
    _isc.UuidValue? id,
    required _isc.UuidValue clinicId,
    required _isc.UuidValue lineId,
    required String serviceDate,
    required int number,
    required String label,
    required String displayName,
    required _imwmdlft.TicketState state,
    int? priorityRank,
    _ic48vmv6.PriorityReason? priorityReason,
    String? priorityNote,
    required double sortKey,
    int? reslotCount,
    int? callVersion,
    _isc.UuidValue? roomId,
    required DateTime joinedAt,
    DateTime? calledAt,
    DateTime? confirmedAt,
    DateTime? serviceStartedAt,
    DateTime? finishedAt,
    DateTime? headsUpSentAt,
    _isc.UuidValue? transferredFromTicketId,
    _isc.UuidValue? transferredToTicketId,
    String? closedReason,
    bool? isDemo,
  }) = _TicketImpl;

  factory Ticket.fromJson(Map<String, dynamic> jsonSerialization) {
    return Ticket(
      id: jsonSerialization['id'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      clinicId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['clinicId'],
      ),
      lineId: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['lineId']),
      serviceDate: jsonSerialization['serviceDate'] as String,
      number: jsonSerialization['number'] as int,
      label: jsonSerialization['label'] as String,
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
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['roomId']),
      joinedAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['joinedAt'],
      ),
      calledAt: jsonSerialization['calledAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['calledAt']),
      confirmedAt: jsonSerialization['confirmedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['confirmedAt'],
            ),
      serviceStartedAt: jsonSerialization['serviceStartedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['serviceStartedAt'],
            ),
      finishedAt: jsonSerialization['finishedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['finishedAt'],
            ),
      headsUpSentAt: jsonSerialization['headsUpSentAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['headsUpSentAt'],
            ),
      transferredFromTicketId:
          jsonSerialization['transferredFromTicketId'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(
              jsonSerialization['transferredFromTicketId'],
            ),
      transferredToTicketId: jsonSerialization['transferredToTicketId'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(
              jsonSerialization['transferredToTicketId'],
            ),
      closedReason: jsonSerialization['closedReason'] as String?,
      isDemo: jsonSerialization['isDemo'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['isDemo']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _isc.UuidValue? id;

  _isc.UuidValue clinicId;

  _isc.UuidValue lineId;

  String serviceDate;

  int number;

  String label;

  String displayName;

  _imwmdlft.TicketState state;

  int priorityRank;

  _ic48vmv6.PriorityReason? priorityReason;

  String? priorityNote;

  double sortKey;

  int reslotCount;

  int callVersion;

  _isc.UuidValue? roomId;

  DateTime joinedAt;

  DateTime? calledAt;

  DateTime? confirmedAt;

  DateTime? serviceStartedAt;

  DateTime? finishedAt;

  DateTime? headsUpSentAt;

  _isc.UuidValue? transferredFromTicketId;

  _isc.UuidValue? transferredToTicketId;

  String? closedReason;

  bool isDemo;

  /// Returns a shallow copy of this [Ticket]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Ticket copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? clinicId,
    _isc.UuidValue? lineId,
    String? serviceDate,
    int? number,
    String? label,
    String? displayName,
    _imwmdlft.TicketState? state,
    int? priorityRank,
    _ic48vmv6.PriorityReason? priorityReason,
    String? priorityNote,
    double? sortKey,
    int? reslotCount,
    int? callVersion,
    _isc.UuidValue? roomId,
    DateTime? joinedAt,
    DateTime? calledAt,
    DateTime? confirmedAt,
    DateTime? serviceStartedAt,
    DateTime? finishedAt,
    DateTime? headsUpSentAt,
    _isc.UuidValue? transferredFromTicketId,
    _isc.UuidValue? transferredToTicketId,
    String? closedReason,
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

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TicketImpl extends Ticket {
  _TicketImpl({
    _isc.UuidValue? id,
    required _isc.UuidValue clinicId,
    required _isc.UuidValue lineId,
    required String serviceDate,
    required int number,
    required String label,
    required String displayName,
    required _imwmdlft.TicketState state,
    int? priorityRank,
    _ic48vmv6.PriorityReason? priorityReason,
    String? priorityNote,
    required double sortKey,
    int? reslotCount,
    int? callVersion,
    _isc.UuidValue? roomId,
    required DateTime joinedAt,
    DateTime? calledAt,
    DateTime? confirmedAt,
    DateTime? serviceStartedAt,
    DateTime? finishedAt,
    DateTime? headsUpSentAt,
    _isc.UuidValue? transferredFromTicketId,
    _isc.UuidValue? transferredToTicketId,
    String? closedReason,
    bool? isDemo,
  }) : super._(
         id: id,
         clinicId: clinicId,
         lineId: lineId,
         serviceDate: serviceDate,
         number: number,
         label: label,
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
         isDemo: isDemo,
       );

  /// Returns a shallow copy of this [Ticket]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Ticket copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? clinicId,
    _isc.UuidValue? lineId,
    String? serviceDate,
    int? number,
    String? label,
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
    bool? isDemo,
  }) {
    return Ticket(
      id: id is _isc.UuidValue? ? id : this.id,
      clinicId: clinicId ?? this.clinicId,
      lineId: lineId ?? this.lineId,
      serviceDate: serviceDate ?? this.serviceDate,
      number: number ?? this.number,
      label: label ?? this.label,
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
      roomId: roomId is _isc.UuidValue? ? roomId : this.roomId,
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
      transferredFromTicketId: transferredFromTicketId is _isc.UuidValue?
          ? transferredFromTicketId
          : this.transferredFromTicketId,
      transferredToTicketId: transferredToTicketId is _isc.UuidValue?
          ? transferredToTicketId
          : this.transferredToTicketId,
      closedReason: closedReason is String? ? closedReason : this.closedReason,
      isDemo: isDemo ?? this.isDemo,
    );
  }
}
