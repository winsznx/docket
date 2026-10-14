import 'package:serverpod/serverpod.dart';

import 'package:docket_server/src/generated/protocol.dart';

/// Who caused a state change, written onto every TicketEvent.
class Actor {
  const Actor(this.type, {this.ref, this.deviceId, this.actionId});

  static const system = Actor(ActorType.system);
  static const patient = Actor(ActorType.patient);

  final ActorType type;
  final String? ref;
  final UuidValue? deviceId;
  final UuidValue? actionId;

  Actor forAction(DeskAction action) => Actor(
    type,
    ref: ref,
    deviceId: action.deviceId,
    actionId: action.actionId,
  );
}
