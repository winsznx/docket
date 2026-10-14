import 'dart:convert';

import 'package:docket_client/docket_client.dart';
import 'package:web/web.dart' as web;

/// The visitor's sandbox, remembered in this browser so a reload keeps the
/// desk open. The token only works on its own sandbox clinic.
class SandboxStore {
  static const _key = 'docket.sandbox';

  static SandboxStart? read() {
    final raw = web.window.localStorage.getItem(_key);
    if (raw == null) return null;
    try {
      final start = SandboxStart.fromJson(
        jsonDecode(raw) as Map<String, dynamic>,
      );
      if (start.expiresAt.isBefore(DateTime.now().toUtc())) {
        clear();
        return null;
      }
      return start;
    } on FormatException {
      clear();
      return null;
    }
  }

  static void save(SandboxStart start) =>
      web.window.localStorage.setItem(_key, jsonEncode(start.toJson()));

  static void clear() => web.window.localStorage.removeItem(_key);
}
