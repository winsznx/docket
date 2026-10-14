import 'package:serverpod/serverpod.dart';

import '../generated/future_calls.dart';
import '../generated/protocol.dart';
import '../notify/dispatcher.dart';
import 'actor.dart';
import 'clinic_time.dart';
import 'eta.dart';
import 'line_queue.dart';
import 'queue_service.dart';
import 'reports.dart';
import 'timers.dart';

/// Day close, nightly upkeep and the two sweeps (PRD 11).
abstract final class ClinicJobs {
  static Future<void> autoCloseDay(
    Session session,
    UuidValue clinicId,
    String serviceDate,
  ) async {
    final clinic = await Clinic.db.findById(session, clinicId);
    if (clinic == null) return;
    final day = await ServiceDay.db.findFirstRow(
      session,
      where: (t) =>
          t.clinicId.equals(clinicId) & t.serviceDate.equals(serviceDate),
    );
    if (day == null || day.state != DayState.open) return;
    if (LineQueue.serviceDateNow(clinic) != serviceDate) {
      await ServiceDay.db.updateRow(
        session,
        day.copyWith(state: DayState.closed, closedAt: DateTime.now().toUtc()),
      );
      return;
    }
    await QueueService.closeDay(session, clinic, Actor.system);
    session.log('[timer] auto-closed ${clinic.slug} $serviceDate');
  }

  /// Any grace or arrival window whose future call was lost is applied here
  /// by the same idempotent rule, and any notification that never got a
  /// dispatch call is enqueued again.
  static Future<void> timerSweep(
    Session session, {
    Duration minAge = const Duration(seconds: 30),
    Duration slack = const Duration(seconds: 2),
  }) async {
    final now = DateTime.now().toUtc();
    final active = await Ticket.db.find(
      session,
      where: (t) =>
          t.state.inSet({TicketState.called, TicketState.confirmed}) &
          (t.calledAt < now.subtract(minAge)),
    );
    final clinics = <UuidValue, Clinic?>{};
    for (final ticket in active) {
      final clinic = clinics[ticket.clinicId] ??= await Clinic.db.findById(
        session,
        ticket.clinicId,
      );
      if (clinic == null) continue;
      final overdue = ticket.state == TicketState.called
          ? ticket.calledAt!.add(Duration(seconds: clinic.graceSeconds))
          : ticket.confirmedAt?.add(Duration(seconds: clinic.arrivalSeconds));
      if (overdue == null || overdue.isAfter(now.subtract(slack))) continue;
      final applied = await QueueService.windowExpired(
        session,
        ticket.id!,
        ticket.callVersion,
        arrival: ticket.state == TicketState.confirmed,
      );
      if (applied && minAge > Duration.zero) {
        session.log(
          '[timer] sweep applied an overdue window for ${ticket.label}',
          level: LogLevel.warning,
        );
      }
    }
    if (!Timers.scheduling(session.serverpod)) return;

    final stuck = await Notification.db.find(
      session,
      where: (t) =>
          t.status.equals(DeliveryStatus.queued) &
          t.attempts.equals(0) &
          (t.createdAt < now.subtract(const Duration(seconds: 45))) &
          (t.createdAt > now.subtract(const Duration(hours: 2))),
      limit: 100,
    );
    for (final n in stuck) {
      await session.serverpod.futureCalls
          .callWithDelay(Duration.zero, identifier: 'dispatch:${n.id}:sweep')
          .dispatch
          .send(n.id!);
    }
  }

