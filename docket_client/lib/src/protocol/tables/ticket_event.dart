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
import '../enums/actor_type.dart' as _iau4lzx2;
import '../enums/ticket_event_type.dart' as _iartk5zh;
import '../enums/ticket_state.dart' as _imwmdlft;

abstract class TicketEvent
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  TicketEvent._({
    this.id,
    required this.clinicId,
    required this.lineId,
    required this.ticketId,
    required this.ticketLabel,
    required this.type,
    this.fromState,
    this.toState,
    required this.actor,
    this.actorRef,
    this.deviceId,
    this.actionId,
    this.roomId,
    this.reason,
    required this.lineVersion,
    required this.at,
  });

  factory TicketEvent({
    _isc.UuidValue? id,
    required _isc.UuidValue clinicId,
    required _isc.UuidValue lineId,
    required _isc.UuidValue ticketId,
    required String ticketLabel,
    required _iartk5zh.TicketEventType type,
    _imwmdlft.TicketState? fromState,
    _imwmdlft.TicketState? toState,
    required _iau4lzx2.ActorType actor,
    String? actorRef,
    _isc.UuidValue? deviceId,
    _isc.UuidValue? actionId,
    _isc.UuidValue? roomId,
    String? reason,
    required int lineVersion,
    required DateTime at,
  }) = _TicketEventImpl;

  factory TicketEvent.fromJson(Map<String, dynamic> jsonSerialization) {
    return TicketEvent(
      id: jsonSerialization['id'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      clinicId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['clinicId'],
      ),
      lineId: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['lineId']),
      ticketId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['ticketId'],
      ),
      ticketLabel: jsonSerialization['ticketLabel'] as String,
      type: _iartk5zh.TicketEventType.fromJson(
        (jsonSerialization['type'] as String),
      ),
      fromState: jsonSerialization['fromState'] == null
          ? null
          : _imwmdlft.TicketState.fromJson(
              (jsonSerialization['fromState'] as String),
            ),
      toState: jsonSerialization['toState'] == null
          ? null
          : _imwmdlft.TicketState.fromJson(
              (jsonSerialization['toState'] as String),
            ),
      actor: _iau4lzx2.ActorType.fromJson(
        (jsonSerialization['actor'] as String),
      ),
      actorRef: jsonSerialization['actorRef'] as String?,
      deviceId: jsonSerialization['deviceId'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['deviceId']),
      actionId: jsonSerialization['actionId'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['actionId']),
      roomId: jsonSerialization['roomId'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['roomId']),
      reason: jsonSerialization['reason'] as String?,
      lineVersion: jsonSerialization['lineVersion'] as int,
      at: _isc.DateTimeJsonExtension.fromJson(jsonSerialization['at']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _isc.UuidValue? id;

  _isc.UuidValue clinicId;

  _isc.UuidValue lineId;

  _isc.UuidValue ticketId;

  String ticketLabel;

  _iartk5zh.TicketEventType type;

  _imwmdlft.TicketState? fromState;

  _imwmdlft.TicketState? toState;

  _iau4lzx2.ActorType actor;

  String? actorRef;

  _isc.UuidValue? deviceId;

  _isc.UuidValue? actionId;

  _isc.UuidValue? roomId;

  String? reason;

  int lineVersion;

  DateTime at;

  /// Returns a shallow copy of this [TicketEvent]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  TicketEvent copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? clinicId,
    _isc.UuidValue? lineId,
    _isc.UuidValue? ticketId,
    String? ticketLabel,
    _iartk5zh.TicketEventType? type,
    _imwmdlft.TicketState? fromState,
    _imwmdlft.TicketState? toState,
    _iau4lzx2.ActorType? actor,
    String? actorRef,
    _isc.UuidValue? deviceId,
    _isc.UuidValue? actionId,
    _isc.UuidValue? roomId,
    String? reason,
    int? lineVersion,
    DateTime? at,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TicketEvent',
      if (id != null) 'id': id?.toJson(),
      'clinicId': clinicId.toJson(),
      'lineId': lineId.toJson(),
      'ticketId': ticketId.toJson(),
      'ticketLabel': ticketLabel,
      'type': type.toJson(),
      if (fromState != null) 'fromState': fromState?.toJson(),
      if (toState != null) 'toState': toState?.toJson(),
      'actor': actor.toJson(),
      if (actorRef != null) 'actorRef': actorRef,
      if (deviceId != null) 'deviceId': deviceId?.toJson(),
      if (actionId != null) 'actionId': actionId?.toJson(),
      if (roomId != null) 'roomId': roomId?.toJson(),
      if (reason != null) 'reason': reason,
      'lineVersion': lineVersion,
      'at': at.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'TicketEvent',
      if (id != null) 'id': id?.toJson(),
      'clinicId': clinicId.toJson(),
      'lineId': lineId.toJson(),
      'ticketId': ticketId.toJson(),
      'ticketLabel': ticketLabel,
      'type': type.toJson(),
      if (fromState != null) 'fromState': fromState?.toJson(),
      if (toState != null) 'toState': toState?.toJson(),
      'actor': actor.toJson(),
      if (actorRef != null) 'actorRef': actorRef,
      if (deviceId != null) 'deviceId': deviceId?.toJson(),
      if (actionId != null) 'actionId': actionId?.toJson(),
      if (roomId != null) 'roomId': roomId?.toJson(),
      if (reason != null) 'reason': reason,
      'lineVersion': lineVersion,
      'at': at.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TicketEventImpl extends TicketEvent {
  _TicketEventImpl({
    _isc.UuidValue? id,
    required _isc.UuidValue clinicId,
    required _isc.UuidValue lineId,
    required _isc.UuidValue ticketId,
    required String ticketLabel,
    required _iartk5zh.TicketEventType type,
    _imwmdlft.TicketState? fromState,
    _imwmdlft.TicketState? toState,
    required _iau4lzx2.ActorType actor,
    String? actorRef,
    _isc.UuidValue? deviceId,
    _isc.UuidValue? actionId,
    _isc.UuidValue? roomId,
    String? reason,
    required int lineVersion,
    required DateTime at,
  }) : super._(
         id: id,
         clinicId: clinicId,
         lineId: lineId,
         ticketId: ticketId,
         ticketLabel: ticketLabel,
         type: type,
         fromState: fromState,
         toState: toState,
         actor: actor,
         actorRef: actorRef,
         deviceId: deviceId,
         actionId: actionId,
         roomId: roomId,
         reason: reason,
         lineVersion: lineVersion,
         at: at,
       );

  /// Returns a shallow copy of this [TicketEvent]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  TicketEvent copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? clinicId,
    _isc.UuidValue? lineId,
    _isc.UuidValue? ticketId,
    String? ticketLabel,
    _iartk5zh.TicketEventType? type,
    Object? fromState = _Undefined,
    Object? toState = _Undefined,
    _iau4lzx2.ActorType? actor,
    Object? actorRef = _Undefined,
    Object? deviceId = _Undefined,
    Object? actionId = _Undefined,
    Object? roomId = _Undefined,
    Object? reason = _Undefined,
    int? lineVersion,
    DateTime? at,
  }) {
    return TicketEvent(
      id: id is _isc.UuidValue? ? id : this.id,
      clinicId: clinicId ?? this.clinicId,
      lineId: lineId ?? this.lineId,
      ticketId: ticketId ?? this.ticketId,
      ticketLabel: ticketLabel ?? this.ticketLabel,
      type: type ?? this.type,
      fromState: fromState is _imwmdlft.TicketState?
          ? fromState
          : this.fromState,
      toState: toState is _imwmdlft.TicketState? ? toState : this.toState,
      actor: actor ?? this.actor,
      actorRef: actorRef is String? ? actorRef : this.actorRef,
      deviceId: deviceId is _isc.UuidValue? ? deviceId : this.deviceId,
      actionId: actionId is _isc.UuidValue? ? actionId : this.actionId,
      roomId: roomId is _isc.UuidValue? ? roomId : this.roomId,
      reason: reason is String? ? reason : this.reason,
      lineVersion: lineVersion ?? this.lineVersion,
      at: at ?? this.at,
    );
  }
}
