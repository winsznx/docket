import 'package:serverpod/serverpod.dart';

import '../app_config.dart';
import '../domain/clinic_time.dart';
import '../domain/eta.dart';
import '../domain/line_queue.dart';
import '../domain/queue_service.dart';
import '../domain/views.dart';
import '../generated/protocol.dart';
import '../strings.dart';

/// Joining a line, no sign-in (PRD 9.1).
class PublicClinicEndpoint extends Endpoint {
  Future<ClinicPublicInfo> getClinic(Session session, String slug) async {
    final clinic = await _clinic(session, slug);
    final lines = await Line.db.find(
      session,
      where: (t) => t.clinicId.equals(clinic.id!),
      orderByList: (t) => [t.sortOrder.asc(), t.code.asc()],
    );
    final infos = <LinePublicInfo>[];
    for (final line in lines) {
      final snap = await Views.lineSnapshot(session, line);
      final presence = await Views.presence(session, line);
      final position = snap.waiting.length + 1;
      final eta = Eta.seconds(
        position: position,
        activeRooms: presence.activeRooms,
        medianServiceSeconds: snap.view.medianServiceSeconds,
      );
      infos.add(
        LinePublicInfo(
          id: line.id!,
          name: line.name,
          code: line.code,
          waitingCount: snap.waiting.length,
          etaMinutesForNewJoin: Eta.minutes(eta),
          etaText: Eta.text(
            eta,
            early: snap.view.sampleCount < Eta.samplesForConfidence,
          ),
          acceptingJoins: line.acceptingJoins,
        ),
      );
    }
    final reason = await _closedReason(session, clinic);
    return ClinicPublicInfo(
      name: clinic.name,
      slug: clinic.slug,
      lines: infos,
      acceptingJoins: reason == null && infos.any((l) => l.acceptingJoins),
      reasonClosed: reason,
      smsEnabled: clinic.smsEnabled && !clinic.isSandbox,
      vapidPublicKey: AppConfig.vapidPublicKey(session) ?? '',
      isSandbox: clinic.isSandbox,
    );
  }

  Future<JoinResult> join(Session session, JoinRequest request) async {
    final clinic = await _clinic(session, request.clinicSlug);
    final line = await Line.db.findById(session, request.lineId);
    if (line == null || line.clinicId != clinic.id) {
      throw DocketException(
        code: DocketErrorCode.validation,
        message: 'Pick a line to join.',
      );
    }
    final joined = await QueueService.join(
      session,
      clinic: clinic,
      line: line,
      displayName: request.displayName ?? '',
      phoneE164: request.phoneE164,
      smsConsent: request.smsConsent,
    );
    return JoinResult(
      ticketToken: joined.token,
      view: await Views.patient(session, joined.ticket.id!),
    );
  }

  Future<String> vapidPublicKey(Session session) async =>
      AppConfig.vapidPublicKey(session) ?? '';

  static Future<Clinic> _clinic(Session session, String slug) async {
    final clinic = await Clinic.db.findFirstRow(
      session,
      where: (t) => t.slug.equals(slug.trim().toLowerCase()),
    );
    if (clinic == null) {
      throw DocketException(
        code: DocketErrorCode.clinicNotFound,
        message: Copy.clinicNotFound,
      );
    }
    if (clinic.isSandbox &&
        clinic.sandboxExpiresAt != null &&
        DateTime.now().toUtc().isAfter(clinic.sandboxExpiresAt!)) {
      throw DocketException(
        code: DocketErrorCode.sandboxExpired,
        message: Copy.sandboxExpired,
      );
    }
    return clinic;
  }

  static Future<String?> _closedReason(Session session, Clinic clinic) async {
    final now = DateTime.now().toUtc();
    final date = LineQueue.serviceDateNow(clinic);
    final day = await ServiceDay.db.findFirstRow(
      session,
      where: (t) => t.clinicId.equals(clinic.id!) & t.serviceDate.equals(date),
    );
    if (day?.state == DayState.closed) return Copy.dayClosedJoin(clinic.name);
    final minutes = ClinicTime.localMinutes(clinic.timezone, now);
    if (day == null && minutes < ClinicTime.minutesOf(clinic.openTime)) {
      return Copy.notOpenYet(clinic.name, clinic.openTime);
    }
    if (minutes >= ClinicTime.minutesOf(clinic.joinCutoffTime)) {
      return Copy.cutoffPassed(clinic.name, clinic.joinCutoffTime);
    }
    return null;
  }
}
