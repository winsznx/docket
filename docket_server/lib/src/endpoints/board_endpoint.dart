import 'package:async/async.dart';
import 'package:serverpod/serverpod.dart';

import '../domain/views.dart';
import '../generated/protocol.dart';
import '../security/tokens.dart';
import '../util/coalesce.dart';

/// The waiting-room screen, read-only by board token (PRD 9.4).
class BoardEndpoint extends Endpoint {
  Future<BoardView> get(Session session, String boardToken) async =>
      Views.board(session, await _clinic(session, boardToken));

  Stream<BoardView> watch(Session session, String boardToken) async* {
    final clinic = await _clinic(session, boardToken);
    yield await Views.board(session, clinic);
    final lines = await Line.db.find(
      session,
      where: (t) => t.clinicId.equals(clinic.id!),
    );
    final events = StreamGroup.merge<Object?>([
      session.messages.createStream<ClinicChanged>('clinic.${clinic.id}'),
      for (final line in lines)
        session.messages.createStream<LineChanged>('line.${line.id}'),
      Stream<Object?>.periodic(const Duration(seconds: 20)),
    ]);
    await for (final _ in events.transform(
      const Coalesce<Object?>(Duration(milliseconds: 100)),
    )) {
      final fresh = await Clinic.db.findById(session, clinic.id!);
      if (fresh == null || fresh.boardTokenHash != clinic.boardTokenHash) {
        throw _invalid();
      }
      yield await Views.board(session, fresh);
    }
  }

  static Future<Clinic> _clinic(Session session, String token) async {
    if (!Tokens.looksValid(token)) throw _invalid();
    final clinic = await Clinic.db.findFirstRow(
      session,
      where: (t) => t.boardTokenHash.equals(Tokens.hash(token)),
    );
    if (clinic == null) throw _invalid();
    return clinic;
  }

  static DocketException _invalid() => DocketException(
    code: DocketErrorCode.clinicNotFound,
    message:
        "This board link doesn't work any more. Get the new one from the owner page.",
  );
}
