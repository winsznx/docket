import 'dart:io';

import 'package:docket_client/docket_client.dart';

/// Component 1 Cloud check (PRD 25): streamed values arrive, and a future
/// call scheduled a minute out fires, including across a redeploy.
///
///   dart run bin/smoke.dart https://docket.api.serverpod.space/ stream
///   dart run bin/smoke.dart https://docket.api.serverpod.space/ schedule 60
///   dart run bin/smoke.dart https://docket.api.serverpod.space/ runs
///   dart run bin/smoke.dart https://docket.api.serverpod.space/ idle 600
Future<void> main(List<String> args) async {
  final client = Client(args[0]);
  switch (args[1]) {
    case 'stream':
      final started = DateTime.now().toUtc();
      await for (final tick in client.smoke.ticks(5)) {
        final lag = DateTime.now().toUtc().difference(tick.serverTime);
        stdout.writeln(
          'tick ${tick.n} from ${tick.serverId} at ${tick.serverTime.toIso8601String()} '
          '(arrived ${lag.inMilliseconds} ms later)',
        );
      }
      stdout.writeln(
        'stream done in ${DateTime.now().toUtc().difference(started).inMilliseconds} ms',
      );
    case 'idle':
      final seconds = int.parse(args[2]);
      final opened = DateTime.now();
      try {
        await for (final tick in client.smoke.idle(seconds)) {
          stdout.writeln(
            'idle tick ${tick.n} after ${DateTime.now().difference(opened).inSeconds} s',
          );
        }
        stdout.writeln('idle stream survived $seconds s');
      } on Object catch (e) {
        stdout.writeln(
          'idle stream dropped after ${DateTime.now().difference(opened).inSeconds} s: $e',
        );
      }
    case 'schedule':
      final run = await client.smoke.schedule(int.parse(args[2]));
      stdout.writeln('scheduled ${run.id} for ${run.scheduledFor.toIso8601String()}');
    case 'runs':
      for (final run in await client.smoke.runs()) {
        final late = run.firedAt?.difference(run.scheduledFor);
        stdout.writeln(
          '${run.id} scheduled ${run.scheduledFor.toIso8601String()} '
          'fired ${run.firedAt?.toIso8601String() ?? 'not yet'}'
          '${late == null ? '' : ' (${late.inMilliseconds} ms after schedule on ${run.serverId})'}',
        );
      }
  }
  client.close();
}
