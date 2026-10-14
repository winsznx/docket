import 'dart:convert';

import 'package:serverpod/serverpod.dart';

import '../app_config.dart';
import '../domain/eta.dart';
import '../domain/timers.dart';
import '../domain/notification_policy.dart';
import '../domain/views.dart';
import '../generated/future_calls.dart';
import '../generated/protocol.dart';
import '../strings.dart';
import 'twilio_sms.dart';
import 'web_push.dart';

/// Delivers one queued Notification row (PRD 14.2). The row is the source of
/// truth: anything not `queued` is left alone, so a duplicate future call
/// can't send twice.
abstract final class Dispatcher {
  static const retryDelays = [Duration(seconds: 30), Duration(seconds: 120)];

  static Future<void> send(Session session, UuidValue notificationId) async {
    final n = await Notification.db.findById(session, notificationId);
    if (n == null || n.status != DeliveryStatus.queued) return;
    final ticket = await Ticket.db.findById(session, n.ticketId);
    final clinic = await Clinic.db.findById(session, n.clinicId);
    if (ticket == null || clinic == null) {
      await _finish(
        session,
        n,
        DeliveryStatus.skipped,
        error: 'Ticket is gone.',
      );
      return;
    }
    final attempt = n.attempts + 1;
    final row = await Notification.db.updateRow(
      session,
      n.copyWith(attempts: attempt),
    );
    final _Outcome outcome;
    switch (n.channel) {
      case Channel.push:
        outcome = await _push(session, row, ticket, clinic);
      case Channel.sms:
        outcome = await _sms(session, row, ticket, clinic);
    }
    if (outcome.transient && attempt <= retryDelays.length) {
      await Notification.db.updateRow(
        session,
        row.copyWith(error: outcome.error),
      );
      if (!Timers.scheduling(session.serverpod)) return;
      await session.serverpod.futureCalls
          .callWithDelay(
            retryDelays[attempt - 1],
            identifier: 'dispatch:${n.id}:${attempt + 1}',
          )
          .dispatch
          .send(n.id!);
      session.log(
        '[notify] ${n.kind.name} ${n.channel.name} for ${n.ticketLabel} '
        'will retry: ${outcome.error}',
        level: LogLevel.warning,
      );
      return;
    }
    await _finish(
      session,
      row,
      outcome.status,
      providerRef: outcome.providerRef,
      error: outcome.error,
    );
    session.log(
      '[notify] ${n.kind.name} ${n.channel.name} for ${n.ticketLabel}: '
      '${outcome.status.name}${outcome.error == null ? '' : ' ${outcome.error}'}',
    );
  }

  static Future<void> _finish(
    Session session,
    Notification n,
    DeliveryStatus status, {
    String? providerRef,
    String? error,
  }) async {
    await Notification.db.updateRow(
      session,
      n.copyWith(
        status: status,
        providerRef: providerRef,
        error: error,
        sentAt: status == DeliveryStatus.sent ? DateTime.now().toUtc() : null,
      ),
    );
    final ticket = await Ticket.db.findById(session, n.ticketId);
    if (ticket == null) return;
    final line = await Line.db.findById(session, ticket.lineId);
    if (line == null) return;
    await session.messages.postMessage(
      'line.${line.id}',
      LineChanged(lineId: line.id!, version: line.version, reason: 'delivery'),
    );
  }

