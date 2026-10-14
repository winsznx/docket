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

abstract class ServiceSample
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ServiceSample._({
    this.id,
    required this.lineId,
    required this.roomId,
    required this.serviceSeconds,
    required this.callToStartSeconds,
    required this.at,
  });

  factory ServiceSample({
    _isc.UuidValue? id,
    required _isc.UuidValue lineId,
    required _isc.UuidValue roomId,
    required int serviceSeconds,
    required int callToStartSeconds,
    required DateTime at,
  }) = _ServiceSampleImpl;

  factory ServiceSample.fromJson(Map<String, dynamic> jsonSerialization) {
    return ServiceSample(
      id: jsonSerialization['id'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      lineId: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['lineId']),
      roomId: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['roomId']),
      serviceSeconds: jsonSerialization['serviceSeconds'] as int,
      callToStartSeconds: jsonSerialization['callToStartSeconds'] as int,
      at: _isc.DateTimeJsonExtension.fromJson(jsonSerialization['at']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _isc.UuidValue? id;

  _isc.UuidValue lineId;

  _isc.UuidValue roomId;

  int serviceSeconds;

  int callToStartSeconds;

  DateTime at;

  /// Returns a shallow copy of this [ServiceSample]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ServiceSample copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? lineId,
    _isc.UuidValue? roomId,
    int? serviceSeconds,
    int? callToStartSeconds,
    DateTime? at,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ServiceSample',
      if (id != null) 'id': id?.toJson(),
      'lineId': lineId.toJson(),
      'roomId': roomId.toJson(),
      'serviceSeconds': serviceSeconds,
      'callToStartSeconds': callToStartSeconds,
      'at': at.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ServiceSample',
      if (id != null) 'id': id?.toJson(),
      'lineId': lineId.toJson(),
      'roomId': roomId.toJson(),
      'serviceSeconds': serviceSeconds,
      'callToStartSeconds': callToStartSeconds,
      'at': at.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ServiceSampleImpl extends ServiceSample {
  _ServiceSampleImpl({
    _isc.UuidValue? id,
    required _isc.UuidValue lineId,
    required _isc.UuidValue roomId,
    required int serviceSeconds,
    required int callToStartSeconds,
    required DateTime at,
  }) : super._(
         id: id,
         lineId: lineId,
         roomId: roomId,
         serviceSeconds: serviceSeconds,
         callToStartSeconds: callToStartSeconds,
         at: at,
       );

  /// Returns a shallow copy of this [ServiceSample]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ServiceSample copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? lineId,
    _isc.UuidValue? roomId,
    int? serviceSeconds,
    int? callToStartSeconds,
    DateTime? at,
  }) {
    return ServiceSample(
      id: id is _isc.UuidValue? ? id : this.id,
      lineId: lineId ?? this.lineId,
      roomId: roomId ?? this.roomId,
      serviceSeconds: serviceSeconds ?? this.serviceSeconds,
      callToStartSeconds: callToStartSeconds ?? this.callToStartSeconds,
      at: at ?? this.at,
    );
  }
}
