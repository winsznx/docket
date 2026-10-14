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

abstract class ClinicSettings
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ClinicSettings._({
    required this.graceSeconds,
    required this.graceReminderSeconds,
    required this.arrivalSeconds,
    required this.headsUpPositions,
    required this.headsUpMinutes,
    required this.reslotOffset,
    required this.maxReslots,
    required this.openTime,
    required this.joinCutoffTime,
    required this.closeTime,
    required this.autoCloseAfterMinutes,
    required this.timezone,
    required this.smsEnabled,
  });

  factory ClinicSettings({
    required int graceSeconds,
    required int graceReminderSeconds,
    required int arrivalSeconds,
    required int headsUpPositions,
    required int headsUpMinutes,
    required int reslotOffset,
    required int maxReslots,
    required String openTime,
    required String joinCutoffTime,
    required String closeTime,
    required int autoCloseAfterMinutes,
    required String timezone,
    required bool smsEnabled,
  }) = _ClinicSettingsImpl;

  factory ClinicSettings.fromJson(Map<String, dynamic> jsonSerialization) {
    return ClinicSettings(
      graceSeconds: jsonSerialization['graceSeconds'] as int,
      graceReminderSeconds: jsonSerialization['graceReminderSeconds'] as int,
      arrivalSeconds: jsonSerialization['arrivalSeconds'] as int,
      headsUpPositions: jsonSerialization['headsUpPositions'] as int,
      headsUpMinutes: jsonSerialization['headsUpMinutes'] as int,
      reslotOffset: jsonSerialization['reslotOffset'] as int,
      maxReslots: jsonSerialization['maxReslots'] as int,
      openTime: jsonSerialization['openTime'] as String,
      joinCutoffTime: jsonSerialization['joinCutoffTime'] as String,
      closeTime: jsonSerialization['closeTime'] as String,
      autoCloseAfterMinutes: jsonSerialization['autoCloseAfterMinutes'] as int,
      timezone: jsonSerialization['timezone'] as String,
      smsEnabled: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['smsEnabled'],
      ),
    );
  }

  int graceSeconds;

  int graceReminderSeconds;

  int arrivalSeconds;

  int headsUpPositions;

  int headsUpMinutes;

  int reslotOffset;

  int maxReslots;

  String openTime;

  String joinCutoffTime;

  String closeTime;

  int autoCloseAfterMinutes;

  String timezone;

  bool smsEnabled;

  /// Returns a shallow copy of this [ClinicSettings]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ClinicSettings copyWith({
    int? graceSeconds,
    int? graceReminderSeconds,
    int? arrivalSeconds,
    int? headsUpPositions,
    int? headsUpMinutes,
    int? reslotOffset,
    int? maxReslots,
    String? openTime,
    String? joinCutoffTime,
    String? closeTime,
    int? autoCloseAfterMinutes,
    String? timezone,
    bool? smsEnabled,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ClinicSettings',
      'graceSeconds': graceSeconds,
      'graceReminderSeconds': graceReminderSeconds,
      'arrivalSeconds': arrivalSeconds,
      'headsUpPositions': headsUpPositions,
      'headsUpMinutes': headsUpMinutes,
      'reslotOffset': reslotOffset,
      'maxReslots': maxReslots,
      'openTime': openTime,
      'joinCutoffTime': joinCutoffTime,
      'closeTime': closeTime,
      'autoCloseAfterMinutes': autoCloseAfterMinutes,
      'timezone': timezone,
      'smsEnabled': smsEnabled,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ClinicSettings',
      'graceSeconds': graceSeconds,
      'graceReminderSeconds': graceReminderSeconds,
      'arrivalSeconds': arrivalSeconds,
      'headsUpPositions': headsUpPositions,
      'headsUpMinutes': headsUpMinutes,
      'reslotOffset': reslotOffset,
      'maxReslots': maxReslots,
      'openTime': openTime,
      'joinCutoffTime': joinCutoffTime,
      'closeTime': closeTime,
      'autoCloseAfterMinutes': autoCloseAfterMinutes,
      'timezone': timezone,
      'smsEnabled': smsEnabled,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _ClinicSettingsImpl extends ClinicSettings {
  _ClinicSettingsImpl({
    required int graceSeconds,
    required int graceReminderSeconds,
    required int arrivalSeconds,
    required int headsUpPositions,
    required int headsUpMinutes,
    required int reslotOffset,
    required int maxReslots,
    required String openTime,
    required String joinCutoffTime,
    required String closeTime,
    required int autoCloseAfterMinutes,
    required String timezone,
    required bool smsEnabled,
  }) : super._(
         graceSeconds: graceSeconds,
         graceReminderSeconds: graceReminderSeconds,
         arrivalSeconds: arrivalSeconds,
         headsUpPositions: headsUpPositions,
         headsUpMinutes: headsUpMinutes,
         reslotOffset: reslotOffset,
         maxReslots: maxReslots,
         openTime: openTime,
         joinCutoffTime: joinCutoffTime,
         closeTime: closeTime,
         autoCloseAfterMinutes: autoCloseAfterMinutes,
         timezone: timezone,
         smsEnabled: smsEnabled,
       );

  /// Returns a shallow copy of this [ClinicSettings]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ClinicSettings copyWith({
    int? graceSeconds,
    int? graceReminderSeconds,
    int? arrivalSeconds,
    int? headsUpPositions,
    int? headsUpMinutes,
    int? reslotOffset,
    int? maxReslots,
    String? openTime,
    String? joinCutoffTime,
    String? closeTime,
    int? autoCloseAfterMinutes,
    String? timezone,
    bool? smsEnabled,
  }) {
    return ClinicSettings(
      graceSeconds: graceSeconds ?? this.graceSeconds,
      graceReminderSeconds: graceReminderSeconds ?? this.graceReminderSeconds,
      arrivalSeconds: arrivalSeconds ?? this.arrivalSeconds,
      headsUpPositions: headsUpPositions ?? this.headsUpPositions,
      headsUpMinutes: headsUpMinutes ?? this.headsUpMinutes,
      reslotOffset: reslotOffset ?? this.reslotOffset,
      maxReslots: maxReslots ?? this.maxReslots,
      openTime: openTime ?? this.openTime,
      joinCutoffTime: joinCutoffTime ?? this.joinCutoffTime,
      closeTime: closeTime ?? this.closeTime,
      autoCloseAfterMinutes:
          autoCloseAfterMinutes ?? this.autoCloseAfterMinutes,
      timezone: timezone ?? this.timezone,
      smsEnabled: smsEnabled ?? this.smsEnabled,
    );
  }
}
