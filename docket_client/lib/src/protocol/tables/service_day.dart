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
import '../enums/day_state.dart' as _iglmd807;

abstract class ServiceDay
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ServiceDay._({
    this.id,
    required this.clinicId,
    required this.serviceDate,
    required this.state,
    required this.openedAt,
    this.closedAt,
  });

  factory ServiceDay({
    _isc.UuidValue? id,
    required _isc.UuidValue clinicId,
    required String serviceDate,
    required _iglmd807.DayState state,
    required DateTime openedAt,
    DateTime? closedAt,
  }) = _ServiceDayImpl;

  factory ServiceDay.fromJson(Map<String, dynamic> jsonSerialization) {
    return ServiceDay(
      id: jsonSerialization['id'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      clinicId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['clinicId'],
      ),
      serviceDate: jsonSerialization['serviceDate'] as String,
      state: _iglmd807.DayState.fromJson(
        (jsonSerialization['state'] as String),
      ),
      openedAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['openedAt'],
      ),
      closedAt: jsonSerialization['closedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['closedAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _isc.UuidValue? id;

  _isc.UuidValue clinicId;

  String serviceDate;

  _iglmd807.DayState state;

  DateTime openedAt;

  DateTime? closedAt;

  /// Returns a shallow copy of this [ServiceDay]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ServiceDay copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? clinicId,
    String? serviceDate,
    _iglmd807.DayState? state,
    DateTime? openedAt,
    DateTime? closedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ServiceDay',
      if (id != null) 'id': id?.toJson(),
      'clinicId': clinicId.toJson(),
      'serviceDate': serviceDate,
      'state': state.toJson(),
      'openedAt': openedAt.toJson(),
      if (closedAt != null) 'closedAt': closedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ServiceDay',
      if (id != null) 'id': id?.toJson(),
      'clinicId': clinicId.toJson(),
      'serviceDate': serviceDate,
      'state': state.toJson(),
      'openedAt': openedAt.toJson(),
      if (closedAt != null) 'closedAt': closedAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ServiceDayImpl extends ServiceDay {
  _ServiceDayImpl({
    _isc.UuidValue? id,
    required _isc.UuidValue clinicId,
    required String serviceDate,
    required _iglmd807.DayState state,
    required DateTime openedAt,
    DateTime? closedAt,
  }) : super._(
         id: id,
         clinicId: clinicId,
         serviceDate: serviceDate,
         state: state,
         openedAt: openedAt,
         closedAt: closedAt,
       );

  /// Returns a shallow copy of this [ServiceDay]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ServiceDay copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? clinicId,
    String? serviceDate,
    _iglmd807.DayState? state,
    DateTime? openedAt,
    Object? closedAt = _Undefined,
  }) {
    return ServiceDay(
      id: id is _isc.UuidValue? ? id : this.id,
      clinicId: clinicId ?? this.clinicId,
      serviceDate: serviceDate ?? this.serviceDate,
      state: state ?? this.state,
      openedAt: openedAt ?? this.openedAt,
      closedAt: closedAt is DateTime? ? closedAt : this.closedAt,
    );
  }
}
