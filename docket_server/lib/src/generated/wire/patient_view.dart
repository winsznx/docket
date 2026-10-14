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
import '../enums/ticket_state.dart' as _imwmdlft;

abstract class PatientView
    implements _is.SerializableModel, _is.ProtocolSerialization {
  PatientView._({
    required this.ticketId,
    required this.clinicName,
    required this.label,
    required this.lineName,
    required this.state,
    this.position,
    this.etaMinutes,
    this.etaText,
    required this.etaIsEstimate,
    this.roomName,
    this.nowServingLabel,
    this.nextAfterLabel,
    this.graceEndsAt,
    this.arrivalEndsAt,
    required this.graceSeconds,
    required this.reslotCount,
    required this.maxReslots,
    required this.headsUpSent,
    this.lineMovedAt,
    required this.deskOnline,
    this.transferredToToken,
    this.transferredToLabel,
    this.transferredToLineName,
    this.closedReason,
    required this.pushActive,
    required this.smsActive,
    required this.smsEnabled,
    this.smsLast4,
    required this.isDemo,
    required this.serverTime,
    required this.version,
  });

  factory PatientView({
    required _is.UuidValue ticketId,
    required String clinicName,
    required String label,
    required String lineName,
    required _imwmdlft.TicketState state,
    int? position,
    int? etaMinutes,
    String? etaText,
    required bool etaIsEstimate,
    String? roomName,
    String? nowServingLabel,
    String? nextAfterLabel,
    DateTime? graceEndsAt,
    DateTime? arrivalEndsAt,
    required int graceSeconds,
    required int reslotCount,
    required int maxReslots,
    required bool headsUpSent,
    DateTime? lineMovedAt,
    required bool deskOnline,
    String? transferredToToken,
    String? transferredToLabel,
    String? transferredToLineName,
    String? closedReason,
    required bool pushActive,
    required bool smsActive,
    required bool smsEnabled,
    String? smsLast4,
    required bool isDemo,
    required DateTime serverTime,
    required int version,
  }) = _PatientViewImpl;

  factory PatientView.fromJson(Map<String, dynamic> jsonSerialization) {
    return PatientView(
      ticketId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['ticketId'],
      ),
      clinicName: jsonSerialization['clinicName'] as String,
      label: jsonSerialization['label'] as String,
      lineName: jsonSerialization['lineName'] as String,
      state: _imwmdlft.TicketState.fromJson(
        (jsonSerialization['state'] as String),
      ),
      position: jsonSerialization['position'] as int?,
      etaMinutes: jsonSerialization['etaMinutes'] as int?,
      etaText: jsonSerialization['etaText'] as String?,
      etaIsEstimate: _is.BoolJsonExtension.fromJson(
        jsonSerialization['etaIsEstimate'],
      ),
      roomName: jsonSerialization['roomName'] as String?,
      nowServingLabel: jsonSerialization['nowServingLabel'] as String?,
      nextAfterLabel: jsonSerialization['nextAfterLabel'] as String?,
      graceEndsAt: jsonSerialization['graceEndsAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['graceEndsAt'],
            ),
      arrivalEndsAt: jsonSerialization['arrivalEndsAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['arrivalEndsAt'],
            ),
      graceSeconds: jsonSerialization['graceSeconds'] as int,
      reslotCount: jsonSerialization['reslotCount'] as int,
      maxReslots: jsonSerialization['maxReslots'] as int,
      headsUpSent: _is.BoolJsonExtension.fromJson(
        jsonSerialization['headsUpSent'],
      ),
      lineMovedAt: jsonSerialization['lineMovedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['lineMovedAt'],
            ),
      deskOnline: _is.BoolJsonExtension.fromJson(
        jsonSerialization['deskOnline'],
      ),
      transferredToToken: jsonSerialization['transferredToToken'] as String?,
      transferredToLabel: jsonSerialization['transferredToLabel'] as String?,
      transferredToLineName:
          jsonSerialization['transferredToLineName'] as String?,
      closedReason: jsonSerialization['closedReason'] as String?,
      pushActive: _is.BoolJsonExtension.fromJson(
        jsonSerialization['pushActive'],
      ),
      smsActive: _is.BoolJsonExtension.fromJson(jsonSerialization['smsActive']),
      smsEnabled: _is.BoolJsonExtension.fromJson(
        jsonSerialization['smsEnabled'],
      ),
      smsLast4: jsonSerialization['smsLast4'] as String?,
      isDemo: _is.BoolJsonExtension.fromJson(jsonSerialization['isDemo']),
      serverTime: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['serverTime'],
      ),
      version: jsonSerialization['version'] as int,
    );
  }

  _is.UuidValue ticketId;

  String clinicName;

  String label;

  String lineName;

  _imwmdlft.TicketState state;

  int? position;

  int? etaMinutes;

  String? etaText;

  bool etaIsEstimate;

  String? roomName;

  String? nowServingLabel;

  String? nextAfterLabel;

  DateTime? graceEndsAt;

  DateTime? arrivalEndsAt;

  int graceSeconds;

  int reslotCount;

  int maxReslots;

  bool headsUpSent;

  DateTime? lineMovedAt;

  bool deskOnline;

  String? transferredToToken;

  String? transferredToLabel;

  String? transferredToLineName;

  String? closedReason;

  bool pushActive;

  bool smsActive;

  bool smsEnabled;

  String? smsLast4;

  bool isDemo;

  DateTime serverTime;

  int version;

  /// Returns a shallow copy of this [PatientView]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  PatientView copyWith({
    _is.UuidValue? ticketId,
    String? clinicName,
    String? label,
    String? lineName,
    _imwmdlft.TicketState? state,
    int? position,
    int? etaMinutes,
    String? etaText,
    bool? etaIsEstimate,
    String? roomName,
    String? nowServingLabel,
    String? nextAfterLabel,
    DateTime? graceEndsAt,
    DateTime? arrivalEndsAt,
    int? graceSeconds,
    int? reslotCount,
    int? maxReslots,
    bool? headsUpSent,
    DateTime? lineMovedAt,
    bool? deskOnline,
    String? transferredToToken,
    String? transferredToLabel,
    String? transferredToLineName,
    String? closedReason,
    bool? pushActive,
    bool? smsActive,
    bool? smsEnabled,
    String? smsLast4,
    bool? isDemo,
    DateTime? serverTime,
    int? version,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PatientView',
      'ticketId': ticketId.toJson(),
      'clinicName': clinicName,
      'label': label,
      'lineName': lineName,
      'state': state.toJson(),
      if (position != null) 'position': position,
      if (etaMinutes != null) 'etaMinutes': etaMinutes,
      if (etaText != null) 'etaText': etaText,
      'etaIsEstimate': etaIsEstimate,
      if (roomName != null) 'roomName': roomName,
      if (nowServingLabel != null) 'nowServingLabel': nowServingLabel,
      if (nextAfterLabel != null) 'nextAfterLabel': nextAfterLabel,
      if (graceEndsAt != null) 'graceEndsAt': graceEndsAt?.toJson(),
      if (arrivalEndsAt != null) 'arrivalEndsAt': arrivalEndsAt?.toJson(),
      'graceSeconds': graceSeconds,
      'reslotCount': reslotCount,
      'maxReslots': maxReslots,
      'headsUpSent': headsUpSent,
      if (lineMovedAt != null) 'lineMovedAt': lineMovedAt?.toJson(),
      'deskOnline': deskOnline,
      if (transferredToToken != null) 'transferredToToken': transferredToToken,
      if (transferredToLabel != null) 'transferredToLabel': transferredToLabel,
      if (transferredToLineName != null)
        'transferredToLineName': transferredToLineName,
      if (closedReason != null) 'closedReason': closedReason,
      'pushActive': pushActive,
      'smsActive': smsActive,
      'smsEnabled': smsEnabled,
      if (smsLast4 != null) 'smsLast4': smsLast4,
      'isDemo': isDemo,
      'serverTime': serverTime.toJson(),
      'version': version,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PatientView',
      'ticketId': ticketId.toJson(),
      'clinicName': clinicName,
      'label': label,
      'lineName': lineName,
      'state': state.toJson(),
      if (position != null) 'position': position,
      if (etaMinutes != null) 'etaMinutes': etaMinutes,
      if (etaText != null) 'etaText': etaText,
      'etaIsEstimate': etaIsEstimate,
      if (roomName != null) 'roomName': roomName,
      if (nowServingLabel != null) 'nowServingLabel': nowServingLabel,
      if (nextAfterLabel != null) 'nextAfterLabel': nextAfterLabel,
      if (graceEndsAt != null) 'graceEndsAt': graceEndsAt?.toJson(),
      if (arrivalEndsAt != null) 'arrivalEndsAt': arrivalEndsAt?.toJson(),
      'graceSeconds': graceSeconds,
      'reslotCount': reslotCount,
      'maxReslots': maxReslots,
      'headsUpSent': headsUpSent,
      if (lineMovedAt != null) 'lineMovedAt': lineMovedAt?.toJson(),
      'deskOnline': deskOnline,
      if (transferredToToken != null) 'transferredToToken': transferredToToken,
      if (transferredToLabel != null) 'transferredToLabel': transferredToLabel,
      if (transferredToLineName != null)
        'transferredToLineName': transferredToLineName,
      if (closedReason != null) 'closedReason': closedReason,
      'pushActive': pushActive,
      'smsActive': smsActive,
      'smsEnabled': smsEnabled,
      if (smsLast4 != null) 'smsLast4': smsLast4,
      'isDemo': isDemo,
      'serverTime': serverTime.toJson(),
      'version': version,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PatientViewImpl extends PatientView {
  _PatientViewImpl({
    required _is.UuidValue ticketId,
    required String clinicName,
    required String label,
    required String lineName,
    required _imwmdlft.TicketState state,
    int? position,
    int? etaMinutes,
    String? etaText,
    required bool etaIsEstimate,
    String? roomName,
    String? nowServingLabel,
    String? nextAfterLabel,
    DateTime? graceEndsAt,
    DateTime? arrivalEndsAt,
    required int graceSeconds,
    required int reslotCount,
    required int maxReslots,
    required bool headsUpSent,
    DateTime? lineMovedAt,
    required bool deskOnline,
    String? transferredToToken,
    String? transferredToLabel,
    String? transferredToLineName,
    String? closedReason,
    required bool pushActive,
    required bool smsActive,
    required bool smsEnabled,
    String? smsLast4,
    required bool isDemo,
    required DateTime serverTime,
    required int version,
  }) : super._(
         ticketId: ticketId,
         clinicName: clinicName,
         label: label,
         lineName: lineName,
         state: state,
         position: position,
         etaMinutes: etaMinutes,
         etaText: etaText,
         etaIsEstimate: etaIsEstimate,
         roomName: roomName,
         nowServingLabel: nowServingLabel,
         nextAfterLabel: nextAfterLabel,
         graceEndsAt: graceEndsAt,
         arrivalEndsAt: arrivalEndsAt,
         graceSeconds: graceSeconds,
         reslotCount: reslotCount,
         maxReslots: maxReslots,
         headsUpSent: headsUpSent,
         lineMovedAt: lineMovedAt,
         deskOnline: deskOnline,
         transferredToToken: transferredToToken,
         transferredToLabel: transferredToLabel,
         transferredToLineName: transferredToLineName,
         closedReason: closedReason,
         pushActive: pushActive,
         smsActive: smsActive,
         smsEnabled: smsEnabled,
         smsLast4: smsLast4,
         isDemo: isDemo,
         serverTime: serverTime,
         version: version,
       );

  /// Returns a shallow copy of this [PatientView]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  PatientView copyWith({
    _is.UuidValue? ticketId,
    String? clinicName,
    String? label,
    String? lineName,
    _imwmdlft.TicketState? state,
    Object? position = _Undefined,
    Object? etaMinutes = _Undefined,
    Object? etaText = _Undefined,
    bool? etaIsEstimate,
    Object? roomName = _Undefined,
    Object? nowServingLabel = _Undefined,
    Object? nextAfterLabel = _Undefined,
    Object? graceEndsAt = _Undefined,
    Object? arrivalEndsAt = _Undefined,
    int? graceSeconds,
    int? reslotCount,
    int? maxReslots,
    bool? headsUpSent,
    Object? lineMovedAt = _Undefined,
    bool? deskOnline,
    Object? transferredToToken = _Undefined,
    Object? transferredToLabel = _Undefined,
    Object? transferredToLineName = _Undefined,
    Object? closedReason = _Undefined,
    bool? pushActive,
    bool? smsActive,
    bool? smsEnabled,
    Object? smsLast4 = _Undefined,
    bool? isDemo,
    DateTime? serverTime,
    int? version,
  }) {
    return PatientView(
      ticketId: ticketId ?? this.ticketId,
      clinicName: clinicName ?? this.clinicName,
      label: label ?? this.label,
      lineName: lineName ?? this.lineName,
      state: state ?? this.state,
      position: position is int? ? position : this.position,
      etaMinutes: etaMinutes is int? ? etaMinutes : this.etaMinutes,
      etaText: etaText is String? ? etaText : this.etaText,
      etaIsEstimate: etaIsEstimate ?? this.etaIsEstimate,
      roomName: roomName is String? ? roomName : this.roomName,
      nowServingLabel: nowServingLabel is String?
          ? nowServingLabel
          : this.nowServingLabel,
      nextAfterLabel: nextAfterLabel is String?
          ? nextAfterLabel
          : this.nextAfterLabel,
      graceEndsAt: graceEndsAt is DateTime? ? graceEndsAt : this.graceEndsAt,
      arrivalEndsAt: arrivalEndsAt is DateTime?
          ? arrivalEndsAt
          : this.arrivalEndsAt,
      graceSeconds: graceSeconds ?? this.graceSeconds,
      reslotCount: reslotCount ?? this.reslotCount,
      maxReslots: maxReslots ?? this.maxReslots,
      headsUpSent: headsUpSent ?? this.headsUpSent,
      lineMovedAt: lineMovedAt is DateTime? ? lineMovedAt : this.lineMovedAt,
      deskOnline: deskOnline ?? this.deskOnline,
      transferredToToken: transferredToToken is String?
          ? transferredToToken
          : this.transferredToToken,
      transferredToLabel: transferredToLabel is String?
          ? transferredToLabel
          : this.transferredToLabel,
      transferredToLineName: transferredToLineName is String?
          ? transferredToLineName
          : this.transferredToLineName,
      closedReason: closedReason is String? ? closedReason : this.closedReason,
      pushActive: pushActive ?? this.pushActive,
      smsActive: smsActive ?? this.smsActive,
      smsEnabled: smsEnabled ?? this.smsEnabled,
      smsLast4: smsLast4 is String? ? smsLast4 : this.smsLast4,
      isDemo: isDemo ?? this.isDemo,
      serverTime: serverTime ?? this.serverTime,
      version: version ?? this.version,
    );
  }
}
