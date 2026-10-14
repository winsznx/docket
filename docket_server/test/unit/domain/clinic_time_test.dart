import 'package:docket_server/src/domain/clinic_time.dart';
import 'package:test/test.dart';

void main() {
  group('Given clinic-local time in Lagos', () {
    test(
      'when it is 23:30 UTC then the Lagos service date is the next day',
      () {
        final utc = DateTime.utc(2026, 10, 14, 23, 30);
        expect(ClinicTime.serviceDate('Africa/Lagos', utc), '2026-10-15');
      },
    );

    test('when closing at 18:00 plus 120 then it is 19:00 UTC', () {
      expect(
        ClinicTime.atLocal(
          'Africa/Lagos',
          '2026-10-14',
          '18:00',
          addMinutes: 120,
        ),
        DateTime.utc(2026, 10, 14, 19),
      );
    });

    test('when a zone or time is invalid then it is refused', () {
      expect(ClinicTime.isValidZone('Mars/Base'), isFalse);
      expect(ClinicTime.isValidHhmm('24:00'), isFalse);
      expect(ClinicTime.isValidHhmm('08:00'), isTrue);
    });
  });
}
