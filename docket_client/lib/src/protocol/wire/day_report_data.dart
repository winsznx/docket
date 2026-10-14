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
import '../wire/line_report.dart' as _iyr0h5aq;

abstract class DayReportData
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  DayReportData._({
    required this.serviceDate,
    required this.lines,
  });

  factory DayReportData({
    required String serviceDate,
    required List<_iyr0h5aq.LineReport> lines,
  }) = _DayReportDataImpl;

  factory DayReportData.fromJson(Map<String, dynamic> jsonSerialization) {
    return DayReportData(
      serviceDate: jsonSerialization['serviceDate'] as String,
      lines: _iw6om5a2.Protocol().deserialize<List<_iyr0h5aq.LineReport>>(
        jsonSerialization['lines'],
      ),
    );
  }

  String serviceDate;

  List<_iyr0h5aq.LineReport> lines;

  /// Returns a shallow copy of this [DayReportData]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  DayReportData copyWith({
    String? serviceDate,
    List<_iyr0h5aq.LineReport>? lines,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DayReportData',
      'serviceDate': serviceDate,
      'lines': lines.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DayReportData',
      'serviceDate': serviceDate,
      'lines': lines.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _DayReportDataImpl extends DayReportData {
  _DayReportDataImpl({
    required String serviceDate,
    required List<_iyr0h5aq.LineReport> lines,
  }) : super._(
         serviceDate: serviceDate,
         lines: lines,
       );

  /// Returns a shallow copy of this [DayReportData]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  DayReportData copyWith({
    String? serviceDate,
    List<_iyr0h5aq.LineReport>? lines,
  }) {
    return DayReportData(
      serviceDate: serviceDate ?? this.serviceDate,
      lines: lines ?? this.lines.map((e0) => e0.copyWith()).toList(),
    );
  }
}
