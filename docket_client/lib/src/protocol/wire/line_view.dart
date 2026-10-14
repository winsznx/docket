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
import '../wire/ticket_view.dart' as _icukv18l;

abstract class LineView
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  LineView._({
    required this.id,
    required this.name,
    required this.code,
    required this.version,
    required this.acceptingJoins,
    required this.tickets,
    required this.medianServiceSeconds,
    required this.sampleCount,
    required this.servedToday,
  });

  factory LineView({
    required _isc.UuidValue id,
    required String name,
    required String code,
    required int version,
    required bool acceptingJoins,
    required List<_icukv18l.TicketView> tickets,
    required int medianServiceSeconds,
    required int sampleCount,
    required int servedToday,
  }) = _LineViewImpl;

  factory LineView.fromJson(Map<String, dynamic> jsonSerialization) {
    return LineView(
      id: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      name: jsonSerialization['name'] as String,
      code: jsonSerialization['code'] as String,
      version: jsonSerialization['version'] as int,
      acceptingJoins: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['acceptingJoins'],
      ),
      tickets: _iw6om5a2.Protocol().deserialize<List<_icukv18l.TicketView>>(
        jsonSerialization['tickets'],
      ),
      medianServiceSeconds: jsonSerialization['medianServiceSeconds'] as int,
      sampleCount: jsonSerialization['sampleCount'] as int,
      servedToday: jsonSerialization['servedToday'] as int,
    );
  }

  _isc.UuidValue id;

  String name;

  String code;

  int version;

  bool acceptingJoins;

  List<_icukv18l.TicketView> tickets;

  int medianServiceSeconds;

  int sampleCount;

  int servedToday;

  /// Returns a shallow copy of this [LineView]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  LineView copyWith({
    _isc.UuidValue? id,
    String? name,
    String? code,
    int? version,
    bool? acceptingJoins,
    List<_icukv18l.TicketView>? tickets,
    int? medianServiceSeconds,
    int? sampleCount,
    int? servedToday,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'LineView',
      'id': id.toJson(),
      'name': name,
      'code': code,
      'version': version,
      'acceptingJoins': acceptingJoins,
      'tickets': tickets.toJson(valueToJson: (v) => v.toJson()),
      'medianServiceSeconds': medianServiceSeconds,
      'sampleCount': sampleCount,
      'servedToday': servedToday,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'LineView',
      'id': id.toJson(),
      'name': name,
      'code': code,
      'version': version,
      'acceptingJoins': acceptingJoins,
      'tickets': tickets.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'medianServiceSeconds': medianServiceSeconds,
      'sampleCount': sampleCount,
      'servedToday': servedToday,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _LineViewImpl extends LineView {
  _LineViewImpl({
    required _isc.UuidValue id,
    required String name,
    required String code,
    required int version,
    required bool acceptingJoins,
    required List<_icukv18l.TicketView> tickets,
    required int medianServiceSeconds,
    required int sampleCount,
    required int servedToday,
  }) : super._(
         id: id,
         name: name,
         code: code,
         version: version,
         acceptingJoins: acceptingJoins,
         tickets: tickets,
         medianServiceSeconds: medianServiceSeconds,
         sampleCount: sampleCount,
         servedToday: servedToday,
       );

  /// Returns a shallow copy of this [LineView]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  LineView copyWith({
    _isc.UuidValue? id,
    String? name,
    String? code,
    int? version,
    bool? acceptingJoins,
    List<_icukv18l.TicketView>? tickets,
    int? medianServiceSeconds,
    int? sampleCount,
    int? servedToday,
  }) {
    return LineView(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      version: version ?? this.version,
      acceptingJoins: acceptingJoins ?? this.acceptingJoins,
      tickets: tickets ?? this.tickets.map((e0) => e0.copyWith()).toList(),
      medianServiceSeconds: medianServiceSeconds ?? this.medianServiceSeconds,
      sampleCount: sampleCount ?? this.sampleCount,
      servedToday: servedToday ?? this.servedToday,
    );
  }
}
