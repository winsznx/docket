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
import '../enums/day_state.dart' as _iglmd807;
import '../wire/line_view.dart' as _itxv0afl;
import '../wire/room_view.dart' as _ieuleg7d;

abstract class DeskView
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  DeskView._({
    required this.clinicId,
    required this.clinicName,
    required this.clinicSlug,
    required this.isSandbox,
    this.day,
    required this.lines,
    required this.rooms,
    required this.joinUrl,
    required this.serverTime,
  });

  factory DeskView({
    required _isc.UuidValue clinicId,
    required String clinicName,
    required String clinicSlug,
    required bool isSandbox,
    _iglmd807.DayState? day,
    required List<_itxv0afl.LineView> lines,
    required List<_ieuleg7d.RoomView> rooms,
    required String joinUrl,
    required DateTime serverTime,
  }) = _DeskViewImpl;

  factory DeskView.fromJson(Map<String, dynamic> jsonSerialization) {
    return DeskView(
      clinicId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['clinicId'],
      ),
      clinicName: jsonSerialization['clinicName'] as String,
      clinicSlug: jsonSerialization['clinicSlug'] as String,
      isSandbox: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['isSandbox'],
      ),
      day: jsonSerialization['day'] == null
          ? null
          : _iglmd807.DayState.fromJson((jsonSerialization['day'] as String)),
      lines: _iw6om5a2.Protocol().deserialize<List<_itxv0afl.LineView>>(
        jsonSerialization['lines'],
      ),
      rooms: _iw6om5a2.Protocol().deserialize<List<_ieuleg7d.RoomView>>(
        jsonSerialization['rooms'],
      ),
      joinUrl: jsonSerialization['joinUrl'] as String,
      serverTime: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['serverTime'],
      ),
    );
  }

  _isc.UuidValue clinicId;

  String clinicName;

  String clinicSlug;

  bool isSandbox;

  _iglmd807.DayState? day;

  List<_itxv0afl.LineView> lines;

  List<_ieuleg7d.RoomView> rooms;

  String joinUrl;

  DateTime serverTime;

  /// Returns a shallow copy of this [DeskView]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  DeskView copyWith({
    _isc.UuidValue? clinicId,
    String? clinicName,
    String? clinicSlug,
    bool? isSandbox,
    _iglmd807.DayState? day,
    List<_itxv0afl.LineView>? lines,
    List<_ieuleg7d.RoomView>? rooms,
    String? joinUrl,
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
      'serverTime': serverTime.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DeskViewImpl extends DeskView {
  _DeskViewImpl({
    required _isc.UuidValue clinicId,
    required String clinicName,
    required String clinicSlug,
    required bool isSandbox,
    _iglmd807.DayState? day,
    required List<_itxv0afl.LineView> lines,
    required List<_ieuleg7d.RoomView> rooms,
    required String joinUrl,
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
         serverTime: serverTime,
       );

  /// Returns a shallow copy of this [DeskView]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  DeskView copyWith({
    _isc.UuidValue? clinicId,
    String? clinicName,
    String? clinicSlug,
    bool? isSandbox,
    Object? day = _Undefined,
    List<_itxv0afl.LineView>? lines,
    List<_ieuleg7d.RoomView>? rooms,
    String? joinUrl,
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
      serverTime: serverTime ?? this.serverTime,
    );
  }
}
