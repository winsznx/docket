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

abstract class BoardCall
    implements _is.SerializableModel, _is.ProtocolSerialization {
  BoardCall._({
    required this.label,
    required this.roomName,
    required this.calledAt,
    required this.callVersion,
  });

  factory BoardCall({
    required String label,
    required String roomName,
    required DateTime calledAt,
    required int callVersion,
  }) = _BoardCallImpl;

  factory BoardCall.fromJson(Map<String, dynamic> jsonSerialization) {
    return BoardCall(
      label: jsonSerialization['label'] as String,
      roomName: jsonSerialization['roomName'] as String,
      calledAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['calledAt'],
      ),
      callVersion: jsonSerialization['callVersion'] as int,
    );
  }

  String label;

  String roomName;

  DateTime calledAt;

  int callVersion;

  /// Returns a shallow copy of this [BoardCall]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  BoardCall copyWith({
    String? label,
    String? roomName,
    DateTime? calledAt,
    int? callVersion,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'BoardCall',
      'label': label,
      'roomName': roomName,
      'calledAt': calledAt.toJson(),
      'callVersion': callVersion,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'BoardCall',
      'label': label,
      'roomName': roomName,
      'calledAt': calledAt.toJson(),
      'callVersion': callVersion,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _BoardCallImpl extends BoardCall {
  _BoardCallImpl({
    required String label,
    required String roomName,
    required DateTime calledAt,
    required int callVersion,
  }) : super._(
         label: label,
         roomName: roomName,
         calledAt: calledAt,
         callVersion: callVersion,
       );

  /// Returns a shallow copy of this [BoardCall]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  BoardCall copyWith({
    String? label,
    String? roomName,
    DateTime? calledAt,
    int? callVersion,
  }) {
    return BoardCall(
      label: label ?? this.label,
      roomName: roomName ?? this.roomName,
      calledAt: calledAt ?? this.calledAt,
      callVersion: callVersion ?? this.callVersion,
    );
  }
}
