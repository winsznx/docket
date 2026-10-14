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
import '../wire/line_view.dart' as _itxv0afl;
import '../wire/room_view.dart' as _ieuleg7d;

abstract class DeskView
    implements _is.SerializableModel, _is.ProtocolSerialization {
  DeskView._({
    required this.clinicId,
    required this.clinicName,
    required this.clinicSlug,
    required this.isSandbox,
    this.day,
    required this.lines,
    required this.rooms,
    required this.joinUrl,
    required this.reslotOffset,
    required this.maxReslots,
    required this.serverTime,
  });

  factory DeskView({
    required _is.UuidValue clinicId,
    required String clinicName,
    required String clinicSlug,
    required bool isSandbox,
    _iglmd807.DayState? day,
    required List<_itxv0afl.LineView> lines,
    required List<_ieuleg7d.RoomView> rooms,
    required String joinUrl,
    required int reslotOffset,
    required int maxReslots,
    required DateTime serverTime,
  }) = _DeskViewImpl;

  factory DeskView.fromJson(Map<String, dynamic> jsonSerialization) {
    return DeskView(
      clinicId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['clinicId'],
      ),
      clinicName: jsonSerialization['clinicName'] as String,
      clinicSlug: jsonSerialization['clinicSlug'] as String,
      isSandbox: _is.BoolJsonExtension.fromJson(jsonSerialization['isSandbox']),
      day: jsonSerialization['day'] == null
          ? null
          : _iglmd807.DayState.fromJson((jsonSerialization['day'] as String)),
      lines: _in3ld48g.Protocol().deserialize<List<_itxv0afl.LineView>>(
        jsonSerialization['lines'],
      ),
      rooms: _in3ld48g.Protocol().deserialize<List<_ieuleg7d.RoomView>>(
        jsonSerialization['rooms'],
      ),
      joinUrl: jsonSerialization['joinUrl'] as String,
      reslotOffset: jsonSerialization['reslotOffset'] as int,
      maxReslots: jsonSerialization['maxReslots'] as int,
      serverTime: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['serverTime'],
      ),
    );
  }

  _is.UuidValue clinicId;

  String clinicName;

  String clinicSlug;

  bool isSandbox;

  _iglmd807.DayState? day;

  List<_itxv0afl.LineView> lines;

  List<_ieuleg7d.RoomView> rooms;

  String joinUrl;

  int reslotOffset;

  int maxReslots;

  DateTime serverTime;

  /// Returns a shallow copy of this [DeskView]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  DeskView copyWith({
    _is.UuidValue? clinicId,
    String? clinicName,
    String? clinicSlug,
    bool? isSandbox,
    _iglmd807.DayState? day,
    List<_itxv0afl.LineView>? lines,
    List<_ieuleg7d.RoomView>? rooms,
    String? joinUrl,
    int? reslotOffset,
    int? maxReslots,
    DateTime? serverTime,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DeskView',
      'clinicId': clinicId.toJson(),
      'clinicName': clinicName,
      'clinicSlug': clinicSlug,
      'isSandbox': isSandbox,
      if (day != null) 'day': day?.toJson(),
      'lines': lines.toJson(valueToJson: (v) => v.toJson()),
      'rooms': rooms.toJson(valueToJson: (v) => v.toJson()),
      'joinUrl': joinUrl,
      'reslotOffset': reslotOffset,
      'maxReslots': maxReslots,
      'serverTime': serverTime.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DeskView',
      'clinicId': clinicId.toJson(),
      'clinicName': clinicName,
      'clinicSlug': clinicSlug,
      'isSandbox': isSandbox,
      if (day != null) 'day': day?.toJson(),
      'lines': lines.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'rooms': rooms.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'joinUrl': joinUrl,
      'reslotOffset': reslotOffset,
      'maxReslots': maxReslots,
      'serverTime': serverTime.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DeskViewImpl extends DeskView {
  _DeskViewImpl({
    required _is.UuidValue clinicId,
    required String clinicName,
    required String clinicSlug,
    required bool isSandbox,
    _iglmd807.DayState? day,
    required List<_itxv0afl.LineView> lines,
    required List<_ieuleg7d.RoomView> rooms,
    required String joinUrl,
    required int reslotOffset,
    required int maxReslots,
    required DateTime serverTime,
  }) : super._(
         clinicId: clinicId,
         clinicName: clinicName,
         clinicSlug: clinicSlug,
         isSandbox: isSandbox,
         day: day,
         lines: lines,
         rooms: rooms,
         joinUrl: joinUrl,
         reslotOffset: reslotOffset,
         maxReslots: maxReslots,
         serverTime: serverTime,
       );

  /// Returns a shallow copy of this [DeskView]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  DeskView copyWith({
    _is.UuidValue? clinicId,
    String? clinicName,
    String? clinicSlug,
    bool? isSandbox,
    Object? day = _Undefined,
    List<_itxv0afl.LineView>? lines,
    List<_ieuleg7d.RoomView>? rooms,
    String? joinUrl,
    int? reslotOffset,
    int? maxReslots,
    DateTime? serverTime,
  }) {
    return DeskView(
      clinicId: clinicId ?? this.clinicId,
      clinicName: clinicName ?? this.clinicName,
      clinicSlug: clinicSlug ?? this.clinicSlug,
      isSandbox: isSandbox ?? this.isSandbox,
      day: day is _iglmd807.DayState? ? day : this.day,
      lines: lines ?? this.lines.map((e0) => e0.copyWith()).toList(),
      rooms: rooms ?? this.rooms.map((e0) => e0.copyWith()).toList(),
      joinUrl: joinUrl ?? this.joinUrl,
      reslotOffset: reslotOffset ?? this.reslotOffset,
      maxReslots: maxReslots ?? this.maxReslots,
      serverTime: serverTime ?? this.serverTime,
    );
  }
}
