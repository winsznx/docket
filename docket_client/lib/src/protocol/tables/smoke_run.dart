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

abstract class SmokeRun
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  SmokeRun._({
    this.id,
    required this.label,
    required this.scheduledFor,
    this.firedAt,
    this.serverId,
  });

  factory SmokeRun({
    _isc.UuidValue? id,
    required String label,
    required DateTime scheduledFor,
    DateTime? firedAt,
    String? serverId,
  }) = _SmokeRunImpl;

  factory SmokeRun.fromJson(Map<String, dynamic> jsonSerialization) {
    return SmokeRun(
      id: jsonSerialization['id'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      label: jsonSerialization['label'] as String,
      scheduledFor: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['scheduledFor'],
      ),
      firedAt: jsonSerialization['firedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['firedAt']),
      serverId: jsonSerialization['serverId'] as String?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _isc.UuidValue? id;

  String label;

  DateTime scheduledFor;

  DateTime? firedAt;

  String? serverId;

  /// Returns a shallow copy of this [SmokeRun]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  SmokeRun copyWith({
    _isc.UuidValue? id,
    String? label,
    DateTime? scheduledFor,
    DateTime? firedAt,
    String? serverId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SmokeRun',
      if (id != null) 'id': id?.toJson(),
      'label': label,
      'scheduledFor': scheduledFor.toJson(),
      if (firedAt != null) 'firedAt': firedAt?.toJson(),
      if (serverId != null) 'serverId': serverId,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SmokeRun',
      if (id != null) 'id': id?.toJson(),
      'label': label,
      'scheduledFor': scheduledFor.toJson(),
      if (firedAt != null) 'firedAt': firedAt?.toJson(),
      if (serverId != null) 'serverId': serverId,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SmokeRunImpl extends SmokeRun {
  _SmokeRunImpl({
    _isc.UuidValue? id,
    required String label,
    required DateTime scheduledFor,
    DateTime? firedAt,
    String? serverId,
  }) : super._(
         id: id,
         label: label,
         scheduledFor: scheduledFor,
         firedAt: firedAt,
         serverId: serverId,
       );

  /// Returns a shallow copy of this [SmokeRun]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  SmokeRun copyWith({
    Object? id = _Undefined,
    String? label,
    DateTime? scheduledFor,
    Object? firedAt = _Undefined,
    Object? serverId = _Undefined,
  }) {
    return SmokeRun(
      id: id is _isc.UuidValue? ? id : this.id,
      label: label ?? this.label,
      scheduledFor: scheduledFor ?? this.scheduledFor,
      firedAt: firedAt is DateTime? ? firedAt : this.firedAt,
      serverId: serverId is String? ? serverId : this.serverId,
    );
  }
}
