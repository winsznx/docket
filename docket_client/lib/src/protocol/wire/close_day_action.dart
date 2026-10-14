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
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  CloseDayAction._({
    required super.actionId,
    required super.deviceId,
    required super.seq,
    required super.issuedAtLocal,
    required this.clinicId,
  });

  factory CloseDayAction({
    required _isc.UuidValue actionId,
    required _isc.UuidValue deviceId,
    required int seq,
    required DateTime issuedAtLocal,
    required _isc.UuidValue clinicId,
  }) = _CloseDayActionImpl;

  factory CloseDayAction.fromJson(Map<String, dynamic> jsonSerialization) {
    return CloseDayAction(
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
      clinicId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['clinicId'],
      ),
    );
  }

  _isc.UuidValue clinicId;

  /// Returns a shallow copy of this [CloseDayAction]
  /// with some or all fields replaced by the given arguments.
  @override
  @_isc.useResult
  CloseDayAction copyWith({
    _isc.UuidValue? actionId,
    _isc.UuidValue? deviceId,
    int? seq,
    DateTime? issuedAtLocal,
    _isc.UuidValue? clinicId,
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
    return _isc.SerializationManager.encode(this);
  }
}

class _CloseDayActionImpl extends CloseDayAction {
  _CloseDayActionImpl({
    required _isc.UuidValue actionId,
    required _isc.UuidValue deviceId,
    required int seq,
    required DateTime issuedAtLocal,
    required _isc.UuidValue clinicId,
  }) : super._(
         actionId: actionId,
         deviceId: deviceId,
         seq: seq,
         issuedAtLocal: issuedAtLocal,
         clinicId: clinicId,
       );

  /// Returns a shallow copy of this [CloseDayAction]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  CloseDayAction copyWith({
    _isc.UuidValue? actionId,
    _isc.UuidValue? deviceId,
    int? seq,
    DateTime? issuedAtLocal,
    _isc.UuidValue? clinicId,
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
