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

abstract class PushSubscriptionInput
    implements _is.SerializableModel, _is.ProtocolSerialization {
  PushSubscriptionInput._({
    required this.endpoint,
    required this.p256dh,
    required this.auth,
  });

  factory PushSubscriptionInput({
    required String endpoint,
    required String p256dh,
    required String auth,
  }) = _PushSubscriptionInputImpl;

  factory PushSubscriptionInput.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return PushSubscriptionInput(
      endpoint: jsonSerialization['endpoint'] as String,
      p256dh: jsonSerialization['p256dh'] as String,
      auth: jsonSerialization['auth'] as String,
    );
  }

  String endpoint;

  String p256dh;

  String auth;

  /// Returns a shallow copy of this [PushSubscriptionInput]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  PushSubscriptionInput copyWith({
    String? endpoint,
    String? p256dh,
    String? auth,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PushSubscriptionInput',
      'endpoint': endpoint,
      'p256dh': p256dh,
      'auth': auth,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PushSubscriptionInput',
      'endpoint': endpoint,
      'p256dh': p256dh,
      'auth': auth,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _PushSubscriptionInputImpl extends PushSubscriptionInput {
  _PushSubscriptionInputImpl({
    required String endpoint,
    required String p256dh,
    required String auth,
  }) : super._(
         endpoint: endpoint,
         p256dh: p256dh,
         auth: auth,
       );

  /// Returns a shallow copy of this [PushSubscriptionInput]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  PushSubscriptionInput copyWith({
    String? endpoint,
    String? p256dh,
    String? auth,
  }) {
    return PushSubscriptionInput(
      endpoint: endpoint ?? this.endpoint,
      p256dh: p256dh ?? this.p256dh,
      auth: auth ?? this.auth,
    );
  }
}
