import 'dart:convert';
import 'dart:typed_data';

import 'package:docket_server/src/notify/web_push.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:pointycastle/api.dart';
import 'package:pointycastle/block/aes.dart';
import 'package:pointycastle/block/modes/gcm.dart';
import 'package:pointycastle/digests/sha256.dart';
import 'package:pointycastle/ecc/api.dart';
import 'package:pointycastle/ecc/curves/secp256r1.dart';
import 'package:pointycastle/key_derivators/api.dart';
import 'package:pointycastle/key_derivators/hkdf.dart';
import 'package:pointycastle/signers/ecdsa_signer.dart';
import 'package:test/test.dart';

// RFC 8291 Appendix A inputs, copied from
// https://www.rfc-editor.org/rfc/rfc8291.txt with whitespace removed.
const _rfcPlaintext = 'V2hlbiBJIGdyb3cgdXAsIEkgd2FudCB0byBiZSBhIHdhdGVybWVsb24';
const _rfcAsPublic =
    'BP4z9KsN6nGRTbVYI_c7VJSPQTBtkgcy27mlmlMoZIIg'
    'Dll6e3vCYLocInmYWAmS6TlzAC8wEqKK6PBru3jl7A8';
const _rfcAsPrivate = 'yfWPiYE-n46HLnH0KqZOF1fJJU3MYrct3AELtAQ-oRw';
const _rfcUaPublic =
    'BCVxsr7N_eNgVRqvHtD0zTZsEc6-VV-JvLexhqUzORcx'
    'aOzi6-AYWXvTBHm4bjyPjs7Vd8pZGH6SRpkNtoIAiw4';
const _rfcUaPrivate = 'q1dXpw3UpT5VOmu_cf_v6ih07Aems3njxI-JWgLcM94';
const _rfcSalt = 'DGv6ra1nlYgDCS1FRnbzlw';
const _rfcAuthSecret = 'BTBZMqHH6r4Tts7J_aSIgg';

// Appendix A says header || ciphertext is "the result shown in Section 5".
const _rfcHeader =
    'DGv6ra1nlYgDCS1FRnbzlwAAEABBBP4z9KsN6nGRTbVYI_c7VJSPQTBtkgcy27ml'
    'mlMoZIIgDll6e3vCYLocInmYWAmS6TlzAC8wEqKK6PBru3jl7A8';
const _rfcCiphertext =
    '8pfeW0KbunFT06SuDKoJH9Ql87S1QUrdirN6GcG7sFz1y1sqLgVi1VhjVkHsUoEs'
    'bI_0LpXMuGvnzQ';
const _rfcMessage =
    'DGv6ra1nlYgDCS1FRnbzlwAAEABBBP4z9KsN6nGRTbVYI_c7VJSPQTBtkgcy27ml'
    'mlMoZIIgDll6e3vCYLocInmYWAmS6TlzAC8wEqKK6PBru3jl7A_yl95bQpu6cVPT'
    'pK4Mqgkf1CXztLVBSt2Ks3oZwbuwXPXLWyouBWLVWGNWQexSgSxsj_Qulcy4a-fN';

const _fcmEndpoint = 'https://fcm.googleapis.com/fcm/send/dQw4w9WgXcQ:APA91b';
const _subject = 'mailto:ops@docket.example';

final ECDomainParameters _p256 = ECCurve_secp256r1();

