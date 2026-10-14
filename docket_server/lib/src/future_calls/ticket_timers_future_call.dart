import 'package:serverpod/serverpod.dart';

import '../domain/queue_service.dart';

/// Grace and arrival windows, PRD 11. Each handler re-checks state and
/// `callVersion`, so a duplicate or late run changes nothing.
class TicketTimersFutureCall extends FutureCall {
  Future<void> graceReminder(
    Session session,
    UuidValue ticketId,
    int callVersion,
  ) => QueueService.graceReminder(session, ticketId, callVersion);

  Future<void> graceExpired(
    Session session,
    UuidValue ticketId,
    int callVersion,
  ) => QueueService.windowExpired(
    session,
    ticketId,
    callVersion,
    arrival: false,
  );

  Future<void> arrivalExpired(
    Session session,
    UuidValue ticketId,
    int callVersion,
  ) => QueueService.windowExpired(
    session,
    ticketId,
    callVersion,
    arrival: true,
  );
}
