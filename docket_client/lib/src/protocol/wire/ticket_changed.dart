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

abstract class TicketChanged
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  TicketChanged._({
    required this.ticketId,
    required this.version,
  });

  factory TicketChanged({
    required _isc.UuidValue ticketId,
    required int version,
  }) = _TicketChangedImpl;

  factory TicketChanged.fromJson(Map<String, dynamic> jsonSerialization) {
    return TicketChanged(
      ticketId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['ticketId'],
      ),
      version: jsonSerialization['version'] as int,
    );
  }

  _isc.UuidValue ticketId;

  int version;

  /// Returns a shallow copy of this [TicketChanged]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  TicketChanged copyWith({
    _isc.UuidValue? ticketId,
    int? version,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TicketChanged',
      'ticketId': ticketId.toJson(),
      'version': version,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'TicketChanged',
      'ticketId': ticketId.toJson(),
      'version': version,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _TicketChangedImpl extends TicketChanged {
  _TicketChangedImpl({
    required _isc.UuidValue ticketId,
    required int version,
  }) : super._(
         ticketId: ticketId,
         version: version,
       );

  /// Returns a shallow copy of this [TicketChanged]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  TicketChanged copyWith({
    _isc.UuidValue? ticketId,
    int? version,
  }) {
    return TicketChanged(
      ticketId: ticketId ?? this.ticketId,
      version: version ?? this.version,
    );
  }
}
