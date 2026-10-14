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

abstract class RoomSetup
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  RoomSetup._({
    required this.name,
    required this.lineCode,
  });

  factory RoomSetup({
    required String name,
    required String lineCode,
  }) = _RoomSetupImpl;

  factory RoomSetup.fromJson(Map<String, dynamic> jsonSerialization) {
    return RoomSetup(
      name: jsonSerialization['name'] as String,
      lineCode: jsonSerialization['lineCode'] as String,
    );
  }

  String name;

  String lineCode;

  /// Returns a shallow copy of this [RoomSetup]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  RoomSetup copyWith({
    String? name,
    String? lineCode,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RoomSetup',
      'name': name,
      'lineCode': lineCode,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'RoomSetup',
      'name': name,
      'lineCode': lineCode,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _RoomSetupImpl extends RoomSetup {
  _RoomSetupImpl({
    required String name,
    required String lineCode,
  }) : super._(
         name: name,
         lineCode: lineCode,
       );

  /// Returns a shallow copy of this [RoomSetup]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  RoomSetup copyWith({
    String? name,
    String? lineCode,
  }) {
    return RoomSetup(
      name: name ?? this.name,
      lineCode: lineCode ?? this.lineCode,
    );
  }
}
