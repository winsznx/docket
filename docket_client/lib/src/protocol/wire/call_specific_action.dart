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

abstract class CallSpecificAction extends _iv35mfmj.DeskAction
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  CallSpecificAction._({
    required super.actionId,
    required super.deviceId,
    required super.seq,
    required super.issuedAtLocal,
    required this.roomId,
    required this.ticketId,
  });

  factory CallSpecificAction({
    required _isc.UuidValue actionId,
    required _isc.UuidValue deviceId,
    required int seq,
    required DateTime issuedAtLocal,
    required _isc.UuidValue roomId,
    required _isc.UuidValue ticketId,
  }) = _CallSpecificActionImpl;

  factory CallSpecificAction.fromJson(Map<String, dynamic> jsonSerialization) {
    return CallSpecificAction(
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
      roomId: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['roomId']),
      ticketId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['ticketId'],
      ),
    );
  }

  _isc.UuidValue roomId;

  _isc.UuidValue ticketId;

  /// Returns a shallow copy of this [CallSpecificAction]
  /// with some or all fields replaced by the given arguments.
  @override
  @_isc.useResult
  CallSpecificAction copyWith({
    _isc.UuidValue? actionId,
    _isc.UuidValue? deviceId,
    int? seq,
    DateTime? issuedAtLocal,
    _isc.UuidValue? roomId,
    _isc.UuidValue? ticketId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CallSpecificAction',
      'actionId': actionId.toJson(),
      'deviceId': deviceId.toJson(),
      'seq': seq,
      'issuedAtLocal': issuedAtLocal.toJson(),
      'roomId': roomId.toJson(),
      'ticketId': ticketId.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CallSpecificAction',
      'actionId': actionId.toJson(),
      'deviceId': deviceId.toJson(),
      'seq': seq,
      'issuedAtLocal': issuedAtLocal.toJson(),
      'roomId': roomId.toJson(),
      'ticketId': ticketId.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _CallSpecificActionImpl extends CallSpecificAction {
  _CallSpecificActionImpl({
    required _isc.UuidValue actionId,
    required _isc.UuidValue deviceId,
    required int seq,
    required DateTime issuedAtLocal,
    required _isc.UuidValue roomId,
    required _isc.UuidValue ticketId,
  }) : super._(
         actionId: actionId,
         deviceId: deviceId,
         seq: seq,
         issuedAtLocal: issuedAtLocal,
         roomId: roomId,
         ticketId: ticketId,
       );

  /// Returns a shallow copy of this [CallSpecificAction]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  CallSpecificAction copyWith({
    _isc.UuidValue? actionId,
    _isc.UuidValue? deviceId,
    int? seq,
    DateTime? issuedAtLocal,
    _isc.UuidValue? roomId,
    _isc.UuidValue? ticketId,
  }) {
    return CallSpecificAction(
      actionId: actionId ?? this.actionId,
      deviceId: deviceId ?? this.deviceId,
      seq: seq ?? this.seq,
      issuedAtLocal: issuedAtLocal ?? this.issuedAtLocal,
      roomId: roomId ?? this.roomId,
      ticketId: ticketId ?? this.ticketId,
    );
  }
}
