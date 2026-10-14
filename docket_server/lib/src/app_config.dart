import 'dart:io';

import 'package:serverpod/serverpod.dart';

import 'security/phone.dart';

/// Deployment-specific values. `PUBLIC_BASE_URL` is set on Cloud with
/// `serverpod cloud variable set`, locally it falls back to the web server.
abstract final class AppConfig {
  static String publicBaseUrl(Serverpod pod) {
    final env = Platform.environment['PUBLIC_BASE_URL'];
    if (env != null && env.isNotEmpty) {
      return env.endsWith('/') ? env.substring(0, env.length - 1) : env;
    }
    final web = pod.config.webServer;
    if (web == null) return 'http://localhost:8082';
    final defaultPort =
        (web.publicScheme == 'https' && web.publicPort == 443) ||
        (web.publicScheme == 'http' && web.publicPort == 80);
    final port = defaultPort ? '' : ':${web.publicPort}';
    return '${web.publicScheme}://${web.publicHost}$port';
  }

  static String ticketUrl(Serverpod pod, String token) =>
      '${publicBaseUrl(pod)}/t/$token';

  static String joinUrl(Serverpod pod, String slug) =>
      '${publicBaseUrl(pod)}/j/$slug';

  static String boardUrl(Serverpod pod, String token) =>
      '${publicBaseUrl(pod)}/b/$token';

  static String inviteUrl(Serverpod pod, String code) =>
      '${publicBaseUrl(pod)}/invite/$code';

  /// Seals contact data and capability links at rest with the
  /// `phoneEncryptionKey` password (PRD 14.4).
  static PhoneCipher sealer(Session session) {
    final key = session.passwords['phoneEncryptionKey'];
    if (key == null || key.isEmpty) {
      throw StateError('The phoneEncryptionKey password is missing.');
    }
    return PhoneCipher(key);
  }

  static String? vapidPublicKey(Session session) =>
      session.passwords['vapidPublicKey'];

  static bool twilioConfigured(Session session) =>
      (session.passwords['twilioAccountSid'] ?? '').isNotEmpty &&
      (session.passwords['twilioAuthToken'] ?? '').isNotEmpty &&
      (session.passwords['twilioFrom'] ?? '').isNotEmpty;
}
