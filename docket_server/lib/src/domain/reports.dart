import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import 'clinic_time.dart';

/// End-of-day numbers per line (PRD 17.5). Live for today, stored by the
/// nightly job for closed days.
abstract final class Reports {
  static Future<DayReportData> build(
    Session session,
    Clinic clinic,
    String serviceDate,
  ) async {
    final lines = await Line.db.find(
      session,
      where: (t) => t.clinicId.equals(clinic.id!),
      orderByList: (t) => [t.sortOrder.asc(), t.code.asc()],
    );
    final tickets = await Ticket.db.find(
      session,
      where: (t) =>
          t.clinicId.equals(clinic.id!) & t.serviceDate.equals(serviceDate),
    );
    final ticketIds = tickets.map((t) => t.id!).toSet();
    final reslotEvents = ticketIds.isEmpty
        ? <TicketEvent>[]
        : await TicketEvent.db.find(
            session,
            where: (t) =>
                t.clinicId.equals(clinic.id!) &
                t.ticketId.inSet(ticketIds) &
                t.reason.equals('reslotted'),
          );
    final reports = <LineReport>[];
    for (final line in lines) {
      final mine = tickets.where((t) => t.lineId == line.id).toList();
      int count(TicketState s) => mine.where((t) => t.state == s).length;
      final waits = [
        for (final t in mine)
          if (t.calledAt != null) t.calledAt!.difference(t.joinedAt).inSeconds,
      ];
      final services = [
        for (final t in mine)
          if (t.serviceStartedAt != null && t.finishedAt != null)
            t.finishedAt!.difference(t.serviceStartedAt!).inSeconds,
      ];
      final arrivals = List<int>.filled(24, 0);
      for (final t in mine) {
        arrivals[ClinicTime.local(clinic.timezone, t.joinedAt).hour]++;
      }
      final mineIds = mine.map((t) => t.id).toSet();
      reports.add(
        LineReport(
          lineName: line.name,
          joined: mine.length,
          served: count(TicketState.served),
          cancelled: count(TicketState.cancelled),
          removed: count(TicketState.removed),
          expired: count(TicketState.expired),
          reslotted: reslotEvents
              .where((e) => mineIds.contains(e.ticketId))
              .length,
          waitingNow: count(TicketState.waiting),
          medianWaitSeconds: percentile(waits, 50),
          p90WaitSeconds: percentile(waits, 90),
          medianServiceSeconds: percentile(services, 50),
          p90ServiceSeconds: percentile(services, 90),
          arrivalsByHour: arrivals,
        ),
      );
    }
    return DayReportData(serviceDate: serviceDate, lines: reports);
  }

  /// Nearest-rank percentile, null for no data.
  static int? percentile(List<int> values, int p) {
    if (values.isEmpty) return null;
    final sorted = [...values]..sort();
    final rank = ((p / 100) * sorted.length).ceil().clamp(1, sorted.length);
    return sorted[rank - 1];
  }

  static String csv(
    Clinic clinic,
    Map<UuidValue, String> lineNames,
    List<Ticket> tickets,
  ) {
    String time(DateTime? utc) => utc == null
        ? ''
        : ClinicTime.local(clinic.timezone, utc).toIso8601String();
    String seconds(DateTime? from, DateTime? to) =>
        from == null || to == null ? '' : '${to.difference(from).inSeconds}';
    final rows = <List<String>>[
      [
        'label',
        'line',
        'state',
        'priority',
        'reslots',
        'demo',
        'joined_at',
        'called_at',
        'service_started_at',
        'finished_at',
        'wait_seconds',
        'service_seconds',
      ],
      for (final t in tickets)
        [
          t.label,
          lineNames[t.lineId] ?? '',
          t.state.name,
          t.priorityReason?.name ?? '',
          '${t.reslotCount}',
          t.isDemo ? 'yes' : 'no',
          time(t.joinedAt),
          time(t.calledAt),
          time(t.serviceStartedAt),
          time(t.finishedAt),
          seconds(t.joinedAt, t.calledAt),
          seconds(t.serviceStartedAt, t.finishedAt),
        ],
    ];
    return rows.map((r) => r.map(_escape).join(',')).join('\n');
  }

  static String _escape(String v) {
    final needsQuotes = v.contains(',') || v.contains('"') || v.contains('\n');
    final safe = v.startsWith(RegExp(r'[=+\-@]')) ? "'$v" : v;
    return needsQuotes ? '"${safe.replaceAll('"', '""')}"' : safe;
  }
}
