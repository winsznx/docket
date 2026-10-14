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

abstract class Room
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Room._({
    this.id,
    required this.clinicId,
    required this.lineId,
    required this.name,
    _is416j1i.RoomState? state,
    int? sortOrder,
  }) : state = state ?? _is416j1i.RoomState.open,
       sortOrder = sortOrder ?? 0;

  factory Room({
    _isc.UuidValue? id,
    required _isc.UuidValue clinicId,
    required _isc.UuidValue lineId,
    required String name,
    _is416j1i.RoomState? state,
    int? sortOrder,
  }) = _RoomImpl;

  factory Room.fromJson(Map<String, dynamic> jsonSerialization) {
    return Room(
      id: jsonSerialization['id'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      clinicId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['clinicId'],
      ),
      lineId: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['lineId']),
      name: jsonSerialization['name'] as String,
      state: jsonSerialization['state'] == null
          ? null
          : _is416j1i.RoomState.fromJson(
              (jsonSerialization['state'] as String),
            ),
      sortOrder: jsonSerialization['sortOrder'] as int?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _isc.UuidValue? id;

  _isc.UuidValue clinicId;

  _isc.UuidValue lineId;

  String name;

  _is416j1i.RoomState state;

  int sortOrder;

  /// Returns a shallow copy of this [Room]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Room copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? clinicId,
    _isc.UuidValue? lineId,
    String? name,
    _is416j1i.RoomState? state,
    int? sortOrder,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Room',
      if (id != null) 'id': id?.toJson(),
      'clinicId': clinicId.toJson(),
      'lineId': lineId.toJson(),
      'name': name,
      'state': state.toJson(),
      'sortOrder': sortOrder,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Room',
      if (id != null) 'id': id?.toJson(),
      'clinicId': clinicId.toJson(),
      'lineId': lineId.toJson(),
      'name': name,
      'state': state.toJson(),
      'sortOrder': sortOrder,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RoomImpl extends Room {
  _RoomImpl({
    _isc.UuidValue? id,
    required _isc.UuidValue clinicId,
    required _isc.UuidValue lineId,
    required String name,
    _is416j1i.RoomState? state,
    int? sortOrder,
  }) : super._(
         id: id,
         clinicId: clinicId,
         lineId: lineId,
         name: name,
         state: state,
         sortOrder: sortOrder,
       );

  /// Returns a shallow copy of this [Room]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Room copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? clinicId,
    _isc.UuidValue? lineId,
    String? name,
    _is416j1i.RoomState? state,
    int? sortOrder,
  }) {
    return Room(
      id: id is _isc.UuidValue? ? id : this.id,
      clinicId: clinicId ?? this.clinicId,
      lineId: lineId ?? this.lineId,
      name: name ?? this.name,
      state: state ?? this.state,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }
}
