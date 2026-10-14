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

abstract class SetRoomStateAction extends _iv35mfmj.DeskAction
    implements _is.SerializableModel, _is.ProtocolSerialization {
  SetRoomStateAction._({
    required super.actionId,
    required super.deviceId,
    required super.seq,
    required super.issuedAtLocal,
    required this.roomId,
    required this.state,
  });

  factory SetRoomStateAction({
    required _is.UuidValue actionId,
    required _is.UuidValue deviceId,
    required int seq,
    required DateTime issuedAtLocal,
    required _is.UuidValue roomId,
    required _is416j1i.RoomState state,
  }) = _SetRoomStateActionImpl;

  factory SetRoomStateAction.fromJson(Map<String, dynamic> jsonSerialization) {
    return SetRoomStateAction(
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
      roomId: _is.UuidValueJsonExtension.fromJson(jsonSerialization['roomId']),
      state: _is416j1i.RoomState.fromJson(
        (jsonSerialization['state'] as String),
      ),
    );
  }

  _is.UuidValue roomId;

  _is416j1i.RoomState state;

  /// Returns a shallow copy of this [SetRoomStateAction]
  /// with some or all fields replaced by the given arguments.
  @override
  @_is.useResult
  SetRoomStateAction copyWith({
    _is.UuidValue? actionId,
    _is.UuidValue? deviceId,
    int? seq,
    DateTime? issuedAtLocal,
    _is.UuidValue? roomId,
    _is416j1i.RoomState? state,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SetRoomStateAction',
      'actionId': actionId.toJson(),
      'deviceId': deviceId.toJson(),
      'seq': seq,
      'issuedAtLocal': issuedAtLocal.toJson(),
      'roomId': roomId.toJson(),
      'state': state.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SetRoomStateAction',
      'actionId': actionId.toJson(),
      'deviceId': deviceId.toJson(),
      'seq': seq,
      'issuedAtLocal': issuedAtLocal.toJson(),
      'roomId': roomId.toJson(),
      'state': state.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _SetRoomStateActionImpl extends SetRoomStateAction {
  _SetRoomStateActionImpl({
    required _is.UuidValue actionId,
    required _is.UuidValue deviceId,
    required int seq,
    required DateTime issuedAtLocal,
    required _is.UuidValue roomId,
    required _is416j1i.RoomState state,
  }) : super._(
         actionId: actionId,
         deviceId: deviceId,
         seq: seq,
         issuedAtLocal: issuedAtLocal,
         roomId: roomId,
         state: state,
       );

  /// Returns a shallow copy of this [SetRoomStateAction]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  SetRoomStateAction copyWith({
    _is.UuidValue? actionId,
    _is.UuidValue? deviceId,
    int? seq,
    DateTime? issuedAtLocal,
    _is.UuidValue? roomId,
    _is416j1i.RoomState? state,
  }) {
    return SetRoomStateAction(
      actionId: actionId ?? this.actionId,
      deviceId: deviceId ?? this.deviceId,
      seq: seq ?? this.seq,
      issuedAtLocal: issuedAtLocal ?? this.issuedAtLocal,
      roomId: roomId ?? this.roomId,
      state: state ?? this.state,
    );
  }
}
