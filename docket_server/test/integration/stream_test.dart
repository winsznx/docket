import 'package:docket_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import 'helpers.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod(
    'Given a patient watching their ticket',
    rollbackDatabase: RollbackDatabase.disabled,
    (builder, endpoints) {
      test('when the desk calls the patient ahead then the stream emits the '
          'new position', () async {
        final f = await Fixture.create(builder, endpoints);
        await f.join(builder, endpoints, name: 'Ahead');
        final me = await f.join(builder, endpoints, name: 'Me');
        final stream = endpoints.ticket.watch(builder, me.ticketToken);
        final positions = <int?>[];
        final done = stream
            .map((v) => v.position)
            .takeWhile((p) => p != 1)
            .forEach(positions.add);
        await flushEventQueue();
        await Future<void>.delayed(const Duration(milliseconds: 200));
        await endpoints.desk.act(
          builder,
          Desk().callNext(f.room1.id!),
          f.token,
        );
        await done.timeout(const Duration(seconds: 10));
        expect(positions.first, 2);
      });

      test('when the desk heartbeat lapses then the patient view says the '
          'desk is offline', () async {
        final f = await Fixture.create(builder, endpoints);
        final me = await f.join(builder, endpoints);
        final desk = Desk();
        await endpoints.desk.heartbeat(
          builder,
          f.clinicId,
          desk.deviceId,
          f.room1.id,
          f.token,
        );
        expect(
          (await endpoints.ticket.get(builder, me.ticketToken)).deskOnline,
          isTrue,
        );
        final session = builder.build();
        final presence = await DeskPresence.db.findFirstRow(
          session,
          where: (t) => t.deviceId.equals(desk.deviceId),
        );
        await DeskPresence.db.updateRow(
          session,
          presence!.copyWith(
            lastSeenAt: DateTime.now().toUtc().subtract(
              const Duration(seconds: 46),
            ),
          ),
        );
        await endpoints.futureCalls.clinicJobs.presenceSweep(builder);
        expect(
          (await endpoints.ticket.get(builder, me.ticketToken)).deskOnline,
          isFalse,
        );
      });
    },
  );
}