void main() {
  group('Given the RFC 8291 Appendix A inputs', () {
    late Uint8List message;

    setUp(() {
      message = encryptAes128gcm(
        plaintext: _decode(_rfcPlaintext),
        uaPublic: _decode(_rfcUaPublic),
        authSecret: _decode(_rfcAuthSecret),
        asPrivate: _decode(_rfcAsPrivate),
        asPublic: _decode(_rfcAsPublic),
        salt: _decode(_rfcSalt),
      );
    });

    test('when encrypted then the output matches the RFC message byte for '
        'byte', () {
      expect(_encode(message), _rfcMessage);
    });

    test('when encrypted then the header and ciphertext match the appendix '
        'intermediate values', () {
      expect(_encode(message.sublist(0, 86)), _rfcHeader);
      expect(_encode(message.sublist(86)), _rfcCiphertext);
    });

    test('when encrypted then the body is 144 bytes, which is erratum 5230 '
        'against the 145 in Section 5', () {
      expect(message, hasLength(144));
    });

    test('when the RFC message is decrypted with the user agent key then the '
        'watermelon plaintext comes back', () {
      final plaintext = _decryptPushMessage(
        _decode(_rfcMessage),
        uaPrivate: _decode(_rfcUaPrivate),
        uaPublic: _decode(_rfcUaPublic),
        authSecret: _decode(_rfcAuthSecret),
      );
      expect(
        utf8.decode(plaintext),
        'When I grow up, I want to be a watermelon',
      );
    });

    test('when the user agent key is not on the curve then encryption is '
        'refused', () {
      final offCurve = _decode(_rfcUaPublic)..[64] ^= 0x01;
      expect(
        () => encryptAes128gcm(
          plaintext: _decode(_rfcPlaintext),
          uaPublic: offCurve,
          authSecret: _decode(_rfcAuthSecret),
          asPrivate: _decode(_rfcAsPrivate),
          asPublic: _decode(_rfcAsPublic),
          salt: _decode(_rfcSalt),
        ),
        throwsArgumentError,
      );
    });

    test('when the record size cannot hold the plaintext then encryption is '
        'refused', () {
      expect(
        () => encryptAes128gcm(
          plaintext: _decode(_rfcPlaintext),
          uaPublic: _decode(_rfcUaPublic),
          authSecret: _decode(_rfcAuthSecret),
          asPrivate: _decode(_rfcAsPrivate),
          asPublic: _decode(_rfcAsPublic),
          salt: _decode(_rfcSalt),
          recordSize: 41 + 1 + 16,
        ),
        throwsArgumentError,
      );
    });
  });

  group('Given VapidKeys.generate', () {
    test('when called then the public key is a 65 byte uncompressed point and '
        'the private key is 32 bytes, both unpadded', () {
      final keys = VapidKeys.generate();
      final publicKey = _decode(keys.publicKeyB64Url);

      expect(publicKey, hasLength(65));
      expect(publicKey.first, 0x04);
      expect(_decode(keys.privateKeyB64Url), hasLength(32));
      expect(keys.publicKeyB64Url, isNot(contains('=')));
      expect(keys.privateKeyB64Url, isNot(contains('=')));
    });

    test('when called twice then the key pairs differ', () {
      expect(
        VapidKeys.generate().privateKeyB64Url,
        isNot(VapidKeys.generate().privateKeyB64Url),
      );
    });

    test('when the halves of two pairs are mixed then WebPushSender refuses '
        'them', () {
      final first = VapidKeys.generate();
      final second = VapidKeys.generate();
      expect(
        () => WebPushSender(
          vapidPublicKey: first.publicKeyB64Url,
          vapidPrivateKey: second.privateKeyB64Url,
          vapidSubject: _subject,
        ),
        throwsArgumentError,
      );
    });
  });

  group('Given a VAPID authorization header', () {
    final keys = VapidKeys.generate();
    final now = DateTime.utc(2026, 10, 14, 9, 30);
    late String header;
    late List<String> jwtParts;

    setUp(() {
      header = vapidAuthorizationHeader(
        endpoint: _fcmEndpoint,
        vapidPublicKey: keys.publicKeyB64Url,
        vapidPrivateKey: keys.privateKeyB64Url,
        subject: _subject,
        now: now,
      );
      final match = RegExp(r'^vapid t=([^,]+), k=(.+)$').firstMatch(header);
      expect(match, isNotNull, reason: header);
      expect(match!.group(2), keys.publicKeyB64Url);
      jwtParts = match.group(1)!.split('.');
    });

    test('when decoded then the JWT header is ES256', () {
      expect(jwtParts, hasLength(3));
      expect(jsonDecode(utf8.decode(_decode(jwtParts[0]))), {
        'typ': 'JWT',
        'alg': 'ES256',
      });
    });

    test('when decoded then aud is the endpoint origin, sub is the subject and '
        'exp is just under 12 hours out', () {
      final claims =
          jsonDecode(utf8.decode(_decode(jwtParts[1]))) as Map<String, Object?>;
      final nowSeconds = now.millisecondsSinceEpoch ~/ 1000;

      expect(claims['aud'], 'https://fcm.googleapis.com');
      expect(claims['sub'], _subject);
      expect(claims['exp'], isA<int>());
      final lifetime = (claims['exp']! as int) - nowSeconds;
      expect(lifetime, lessThan(12 * 3600));
      expect(lifetime, greaterThan(11 * 3600));
    });

    test('when the signature is checked with pointycastle ECDSA then it '
        'verifies against the public key', () {
      final signature = _decode(jwtParts[2]);
      expect(signature, hasLength(64));
      expect(
        _verifyEs256(
          '${jwtParts[0]}.${jwtParts[1]}',
          signature,
          _decode(keys.publicKeyB64Url),
        ),
        isTrue,
      );
    });

    test('when the claims are altered then the signature no longer '
        'verifies', () {
      final forgedClaims = _encode(
        utf8.encode(jsonEncode({'aud': 'https://evil.example', 'exp': 1})),
      );
      expect(
        _verifyEs256(
          '${jwtParts[0]}.$forgedClaims',
          _decode(jwtParts[2]),
          _decode(keys.publicKeyB64Url),
        ),
        isFalse,
      );
    });

    test('when the subject is not mailto or https then it is refused', () {
      expect(
        () => vapidAuthorizationHeader(
          endpoint: _fcmEndpoint,
          vapidPublicKey: keys.publicKeyB64Url,
          vapidPrivateKey: keys.privateKeyB64Url,
          subject: 'ops@docket.example',
        ),
        throwsArgumentError,
      );
    });
  });

  group('Given isAllowedPushEndpoint', () {
    for (final endpoint in [
      _fcmEndpoint,
      'https://updates.push.services.mozilla.com/wpush/v2/gAAAAABk',
      'https://web.push.apple.com/QGuQyavXutnMH2V5LTrDf9Zr',
      'https://wns2-by3p.notify.windows.com/w/?token=BQYAAAB',
    ]) {
      test('when given $endpoint then it is allowed', () {
        expect(isAllowedPushEndpoint(endpoint), isTrue);
      });
    }

    for (final endpoint in [
      'http://fcm.googleapis.com/fcm/send/abc',
      'https://evil.example.com/fcm/send/abc',
      'https://fcm.googleapis.com.evil.example/fcm/send/abc',
      'https://evilnotify.windows.com/w/?token=abc',
      'https://notify.windows.com/w/?token=abc',
      'https://fcm.googleapis.com:8443/fcm/send/abc',
      'wss://web.push.apple.com/abc',
      'not a url',
      '',
    ]) {
      test('when given "$endpoint" then it is rejected', () {
        expect(isAllowedPushEndpoint(endpoint), isFalse);
      });
    }
  });

  group('Given a WebPushSender with a mock push service', () {
    final vapid = VapidKeys.generate();
    final subscriber = VapidKeys.generate();
    final authSecret = Uint8List.fromList(List.generate(16, (i) => i * 7));
    final payload = utf8.encode('{"ticket":"A-042","state":"called"}');

    Future<(PushResult, http.Request)> sendWith(
      http.Response response, {
      String urgency = 'normal',
      String? topic,
    }) async {
      late http.Request captured;
      final sender = WebPushSender(
        vapidPublicKey: vapid.publicKeyB64Url,
        vapidPrivateKey: vapid.privateKeyB64Url,
        vapidSubject: _subject,
        client: MockClient((request) async {
          captured = request;
          return response;
        }),
      );
      final result = await sender.send(
        endpoint: _fcmEndpoint,
        p256dh: subscriber.publicKeyB64Url,
        auth: _encode(authSecret),
        payload: payload,
        ttlSeconds: 600,
        urgency: urgency,
        topic: topic,
      );
      return (result, captured);
    }

    test('when sent then every Web Push header is set', () async {
      final (_, request) = await sendWith(
        http.Response('', 201),
        urgency: 'high',
        topic: 'ticket-A-042',
      );

      expect(request.method, 'POST');
      expect(request.url.toString(), _fcmEndpoint);
      expect(request.headers['TTL'], '600');
      expect(request.headers['Content-Encoding'], 'aes128gcm');
      expect(request.headers['Content-Type'], 'application/octet-stream');
      expect(request.headers['Urgency'], 'high');
      expect(request.headers['Topic'], 'ticket-A-042');
      expect(
        request.headers['Authorization'],
        matches(RegExp(r'^vapid t=[\w-]+\.[\w-]+\.[\w-]+, k=[\w-]+$')),
      );
      expect(
        request.headers['Authorization'],
        endsWith('k=${vapid.publicKeyB64Url}'),
      );
    });

    test('when no topic is given then no Topic header is sent', () async {
      final (_, request) = await sendWith(http.Response('', 201));
      expect(request.headers.containsKey('Topic'), isFalse);
      expect(request.headers['Urgency'], 'normal');
    });

    test('when the topic is too long then it is replaced by a stable 32 '
        'character base64url digest', () async {
      final topic = 'clinic-7/line-3/ticket-A-042/called-again';
      final (_, first) = await sendWith(http.Response('', 201), topic: topic);
      final (_, second) = await sendWith(http.Response('', 201), topic: topic);

      expect(first.headers['Topic'], matches(RegExp(r'^[\w-]{32}$')));
      expect(first.headers['Topic'], second.headers['Topic']);
    });

    test('when the body is decrypted with the subscriber key then the payload '
        'comes back', () async {
      final (_, request) = await sendWith(http.Response('', 201));
      final body = request.bodyBytes;

      expect(ByteData.sublistView(body, 16, 20).getUint32(0), 4096);
      expect(body[20], 65);
      expect(
        _decryptPushMessage(
          body,
          uaPrivate: _decode(subscriber.privateKeyB64Url),
          uaPublic: _decode(subscriber.publicKeyB64Url),
          authSecret: authSecret,
        ),
        payload,
      );
    });

    final statusExpectations = {
      201: (ok: true, gone: false, transient: false),
      404: (ok: false, gone: true, transient: false),
      410: (ok: false, gone: true, transient: false),
      429: (ok: false, gone: false, transient: true),
      500: (ok: false, gone: false, transient: true),
    };
    statusExpectations.forEach((status, expected) {
      test(
        'when the push service answers $status then ok is ${expected.ok}, '
        'gone is ${expected.gone} and transient is ${expected.transient}',
        () async {
          final (result, _) = await sendWith(http.Response('', status));

          expect(result.statusCode, status);
          expect(result.ok, expected.ok);
          expect(result.gone, expected.gone);
          expect(result.transient, expected.transient);
        },
      );
    });

    test('when the network fails then the result is transient with status '
        '0', () async {
      final sender = WebPushSender(
        vapidPublicKey: vapid.publicKeyB64Url,
        vapidPrivateKey: vapid.privateKeyB64Url,
        vapidSubject: _subject,
        client: MockClient(
          (_) async => throw http.ClientException('Connection refused'),
        ),
      );
      final result = await sender.send(
        endpoint: _fcmEndpoint,
        p256dh: subscriber.publicKeyB64Url,
        auth: _encode(authSecret),
        payload: payload,
        ttlSeconds: 60,
      );

      expect(result.statusCode, 0);
      expect(result.transient, isTrue);
      expect(result.ok, isFalse);
    });

    test('when the endpoint is not an allowed push service then send throws '
        'before any request', () async {
      var requests = 0;
      final sender = WebPushSender(
        vapidPublicKey: vapid.publicKeyB64Url,
        vapidPrivateKey: vapid.privateKeyB64Url,
        vapidSubject: _subject,
        client: MockClient((_) async {
          requests++;
          return http.Response('', 201);
        }),
      );

      await expectLater(
        sender.send(
          endpoint: 'https://169.254.169.254/latest/meta-data',
          p256dh: subscriber.publicKeyB64Url,
          auth: _encode(authSecret),
          payload: payload,
          ttlSeconds: 60,
        ),
        throwsArgumentError,
      );
      expect(requests, 0);
    });

    test('when the payload is over 3993 bytes then send throws', () async {
      final sender = WebPushSender(
        vapidPublicKey: vapid.publicKeyB64Url,
        vapidPrivateKey: vapid.privateKeyB64Url,
        vapidSubject: _subject,
        client: MockClient((_) async => http.Response('', 201)),
      );

      await expectLater(
        sender.send(
          endpoint: _fcmEndpoint,
          p256dh: subscriber.publicKeyB64Url,
          auth: _encode(authSecret),
          payload: List.filled(3994, 0x61),
          ttlSeconds: 60,
        ),
        throwsArgumentError,
      );
    });
  });
}

