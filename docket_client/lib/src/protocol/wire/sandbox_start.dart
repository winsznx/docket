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

abstract class SandboxStart
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  SandboxStart._({
    required this.clinicId,
    required this.clinicSlug,
    required this.sandboxToken,
    required this.boardUrl,
    required this.joinUrl,
    required this.expiresAt,
  });

  factory SandboxStart({
    required _isc.UuidValue clinicId,
    required String clinicSlug,
    required String sandboxToken,
    required String boardUrl,
    required String joinUrl,
    required DateTime expiresAt,
  }) = _SandboxStartImpl;

  factory SandboxStart.fromJson(Map<String, dynamic> jsonSerialization) {
    return SandboxStart(
      clinicId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['clinicId'],
      ),
      clinicSlug: jsonSerialization['clinicSlug'] as String,
      sandboxToken: jsonSerialization['sandboxToken'] as String,
      boardUrl: jsonSerialization['boardUrl'] as String,
      joinUrl: jsonSerialization['joinUrl'] as String,
      expiresAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['expiresAt'],
      ),
    );
  }

  _isc.UuidValue clinicId;

  String clinicSlug;

  String sandboxToken;

  String boardUrl;

  String joinUrl;

  DateTime expiresAt;

  /// Returns a shallow copy of this [SandboxStart]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  SandboxStart copyWith({
    _isc.UuidValue? clinicId,
    String? clinicSlug,
    String? sandboxToken,
    String? boardUrl,
    String? joinUrl,
    DateTime? expiresAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SandboxStart',
      'clinicId': clinicId.toJson(),
      'clinicSlug': clinicSlug,
      'sandboxToken': sandboxToken,
      'boardUrl': boardUrl,
      'joinUrl': joinUrl,
      'expiresAt': expiresAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SandboxStart',
      'clinicId': clinicId.toJson(),
      'clinicSlug': clinicSlug,
      'sandboxToken': sandboxToken,
      'boardUrl': boardUrl,
      'joinUrl': joinUrl,
      'expiresAt': expiresAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _SandboxStartImpl extends SandboxStart {
  _SandboxStartImpl({
    required _isc.UuidValue clinicId,
    required String clinicSlug,
    required String sandboxToken,
    required String boardUrl,
    required String joinUrl,
    required DateTime expiresAt,
  }) : super._(
         clinicId: clinicId,
         clinicSlug: clinicSlug,
         sandboxToken: sandboxToken,
         boardUrl: boardUrl,
         joinUrl: joinUrl,
         expiresAt: expiresAt,
       );

  /// Returns a shallow copy of this [SandboxStart]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  SandboxStart copyWith({
    _isc.UuidValue? clinicId,
    String? clinicSlug,
    String? sandboxToken,
    String? boardUrl,
    String? joinUrl,
    DateTime? expiresAt,
  }) {
    return SandboxStart(
      clinicId: clinicId ?? this.clinicId,
      clinicSlug: clinicSlug ?? this.clinicSlug,
      sandboxToken: sandboxToken ?? this.sandboxToken,
      boardUrl: boardUrl ?? this.boardUrl,
      joinUrl: joinUrl ?? this.joinUrl,
      expiresAt: expiresAt ?? this.expiresAt,
    );
  }
}
