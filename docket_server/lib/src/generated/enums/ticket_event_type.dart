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

enum TicketEventType implements _is.SerializableModel {
  joined,
  walkInAdded,
  priorityInserted,
  called,
  recalled,
  confirmed,
  graceReminderSent,
  headsUpSent,
  graceExpired,
  arrivalExpired,
  markedNoShow,
  reslotted,
  expired,
  serviceStarted,
  served,
  transferred,
  cancelled,
  removed,
  closed;

  static TicketEventType fromJson(String name) {
    switch (name) {
      case 'joined':
        return TicketEventType.joined;
      case 'walkInAdded':
        return TicketEventType.walkInAdded;
      case 'priorityInserted':
        return TicketEventType.priorityInserted;
      case 'called':
        return TicketEventType.called;
      case 'recalled':
        return TicketEventType.recalled;
      case 'confirmed':
        return TicketEventType.confirmed;
      case 'graceReminderSent':
        return TicketEventType.graceReminderSent;
      case 'headsUpSent':
        return TicketEventType.headsUpSent;
      case 'graceExpired':
        return TicketEventType.graceExpired;
      case 'arrivalExpired':
        return TicketEventType.arrivalExpired;
      case 'markedNoShow':
        return TicketEventType.markedNoShow;
      case 'reslotted':
        return TicketEventType.reslotted;
      case 'expired':
        return TicketEventType.expired;
      case 'serviceStarted':
        return TicketEventType.serviceStarted;
      case 'served':
        return TicketEventType.served;
      case 'transferred':
        return TicketEventType.transferred;
      case 'cancelled':
        return TicketEventType.cancelled;
      case 'removed':
        return TicketEventType.removed;
      case 'closed':
        return TicketEventType.closed;
      default:
        throw ArgumentError(
          'Value "$name" cannot be converted to "TicketEventType"',
        );
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}