Uint8List _decode(String value) => base64Url.decode(base64Url.normalize(value));

String _encode(List<int> bytes) => base64Url.encode(bytes).replaceAll('=', '');

BigInt _toBigInt(List<int> bytes) =>
    bytes.fold(BigInt.zero, (value, byte) => (value << 8) | BigInt.from(byte));

Uint8List _toBytes(BigInt value, int length) {
  final hex = value.toRadixString(16).padLeft(length * 2, '0');
  return Uint8List.fromList([
    for (var i = 0; i < hex.length; i += 2)
      int.parse(hex.substring(i, i + 2), radix: 16),
  ]);
}

ECPublicKey _publicKey(Uint8List encoded) =>
    ECPublicKey(_p256.curve.decodePoint(encoded), _p256);

bool _verifyEs256(String signingInput, Uint8List rawSignature, Uint8List key) {
  final verifier = ECDSASigner(SHA256Digest())
    ..init(false, PublicKeyParameter<ECPublicKey>(_publicKey(key)));
  return verifier.verifySignature(
    utf8.encode(signingInput),
    ECSignature(
      _toBigInt(rawSignature.sublist(0, 32)),
      _toBigInt(rawSignature.sublist(32)),
    ),
  );
}

/// Independent user agent side of RFC 8291, used as a test oracle.
Uint8List _decryptPushMessage(
  Uint8List message, {
  required Uint8List uaPrivate,
  required Uint8List uaPublic,
  required Uint8List authSecret,
}) {
  final salt = message.sublist(0, 16);
  final keyIdLength = message[20];
  final asPublic = message.sublist(21, 21 + keyIdLength);
  final ciphertext = message.sublist(21 + keyIdLength);

  final agreement = ECDHBasicAgreement()
    ..init(ECPrivateKey(_toBigInt(uaPrivate), _p256));
  final ecdhSecret = _toBytes(
    agreement.calculateAgreement(_publicKey(asPublic)),
    32,
  );

  Uint8List hkdf(Uint8List salt, Uint8List ikm, List<int> info, int length) =>
      (HKDFKeyDerivator(SHA256Digest())
            ..init(HkdfParameters(ikm, length, salt, Uint8List.fromList(info))))
          .process(Uint8List(0));

  final ikm = hkdf(authSecret, ecdhSecret, [
    ...ascii.encode('WebPush: info\x00'),
    ...uaPublic,
    ...asPublic,
  ], 32);
  final cek = hkdf(
    salt,
    ikm,
    ascii.encode('Content-Encoding: aes128gcm\x00'),
    16,
  );
  final nonce = hkdf(
    salt,
    ikm,
    ascii.encode('Content-Encoding: nonce\x00'),
    12,
  );

  final record =
      (GCMBlockCipher(AESEngine())..init(
            false,
            AEADParameters(KeyParameter(cek), 128, nonce, Uint8List(0)),
          ))
          .process(ciphertext);
  expect(record.last, 0x02, reason: 'last record delimiter');
  return record.sublist(0, record.length - 1);
}
