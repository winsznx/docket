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
import 'package:serverpod/serverpod.dart' as _is;
import '../enums/staff_role.dart' as _igwmwxyi;

abstract class StaffInviteView
    implements _is.SerializableModel, _is.ProtocolSerialization {
  StaffInviteView._({
    required this.inviteUrl,
    required this.role,
    required this.expiresAt,
  });

  factory StaffInviteView({
    required String inviteUrl,
    required _igwmwxyi.StaffRole role,
    required DateTime expiresAt,
  }) = _StaffInviteViewImpl;

  factory StaffInviteView.fromJson(Map<String, dynamic> jsonSerialization) {
    return StaffInviteView(
      inviteUrl: jsonSerialization['inviteUrl'] as String,
      role: _igwmwxyi.StaffRole.fromJson((jsonSerialization['role'] as String)),
      expiresAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['expiresAt'],
      ),
    );
  }

  String inviteUrl;

  _igwmwxyi.StaffRole role;

  DateTime expiresAt;

  /// Returns a shallow copy of this [StaffInviteView]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  StaffInviteView copyWith({
    String? inviteUrl,
    _igwmwxyi.StaffRole? role,
    DateTime? expiresAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'StaffInviteView',
      'inviteUrl': inviteUrl,
      'role': role.toJson(),
      'expiresAt': expiresAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'StaffInviteView',
      'inviteUrl': inviteUrl,
      'role': role.toJson(),
      'expiresAt': expiresAt.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _StaffInviteViewImpl extends StaffInviteView {
  _StaffInviteViewImpl({
    required String inviteUrl,
    required _igwmwxyi.StaffRole role,
    required DateTime expiresAt,
  }) : super._(
         inviteUrl: inviteUrl,
         role: role,
         expiresAt: expiresAt,
       );

  /// Returns a shallow copy of this [StaffInviteView]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  StaffInviteView copyWith({
    String? inviteUrl,
    _igwmwxyi.StaffRole? role,
    DateTime? expiresAt,
  }) {
    return StaffInviteView(
      inviteUrl: inviteUrl ?? this.inviteUrl,
      role: role ?? this.role,
      expiresAt: expiresAt ?? this.expiresAt,
    );
  }
}
