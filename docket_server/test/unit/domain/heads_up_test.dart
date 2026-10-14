import 'package:docket_server/src/domain/heads_up.dart';
import 'package:test/test.dart';

void main() {
  bool due({bool sent = false, int pos = 5, int eta = 3600}) => HeadsUp.due(
    alreadySent: sent,
    position: pos,
    etaSeconds: eta,
    headsUpPositions: 2,
    headsUpMinutes: 10,
  );

  group('Given the heads-up rule with 2 places or 10 minutes', () {
    test('when 3rd with a long ETA then nothing is due', () {
      expect(due(pos: 3), isFalse);
    });
    test('when 2nd then it is due', () => expect(due(pos: 2), isTrue));
    test('when ETA reaches 10 minutes first then it is due', () {
      expect(due(pos: 4, eta: 600), isTrue);
    });
    test('when already sent this wait then it is not sent again', () {
      expect(due(sent: true, pos: 1, eta: 60), isFalse);
    });
  });
}
