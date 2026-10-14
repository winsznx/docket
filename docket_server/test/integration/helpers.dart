import 'package:docket_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';

import 'test_tools/serverpod_test_tools.dart';

/// A sandbox clinic made through the real endpoint, with its lines and rooms.
class Fixture {
  Fixture(this.start, this.consultation, this.lab, this.rooms);

  final SandboxStart start;
  final Line consultation;
  final Line lab;
  final List<Room> rooms;

  UuidValue get clinicId => start.clinicId;
  String get token => start.sandboxToken;
  Room get room1 => rooms.firstWhere((r) => r.name == 'Room 1');
  Room get room2 => rooms.firstWhere((r) => r.name == 'Room 2');
  Room get labBench => rooms.firstWhere((r) => r.name == 'Lab Bench');

  static Future<Fixture> create(
    TestSessionBuilder builder,
    TestEndpoints endpoints,
  ) async {
    final start = await endpoints.sandbox.start(builder);
    final session = builder.build();
    final lines = await Line.db.find(
      session,
      where: (t) => t.clinicId.equals(start.clinicId),
    );
    final rooms = await Room.db.find(
      session,
      where: (t) => t.clinicId.equals(start.clinicId),
    );
    return Fixture(
      start,
      lines.firstWhere((l) => l.code == 'C'),
      lines.firstWhere((l) => l.code == 'L'),
      rooms,
    );
  }

  Future<JoinResult> join(
    TestSessionBuilder builder,
    TestEndpoints endpoints, {
    Line? line,
    String name = 'Ada',
  }) => endpoints.publicClinic.join(
    builder,
    JoinRequest(
      clinicSlug: start.clinicSlug,
      lineId: (line ?? consultation).id!,
      displayName: name,
      smsConsent: false,
    ),
  );
}

/// Mints desk actions the way a device does, with UUID v7 ids and an
/// increasing `seq`.
class Desk {
  Desk() : deviceId = UuidValue.fromString(const Uuid().v7());

  final UuidValue deviceId;
  int _seq = 1;

  UuidValue get _id => UuidValue.fromString(const Uuid().v7());

  int get _next => _seq++;

  CallNextAction callNext(UuidValue roomId) => CallNextAction(
    actionId: _id,
    deviceId: deviceId,
    seq: _next,
    issuedAtLocal: DateTime.now().toUtc(),
    roomId: roomId,
  );

  StartServiceAction start(UuidValue ticketId, UuidValue roomId) =>
      StartServiceAction(
        actionId: _id,
        deviceId: deviceId,
        seq: _next,
        issuedAtLocal: DateTime.now().toUtc(),
        ticketId: ticketId,
        roomId: roomId,
      );

  FinishAction finish(UuidValue ticketId) => FinishAction(
    actionId: _id,
    deviceId: deviceId,
    seq: _next,
    issuedAtLocal: DateTime.now().toUtc(),
    ticketId: ticketId,
  );

  MarkNoShowAction noShow(UuidValue ticketId) => MarkNoShowAction(
    actionId: _id,
    deviceId: deviceId,
    seq: _next,
    issuedAtLocal: DateTime.now().toUtc(),
    ticketId: ticketId,
  );

  TransferAction transfer(UuidValue ticketId, UuidValue lineId) =>
      TransferAction(
        actionId: _id,
        deviceId: deviceId,
        seq: _next,
        issuedAtLocal: DateTime.now().toUtc(),
        ticketId: ticketId,
        targetLineId: lineId,
        newTicketId: _id,
      );

  CloseDayAction closeDay(UuidValue clinicId) => CloseDayAction(
    actionId: _id,
    deviceId: deviceId,
    seq: _next,
    issuedAtLocal: DateTime.now().toUtc(),
    clinicId: clinicId,
  );

  AddWalkInAction walkIn(UuidValue lineId, String name) => AddWalkInAction(
    actionId: _id,
    deviceId: deviceId,
    seq: _next,
    issuedAtLocal: DateTime.now().toUtc(),
    ticketId: _id,
    lineId: lineId,
    displayName: name,
  );
}
