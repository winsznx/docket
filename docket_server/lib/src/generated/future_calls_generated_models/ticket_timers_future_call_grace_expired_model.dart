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

abstract class TicketTimersFutureCallGraceExpiredModel
    implements _is.SerializableModel, _is.ProtocolSerialization {
  TicketTimersFutureCallGraceExpiredModel._({
    required this.ticketId,
    required this.callVersion,
  });

  factory TicketTimersFutureCallGraceExpiredModel({
    required _is.UuidValue ticketId,
    required int callVersion,
  }) = _TicketTimersFutureCallGraceExpiredModelImpl;

  factory TicketTimersFutureCallGraceExpiredModel.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return TicketTimersFutureCallGraceExpiredModel(
      ticketId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['ticketId'],
      ),
      callVersion: jsonSerialization['callVersion'] as int,
    );
  }

  _is.UuidValue ticketId;

  int callVersion;

  /// Returns a shallow copy of this [TicketTimersFutureCallGraceExpiredModel]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  TicketTimersFutureCallGraceExpiredModel copyWith({
    _is.UuidValue? ticketId,
    int? callVersion,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TicketTimersFutureCallGraceExpiredModel',
      'ticketId': ticketId.toJson(),
      'callVersion': callVersion,
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

class _TicketTimersFutureCallGraceExpiredModelImpl
    extends TicketTimersFutureCallGraceExpiredModel {
  _TicketTimersFutureCallGraceExpiredModelImpl({
    required _is.UuidValue ticketId,
    required int callVersion,
  }) : super._(
         ticketId: ticketId,
         callVersion: callVersion,
       );

  /// Returns a shallow copy of this [TicketTimersFutureCallGraceExpiredModel]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  TicketTimersFutureCallGraceExpiredModel copyWith({
    _is.UuidValue? ticketId,
    int? callVersion,
  }) {
    return TicketTimersFutureCallGraceExpiredModel(
      ticketId: ticketId ?? this.ticketId,
      callVersion: callVersion ?? this.callVersion,
    );
  }
}
