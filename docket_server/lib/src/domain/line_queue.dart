import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import 'clinic_time.dart';
import 'ordering.dart';

/// Queries over one line's queue, always inside the caller's transaction.
abstract final class LineQueue {
  static String serviceDateNow(Clinic clinic) =>
      ClinicTime.serviceDate(clinic.timezone, DateTime.now().toUtc());

  /// Waiting tickets in call order: priority first, then sort key.
  static Future<List<Ticket>> waiting(
    Session session,
    Transaction t,
    UuidValue lineId,
    String serviceDate,
  ) => Ticket.db.find(
    session,
    where: (x) =>
        x.lineId.equals(lineId) &
        x.serviceDate.equals(serviceDate) &
        x.state.equals(TicketState.waiting),
    orderByList: (x) => [x.priorityRank.asc(), x.sortKey.asc()],
    transaction: t,
  );

  static Future<int> nextNumber(
    Session session,
    Transaction t,
    UuidValue lineId,
    String serviceDate,
  ) async {
    final last = await Ticket.db.findFirstRow(
      session,
      where: (x) => x.lineId.equals(lineId) & x.serviceDate.equals(serviceDate),
      orderBy: (x) => x.number.desc(),
      transaction: t,
    );
    return (last?.number ?? 0) + 1;
  }

  static String label(String code, int number) =>
      '$code-${number.toString().padLeft(3, '0')}';

  /// The append key for a new ticket of [rank].
  static Future<double> appendKey(
    Session session,
    Transaction t,
    UuidValue lineId,
    String serviceDate,
    int rank,
  ) async {
    final last = await Ticket.db.findFirstRow(
      session,
      where: (x) =>
          x.lineId.equals(lineId) &
          x.serviceDate.equals(serviceDate) &
          x.state.equals(TicketState.waiting) &
          x.priorityRank.equals(rank),
      orderBy: (x) => x.sortKey.desc(),
      transaction: t,
    );
    return Ordering.appendKey(last?.sortKey);
  }

  /// Rewrites every waiting key in the line to evenly spaced values in the
  /// current order, PRD 4.3. Returns the refreshed waiting list.
  static Future<List<Ticket>> renumber(
    Session session,
    Transaction t,
    UuidValue lineId,
    String serviceDate,
  ) async {
    final current = await waiting(session, t, lineId, serviceDate);
    final keys = Ordering.renumbered(current.length);
    final updated = [
      for (var i = 0; i < current.length; i++)
        current[i].copyWith(sortKey: keys[i]),
    ];
    if (updated.isNotEmpty) {
      await Ticket.db.update(session, updated, transaction: t);
    }
    return updated;
  }
}
