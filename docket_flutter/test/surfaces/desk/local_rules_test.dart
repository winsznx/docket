import 'package:docket_client/docket_client.dart' hide Notification;
import 'package:docket_flutter/surfaces/desk/offline/local_rules.dart';
import 'package:flutter_test/flutter_test.dart';

final _device = UuidValue.fromString('01900000-0000-7000-8000-000000000001');
final _consultation = UuidValue.fromString(
  '01900000-0000-7000-8000-0000000000c0',
);
final _lab = UuidValue.fromString('01900000-0000-7000-8000-0000000000d0');
final _room1 = UuidValue.fromString('01900000-0000-7000-8000-0000000000a1');
final _bench = UuidValue.fromString('01900000-0000-7000-8000-0000000000a3');
final _now = DateTime.utc(2026, 10, 14, 9, 30);

final _context = LocalContext(
  roomLines: {_room1: _consultation, _bench: _lab},
  lineCodes: {_consultation: 'C', _lab: 'L'},
  now: _now,
);

var _ids = 0;
UuidValue _id() => UuidValue.fromString(
  '01900000-0000-7000-8000-${(++_ids).toString().padLeft(12, '0')}',
);

LocalTicket _ticket(
  String label, {
  UuidValue? line,
  TicketState state = TicketState.waiting,
  int rank = 1,
  double sortKey = 1024,
  int reslots = 0,
  UuidValue? room,
}) => LocalTicket(
  id: _id(),
  lineId: line ?? _consultation,
  label: label,
  displayName: 'Patient $label',
  state: state,
  priorityRank: rank,
  sortKey: sortKey,
  roomId: room,
  reslotCount: reslots,
  isDemo: false,
  updatedAt: _now,
);

int _seq = 0;
({UuidValue actionId, UuidValue deviceId, int seq, DateTime issuedAtLocal})
_stamp() => (
  actionId: _id(),
  deviceId: _device,
  seq: ++_seq,
  issuedAtLocal: _now,
);

