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
import '../enums/delivery_status.dart' as _ik1evhid;
import '../enums/priority_reason.dart' as _ic48vmv6;
import '../enums/ticket_state.dart' as _imwmdlft;

abstract class TicketView
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  TicketView._({
    required this.id,
    required this.lineId,
    required this.label,
    required this.displayName,
    required this.state,
    required this.priorityRank,
    this.priorityReason,
    this.priorityNote,
    required this.sortKey,
    this.roomId,
    this.calledAt,
    this.graceEndsAt,
    this.arrivalEndsAt,
    required this.callVersion,
    required this.reslotCount,
    required this.isDemo,
    required this.hasPush,
    required this.hasSms,
    this.pushStatus,
    this.smsStatus,
  });

  factory TicketView({
    required _isc.UuidValue id,
    required _isc.UuidValue lineId,
    required String label,
    required String displayName,
    required _imwmdlft.TicketState state,
    required int priorityRank,
    _ic48vmv6.PriorityReason? priorityReason,
    String? priorityNote,
    required double sortKey,
    _isc.UuidValue? roomId,
    DateTime? calledAt,
    DateTime? graceEndsAt,
    DateTime? arrivalEndsAt,
    required int callVersion,
    required int reslotCount,
    required bool isDemo,
    required bool hasPush,
    required bool hasSms,
    _ik1evhid.DeliveryStatus? pushStatus,
    _ik1evhid.DeliveryStatus? smsStatus,
  }) = _TicketViewImpl;

  factory TicketView.fromJson(Map<String, dynamic> jsonSerialization) {
    return TicketView(
      id: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      lineId: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['lineId']),
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
      priorityNote: jsonSerialization['priorityNote'] as String?,
      sortKey: (jsonSerialization['sortKey'] as num).toDouble(),
      roomId: jsonSerialization['roomId'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['roomId']),
      calledAt: jsonSerialization['calledAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['calledAt']),
      graceEndsAt: jsonSerialization['graceEndsAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['graceEndsAt'],
            ),
      arrivalEndsAt: jsonSerialization['arrivalEndsAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['arrivalEndsAt'],
            ),
      callVersion: jsonSerialization['callVersion'] as int,
      reslotCount: jsonSerialization['reslotCount'] as int,
      isDemo: _isc.BoolJsonExtension.fromJson(jsonSerialization['isDemo']),
      hasPush: _isc.BoolJsonExtension.fromJson(jsonSerialization['hasPush']),
      hasSms: _isc.BoolJsonExtension.fromJson(jsonSerialization['hasSms']),
      pushStatus: jsonSerialization['pushStatus'] == null
          ? null
          : _ik1evhid.DeliveryStatus.fromJson(
              (jsonSerialization['pushStatus'] as String),
            ),
      smsStatus: jsonSerialization['smsStatus'] == null
          ? null
          : _ik1evhid.DeliveryStatus.fromJson(
              (jsonSerialization['smsStatus'] as String),
            ),
    );
  }

  _isc.UuidValue id;

  _isc.UuidValue lineId;

  String label;

  String displayName;

  _imwmdlft.TicketState state;

  int priorityRank;

  _ic48vmv6.PriorityReason? priorityReason;

  String? priorityNote;

  double sortKey;

  _isc.UuidValue? roomId;

  DateTime? calledAt;

  DateTime? graceEndsAt;

  DateTime? arrivalEndsAt;

  int callVersion;

  int reslotCount;

  bool isDemo;

  bool hasPush;

  bool hasSms;

  _ik1evhid.DeliveryStatus? pushStatus;

  _ik1evhid.DeliveryStatus? smsStatus;

  /// Returns a shallow copy of this [TicketView]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  TicketView copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? lineId,
    String? label,
    String? displayName,
    _imwmdlft.TicketState? state,
    int? priorityRank,
    _ic48vmv6.PriorityReason? priorityReason,
    String? priorityNote,
    double? sortKey,
    _isc.UuidValue? roomId,
    DateTime? calledAt,
    DateTime? graceEndsAt,
    DateTime? arrivalEndsAt,
    int? callVersion,
    int? reslotCount,
    bool? isDemo,
    bool? hasPush,
    bool? hasSms,
    _ik1evhid.DeliveryStatus? pushStatus,
    _ik1evhid.DeliveryStatus? smsStatus,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TicketView',
      'id': id.toJson(),
      'lineId': lineId.toJson(),
      'label': label,
      'displayName': displayName,
      'state': state.toJson(),
      'priorityRank': priorityRank,
      if (priorityReason != null) 'priorityReason': priorityReason?.toJson(),
      if (priorityNote != null) 'priorityNote': priorityNote,
      'sortKey': sortKey,
      if (roomId != null) 'roomId': roomId?.toJson(),
      if (calledAt != null) 'calledAt': calledAt?.toJson(),
      if (graceEndsAt != null) 'graceEndsAt': graceEndsAt?.toJson(),
      if (arrivalEndsAt != null) 'arrivalEndsAt': arrivalEndsAt?.toJson(),
      'callVersion': callVersion,
      'reslotCount': reslotCount,
      'isDemo': isDemo,
      'hasPush': hasPush,
      'hasSms': hasSms,
      if (pushStatus != null) 'pushStatus': pushStatus?.toJson(),
      if (smsStatus != null) 'smsStatus': smsStatus?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'TicketView',
      'id': id.toJson(),
      'lineId': lineId.toJson(),
      'label': label,
      'displayName': displayName,
      'state': state.toJson(),
      'priorityRank': priorityRank,
      if (priorityReason != null) 'priorityReason': priorityReason?.toJson(),
      if (priorityNote != null) 'priorityNote': priorityNote,
      'sortKey': sortKey,
      if (roomId != null) 'roomId': roomId?.toJson(),
      if (calledAt != null) 'calledAt': calledAt?.toJson(),
      if (graceEndsAt != null) 'graceEndsAt': graceEndsAt?.toJson(),
      if (arrivalEndsAt != null) 'arrivalEndsAt': arrivalEndsAt?.toJson(),
      'callVersion': callVersion,
      'reslotCount': reslotCount,
      'isDemo': isDemo,
      'hasPush': hasPush,
      'hasSms': hasSms,
      if (pushStatus != null) 'pushStatus': pushStatus?.toJson(),
      if (smsStatus != null) 'smsStatus': smsStatus?.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TicketViewImpl extends TicketView {
  _TicketViewImpl({
    required _isc.UuidValue id,
    required _isc.UuidValue lineId,
    required String label,
    required String displayName,
    required _imwmdlft.TicketState state,
    required int priorityRank,
    _ic48vmv6.PriorityReason? priorityReason,
    String? priorityNote,
    required double sortKey,
    _isc.UuidValue? roomId,
    DateTime? calledAt,
    DateTime? graceEndsAt,
    DateTime? arrivalEndsAt,
    required int callVersion,
    required int reslotCount,
    required bool isDemo,
    required bool hasPush,
    required bool hasSms,
    _ik1evhid.DeliveryStatus? pushStatus,
    _ik1evhid.DeliveryStatus? smsStatus,
  }) : super._(
         id: id,
         lineId: lineId,
         label: label,
         displayName: displayName,
         state: state,
         priorityRank: priorityRank,
         priorityReason: priorityReason,
         priorityNote: priorityNote,
         sortKey: sortKey,
         roomId: roomId,
         calledAt: calledAt,
         graceEndsAt: graceEndsAt,
         arrivalEndsAt: arrivalEndsAt,
         callVersion: callVersion,
         reslotCount: reslotCount,
         isDemo: isDemo,
         hasPush: hasPush,
         hasSms: hasSms,
         pushStatus: pushStatus,
         smsStatus: smsStatus,
       );

  /// Returns a shallow copy of this [TicketView]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  TicketView copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? lineId,
    String? label,
    String? displayName,
    _imwmdlft.TicketState? state,
    int? priorityRank,
    Object? priorityReason = _Undefined,
    Object? priorityNote = _Undefined,
    double? sortKey,
    Object? roomId = _Undefined,
    Object? calledAt = _Undefined,
    Object? graceEndsAt = _Undefined,
    Object? arrivalEndsAt = _Undefined,
    int? callVersion,
    int? reslotCount,
    bool? isDemo,
    bool? hasPush,
    bool? hasSms,
    Object? pushStatus = _Undefined,
    Object? smsStatus = _Undefined,
  }) {
    return TicketView(
      id: id ?? this.id,
      lineId: lineId ?? this.lineId,
      label: label ?? this.label,
      displayName: displayName ?? this.displayName,
      state: state ?? this.state,
      priorityRank: priorityRank ?? this.priorityRank,
      priorityReason: priorityReason is _ic48vmv6.PriorityReason?
          ? priorityReason
          : this.priorityReason,
      priorityNote: priorityNote is String? ? priorityNote : this.priorityNote,
      sortKey: sortKey ?? this.sortKey,
      roomId: roomId is _isc.UuidValue? ? roomId : this.roomId,
      calledAt: calledAt is DateTime? ? calledAt : this.calledAt,
      graceEndsAt: graceEndsAt is DateTime? ? graceEndsAt : this.graceEndsAt,
      arrivalEndsAt: arrivalEndsAt is DateTime?
          ? arrivalEndsAt
          : this.arrivalEndsAt,
      callVersion: callVersion ?? this.callVersion,
      reslotCount: reslotCount ?? this.reslotCount,
      isDemo: isDemo ?? this.isDemo,
      hasPush: hasPush ?? this.hasPush,
      hasSms: hasSms ?? this.hasSms,
      pushStatus: pushStatus is _ik1evhid.DeliveryStatus?
          ? pushStatus
          : this.pushStatus,
      smsStatus: smsStatus is _ik1evhid.DeliveryStatus?
          ? smsStatus
          : this.smsStatus,
    );
  }
}
