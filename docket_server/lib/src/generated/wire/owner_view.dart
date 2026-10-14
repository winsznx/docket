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
import 'package:docket_server/src/generated/protocol.dart' as _in3ld48g;
import 'package:serverpod/serverpod.dart' as _is;
import '../enums/day_state.dart' as _iglmd807;
import '../tables/clinic.dart' as _ifw9dbhk;
import '../tables/line.dart' as _i6vf51sf;
import '../tables/room.dart' as _ike81btj;

abstract class OwnerView
    implements _is.SerializableModel, _is.ProtocolSerialization {
  OwnerView._({
    required this.clinic,
    required this.lines,
    required this.rooms,
    required this.serviceDate,
    this.day,
    required this.smsAvailable,
  });

  factory OwnerView({
    required _ifw9dbhk.Clinic clinic,
    required List<_i6vf51sf.Line> lines,
    required List<_ike81btj.Room> rooms,
    required String serviceDate,
    _iglmd807.DayState? day,
    required bool smsAvailable,
  }) = _OwnerViewImpl;

  factory OwnerView.fromJson(Map<String, dynamic> jsonSerialization) {
    return OwnerView(
      clinic: _in3ld48g.Protocol().deserialize<_ifw9dbhk.Clinic>(
        jsonSerialization['clinic'],
      ),
      lines: _in3ld48g.Protocol().deserialize<List<_i6vf51sf.Line>>(
        jsonSerialization['lines'],
      ),
      rooms: _in3ld48g.Protocol().deserialize<List<_ike81btj.Room>>(
        jsonSerialization['rooms'],
      ),
      serviceDate: jsonSerialization['serviceDate'] as String,
      day: jsonSerialization['day'] == null
          ? null
          : _iglmd807.DayState.fromJson((jsonSerialization['day'] as String)),
      smsAvailable: _is.BoolJsonExtension.fromJson(
        jsonSerialization['smsAvailable'],
      ),
    );
  }

  _ifw9dbhk.Clinic clinic;

  List<_i6vf51sf.Line> lines;

  List<_ike81btj.Room> rooms;

  String serviceDate;

  _iglmd807.DayState? day;

  bool smsAvailable;

  /// Returns a shallow copy of this [OwnerView]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  OwnerView copyWith({
    _ifw9dbhk.Clinic? clinic,
    List<_i6vf51sf.Line>? lines,
    List<_ike81btj.Room>? rooms,
    String? serviceDate,
    _iglmd807.DayState? day,
    bool? smsAvailable,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'OwnerView',
      'clinic': clinic.toJson(),
      'lines': lines.toJson(valueToJson: (v) => v.toJson()),
      'rooms': rooms.toJson(valueToJson: (v) => v.toJson()),
      'serviceDate': serviceDate,
      if (day != null) 'day': day?.toJson(),
      'smsAvailable': smsAvailable,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'OwnerView',
      'clinic': clinic.toJsonForProtocol(),
      'lines': lines.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'rooms': rooms.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'serviceDate': serviceDate,
      if (day != null) 'day': day?.toJson(),
      'smsAvailable': smsAvailable,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _OwnerViewImpl extends OwnerView {
  _OwnerViewImpl({
    required _ifw9dbhk.Clinic clinic,
    required List<_i6vf51sf.Line> lines,
    required List<_ike81btj.Room> rooms,
    required String serviceDate,
    _iglmd807.DayState? day,
    required bool smsAvailable,
  }) : super._(
         clinic: clinic,
         lines: lines,
         rooms: rooms,
         serviceDate: serviceDate,
         day: day,
         smsAvailable: smsAvailable,
       );

  /// Returns a shallow copy of this [OwnerView]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  OwnerView copyWith({
    _ifw9dbhk.Clinic? clinic,
    List<_i6vf51sf.Line>? lines,
    List<_ike81btj.Room>? rooms,
    String? serviceDate,
    Object? day = _Undefined,
    bool? smsAvailable,
  }) {
    return OwnerView(
      clinic: clinic ?? this.clinic.copyWith(),
      lines: lines ?? this.lines.map((e0) => e0.copyWith()).toList(),
      rooms: rooms ?? this.rooms.map((e0) => e0.copyWith()).toList(),
      serviceDate: serviceDate ?? this.serviceDate,
      day: day is _iglmd807.DayState? ? day : this.day,
      smsAvailable: smsAvailable ?? this.smsAvailable,
    );
  }
}
