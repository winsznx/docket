import 'package:async/async.dart';
import 'package:serverpod/serverpod.dart';

import '../app_config.dart';
import '../domain/queue_service.dart';
import '../domain/views.dart';
import '../generated/protocol.dart';
import '../notify/web_push.dart';
import '../security/phone.dart';
import '../security/tokens.dart';
import '../strings.dart';
import '../util/coalesce.dart';

/// The patient's ticket. The token in the URL is the capability, no sign-in
/// (PRD 9.2).
class TicketEndpoint extends Endpoint {
  static const heartbeat = Duration(seconds: 20);

  Future<PatientView> get(Session session, String token) async {
    final ticket = await resolve(session, token);
    return Views.patient(session, ticket.id!);
  }

  Stream<PatientView> watch(Session session, String token) async* {
    final ticket = await resolve(session, token);
    yield await Views.patient(session, ticket.id!);
    final events = StreamGroup.merge<Object?>([
      session.messages.createStream<LineChanged>('line.${ticket.lineId}'),
      session.messages.createStream<TicketChanged>('ticket.${ticket.id}'),
      Stream<Object?>.periodic(heartbeat),
    ]);
    await for (final _ in events.transform(
      const Coalesce<Object?>(Duration(milliseconds: 100)),
    )) {
      yield await Views.patient(session, ticket.id!);
    }
  }

  Future<PatientView> confirmComing(Session session, String token) async {
    final ticket = await resolve(session, token);
    await QueueService.confirm(session, ticket);
    return Views.patient(session, ticket.id!);
  }

  Future<PatientView> leave(Session session, String token) async {
    final ticket = await resolve(session, token);
    await QueueService.leave(session, ticket);
    return Views.patient(session, ticket.id!);
  }

  Future<PatientView> registerPush(
    Session session,
    String token,
    PushSubscriptionInput subscription,
  ) async {
    final ticket = await resolve(session, token);
    if (!isAllowedPushEndpoint(subscription.endpoint) ||
        subscription.p256dh.length > 200 ||
        subscription.auth.length > 64) {
      throw DocketException(
        code: DocketErrorCode.pushInvalid,
        message: Copy.pushInvalid,
      );
    }
    final link = AppConfig.sealer(
      session,
    ).encrypt(AppConfig.ticketUrl(session.serverpod, token));
    await session.db.transaction((t) async {
      await PushTarget.db.updateWhere(
        session,
        where: (x) => x.ticketId.equals(ticket.id!),
        columnValues: (x) => [x.active(false)],
        transaction: t,
      );
      await PushTarget.db.insertRow(
        session,
        PushTarget(
          ticketId: ticket.id!,
          endpoint: subscription.endpoint,
          p256dh: subscription.p256dh,
          authSecret: subscription.auth,
          linkCipher: link,
        ),
        transaction: t,
      );
    });
    await QueueService.alertsChanged(session, ticket);
    return Views.patient(session, ticket.id!);
  }

  Future<PatientView> setPhone(
    Session session,
    String token,
    String phoneE164,
    bool smsConsent,
  ) async {
    final ticket = await resolve(session, token);
    final clinic = (await Clinic.db.findById(session, ticket.clinicId))!;
    if (!clinic.smsEnabled || clinic.isSandbox) {
      throw DocketException(
        code: DocketErrorCode.smsDisabled,
        message: Copy.smsDisabled,
      );
    }
    if (!smsConsent) {
      throw DocketException(
        code: DocketErrorCode.validation,
        message: Copy.consentNeeded,
      );
    }
    final phone = normalizePhoneE164(phoneE164);
    if (phone == null) {
      throw DocketException(
        code: DocketErrorCode.validation,
        message: Copy.phoneInvalid,
      );
    }
    final sealer = AppConfig.sealer(session);
    final target = SmsTarget(
      ticketId: ticket.id!,
      phoneCipher: sealer.encrypt(phone),
      phoneLast4: phone.substring(phone.length - 4),
      consentAt: DateTime.now().toUtc(),
      linkCipher: sealer.encrypt(AppConfig.ticketUrl(session.serverpod, token)),
    );
    final existing = await SmsTarget.db.findFirstRow(
      session,
      where: (t) => t.ticketId.equals(ticket.id!),
    );
    if (existing == null) {
      await SmsTarget.db.insertRow(session, target);
    } else {
      await SmsTarget.db.updateRow(
        session,
        target.copyWith(id: existing.id, active: true),
      );
    }
    await QueueService.alertsChanged(session, ticket);
    return Views.patient(session, ticket.id!);
  }

  Future<PatientView> disableAlerts(Session session, String token) async {
    final ticket = await resolve(session, token);
    await PushTarget.db.updateWhere(
      session,
      where: (t) => t.ticketId.equals(ticket.id!),
      columnValues: (t) => [t.active(false)],
    );
    await SmsTarget.db.updateWhere(
      session,
      where: (t) => t.ticketId.equals(ticket.id!),
      columnValues: (t) => [t.active(false)],
    );
    await QueueService.alertsChanged(session, ticket);
    return Views.patient(session, ticket.id!);
  }

  static Future<Ticket> resolve(Session session, String token) async {
    if (!Tokens.looksValid(token)) {
      throw DocketException(
        code: DocketErrorCode.ticketNotFound,
        message: Copy.ticketNotFound,
      );
    }
    final ticket = await Ticket.db.findFirstRow(
      session,
      where: (t) => t.tokenHash.equals(Tokens.hash(token)),
    );
    if (ticket == null) {
      throw DocketException(
        code: DocketErrorCode.ticketNotFound,
        message: Copy.ticketNotFound,
      );
    }
    return ticket;
  }
}
