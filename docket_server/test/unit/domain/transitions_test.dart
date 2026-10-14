import 'package:docket_server/src/domain/transitions.dart';
import 'package:docket_server/src/generated/protocol.dart';
import 'package:test/test.dart';

/// Every row of PRD 5.1, and every refused pair, table-driven.
void main() {
  const allowed = <(TicketCommand, TicketState, TicketState)>[
    (TicketCommand.callNext, TicketState.waiting, TicketState.called),
    (TicketCommand.callSpecific, TicketState.waiting, TicketState.called),
    (TicketCommand.leave, TicketState.waiting, TicketState.cancelled),
    (TicketCommand.remove, TicketState.waiting, TicketState.removed),
    (TicketCommand.recall, TicketState.called, TicketState.called),
    (TicketCommand.confirm, TicketState.called, TicketState.confirmed),
    (TicketCommand.startService, TicketState.called, TicketState.inService),
    (TicketCommand.graceExpiry, TicketState.called, TicketState.waiting),
    (TicketCommand.markNoShow, TicketState.called, TicketState.waiting),
    (TicketCommand.startService, TicketState.confirmed, TicketState.inService),
    (TicketCommand.arrivalExpiry, TicketState.confirmed, TicketState.waiting),
    (TicketCommand.markNoShow, TicketState.confirmed, TicketState.waiting),
    (TicketCommand.leave, TicketState.called, TicketState.cancelled),
    (TicketCommand.leave, TicketState.confirmed, TicketState.cancelled),
    (TicketCommand.remove, TicketState.called, TicketState.removed),
    (TicketCommand.remove, TicketState.confirmed, TicketState.removed),
    (TicketCommand.finish, TicketState.inService, TicketState.served),
    (TicketCommand.transfer, TicketState.inService, TicketState.transferred),
    (TicketCommand.closeDay, TicketState.waiting, TicketState.closed),
    (TicketCommand.closeDay, TicketState.called, TicketState.closed),
    (TicketCommand.closeDay, TicketState.confirmed, TicketState.closed),
    (TicketCommand.closeDay, TicketState.inService, TicketState.served),
  ];

  group('Given the PRD 5.1 ticket table', () {
    for (final (command, from, to) in allowed) {
      test('when ${command.name} from ${from.name} then ${to.name}', () {
        expect(Transitions.target(command, from), to);
      });
    }

    final allowedPairs = {for (final (c, f, _) in allowed) (c, f)};
    for (final command in TicketCommand.values) {
      for (final from in TicketState.values) {
        if (allowedPairs.contains((command, from))) continue;
        test('when ${command.name} from ${from.name} then it is refused', () {
          expect(Transitions.allowed(command, from), isFalse);
        });
      }
    }

    test('when a state is terminal then no command leaves it', () {
      for (final from in Transitions.terminal) {
        for (final command in TicketCommand.values) {
          expect(
            Transitions.allowed(command, from),
            isFalse,
            reason: '$command $from',
          );
        }
      }
    });
  });
}
