import 'dart:async';
import 'dart:convert';
import 'dart:io' show IOException;
import 'dart:math' show Random;
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:pointycastle/api.dart';
import 'package:pointycastle/block/aes.dart';
import 'package:pointycastle/block/modes/gcm.dart';
import 'package:pointycastle/digests/sha256.dart';
import 'package:pointycastle/ecc/api.dart';
import 'package:pointycastle/ecc/curves/secp256r1.dart';
import 'package:pointycastle/key_derivators/api.dart';
import 'package:pointycastle/key_derivators/hkdf.dart';
import 'package:pointycastle/macs/hmac.dart';
import 'package:pointycastle/signers/ecdsa_signer.dart';

final ECDomainParameters _p256 = ECCurve_secp256r1();
final Random _random = Random.secure();
final BigInt _byteMask = BigInt.from(0xff);

const _recordSize = 4096;
const _authSecretLength = 16;
const _saltLength = 16;
const _gcmTagLength = 16;

// RFC 8188 section 2: 0x02 marks the last record, which is the only record
// in a push message.
const _lastRecordDelimiter = 0x02;

// RFC 8291 section 4: push services only promise 4096 bytes of body, which
// leaves 3993 bytes of plaintext after the 86 byte header, delimiter and tag.
const _maxPayloadLength = 3993;

// RFC 8292 section 2 caps exp at 24 hours. Twelve hours with a margin keeps
// us clear of that even when our clock runs ahead of the push service.
const _vapidTokenLifetime = Duration(hours: 11, minutes: 55);

const _requestTimeout = Duration(seconds: 15);

const _pushHosts = {
  'fcm.googleapis.com',
  'updates.push.services.mozilla.com',
  'web.push.apple.com',
};

const _urgencies = {'very-low', 'low', 'normal', 'high'};

final _topicPattern = RegExp(r'^[A-Za-z0-9_-]{1,32}$');

/// A VAPID application server key pair, both halves base64url without
/// padding. The public key is what browsers pass to
/// `pushManager.subscribe` as `applicationServerKey`.
class VapidKeys {
  const VapidKeys({
    required this.publicKeyB64Url,
    required this.privateKeyB64Url,
  });

  /// Uncompressed P-256 point, 65 bytes.
  final String publicKeyB64Url;

  /// P-256 private scalar, 32 bytes.
  final String privateKeyB64Url;

  static VapidKeys generate() {
    final keyPair = _generateP256KeyPair();
    return VapidKeys(
      publicKeyB64Url: _b64UrlEncode(keyPair.publicKey),
      privateKeyB64Url: _b64UrlEncode(keyPair.privateKey),
    );
  }
}

class PushResult {
  const PushResult({required this.statusCode, this.body});

  /// HTTP status from the push service, or 0 when no response arrived.
  final int statusCode;
  final String? body;

  bool get ok => statusCode >= 200 && statusCode < 300;

  /// The subscription no longer exists and should be deleted.
  bool get gone => statusCode == 404 || statusCode == 410;

  /// Worth retrying later with backoff.
  bool get transient =>
      statusCode == 0 ||
      statusCode == 429 ||
      (statusCode >= 500 && statusCode < 600);

  @override
  String toString() => 'PushResult($statusCode)';
}

/// Sends encrypted Web Push messages (RFC 8030, 8291, 8292).
///
/// [send] throws [ArgumentError] for input that can never succeed: an
/// endpoint outside [isAllowedPushEndpoint], subscription keys that are not
/// valid P-256 or 16 byte secrets, or a payload over 3993 bytes. Every
/// response from the push service, and every network failure, comes back as
/// a [PushResult].
class WebPushSender {
  WebPushSender({
    required String vapidPublicKey,
    required String vapidPrivateKey,
    required String vapidSubject,
    http.Client? client,
  }) : _vapid = _VapidCredentials(
         publicKey: vapidPublicKey,
         privateKey: vapidPrivateKey,
         subject: vapidSubject,
       ),
       _client = client ?? http.Client(),
       _ownsClient = client == null;

  final _VapidCredentials _vapid;
  final http.Client _client;
  final bool _ownsClient;

