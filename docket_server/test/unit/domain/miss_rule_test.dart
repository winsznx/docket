import 'package:docket_server/src/domain/miss_rule.dart';
import 'package:test/test.dart';

void main() {
  group('Given the miss rule', () {
    for (final (count, max, outcome) in [
      (0, 1, MissOutcome.reslot),
      (1, 1, MissOutcome.expire),
      (0, 0, MissOutcome.expire),
      (2, 3, MissOutcome.reslot),
      (3, 3, MissOutcome.expire),
    ]) {
      test(
        'when reslotCount $count and maxReslots $max then ${outcome.name}',
        () {
          expect(MissRule.decide(reslotCount: count, maxReslots: max), outcome);
        },
      );
    }
  });
}
