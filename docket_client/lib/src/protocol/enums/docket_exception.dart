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
import '../enums/docket_error_code.dart' as _i1jhh8n2;

abstract class DocketException
    implements
        _isc.SerializableException,
        _isc.SerializableModel,
        _isc.ProtocolSerialization {
  DocketException._({
    required this.code,
    required this.message,
  });

  factory DocketException({
    required _i1jhh8n2.DocketErrorCode code,
    required String message,
  }) = _DocketExceptionImpl;

  factory DocketException.fromJson(Map<String, dynamic> jsonSerialization) {
    return DocketException(
      code: _i1jhh8n2.DocketErrorCode.fromJson(
        (jsonSerialization['code'] as String),
      ),
      message: jsonSerialization['message'] as String,
    );
  }

  _i1jhh8n2.DocketErrorCode code;

  String message;

  /// Returns a shallow copy of this [DocketException]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  DocketException copyWith({
    _i1jhh8n2.DocketErrorCode? code,
    String? message,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DocketException',
      'code': code.toJson(),
      'message': message,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DocketException',
      'code': code.toJson(),
      'message': message,
    };
  }

  @override
  String toString() {
    return 'DocketException(code: $code, message: $message)';
  }
}

class _DocketExceptionImpl extends DocketException {
  _DocketExceptionImpl({
    required _i1jhh8n2.DocketErrorCode code,
    required String message,
  }) : super._(
         code: code,
         message: message,
       );

  /// Returns a shallow copy of this [DocketException]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  DocketException copyWith({
    _i1jhh8n2.DocketErrorCode? code,
    String? message,
  }) {
    return DocketException(
      code: code ?? this.code,
      message: message ?? this.message,
    );
  }
}
