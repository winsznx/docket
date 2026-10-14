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
import '../wire/day_report_data.dart' as _ib20ove7;

abstract class DayReport
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  DayReport._({
    this.id,
    required this.clinicId,
    required this.serviceDate,
    required this.generatedAt,
    required this.data,
  });

  factory DayReport({
    _isc.UuidValue? id,
    required _isc.UuidValue clinicId,
    required String serviceDate,
    required DateTime generatedAt,
    required _ib20ove7.DayReportData data,
  }) = _DayReportImpl;

  factory DayReport.fromJson(Map<String, dynamic> jsonSerialization) {
    return DayReport(
      id: jsonSerialization['id'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      clinicId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['clinicId'],
      ),
      serviceDate: jsonSerialization['serviceDate'] as String,
      generatedAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['generatedAt'],
      ),
      data: _iw6om5a2.Protocol().deserialize<_ib20ove7.DayReportData>(
        jsonSerialization['data'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _isc.UuidValue? id;

  _isc.UuidValue clinicId;

  String serviceDate;

  DateTime generatedAt;

  _ib20ove7.DayReportData data;

  /// Returns a shallow copy of this [DayReport]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  DayReport copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? clinicId,
    String? serviceDate,
    DateTime? generatedAt,
    _ib20ove7.DayReportData? data,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DayReport',
      if (id != null) 'id': id?.toJson(),
      'clinicId': clinicId.toJson(),
      'serviceDate': serviceDate,
      'generatedAt': generatedAt.toJson(),
      'data': data.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DayReport',
      if (id != null) 'id': id?.toJson(),
      'clinicId': clinicId.toJson(),
      'serviceDate': serviceDate,
      'generatedAt': generatedAt.toJson(),
      'data': data.toJsonForProtocol(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DayReportImpl extends DayReport {
  _DayReportImpl({
    _isc.UuidValue? id,
    required _isc.UuidValue clinicId,
    required String serviceDate,
    required DateTime generatedAt,
    required _ib20ove7.DayReportData data,
  }) : super._(
         id: id,
         clinicId: clinicId,
         serviceDate: serviceDate,
         generatedAt: generatedAt,
         data: data,
       );

  /// Returns a shallow copy of this [DayReport]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  DayReport copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? clinicId,
    String? serviceDate,
    DateTime? generatedAt,
    _ib20ove7.DayReportData? data,
  }) {
    return DayReport(
      id: id is _isc.UuidValue? ? id : this.id,
      clinicId: clinicId ?? this.clinicId,
      serviceDate: serviceDate ?? this.serviceDate,
      generatedAt: generatedAt ?? this.generatedAt,
      data: data ?? this.data.copyWith(),
    );
  }
}
