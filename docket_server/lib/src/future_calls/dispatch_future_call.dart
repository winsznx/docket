import 'package:serverpod/serverpod.dart';

import '../notify/dispatcher.dart';

/// Delivers one queued notification, PRD 14.2.
class DispatchFutureCall extends FutureCall {
  Future<void> send(Session session, UuidValue notificationId) =>
      Dispatcher.send(session, notificationId);
}
