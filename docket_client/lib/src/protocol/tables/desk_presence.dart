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

abstract class DeskPresence
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  DeskPresence._({
    this.id,
    required this.clinicId,
    required this.deviceId,
    this.roomId,
    required this.actorRef,
    required this.lastSeenAt,
  });

  factory DeskPresence({
    _isc.UuidValue? id,
    required _isc.UuidValue clinicId,
    required _isc.UuidValue deviceId,
    _isc.UuidValue? roomId,
    required String actorRef,
    required DateTime lastSeenAt,
  }) = _DeskPresenceImpl;

  factory DeskPresence.fromJson(Map<String, dynamic> jsonSerialization) {
    return DeskPresence(
      id: jsonSerialization['id'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      clinicId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['clinicId'],
      ),
      deviceId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['deviceId'],
      ),
      roomId: jsonSerialization['roomId'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['roomId']),
      actorRef: jsonSerialization['actorRef'] as String,
      lastSeenAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['lastSeenAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _isc.UuidValue? id;

  _isc.UuidValue clinicId;

  _isc.UuidValue deviceId;

  _isc.UuidValue? roomId;

  String actorRef;

  DateTime lastSeenAt;

  /// Returns a shallow copy of this [DeskPresence]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  DeskPresence copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? clinicId,
    _isc.UuidValue? deviceId,
    _isc.UuidValue? roomId,
    String? actorRef,
    DateTime? lastSeenAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DeskPresence',
      if (id != null) 'id': id?.toJson(),
      'clinicId': clinicId.toJson(),
      'deviceId': deviceId.toJson(),
      if (roomId != null) 'roomId': roomId?.toJson(),
      'actorRef': actorRef,
      'lastSeenAt': lastSeenAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DeskPresence',
      if (id != null) 'id': id?.toJson(),
      'clinicId': clinicId.toJson(),
      'deviceId': deviceId.toJson(),
      if (roomId != null) 'roomId': roomId?.toJson(),
      'actorRef': actorRef,
      'lastSeenAt': lastSeenAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DeskPresenceImpl extends DeskPresence {
  _DeskPresenceImpl({
    _isc.UuidValue? id,
    required _isc.UuidValue clinicId,
    required _isc.UuidValue deviceId,
    _isc.UuidValue? roomId,
    required String actorRef,
    required DateTime lastSeenAt,
  }) : super._(
         id: id,
         clinicId: clinicId,
         deviceId: deviceId,
         roomId: roomId,
         actorRef: actorRef,
         lastSeenAt: lastSeenAt,
       );

  /// Returns a shallow copy of this [DeskPresence]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  DeskPresence copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? clinicId,
    _isc.UuidValue? deviceId,
    Object? roomId = _Undefined,
    String? actorRef,
    DateTime? lastSeenAt,
  }) {
    return DeskPresence(
      id: id is _isc.UuidValue? ? id : this.id,
      clinicId: clinicId ?? this.clinicId,
      deviceId: deviceId ?? this.deviceId,
      roomId: roomId is _isc.UuidValue? ? roomId : this.roomId,
      actorRef: actorRef ?? this.actorRef,
      lastSeenAt: lastSeenAt ?? this.lastSeenAt,
    );
  }
}
