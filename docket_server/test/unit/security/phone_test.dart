import 'dart:convert';

import 'package:docket_server/src/security/phone.dart';
import 'package:test/test.dart';

void main() {
  group('Given normalizePhoneE164', () {
    const normalized = {
      '08031234567': '+2348031234567',
      '8031234567': '+2348031234567',
      '+2348031234567': '+2348031234567',
      '2348031234567': '+2348031234567',
      '0803 123 4567': '+2348031234567',
      '0803-123-4567': '+2348031234567',
      '0803.123.4567': '+2348031234567',
      '(0803) 123 4567': '+2348031234567',
      ' +234 803 123 4567 ': '+2348031234567',
      '+234 (0) 803 123 4567': '+2348031234567',
      '07012345678': '+2347012345678',
      '09012345678': '+2349012345678',
      '+1 (415) 555-2671': '+14155552671',
      '+44 20 7946 0958': '+442079460958',
      '+12345678': '+12345678',
      '+123456789012345': '+123456789012345',
    };
    normalized.forEach((input, expected) {
      test('when given "$input" then it returns $expected', () {
        expect(normalizePhoneE164(input), expected);
      });
    });

    for (final input in [
      '12345',
      'abc',
      '+0123',
      '',
      '+',
      '+1234567',
      '+1234567890123456',
      '0803123456',
      '080312345678',
      '14155552671',
      '+234-803-123-456a',
      '++2348031234567',
      '+234+8031234567',
    ]) {
      test('when given "$input" then it returns null', () {
        expect(normalizePhoneE164(input), isNull);
      });
    }
  });

  group('Given a PhoneCipher', () {
    final key = PhoneCipher.generateKeyBase64();
    final cipher = PhoneCipher(key);
    const phone = '+2348031234567';

    test('when generating a key then it decodes to 32 bytes', () {
      expect(base64.decode(key), hasLength(32));
    });

    test('when encrypted and decrypted then the phone comes back', () {
      expect(cipher.decrypt(cipher.encrypt(phone)), phone);
    });

    test('when encrypted then the output is nonce, ciphertext and tag', () {
      final bytes = base64.decode(cipher.encrypt(phone));
      expect(bytes, hasLength(12 + utf8.encode(phone).length + 16));
    });

    test('when the same phone is encrypted twice then the outputs differ', () {
      expect(cipher.encrypt(phone), isNot(cipher.encrypt(phone)));
    });

    test('when decrypted with a different key then it fails', () {
      final other = PhoneCipher(PhoneCipher.generateKeyBase64());
      expect(
        () => other.decrypt(cipher.encrypt(phone)),
        throwsFormatException,
      );
    });

    test('when the cipher text was altered then it fails', () {
      final bytes = base64.decode(cipher.encrypt(phone));
      bytes[14] ^= 0x01;
      expect(
        () => cipher.decrypt(base64.encode(bytes)),
        throwsFormatException,
      );
    });

    test('when the cipher text is too short or not base64 then it fails', () {
      expect(() => cipher.decrypt('AAAA'), throwsFormatException);
      expect(() => cipher.decrypt('%%%'), throwsFormatException);
    });

    test('when the key is not 32 bytes then construction fails', () {
      expect(
        () => PhoneCipher(base64.encode(List.filled(16, 1))),
        throwsArgumentError,
      );
      expect(() => PhoneCipher('not base64!'), throwsArgumentError);
    });
  });
}
