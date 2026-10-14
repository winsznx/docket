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
import '../enums/action_outcome.dart' as _iq4q6c7t;
import '../enums/docket_error_code.dart' as _i1jhh8n2;

abstract class OutboxAction
    implements _is.SerializableModel, _is.ProtocolSerialization {
  OutboxAction._({
    _is.UuidValue? id,
    required this.seq,
    required this.actionJson,
    required this.createdAt,
    this.outcome,
    this.code,
    this.message,
    this.settledAt,
  }) : id = id ?? const _is.Uuid().v7obj();

  factory OutboxAction({
    _is.UuidValue? id,
    required int seq,
    required String actionJson,
    required DateTime createdAt,
    _iq4q6c7t.ActionOutcome? outcome,
    _i1jhh8n2.DocketErrorCode? code,
    String? message,
    DateTime? settledAt,
  }) = _OutboxActionImpl;

  factory OutboxAction.fromJson(Map<String, dynamic> jsonSerialization) {
    return OutboxAction(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      seq: jsonSerialization['seq'] as int,
      actionJson: jsonSerialization['actionJson'] as String,
      createdAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      outcome: jsonSerialization['outcome'] == null
          ? null
          : _iq4q6c7t.ActionOutcome.fromJson(
              (jsonSerialization['outcome'] as String),
            ),
      code: jsonSerialization['code'] == null
          ? null
          : _i1jhh8n2.DocketErrorCode.fromJson(
              (jsonSerialization['code'] as String),
            ),
      message: jsonSerialization['message'] as String?,
      settledAt: jsonSerialization['settledAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['settledAt']),
    );
  }

  /// The id of the object.
  _is.UuidValue? id;

  int seq;

  String actionJson;

  DateTime createdAt;

  _iq4q6c7t.ActionOutcome? outcome;

  _i1jhh8n2.DocketErrorCode? code;

  String? message;

  DateTime? settledAt;

  /// Returns a shallow copy of this [OutboxAction]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  OutboxAction copyWith({
    _is.UuidValue? id,
    int? seq,
    String? actionJson,
    DateTime? createdAt,
    _iq4q6c7t.ActionOutcome? outcome,
    _i1jhh8n2.DocketErrorCode? code,
    String? message,
    DateTime? settledAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'OutboxAction',
      if (id != null) 'id': id?.toJson(),
      'seq': seq,
      'actionJson': actionJson,
      'createdAt': createdAt.toJson(),
      if (outcome != null) 'outcome': outcome?.toJson(),
      if (code != null) 'code': code?.toJson(),
      if (message != null) 'message': message,
      if (settledAt != null) 'settledAt': settledAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'OutboxAction',
      if (id != null) 'id': id?.toJson(),
      'seq': seq,
      'actionJson': actionJson,
      'createdAt': createdAt.toJson(),
      if (outcome != null) 'outcome': outcome?.toJson(),
      if (code != null) 'code': code?.toJson(),
      if (message != null) 'message': message,
      if (settledAt != null) 'settledAt': settledAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _OutboxActionImpl extends OutboxAction {
  _OutboxActionImpl({
    _is.UuidValue? id,
    required int seq,
    required String actionJson,
    required DateTime createdAt,
    _iq4q6c7t.ActionOutcome? outcome,
    _i1jhh8n2.DocketErrorCode? code,
    String? message,
    DateTime? settledAt,
  }) : super._(
         id: id,
         seq: seq,
         actionJson: actionJson,
         createdAt: createdAt,
         outcome: outcome,
         code: code,
         message: message,
         settledAt: settledAt,
       );

  /// Returns a shallow copy of this [OutboxAction]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  OutboxAction copyWith({
    Object? id = _Undefined,
    int? seq,
    String? actionJson,
    DateTime? createdAt,
    Object? outcome = _Undefined,
    Object? code = _Undefined,
    Object? message = _Undefined,
    Object? settledAt = _Undefined,
  }) {
    return OutboxAction(
      id: id is _is.UuidValue? ? id : this.id,
      seq: seq ?? this.seq,
      actionJson: actionJson ?? this.actionJson,
      createdAt: createdAt ?? this.createdAt,
      outcome: outcome is _iq4q6c7t.ActionOutcome? ? outcome : this.outcome,
      code: code is _i1jhh8n2.DocketErrorCode? ? code : this.code,
      message: message is String? ? message : this.message,
      settledAt: settledAt is DateTime? ? settledAt : this.settledAt,
    );
  }
}
