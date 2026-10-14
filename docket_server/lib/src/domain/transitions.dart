import 'package:docket_server/src/generated/protocol.dart';

/// Every ticket command in the PRD 5.1 state machine.
enum TicketCommand {
  callNext,
  callSpecific,
  leave,
  remove,
  recall,
  confirm,
  startService,
  graceExpiry,
  markNoShow,
  arrivalExpiry,
  finish,
  transfer,
  closeDay,
}

/// The PRD 5.1 table as data. A missing entry is a refused transition.
///
/// Miss transitions list `waiting` because the miss rule decides between
/// `waiting` and `expired` after the guard passes.
abstract final class Transitions {
  static const Map<TicketCommand, Map<TicketState, TicketState>> table = {
    TicketCommand.callNext: {TicketState.waiting: TicketState.called},
    TicketCommand.callSpecific: {TicketState.waiting: TicketState.called},
    TicketCommand.leave: {
      TicketState.waiting: TicketState.cancelled,
      TicketState.called: TicketState.cancelled,
      TicketState.confirmed: TicketState.cancelled,
    },
    TicketCommand.remove: {
      TicketState.waiting: TicketState.removed,
      TicketState.called: TicketState.removed,
      TicketState.confirmed: TicketState.removed,
    },
    TicketCommand.recall: {TicketState.called: TicketState.called},
    TicketCommand.confirm: {TicketState.called: TicketState.confirmed},
    TicketCommand.startService: {
      TicketState.called: TicketState.inService,
      TicketState.confirmed: TicketState.inService,
    },
    TicketCommand.graceExpiry: {TicketState.called: TicketState.waiting},
    TicketCommand.markNoShow: {
      TicketState.called: TicketState.waiting,
      TicketState.confirmed: TicketState.waiting,
    },
    TicketCommand.arrivalExpiry: {TicketState.confirmed: TicketState.waiting},
    TicketCommand.finish: {TicketState.inService: TicketState.served},
    TicketCommand.transfer: {TicketState.inService: TicketState.transferred},
    TicketCommand.closeDay: {
      TicketState.waiting: TicketState.closed,
      TicketState.called: TicketState.closed,
      TicketState.confirmed: TicketState.closed,
      TicketState.inService: TicketState.served,
    },
  };

  static const Set<TicketState> terminal = {
    TicketState.served,
    TicketState.transferred,
    TicketState.cancelled,
    TicketState.removed,
    TicketState.expired,
    TicketState.closed,
  };

  static TicketState? target(TicketCommand command, TicketState from) =>
      table[command]?[from];

  static bool allowed(TicketCommand command, TicketState from) =>
      target(command, from) != null;
}