  /// Grace reminders that are due, for servers without future calls.
  static Future<void> dueReminders(Session session) async {
    final now = DateTime.now().toUtc();
    final called = await Ticket.db.find(
      session,
      where: (t) => t.state.equals(TicketState.called),
    );
    final clinics = <UuidValue, Clinic?>{};
    for (final ticket in called) {
      final clinic = clinics[ticket.clinicId] ??= await Clinic.db.findById(
        session,
        ticket.clinicId,
      );
      if (clinic == null || ticket.calledAt == null) continue;
      if (clinic.graceReminderSeconds >= clinic.graceSeconds) continue;
      final due = ticket.calledAt!.add(
        Duration(seconds: clinic.graceSeconds - clinic.graceReminderSeconds),
      );
      if (now.isBefore(due)) continue;
      await QueueService.graceReminder(session, ticket.id!, ticket.callVersion);
    }
  }

  /// Queued notifications and their retries, for servers without future
  /// calls. Retry spacing follows PRD 14.2: 30 s, then 120 s.
  static Future<void> dispatchQueued(Session session) async {
    final now = DateTime.now().toUtc();
    final queued = await Notification.db.find(
      session,
      where: (t) =>
          t.status.equals(DeliveryStatus.queued) &
          (t.createdAt > now.subtract(const Duration(hours: 2))),
      orderBy: (t) => t.createdAt,
      limit: 25,
    );
    for (final n in queued) {
      final wait = switch (n.attempts) {
        0 => Duration.zero,
        1 => Dispatcher.retryDelays[0],
        _ => Dispatcher.retryDelays[0] + Dispatcher.retryDelays[1],
      };
      if (now.isBefore(n.createdAt.add(wait))) continue;
      await Dispatcher.send(session, n.id!);
    }
  }

  /// Days past `closeTime + autoCloseAfterMinutes`, for servers without
  /// future calls.
  static Future<void> autoCloseDue(Session session) async {
    final now = DateTime.now().toUtc();
    final open = await ServiceDay.db.find(
      session,
      where: (t) => t.state.equals(DayState.open),
    );
    for (final day in open) {
      final clinic = await Clinic.db.findById(session, day.clinicId);
      if (clinic == null) continue;
      final closeAt = ClinicTime.atLocal(
        clinic.timezone,
        day.serviceDate,
        clinic.closeTime,
        addMinutes: clinic.autoCloseAfterMinutes,
      );
      if (now.isBefore(closeAt)) continue;
      await autoCloseDay(session, day.clinicId, day.serviceDate);
    }
  }

  /// Lines whose last desk heartbeat just lapsed get a LineChanged so every
  /// patient sees the desk-offline banner without waiting for a heartbeat.
  static Future<void> presenceSweep(Session session) async {
    final now = DateTime.now().toUtc();
    final lapsed = await DeskPresence.db.find(
      session,
      where: (t) =>
          (t.lastSeenAt <= now.subtract(Eta.presenceWindow)) &
          (t.lastSeenAt >
              now.subtract(Eta.presenceWindow + const Duration(seconds: 16))),
    );
    final clinicIds = lapsed.map((p) => p.clinicId).toSet();
    for (final clinicId in clinicIds) {
      final lines = await Line.db.find(
        session,
        where: (t) => t.clinicId.equals(clinicId),
      );
      for (final line in lines) {
        await session.messages.postMessage(
          'line.${line.id}',
          LineChanged(
            lineId: line.id!,
            version: line.version,
            reason: 'presence',
          ),
        );
      }
    }
    await DeskPresence.db.deleteWhere(
      session,
      where: (t) => t.lastSeenAt < now.subtract(const Duration(days: 2)),
    );
  }

