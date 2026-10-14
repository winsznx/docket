import 'package:docket_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import 'helpers.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod(
    'Given two desks on one line with 40 patients waiting',
    rollbackDatabase: RollbackDatabase.disabled,
    (builder, endpoints) {
      test('when 50 paired Call next actions fire together then no ticket is '
          'called twice and every call gets a ticket or "No one is waiting"',
          () async {
        final f = await Fixture.create(builder, endpoints);
        for (var i = 0; i < 40; i++) {
          await f.join(builder, endpoints, name: 'P$i');
        }
        final a = Desk();
        final b = Desk();
        final results = <DeskActionResult>[];
        for (var i = 0; i < 50; i++) {
          results.addAll(
            await Future.wait([
              endpoints.desk.act(builder, a.callNext(f.room1.id!), f.token),
              endpoints.desk.act(builder, b.callNext(f.room2.id!), f.token),
            ]),
          );
        }
        final applied = results
            .where((r) => r.outcome == ActionOutcome.applied)
            .toList();
        final ids = applied.map((r) => r.ticket!.id).toList();
        expect(ids.toSet().length, ids.length);
        expect(applied, hasLength(40));
        final rejected = results.where(
          (r) => r.outcome == ActionOutcome.rejected,
        );
        expect(rejected, hasLength(60));
        expect(rejected.every((r) => r.message == 'No one is waiting.'), isTrue);
      });
    },
  );
}
