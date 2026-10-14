import 'package:serverpod/serverpod.dart';

import '../domain/timers.dart';
import '../generated/future_calls.dart';
import '../generated/protocol.dart';

/// Component 1 Cloud check: a stream that ticks once a second and a future
/// call scheduled a minute out whose firing time is stored.
class SmokeEndpoint extends Endpoint {
  Stream<SmokeTick> ticks(Session session, int count) async* {
    final n = count.clamp(1, 120);
    for (var i = 1; i <= n; i++) {
      yield SmokeTick(
        n: i,
        serverTime: DateTime.now().toUtc(),
        serverId: session.serverpod.serverId,
      );
      await Future<void>.delayed(const Duration(seconds: 1));
    }
  }

  /// Sends one value, stays silent for [seconds], then sends another, to
  /// measure how long an idle stream survives Cloud's load balancer
  /// (PRD 23).
  Stream<SmokeTick> idle(Session session, int seconds) async* {
    yield SmokeTick(
      n: 1,
      serverTime: DateTime.now().toUtc(),
      serverId: session.serverpod.serverId,
    );
    await Future<void>.delayed(Duration(seconds: seconds.clamp(1, 1800)));
    yield SmokeTick(
      n: 2,
      serverTime: DateTime.now().toUtc(),
      serverId: session.serverpod.serverId,
    );
  }

  Future<SmokeRun> schedule(Session session, int delaySeconds) async {
    final due = DateTime.now().toUtc().add(
      Duration(seconds: delaySeconds.clamp(5, 900)),
    );
    final run = await SmokeRun.db.insertRow(
      session,
      SmokeRun(label: 'cloud-smoke', scheduledFor: due),
    );
    if (!Timers.scheduling(session.serverpod)) {
      throw DocketException(
        code: DocketErrorCode.validation,
        message:
            'Future calls are off on this server, so nothing was scheduled.',
      );
    }
    await session.serverpod.futureCalls
        .callAtTime(due, identifier: 'smoke:${run.id}')
        .smoke
        .fire(run.id!);
    return run;
  }

  /// Times [count] trivial round trips to the database from this podlet,
  /// in microseconds each, to separate database latency from network.
  Future<List<int>> dbPing(Session session, int count) async {
    final times = <int>[];
    for (var i = 0; i < count.clamp(1, 50); i++) {
      final sw = Stopwatch()..start();
      await session.db.unsafeSimpleQuery('SELECT 1');
      times.add(sw.elapsedMicroseconds);
    }
    return times;
  }

  /// A fixed CPU workload, timed in milliseconds, to compare this podlet's
  /// CPU with a development machine.
  Future<int> cpu(Session session) async {
    final sw = Stopwatch()..start();
    var x = 0;
    for (var i = 0; i < 20000000; i++) {
      x = (x * 31 + i) & 0x7fffffff;
    }
    final ms = sw.elapsedMilliseconds;
    return x == -1 ? -1 : ms;
  }

  /// [count] primary-key reads through the ORM, in microseconds each.
  Future<List<int>> ormPing(Session session, int count) async {
    final times = <int>[];
    for (var i = 0; i < count.clamp(1, 50); i++) {
      final sw = Stopwatch()..start();
      await SmokeRun.db.findFirstRow(session);
      times.add(sw.elapsedMicroseconds);
    }
    return times;
  }

  Future<List<SmokeRun>> runs(Session session) => SmokeRun.db.find(
    session,
    orderBy: (t) => t.scheduledFor.desc(),
    limit: 20,
  );
}
