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
    implements _is.SerializableModel, _is.ProtocolSerialization {
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
    required _is.UuidValue actionId,
    required _is.UuidValue deviceId,
    required int seq,
    required DateTime issuedAtLocal,
    required _is.UuidValue ticketId,
    required _is.UuidValue lineId,
    required String displayName,
    String? phoneE164,
  }) = _AddWalkInActionImpl;

  factory AddWalkInAction.fromJson(Map<String, dynamic> jsonSerialization) {
    return AddWalkInAction(
      actionId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['actionId'],
      ),
      deviceId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['deviceId'],
      ),
      seq: jsonSerialization['seq'] as int,
      issuedAtLocal: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['issuedAtLocal'],
      ),
      ticketId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['ticketId'],
      ),
      lineId: _is.UuidValueJsonExtension.fromJson(jsonSerialization['lineId']),
      displayName: jsonSerialization['displayName'] as String,
      phoneE164: jsonSerialization['phoneE164'] as String?,
    );
  }

  _is.UuidValue ticketId;

  _is.UuidValue lineId;

  String displayName;

  String? phoneE164;

  /// Returns a shallow copy of this [AddWalkInAction]
  /// with some or all fields replaced by the given arguments.
  @override
  @_is.useResult
  AddWalkInAction copyWith({
    _is.UuidValue? actionId,
    _is.UuidValue? deviceId,
    int? seq,
    DateTime? issuedAtLocal,
    _is.UuidValue? ticketId,
    _is.UuidValue? lineId,
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
    return _is.SerializationManager.encode(this);
  }
}

class _AddWalkInActionImpl extends AddWalkInAction {
  _AddWalkInActionImpl({
    required _is.UuidValue actionId,
    required _is.UuidValue deviceId,
    required int seq,
    required DateTime issuedAtLocal,
    required _is.UuidValue ticketId,
    required _is.UuidValue lineId,
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
  @_is.useResult
  @override
  AddWalkInAction copyWith({
    _is.UuidValue? actionId,
    _is.UuidValue? deviceId,
    int? seq,
    DateTime? issuedAtLocal,
    _is.UuidValue? ticketId,
    _is.UuidValue? lineId,
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
