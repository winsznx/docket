import 'package:serverpod_database/serverpod_database.dart';

import '../client.dart';

/// The desk's SQLite database on this device (PRD 8.4 and 15). On the web it
/// runs in `db_worker.js`, so the desk and a board tab in the same browser
/// profile share it safely.
abstract final class LocalDb {
  static Future<ClientDatabaseSession>? _session;

  static Future<ClientDatabaseSession> open() =>
      _session ??= client.createSession('docket_desk.db');
}
