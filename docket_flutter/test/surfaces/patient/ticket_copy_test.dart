import 'package:docket_client/docket_client.dart';
import 'package:docket_flutter/shared/server_clock.dart';
import 'package:docket_flutter/shared/strings/patient.dart';
import 'package:docket_flutter/surfaces/patient/browser/patient_browser.dart';
import 'package:docket_flutter/surfaces/patient/patient_widgets.dart';
import 'package:docket_flutter/surfaces/patient/ticket_copy.dart';
import 'package:flutter_test/flutter_test.dart';

import 'patient_view_fixture.dart';

final _now = DateTime.utc(2026, 10, 14, 9, 42, 3);

TicketCopy _copy(PatientView view) => ticketCopy(view, now: _now);

void main() {
  group('PRD 17.2 state table', () {
    test('waiting says the place, the ETA and the strip', () {
      final copy = _copy(
        patientView(lineMovedAt: _now.subtract(const Duration(seconds: 40))),
      );
      expect(copy.headline, "You're 3rd in line for Consultation.");
      expect(copy.headlinePosition, 3);
      expect(copy.supporting, 'About 14 min.');
      expect(copy.strip, [
        'Line moved 40 s ago',
        'Now serving C-028',
        "You're 2nd when C-029 is called",
      ]);
      expect(copy.actions, {TicketAction.getAlerts, TicketAction.leave});
      expect(copy.countdown, isNull);
    });

    test('waiting with a heads-up sent says start heading back', () {
      final copy = _copy(
        patientView(position: 2, nextAfterLabel: 'C-030', headsUpSent: true),
      );
      expect(phaseOf(patientView(headsUpSent: true)), TicketPhase.headsUp);
      expect(copy.headline, 'Start heading back');
      expect(copy.supporting, "You're next after C-030.");
      expect(copy.strip.last, "You're 2nd in line, about 14 min");
      expect(copy.actions, {TicketAction.getAlerts, TicketAction.leave});
    });

    test('a heads-up at the front says the patient is next', () {
      final copy = _copy(
        patientView(position: 1, nextAfterLabel: null, headsUpSent: true),
      );
      expect(copy.supporting, "You're next.");
    });

    test('a heads-up after a re-slot keeps the miss warning', () {
      final copy = _copy(
        patientView(
          position: 1,
          nextAfterLabel: null,
          headsUpSent: true,
          reslotCount: 1,
        ),
      );
      expect(
        copy.supporting,
        "You're next. One more miss and the ticket expires.",
      );
    });

    test('called says go to the room with a grace countdown', () {
      final ends = _now.add(const Duration(seconds: 161));
      final copy = _copy(
        patientView(
          state: TicketState.called,
          position: null,
          roomName: 'Room 2',
          graceEndsAt: ends,
        ),
      );
      expect(copy.headline, 'Your turn. Go to Room 2.');
      expect(copy.countdown?.kind, CountdownKind.grace);
      expect(copy.countdown?.endsAt, ends);
      expect(copy.countdown?.suffix, ' to confirm');
      expect(copy.actions, {TicketAction.confirm});
      expect(copy.strip, isEmpty);
    });

    test(
      'confirmed says the room is expecting you with an arrival countdown',
      () {
        final copy = _copy(
          patientView(
            state: TicketState.confirmed,
            position: null,
            roomName: 'Room 2',
            arrivalEndsAt: _now.add(const Duration(minutes: 9)),
          ),
        );
        expect(copy.headline, 'Room 2 is expecting you');
        expect(copy.countdown?.kind, CountdownKind.arrival);
        expect(copy.countdown?.suffix, ' to reach the room');
        expect(copy.actions, {TicketAction.leave});
      },
    );

    test('in service names the room and offers nothing to tap', () {
      final copy = _copy(
        patientView(
          state: TicketState.inService,
          position: null,
          roomName: 'Room 2',
        ),
      );
      expect(copy.headline, "You're being seen in Room 2");
      expect(copy.actions, isEmpty);
    });

    test('served thanks the patient', () {
      final copy = _copy(
        patientView(state: TicketState.served, position: null),
      );
      expect(copy.headline, 'Done. Thanks for waiting with Docket.');
      expect(copy.actions, isEmpty);
    });

    test('transferred names the next stop and the new label', () {
      final copy = _copy(
        patientView(
          state: TicketState.transferred,
          position: null,
          transferredToToken: 'next-token',
          transferredToLabel: 'L-007',
          transferredToLineName: 'Lab',
        ),
      );
      expect(copy.headline, 'Next stop: Lab, L-007');
      expect(copy.supporting, 'Opening your new ticket.');
    });

    test('waiting after a re-slot says the call was missed', () {
      final view = patientView(reslotCount: 1, maxReslots: 1);
      final copy = _copy(view);
      expect(phaseOf(view), TicketPhase.reslotted);
      expect(copy.headline, 'You missed your call');
      expect(
        copy.supporting,
        "You're back in line, 3rd from the front. One more miss and the "
        'ticket expires.',
      );
      expect(copy.note, "When you're called, tap I'm coming.");
      expect(copy.actions, {TicketAction.getAlerts, TicketAction.leave});
    });

    test('a clinic allowing more misses counts them', () {
      final copy = _copy(patientView(reslotCount: 1, maxReslots: 2));
      expect(
        copy.supporting,
        endsWith('Two more misses and the ticket expires.'),
      );
    });

    test('expired counts the missed calls', () {
      final copy = _copy(
        patientView(state: TicketState.expired, position: null, reslotCount: 1),
      );
      expect(copy.headline, 'This ticket expired');
      expect(copy.supporting, 'It missed two calls. Please see the desk.');
    });

    test('cancelled, removed and closed state what happened', () {
      expect(
        _copy(
          patientView(state: TicketState.cancelled, position: null),
        ).headline,
        'You left the line',
      );

      final removed = _copy(
        patientView(
          state: TicketState.removed,
          position: null,
          closedReason: 'Left the clinic',
        ),
      );
      expect(removed.headline, 'The desk took this ticket out of the line');
      expect(removed.strip, ["The desk's reason: Left the clinic"]);

      final closed = _copy(
        patientView(state: TicketState.closed, position: null),
      );
      expect(closed.headline, 'Closed for today');
      expect(
        closed.supporting,
        'Grace Clinic has closed for today. Ticket C-031 is closed.',
      );
    });

    test('every state has a headline and only waiting offers alerts', () {
      for (final state in TicketState.values) {
        final copy = _copy(patientView(state: state, roomName: 'Room 2'));
        expect(copy.headline, isNotEmpty, reason: state.name);
        expect(
          copy.actions.contains(TicketAction.getAlerts),
          state == TicketState.waiting,
          reason: state.name,
        );
      }
    });

    test('only waiting, called and confirmed hold a place', () {
      final active = {
        for (final state in TicketState.values)
          state: phaseOf(patientView(state: state)).isActive,
      };
      expect(active, {
        TicketState.waiting: true,
        TicketState.called: true,
        TicketState.confirmed: true,
        TicketState.inService: false,
        TicketState.served: false,
        TicketState.transferred: false,
        TicketState.cancelled: false,
        TicketState.removed: false,
        TicketState.expired: false,
        TicketState.closed: false,
      });
    });
  });

  group('ETA and strip lines', () {
    test('the ETA reads as its own sentence', () {
      expect(PatientStrings.etaSentence('about 14 min'), 'About 14 min.');
      expect(PatientStrings.etaSentence('under 5 min'), 'Under 5 min.');
      expect(PatientStrings.etaSentence('over an hour'), 'Over an hour.');
      expect(
        PatientStrings.etaSentence('about 8 min, early estimate'),
        'About 8 min, early estimate.',
      );
    });

    test('no ETA means no supporting line', () {
      expect(_copy(patientView(etaText: null)).supporting, isNull);
    });

    test('the line moved time steps by five seconds, then minutes', () {
      String moved(int seconds) => lineMovedText(
        _now.subtract(Duration(seconds: seconds)),
        now: _now,
      );
      expect(lineMovedText(null, now: _now), "Line hasn't moved yet");
      expect(moved(3), 'Line moved just now');
      expect(moved(-2), 'Line moved just now');
      expect(moved(12), 'Line moved 10 s ago');
      expect(moved(44), 'Line moved 40 s ago');
      expect(moved(59), 'Line moved 55 s ago');
      expect(moved(60), 'Line moved 1 min ago');
      expect(moved(3599), 'Line moved 59 min ago');
      expect(moved(3600), 'Line moved over an hour ago');
    });

    test('the front of the line is next to be called', () {
      final strip = waitingStrip(
        patientView(position: 1, nextAfterLabel: null),
        now: _now,
      );
      expect(strip.last, "You're next to be called");
    });

    test('the strip leaves out what the view does not know', () {
      final strip = waitingStrip(
        patientView(nowServingLabel: null, nextAfterLabel: null, position: 4),
        now: _now,
      );
      expect(strip, ["Line hasn't moved yet"]);
    });

    test('the strip never says the patient is serving themselves', () {
      final strip = waitingStrip(
        patientView(nowServingLabel: 'C-031'),
        now: _now,
      );
      expect(strip.any((line) => line.startsWith('Now serving')), isFalse);
    });

    test('the strip lines are separate facts, never dot-joined', () {
      final copy = _copy(
        patientView(lineMovedAt: _now.subtract(const Duration(seconds: 40))),
      );
      expect(copy.strip.length, lessThanOrEqualTo(3));
      for (final line in copy.strip) {
        expect(line.contains('·'), isFalse);
      }
    });

    test('ordinals', () {
      expect(
        [1, 2, 3, 4, 11, 12, 13, 21, 22, 23, 101, 111, 112].map(
          PatientStrings.ordinal,
        ),
        [
          '1st',
          '2nd',
          '3rd',
          '4th',
          '11th',
          '12th',
          '13th',
          '21st',
          '22nd',
          '23rd',
          '101st',
          '111th',
          '112th',
        ],
      );
    });
  });

  group('countdowns', () {
    test('mm:ss from server time, never negative', () {
      expect(ServerClock.mmss(161), '2:41');
      expect(ServerClock.mmss(600), '10:00');
      expect(ServerClock.mmss(59), '0:59');
      expect(ServerClock.mmss(0), '0:00');
    });

    test('the digits follow the server clock, not the phone clock', () {
      // The server is an hour ahead of this machine.
      final serverNow = DateTime.now().toUtc().add(const Duration(hours: 1));
      ServerClock.instance.observe(serverNow);
      final grace = TicketCountdown(
        CountdownKind.grace,
        serverNow.add(const Duration(seconds: 161)),
      );
      expect(grace.digits(ServerClock.instance), '2:41');

      final over = TicketCountdown(
        CountdownKind.arrival,
        serverNow.subtract(const Duration(seconds: 5)),
      );
      expect(over.digits(ServerClock.instance), '0:00');
    });

    test('the last update time reads like a clock', () {
      final local = DateTime(2026, 10, 14, 10, 42, 3);
      expect(clockTime(local), '10:42:03');
    });
  });

  group('screen reader', () {
    test('announcements are full sentences with the spoken label', () {
      final copy = _copy(patientView());
      expect(
        copy.announcement(spokenLabel('C-031')),
        "C 31. You're 3rd in line for Consultation. About 14 min.",
      );
      final called = _copy(
        patientView(state: TicketState.called, roomName: 'Room 2'),
      );
      expect(
        called.announcement('C 31', countdownText: '2:41 to confirm'),
        'C 31. Your turn. Go to Room 2. 2:41 to confirm.',
      );
    });

    test('labels are spoken the way the board says them', () {
      expect(spokenLabel('C-031'), 'C 31');
      expect(spokenLabel('L-007'), 'L 7');
      expect(spokenLabel('C-100'), 'C 100');
      expect(spokenLabel('odd'), 'odd');
    });
  });

  group('push keys', () {
    test('base64url without padding round-trips', () {
      final bytes = List<int>.generate(65, (i) => (i * 37) % 256);
      final encoded = encodeBase64UrlNoPad(bytes);
      expect(encoded.contains('='), isFalse);
      expect(encoded.contains('+'), isFalse);
      expect(encoded.contains('/'), isFalse);
      expect(decodeBase64Url(encoded), bytes);
    });

    test('a VAPID key decodes to an uncompressed P-256 point', () {
      final key = decodeBase64Url(
        'BNifDY9IguvqIiaVT_duqI0OMXgN3YCXvtZTQ8THzYXu48TkcI5Ht5PeW9fVvVbYu0nx'
        'Zjek23ZVxKhxFsxHjo4',
      );
      expect(key.length, 65);
      expect(key.first, 0x04);
    });
  });
}
