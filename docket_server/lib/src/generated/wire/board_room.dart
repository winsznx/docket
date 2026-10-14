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
import '../enums/room_state.dart' as _is416j1i;

abstract class BoardRoom
    implements _is.SerializableModel, _is.ProtocolSerialization {
  BoardRoom._({
    required this.roomName,
    required this.state,
    this.nowServingLabel,
  });

  factory BoardRoom({
    required String roomName,
    required _is416j1i.RoomState state,
    String? nowServingLabel,
  }) = _BoardRoomImpl;

  factory BoardRoom.fromJson(Map<String, dynamic> jsonSerialization) {
    return BoardRoom(
      roomName: jsonSerialization['roomName'] as String,
      state: _is416j1i.RoomState.fromJson(
        (jsonSerialization['state'] as String),
      ),
      nowServingLabel: jsonSerialization['nowServingLabel'] as String?,
    );
  }

  String roomName;

  _is416j1i.RoomState state;

  String? nowServingLabel;

  /// Returns a shallow copy of this [BoardRoom]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  BoardRoom copyWith({
    String? roomName,
    _is416j1i.RoomState? state,
    String? nowServingLabel,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'BoardRoom',
      'roomName': roomName,
      'state': state.toJson(),
      if (nowServingLabel != null) 'nowServingLabel': nowServingLabel,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'BoardRoom',
      'roomName': roomName,
      'state': state.toJson(),
      if (nowServingLabel != null) 'nowServingLabel': nowServingLabel,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _BoardRoomImpl extends BoardRoom {
  _BoardRoomImpl({
    required String roomName,
    required _is416j1i.RoomState state,
    String? nowServingLabel,
  }) : super._(
         roomName: roomName,
         state: state,
         nowServingLabel: nowServingLabel,
       );

  /// Returns a shallow copy of this [BoardRoom]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  BoardRoom copyWith({
    String? roomName,
    _is416j1i.RoomState? state,
    Object? nowServingLabel = _Undefined,
  }) {
    return BoardRoom(
      roomName: roomName ?? this.roomName,
      state: state ?? this.state,
      nowServingLabel: nowServingLabel is String?
          ? nowServingLabel
          : this.nowServingLabel,
    );
  }
}
