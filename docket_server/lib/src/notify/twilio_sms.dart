import 'dart:async';
import 'dart:convert';
import 'dart:io' show IOException;
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:pointycastle/api.dart';
import 'package:pointycastle/digests/sha1.dart';
import 'package:pointycastle/macs/hmac.dart';

const _requestTimeout = Duration(seconds: 15);

final _accountSidPattern = RegExp(r'^AC[0-9a-fA-F]{32}$');

class SmsResult {
  const SmsResult({
    required this.ok,
    this.sid,
    this.status,
    this.error,
    this.transient = false,
  });

  final bool ok;

  /// Twilio message SID, set when the message was accepted.
  final String? sid;

  /// Twilio message status at creation, usually queued or accepted.
  final String? status;
  final String? error;

  /// Worth retrying later with backoff.
  final bool transient;

  @override
  String toString() => ok
      ? 'SmsResult(ok, $sid, $status)'
      : 'SmsResult(failed, transient: $transient, $error)';
}

class TwilioSmsSender {
  TwilioSmsSender({
    required String accountSid,
    required String authToken,
    required this._from,
    http.Client? client,
  }) : _messagesUri = _messagesUriFor(accountSid),
       _authorization = _basicAuth(accountSid, authToken),
       _client = client ?? http.Client(),
       _ownsClient = client == null;

  final Uri _messagesUri;
  final String _authorization;
  final String _from;
  final http.Client _client;
  final bool _ownsClient;

  Future<SmsResult> send({
    required String to,
    required String body,
    String? statusCallback,
  }) async {
    final http.Response response;
    try {
      response = await _client
          .post(
            _messagesUri,
            headers: {
              'Authorization': _authorization,
              'Accept': 'application/json',
            },
            body: {
              'To': to,
              'From': _from,
              'Body': body,
              'StatusCallback': ?statusCallback,
            },
          )
          .timeout(_requestTimeout);
    } on TimeoutException {
      return const SmsResult(
        ok: false,
        error: 'Twilio request timed out.',
        transient: true,
      );
    } on http.ClientException catch (error) {
      return SmsResult(
        ok: false,
        error: 'Twilio request failed: ${error.message}',
        transient: true,
      );
    } on IOException catch (error) {
      return SmsResult(
        ok: false,
        error: 'Twilio request failed: $error',
        transient: true,
      );
    }

    final statusCode = response.statusCode;
    final json = _decodeJsonObject(response.bodyBytes);
    if (statusCode >= 200 && statusCode < 300) {
      return SmsResult(
        ok: true,
        sid: _stringField(json, 'sid'),
        status: _stringField(json, 'status'),
      );
    }

    final message =
        _stringField(json, 'message') ?? 'Twilio answered $statusCode.';
    final code = json?['code'];
    final error = code is int ? '$message (Twilio code $code)' : message;
    return SmsResult(
      ok: false,
      // Twilio echoes the recipient in some errors. Keep it out of logs, since
      // phones are encrypted at rest for a reason.
      error: to.isEmpty ? error : error.replaceAll(to, '[recipient]'),
      transient: statusCode == 429 || (statusCode >= 500 && statusCode < 600),
    );
  }

  /// Closes the HTTP client if this sender created it.
  void close() {
    if (_ownsClient) _client.close();
  }

  static Uri _messagesUriFor(String accountSid) {
    if (!_accountSidPattern.hasMatch(accountSid)) {
      throw ArgumentError(
        'The Twilio account SID must be AC followed by 32 hex digits.',
        'accountSid',
      );
    }
    return Uri.https(
      'api.twilio.com',
      '/2010-04-01/Accounts/$accountSid/Messages.json',
    );
  }

  static String _basicAuth(String accountSid, String authToken) {
    if (authToken.isEmpty) {
      throw ArgumentError('The Twilio auth token is empty.', 'authToken');
    }
    return 'Basic ${base64.encode(utf8.encode('$accountSid:$authToken'))}';
  }
}

/// Checks the `X-Twilio-Signature` header of a form encoded webhook.
///
/// [url] must be the exact public URL Twilio called, query string included.
/// Behind a proxy that means the configured webhook URL, not the one the
/// server sees.
bool verifyTwilioSignature({
  required String authToken,
  required String url,
  required Map<String, String> params,
  required String signature,
}) {
  if (authToken.isEmpty) {
    throw ArgumentError('The Twilio auth token is empty.', 'authToken');
  }
  final data = StringBuffer(url);
  for (final key in params.keys.toList()..sort()) {
    data
      ..write(key)
      ..write(params[key]);
  }
  final mac = HMac(SHA1Digest(), 64)
    ..init(KeyParameter(utf8.encode(authToken)));
  final expected = base64.encode(mac.process(utf8.encode(data.toString())));
  return _constantTimeEquals(expected, signature);
}

bool _constantTimeEquals(String a, String b) {
  if (a.length != b.length) return false;
  var difference = 0;
  for (var i = 0; i < a.length; i++) {
    difference |= a.codeUnitAt(i) ^ b.codeUnitAt(i);
  }
  return difference == 0;
}

Map<String, Object?>? _decodeJsonObject(Uint8List bytes) {
  try {
    final decoded = jsonDecode(utf8.decode(bytes, allowMalformed: true));
    return decoded is Map<String, Object?> ? decoded : null;
  } on FormatException {
    return null;
  }
}

String? _stringField(Map<String, Object?>? json, String key) =>
    switch (json?[key]) {
      final String value => value,
      _ => null,
    };
