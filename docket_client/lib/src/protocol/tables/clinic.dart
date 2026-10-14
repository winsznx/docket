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

abstract class Clinic
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Clinic._({
    this.id,
    required this.name,
    required this.slug,
    String? timezone,
    String? openTime,
    String? joinCutoffTime,
    String? closeTime,
    int? autoCloseAfterMinutes,
    int? graceSeconds,
    int? graceReminderSeconds,
    int? arrivalSeconds,
    int? headsUpPositions,
    int? headsUpMinutes,
    int? reslotOffset,
    int? maxReslots,
    bool? smsEnabled,
    bool? isSandbox,
    this.sandboxExpiresAt,
    DateTime? createdAt,
  }) : timezone = timezone ?? 'Africa/Lagos',
       openTime = openTime ?? '08:00',
       joinCutoffTime = joinCutoffTime ?? '17:00',
       closeTime = closeTime ?? '18:00',
       autoCloseAfterMinutes = autoCloseAfterMinutes ?? 120,
       graceSeconds = graceSeconds ?? 180,
       graceReminderSeconds = graceReminderSeconds ?? 60,
       arrivalSeconds = arrivalSeconds ?? 600,
       headsUpPositions = headsUpPositions ?? 2,
       headsUpMinutes = headsUpMinutes ?? 10,
       reslotOffset = reslotOffset ?? 3,
       maxReslots = maxReslots ?? 1,
       smsEnabled = smsEnabled ?? false,
       isSandbox = isSandbox ?? false,
       createdAt = createdAt ?? DateTime.now();

  factory Clinic({
    _isc.UuidValue? id,
    required String name,
    required String slug,
    String? timezone,
    String? openTime,
    String? joinCutoffTime,
    String? closeTime,
    int? autoCloseAfterMinutes,
    int? graceSeconds,
    int? graceReminderSeconds,
    int? arrivalSeconds,
    int? headsUpPositions,
    int? headsUpMinutes,
    int? reslotOffset,
    int? maxReslots,
    bool? smsEnabled,
    bool? isSandbox,
    DateTime? sandboxExpiresAt,
    DateTime? createdAt,
  }) = _ClinicImpl;

  factory Clinic.fromJson(Map<String, dynamic> jsonSerialization) {
    return Clinic(
      id: jsonSerialization['id'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      name: jsonSerialization['name'] as String,
      slug: jsonSerialization['slug'] as String,
      timezone: jsonSerialization['timezone'] as String?,
      openTime: jsonSerialization['openTime'] as String?,
      joinCutoffTime: jsonSerialization['joinCutoffTime'] as String?,
      closeTime: jsonSerialization['closeTime'] as String?,
      autoCloseAfterMinutes: jsonSerialization['autoCloseAfterMinutes'] as int?,
      graceSeconds: jsonSerialization['graceSeconds'] as int?,
      graceReminderSeconds: jsonSerialization['graceReminderSeconds'] as int?,
      arrivalSeconds: jsonSerialization['arrivalSeconds'] as int?,
      headsUpPositions: jsonSerialization['headsUpPositions'] as int?,
      headsUpMinutes: jsonSerialization['headsUpMinutes'] as int?,
      reslotOffset: jsonSerialization['reslotOffset'] as int?,
      maxReslots: jsonSerialization['maxReslots'] as int?,
      smsEnabled: jsonSerialization['smsEnabled'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['smsEnabled']),
      isSandbox: jsonSerialization['isSandbox'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['isSandbox']),
      sandboxExpiresAt: jsonSerialization['sandboxExpiresAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['sandboxExpiresAt'],
            ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _isc.UuidValue? id;

  String name;

  String slug;

  String timezone;

  String openTime;

  String joinCutoffTime;

  String closeTime;

  int autoCloseAfterMinutes;

  int graceSeconds;

  int graceReminderSeconds;

  int arrivalSeconds;

  int headsUpPositions;

  int headsUpMinutes;

  int reslotOffset;

  int maxReslots;

  bool smsEnabled;

  bool isSandbox;

  DateTime? sandboxExpiresAt;

  DateTime createdAt;

  /// Returns a shallow copy of this [Clinic]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Clinic copyWith({
    _isc.UuidValue? id,
    String? name,
    String? slug,
    String? timezone,
    String? openTime,
    String? joinCutoffTime,
    String? closeTime,
    int? autoCloseAfterMinutes,
    int? graceSeconds,
    int? graceReminderSeconds,
    int? arrivalSeconds,
    int? headsUpPositions,
    int? headsUpMinutes,
    int? reslotOffset,
    int? maxReslots,
    bool? smsEnabled,
    bool? isSandbox,
    DateTime? sandboxExpiresAt,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Clinic',
      if (id != null) 'id': id?.toJson(),
      'name': name,
      'slug': slug,
      'timezone': timezone,
      'openTime': openTime,
      'joinCutoffTime': joinCutoffTime,
      'closeTime': closeTime,
      'autoCloseAfterMinutes': autoCloseAfterMinutes,
      'graceSeconds': graceSeconds,
      'graceReminderSeconds': graceReminderSeconds,
      'arrivalSeconds': arrivalSeconds,
      'headsUpPositions': headsUpPositions,
      'headsUpMinutes': headsUpMinutes,
      'reslotOffset': reslotOffset,
      'maxReslots': maxReslots,
      'smsEnabled': smsEnabled,
      'isSandbox': isSandbox,
      if (sandboxExpiresAt != null)
        'sandboxExpiresAt': sandboxExpiresAt?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Clinic',
      if (id != null) 'id': id?.toJson(),
      'name': name,
      'slug': slug,
      'timezone': timezone,
      'openTime': openTime,
      'joinCutoffTime': joinCutoffTime,
      'closeTime': closeTime,
      'autoCloseAfterMinutes': autoCloseAfterMinutes,
      'graceSeconds': graceSeconds,
      'graceReminderSeconds': graceReminderSeconds,
      'arrivalSeconds': arrivalSeconds,
      'headsUpPositions': headsUpPositions,
      'headsUpMinutes': headsUpMinutes,
      'reslotOffset': reslotOffset,
      'maxReslots': maxReslots,
      'smsEnabled': smsEnabled,
      'isSandbox': isSandbox,
      if (sandboxExpiresAt != null)
        'sandboxExpiresAt': sandboxExpiresAt?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ClinicImpl extends Clinic {
  _ClinicImpl({
    _isc.UuidValue? id,
    required String name,
    required String slug,
    String? timezone,
    String? openTime,
    String? joinCutoffTime,
    String? closeTime,
    int? autoCloseAfterMinutes,
    int? graceSeconds,
    int? graceReminderSeconds,
    int? arrivalSeconds,
    int? headsUpPositions,
    int? headsUpMinutes,
    int? reslotOffset,
    int? maxReslots,
    bool? smsEnabled,
    bool? isSandbox,
    DateTime? sandboxExpiresAt,
    DateTime? createdAt,
  }) : super._(
         id: id,
         name: name,
         slug: slug,
         timezone: timezone,
         openTime: openTime,
         joinCutoffTime: joinCutoffTime,
         closeTime: closeTime,
         autoCloseAfterMinutes: autoCloseAfterMinutes,
         graceSeconds: graceSeconds,
         graceReminderSeconds: graceReminderSeconds,
         arrivalSeconds: arrivalSeconds,
         headsUpPositions: headsUpPositions,
         headsUpMinutes: headsUpMinutes,
         reslotOffset: reslotOffset,
         maxReslots: maxReslots,
         smsEnabled: smsEnabled,
         isSandbox: isSandbox,
         sandboxExpiresAt: sandboxExpiresAt,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [Clinic]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Clinic copyWith({
    Object? id = _Undefined,
    String? name,
    String? slug,
    String? timezone,
    String? openTime,
    String? joinCutoffTime,
    String? closeTime,
    int? autoCloseAfterMinutes,
    int? graceSeconds,
    int? graceReminderSeconds,
    int? arrivalSeconds,
    int? headsUpPositions,
    int? headsUpMinutes,
    int? reslotOffset,
    int? maxReslots,
    bool? smsEnabled,
    bool? isSandbox,
    Object? sandboxExpiresAt = _Undefined,
    DateTime? createdAt,
  }) {
    return Clinic(
      id: id is _isc.UuidValue? ? id : this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      timezone: timezone ?? this.timezone,
      openTime: openTime ?? this.openTime,
      joinCutoffTime: joinCutoffTime ?? this.joinCutoffTime,
      closeTime: closeTime ?? this.closeTime,
      autoCloseAfterMinutes:
          autoCloseAfterMinutes ?? this.autoCloseAfterMinutes,
      graceSeconds: graceSeconds ?? this.graceSeconds,
      graceReminderSeconds: graceReminderSeconds ?? this.graceReminderSeconds,
      arrivalSeconds: arrivalSeconds ?? this.arrivalSeconds,
      headsUpPositions: headsUpPositions ?? this.headsUpPositions,
      headsUpMinutes: headsUpMinutes ?? this.headsUpMinutes,
      reslotOffset: reslotOffset ?? this.reslotOffset,
      maxReslots: maxReslots ?? this.maxReslots,
      smsEnabled: smsEnabled ?? this.smsEnabled,
      isSandbox: isSandbox ?? this.isSandbox,
      sandboxExpiresAt: sandboxExpiresAt is DateTime?
          ? sandboxExpiresAt
          : this.sandboxExpiresAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
