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

abstract class CloseDayAction extends _iv35mfmj.DeskAction
    implements _is.SerializableModel, _is.ProtocolSerialization {
  CloseDayAction._({
    required super.actionId,
    required super.deviceId,
    required super.seq,
    required super.issuedAtLocal,
    required this.clinicId,
  });

  factory CloseDayAction({
    required _is.UuidValue actionId,
    required _is.UuidValue deviceId,
    required int seq,
    required DateTime issuedAtLocal,
    required _is.UuidValue clinicId,
  }) = _CloseDayActionImpl;

  factory CloseDayAction.fromJson(Map<String, dynamic> jsonSerialization) {
    return CloseDayAction(
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
      clinicId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['clinicId'],
      ),
    );
  }

  _is.UuidValue clinicId;

  /// Returns a shallow copy of this [CloseDayAction]
  /// with some or all fields replaced by the given arguments.
  @override
  @_is.useResult
  CloseDayAction copyWith({
    _is.UuidValue? actionId,
    _is.UuidValue? deviceId,
    int? seq,
    DateTime? issuedAtLocal,
    _is.UuidValue? clinicId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CloseDayAction',
      'actionId': actionId.toJson(),
      'deviceId': deviceId.toJson(),
      'seq': seq,
      'issuedAtLocal': issuedAtLocal.toJson(),
      'clinicId': clinicId.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CloseDayAction',
      'actionId': actionId.toJson(),
      'deviceId': deviceId.toJson(),
      'seq': seq,
      'issuedAtLocal': issuedAtLocal.toJson(),
      'clinicId': clinicId.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _CloseDayActionImpl extends CloseDayAction {
  _CloseDayActionImpl({
    required _is.UuidValue actionId,
    required _is.UuidValue deviceId,
    required int seq,
    required DateTime issuedAtLocal,
    required _is.UuidValue clinicId,
  }) : super._(
         actionId: actionId,
         deviceId: deviceId,
         seq: seq,
         issuedAtLocal: issuedAtLocal,
         clinicId: clinicId,
       );

  /// Returns a shallow copy of this [CloseDayAction]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  CloseDayAction copyWith({
    _is.UuidValue? actionId,
    _is.UuidValue? deviceId,
    int? seq,
    DateTime? issuedAtLocal,
    _is.UuidValue? clinicId,
  }) {
    return CloseDayAction(
      actionId: actionId ?? this.actionId,
      deviceId: deviceId ?? this.deviceId,
      seq: seq ?? this.seq,
      issuedAtLocal: issuedAtLocal ?? this.issuedAtLocal,
      clinicId: clinicId ?? this.clinicId,
    );
  }
}
