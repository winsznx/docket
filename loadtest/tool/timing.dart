import 'package:docket_client/docket_client.dart';

Future<void> main(List<String> args) async {
  final client = Client(args[0]);
  Future<void> time(String name, Future<Object?> Function() f) async {
    final sw = Stopwatch()..start();
    await f();
    print('$name ${sw.elapsedMilliseconds} ms');
  }

  await time('vapidPublicKey (no db)', () => client.publicClinic.vapidPublicKey());
  await time('vapidPublicKey again', () => client.publicClinic.vapidPublicKey());
  final sb = await client.sandbox.start();
  final j = await client.publicClinic.join(
    JoinRequest(
      clinicSlug: sb.clinicSlug,
      lineId: (await client.desk.getView(sb.clinicId, sb.sandboxToken)).lines.first.id,
      displayName: 'T',
      smsConsent: false,
    ),
  );
  for (var i = 0; i < 3; i++) {
    await time('ticket.get', () => client.ticket.get(j.ticketToken));
  }
  for (var i = 0; i < 2; i++) {
    await time('desk.getView', () => client.desk.getView(sb.clinicId, sb.sandboxToken));
  }
  final view = await client.desk.getView(sb.clinicId, sb.sandboxToken);
  final room = view.rooms.first;
  final device = UuidValue.fromString(const Uuid().v7());
  for (var i = 0; i < 3; i++) {
    await client.publicClinic.join(
      JoinRequest(
        clinicSlug: sb.clinicSlug,
        lineId: room.lineId,
        displayName: 'T$i',
        smsConsent: false,
      ),
    );
  }
  for (var i = 0; i < 3; i++) {
    await time(
      'desk.act CallNext',
      () => client.desk.act(
        CallNextAction(
          actionId: UuidValue.fromString(const Uuid().v7()),
          deviceId: device,
          seq: i + 1,
          issuedAtLocal: DateTime.now().toUtc(),
          roomId: room.id,
        ),
        sb.sandboxToken,
      ),
    );
  }
  client.close();
}
