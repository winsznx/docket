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

abstract class DeskMeta
    implements _is.SerializableModel, _is.ProtocolSerialization {
  DeskMeta._({
    this.id,
    required this.deviceId,
    this.clinicId,
    this.roomId,
    int? nextSeq,
    String? lineVersionsJson,
    this.lastSnapshotAt,
    this.lastViewJson,
  }) : nextSeq = nextSeq ?? 1,
       lineVersionsJson = lineVersionsJson ?? '{}';

  factory DeskMeta({
    int? id,
    required _is.UuidValue deviceId,
    _is.UuidValue? clinicId,
    _is.UuidValue? roomId,
    int? nextSeq,
    String? lineVersionsJson,
    DateTime? lastSnapshotAt,
    String? lastViewJson,
  }) = _DeskMetaImpl;

  factory DeskMeta.fromJson(Map<String, dynamic> jsonSerialization) {
    return DeskMeta(
      id: jsonSerialization['id'] as int?,
      deviceId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['deviceId'],
      ),
      clinicId: jsonSerialization['clinicId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['clinicId']),
      roomId: jsonSerialization['roomId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['roomId']),
      nextSeq: jsonSerialization['nextSeq'] as int?,
      lineVersionsJson: jsonSerialization['lineVersionsJson'] as String?,
      lastSnapshotAt: jsonSerialization['lastSnapshotAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['lastSnapshotAt'],
            ),
      lastViewJson: jsonSerialization['lastViewJson'] as String?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  _is.UuidValue deviceId;

  _is.UuidValue? clinicId;

  _is.UuidValue? roomId;

  int nextSeq;

  String lineVersionsJson;

  DateTime? lastSnapshotAt;

  String? lastViewJson;

  /// Returns a shallow copy of this [DeskMeta]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  DeskMeta copyWith({
    int? id,
    _is.UuidValue? deviceId,
    _is.UuidValue? clinicId,
    _is.UuidValue? roomId,
    int? nextSeq,
    String? lineVersionsJson,
    DateTime? lastSnapshotAt,
    String? lastViewJson,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DeskMeta',
      if (id != null) 'id': id,
      'deviceId': deviceId.toJson(),
      if (clinicId != null) 'clinicId': clinicId?.toJson(),
      if (roomId != null) 'roomId': roomId?.toJson(),
      'nextSeq': nextSeq,
      'lineVersionsJson': lineVersionsJson,
      if (lastSnapshotAt != null) 'lastSnapshotAt': lastSnapshotAt?.toJson(),
      if (lastViewJson != null) 'lastViewJson': lastViewJson,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DeskMeta',
      if (id != null) 'id': id,
      'deviceId': deviceId.toJson(),
      if (clinicId != null) 'clinicId': clinicId?.toJson(),
      if (roomId != null) 'roomId': roomId?.toJson(),
      'nextSeq': nextSeq,
      'lineVersionsJson': lineVersionsJson,
      if (lastSnapshotAt != null) 'lastSnapshotAt': lastSnapshotAt?.toJson(),
      if (lastViewJson != null) 'lastViewJson': lastViewJson,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DeskMetaImpl extends DeskMeta {
  _DeskMetaImpl({
    int? id,
    required _is.UuidValue deviceId,
    _is.UuidValue? clinicId,
    _is.UuidValue? roomId,
    int? nextSeq,
    String? lineVersionsJson,
    DateTime? lastSnapshotAt,
    String? lastViewJson,
  }) : super._(
         id: id,
         deviceId: deviceId,
         clinicId: clinicId,
         roomId: roomId,
         nextSeq: nextSeq,
         lineVersionsJson: lineVersionsJson,
         lastSnapshotAt: lastSnapshotAt,
         lastViewJson: lastViewJson,
       );

  /// Returns a shallow copy of this [DeskMeta]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  DeskMeta copyWith({
    Object? id = _Undefined,
    _is.UuidValue? deviceId,
    Object? clinicId = _Undefined,
    Object? roomId = _Undefined,
    int? nextSeq,
    String? lineVersionsJson,
    Object? lastSnapshotAt = _Undefined,
    Object? lastViewJson = _Undefined,
  }) {
    return DeskMeta(
      id: id is int? ? id : this.id,
      deviceId: deviceId ?? this.deviceId,
      clinicId: clinicId is _is.UuidValue? ? clinicId : this.clinicId,
      roomId: roomId is _is.UuidValue? ? roomId : this.roomId,
      nextSeq: nextSeq ?? this.nextSeq,
      lineVersionsJson: lineVersionsJson ?? this.lineVersionsJson,
      lastSnapshotAt: lastSnapshotAt is DateTime?
          ? lastSnapshotAt
          : this.lastSnapshotAt,
      lastViewJson: lastViewJson is String? ? lastViewJson : this.lastViewJson,
    );
  }
}
