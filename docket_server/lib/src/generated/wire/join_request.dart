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

abstract class JoinRequest
    implements _is.SerializableModel, _is.ProtocolSerialization {
  JoinRequest._({
    required this.clinicSlug,
    required this.lineId,
    this.displayName,
    this.phoneE164,
    required this.smsConsent,
  });

  factory JoinRequest({
    required String clinicSlug,
    required _is.UuidValue lineId,
    String? displayName,
    String? phoneE164,
    required bool smsConsent,
  }) = _JoinRequestImpl;

  factory JoinRequest.fromJson(Map<String, dynamic> jsonSerialization) {
    return JoinRequest(
      clinicSlug: jsonSerialization['clinicSlug'] as String,
      lineId: _is.UuidValueJsonExtension.fromJson(jsonSerialization['lineId']),
      displayName: jsonSerialization['displayName'] as String?,
      phoneE164: jsonSerialization['phoneE164'] as String?,
      smsConsent: _is.BoolJsonExtension.fromJson(
        jsonSerialization['smsConsent'],
      ),
    );
  }

  String clinicSlug;

  _is.UuidValue lineId;

  String? displayName;

  String? phoneE164;

  bool smsConsent;

  /// Returns a shallow copy of this [JoinRequest]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  JoinRequest copyWith({
    String? clinicSlug,
    _is.UuidValue? lineId,
    String? displayName,
    String? phoneE164,
    bool? smsConsent,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'JoinRequest',
      'clinicSlug': clinicSlug,
      'lineId': lineId.toJson(),
      if (displayName != null) 'displayName': displayName,
      if (phoneE164 != null) 'phoneE164': phoneE164,
      'smsConsent': smsConsent,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'JoinRequest',
      'clinicSlug': clinicSlug,
      'lineId': lineId.toJson(),
      if (displayName != null) 'displayName': displayName,
      if (phoneE164 != null) 'phoneE164': phoneE164,
      'smsConsent': smsConsent,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _JoinRequestImpl extends JoinRequest {
  _JoinRequestImpl({
    required String clinicSlug,
    required _is.UuidValue lineId,
    String? displayName,
    String? phoneE164,
    required bool smsConsent,
  }) : super._(
         clinicSlug: clinicSlug,
         lineId: lineId,
         displayName: displayName,
         phoneE164: phoneE164,
         smsConsent: smsConsent,
       );

  /// Returns a shallow copy of this [JoinRequest]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  JoinRequest copyWith({
    String? clinicSlug,
    _is.UuidValue? lineId,
    Object? displayName = _Undefined,
    Object? phoneE164 = _Undefined,
    bool? smsConsent,
  }) {
    return JoinRequest(
      clinicSlug: clinicSlug ?? this.clinicSlug,
      lineId: lineId ?? this.lineId,
      displayName: displayName is String? ? displayName : this.displayName,
      phoneE164: phoneE164 is String? ? phoneE164 : this.phoneE164,
      smsConsent: smsConsent ?? this.smsConsent,
    );
  }
}
