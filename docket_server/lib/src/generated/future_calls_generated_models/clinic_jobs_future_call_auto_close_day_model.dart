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

abstract class ClinicJobsFutureCallAutoCloseDayModel
    implements _is.SerializableModel, _is.ProtocolSerialization {
  ClinicJobsFutureCallAutoCloseDayModel._({
    required this.clinicId,
    required this.serviceDate,
  });

  factory ClinicJobsFutureCallAutoCloseDayModel({
    required _is.UuidValue clinicId,
    required String serviceDate,
  }) = _ClinicJobsFutureCallAutoCloseDayModelImpl;

  factory ClinicJobsFutureCallAutoCloseDayModel.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ClinicJobsFutureCallAutoCloseDayModel(
      clinicId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['clinicId'],
      ),
      serviceDate: jsonSerialization['serviceDate'] as String,
    );
  }

  _is.UuidValue clinicId;

  String serviceDate;

  /// Returns a shallow copy of this [ClinicJobsFutureCallAutoCloseDayModel]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ClinicJobsFutureCallAutoCloseDayModel copyWith({
    _is.UuidValue? clinicId,
    String? serviceDate,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ClinicJobsFutureCallAutoCloseDayModel',
      'clinicId': clinicId.toJson(),
      'serviceDate': serviceDate,
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

class _ClinicJobsFutureCallAutoCloseDayModelImpl
    extends ClinicJobsFutureCallAutoCloseDayModel {
  _ClinicJobsFutureCallAutoCloseDayModelImpl({
    required _is.UuidValue clinicId,
    required String serviceDate,
  }) : super._(
         clinicId: clinicId,
         serviceDate: serviceDate,
       );

  /// Returns a shallow copy of this [ClinicJobsFutureCallAutoCloseDayModel]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ClinicJobsFutureCallAutoCloseDayModel copyWith({
    _is.UuidValue? clinicId,
    String? serviceDate,
  }) {
    return ClinicJobsFutureCallAutoCloseDayModel(
      clinicId: clinicId ?? this.clinicId,
      serviceDate: serviceDate ?? this.serviceDate,
    );
  }
}
