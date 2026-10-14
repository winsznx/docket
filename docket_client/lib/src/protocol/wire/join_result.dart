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
import '../wire/patient_view.dart' as _ioyo36cx;

abstract class JoinResult
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  JoinResult._({
    required this.ticketToken,
    required this.view,
  });

  factory JoinResult({
    required String ticketToken,
    required _ioyo36cx.PatientView view,
  }) = _JoinResultImpl;

  factory JoinResult.fromJson(Map<String, dynamic> jsonSerialization) {
    return JoinResult(
      ticketToken: jsonSerialization['ticketToken'] as String,
      view: _iw6om5a2.Protocol().deserialize<_ioyo36cx.PatientView>(
        jsonSerialization['view'],
      ),
    );
  }

  String ticketToken;

  _ioyo36cx.PatientView view;

  /// Returns a shallow copy of this [JoinResult]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  JoinResult copyWith({
    String? ticketToken,
    _ioyo36cx.PatientView? view,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'JoinResult',
      'ticketToken': ticketToken,
      'view': view.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'JoinResult',
      'ticketToken': ticketToken,
      'view': view.toJsonForProtocol(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _JoinResultImpl extends JoinResult {
  _JoinResultImpl({
    required String ticketToken,
    required _ioyo36cx.PatientView view,
  }) : super._(
         ticketToken: ticketToken,
         view: view,
       );

  /// Returns a shallow copy of this [JoinResult]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  JoinResult copyWith({
    String? ticketToken,
    _ioyo36cx.PatientView? view,
  }) {
    return JoinResult(
      ticketToken: ticketToken ?? this.ticketToken,
      view: view ?? this.view.copyWith(),
    );
  }
}
