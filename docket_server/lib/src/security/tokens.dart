import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:pointycastle/digests/sha256.dart';

/// Capability tokens: 32 random bytes in base64url, stored only as a
/// SHA-256 hash (PRD 9.2 and 18).
abstract final class Tokens {
  static final Random _random = Random.secure();

  static String mint({int bytes = 32}) {
    final data = Uint8List(bytes);
    for (var i = 0; i < bytes; i++) {
      data[i] = _random.nextInt(256);
    }
    return base64Url.encode(data).replaceAll('=', '');
  }

  static String hash(String token) {
    final digest = SHA256Digest().process(utf8.encode(token));
    return digest.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }

  static bool looksValid(String token) =>
      token.length >= 32 &&
      token.length <= 64 &&
      RegExp(r'^[A-Za-z0-9_-]+$').hasMatch(token);

  /// Six-word-free short codes for staff invites, still 128 bits.
  static String inviteCode() => mint(bytes: 16);
}