  Future<PushResult> send({
    required String endpoint,
    required String p256dh,
    required String auth,
    required List<int> payload,
    required int ttlSeconds,
    String urgency = 'normal',
    String? topic,
  }) async {
    if (!isAllowedPushEndpoint(endpoint)) {
      throw ArgumentError(
        'The push endpoint is not on an allowed push service.',
        'endpoint',
      );
    }
    if (ttlSeconds < 0) {
      throw ArgumentError('TTL must not be negative.', 'ttlSeconds');
    }
    if (!_urgencies.contains(urgency)) {
      throw ArgumentError(
        'Urgency must be very-low, low, normal or high.',
        'urgency',
      );
    }
    if (payload.length > _maxPayloadLength) {
      throw ArgumentError(
        'The push payload must be at most $_maxPayloadLength bytes.',
        'payload',
      );
    }
    final uaPublic = _b64UrlDecode(p256dh, 'p256dh');
    _p256Point(uaPublic, 'p256dh');
    final authSecret = _b64UrlDecode(auth, 'auth');
    if (authSecret.length != _authSecretLength) {
      throw ArgumentError(
        'The subscription auth secret must be $_authSecretLength bytes.',
        'auth',
      );
    }

    final ephemeral = _generateP256KeyPair();
    final body = encryptAes128gcm(
      plaintext: Uint8List.fromList(payload),
      uaPublic: uaPublic,
      authSecret: authSecret,
      asPrivate: ephemeral.privateKey,
      asPublic: ephemeral.publicKey,
      salt: _randomBytes(_saltLength),
    );
    final headers = {
      'TTL': '$ttlSeconds',
      'Content-Encoding': 'aes128gcm',
      'Content-Type': 'application/octet-stream',
      'Urgency': urgency,
      if (topic != null) 'Topic': _topicHeader(topic),
      'Authorization': _vapid.authorizationHeader(endpoint, DateTime.now()),
    };

    try {
      final response = await _client
          .post(Uri.parse(endpoint), headers: headers, body: body)
          .timeout(_requestTimeout);
      return PushResult(
        statusCode: response.statusCode,
        body: response.bodyBytes.isEmpty
            ? null
            : utf8.decode(response.bodyBytes, allowMalformed: true),
      );
    } on TimeoutException {
      return const PushResult(statusCode: 0, body: 'Request timed out');
    } on http.ClientException catch (error) {
      return PushResult(statusCode: 0, body: error.message);
    } on IOException catch (error) {
      return PushResult(statusCode: 0, body: '$error');
    }
  }

  /// Closes the HTTP client if this sender created it.
  void close() {
    if (_ownsClient) _client.close();
  }
}

/// Encrypts [plaintext] as a single aes128gcm record (RFC 8291 section 3.4,
/// RFC 8188 section 2). Deterministic for a given key pair and salt, which
/// is what lets the RFC 8291 Appendix A vector be reproduced.
Uint8List encryptAes128gcm({
  required Uint8List plaintext,
  required Uint8List uaPublic,
  required Uint8List authSecret,
  required Uint8List asPrivate,
  required Uint8List asPublic,
  required Uint8List salt,
  int recordSize = _recordSize,
}) {
  if (authSecret.length != _authSecretLength) {
    throw ArgumentError(
      'The auth secret must be $_authSecretLength bytes.',
      'authSecret',
    );
  }
  if (salt.length != _saltLength) {
    throw ArgumentError('The salt must be $_saltLength bytes.', 'salt');
  }
  // RFC 8291 section 4: rs must exceed plaintext, delimiter and tag.
  final recordLength = plaintext.length + 1 + _gcmTagLength;
  if (recordSize <= recordLength || recordSize > 0xffffffff) {
    throw ArgumentError(
      'The record size must be over $recordLength bytes and fit in 32 bits.',
      'recordSize',
    );
  }
  final uaPoint = _p256Point(uaPublic, 'uaPublic');
  _p256Point(asPublic, 'asPublic');
  final asScalar = _p256Scalar(asPrivate, 'asPrivate');

  final ecdhSecret = _ecdh(asScalar, uaPoint);
  final ikm = _hkdfSha256(
    salt: authSecret,
    ikm: ecdhSecret,
    info: [...ascii.encode('WebPush: info'), 0, ...uaPublic, ...asPublic],
    length: 32,
  );
  final cek = _hkdfSha256(
    salt: salt,
    ikm: ikm,
    info: [...ascii.encode('Content-Encoding: aes128gcm'), 0],
    length: 16,
  );
  final nonce = _hkdfSha256(
    salt: salt,
    ikm: ikm,
    info: [...ascii.encode('Content-Encoding: nonce'), 0],
    length: 12,
  );

  final record = Uint8List(plaintext.length + 1)
    ..setAll(0, plaintext)
    ..[plaintext.length] = _lastRecordDelimiter;
  final cipher = GCMBlockCipher(AESEngine())
    ..init(
      true,
      AEADParameters(KeyParameter(cek), _gcmTagLength * 8, nonce, Uint8List(0)),
    );
  final ciphertext = cipher.process(record);

  // RFC 8188 section 2.1: salt || rs (uint32 big endian) || idlen || keyid.
  final recordSizeBytes = ByteData(4)..setUint32(0, recordSize);
  return (BytesBuilder(copy: false)
        ..add(salt)
        ..add(recordSizeBytes.buffer.asUint8List())
        ..addByte(asPublic.length)
        ..add(asPublic)
        ..add(ciphertext))
      .takeBytes();
}

