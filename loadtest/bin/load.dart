import 'dart:async';
import 'dart:io';

import 'package:docket_client/docket_client.dart';

/// PRD 22.4 load test: 300 `ticket.watch` streams on one line while a desk
/// calls every 2 seconds. Latency is the time from the desk sending `act` to
/// each phone receiving its first view at or past the call's line version,
/// so it covers the whole tap-to-phone path.
///
///   dart run bin/load.dart API_URL [streams=300] [calls=30]
Future<void> main(List<String> args) async {
  final api = args[0];
  final streams = args.length > 1 ? int.parse(args[1]) : 300;
  final callCount = args.length > 2 ? int.parse(args[2]) : 30;
  final desk = Client(api);
  final sandbox = await desk.sandbox.start();
  final view = await desk.desk.getView(sandbox.clinicId, sandbox.sandboxToken);
  final line = view.lines.firstWhere((l) => l.code == 'C');
  final rooms = view.rooms.where((r) => r.lineId == line.id).toList();
  final deviceId = UuidValue.fromString(const Uuid().v7());
  var seq = 1;
  UuidValue id() => UuidValue.fromString(const Uuid().v7());

  final tickets = (streams / 2).ceil().clamp(1, 190);
  final tokens = <String>[];
  for (var i = 0; i < tickets; i++) {
    final r = await desk.desk.act(
      AddWalkInAction(
        actionId: id(),
        deviceId: deviceId,
        seq: seq++,
        issuedAtLocal: DateTime.now().toUtc(),
        ticketId: id(),
        lineId: line.id,
        displayName: 'Load ${i + 1}',
      ),
      sandbox.sandboxToken,
    );
    tokens.add(Uri.parse(r.ticketUrl!).pathSegments.last);
  }
  stdout.writeln('created $tickets tickets, opening $streams streams');

  final receipts = List.generate(streams, (_) => <(int, DateTime)>[]);
  final subs = <StreamSubscription<PatientView>>[];
  final phones = <Client>[];
  var connected = 0;
  for (var i = 0; i < streams; i++) {
    final phone = Client(api);
    phones.add(phone);
    var first = true;
    subs.add(
      phone.ticket.watch(tokens[i % tokens.length]).listen((v) {
        if (first) {
          first = false;
          connected++;
        }
        receipts[i].add((v.version, DateTime.now().toUtc()));
      }, onError: (Object e) => stderr.writeln('stream $i error: $e')),
    );
  }
  await Future<void>.delayed(const Duration(seconds: 10));
  stdout.writeln('$connected of $streams streams delivered a first view');

  final calls = <(DateTime, int)>[];
  for (var c = 0; c < callCount; c++) {
    final room = rooms[c % rooms.length];
    final sent = DateTime.now().toUtc();
    final r = await desk.desk.act(
      CallNextAction(
        actionId: id(),
        deviceId: deviceId,
        seq: seq++,
        issuedAtLocal: sent,
        roomId: room.id,
      ),
      sandbox.sandboxToken,
    );
    final after = await desk.desk.getView(sandbox.clinicId, sandbox.sandboxToken);
    calls.add((sent, after.lines.firstWhere((l) => l.id == line.id).version));
    if (r.outcome != ActionOutcome.applied) stdout.writeln('call ${c + 1}: ${r.message}');
    await Future<void>.delayed(const Duration(seconds: 2));
  }
  await Future<void>.delayed(const Duration(seconds: 5));
  for (final s in subs) {
    await s.cancel();
  }
  for (final p in phones) {
    p.close();
  }
  desk.close();

  // For each call, every phone's first view at or past the call's version,
  // timed from the moment the desk sent the action.
  final latencies = <int>[];
  var missed = 0;
  for (final (sent, version) in calls) {
    for (final phone in receipts) {
      final hit = phone.where((r) => r.$1 >= version && !r.$2.isBefore(sent));
      if (hit.isEmpty) {
        missed++;
        continue;
      }
      latencies.add(hit.first.$2.difference(sent).inMilliseconds);
    }
  }
  stdout.writeln('missed $missed of ${calls.length * streams} expected updates');
  latencies.sort();
  int pct(int p) => latencies.isEmpty
      ? -1
      : latencies[((p / 100) * latencies.length).ceil().clamp(1, latencies.length) - 1];
  stdout.writeln(
    'streams=$streams calls=$callCount samples=${latencies.length} '
    'p50=${pct(50)}ms p90=${pct(90)}ms p95=${pct(95)}ms p99=${pct(99)}ms max=${pct(100)}ms',
  );
  exit(0);
}
