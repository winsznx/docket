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
import '../wire/line_public_info.dart' as _ij1egfxl;

abstract class ClinicPublicInfo
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ClinicPublicInfo._({
    required this.name,
    required this.slug,
    required this.lines,
    required this.acceptingJoins,
    this.reasonClosed,
    required this.smsEnabled,
    required this.vapidPublicKey,
    required this.isSandbox,
  });

  factory ClinicPublicInfo({
    required String name,
    required String slug,
    required List<_ij1egfxl.LinePublicInfo> lines,
    required bool acceptingJoins,
    String? reasonClosed,
    required bool smsEnabled,
    required String vapidPublicKey,
    required bool isSandbox,
  }) = _ClinicPublicInfoImpl;

  factory ClinicPublicInfo.fromJson(Map<String, dynamic> jsonSerialization) {
    return ClinicPublicInfo(
      name: jsonSerialization['name'] as String,
      slug: jsonSerialization['slug'] as String,
      lines: _iw6om5a2.Protocol().deserialize<List<_ij1egfxl.LinePublicInfo>>(
        jsonSerialization['lines'],
      ),
      acceptingJoins: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['acceptingJoins'],
      ),
      reasonClosed: jsonSerialization['reasonClosed'] as String?,
      smsEnabled: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['smsEnabled'],
      ),
      vapidPublicKey: jsonSerialization['vapidPublicKey'] as String,
      isSandbox: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['isSandbox'],
      ),
    );
  }

  String name;

  String slug;

  List<_ij1egfxl.LinePublicInfo> lines;

  bool acceptingJoins;

  String? reasonClosed;

  bool smsEnabled;

  String vapidPublicKey;

  bool isSandbox;

  /// Returns a shallow copy of this [ClinicPublicInfo]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ClinicPublicInfo copyWith({
    String? name,
    String? slug,
    List<_ij1egfxl.LinePublicInfo>? lines,
    bool? acceptingJoins,
    String? reasonClosed,
    bool? smsEnabled,
    String? vapidPublicKey,
    bool? isSandbox,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ClinicPublicInfo',
      'name': name,
      'slug': slug,
      'lines': lines.toJson(valueToJson: (v) => v.toJson()),
      'acceptingJoins': acceptingJoins,
      if (reasonClosed != null) 'reasonClosed': reasonClosed,
      'smsEnabled': smsEnabled,
      'vapidPublicKey': vapidPublicKey,
      'isSandbox': isSandbox,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ClinicPublicInfo',
      'name': name,
      'slug': slug,
      'lines': lines.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'acceptingJoins': acceptingJoins,
      if (reasonClosed != null) 'reasonClosed': reasonClosed,
      'smsEnabled': smsEnabled,
      'vapidPublicKey': vapidPublicKey,
      'isSandbox': isSandbox,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ClinicPublicInfoImpl extends ClinicPublicInfo {
  _ClinicPublicInfoImpl({
    required String name,
    required String slug,
    required List<_ij1egfxl.LinePublicInfo> lines,
    required bool acceptingJoins,
    String? reasonClosed,
    required bool smsEnabled,
    required String vapidPublicKey,
    required bool isSandbox,
  }) : super._(
         name: name,
         slug: slug,
         lines: lines,
         acceptingJoins: acceptingJoins,
         reasonClosed: reasonClosed,
         smsEnabled: smsEnabled,
         vapidPublicKey: vapidPublicKey,
         isSandbox: isSandbox,
       );

  /// Returns a shallow copy of this [ClinicPublicInfo]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ClinicPublicInfo copyWith({
    String? name,
    String? slug,
    List<_ij1egfxl.LinePublicInfo>? lines,
    bool? acceptingJoins,
    Object? reasonClosed = _Undefined,
    bool? smsEnabled,
    String? vapidPublicKey,
    bool? isSandbox,
  }) {
    return ClinicPublicInfo(
      name: name ?? this.name,
      slug: slug ?? this.slug,
      lines: lines ?? this.lines.map((e0) => e0.copyWith()).toList(),
      acceptingJoins: acceptingJoins ?? this.acceptingJoins,
      reasonClosed: reasonClosed is String? ? reasonClosed : this.reasonClosed,
      smsEnabled: smsEnabled ?? this.smsEnabled,
      vapidPublicKey: vapidPublicKey ?? this.vapidPublicKey,
      isSandbox: isSandbox ?? this.isSandbox,
    );
  }
}
