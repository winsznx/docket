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
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
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
    required _isc.UuidValue actionId,
    required _isc.UuidValue deviceId,
    required int seq,
    required DateTime issuedAtLocal,
    required _isc.UuidValue ticketId,
    required _isc.UuidValue targetLineId,
    required _isc.UuidValue newTicketId,
  }) = _TransferActionImpl;

  factory TransferAction.fromJson(Map<String, dynamic> jsonSerialization) {
    return TransferAction(
      actionId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['actionId'],
      ),
      deviceId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['deviceId'],
      ),
      seq: jsonSerialization['seq'] as int,
      issuedAtLocal: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['issuedAtLocal'],
      ),
      ticketId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['ticketId'],
      ),
      targetLineId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['targetLineId'],
      ),
      newTicketId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['newTicketId'],
      ),
    );
  }

  _isc.UuidValue ticketId;

  _isc.UuidValue targetLineId;

  _isc.UuidValue newTicketId;

  /// Returns a shallow copy of this [TransferAction]
  /// with some or all fields replaced by the given arguments.
  @override
  @_isc.useResult
  TransferAction copyWith({
    _isc.UuidValue? actionId,
    _isc.UuidValue? deviceId,
    int? seq,
    DateTime? issuedAtLocal,
    _isc.UuidValue? ticketId,
    _isc.UuidValue? targetLineId,
    _isc.UuidValue? newTicketId,
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
    return _isc.SerializationManager.encode(this);
  }
}

class _TransferActionImpl extends TransferAction {
  _TransferActionImpl({
    required _isc.UuidValue actionId,
    required _isc.UuidValue deviceId,
    required int seq,
    required DateTime issuedAtLocal,
    required _isc.UuidValue ticketId,
    required _isc.UuidValue targetLineId,
    required _isc.UuidValue newTicketId,
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
  @_isc.useResult
  @override
  TransferAction copyWith({
    _isc.UuidValue? actionId,
    _isc.UuidValue? deviceId,
    int? seq,
    DateTime? issuedAtLocal,
    _isc.UuidValue? ticketId,
    _isc.UuidValue? targetLineId,
    _isc.UuidValue? newTicketId,
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
