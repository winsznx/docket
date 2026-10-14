import 'package:docket_server/src/domain/clinic_jobs.dart';
import 'package:docket_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import 'helpers.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod(
    'Given closed days and an expired sandbox',
    rollbackDatabase: RollbackDatabase.disabled,
    (builder, endpoints) {
      test('when the nightly job runs then contact data and expired sandboxes '
          'are removed and reports stay', () async {
        final kept = await Fixture.create(builder, endpoints);
        final gone = await Fixture.create(builder, endpoints);
        final session = builder.build();
        final joined = await kept.join(builder, endpoints, name: 'Bisi');
        await PushTarget.db.insertRow(
          session,
          PushTarget(
            ticketId: joined.view.ticketId,
            endpoint: 'https://fcm.googleapis.com/fcm/send/x',
            p256dh: 'k',
            authSecret: 'a',
            linkCipher: 'sealed',
          ),
        );
        await endpoints.desk.act(builder, Desk().closeDay(kept.clinicId), kept.token);
        final day = await ServiceDay.db.findFirstRow(
          session,
          where: (t) => t.clinicId.equals(kept.clinicId),
        );
        await ServiceDay.db.updateRow(
          session,
          day!.copyWith(
            closedAt: DateTime.now().toUtc().subtract(const Duration(hours: 25)),
          ),
        );
        final sandbox = (await Clinic.db.findById(session, gone.clinicId))!;
        await Clinic.db.updateRow(
          session,
          sandbox.copyWith(
            sandboxExpiresAt: DateTime.now().toUtc().subtract(
              const Duration(minutes: 1),
            ),
          ),
        );

        await endpoints.futureCalls.clinicJobs.nightly(builder);

        final ticket = await Ticket.db.findById(session, joined.view.ticketId);
        expect(ticket!.displayName, 'Patient');
        expect(
          await PushTarget.db.count(
            session,
            where: (t) => t.ticketId.equals(joined.view.ticketId),
          ),
          0,
        );
        expect(await Clinic.db.findById(session, gone.clinicId), isNull);
        expect(await Clinic.db.findById(session, kept.clinicId), isNotNull);
        final report = await DayReport.db.findFirstRow(
          session,
          where: (t) => t.clinicId.equals(kept.clinicId),
        );
        expect(report, isNotNull);
        expect(report!.data.lines.first.joined, 1);
        await ClinicJobs.nightly(session);
        expect(
          await DayReport.db.count(
            session,
            where: (t) => t.clinicId.equals(kept.clinicId),
          ),
          1,
        );
      });
    },
  );
}
