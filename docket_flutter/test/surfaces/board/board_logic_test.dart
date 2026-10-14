import 'package:docket_client/docket_client.dart';
import 'package:docket_flutter/surfaces/board/board_logic.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';

final _t0 = DateTime.utc(2026, 10, 14, 9);

BoardCall _call(
  String label,
  String room, {
  int version = 1,
  Duration after = Duration.zero,
}) => BoardCall(
  label: label,
  roomName: room,
  calledAt: _t0.add(after),
  callVersion: version,
);

void main() {
  group('speech', () {
    test('reads the code letter, then the number without leading zeros', () {
      expect(spokenLabel('C-031'), 'C 31');
      expect(spokenLabel('L-007'), 'L 7');
      expect(spokenLabel('P-100'), 'P 100');
      expect(spokenLabel('C-001'), 'C 1');
    });

    test('says where to go', () {
      expect(
        speechFor(_call('C-031', 'Room 2')),
        'C 31, please go to Room 2',
      );
      expect(
        speechFor(_call('L-007', 'Lab Bench')),
        'L 7, please go to Lab Bench',
      );
    });

    test('stays quiet for a label the server has not numbered yet', () {
      expect(spokenLabel('C-?'), isNull);
      expect(speechFor(_call('C-?', 'Room 2')), isNull);
    });
  });

  group('CallTracker', () {
    test('the first view is history and is not announced', () {
      final tracker = CallTracker();
      final calls = [_call('C-002', 'Room 1'), _call('C-001', 'Room 2')];
      expect(
        tracker.observe(calls, local: false, now: _t0, deviceNow: _t0),
        isEmpty,
      );
    });

    test('a new call in a later view is announced once', () {
      final tracker = CallTracker()
        ..observe(
          [_call('C-001', 'Room 1')],
          local: false,
          now: _t0,
          deviceNow: _t0,
        );
      final next = [
        _call('C-002', 'Room 2', after: const Duration(seconds: 5)),
        _call('C-001', 'Room 1'),
      ];
      final now = _t0.add(const Duration(seconds: 6));
      final fresh = tracker.observe(
        next,
        local: false,
        now: now,
        deviceNow: now,
      );
      expect(fresh.map((c) => c.label), ['C-002']);
      expect(
        tracker.observe(next, local: false, now: now, deviceNow: now),
        isEmpty,
      );
    });

    test('several new calls come out oldest first', () {
      final tracker = CallTracker()
        ..observe(const [], local: false, now: _t0, deviceNow: _t0);
      final now = _t0.add(const Duration(seconds: 10));
      final fresh = tracker.observe(
        [
          _call('C-003', 'Room 1', after: const Duration(seconds: 8)),
          _call('L-001', 'Lab Bench', after: const Duration(seconds: 4)),
        ],
        local: false,
        now: now,
        deviceNow: now,
      );
      expect(fresh.map((c) => c.label), ['L-001', 'C-003']);
    });

    test('a new call version of the same ticket is a new call', () {
      final tracker = CallTracker()
        ..observe(
          [_call('C-004', 'Room 1')],
          local: false,
          now: _t0,
          deviceNow: _t0,
        );
      final now = _t0.add(const Duration(minutes: 1));
      final fresh = tracker.observe(
        [
          _call(
            'C-004',
            'Room 2',
            version: 2,
            after: const Duration(minutes: 1),
          ),
        ],
        local: false,
        now: now,
        deviceNow: now,
      );
      expect(fresh.single.roomName, 'Room 2');
    });

    test('a call older than two minutes is shown but not announced', () {
      final tracker = CallTracker()
        ..observe(const [], local: false, now: _t0, deviceNow: _t0);
      final now = _t0.add(const Duration(minutes: 5));
      expect(
        tracker.observe(
          [_call('C-005', 'Room 1')],
          local: false,
          now: now,
          deviceNow: now,
        ),
        isEmpty,
      );
    });

    test('a call announced in local mode is not repeated by the server', () {
      final tracker = CallTracker()
        ..observe(const [], local: false, now: _t0, deviceNow: _t0);
      final localNow = _t0.add(const Duration(seconds: 20));
      final fromDesk = tracker.observe(
        [_call('C-006', 'Room 1', after: const Duration(seconds: 15))],
        local: true,
        now: localNow,
        deviceNow: localNow,
      );
      expect(fromDesk.map((c) => c.label), ['C-006']);

      final serverNow = _t0.add(const Duration(seconds: 50));
      final synced = tracker.observe(
        [
          _call('C-007', 'Room 2', after: const Duration(seconds: 48)),
          _call(
            'C-006',
            'Room 1',
            version: 1,
            after: const Duration(seconds: 45),
          ),
        ],
        local: false,
        now: serverNow,
        deviceNow: serverNow,
      );
      expect(synced.map((c) => c.label), ['C-007']);
    });
  });

  group('localBoardView', () {
    final consultation = UuidValue.fromString(
      '01a13b8b-3f35-70ab-ba56-a52b0a1b48c4',
    );
    final lab = UuidValue.fromString('01a13b8b-3f3b-7046-8ff4-dd2e514ef136');
    final room1 = UuidValue.fromString('01a13b8b-3f42-7d87-80de-f1ca69a422e8');
    final room2 = UuidValue.fromString('01a13b8b-3f42-750e-ac12-14fcf7c22472');

    DeskView desk() => DeskView(
      reslotOffset: 3,
      maxReslots: 1,
      clinicId: UuidValue.fromString('01a13b8b-3f32-7204-91d2-48817ddf85f3'),
      clinicName: 'Ikeja Family Clinic',
      clinicSlug: 'ikeja-family',
      isSandbox: false,
      lines: [
        LineView(
          id: consultation,
          name: 'Consultation',
          code: 'C',
          version: 4,
          acceptingJoins: true,
          tickets: const [],
          medianServiceSeconds: 480,
          sampleCount: 0,
          servedToday: 0,
        ),
        LineView(
          id: lab,
          name: 'Lab',
          code: 'L',
          version: 1,
          acceptingJoins: true,
          tickets: const [],
          medianServiceSeconds: 480,
          sampleCount: 0,
          servedToday: 0,
        ),
      ],
      rooms: [
        RoomView(
          id: room1,
          name: 'Room 1',
          lineId: consultation,
          state: RoomState.open,
          deskOnline: true,
        ),
        RoomView(
          id: room2,
          name: 'Room 2',
          lineId: consultation,
          state: RoomState.paused,
          deskOnline: true,
        ),
      ],
      joinUrl: 'https://docket.example/j/ikeja-family',
      serverTime: _t0,
    );

    LocalTicket ticket(
      String label,
      TicketState state, {
      UuidValue? room,
      Duration? calledAfter,
      UuidValue? line,
    }) => LocalTicket(
      lineId: line ?? consultation,
      label: label,
      displayName: 'A',
      state: state,
      priorityRank: 1,
      sortKey: 1024,
      roomId: room,
      calledAt: calledAfter == null ? null : _t0.add(calledAfter),
      isDemo: false,
      updatedAt: _t0,
    );

    test('shows the desk calls, rooms and waiting counts', () {
      final view = localBoardView(
        desk: desk(),
        now: _t0,
        tickets: [
          ticket(
            'C-001',
            TicketState.served,
            room: room1,
            calledAfter: Duration.zero,
          ),
          ticket(
            'C-002',
            TicketState.called,
            room: room1,
            calledAfter: const Duration(minutes: 3),
          ),
          ticket('C-003', TicketState.waiting),
          ticket('C-004', TicketState.waiting),
          ticket('L-001', TicketState.waiting, line: lab),
        ],
      );

      expect(view.clinicName, 'Ikeja Family Clinic');
      expect(view.rooms.map((r) => r.nowServingLabel), ['C-002', null]);
      expect(view.rooms.last.state, RoomState.paused);
      expect(view.recentCalls.map((c) => c.label), ['C-002', 'C-001']);
      expect(view.recentCalls.first.roomName, 'Room 1');
      expect(view.waitingByLine, {'Consultation': 2, 'Lab': 1});
      expect(slugOfJoinUrl(view.joinUrl), 'ikeja-family');
    });
  });

  group('BoardMetrics', () {
    double width(double size) => size * 2.8;

    test('three rooms on a 1080p board sit in one row, label 18 to 20%', () {
      final m = BoardMetrics.of(const Size(1920, 1080), 3, width);
      expect(m.frame, const Size(1920, 1080));
      expect(m.roomsPerRow, 3);
      expect(m.rows, 1);
      expect(m.labelSize, inInclusiveRange(1080 * 0.18, 1080 * 0.2));
    });

    test('one room never grows past 20% of the height', () {
      final m = BoardMetrics.of(const Size(1920, 1080), 1, width);
      expect(m.labelSize, 216);
    });

    test('a wide window letterboxes to 16:9 from the height', () {
      final m = BoardMetrics.of(const Size(2400, 720), 2, width);
      expect(m.frame, const Size(1280, 720));
    });

    test('many rooms wrap but never go under 18% of the height', () {
      final m = BoardMetrics.of(const Size(1280, 720), 6, width);
      expect(m.labelSize, greaterThanOrEqualTo(720 * 0.18));
      expect(m.rows, greaterThan(1));
    });
  });
}
