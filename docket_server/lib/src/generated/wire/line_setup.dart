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

abstract class LineSetup
    implements _is.SerializableModel, _is.ProtocolSerialization {
  LineSetup._({
    required this.name,
    required this.code,
    required this.defaultServiceSeconds,
  });

  factory LineSetup({
    required String name,
    required String code,
    required int defaultServiceSeconds,
  }) = _LineSetupImpl;

  factory LineSetup.fromJson(Map<String, dynamic> jsonSerialization) {
    return LineSetup(
      name: jsonSerialization['name'] as String,
      code: jsonSerialization['code'] as String,
      defaultServiceSeconds: jsonSerialization['defaultServiceSeconds'] as int,
    );
  }

  String name;

  String code;

  int defaultServiceSeconds;

  /// Returns a shallow copy of this [LineSetup]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  LineSetup copyWith({
    String? name,
    String? code,
    int? defaultServiceSeconds,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'LineSetup',
      'name': name,
      'code': code,
      'defaultServiceSeconds': defaultServiceSeconds,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'LineSetup',
      'name': name,
      'code': code,
      'defaultServiceSeconds': defaultServiceSeconds,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _LineSetupImpl extends LineSetup {
  _LineSetupImpl({
    required String name,
    required String code,
    required int defaultServiceSeconds,
  }) : super._(
         name: name,
         code: code,
         defaultServiceSeconds: defaultServiceSeconds,
       );

  /// Returns a shallow copy of this [LineSetup]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  LineSetup copyWith({
    String? name,
    String? code,
    int? defaultServiceSeconds,
  }) {
    return LineSetup(
      name: name ?? this.name,
      code: code ?? this.code,
      defaultServiceSeconds:
          defaultServiceSeconds ?? this.defaultServiceSeconds,
    );
  }
}
