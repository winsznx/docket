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

abstract class ClinicChanged
    implements _is.SerializableModel, _is.ProtocolSerialization {
  ClinicChanged._({required this.clinicId});

  factory ClinicChanged({required _is.UuidValue clinicId}) = _ClinicChangedImpl;

  factory ClinicChanged.fromJson(Map<String, dynamic> jsonSerialization) {
    return ClinicChanged(
      clinicId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['clinicId'],
      ),
    );
  }

  _is.UuidValue clinicId;

  /// Returns a shallow copy of this [ClinicChanged]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ClinicChanged copyWith({_is.UuidValue? clinicId});
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ClinicChanged',
      'clinicId': clinicId.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ClinicChanged',
      'clinicId': clinicId.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _ClinicChangedImpl extends ClinicChanged {
  _ClinicChangedImpl({required _is.UuidValue clinicId})
    : super._(clinicId: clinicId);

  /// Returns a shallow copy of this [ClinicChanged]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ClinicChanged copyWith({_is.UuidValue? clinicId}) {
    return ClinicChanged(clinicId: clinicId ?? this.clinicId);
  }
}
