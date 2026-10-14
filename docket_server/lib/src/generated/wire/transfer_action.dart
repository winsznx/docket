/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

part of 'desk_action.dart';

abstract class TransferAction extends _iv35mfmj.DeskAction
    implements _is.SerializableModel, _is.ProtocolSerialization {
  TransferAction._({
    required super.actionId,
    required super.deviceId,
    required super.seq,
    required super.issuedAtLocal,
    required this.ticketId,
    required this.targetLineId,
    required this.newTicketId,
  });

  factory TransferAction({
    required _is.UuidValue actionId,
    required _is.UuidValue deviceId,
    required int seq,
    required DateTime issuedAtLocal,
    required _is.UuidValue ticketId,
    required _is.UuidValue targetLineId,
    required _is.UuidValue newTicketId,
  }) = _TransferActionImpl;

  factory TransferAction.fromJson(Map<String, dynamic> jsonSerialization) {
    return TransferAction(
      actionId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['actionId'],
      ),
      deviceId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['deviceId'],
      ),
      seq: jsonSerialization['seq'] as int,
      issuedAtLocal: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['issuedAtLocal'],
      ),
      ticketId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['ticketId'],
      ),
      targetLineId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['targetLineId'],
      ),
      newTicketId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['newTicketId'],
      ),
    );
  }

  _is.UuidValue ticketId;

  _is.UuidValue targetLineId;

  _is.UuidValue newTicketId;

  /// Returns a shallow copy of this [TransferAction]
  /// with some or all fields replaced by the given arguments.
  @override
  @_is.useResult
  TransferAction copyWith({
    _is.UuidValue? actionId,
    _is.UuidValue? deviceId,
    int? seq,
    DateTime? issuedAtLocal,
    _is.UuidValue? ticketId,
    _is.UuidValue? targetLineId,
    _is.UuidValue? newTicketId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TransferAction',
      'actionId': actionId.toJson(),
      'deviceId': deviceId.toJson(),
      'seq': seq,
      'issuedAtLocal': issuedAtLocal.toJson(),
      'ticketId': ticketId.toJson(),
      'targetLineId': targetLineId.toJson(),
      'newTicketId': newTicketId.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'TransferAction',
      'actionId': actionId.toJson(),
      'deviceId': deviceId.toJson(),
      'seq': seq,
      'issuedAtLocal': issuedAtLocal.toJson(),
      'ticketId': ticketId.toJson(),
      'targetLineId': targetLineId.toJson(),
      'newTicketId': newTicketId.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _TransferActionImpl extends TransferAction {
  _TransferActionImpl({
    required _is.UuidValue actionId,
    required _is.UuidValue deviceId,
    required int seq,
    required DateTime issuedAtLocal,
    required _is.UuidValue ticketId,
    required _is.UuidValue targetLineId,
    required _is.UuidValue newTicketId,
  }) : super._(
         actionId: actionId,
         deviceId: deviceId,
         seq: seq,
         issuedAtLocal: issuedAtLocal,
         ticketId: ticketId,
         targetLineId: targetLineId,
         newTicketId: newTicketId,
       );

  /// Returns a shallow copy of this [TransferAction]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  TransferAction copyWith({
    _is.UuidValue? actionId,
    _is.UuidValue? deviceId,
    int? seq,
    DateTime? issuedAtLocal,
    _is.UuidValue? ticketId,
    _is.UuidValue? targetLineId,
    _is.UuidValue? newTicketId,
  }) {
    return TransferAction(
      actionId: actionId ?? this.actionId,
      deviceId: deviceId ?? this.deviceId,
      seq: seq ?? this.seq,
      issuedAtLocal: issuedAtLocal ?? this.issuedAtLocal,
      ticketId: ticketId ?? this.ticketId,
      targetLineId: targetLineId ?? this.targetLineId,
      newTicketId: newTicketId ?? this.newTicketId,
    );
  }
}
