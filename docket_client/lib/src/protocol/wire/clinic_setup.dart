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
import 'package:docket_client/src/protocol/protocol.dart' as _iw6om5a2;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import '../wire/line_setup.dart' as _isx7807k;
import '../wire/room_setup.dart' as _iqgppnzh;

abstract class ClinicSetup
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ClinicSetup._({
    required this.name,
    required this.slug,
    required this.timezone,
    required this.lines,
    required this.rooms,
  });

  factory ClinicSetup({
    required String name,
    required String slug,
    required String timezone,
    required List<_isx7807k.LineSetup> lines,
    required List<_iqgppnzh.RoomSetup> rooms,
  }) = _ClinicSetupImpl;

  factory ClinicSetup.fromJson(Map<String, dynamic> jsonSerialization) {
    return ClinicSetup(
      name: jsonSerialization['name'] as String,
      slug: jsonSerialization['slug'] as String,
      timezone: jsonSerialization['timezone'] as String,
      lines: _iw6om5a2.Protocol().deserialize<List<_isx7807k.LineSetup>>(
        jsonSerialization['lines'],
      ),
      rooms: _iw6om5a2.Protocol().deserialize<List<_iqgppnzh.RoomSetup>>(
        jsonSerialization['rooms'],
      ),
    );
  }

  String name;

  String slug;

  String timezone;

  List<_isx7807k.LineSetup> lines;

  List<_iqgppnzh.RoomSetup> rooms;

  /// Returns a shallow copy of this [ClinicSetup]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ClinicSetup copyWith({
    String? name,
    String? slug,
    String? timezone,
    List<_isx7807k.LineSetup>? lines,
    List<_iqgppnzh.RoomSetup>? rooms,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ClinicSetup',
      'name': name,
      'slug': slug,
      'timezone': timezone,
      'lines': lines.toJson(valueToJson: (v) => v.toJson()),
      'rooms': rooms.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ClinicSetup',
      'name': name,
      'slug': slug,
      'timezone': timezone,
      'lines': lines.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'rooms': rooms.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _ClinicSetupImpl extends ClinicSetup {
  _ClinicSetupImpl({
    required String name,
    required String slug,
    required String timezone,
    required List<_isx7807k.LineSetup> lines,
    required List<_iqgppnzh.RoomSetup> rooms,
  }) : super._(
         name: name,
         slug: slug,
         timezone: timezone,
         lines: lines,
         rooms: rooms,
       );

  /// Returns a shallow copy of this [ClinicSetup]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ClinicSetup copyWith({
    String? name,
    String? slug,
    String? timezone,
    List<_isx7807k.LineSetup>? lines,
    List<_iqgppnzh.RoomSetup>? rooms,
  }) {
    return ClinicSetup(
      name: name ?? this.name,
      slug: slug ?? this.slug,
      timezone: timezone ?? this.timezone,
      lines: lines ?? this.lines.map((e0) => e0.copyWith()).toList(),
      rooms: rooms ?? this.rooms.map((e0) => e0.copyWith()).toList(),
    );
  }
}
