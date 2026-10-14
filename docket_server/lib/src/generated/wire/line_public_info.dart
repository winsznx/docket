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
import 'package:serverpod/serverpod.dart' as _is;

abstract class LinePublicInfo
    implements _is.SerializableModel, _is.ProtocolSerialization {
  LinePublicInfo._({
    required this.id,
    required this.name,
    required this.code,
    required this.waitingCount,
    this.etaMinutesForNewJoin,
    required this.etaText,
    required this.acceptingJoins,
  });

  factory LinePublicInfo({
    required _is.UuidValue id,
    required String name,
    required String code,
    required int waitingCount,
    int? etaMinutesForNewJoin,
    required String etaText,
    required bool acceptingJoins,
  }) = _LinePublicInfoImpl;

  factory LinePublicInfo.fromJson(Map<String, dynamic> jsonSerialization) {
    return LinePublicInfo(
      id: _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      name: jsonSerialization['name'] as String,
      code: jsonSerialization['code'] as String,
      waitingCount: jsonSerialization['waitingCount'] as int,
      etaMinutesForNewJoin: jsonSerialization['etaMinutesForNewJoin'] as int?,
      etaText: jsonSerialization['etaText'] as String,
      acceptingJoins: _is.BoolJsonExtension.fromJson(
        jsonSerialization['acceptingJoins'],
      ),
    );
  }

  _is.UuidValue id;

  String name;

  String code;

  int waitingCount;

  int? etaMinutesForNewJoin;

  String etaText;

  bool acceptingJoins;

  /// Returns a shallow copy of this [LinePublicInfo]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  LinePublicInfo copyWith({
    _is.UuidValue? id,
    String? name,
    String? code,
    int? waitingCount,
    int? etaMinutesForNewJoin,
    String? etaText,
    bool? acceptingJoins,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'LinePublicInfo',
      'id': id.toJson(),
      'name': name,
      'code': code,
      'waitingCount': waitingCount,
      if (etaMinutesForNewJoin != null)
        'etaMinutesForNewJoin': etaMinutesForNewJoin,
      'etaText': etaText,
      'acceptingJoins': acceptingJoins,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'LinePublicInfo',
      'id': id.toJson(),
      'name': name,
      'code': code,
      'waitingCount': waitingCount,
      if (etaMinutesForNewJoin != null)
        'etaMinutesForNewJoin': etaMinutesForNewJoin,
      'etaText': etaText,
      'acceptingJoins': acceptingJoins,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _LinePublicInfoImpl extends LinePublicInfo {
  _LinePublicInfoImpl({
    required _is.UuidValue id,
    required String name,
    required String code,
    required int waitingCount,
    int? etaMinutesForNewJoin,
    required String etaText,
    required bool acceptingJoins,
  }) : super._(
         id: id,
         name: name,
         code: code,
         waitingCount: waitingCount,
         etaMinutesForNewJoin: etaMinutesForNewJoin,
         etaText: etaText,
         acceptingJoins: acceptingJoins,
       );

  /// Returns a shallow copy of this [LinePublicInfo]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  LinePublicInfo copyWith({
    _is.UuidValue? id,
    String? name,
    String? code,
    int? waitingCount,
    Object? etaMinutesForNewJoin = _Undefined,
    String? etaText,
    bool? acceptingJoins,
  }) {
    return LinePublicInfo(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      waitingCount: waitingCount ?? this.waitingCount,
      etaMinutesForNewJoin: etaMinutesForNewJoin is int?
          ? etaMinutesForNewJoin
          : this.etaMinutesForNewJoin,
      etaText: etaText ?? this.etaText,
      acceptingJoins: acceptingJoins ?? this.acceptingJoins,
    );
  }
}
