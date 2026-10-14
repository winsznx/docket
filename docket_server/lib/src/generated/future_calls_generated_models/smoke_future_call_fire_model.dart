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

abstract class SmokeFutureCallFireModel
    implements _is.SerializableModel, _is.ProtocolSerialization {
  SmokeFutureCallFireModel._({required this.runId});

  factory SmokeFutureCallFireModel({required _is.UuidValue runId}) =
      _SmokeFutureCallFireModelImpl;

  factory SmokeFutureCallFireModel.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return SmokeFutureCallFireModel(
      runId: _is.UuidValueJsonExtension.fromJson(jsonSerialization['runId']),
    );
  }

  _is.UuidValue runId;

  /// Returns a shallow copy of this [SmokeFutureCallFireModel]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  SmokeFutureCallFireModel copyWith({_is.UuidValue? runId});
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SmokeFutureCallFireModel',
      'runId': runId.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _SmokeFutureCallFireModelImpl extends SmokeFutureCallFireModel {
  _SmokeFutureCallFireModelImpl({required _is.UuidValue runId})
    : super._(runId: runId);

  /// Returns a shallow copy of this [SmokeFutureCallFireModel]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  SmokeFutureCallFireModel copyWith({_is.UuidValue? runId}) {
    return SmokeFutureCallFireModel(runId: runId ?? this.runId);
  }
}
