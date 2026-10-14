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

enum TicketState implements _isc.SerializableModel {
  waiting,
  called,
  confirmed,
  inService,
  served,
  transferred,
  cancelled,
  removed,
  expired,
  closed;

  static TicketState fromJson(String name) {
    switch (name) {
      case 'waiting':
        return TicketState.waiting;
      case 'called':
        return TicketState.called;
      case 'confirmed':
        return TicketState.confirmed;
      case 'inService':
        return TicketState.inService;
      case 'served':
        return TicketState.served;
      case 'transferred':
        return TicketState.transferred;
      case 'cancelled':
        return TicketState.cancelled;
      case 'removed':
        return TicketState.removed;
      case 'expired':
        return TicketState.expired;
      case 'closed':
        return TicketState.closed;
      default:
        throw ArgumentError(
          'Value "$name" cannot be converted to "TicketState"',
        );
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}
