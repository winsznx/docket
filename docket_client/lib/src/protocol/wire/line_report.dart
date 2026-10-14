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

abstract class LineReport
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  LineReport._({
    required this.lineName,
    required this.joined,
    required this.served,
    required this.cancelled,
    required this.removed,
    required this.expired,
    required this.reslotted,
    required this.waitingNow,
    this.medianWaitSeconds,
    this.p90WaitSeconds,
    this.medianServiceSeconds,
    this.p90ServiceSeconds,
    required this.arrivalsByHour,
  });

  factory LineReport({
    required String lineName,
    required int joined,
    required int served,
    required int cancelled,
    required int removed,
    required int expired,
    required int reslotted,
    required int waitingNow,
    int? medianWaitSeconds,
    int? p90WaitSeconds,
    int? medianServiceSeconds,
    int? p90ServiceSeconds,
    required List<int> arrivalsByHour,
  }) = _LineReportImpl;

  factory LineReport.fromJson(Map<String, dynamic> jsonSerialization) {
    return LineReport(
      lineName: jsonSerialization['lineName'] as String,
      joined: jsonSerialization['joined'] as int,
      served: jsonSerialization['served'] as int,
      cancelled: jsonSerialization['cancelled'] as int,
      removed: jsonSerialization['removed'] as int,
      expired: jsonSerialization['expired'] as int,
      reslotted: jsonSerialization['reslotted'] as int,
      waitingNow: jsonSerialization['waitingNow'] as int,
      medianWaitSeconds: jsonSerialization['medianWaitSeconds'] as int?,
      p90WaitSeconds: jsonSerialization['p90WaitSeconds'] as int?,
      medianServiceSeconds: jsonSerialization['medianServiceSeconds'] as int?,
      p90ServiceSeconds: jsonSerialization['p90ServiceSeconds'] as int?,
      arrivalsByHour: _iw6om5a2.Protocol().deserialize<List<int>>(
        jsonSerialization['arrivalsByHour'],
      ),
    );
  }

  String lineName;

  int joined;

  int served;

  int cancelled;

  int removed;

  int expired;

  int reslotted;

  int waitingNow;

  int? medianWaitSeconds;

  int? p90WaitSeconds;

  int? medianServiceSeconds;

  int? p90ServiceSeconds;

  List<int> arrivalsByHour;

  /// Returns a shallow copy of this [LineReport]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  LineReport copyWith({
    String? lineName,
    int? joined,
    int? served,
    int? cancelled,
    int? removed,
    int? expired,
    int? reslotted,
    int? waitingNow,
    int? medianWaitSeconds,
    int? p90WaitSeconds,
    int? medianServiceSeconds,
    int? p90ServiceSeconds,
    List<int>? arrivalsByHour,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'LineReport',
      'lineName': lineName,
      'joined': joined,
      'served': served,
      'cancelled': cancelled,
      'removed': removed,
      'expired': expired,
      'reslotted': reslotted,
      'waitingNow': waitingNow,
      if (medianWaitSeconds != null) 'medianWaitSeconds': medianWaitSeconds,
      if (p90WaitSeconds != null) 'p90WaitSeconds': p90WaitSeconds,
      if (medianServiceSeconds != null)
        'medianServiceSeconds': medianServiceSeconds,
      if (p90ServiceSeconds != null) 'p90ServiceSeconds': p90ServiceSeconds,
      'arrivalsByHour': arrivalsByHour.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'LineReport',
      'lineName': lineName,
      'joined': joined,
      'served': served,
      'cancelled': cancelled,
      'removed': removed,
      'expired': expired,
      'reslotted': reslotted,
      'waitingNow': waitingNow,
      if (medianWaitSeconds != null) 'medianWaitSeconds': medianWaitSeconds,
      if (p90WaitSeconds != null) 'p90WaitSeconds': p90WaitSeconds,
      if (medianServiceSeconds != null)
        'medianServiceSeconds': medianServiceSeconds,
      if (p90ServiceSeconds != null) 'p90ServiceSeconds': p90ServiceSeconds,
      'arrivalsByHour': arrivalsByHour.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _LineReportImpl extends LineReport {
  _LineReportImpl({
    required String lineName,
    required int joined,
    required int served,
    required int cancelled,
    required int removed,
    required int expired,
    required int reslotted,
    required int waitingNow,
    int? medianWaitSeconds,
    int? p90WaitSeconds,
    int? medianServiceSeconds,
    int? p90ServiceSeconds,
    required List<int> arrivalsByHour,
  }) : super._(
         lineName: lineName,
         joined: joined,
         served: served,
         cancelled: cancelled,
         removed: removed,
         expired: expired,
         reslotted: reslotted,
         waitingNow: waitingNow,
         medianWaitSeconds: medianWaitSeconds,
         p90WaitSeconds: p90WaitSeconds,
         medianServiceSeconds: medianServiceSeconds,
         p90ServiceSeconds: p90ServiceSeconds,
         arrivalsByHour: arrivalsByHour,
       );

  /// Returns a shallow copy of this [LineReport]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  LineReport copyWith({
    String? lineName,
    int? joined,
    int? served,
    int? cancelled,
    int? removed,
    int? expired,
    int? reslotted,
    int? waitingNow,
    Object? medianWaitSeconds = _Undefined,
    Object? p90WaitSeconds = _Undefined,
    Object? medianServiceSeconds = _Undefined,
    Object? p90ServiceSeconds = _Undefined,
    List<int>? arrivalsByHour,
  }) {
    return LineReport(
      lineName: lineName ?? this.lineName,
      joined: joined ?? this.joined,
      served: served ?? this.served,
      cancelled: cancelled ?? this.cancelled,
      removed: removed ?? this.removed,
      expired: expired ?? this.expired,
      reslotted: reslotted ?? this.reslotted,
      waitingNow: waitingNow ?? this.waitingNow,
      medianWaitSeconds: medianWaitSeconds is int?
          ? medianWaitSeconds
          : this.medianWaitSeconds,
      p90WaitSeconds: p90WaitSeconds is int?
          ? p90WaitSeconds
          : this.p90WaitSeconds,
      medianServiceSeconds: medianServiceSeconds is int?
          ? medianServiceSeconds
          : this.medianServiceSeconds,
      p90ServiceSeconds: p90ServiceSeconds is int?
          ? p90ServiceSeconds
          : this.p90ServiceSeconds,
      arrivalsByHour:
          arrivalsByHour ?? this.arrivalsByHour.map((e0) => e0).toList(),
    );
  }
}