  static Future<_Outcome> _push(
    Session session,
    Notification n,
    Ticket ticket,
    Clinic clinic,
  ) async {
    final target = await PushTarget.db.findFirstRow(
      session,
      where: (t) => t.ticketId.equals(ticket.id!) & t.active.equals(true),
    );
    if (target == null) {
      return const _Outcome(DeliveryStatus.skipped, error: 'Alerts are off.');
    }
    final public = session.passwords['vapidPublicKey'];
    final private = session.passwords['vapidPrivateKey'];
    final subject = session.passwords['vapidSubject'];
    if (public == null || private == null || subject == null) {
      return const _Outcome(
        DeliveryStatus.skipped,
        error: "Web Push keys aren't set on this server.",
      );
    }
    final link = AppConfig.sealer(session).decrypt(target.linkCipher);
    final body = await _body(session, n, ticket, clinic, link, sms: false);
    final payload = utf8.encode(
      jsonEncode({
        'title': Copy.pushTitle(n.kind, ticket.label),
        'body': body,
        'url': link,
        'tag': 'docket-${ticket.id}',
        'kind': n.kind.name,
      }),
    );
    final isCall = n.kind == NotificationKind.called;
    final ttl = isCall ? _graceLeft(ticket, clinic) : 3600;
    final PushResult result;
    WebPushSender? sender;
    try {
      sender = WebPushSender(
        vapidPublicKey: public,
        vapidPrivateKey: private,
        vapidSubject: subject,
      );
      result = await sender.send(
        endpoint: target.endpoint,
        p256dh: target.p256dh,
        auth: target.authSecret,
        payload: payload,
        ttlSeconds: ttl,
        urgency: isCall || n.kind == NotificationKind.graceReminder
            ? 'high'
            : 'normal',
        topic: '${n.kind.name}${ticket.id.toString().replaceAll('-', '')}',
      );
    } on ArgumentError catch (e) {
      return _Outcome(DeliveryStatus.failed, error: '${e.message}');
    } finally {
      sender?.close();
    }
    if (result.ok) {
      return _Outcome(DeliveryStatus.sent, providerRef: '${result.statusCode}');
    }
    if (result.gone) {
      await PushTarget.db.updateRow(session, target.copyWith(active: false));
      await _smsFallback(session, n, ticket, clinic);
      return _Outcome(
        DeliveryStatus.failed,
        error: 'The browser subscription is gone (${result.statusCode}).',
      );
    }
    return _Outcome(
      DeliveryStatus.failed,
      transient: result.transient,
      error: 'Push service answered ${result.statusCode}.',
    );
  }

  /// A dead push endpoint falls back to SMS where the policy allows it.
  static Future<void> _smsFallback(
    Session session,
    Notification n,
    Ticket ticket,
    Clinic clinic,
  ) async {
    final sms = await SmsTarget.db.findFirstRow(
      session,
      where: (t) => t.ticketId.equals(ticket.id!) & t.active.equals(true),
    );
    final allowed = NotificationPolicy.channels(
      kind: n.kind,
      pushActive: false,
      smsActive: sms != null && clinic.smsEnabled && !clinic.isSandbox,
    ).contains(Channel.sms);
    if (!allowed) return;
    final rows = await Notification.db.insert(
      session,
      [
        Notification(
          ticketId: ticket.id!,
          clinicId: clinic.id!,
          ticketLabel: ticket.label,
          kind: n.kind,
          channel: Channel.sms,
          status: DeliveryStatus.queued,
          callVersion: n.callVersion,
          dedupeKey: NotificationPolicy.dedupeKey(
            ticketId: ticket.id!,
            kind: n.kind,
            channel: Channel.sms,
            callVersion: n.callVersion,
            reslotCount: ticket.reslotCount,
            suffix: 'fallback-${n.id}',
          ),
        ),
      ],
      ignoreConflicts: true,
    );
    if (!Timers.scheduling(session.serverpod)) return;
    for (final row in rows) {
      await session.serverpod.futureCalls
          .callWithDelay(Duration.zero, identifier: 'dispatch:${row.id}:1')
          .dispatch
          .send(row.id!);
    }
  }

  static Future<_Outcome> _sms(
    Session session,
    Notification n,
    Ticket ticket,
    Clinic clinic,
  ) async {
    final target = await SmsTarget.db.findFirstRow(
      session,
      where: (t) => t.ticketId.equals(ticket.id!) & t.active.equals(true),
    );
    if (target == null) {
      return const _Outcome(DeliveryStatus.skipped, error: 'Texts are off.');
    }
    if (!clinic.smsEnabled || clinic.isSandbox) {
      return const _Outcome(
        DeliveryStatus.skipped,
        error: "This clinic doesn't send texts.",
      );
    }
    if (!AppConfig.twilioConfigured(session)) {
      return const _Outcome(
        DeliveryStatus.skipped,
        error: "SMS isn't configured on this server.",
      );
    }
    final sealer = AppConfig.sealer(session);
    final phone = sealer.decrypt(target.phoneCipher);
    final link = sealer.decrypt(target.linkCipher);
    final body = await _body(session, n, ticket, clinic, link, sms: true);
    final SmsResult result;
    TwilioSmsSender? sender;
    try {
      sender = TwilioSmsSender(
        accountSid: session.passwords['twilioAccountSid']!,
        authToken: session.passwords['twilioAuthToken']!,
        from: session.passwords['twilioFrom']!,
      );
      result = await sender.send(
        to: phone,
        body: body,
        statusCallback:
            '${AppConfig.publicBaseUrl(session.serverpod)}/api/twilio/status',
      );
    } on ArgumentError catch (e) {
      return _Outcome(DeliveryStatus.failed, error: '${e.message}');
    } finally {
      sender?.close();
    }
    if (result.ok) {
      return _Outcome(DeliveryStatus.sent, providerRef: result.sid);
    }
    return _Outcome(
      DeliveryStatus.failed,
      transient: result.transient,
      error: result.error ?? 'Twilio refused the message.',
    );
  }

