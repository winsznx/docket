/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

part of 'desk_action.dart';

abstract class AddWalkInAction extends _iv35mfmj.DeskAction
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  AddWalkInAction._({
    required super.actionId,
    required super.deviceId,
    required super.seq,
    required super.issuedAtLocal,
    required this.ticketId,
    required this.lineId,
    required this.displayName,
    this.phoneE164,
  });

  factory AddWalkInAction({
    required _isc.UuidValue actionId,
    required _isc.UuidValue deviceId,
    required int seq,
    required DateTime issuedAtLocal,
    required _isc.UuidValue ticketId,
    required _isc.UuidValue lineId,
    required String displayName,
    String? phoneE164,
  }) = _AddWalkInActionImpl;

  factory AddWalkInAction.fromJson(Map<String, dynamic> jsonSerialization) {
    return AddWalkInAction(
      actionId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['actionId'],
      ),
      deviceId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['deviceId'],
      ),
      seq: jsonSerialization['seq'] as int,
      issuedAtLocal: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['issuedAtLocal'],
      ),
      ticketId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['ticketId'],
      ),
      lineId: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['lineId']),
      displayName: jsonSerialization['displayName'] as String,
      phoneE164: jsonSerialization['phoneE164'] as String?,
    );
  }

  _isc.UuidValue ticketId;

  _isc.UuidValue lineId;

  String displayName;

  String? phoneE164;

  /// Returns a shallow copy of this [AddWalkInAction]
  /// with some or all fields replaced by the given arguments.
  @override
  @_isc.useResult
  AddWalkInAction copyWith({
    _isc.UuidValue? actionId,
    _isc.UuidValue? deviceId,
    int? seq,
    DateTime? issuedAtLocal,
    _isc.UuidValue? ticketId,
    _isc.UuidValue? lineId,
    String? displayName,
    String? phoneE164,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AddWalkInAction',
      'actionId': actionId.toJson(),
      'deviceId': deviceId.toJson(),
      'seq': seq,
      'issuedAtLocal': issuedAtLocal.toJson(),
      'ticketId': ticketId.toJson(),
      'lineId': lineId.toJson(),
      'displayName': displayName,
      if (phoneE164 != null) 'phoneE164': phoneE164,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AddWalkInAction',
      'actionId': actionId.toJson(),
      'deviceId': deviceId.toJson(),
      'seq': seq,
      'issuedAtLocal': issuedAtLocal.toJson(),
      'ticketId': ticketId.toJson(),
      'lineId': lineId.toJson(),
      'displayName': displayName,
      if (phoneE164 != null) 'phoneE164': phoneE164,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _AddWalkInActionImpl extends AddWalkInAction {
  _AddWalkInActionImpl({
    required _isc.UuidValue actionId,
    required _isc.UuidValue deviceId,
    required int seq,
    required DateTime issuedAtLocal,
    required _isc.UuidValue ticketId,
    required _isc.UuidValue lineId,
    required String displayName,
    String? phoneE164,
  }) : super._(
         actionId: actionId,
         deviceId: deviceId,
         seq: seq,
         issuedAtLocal: issuedAtLocal,
         ticketId: ticketId,
         lineId: lineId,
         displayName: displayName,
         phoneE164: phoneE164,
       );

  /// Returns a shallow copy of this [AddWalkInAction]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  AddWalkInAction copyWith({
    _isc.UuidValue? actionId,
    _isc.UuidValue? deviceId,
    int? seq,
    DateTime? issuedAtLocal,
    _isc.UuidValue? ticketId,
    _isc.UuidValue? lineId,
    String? displayName,
    Object? phoneE164 = _Undefined,
  }) {
    return AddWalkInAction(
      actionId: actionId ?? this.actionId,
      deviceId: deviceId ?? this.deviceId,
      seq: seq ?? this.seq,
      issuedAtLocal: issuedAtLocal ?? this.issuedAtLocal,
      ticketId: ticketId ?? this.ticketId,
      lineId: lineId ?? this.lineId,
      displayName: displayName ?? this.displayName,
      phoneE164: phoneE164 is String? ? phoneE164 : this.phoneE164,
    );
  }
}
