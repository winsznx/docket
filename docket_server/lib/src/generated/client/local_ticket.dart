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

abstract class LocalTicket
    implements _is.SerializableModel, _is.ProtocolSerialization {
  LocalTicket._({
    _is.UuidValue? id,
    required this.lineId,
    required this.label,
    required this.displayName,
    required this.state,
    required this.priorityRank,
    this.priorityReason,
    required this.sortKey,
    this.roomId,
    this.calledAt,
    int? callVersion,
    int? reslotCount,
    required this.isDemo,
    bool? pendingSync,
    required this.updatedAt,
  }) : id = id ?? const _is.Uuid().v7obj(),
       callVersion = callVersion ?? 0,
       reslotCount = reslotCount ?? 0,
       pendingSync = pendingSync ?? false;

  factory LocalTicket({
    _is.UuidValue? id,
    required _is.UuidValue lineId,
    required String label,
    required String displayName,
    required _imwmdlft.TicketState state,
    required int priorityRank,
    _ic48vmv6.PriorityReason? priorityReason,
    required double sortKey,
    _is.UuidValue? roomId,
    DateTime? calledAt,
    int? callVersion,
    int? reslotCount,
    required bool isDemo,
    bool? pendingSync,
    required DateTime updatedAt,
  }) = _LocalTicketImpl;

  factory LocalTicket.fromJson(Map<String, dynamic> jsonSerialization) {
    return LocalTicket(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      lineId: _is.UuidValueJsonExtension.fromJson(jsonSerialization['lineId']),
      label: jsonSerialization['label'] as String,
      displayName: jsonSerialization['displayName'] as String,
      state: _imwmdlft.TicketState.fromJson(
        (jsonSerialization['state'] as String),
      ),
      priorityRank: jsonSerialization['priorityRank'] as int,
      priorityReason: jsonSerialization['priorityReason'] == null
          ? null
          : _ic48vmv6.PriorityReason.fromJson(
              (jsonSerialization['priorityReason'] as String),
            ),
      sortKey: (jsonSerialization['sortKey'] as num).toDouble(),
      roomId: jsonSerialization['roomId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['roomId']),
      calledAt: jsonSerialization['calledAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['calledAt']),
      callVersion: jsonSerialization['callVersion'] as int?,
      reslotCount: jsonSerialization['reslotCount'] as int?,
      isDemo: _is.BoolJsonExtension.fromJson(jsonSerialization['isDemo']),
      pendingSync: jsonSerialization['pendingSync'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['pendingSync']),
      updatedAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  /// The id of the object.
  _is.UuidValue? id;

  _is.UuidValue lineId;

  String label;

  String displayName;

  _imwmdlft.TicketState state;

  int priorityRank;

  _ic48vmv6.PriorityReason? priorityReason;

  double sortKey;

  _is.UuidValue? roomId;

  DateTime? calledAt;

  int callVersion;

  int reslotCount;

  bool isDemo;

  bool pendingSync;

  DateTime updatedAt;

  /// Returns a shallow copy of this [LocalTicket]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  LocalTicket copyWith({
    _is.UuidValue? id,
    _is.UuidValue? lineId,
    String? label,
    String? displayName,
    _imwmdlft.TicketState? state,
    int? priorityRank,
    _ic48vmv6.PriorityReason? priorityReason,
    double? sortKey,
    _is.UuidValue? roomId,
    DateTime? calledAt,
    int? callVersion,
    int? reslotCount,
    bool? isDemo,
    bool? pendingSync,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'LocalTicket',
      if (id != null) 'id': id?.toJson(),
      'lineId': lineId.toJson(),
      'label': label,
      'displayName': displayName,
      'state': state.toJson(),
      'priorityRank': priorityRank,
      if (priorityReason != null) 'priorityReason': priorityReason?.toJson(),
      'sortKey': sortKey,
      if (roomId != null) 'roomId': roomId?.toJson(),
      if (calledAt != null) 'calledAt': calledAt?.toJson(),
      'callVersion': callVersion,
      'reslotCount': reslotCount,
      'isDemo': isDemo,
      'pendingSync': pendingSync,
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'LocalTicket',
      if (id != null) 'id': id?.toJson(),
      'lineId': lineId.toJson(),
      'label': label,
      'displayName': displayName,
      'state': state.toJson(),
      'priorityRank': priorityRank,
      if (priorityReason != null) 'priorityReason': priorityReason?.toJson(),
      'sortKey': sortKey,
      if (roomId != null) 'roomId': roomId?.toJson(),
      if (calledAt != null) 'calledAt': calledAt?.toJson(),
      'callVersion': callVersion,
      'reslotCount': reslotCount,
      'isDemo': isDemo,
      'pendingSync': pendingSync,
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _LocalTicketImpl extends LocalTicket {
  _LocalTicketImpl({
    _is.UuidValue? id,
    required _is.UuidValue lineId,
    required String label,
    required String displayName,
    required _imwmdlft.TicketState state,
    required int priorityRank,
    _ic48vmv6.PriorityReason? priorityReason,
    required double sortKey,
    _is.UuidValue? roomId,
    DateTime? calledAt,
    int? callVersion,
    int? reslotCount,
    required bool isDemo,
    bool? pendingSync,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         lineId: lineId,
         label: label,
         displayName: displayName,
         state: state,
         priorityRank: priorityRank,
         priorityReason: priorityReason,
         sortKey: sortKey,
         roomId: roomId,
         calledAt: calledAt,
         callVersion: callVersion,
         reslotCount: reslotCount,
         isDemo: isDemo,
         pendingSync: pendingSync,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [LocalTicket]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  LocalTicket copyWith({
    Object? id = _Undefined,
    _is.UuidValue? lineId,
    String? label,
    String? displayName,
    _imwmdlft.TicketState? state,
    int? priorityRank,
    Object? priorityReason = _Undefined,
    double? sortKey,
    Object? roomId = _Undefined,
    Object? calledAt = _Undefined,
    int? callVersion,
    int? reslotCount,
    bool? isDemo,
    bool? pendingSync,
    DateTime? updatedAt,
  }) {
    return LocalTicket(
      id: id is _is.UuidValue? ? id : this.id,
      lineId: lineId ?? this.lineId,
      label: label ?? this.label,
      displayName: displayName ?? this.displayName,
      state: state ?? this.state,
      priorityRank: priorityRank ?? this.priorityRank,
      priorityReason: priorityReason is _ic48vmv6.PriorityReason?
          ? priorityReason
          : this.priorityReason,
      sortKey: sortKey ?? this.sortKey,
      roomId: roomId is _is.UuidValue? ? roomId : this.roomId,
      calledAt: calledAt is DateTime? ? calledAt : this.calledAt,
      callVersion: callVersion ?? this.callVersion,
      reslotCount: reslotCount ?? this.reslotCount,
      isDemo: isDemo ?? this.isDemo,
      pendingSync: pendingSync ?? this.pendingSync,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
