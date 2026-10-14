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
import '../wire/desk_action_result.dart' as _iq88o78o;
import '../wire/desk_view.dart' as _i3zwp1jx;

abstract class SyncResult
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  SyncResult._({
    required this.results,
    required this.view,
  });

  factory SyncResult({
    required List<_iq88o78o.DeskActionResult> results,
    required _i3zwp1jx.DeskView view,
  }) = _SyncResultImpl;

  factory SyncResult.fromJson(Map<String, dynamic> jsonSerialization) {
    return SyncResult(
      results: _iw6om5a2.Protocol()
          .deserialize<List<_iq88o78o.DeskActionResult>>(
            jsonSerialization['results'],
          ),
      view: _iw6om5a2.Protocol().deserialize<_i3zwp1jx.DeskView>(
        jsonSerialization['view'],
      ),
    );
  }

  List<_iq88o78o.DeskActionResult> results;

  _i3zwp1jx.DeskView view;

  /// Returns a shallow copy of this [SyncResult]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  SyncResult copyWith({
    List<_iq88o78o.DeskActionResult>? results,
    _i3zwp1jx.DeskView? view,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SyncResult',
      'results': results.toJson(valueToJson: (v) => v.toJson()),
      'view': view.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SyncResult',
      'results': results.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'view': view.toJsonForProtocol(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _SyncResultImpl extends SyncResult {
  _SyncResultImpl({
    required List<_iq88o78o.DeskActionResult> results,
    required _i3zwp1jx.DeskView view,
  }) : super._(
         results: results,
         view: view,
       );

  /// Returns a shallow copy of this [SyncResult]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  SyncResult copyWith({
    List<_iq88o78o.DeskActionResult>? results,
    _i3zwp1jx.DeskView? view,
  }) {
    return SyncResult(
      results: results ?? this.results.map((e0) => e0.copyWith()).toList(),
      view: view ?? this.view.copyWith(),
    );
  }
}
