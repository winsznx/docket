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

abstract class DispatchFutureCallSendModel
    implements _is.SerializableModel, _is.ProtocolSerialization {
  DispatchFutureCallSendModel._({required this.notificationId});

  factory DispatchFutureCallSendModel({required _is.UuidValue notificationId}) =
      _DispatchFutureCallSendModelImpl;

  factory DispatchFutureCallSendModel.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return DispatchFutureCallSendModel(
      notificationId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['notificationId'],
      ),
    );
  }

  _is.UuidValue notificationId;

  /// Returns a shallow copy of this [DispatchFutureCallSendModel]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  DispatchFutureCallSendModel copyWith({_is.UuidValue? notificationId});
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DispatchFutureCallSendModel',
      'notificationId': notificationId.toJson(),
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

class _DispatchFutureCallSendModelImpl extends DispatchFutureCallSendModel {
  _DispatchFutureCallSendModelImpl({required _is.UuidValue notificationId})
    : super._(notificationId: notificationId);

  /// Returns a shallow copy of this [DispatchFutureCallSendModel]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  DispatchFutureCallSendModel copyWith({_is.UuidValue? notificationId}) {
    return DispatchFutureCallSendModel(
      notificationId: notificationId ?? this.notificationId,
    );
  }
}
