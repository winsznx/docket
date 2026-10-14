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

abstract class RoomView
    implements _is.SerializableModel, _is.ProtocolSerialization {
  RoomView._({
    required this.id,
    required this.name,
    required this.lineId,
    required this.state,
    this.currentTicketId,
    required this.deskOnline,
  });

  factory RoomView({
    required _is.UuidValue id,
    required String name,
    required _is.UuidValue lineId,
    required _is416j1i.RoomState state,
    _is.UuidValue? currentTicketId,
    required bool deskOnline,
  }) = _RoomViewImpl;

  factory RoomView.fromJson(Map<String, dynamic> jsonSerialization) {
    return RoomView(
      id: _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      name: jsonSerialization['name'] as String,
      lineId: _is.UuidValueJsonExtension.fromJson(jsonSerialization['lineId']),
      state: _is416j1i.RoomState.fromJson(
        (jsonSerialization['state'] as String),
      ),
      currentTicketId: jsonSerialization['currentTicketId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(
              jsonSerialization['currentTicketId'],
            ),
      deskOnline: _is.BoolJsonExtension.fromJson(
        jsonSerialization['deskOnline'],
      ),
    );
  }

  _is.UuidValue id;

  String name;

  _is.UuidValue lineId;

  _is416j1i.RoomState state;

  _is.UuidValue? currentTicketId;

  bool deskOnline;

  /// Returns a shallow copy of this [RoomView]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  RoomView copyWith({
    _is.UuidValue? id,
    String? name,
    _is.UuidValue? lineId,
    _is416j1i.RoomState? state,
    _is.UuidValue? currentTicketId,
    bool? deskOnline,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RoomView',
      'id': id.toJson(),
      'name': name,
      'lineId': lineId.toJson(),
      'state': state.toJson(),
      if (currentTicketId != null) 'currentTicketId': currentTicketId?.toJson(),
      'deskOnline': deskOnline,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'RoomView',
      'id': id.toJson(),
      'name': name,
      'lineId': lineId.toJson(),
      'state': state.toJson(),
      if (currentTicketId != null) 'currentTicketId': currentTicketId?.toJson(),
      'deskOnline': deskOnline,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RoomViewImpl extends RoomView {
  _RoomViewImpl({
    required _is.UuidValue id,
    required String name,
    required _is.UuidValue lineId,
    required _is416j1i.RoomState state,
    _is.UuidValue? currentTicketId,
    required bool deskOnline,
  }) : super._(
         id: id,
         name: name,
         lineId: lineId,
         state: state,
         currentTicketId: currentTicketId,
         deskOnline: deskOnline,
       );

  /// Returns a shallow copy of this [RoomView]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  RoomView copyWith({
    _is.UuidValue? id,
    String? name,
    _is.UuidValue? lineId,
    _is416j1i.RoomState? state,
    Object? currentTicketId = _Undefined,
    bool? deskOnline,
  }) {
    return RoomView(
      id: id ?? this.id,
      name: name ?? this.name,
      lineId: lineId ?? this.lineId,
      state: state ?? this.state,
      currentTicketId: currentTicketId is _is.UuidValue?
          ? currentTicketId
          : this.currentTicketId,
      deskOnline: deskOnline ?? this.deskOnline,
    );
  }
}
