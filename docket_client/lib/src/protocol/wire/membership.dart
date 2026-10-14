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

abstract class Membership
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Membership._({
    required this.clinicId,
    required this.clinicName,
    required this.role,
  });

  factory Membership({
    required _isc.UuidValue clinicId,
    required String clinicName,
    required _igwmwxyi.StaffRole role,
  }) = _MembershipImpl;

  factory Membership.fromJson(Map<String, dynamic> jsonSerialization) {
    return Membership(
      clinicId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['clinicId'],
      ),
      clinicName: jsonSerialization['clinicName'] as String,
      role: _igwmwxyi.StaffRole.fromJson((jsonSerialization['role'] as String)),
    );
  }

  _isc.UuidValue clinicId;

  String clinicName;

  _igwmwxyi.StaffRole role;

  /// Returns a shallow copy of this [Membership]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Membership copyWith({
    _isc.UuidValue? clinicId,
    String? clinicName,
    _igwmwxyi.StaffRole? role,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Membership',
      'clinicId': clinicId.toJson(),
      'clinicName': clinicName,
      'role': role.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Membership',
      'clinicId': clinicId.toJson(),
      'clinicName': clinicName,
      'role': role.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _MembershipImpl extends Membership {
  _MembershipImpl({
    required _isc.UuidValue clinicId,
    required String clinicName,
    required _igwmwxyi.StaffRole role,
  }) : super._(
         clinicId: clinicId,
         clinicName: clinicName,
         role: role,
       );

  /// Returns a shallow copy of this [Membership]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Membership copyWith({
    _isc.UuidValue? clinicId,
    String? clinicName,
    _igwmwxyi.StaffRole? role,
  }) {
    return Membership(
      clinicId: clinicId ?? this.clinicId,
      clinicName: clinicName ?? this.clinicName,
      role: role ?? this.role,
    );
  }
}
