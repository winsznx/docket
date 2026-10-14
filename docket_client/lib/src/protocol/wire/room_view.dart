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
import '../enums/room_state.dart' as _is416j1i;

abstract class RoomView
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  RoomView._({
    required this.id,
    required this.name,
    required this.lineId,
    required this.state,
    this.currentTicketId,
    required this.deskOnline,
  });

  factory RoomView({
    required _isc.UuidValue id,
    required String name,
    required _isc.UuidValue lineId,
    required _is416j1i.RoomState state,
    _isc.UuidValue? currentTicketId,
    required bool deskOnline,
  }) = _RoomViewImpl;

  factory RoomView.fromJson(Map<String, dynamic> jsonSerialization) {
    return RoomView(
      id: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      name: jsonSerialization['name'] as String,
      lineId: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['lineId']),
      state: _is416j1i.RoomState.fromJson(
        (jsonSerialization['state'] as String),
      ),
      currentTicketId: jsonSerialization['currentTicketId'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(
              jsonSerialization['currentTicketId'],
            ),
      deskOnline: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['deskOnline'],
      ),
    );
  }

  _isc.UuidValue id;

  String name;

  _isc.UuidValue lineId;

  _is416j1i.RoomState state;

  _isc.UuidValue? currentTicketId;

  bool deskOnline;

  /// Returns a shallow copy of this [RoomView]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  RoomView copyWith({
    _isc.UuidValue? id,
    String? name,
    _isc.UuidValue? lineId,
    _is416j1i.RoomState? state,
    _isc.UuidValue? currentTicketId,
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
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RoomViewImpl extends RoomView {
  _RoomViewImpl({
    required _isc.UuidValue id,
    required String name,
    required _isc.UuidValue lineId,
    required _is416j1i.RoomState state,
    _isc.UuidValue? currentTicketId,
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
  @_isc.useResult
  @override
  RoomView copyWith({
    _isc.UuidValue? id,
    String? name,
    _isc.UuidValue? lineId,
    _is416j1i.RoomState? state,
    Object? currentTicketId = _Undefined,
    bool? deskOnline,
  }) {
    return RoomView(
      id: id ?? this.id,
      name: name ?? this.name,
      lineId: lineId ?? this.lineId,
      state: state ?? this.state,
      currentTicketId: currentTicketId is _isc.UuidValue?
          ? currentTicketId
          : this.currentTicketId,
      deskOnline: deskOnline ?? this.deskOnline,
    );
  }
}
