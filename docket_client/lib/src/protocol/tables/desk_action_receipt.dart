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
import '../enums/action_outcome.dart' as _iq4q6c7t;
import '../enums/docket_error_code.dart' as _i1jhh8n2;

abstract class DeskActionReceipt
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  DeskActionReceipt._({
    this.id,
    required this.actionId,
    required this.deviceId,
    required this.seq,
    required this.clinicId,
    required this.outcome,
    this.code,
    this.message,
    this.ticketId,
    required this.appliedAt,
  });

  factory DeskActionReceipt({
    _isc.UuidValue? id,
    required _isc.UuidValue actionId,
    required _isc.UuidValue deviceId,
    required int seq,
    required _isc.UuidValue clinicId,
    required _iq4q6c7t.ActionOutcome outcome,
    _i1jhh8n2.DocketErrorCode? code,
    String? message,
    _isc.UuidValue? ticketId,
    required DateTime appliedAt,
  }) = _DeskActionReceiptImpl;

  factory DeskActionReceipt.fromJson(Map<String, dynamic> jsonSerialization) {
    return DeskActionReceipt(
      id: jsonSerialization['id'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      actionId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['actionId'],
      ),
      deviceId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['deviceId'],
      ),
      seq: jsonSerialization['seq'] as int,
      clinicId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['clinicId'],
      ),
      outcome: _iq4q6c7t.ActionOutcome.fromJson(
        (jsonSerialization['outcome'] as String),
      ),
      code: jsonSerialization['code'] == null
          ? null
          : _i1jhh8n2.DocketErrorCode.fromJson(
              (jsonSerialization['code'] as String),
            ),
      message: jsonSerialization['message'] as String?,
      ticketId: jsonSerialization['ticketId'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['ticketId']),
      appliedAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['appliedAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _isc.UuidValue? id;

  _isc.UuidValue actionId;

  _isc.UuidValue deviceId;

  int seq;

  _isc.UuidValue clinicId;

  _iq4q6c7t.ActionOutcome outcome;

  _i1jhh8n2.DocketErrorCode? code;

  String? message;

  _isc.UuidValue? ticketId;

  DateTime appliedAt;

  /// Returns a shallow copy of this [DeskActionReceipt]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  DeskActionReceipt copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? actionId,
    _isc.UuidValue? deviceId,
    int? seq,
    _isc.UuidValue? clinicId,
    _iq4q6c7t.ActionOutcome? outcome,
    _i1jhh8n2.DocketErrorCode? code,
    String? message,
    _isc.UuidValue? ticketId,
    DateTime? appliedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DeskActionReceipt',
      if (id != null) 'id': id?.toJson(),
      'actionId': actionId.toJson(),
      'deviceId': deviceId.toJson(),
      'seq': seq,
      'clinicId': clinicId.toJson(),
      'outcome': outcome.toJson(),
      if (code != null) 'code': code?.toJson(),
      if (message != null) 'message': message,
      if (ticketId != null) 'ticketId': ticketId?.toJson(),
      'appliedAt': appliedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DeskActionReceipt',
      if (id != null) 'id': id?.toJson(),
      'actionId': actionId.toJson(),
      'deviceId': deviceId.toJson(),
      'seq': seq,
      'clinicId': clinicId.toJson(),
      'outcome': outcome.toJson(),
      if (code != null) 'code': code?.toJson(),
      if (message != null) 'message': message,
      if (ticketId != null) 'ticketId': ticketId?.toJson(),
      'appliedAt': appliedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DeskActionReceiptImpl extends DeskActionReceipt {
  _DeskActionReceiptImpl({
    _isc.UuidValue? id,
    required _isc.UuidValue actionId,
    required _isc.UuidValue deviceId,
    required int seq,
    required _isc.UuidValue clinicId,
    required _iq4q6c7t.ActionOutcome outcome,
    _i1jhh8n2.DocketErrorCode? code,
    String? message,
    _isc.UuidValue? ticketId,
    required DateTime appliedAt,
  }) : super._(
         id: id,
         actionId: actionId,
         deviceId: deviceId,
         seq: seq,
         clinicId: clinicId,
         outcome: outcome,
         code: code,
         message: message,
         ticketId: ticketId,
         appliedAt: appliedAt,
       );

  /// Returns a shallow copy of this [DeskActionReceipt]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  DeskActionReceipt copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? actionId,
    _isc.UuidValue? deviceId,
    int? seq,
    _isc.UuidValue? clinicId,
    _iq4q6c7t.ActionOutcome? outcome,
    Object? code = _Undefined,
    Object? message = _Undefined,
    Object? ticketId = _Undefined,
    DateTime? appliedAt,
  }) {
    return DeskActionReceipt(
      id: id is _isc.UuidValue? ? id : this.id,
      actionId: actionId ?? this.actionId,
      deviceId: deviceId ?? this.deviceId,
      seq: seq ?? this.seq,
      clinicId: clinicId ?? this.clinicId,
      outcome: outcome ?? this.outcome,
      code: code is _i1jhh8n2.DocketErrorCode? ? code : this.code,
      message: message is String? ? message : this.message,
      ticketId: ticketId is _isc.UuidValue? ? ticketId : this.ticketId,
      appliedAt: appliedAt ?? this.appliedAt,
    );
  }
}
