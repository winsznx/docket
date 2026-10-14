import 'dart:async';

import 'package:serverpod/serverpod.dart';

import 'clinic_jobs.dart';

/// Runs Docket's timer work from the database once a second when this
/// server can't run future calls (see [Timers]). Every rule is the same
/// idempotent one the future calls use, and all state lives in Postgres, so
/// a restart still can't lose a place. It logs at start so nobody mistakes
/// it for the PRD 11 setup.
class LocalScheduler {
  LocalScheduler(this.pod);

  final Serverpod pod;
  Timer? _fast;
  Timer? _presence;
  bool _busy = false;
  String? _lastNightly;

  void start() {
    pod.logVerbose(
      '[timer] future calls are off, running the in-process sweep',
    );
    _fast = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
    _presence = Timer.periodic(
      const Duration(seconds: 15),
      (_) => _run(ClinicJobs.presenceSweep),
    );
  }

  bool _stopped = false;

  void stop() {
    _stopped = true;
    _fast?.cancel();
    _presence?.cancel();
  }

  Future<void> _tick() async {
    if (_busy || _stopped) return;
    _busy = true;
    try {
      await _run(
        (s) => ClinicJobs.timerSweep(
          s,
          minAge: Duration.zero,
          slack: Duration.zero,
        ),
      );
      await _run(ClinicJobs.dueReminders);
      await _run(ClinicJobs.dispatchQueued);
      await _run(ClinicJobs.autoCloseDue);
      final now = DateTime.now().toUtc();
      final today = now.toIso8601String().substring(0, 10);
      if (now.hour == 1 && _lastNightly != today) {
        _lastNightly = today;
        await _run(ClinicJobs.nightly);
      }
    } finally {
      _busy = false;
    }
  }

  Future<void> _run(Future<void> Function(Session) job) async {
    if (_stopped) return;
    final session = await pod.createSession(enableLogging: false);
    try {
      await job(session);
    } on Exception catch (e) {
      session.log('[timer] in-process sweep failed: $e', level: LogLevel.error);
    } finally {
      await session.close();
    }
  }
}
