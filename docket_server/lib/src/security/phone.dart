import 'dart:convert';
import 'dart:math' show Random;
import 'dart:typed_data';

import 'package:pointycastle/api.dart';
import 'package:pointycastle/block/aes.dart';
import 'package:pointycastle/block/modes/gcm.dart';

final _separators = RegExp(r'[\s\-.()]');

// Nigerian mobile numbers are a 10 digit national number starting 7, 8 or 9.
final _nigerianLocal = RegExp(r'^0?([789]\d{9})$');

// The optional 0 after 234 repairs '+234 (0) 803 ...', a common way of
// writing the number that would otherwise pass as a 14 digit E.164 number.
final _nigerianInternational = RegExp(r'^\+?2340?([789]\d{9})$');

final _e164 = RegExp(r'^\+[1-9]\d{7,14}$');

/// Normalizes a phone number to E.164, reading bare local numbers as
/// Nigerian mobiles. Returns null when the input is not a usable number.
String? normalizePhoneE164(String input) {
  final compact = input.replaceAll(_separators, '');
  final nigerian =
      _nigerianLocal.firstMatch(compact) ??
      _nigerianInternational.firstMatch(compact);
  if (nigerian != null) return '+234${nigerian.group(1)}';
  return _e164.hasMatch(compact) ? compact : null;
}

/// AES-256-GCM for phone numbers at rest. Output is
/// base64(nonce || ciphertext || tag) with a fresh 12 byte nonce per call.
class PhoneCipher {
  PhoneCipher(String base64Key) : _key = _decodeKey(base64Key);

  static const _keyLength = 32;
  static const _nonceLength = 12;
  static const _tagLength = 16;
  static final Random _random = Random.secure();

  final Uint8List _key;

  static String generateKeyBase64() => base64.encode(_randomBytes(_keyLength));

  String encrypt(String phone) {
    final nonce = _randomBytes(_nonceLength);
    final sealed = _cipher(
      forEncryption: true,
      nonce: nonce,
    ).process(utf8.encode(phone));
    return base64.encode([...nonce, ...sealed]);
  }

  /// Throws [FormatException] when [cipherText] is malformed, was encrypted
  /// under another key, or was altered.
  String decrypt(String cipherText) {
    final Uint8List bytes;
    try {
      bytes = base64.decode(cipherText);
    } on FormatException {
      throw const FormatException('The phone cipher text is not valid base64.');
    }
    if (bytes.length < _nonceLength + _tagLength) {
      throw const FormatException('The phone cipher text is too short.');
    }
    final cipher = _cipher(
      forEncryption: false,
      nonce: bytes.sublist(0, _nonceLength),
    );
    try {
      return utf8.decode(cipher.process(bytes.sublist(_nonceLength)));
    } on InvalidCipherTextException {
      throw const FormatException(
        'Could not decrypt the phone number. The key is wrong or the data '
        'was changed.',
      );
    }
  }

  GCMBlockCipher _cipher({
    required bool forEncryption,
    required Uint8List nonce,
  }) => GCMBlockCipher(AESEngine())
    ..init(
      forEncryption,
      AEADParameters(KeyParameter(_key), _tagLength * 8, nonce, Uint8List(0)),
    );

  static Uint8List _decodeKey(String base64Key) {
    final Uint8List key;
    try {
      key = base64.decode(base64.normalize(base64Key.trim()));
    } on FormatException {
      throw ArgumentError(
        'The phone encryption key must be base64.',
        'base64Key',
      );
    }
    if (key.length != _keyLength) {
      throw ArgumentError(
        'The phone encryption key must decode to $_keyLength bytes.',
        'base64Key',
      );
    }
    return key;
  }

  static Uint8List _randomBytes(int length) {
    final bytes = Uint8List(length);
    for (var i = 0; i < length; i++) {
      bytes[i] = _random.nextInt(256);
    }
    return bytes;
  }
}
