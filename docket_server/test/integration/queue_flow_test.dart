import 'package:docket_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import 'helpers.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod(
    'Given a sandbox clinic',
    rollbackDatabase: RollbackDatabase.disabled,
    (builder, endpoints) {
      test(
        'when a patient joins, is called, confirms, starts and finishes '
        'then every step writes one event and bumps the line version',
        () async {
          final f = await Fixture.create(builder, endpoints);
          final desk = Desk();
          final joined = await f.join(builder, endpoints);
          expect(joined.view.state, TicketState.waiting);
          expect(joined.view.position, 1);
          expect(joined.view.label, 'C-001');

          final called = await endpoints.desk.act(
            builder,
            desk.callNext(f.room1.id!),
            f.token,
          );
          expect(called.outcome, ActionOutcome.applied);
          expect(called.ticket!.state, TicketState.called);
          expect(called.ticket!.callVersion, 1);

          final confirmed = await endpoints.ticket.confirmComing(
            builder,
            joined.ticketToken,
          );
          expect(confirmed.state, TicketState.confirmed);
          expect(confirmed.arrivalEndsAt, isNotNull);

          final started = await endpoints.desk.act(
            builder,
            desk.start(joined.view.ticketId, f.room1.id!),
            f.token,
          );
          expect(started.ticket!.state, TicketState.inService);

          final finished = await endpoints.desk.act(
            builder,
            desk.finish(joined.view.ticketId),
            f.token,
          );
          expect(finished.ticket!.state, TicketState.served);

          final session = builder.build();
          final events = await TicketEvent.db.find(
            session,
            where: (t) => t.ticketId.equals(joined.view.ticketId),
            orderBy: (t) => t.lineVersion,
          );
          final types = events.map((e) => e.type).toList();
          expect(
            types,
            containsAllInOrder([
              TicketEventType.joined,
              TicketEventType.called,
              TicketEventType.confirmed,
              TicketEventType.serviceStarted,
              TicketEventType.served,
            ]),
          );
          final versions = events
              .where((e) => e.type != TicketEventType.headsUpSent)
              .map((e) => e.lineVersion)
              .toList();
          for (var i = 1; i < versions.length; i++) {
            expect(versions[i], greaterThan(versions[i - 1]));
          }
          final samples = await ServiceSample.db.find(
            session,
            where: (t) => t.lineId.equals(f.consultation.id!),
          );
          expect(samples, hasLength(1));
        },
      );

      test(
        'when the same actionId is sent twice then the second is a duplicate '
        'with the stored result',
        () async {
          final f = await Fixture.create(builder, endpoints);
          final desk = Desk();
          await f.join(builder, endpoints);
          final action = desk.callNext(f.room1.id!);
          final first = await endpoints.desk.act(builder, action, f.token);
          final second = await endpoints.desk.act(builder, action, f.token);
          expect(first.outcome, ActionOutcome.applied);
          expect(second.outcome, ActionOutcome.duplicate);
          expect(second.ticket!.id, first.ticket!.id);
          final called = await Ticket.db.count(
            builder.build(),
            where: (t) =>
                t.clinicId.equals(f.clinicId) &
                t.state.equals(TicketState.called),
          );
          expect(called, 1);
        },
      );

      test(
        'when a sync batch third action targets a ticket that left then it '
        'returns applied, applied, rejected and a fresh view',
        () async {
          final f = await Fixture.create(builder, endpoints);
          final desk = Desk();
          final a = await f.join(builder, endpoints, name: 'A');
          final b = await f.join(builder, endpoints, name: 'B');
          await f.join(builder, endpoints, name: 'C');
          final call = desk.callNext(f.room1.id!);
          final start = desk.start(a.view.ticketId, f.room1.id!);
          final noShowB = desk.noShow(b.view.ticketId);
          await endpoints.ticket.leave(builder, b.ticketToken);

          final result = await endpoints.desk.sync(
            builder,
            SyncBatch(deviceId: desk.deviceId, actions: [noShowB, start, call]),
            f.token,
          );
          expect(result.results.map((r) => r.outcome).toList(), [
            ActionOutcome.applied,
            ActionOutcome.applied,
            ActionOutcome.rejected,
          ]);
          expect(result.results[2].code, DocketErrorCode.invalidTransition);
          expect(result.results[2].message, 'C-002 had already left the line.');
          expect(result.view.clinicId, f.clinicId);
        },
      );

      test('when the desk closes the day then waiting tickets close and '
          'tickets in service finish', () async {
        final f = await Fixture.create(builder, endpoints);
        final desk = Desk();
        final a = await f.join(builder, endpoints, name: 'A');
        final b = await f.join(builder, endpoints, name: 'B');
        await endpoints.desk.act(builder, desk.callNext(f.room1.id!), f.token);
        await endpoints.desk.act(
          builder,
          desk.start(a.view.ticketId, f.room1.id!),
          f.token,
        );
        final closed = await endpoints.desk.act(
          builder,
          desk.closeDay(f.clinicId),
          f.token,
        );
        expect(closed.outcome, ActionOutcome.applied);
        final va = await endpoints.ticket.get(builder, a.ticketToken);
        final vb = await endpoints.ticket.get(builder, b.ticketToken);
        expect(va.state, TicketState.served);
        expect(va.closedReason, 'auto-finished at close');
        expect(vb.state, TicketState.closed);
        final day = await ServiceDay.db.findFirstRow(
          builder.build(),
          where: (t) => t.clinicId.equals(f.clinicId),
        );
        expect(day!.state, DayState.closed);
        await expectLater(
          f.join(builder, endpoints),
          throwsA(
            isA<DocketException>().having(
              (e) => e.code,
              'code',
              DocketErrorCode.dayClosed,
            ),
          ),
        );
      });

      test('when a ticket in service is transferred then a linked ticket '
          'waits in the target line and the old view carries the new token', () async {
        final f = await Fixture.create(builder, endpoints);
        final desk = Desk();
        final a = await f.join(builder, endpoints);
        await endpoints.desk.act(builder, desk.callNext(f.room1.id!), f.token);
        await endpoints.desk.act(
          builder,
          desk.start(a.view.ticketId, f.room1.id!),
          f.token,
        );
        final moved = await endpoints.desk.act(
          builder,
          desk.transfer(a.view.ticketId, f.lab.id!),
          f.token,
        );
        expect(moved.outcome, ActionOutcome.applied);
        expect(moved.ticket!.label, 'L-001');
        expect(moved.ticket!.state, TicketState.waiting);
        final old = await endpoints.ticket.get(builder, a.ticketToken);
        expect(old.state, TicketState.transferred);
        expect(old.transferredToLabel, 'L-001');
        expect(old.transferredToLineName, 'Lab');
        final next = await endpoints.ticket.get(builder, old.transferredToToken!);
        expect(next.ticketId, moved.ticket!.id);
        expect(next.state, TicketState.waiting);
      });
    },
  );
}
