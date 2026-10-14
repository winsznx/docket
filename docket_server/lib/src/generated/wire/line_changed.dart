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

abstract class LineChanged
    implements _is.SerializableModel, _is.ProtocolSerialization {
  LineChanged._({
    required this.lineId,
    required this.version,
    required this.reason,
  });

  factory LineChanged({
    required _is.UuidValue lineId,
    required int version,
    required String reason,
  }) = _LineChangedImpl;

  factory LineChanged.fromJson(Map<String, dynamic> jsonSerialization) {
    return LineChanged(
      lineId: _is.UuidValueJsonExtension.fromJson(jsonSerialization['lineId']),
      version: jsonSerialization['version'] as int,
      reason: jsonSerialization['reason'] as String,
    );
  }

  _is.UuidValue lineId;

  int version;

  String reason;

  /// Returns a shallow copy of this [LineChanged]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  LineChanged copyWith({
    _is.UuidValue? lineId,
    int? version,
    String? reason,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'LineChanged',
      'lineId': lineId.toJson(),
      'version': version,
      'reason': reason,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'LineChanged',
      'lineId': lineId.toJson(),
      'version': version,
      'reason': reason,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _LineChangedImpl extends LineChanged {
  _LineChangedImpl({
    required _is.UuidValue lineId,
    required int version,
    required String reason,
  }) : super._(
         lineId: lineId,
         version: version,
         reason: reason,
       );

  /// Returns a shallow copy of this [LineChanged]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  LineChanged copyWith({
    _is.UuidValue? lineId,
    int? version,
    String? reason,
  }) {
    return LineChanged(
      lineId: lineId ?? this.lineId,
      version: version ?? this.version,
      reason: reason ?? this.reason,
    );
  }
}