/// Builds the RFC 8292 `Authorization` header for one push request.
String vapidAuthorizationHeader({
  required String endpoint,
  required String vapidPublicKey,
  required String vapidPrivateKey,
  required String subject,
  DateTime? now,
}) {
  return _VapidCredentials(
    publicKey: vapidPublicKey,
    privateKey: vapidPrivateKey,
    subject: subject,
  ).authorizationHeader(endpoint, now ?? DateTime.now());
}

/// Push endpoints come from browsers, so only known push services are
/// reachable. Anything else would let a client make the server POST to an
/// arbitrary URL.
bool isAllowedPushEndpoint(String endpoint) {
  final uri = Uri.tryParse(endpoint);
  if (uri == null || uri.scheme != 'https' || uri.port != 443) return false;
  final host = uri.host.toLowerCase();
  return _pushHosts.contains(host) || host.endsWith('.notify.windows.com');
}

final class _VapidCredentials {
  factory _VapidCredentials({
    required String publicKey,
    required String privateKey,
    required String subject,
  }) {
    // RFC 8292 section 2.1: the contact must be a mailto: or https: URI.
    if (!subject.startsWith('mailto:') && !subject.startsWith('https://')) {
      throw ArgumentError(
        'The VAPID subject must be a mailto: or https: URI.',
        'subject',
      );
    }
    final publicBytes = _b64UrlDecode(publicKey, 'vapidPublicKey');
    _p256Point(publicBytes, 'vapidPublicKey');
    final d = _p256Scalar(
      _b64UrlDecode(privateKey, 'vapidPrivateKey'),
      'vapidPrivateKey',
    );
    if (!_bytesEqual(_publicKeyFor(d), publicBytes)) {
      throw ArgumentError(
        'The VAPID public key does not match the private key.',
        'vapidPublicKey',
      );
    }
    return _VapidCredentials._(
      _b64UrlEncode(publicBytes),
      ECPrivateKey(d, _p256),
      subject,
    );
  }

  _VapidCredentials._(this._publicKey, this._privateKey, this._subject);

  final String _publicKey;
  final ECPrivateKey _privateKey;
  final String _subject;

  String authorizationHeader(String endpoint, DateTime now) {
    final uri = Uri.tryParse(endpoint);
    if (uri == null || uri.scheme != 'https' || uri.host.isEmpty) {
      throw ArgumentError(
        'The push endpoint must be an https URL.',
        'endpoint',
      );
    }
    final expiresAt = now.add(_vapidTokenLifetime).millisecondsSinceEpoch;
    final signingInput = [
      _jsonSegment({'typ': 'JWT', 'alg': 'ES256'}),
      _jsonSegment({
        'aud': uri.origin,
        'exp': expiresAt ~/ 1000,
        'sub': _subject,
      }),
    ].join('.');

    // RFC 6979 deterministic k, so no pointycastle SecureRandom needs seeding.
    final signer = ECDSASigner(SHA256Digest(), HMac(SHA256Digest(), 64))
      ..init(true, PrivateKeyParameter<ECPrivateKey>(_privateKey));
    final signature =
        signer.generateSignature(utf8.encode(signingInput)) as ECSignature;
    // JWS ES256 is raw r || s (RFC 7518 section 3.4). pointycastle hands
    // back BigInts, and DER would be rejected by push services.
    final rawSignature = Uint8List(64)
      ..setAll(0, _encodeUnsigned(signature.r, 32))
      ..setAll(32, _encodeUnsigned(signature.s, 32));

    return 'vapid t=$signingInput.${_b64UrlEncode(rawSignature)}, '
        'k=$_publicKey';
  }
}