void main() {
  group('call next', () {
    test('takes the first eligible ticket: priority first, then sort key', () {
      final normalFirst = _ticket('C-001', sortKey: 1024);
      final normalSecond = _ticket('C-002', sortKey: 2048);
      final priority = _ticket('C-003', rank: 0, sortKey: 4096);
      final otherLine = _ticket('L-001', line: _lab, sortKey: 1);
      final alreadyCalled = _ticket(
        'C-000',
        state: TicketState.called,
        sortKey: 1,
        room: _room1,
      );
      final s = _stamp();

      final changed = LocalRules.apply(
        CallNextAction(
          actionId: s.actionId,
          deviceId: s.deviceId,
          seq: s.seq,
          issuedAtLocal: s.issuedAtLocal,
          roomId: _room1,
        ),
        [normalSecond, otherLine, normalFirst, alreadyCalled, priority],
        _context,
      );

      expect(changed, hasLength(1));
      final called = changed.single;
      expect(called.id, priority.id);
      expect(called.state, TicketState.called);
      expect(called.roomId, _room1);
      expect(called.calledAt, _now);
      expect(called.callVersion, priority.callVersion + 1);
      expect(called.pendingSync, isTrue);
    });

    test('a second call takes the next ticket once the first is applied', () {
      final first = _ticket('C-001', sortKey: 1024);
      final second = _ticket('C-002', sortKey: 2048);
      CallNextAction call() {
        final s = _stamp();
        return CallNextAction(
          actionId: s.actionId,
          deviceId: s.deviceId,
          seq: s.seq,
          issuedAtLocal: s.issuedAtLocal,
          roomId: _room1,
        );
      }

      final one = LocalRules.apply(call(), [first, second], _context).single;
      final two = LocalRules.apply(call(), [one, second], _context).single;

      expect(one.id, first.id);
      expect(two.id, second.id);
    });

    test('changes nothing when no one is waiting in the room\'s line', () {
      final s = _stamp();
      final changed = LocalRules.apply(
        CallNextAction(
          actionId: s.actionId,
          deviceId: s.deviceId,
          seq: s.seq,
          issuedAtLocal: s.issuedAtLocal,
          roomId: _room1,
        ),
        [_ticket('L-001', line: _lab)],
        _context,
      );
      expect(changed, isEmpty);
    });

    test('call this patient takes the named ticket out of order', () {
      final first = _ticket('C-001', sortKey: 1024);
      final third = _ticket('C-003', sortKey: 3072);
      final s = _stamp();
      final changed = LocalRules.apply(
        CallSpecificAction(
          actionId: s.actionId,
          deviceId: s.deviceId,
          seq: s.seq,
          issuedAtLocal: s.issuedAtLocal,
          roomId: _room1,
          ticketId: third.id!,
        ),
        [first, third],
        _context,
      );
      expect(changed.single.id, third.id);
      expect(changed.single.state, TicketState.called);
    });
  });

  group('adds', () {
    test('a walk-in gets the minted id, the "C-?" label and the back of the '
        'line', () {
      final last = _ticket('C-004', sortKey: 4096);
      final priority = _ticket('C-005', rank: 0, sortKey: 9000);
      final s = _stamp();
      final minted = _id();

      final added = LocalRules.apply(
        AddWalkInAction(
          actionId: s.actionId,
          deviceId: s.deviceId,
          seq: s.seq,
          issuedAtLocal: s.issuedAtLocal,
          ticketId: minted,
          lineId: _consultation,
          displayName: '  AB  ',
        ),
        [last, priority],
        _context,
      ).single;

      expect(added.id, minted);
      expect(added.label, 'C-?');
      expect(added.displayName, 'AB');
      expect(added.state, TicketState.waiting);
      expect(added.priorityRank, 1);
      expect(added.sortKey, 4096 + LocalRules.joinGap);
      expect(added.pendingSync, isTrue);
    });

    test('a priority add goes ahead of everyone waiting, with its reason', () {
      final waiting = _ticket('C-001', sortKey: 1024);
      final s = _stamp();
      final added = LocalRules.apply(
        AddPriorityAction(
          actionId: s.actionId,
          deviceId: s.deviceId,
          seq: s.seq,
          issuedAtLocal: s.issuedAtLocal,
          ticketId: _id(),
          lineId: _consultation,
          displayName: 'CD',
          reason: PriorityReason.elderly,
        ),
        [waiting],
        _context,
      ).single;

      expect(added.label, 'C-?');
      expect(added.priorityRank, 0);
      expect(added.priorityReason, PriorityReason.elderly);
      expect(
        LocalRules.eligible([waiting, added], _consultation).first.id,
        added.id,
      );
    });

    test('a lab walk-in uses the lab code', () {
      final s = _stamp();
      final added = LocalRules.apply(
        AddWalkInAction(
          actionId: s.actionId,
          deviceId: s.deviceId,
          seq: s.seq,
          issuedAtLocal: s.issuedAtLocal,
          ticketId: _id(),
          lineId: _lab,
          displayName: 'EF',
        ),
        const [],
        _context,
      ).single;
      expect(added.label, 'L-?');
      expect(added.sortKey, LocalRules.joinGap);
    });
  });

  group('remove', () {
    test('a waiting ticket becomes removed', () {
      final waiting = _ticket('C-001');
      final s = _stamp();
      final removed = LocalRules.apply(
        RemoveAction(
          actionId: s.actionId,
          deviceId: s.deviceId,
          seq: s.seq,
          issuedAtLocal: s.issuedAtLocal,
          ticketId: waiting.id!,
          reason: 'Came by mistake',
        ),
        [waiting],
        _context,
      ).single;
      expect(removed.state, TicketState.removed);
      expect(removed.pendingSync, isTrue);
      expect(LocalRules.eligible([removed], _consultation), isEmpty);
    });

    test('a ticket already in service stays as it is', () {
      final serving = _ticket('C-001', state: TicketState.inService);
      final s = _stamp();
      expect(
        LocalRules.apply(
          RemoveAction(
            actionId: s.actionId,
            deviceId: s.deviceId,
            seq: s.seq,
            issuedAtLocal: s.issuedAtLocal,
            ticketId: serving.id!,
            reason: 'Other',
          ),
          [serving],
          _context,
        ),
        isEmpty,
      );
    });
  });

  group('transfer', () {
    test('finishes the ticket here and opens a pending one at the back of '
        'the target line', () {
      final serving = _ticket(
        'C-001',
        state: TicketState.inService,
        room: _room1,
      );
      final labWaiting = _ticket('L-002', line: _lab, sortKey: 2048);
      final s = _stamp();
      final newId = _id();

      final changed = LocalRules.apply(
        TransferAction(
          actionId: s.actionId,
          deviceId: s.deviceId,
          seq: s.seq,
          issuedAtLocal: s.issuedAtLocal,
          ticketId: serving.id!,
          targetLineId: _lab,
          newTicketId: newId,
        ),
        [serving, labWaiting],
        _context,
      );

      expect(changed, hasLength(2));
      final old = changed.firstWhere((t) => t.id == serving.id);
      final fresh = changed.firstWhere((t) => t.id == newId);
      expect(old.state, TicketState.transferred);
      expect(fresh.lineId, _lab);
      expect(fresh.label, 'L-?');
      expect(fresh.displayName, serving.displayName);
      expect(fresh.state, TicketState.waiting);
      expect(fresh.sortKey, 2048 + LocalRules.joinGap);
      expect(fresh.pendingSync, isTrue);
    });

    test('a ticket that isn\'t in service can\'t be transferred', () {
      final waiting = _ticket('C-001');
      final s = _stamp();
      expect(
        LocalRules.apply(
          TransferAction(
            actionId: s.actionId,
            deviceId: s.deviceId,
            seq: s.seq,
            issuedAtLocal: s.issuedAtLocal,
            ticketId: waiting.id!,
            targetLineId: _lab,
            newTicketId: _id(),
          ),
          [waiting],
          _context,
        ),
        isEmpty,
      );
    });
  });

  group('service and misses', () {
    test('start service, then finish', () {
      final called = _ticket('C-001', state: TicketState.called, room: _room1);
      final s1 = _stamp();
      final started = LocalRules.apply(
        StartServiceAction(
          actionId: s1.actionId,
          deviceId: s1.deviceId,
          seq: s1.seq,
          issuedAtLocal: s1.issuedAtLocal,
          ticketId: called.id!,
          roomId: _room1,
        ),
        [called],
        _context,
      ).single;
      expect(started.state, TicketState.inService);

      final s2 = _stamp();
      final finished = LocalRules.apply(
        FinishAction(
          actionId: s2.actionId,
          deviceId: s2.deviceId,
          seq: s2.seq,
          issuedAtLocal: s2.issuedAtLocal,
          ticketId: started.id!,
        ),
        [started],
        _context,
      ).single;
      expect(finished.state, TicketState.served);
    });

    test('a first no-show goes back three places behind the front', () {
      final called = _ticket('C-001', state: TicketState.called, room: _room1);
      final waiting = [
        for (var i = 1; i <= 4; i++) _ticket('C-00${i + 1}', sortKey: i * 1024),
      ];
      final s = _stamp();
      final missed = LocalRules.apply(
        MarkNoShowAction(
          actionId: s.actionId,
          deviceId: s.deviceId,
          seq: s.seq,
          issuedAtLocal: s.issuedAtLocal,
          ticketId: called.id!,
        ),
        [called, ...waiting],
        _context,
      ).single;

      expect(missed.state, TicketState.waiting);
      expect(missed.reslotCount, 1);
      final order = LocalRules.eligible([...waiting, missed], _consultation);
      expect(order.indexWhere((t) => t.id == missed.id), 2);
    });

    test('a second no-show expires the ticket', () {
      final called = _ticket(
        'C-001',
        state: TicketState.confirmed,
        room: _room1,
        reslots: 1,
      );
      final s = _stamp();
      final missed = LocalRules.apply(
        MarkNoShowAction(
          actionId: s.actionId,
          deviceId: s.deviceId,
          seq: s.seq,
          issuedAtLocal: s.issuedAtLocal,
          ticketId: called.id!,
        ),
        [called],
        _context,
      ).single;
      expect(missed.state, TicketState.expired);
    });

    test('recall and room state change no tickets', () {
      final called = _ticket('C-001', state: TicketState.called, room: _room1);
      final s = _stamp();
      expect(
        LocalRules.apply(
          RecallAction(
            actionId: s.actionId,
            deviceId: s.deviceId,
            seq: s.seq,
            issuedAtLocal: s.issuedAtLocal,
            ticketId: called.id!,
          ),
          [called],
          _context,
        ),
        isEmpty,
      );
    });

    test('close day closes everyone open and marks service as seen', () {
      final waiting = _ticket('C-001');
      final serving = _ticket('C-002', state: TicketState.inService);
      final done = _ticket('C-003', state: TicketState.served);
      final s = _stamp();
      final changed = LocalRules.apply(
        CloseDayAction(
          actionId: s.actionId,
          deviceId: s.deviceId,
          seq: s.seq,
          issuedAtLocal: s.issuedAtLocal,
          clinicId: _id(),
        ),
        [waiting, serving, done],
        _context,
      );
      expect(
        {
          for (final t in changed) t.label: t.state,
        },
        {'C-001': TicketState.closed, 'C-002': TicketState.served},
      );
    });
  });

  test('reslot keys land between neighbours or at the ends', () {
    expect(LocalRules.reslotKey([], 3), LocalRules.joinGap);
    expect(LocalRules.reslotKey([1024, 2048], 3), 2048 + LocalRules.joinGap);
    expect(LocalRules.reslotKey([1024, 2048, 3072], 3), 2560);
    expect(LocalRules.reslotKey([1024, 2048], 1), 0);
  });
}
