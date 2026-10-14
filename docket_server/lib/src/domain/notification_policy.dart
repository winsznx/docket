import 'package:serverpod/serverpod.dart';

import 'package:docket_server/src/generated/protocol.dart';

/// PRD 14.1: which channels each kind goes out on.
abstract final class NotificationPolicy {
  static List<Channel> channels({
    required NotificationKind kind,
    required bool pushActive,
    required bool smsActive,
  }) {
    final push = pushActive && kind != NotificationKind.joined;
    final bool sms;
    switch (kind) {
      case NotificationKind.joined:
        sms = smsActive && !pushActive;
      case NotificationKind.called:
        sms = smsActive;
      case NotificationKind.graceReminder:
        sms = false;
      case NotificationKind.headsUp:
      case NotificationKind.reslotted:
      case NotificationKind.expired:
      case NotificationKind.dayClosed:
      case NotificationKind.transferred:
        sms = smsActive && !pushActive;
    }
    return [if (push) Channel.push, if (sms) Channel.sms];
  }

  static String dedupeKey({
    required UuidValue ticketId,
    required NotificationKind kind,
    required Channel channel,
    required int callVersion,
    required int reslotCount,
    String? suffix,
  }) {
    final base = '$ticketId:${kind.name}:${channel.name}:$callVersion:$reslotCount';
    return suffix == null ? base : '$base:$suffix';
  }
}
