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
import '../enums/channel.dart' as _i1ikwq8c;
import '../enums/delivery_status.dart' as _ik1evhid;
import '../enums/notification_kind.dart' as _ic51rir1;

abstract class Notification
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Notification._({
    this.id,
    required this.ticketId,
    required this.clinicId,
    required this.ticketLabel,
    required this.kind,
    required this.channel,
    required this.status,
    required this.dedupeKey,
    int? callVersion,
    int? attempts,
    this.providerRef,
    this.error,
    DateTime? createdAt,
    this.sentAt,
  }) : callVersion = callVersion ?? 0,
       attempts = attempts ?? 0,
       createdAt = createdAt ?? DateTime.now();

  factory Notification({
    _isc.UuidValue? id,
    required _isc.UuidValue ticketId,
    required _isc.UuidValue clinicId,
    required String ticketLabel,
    required _ic51rir1.NotificationKind kind,
    required _i1ikwq8c.Channel channel,
    required _ik1evhid.DeliveryStatus status,
    required String dedupeKey,
    int? callVersion,
    int? attempts,
    String? providerRef,
    String? error,
    DateTime? createdAt,
    DateTime? sentAt,
  }) = _NotificationImpl;

  factory Notification.fromJson(Map<String, dynamic> jsonSerialization) {
    return Notification(
      id: jsonSerialization['id'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      ticketId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['ticketId'],
      ),
      clinicId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['clinicId'],
      ),
      ticketLabel: jsonSerialization['ticketLabel'] as String,
      kind: _ic51rir1.NotificationKind.fromJson(
        (jsonSerialization['kind'] as String),
      ),
      channel: _i1ikwq8c.Channel.fromJson(
        (jsonSerialization['channel'] as String),
      ),
      status: _ik1evhid.DeliveryStatus.fromJson(
        (jsonSerialization['status'] as String),
      ),
      dedupeKey: jsonSerialization['dedupeKey'] as String,
      callVersion: jsonSerialization['callVersion'] as int?,
      attempts: jsonSerialization['attempts'] as int?,
      providerRef: jsonSerialization['providerRef'] as String?,
      error: jsonSerialization['error'] as String?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      sentAt: jsonSerialization['sentAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['sentAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _isc.UuidValue? id;

  _isc.UuidValue ticketId;

  _isc.UuidValue clinicId;

  String ticketLabel;

  _ic51rir1.NotificationKind kind;

  _i1ikwq8c.Channel channel;

  _ik1evhid.DeliveryStatus status;

  String dedupeKey;

  int callVersion;

  int attempts;

  String? providerRef;

  String? error;

  DateTime createdAt;

  DateTime? sentAt;

  /// Returns a shallow copy of this [Notification]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Notification copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? ticketId,
    _isc.UuidValue? clinicId,
    String? ticketLabel,
    _ic51rir1.NotificationKind? kind,
    _i1ikwq8c.Channel? channel,
    _ik1evhid.DeliveryStatus? status,
    String? dedupeKey,
    int? callVersion,
    int? attempts,
    String? providerRef,
    String? error,
    DateTime? createdAt,
    DateTime? sentAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Notification',
      if (id != null) 'id': id?.toJson(),
      'ticketId': ticketId.toJson(),
      'clinicId': clinicId.toJson(),
      'ticketLabel': ticketLabel,
      'kind': kind.toJson(),
      'channel': channel.toJson(),
      'status': status.toJson(),
      'dedupeKey': dedupeKey,
      'callVersion': callVersion,
      'attempts': attempts,
      if (providerRef != null) 'providerRef': providerRef,
      if (error != null) 'error': error,
      'createdAt': createdAt.toJson(),
      if (sentAt != null) 'sentAt': sentAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Notification',
      if (id != null) 'id': id?.toJson(),
      'ticketId': ticketId.toJson(),
      'clinicId': clinicId.toJson(),
      'ticketLabel': ticketLabel,
      'kind': kind.toJson(),
      'channel': channel.toJson(),
      'status': status.toJson(),
      'dedupeKey': dedupeKey,
      'callVersion': callVersion,
      'attempts': attempts,
      if (providerRef != null) 'providerRef': providerRef,
      if (error != null) 'error': error,
      'createdAt': createdAt.toJson(),
      if (sentAt != null) 'sentAt': sentAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _NotificationImpl extends Notification {
  _NotificationImpl({
    _isc.UuidValue? id,
    required _isc.UuidValue ticketId,
    required _isc.UuidValue clinicId,
    required String ticketLabel,
    required _ic51rir1.NotificationKind kind,
    required _i1ikwq8c.Channel channel,
    required _ik1evhid.DeliveryStatus status,
    required String dedupeKey,
    int? callVersion,
    int? attempts,
    String? providerRef,
    String? error,
    DateTime? createdAt,
    DateTime? sentAt,
  }) : super._(
         id: id,
         ticketId: ticketId,
         clinicId: clinicId,
         ticketLabel: ticketLabel,
         kind: kind,
         channel: channel,
         status: status,
         dedupeKey: dedupeKey,
         callVersion: callVersion,
         attempts: attempts,
         providerRef: providerRef,
         error: error,
         createdAt: createdAt,
         sentAt: sentAt,
       );

  /// Returns a shallow copy of this [Notification]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Notification copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? ticketId,
    _isc.UuidValue? clinicId,
    String? ticketLabel,
    _ic51rir1.NotificationKind? kind,
    _i1ikwq8c.Channel? channel,
    _ik1evhid.DeliveryStatus? status,
    String? dedupeKey,
    int? callVersion,
    int? attempts,
    Object? providerRef = _Undefined,
    Object? error = _Undefined,
    DateTime? createdAt,
    Object? sentAt = _Undefined,
  }) {
    return Notification(
      id: id is _isc.UuidValue? ? id : this.id,
      ticketId: ticketId ?? this.ticketId,
      clinicId: clinicId ?? this.clinicId,
      ticketLabel: ticketLabel ?? this.ticketLabel,
      kind: kind ?? this.kind,
      channel: channel ?? this.channel,
      status: status ?? this.status,
      dedupeKey: dedupeKey ?? this.dedupeKey,
      callVersion: callVersion ?? this.callVersion,
      attempts: attempts ?? this.attempts,
      providerRef: providerRef is String? ? providerRef : this.providerRef,
      error: error is String? ? error : this.error,
      createdAt: createdAt ?? this.createdAt,
      sentAt: sentAt is DateTime? ? sentAt : this.sentAt,
    );
  }
}