  static int _graceLeft(Ticket ticket, Clinic clinic) {
    final calledAt = ticket.calledAt;
    if (calledAt == null) return clinic.graceSeconds;
    final end = calledAt.add(Duration(seconds: clinic.graceSeconds));
    final left = end.difference(DateTime.now().toUtc()).inSeconds;
    return left < 30 ? 30 : left;
  }

  static Future<String> _body(
    Session session,
    Notification n,
    Ticket ticket,
    Clinic clinic,
    String link, {
    required bool sms,
  }) async {
    final room = ticket.roomId == null
        ? null
        : await Room.db.findById(session, ticket.roomId!);
    final roomName = room?.name ?? 'the room';
    switch (n.kind) {
      case NotificationKind.joined:
        return Copy.smsJoined(ticket.label, clinic.name, link);
      case NotificationKind.headsUp:
      case NotificationKind.reslotted:
        final line = (await Line.db.findById(session, ticket.lineId))!;
        final snap = await Views.lineSnapshot(session, line);
        final index = snap.waiting.indexWhere((t) => t.id == ticket.id);
        final position = index < 0 ? 1 : index + 1;
        if (n.kind == NotificationKind.reslotted) {
          return Copy.reslotted(ticket.label, position);
        }
        final presence = await Views.presence(session, line);
        final eta = Eta.seconds(
          position: position,
          activeRooms: presence.activeRooms,
          medianServiceSeconds: snap.view.medianServiceSeconds,
        );
        return Copy.headsUp(
          ticket.label,
          position,
          Eta.text(eta, early: false),
        );
      case NotificationKind.called:
        return sms
            ? Copy.calledSms(ticket.label, roomName, clinic.graceSeconds, link)
            : Copy.called(ticket.label, roomName, clinic.graceSeconds);
      case NotificationKind.graceReminder:
        return Copy.graceReminder(
          ticket.label,
          roomName,
          clinic.graceReminderSeconds,
        );
      case NotificationKind.expired:
        return Copy.expired(ticket.label, ticket.reslotCount + 1);
      case NotificationKind.dayClosed:
        return Copy.dayClosed(clinic.name, ticket.label);
      case NotificationKind.transferred:
        final line = await Line.db.findById(session, ticket.lineId);
        return Copy.transferred(line?.name ?? '', ticket.label, link);
    }
  }

  /// Applies a Twilio delivery report to the row it belongs to (BUILD A5).
  static Future<void> applyTwilioStatus(
    Session session,
    String messageSid,
    String messageStatus,
    String? errorCode,
  ) async {
    final n = await Notification.db.findFirstRow(
      session,
      where: (t) =>
          t.providerRef.equals(messageSid) & t.channel.equals(Channel.sms),
    );
    if (n == null) return;
    final DeliveryStatus? status = switch (messageStatus) {
      'delivered' => DeliveryStatus.delivered,
      'undelivered' => DeliveryStatus.undelivered,
      'failed' => DeliveryStatus.failed,
      _ => null,
    };
    if (status == null) return;
    await _finish(
      session,
      n,
      status,
      providerRef: n.providerRef,
      error: errorCode == null ? null : 'Twilio error $errorCode',
    );
  }
}

class _Outcome {
  const _Outcome(
    this.status, {
    this.providerRef,
    this.error,
    this.transient = false,
  });

  final DeliveryStatus status;
  final String? providerRef;
  final String? error;
  final bool transient;
}
