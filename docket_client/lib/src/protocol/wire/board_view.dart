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
import '../wire/board_call.dart' as _ixlxpil5;
import '../wire/board_room.dart' as _ix8oojbq;

abstract class BoardView
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  BoardView._({
    required this.clinicName,
    required this.rooms,
    required this.recentCalls,
    required this.waitingByLine,
    required this.joinUrl,
    required this.serverTime,
  });

  factory BoardView({
    required String clinicName,
    required List<_ix8oojbq.BoardRoom> rooms,
    required List<_ixlxpil5.BoardCall> recentCalls,
    required Map<String, int> waitingByLine,
    required String joinUrl,
    required DateTime serverTime,
  }) = _BoardViewImpl;

  factory BoardView.fromJson(Map<String, dynamic> jsonSerialization) {
    return BoardView(
      clinicName: jsonSerialization['clinicName'] as String,
      rooms: _iw6om5a2.Protocol().deserialize<List<_ix8oojbq.BoardRoom>>(
        jsonSerialization['rooms'],
      ),
      recentCalls: _iw6om5a2.Protocol().deserialize<List<_ixlxpil5.BoardCall>>(
        jsonSerialization['recentCalls'],
      ),
      waitingByLine: _iw6om5a2.Protocol().deserialize<Map<String, int>>(
        jsonSerialization['waitingByLine'],
      ),
      joinUrl: jsonSerialization['joinUrl'] as String,
      serverTime: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['serverTime'],
      ),
    );
  }

  String clinicName;

  List<_ix8oojbq.BoardRoom> rooms;

  List<_ixlxpil5.BoardCall> recentCalls;

  Map<String, int> waitingByLine;

  String joinUrl;

  DateTime serverTime;

  /// Returns a shallow copy of this [BoardView]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  BoardView copyWith({
    String? clinicName,
    List<_ix8oojbq.BoardRoom>? rooms,
    List<_ixlxpil5.BoardCall>? recentCalls,
    Map<String, int>? waitingByLine,
    String? joinUrl,
    DateTime? serverTime,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'BoardView',
      'clinicName': clinicName,
      'rooms': rooms.toJson(valueToJson: (v) => v.toJson()),
      'recentCalls': recentCalls.toJson(valueToJson: (v) => v.toJson()),
      'waitingByLine': waitingByLine.toJson(),
      'joinUrl': joinUrl,
      'serverTime': serverTime.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'BoardView',
      'clinicName': clinicName,
      'rooms': rooms.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'recentCalls': recentCalls.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
      'waitingByLine': waitingByLine.toJson(),
      'joinUrl': joinUrl,
      'serverTime': serverTime.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _BoardViewImpl extends BoardView {
  _BoardViewImpl({
    required String clinicName,
    required List<_ix8oojbq.BoardRoom> rooms,
    required List<_ixlxpil5.BoardCall> recentCalls,
    required Map<String, int> waitingByLine,
    required String joinUrl,
    required DateTime serverTime,
  }) : super._(
         clinicName: clinicName,
         rooms: rooms,
         recentCalls: recentCalls,
         waitingByLine: waitingByLine,
         joinUrl: joinUrl,
         serverTime: serverTime,
       );

  /// Returns a shallow copy of this [BoardView]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  BoardView copyWith({
    String? clinicName,
    List<_ix8oojbq.BoardRoom>? rooms,
    List<_ixlxpil5.BoardCall>? recentCalls,
    Map<String, int>? waitingByLine,
    String? joinUrl,
    DateTime? serverTime,
  }) {
    return BoardView(
      clinicName: clinicName ?? this.clinicName,
      rooms: rooms ?? this.rooms.map((e0) => e0.copyWith()).toList(),
      recentCalls:
          recentCalls ?? this.recentCalls.map((e0) => e0.copyWith()).toList(),
      waitingByLine:
          waitingByLine ??
          this.waitingByLine.map(
            (
              key0,
              value0,
            ) => MapEntry(
              key0,
              value0,
            ),
          ),
      joinUrl: joinUrl ?? this.joinUrl,
      serverTime: serverTime ?? this.serverTime,
    );
  }
}
