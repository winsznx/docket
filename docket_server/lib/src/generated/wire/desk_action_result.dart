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
import 'package:docket_server/src/generated/protocol.dart' as _in3ld48g;
import 'package:serverpod/serverpod.dart' as _is;
import '../enums/action_outcome.dart' as _iq4q6c7t;
import '../enums/docket_error_code.dart' as _i1jhh8n2;
import '../wire/ticket_view.dart' as _icukv18l;

abstract class DeskActionResult
    implements _is.SerializableModel, _is.ProtocolSerialization {
  DeskActionResult._({
    required this.actionId,
    required this.outcome,
    this.code,
    this.message,
    this.ticket,
    this.ticketUrl,
  });

  factory DeskActionResult({
    required _is.UuidValue actionId,
    required _iq4q6c7t.ActionOutcome outcome,
    _i1jhh8n2.DocketErrorCode? code,
    String? message,
    _icukv18l.TicketView? ticket,
    String? ticketUrl,
  }) = _DeskActionResultImpl;

  factory DeskActionResult.fromJson(Map<String, dynamic> jsonSerialization) {
    return DeskActionResult(
      actionId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['actionId'],
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
      ticket: jsonSerialization['ticket'] == null
          ? null
          : _in3ld48g.Protocol().deserialize<_icukv18l.TicketView>(
              jsonSerialization['ticket'],
            ),
      ticketUrl: jsonSerialization['ticketUrl'] as String?,
    );
  }

  _is.UuidValue actionId;

  _iq4q6c7t.ActionOutcome outcome;

  _i1jhh8n2.DocketErrorCode? code;

  String? message;

  _icukv18l.TicketView? ticket;

  String? ticketUrl;

  /// Returns a shallow copy of this [DeskActionResult]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  DeskActionResult copyWith({
    _is.UuidValue? actionId,
    _iq4q6c7t.ActionOutcome? outcome,
    _i1jhh8n2.DocketErrorCode? code,
    String? message,
    _icukv18l.TicketView? ticket,
    String? ticketUrl,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DeskActionResult',
      'actionId': actionId.toJson(),
      'outcome': outcome.toJson(),
      if (code != null) 'code': code?.toJson(),
      if (message != null) 'message': message,
      if (ticket != null) 'ticket': ticket?.toJson(),
      if (ticketUrl != null) 'ticketUrl': ticketUrl,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DeskActionResult',
      'actionId': actionId.toJson(),
      'outcome': outcome.toJson(),
      if (code != null) 'code': code?.toJson(),
      if (message != null) 'message': message,
      if (ticket != null) 'ticket': ticket?.toJsonForProtocol(),
      if (ticketUrl != null) 'ticketUrl': ticketUrl,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DeskActionResultImpl extends DeskActionResult {
  _DeskActionResultImpl({
    required _is.UuidValue actionId,
    required _iq4q6c7t.ActionOutcome outcome,
    _i1jhh8n2.DocketErrorCode? code,
    String? message,
    _icukv18l.TicketView? ticket,
    String? ticketUrl,
  }) : super._(
         actionId: actionId,
         outcome: outcome,
         code: code,
         message: message,
         ticket: ticket,
         ticketUrl: ticketUrl,
       );

  /// Returns a shallow copy of this [DeskActionResult]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  DeskActionResult copyWith({
    _is.UuidValue? actionId,
    _iq4q6c7t.ActionOutcome? outcome,
    Object? code = _Undefined,
    Object? message = _Undefined,
    Object? ticket = _Undefined,
    Object? ticketUrl = _Undefined,
  }) {
    return DeskActionResult(
      actionId: actionId ?? this.actionId,
      outcome: outcome ?? this.outcome,
      code: code is _i1jhh8n2.DocketErrorCode? ? code : this.code,
      message: message is String? ? message : this.message,
      ticket: ticket is _icukv18l.TicketView?
          ? ticket
          : this.ticket?.copyWith(),
      ticketUrl: ticketUrl is String? ? ticketUrl : this.ticketUrl,
    );
  }
}
