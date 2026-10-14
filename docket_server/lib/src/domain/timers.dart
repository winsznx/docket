import 'package:serverpod/serverpod.dart';

/// Whether this server can schedule and run future calls. Serverpod Cloud's
/// Starter plan turns future calls off, and then the generated
/// `futureCalls` throws on every use (docs/SPONSOR_FINDINGS.md).
abstract final class Timers {
  static bool scheduling(Serverpod pod) =>
      pod.config.database != null && pod.config.futureCall.enabled;

  static bool executing(Serverpod pod) =>
      scheduling(pod) && pod.config.futureCallExecutionEnabled;

  static String mode(Serverpod pod) => executing(pod)
      ? 'future calls'
      : 'in-process sweep, future calls are off on this server';
}
