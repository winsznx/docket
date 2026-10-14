import 'dart:async';
import 'dart:io';

import 'package:docket_client/docket_client.dart';

/// PRD 22.4 restart test, the client half. Sets a short grace window on a
/// fresh sandbox, calls a patient, and waits for the re-slot. Restart the
/// server while it waits. Prints how late the re-slot landed.
///
///   dart run bin/restart.dart API_URL [graceSeconds=60]
Future<void> main(List<String> args) async {
  final api = args[0];
  final grace = args.length > 1 ? int.parse(args[1]) : 60;
  final client = Client(api);
  final sb = await client.sandbox.start();
  final owner = await client.owner.getOwnerView(sb.clinicId, sb.sandboxToken);
  final c = owner.clinic;
  await client.owner.updateSettings(
    sb.clinicId,
    ClinicSettings(
      graceSeconds: grace,
      graceReminderSeconds: 15,
      arrivalSeconds: c.arrivalSeconds,
      headsUpPositions: c.headsUpPositions,
      headsUpMinutes: c.headsUpMinutes,
      reslotOffset: c.reslotOffset,
      maxReslots: c.maxReslots,
      openTime: c.openTime,
      joinCutoffTime: c.joinCutoffTime,
      closeTime: c.closeTime,
      autoCloseAfterMinutes: c.autoCloseAfterMinutes,
      timezone: c.timezone,
      smsEnabled: false,
    ),
    sb.sandboxToken,
  );
  final line = owner.lines.firstWhere((l) => l.code == 'C');
  final room = owner.rooms.firstWhere((r) => r.lineId == line.id);
  final tokens = <String>[];
  for (var i = 0; i < 4; i++) {
    final r = await client.publicClinic.join(
      JoinRequest(
        clinicSlug: sb.clinicSlug,
        lineId: line.id!,
        displayName: 'Restart ${i + 1}',
        smsConsent: false,
      ),
    );
    tokens.add(r.ticketToken);
  }
  final called = await client.desk.act(
    CallNextAction(
      actionId: UuidValue.fromString(const Uuid().v7()),
      deviceId: UuidValue.fromString(const Uuid().v7()),
      seq: 1,
      issuedAtLocal: DateTime.now().toUtc(),
      roomId: room.id!,
    ),
    sb.sandboxToken,
  );
  final graceEnd = called.ticket!.graceEndsAt!;
  stdout.writeln('CALLED grace ends ${graceEnd.toIso8601String()}');
  client.close();

  final deadline = DateTime.now().add(Duration(seconds: grace + 240));
  while (DateTime.now().isBefore(deadline)) {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    final probe = Client(api);
    try {
      final v = await probe.ticket.get(tokens.first);
      if (v.state == TicketState.waiting && v.reslotCount == 1) {
        final late = DateTime.now().toUtc().difference(graceEnd);
        stdout.writeln(
          'RESLOTTED position ${v.position} landed ${late.inMilliseconds} ms '
          'after the scheduled grace end',
        );
        probe.close();
        exit(0);
      }
    } on Object {
      // The server is down mid-restart. Keep polling until it's back.
    } finally {
      probe.close();
    }
  }
  stdout.writeln('FAILED no re-slot within 4 minutes of the grace end');
  exit(1);
}