typedef _KeyPair = ({Uint8List publicKey, Uint8List privateKey});

_KeyPair _generateP256KeyPair() {
  BigInt d;
  do {
    d = _decodeUnsigned(_randomBytes(32));
  } while (d == BigInt.zero || d >= _p256.n);
  return (publicKey: _publicKeyFor(d), privateKey: _encodeUnsigned(d, 32));
}

Uint8List _publicKeyFor(BigInt d) => (_p256.G * d)!.getEncoded(false);

ECPoint _p256Point(Uint8List bytes, String name) {
  if (bytes.length != 65 || bytes[0] != 0x04) {
    throw ArgumentError(
      '$name must be a 65 byte uncompressed P-256 public key.',
      name,
    );
  }
  // RFC 8291 section 7 requires an on-curve check. pointycastle's
  // decodePoint only checks that x and y are below the field prime.
  final point = _p256.curve.decodePoint(bytes)!;
  final x = point.x!;
  final y = point.y!;
  if (y.square() != x * x.square() + _p256.curve.a! * x + _p256.curve.b!) {
    throw ArgumentError('$name is not a point on the P-256 curve.', name);
  }
  return point;
}

BigInt _p256Scalar(Uint8List bytes, String name) {
  final d = _decodeUnsigned(bytes);
  if (bytes.length != 32 || d == BigInt.zero || d >= _p256.n) {
    throw ArgumentError('$name must be a 32 byte P-256 private key.', name);
  }
  return d;
}

Uint8List _ecdh(BigInt privateScalar, ECPoint publicPoint) {
  final agreement = ECDHBasicAgreement()
    ..init(ECPrivateKey(privateScalar, _p256));
  // The shared x coordinate comes back as a BigInt, which drops leading
  // zero bytes. HKDF needs the fixed 32 byte encoding.
  return _encodeUnsigned(
    agreement.calculateAgreement(ECPublicKey(publicPoint, _p256)),
    32,
  );
}

Uint8List _hkdfSha256({
  required Uint8List salt,
  required Uint8List ikm,
  required List<int> info,
  required int length,
}) {
  final hkdf = HKDFKeyDerivator(SHA256Digest())
    ..init(HkdfParameters(ikm, length, salt, Uint8List.fromList(info)));
  return hkdf.process(Uint8List(0));
}

String _topicHeader(String topic) {
  if (_topicPattern.hasMatch(topic)) return topic;
  // RFC 8030 section 5.4 allows at most 32 base64url characters. A digest
  // keeps equal topics equal, so they still replace each other in the queue.
  final digest = SHA256Digest().process(utf8.encode(topic));
  return _b64UrlEncode(digest).substring(0, 32);
}

String _jsonSegment(Map<String, Object> json) =>
    _b64UrlEncode(utf8.encode(jsonEncode(json)));

String _b64UrlEncode(List<int> bytes) =>
    base64Url.encode(bytes).replaceAll('=', '');

Uint8List _b64UrlDecode(String value, String name) {
  try {
    return base64Url.decode(base64Url.normalize(value.trim()));
  } on FormatException {
    throw ArgumentError('$name is not valid base64url.', name);
  }
}

Uint8List _randomBytes(int length) {
  final bytes = Uint8List(length);
  for (var i = 0; i < length; i++) {
    bytes[i] = _random.nextInt(256);
  }
  return bytes;
}

BigInt _decodeUnsigned(List<int> bytes) {
  var value = BigInt.zero;
  for (final byte in bytes) {
    value = (value << 8) | BigInt.from(byte);
  }
  return value;
}

Uint8List _encodeUnsigned(BigInt value, int length) {
  final bytes = Uint8List(length);
  var remaining = value;
  for (var i = length - 1; i >= 0; i--) {
    bytes[i] = (remaining & _byteMask).toInt();
    remaining >>= 8;
  }
  return bytes;
}

bool _bytesEqual(List<int> a, List<int> b) {
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}
