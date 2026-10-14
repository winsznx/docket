import 'package:docket_server/src/domain/notification_policy.dart';
import 'package:docket_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

/// PRD 14.1 for every kind with and without push and SMS.
void main() {
  const expected = <NotificationKind, Map<(bool, bool), List<Channel>>>{
    NotificationKind.joined: {
      (true, true): [],
      (true, false): [],
      (false, true): [Channel.sms],
      (false, false): [],
    },
    NotificationKind.headsUp: {
      (true, true): [Channel.push],
      (true, false): [Channel.push],
      (false, true): [Channel.sms],
      (false, false): [],
    },
    NotificationKind.called: {
      (true, true): [Channel.push, Channel.sms],
      (true, false): [Channel.push],
      (false, true): [Channel.sms],
      (false, false): [],
    },
    NotificationKind.graceReminder: {
      (true, true): [Channel.push],
      (true, false): [Channel.push],
      (false, true): [],
      (false, false): [],
    },
  };
  const pushElseSms = [
    NotificationKind.reslotted,
    NotificationKind.expired,
    NotificationKind.dayClosed,
    NotificationKind.transferred,
  ];

  group('Given the notification policy', () {
    for (final kind in NotificationKind.values) {
      for (final push in [true, false]) {
        for (final sms in [true, false]) {
          final want = pushElseSms.contains(kind)
              ? (push ? [Channel.push] : (sms ? [Channel.sms] : <Channel>[]))
              : expected[kind]![(push, sms)]!;
          test('when ${kind.name} with push $push and sms $sms then $want', () {
            expect(
              NotificationPolicy.channels(
                kind: kind,
                pushActive: push,
                smsActive: sms,
              ),
              want,
            );
          });
        }
      }
    }

    test('when keys are built then retries share one dedupe key', () {
      final id = UuidValue.fromString('01928a6e-0000-7000-8000-000000000001');
      final a = NotificationPolicy.dedupeKey(
        ticketId: id,
        kind: NotificationKind.called,
        channel: Channel.push,
        callVersion: 2,
        reslotCount: 1,
      );
      expect(a, '$id:called:push:2:1');
    });
  });
}
