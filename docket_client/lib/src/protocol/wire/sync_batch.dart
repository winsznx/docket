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
import '../wire/desk_action.dart' as _ia6om7l1;

abstract class SyncBatch
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  SyncBatch._({
    required this.deviceId,
    required this.actions,
  });

  factory SyncBatch({
    required _isc.UuidValue deviceId,
    required List<_ia6om7l1.DeskAction> actions,
  }) = _SyncBatchImpl;

  factory SyncBatch.fromJson(Map<String, dynamic> jsonSerialization) {
    return SyncBatch(
      deviceId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['deviceId'],
      ),
      actions: _iw6om5a2.Protocol().deserialize<List<_ia6om7l1.DeskAction>>(
        jsonSerialization['actions'],
      ),
    );
  }

  _isc.UuidValue deviceId;

  List<_ia6om7l1.DeskAction> actions;

  /// Returns a shallow copy of this [SyncBatch]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  SyncBatch copyWith({
    _isc.UuidValue? deviceId,
    List<_ia6om7l1.DeskAction>? actions,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SyncBatch',
      'deviceId': deviceId.toJson(),
      'actions': actions.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SyncBatch',
      'deviceId': deviceId.toJson(),
      'actions': actions.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _SyncBatchImpl extends SyncBatch {
  _SyncBatchImpl({
    required _isc.UuidValue deviceId,
    required List<_ia6om7l1.DeskAction> actions,
  }) : super._(
         deviceId: deviceId,
         actions: actions,
       );

  /// Returns a shallow copy of this [SyncBatch]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  SyncBatch copyWith({
    _isc.UuidValue? deviceId,
    List<_ia6om7l1.DeskAction>? actions,
  }) {
    return SyncBatch(
      deviceId: deviceId ?? this.deviceId,
      actions: actions ?? this.actions.map((e0) => e0.copyWith()).toList(),
    );
  }
}
