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

abstract class TicketChanged
    implements _is.SerializableModel, _is.ProtocolSerialization {
  TicketChanged._({
    required this.ticketId,
    required this.version,
  });

  factory TicketChanged({
    required _is.UuidValue ticketId,
    required int version,
  }) = _TicketChangedImpl;

  factory TicketChanged.fromJson(Map<String, dynamic> jsonSerialization) {
    return TicketChanged(
      ticketId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['ticketId'],
      ),
      version: jsonSerialization['version'] as int,
    );
  }

  _is.UuidValue ticketId;

  int version;

  /// Returns a shallow copy of this [TicketChanged]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  TicketChanged copyWith({
    _is.UuidValue? ticketId,
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
    return _is.SerializationManager.encode(this);
  }
}

class _TicketChangedImpl extends TicketChanged {
  _TicketChangedImpl({
    required _is.UuidValue ticketId,
    required int version,
  }) : super._(
         ticketId: ticketId,
         version: version,
       );

  /// Returns a shallow copy of this [TicketChanged]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  TicketChanged copyWith({
    _is.UuidValue? ticketId,
    int? version,
  }) {
    return TicketChanged(
      ticketId: ticketId ?? this.ticketId,
      version: version ?? this.version,
    );
  }
}
