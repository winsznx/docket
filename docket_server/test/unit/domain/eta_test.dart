import 'package:docket_server/src/domain/eta.dart';
import 'package:test/test.dart';

void main() {
  group('Given ETA inputs', () {
    test('when fewer than 3 samples then the line default is used', () {
      expect(Eta.medianServiceSeconds([100, 200], 480), 480);
    });

    test('when samples exist then the median of the newest 10 is used', () {
      expect(Eta.medianServiceSeconds([300, 100, 200], 480), 200);
      expect(Eta.medianServiceSeconds([100, 200, 300, 400], 480), 250);
      final twelve = [for (var i = 1; i <= 12; i++) i * 10];
      expect(Eta.medianServiceSeconds(twelve, 480), 55);
    });

    test('when 3rd with 2 active rooms and 480 s then 960 s', () {
      expect(
        Eta.seconds(position: 3, activeRooms: 2, medianServiceSeconds: 480),
        960,
      );
    });

    test('when no room is active then it counts one', () {
      expect(
        Eta.seconds(position: 2, activeRooms: 0, medianServiceSeconds: 300),
        600,
      );
    });

    test('then it is never zero or negative', () {
      expect(
        Eta.seconds(position: 0, activeRooms: 1, medianServiceSeconds: 0),
        1,
      );
      expect(Eta.minutes(1), 1);
    });
  });

  group('Given the display rules', () {
    for (final (seconds, text) in [
      (60, 'under 5 min'),
      (299, 'under 5 min'),
      (300, 'about 5 min'),
      (14 * 60, 'about 14 min'),
      (15 * 60, 'about 15 min'),
      (23 * 60, 'about 25 min'),
      (60 * 60, 'about 60 min'),
      (61 * 60, 'over an hour'),
    ]) {
      test('when $seconds s then "$text"', () {
        expect(Eta.text(seconds, early: false), text);
      });
    }

    test('when fewer than 3 samples then it says early estimate', () {
      expect(Eta.text(600, early: true), 'about 10 min, early estimate');
    });
  });
}
