import 'dart:convert';

import 'package:docket_client/docket_client.dart';
import 'package:flutter/foundation.dart';

import '../../shared/local_db.dart';
import 'board_logic.dart';

/// Where the board reads calls from when its own stream is down.
abstract class LocalBoardSource {
  /// The board built from this browser's desk database, or null when this
  /// browser has no desk for the clinic with the slug [clinicSlug]. A null
  /// slug accepts any desk, for a board that has never reached the server.
  Future<BoardView?> read({String? clinicSlug});
}

/// Reads the desk's SQLite database in this browser profile through the
/// shared `db_worker.js`, so a board tab next to the desk keeps calling
/// through an outage (PRD 15.5).
class DeskDatabaseBoardSource implements LocalBoardSource {
  /// Why the last read found nothing, for the debug console.
  String? lastMiss;

  @override
  Future<BoardView?> read({String? clinicSlug}) async {
    try {
      final session = await LocalDb.open();
      final meta = await DeskMeta.db.findFirstRow(session);
      final json = meta?.lastViewJson;
      if (json == null) return _miss('The desk has not stored a view yet.');
      final desk = DeskView.fromJson(jsonDecode(json) as Map<String, dynamic>);
      if (clinicSlug != null && desk.clinicSlug != clinicSlug) {
        return _miss('The desk in this browser is for another clinic.');
      }
      final tickets = await LocalTicket.db.find(session);
      if (tickets.isEmpty) return _miss('The desk has no tickets stored.');
      return localBoardView(
        desk: desk,
        tickets: tickets,
        now: DateTime.now().toUtc(),
      );
    } on Object catch (error) {
      return _miss('The desk database is not available here: $error');
    }
  }

  BoardView? _miss(String reason) {
    if (reason != lastMiss) debugPrint('Board local mode: $reason');
    lastMiss = reason;
    return null;
  }
}
