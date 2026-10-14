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

abstract class TicketTimersFutureCallGraceReminderModel
    implements _is.SerializableModel, _is.ProtocolSerialization {
  TicketTimersFutureCallGraceReminderModel._({
    required this.ticketId,
    required this.callVersion,
  });

  factory TicketTimersFutureCallGraceReminderModel({
    required _is.UuidValue ticketId,
    required int callVersion,
  }) = _TicketTimersFutureCallGraceReminderModelImpl;

  factory TicketTimersFutureCallGraceReminderModel.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return TicketTimersFutureCallGraceReminderModel(
      ticketId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['ticketId'],
      ),
      callVersion: jsonSerialization['callVersion'] as int,
    );
  }

  _is.UuidValue ticketId;

  int callVersion;

  /// Returns a shallow copy of this [TicketTimersFutureCallGraceReminderModel]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  TicketTimersFutureCallGraceReminderModel copyWith({
    _is.UuidValue? ticketId,
    int? callVersion,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TicketTimersFutureCallGraceReminderModel',
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

class _TicketTimersFutureCallGraceReminderModelImpl
    extends TicketTimersFutureCallGraceReminderModel {
  _TicketTimersFutureCallGraceReminderModelImpl({
    required _is.UuidValue ticketId,
    required int callVersion,
  }) : super._(
         ticketId: ticketId,
         callVersion: callVersion,
       );

  /// Returns a shallow copy of this [TicketTimersFutureCallGraceReminderModel]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  TicketTimersFutureCallGraceReminderModel copyWith({
    _is.UuidValue? ticketId,
    int? callVersion,
  }) {
    return TicketTimersFutureCallGraceReminderModel(
      ticketId: ticketId ?? this.ticketId,
      callVersion: callVersion ?? this.callVersion,
    );
  }
}
