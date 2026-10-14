import 'package:serverpod/serverpod.dart';

/// Reports how many future calls are more than 10 seconds overdue
/// (PRD 19). Informational, so a slow scan never pulls the pod out of
/// rotation.
class OverdueTimersIndicator extends HealthIndicator<int> {
  @override
  String get name => 'docket:overdue-timers';

  @override
  String get componentType => HealthComponentType.component.name;

  @override
  String get observedUnit => 'calls';

  @override
  Duration get timeout => const Duration(seconds: 2);

  @override
  Future<HealthCheckResult> check() async {
    final session = await Serverpod.instance.createSession(
      enableLogging: false,
    );
    try {
      final result = await session.db.unsafeQuery(
        'SELECT count(*) FROM serverpod_future_call '
        "WHERE \"time\" < (now() at time zone 'utc') - interval '10 seconds'",
      );
      final count = result.first.first as int;
      return pass(
        observedValue: count,
        output: count == 0 ? null : '$count timers are overdue.',
      );
    } on Exception catch (e) {
      return pass(output: "Couldn't count overdue timers: $e");
    } finally {
      await session.close();
    }
  }
}

/// Says how timers run on this server: Serverpod future calls, or the
/// in-process sweep when the plan has future calls off.
class TimerModeIndicator extends HealthIndicator<String> {
  TimerModeIndicator(this.mode);

  final String Function() mode;

  @override
  String get name => 'docket:timer-mode';

  @override
  Future<HealthCheckResult> check() async => pass(observedValue: mode());
}
