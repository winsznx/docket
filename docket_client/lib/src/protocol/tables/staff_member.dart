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
import '../enums/staff_role.dart' as _igwmwxyi;

abstract class StaffMember
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  StaffMember._({
    this.id,
    required this.clinicId,
    required this.userIdentifier,
    required this.displayName,
    required this.role,
    bool? active,
    DateTime? createdAt,
  }) : active = active ?? true,
       createdAt = createdAt ?? DateTime.now();

  factory StaffMember({
    _isc.UuidValue? id,
    required _isc.UuidValue clinicId,
    required String userIdentifier,
    required String displayName,
    required _igwmwxyi.StaffRole role,
    bool? active,
    DateTime? createdAt,
  }) = _StaffMemberImpl;

  factory StaffMember.fromJson(Map<String, dynamic> jsonSerialization) {
    return StaffMember(
      id: jsonSerialization['id'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      clinicId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['clinicId'],
      ),
      userIdentifier: jsonSerialization['userIdentifier'] as String,
      displayName: jsonSerialization['displayName'] as String,
      role: _igwmwxyi.StaffRole.fromJson((jsonSerialization['role'] as String)),
      active: jsonSerialization['active'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['active']),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _isc.UuidValue? id;

  _isc.UuidValue clinicId;

  String userIdentifier;

  String displayName;

  _igwmwxyi.StaffRole role;

  bool active;

  DateTime createdAt;

  /// Returns a shallow copy of this [StaffMember]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  StaffMember copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? clinicId,
    String? userIdentifier,
    String? displayName,
    _igwmwxyi.StaffRole? role,
    bool? active,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'StaffMember',
      if (id != null) 'id': id?.toJson(),
      'clinicId': clinicId.toJson(),
      'userIdentifier': userIdentifier,
      'displayName': displayName,
      'role': role.toJson(),
      'active': active,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'StaffMember',
      if (id != null) 'id': id?.toJson(),
      'clinicId': clinicId.toJson(),
      'userIdentifier': userIdentifier,
      'displayName': displayName,
      'role': role.toJson(),
      'active': active,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _StaffMemberImpl extends StaffMember {
  _StaffMemberImpl({
    _isc.UuidValue? id,
    required _isc.UuidValue clinicId,
    required String userIdentifier,
    required String displayName,
    required _igwmwxyi.StaffRole role,
    bool? active,
    DateTime? createdAt,
  }) : super._(
         id: id,
         clinicId: clinicId,
         userIdentifier: userIdentifier,
         displayName: displayName,
         role: role,
         active: active,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [StaffMember]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  StaffMember copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? clinicId,
    String? userIdentifier,
    String? displayName,
    _igwmwxyi.StaffRole? role,
    bool? active,
    DateTime? createdAt,
  }) {
    return StaffMember(
      id: id is _isc.UuidValue? ? id : this.id,
      clinicId: clinicId ?? this.clinicId,
      userIdentifier: userIdentifier ?? this.userIdentifier,
      displayName: displayName ?? this.displayName,
      role: role ?? this.role,
      active: active ?? this.active,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