  static Future<void> nightly(Session session) async {
    final now = DateTime.now().toUtc();

    final closedDays = await ServiceDay.db.find(
      session,
      where: (t) => t.state.equals(DayState.closed),
    );
    for (final day in closedDays) {
      final exists = await DayReport.db.findFirstRow(
        session,
        where: (t) =>
            t.clinicId.equals(day.clinicId) &
            t.serviceDate.equals(day.serviceDate),
      );
      if (exists != null) continue;
      final clinic = await Clinic.db.findById(session, day.clinicId);
      if (clinic == null) continue;
      await DayReport.db.insert(
        session,
        [
          DayReport(
            clinicId: day.clinicId,
            serviceDate: day.serviceDate,
            generatedAt: now,
            data: await Reports.build(session, clinic, day.serviceDate),
          ),
        ],
        ignoreConflicts: true,
      );
    }

    await purgeContactData(session, now);
    await purgeSandboxes(session, now);

    await RateBucket.db.deleteWhere(
      session,
      where: (t) => t.windowStart < now.subtract(const Duration(days: 2)),
    );
    await TicketEvent.db.updateWhere(
      session,
      where: (t) =>
          (t.at < now.subtract(const Duration(days: 30))) &
          (t.reason.notEquals(null) | t.actorRef.notEquals(null)),
      columnValues: (t) => [t.reason(null), t.actorRef(null)],
    );
    session.log('[timer] nightly upkeep finished');
  }

  /// Names become "Patient" and phone and push targets are deleted for
  /// service days that closed more than 24 hours ago (PRD 11, 18).
  static Future<void> purgeContactData(Session session, DateTime now) async {
    final days = await ServiceDay.db.find(
      session,
      where: (t) =>
          t.state.equals(DayState.closed) &
          (t.closedAt < now.subtract(const Duration(hours: 24))),
    );
    for (final day in days) {
      final tickets = await Ticket.db.find(
        session,
        where: (t) =>
            t.clinicId.equals(day.clinicId) &
            t.serviceDate.equals(day.serviceDate),
      );
      if (tickets.isEmpty) continue;
      final ids = tickets.map((t) => t.id!).toSet();
      await SmsTarget.db.deleteWhere(
        session,
        where: (t) => t.ticketId.inSet(ids),
      );
      await PushTarget.db.deleteWhere(
        session,
        where: (t) => t.ticketId.inSet(ids),
      );
      await Ticket.db.updateWhere(
        session,
        where: (t) => t.id.inSet(ids) & t.displayName.notEquals('Patient'),
        columnValues: (t) => [t.displayName('Patient')],
      );
    }
  }

  static Future<void> purgeSandboxes(Session session, DateTime now) async {
    final expired = await Clinic.db.find(
      session,
      where: (t) => t.isSandbox.equals(true) & (t.sandboxExpiresAt < now),
    );
    for (final clinic in expired) {
      final id = clinic.id!;
      final ticketIds = (await Ticket.db.find(
        session,
        where: (t) => t.clinicId.equals(id),
      )).map((t) => t.id!).toSet();
      if (ticketIds.isNotEmpty) {
        await PushTarget.db.deleteWhere(
          session,
          where: (t) => t.ticketId.inSet(ticketIds),
        );
        await SmsTarget.db.deleteWhere(
          session,
          where: (t) => t.ticketId.inSet(ticketIds),
        );
      }
      final lineIds = (await Line.db.find(
        session,
        where: (t) => t.clinicId.equals(id),
      )).map((l) => l.id!).toSet();
      if (lineIds.isNotEmpty) {
        await ServiceSample.db.deleteWhere(
          session,
          where: (t) => t.lineId.inSet(lineIds),
        );
      }
      await TicketEvent.db.deleteWhere(
        session,
        where: (t) => t.clinicId.equals(id),
      );
      await Notification.db.deleteWhere(
        session,
        where: (t) => t.clinicId.equals(id),
      );
      await DeskActionReceipt.db.deleteWhere(
        session,
        where: (t) => t.clinicId.equals(id),
      );
      await DeskPresence.db.deleteWhere(
        session,
        where: (t) => t.clinicId.equals(id),
      );
      await DayReport.db.deleteWhere(
        session,
        where: (t) => t.clinicId.equals(id),
      );
      await StaffInvite.db.deleteWhere(
        session,
        where: (t) => t.clinicId.equals(id),
      );
      await Clinic.db.deleteRow(session, clinic);
      session.log('[timer] purged sandbox ${clinic.slug}');
    }
  }
}
