import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

/// Component 1 Cloud check: records when a scheduled call actually fires.
class SmokeFutureCall extends FutureCall {
  Future<void> fire(Session session, UuidValue runId) async {
    final run = await SmokeRun.db.findById(session, runId);
    if (run == null || run.firedAt != null) return;
    await SmokeRun.db.updateRow(
      session,
      run.copyWith(
        firedAt: DateTime.now().toUtc(),
        serverId: session.serverpod.serverId,
      ),
    );
  }
}
