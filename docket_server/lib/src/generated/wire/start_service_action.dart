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

abstract class StartServiceAction extends _iv35mfmj.DeskAction
    implements _is.SerializableModel, _is.ProtocolSerialization {
  StartServiceAction._({
    required super.actionId,
    required super.deviceId,
    required super.seq,
    required super.issuedAtLocal,
    required this.ticketId,
    required this.roomId,
  });

  factory StartServiceAction({
    required _is.UuidValue actionId,
    required _is.UuidValue deviceId,
    required int seq,
    required DateTime issuedAtLocal,
    required _is.UuidValue ticketId,
    required _is.UuidValue roomId,
  }) = _StartServiceActionImpl;

  factory StartServiceAction.fromJson(Map<String, dynamic> jsonSerialization) {
    return StartServiceAction(
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
      roomId: _is.UuidValueJsonExtension.fromJson(jsonSerialization['roomId']),
    );
  }

  _is.UuidValue ticketId;

  _is.UuidValue roomId;

  /// Returns a shallow copy of this [StartServiceAction]
  /// with some or all fields replaced by the given arguments.
  @override
  @_is.useResult
  StartServiceAction copyWith({
    _is.UuidValue? actionId,
    _is.UuidValue? deviceId,
    int? seq,
    DateTime? issuedAtLocal,
    _is.UuidValue? ticketId,
    _is.UuidValue? roomId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'StartServiceAction',
      'actionId': actionId.toJson(),
      'deviceId': deviceId.toJson(),
      'seq': seq,
      'issuedAtLocal': issuedAtLocal.toJson(),
      'ticketId': ticketId.toJson(),
      'roomId': roomId.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'StartServiceAction',
      'actionId': actionId.toJson(),
      'deviceId': deviceId.toJson(),
      'seq': seq,
      'issuedAtLocal': issuedAtLocal.toJson(),
      'ticketId': ticketId.toJson(),
      'roomId': roomId.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _StartServiceActionImpl extends StartServiceAction {
  _StartServiceActionImpl({
    required _is.UuidValue actionId,
    required _is.UuidValue deviceId,
    required int seq,
    required DateTime issuedAtLocal,
    required _is.UuidValue ticketId,
    required _is.UuidValue roomId,
  }) : super._(
         actionId: actionId,
         deviceId: deviceId,
         seq: seq,
         issuedAtLocal: issuedAtLocal,
         ticketId: ticketId,
         roomId: roomId,
       );

  /// Returns a shallow copy of this [StartServiceAction]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  StartServiceAction copyWith({
    _is.UuidValue? actionId,
    _is.UuidValue? deviceId,
    int? seq,
    DateTime? issuedAtLocal,
    _is.UuidValue? ticketId,
    _is.UuidValue? roomId,
  }) {
    return StartServiceAction(
      actionId: actionId ?? this.actionId,
      deviceId: deviceId ?? this.deviceId,
      seq: seq ?? this.seq,
      issuedAtLocal: issuedAtLocal ?? this.issuedAtLocal,
      ticketId: ticketId ?? this.ticketId,
      roomId: roomId ?? this.roomId,
    );
  }
}
