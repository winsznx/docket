import 'package:docket_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import 'helpers.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod(
    'Given a called ticket with four waiting behind it',
    rollbackDatabase: RollbackDatabase.disabled,
    (builder, endpoints) {
      late Fixture f;
      late Desk desk;
      late JoinResult first;

      setUp(() async {
        f = await Fixture.create(builder, endpoints);
        desk = Desk();
        first = await f.join(builder, endpoints, name: 'First');
        for (var i = 0; i < 4; i++) {
          await f.join(builder, endpoints, name: 'P$i');
        }
        await endpoints.desk.act(builder, desk.callNext(f.room1.id!), f.token);
      });

      test('when grace expires then it re-slots exactly reslotOffset places '
          'from the front, and a second miss expires it', () async {
        await endpoints.futureCalls.ticketTimers.graceExpired(
          builder,
          first.view.ticketId,
          1,
        );
        var view = await endpoints.ticket.get(builder, first.ticketToken);
        expect(view.state, TicketState.waiting);
        expect(view.reslotCount, 1);
        expect(view.position, 3);

        await endpoints.desk.act(builder, desk.callNext(f.room1.id!), f.token);
        await endpoints.desk.act(builder, desk.callNext(f.room2.id!), f.token);
        final third = await endpoints.desk.act(
          builder,
          desk.callNext(f.room1.id!),
          f.token,
        );
        expect(third.ticket!.id, first.view.ticketId);
        expect(third.ticket!.callVersion, 2);

        await endpoints.futureCalls.ticketTimers.graceExpired(
          builder,
          first.view.ticketId,
          2,
        );
        view = await endpoints.ticket.get(builder, first.ticketToken);
        expect(view.state, TicketState.expired);
      });

      test('when the same timer runs twice then the second run changes nothing',
          () async {
        await endpoints.futureCalls.ticketTimers.graceExpired(
          builder,
          first.view.ticketId,
          1,
        );
        final once = await endpoints.ticket.get(builder, first.ticketToken);
        await endpoints.futureCalls.ticketTimers.graceExpired(
          builder,
          first.view.ticketId,
          1,
        );
        final twice = await endpoints.ticket.get(builder, first.ticketToken);
        expect(twice.state, once.state);
        expect(twice.reslotCount, 1);
        expect(twice.version, once.version);
      });

      test('when a stale callVersion fires then it is a no-op', () async {
        await endpoints.futureCalls.ticketTimers.graceExpired(
          builder,
          first.view.ticketId,
          7,
        );
        final view = await endpoints.ticket.get(builder, first.ticketToken);
        expect(view.state, TicketState.called);
      });

      test('when the patient confirms then grace expiry does nothing and '
          'arrival expiry applies the miss rule', () async {
        await endpoints.ticket.confirmComing(builder, first.ticketToken);
        await endpoints.futureCalls.ticketTimers.graceExpired(
          builder,
          first.view.ticketId,
          1,
        );
        var view = await endpoints.ticket.get(builder, first.ticketToken);
        expect(view.state, TicketState.confirmed);
        await endpoints.futureCalls.ticketTimers.arrivalExpired(
          builder,
          first.view.ticketId,
          1,
        );
        view = await endpoints.ticket.get(builder, first.ticketToken);
        expect(view.state, TicketState.waiting);
        expect(view.reslotCount, 1);
      });

      test('when grace runs out then the miss notification is queued once',
          () async {
        await endpoints.futureCalls.ticketTimers.graceExpired(
          builder,
          first.view.ticketId,
          1,
        );
        final events = await TicketEvent.db.find(
          builder.build(),
          where: (t) =>
              t.ticketId.equals(first.view.ticketId) &
              t.type.equals(TicketEventType.graceExpired),
        );
        expect(events, hasLength(1));
        expect(events.single.reason, 'reslotted');
      });
    },
  );
}
