/// PRD 4.5: a miss re-slots while `reslotCount < maxReslots`, then expires.
enum MissOutcome { reslot, expire }

abstract final class MissRule {
  static MissOutcome decide({required int reslotCount, required int maxReslots}) =>
      reslotCount < maxReslots ? MissOutcome.reslot : MissOutcome.expire;
}
