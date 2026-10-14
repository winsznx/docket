import 'package:serverpod/serverpod.dart';

import '../domain/clinic_jobs.dart';

/// Day close, nightly upkeep and the two sweeps, PRD 11.
class ClinicJobsFutureCall extends FutureCall {
  Future<void> autoCloseDay(
    Session session,
    UuidValue clinicId,
    String serviceDate,
  ) => ClinicJobs.autoCloseDay(session, clinicId, serviceDate);

  Future<void> nightly(Session session) => ClinicJobs.nightly(session);

  Future<void> presenceSweep(Session session) =>
      ClinicJobs.presenceSweep(session);

  Future<void> timerSweep(Session session) => ClinicJobs.timerSweep(session);
}
