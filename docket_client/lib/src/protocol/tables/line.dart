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

abstract class Line
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Line._({
    this.id,
    required this.clinicId,
    required this.name,
    required this.code,
    int? defaultServiceSeconds,
    bool? acceptingJoins,
    int? version,
    int? sortOrder,
  }) : defaultServiceSeconds = defaultServiceSeconds ?? 480,
       acceptingJoins = acceptingJoins ?? true,
       version = version ?? 0,
       sortOrder = sortOrder ?? 0;

  factory Line({
    _isc.UuidValue? id,
    required _isc.UuidValue clinicId,
    required String name,
    required String code,
    int? defaultServiceSeconds,
    bool? acceptingJoins,
    int? version,
    int? sortOrder,
  }) = _LineImpl;

  factory Line.fromJson(Map<String, dynamic> jsonSerialization) {
    return Line(
      id: jsonSerialization['id'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      clinicId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['clinicId'],
      ),
      name: jsonSerialization['name'] as String,
      code: jsonSerialization['code'] as String,
      defaultServiceSeconds: jsonSerialization['defaultServiceSeconds'] as int?,
      acceptingJoins: jsonSerialization['acceptingJoins'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(
              jsonSerialization['acceptingJoins'],
            ),
      version: jsonSerialization['version'] as int?,
      sortOrder: jsonSerialization['sortOrder'] as int?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _isc.UuidValue? id;

  _isc.UuidValue clinicId;

  String name;

  String code;

  int defaultServiceSeconds;

  bool acceptingJoins;

  int version;

  int sortOrder;

  /// Returns a shallow copy of this [Line]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Line copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? clinicId,
    String? name,
    String? code,
    int? defaultServiceSeconds,
    bool? acceptingJoins,
    int? version,
    int? sortOrder,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Line',
      if (id != null) 'id': id?.toJson(),
      'clinicId': clinicId.toJson(),
      'name': name,
      'code': code,
      'defaultServiceSeconds': defaultServiceSeconds,
      'acceptingJoins': acceptingJoins,
      'version': version,
      'sortOrder': sortOrder,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Line',
      if (id != null) 'id': id?.toJson(),
      'clinicId': clinicId.toJson(),
      'name': name,
      'code': code,
      'defaultServiceSeconds': defaultServiceSeconds,
      'acceptingJoins': acceptingJoins,
      'version': version,
      'sortOrder': sortOrder,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _LineImpl extends Line {
  _LineImpl({
    _isc.UuidValue? id,
    required _isc.UuidValue clinicId,
    required String name,
    required String code,
    int? defaultServiceSeconds,
    bool? acceptingJoins,
    int? version,
    int? sortOrder,
  }) : super._(
         id: id,
         clinicId: clinicId,
         name: name,
         code: code,
         defaultServiceSeconds: defaultServiceSeconds,
         acceptingJoins: acceptingJoins,
         version: version,
         sortOrder: sortOrder,
       );

  /// Returns a shallow copy of this [Line]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Line copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? clinicId,
    String? name,
    String? code,
    int? defaultServiceSeconds,
    bool? acceptingJoins,
    int? version,
    int? sortOrder,
  }) {
    return Line(
      id: id is _isc.UuidValue? ? id : this.id,
      clinicId: clinicId ?? this.clinicId,
      name: name ?? this.name,
      code: code ?? this.code,
      defaultServiceSeconds:
          defaultServiceSeconds ?? this.defaultServiceSeconds,
      acceptingJoins: acceptingJoins ?? this.acceptingJoins,
      version: version ?? this.version,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }
}
