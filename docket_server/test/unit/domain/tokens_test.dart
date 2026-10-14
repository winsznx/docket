import 'package:docket_server/src/security/tokens.dart';
import 'package:test/test.dart';

void main() {
  group('Given capability tokens', () {
    test('when minted then they are 43 base64url characters of 32 bytes', () {
      final t = Tokens.mint();
      expect(t.length, 43);
      expect(RegExp(r'^[A-Za-z0-9_-]+$').hasMatch(t), isTrue);
      expect(Tokens.looksValid(t), isTrue);
    });

    test('when minted twice then they differ', () {
      expect(Tokens.mint(), isNot(Tokens.mint()));
    });

    test('when hashed then it is stable SHA-256 hex', () {
      expect(
        Tokens.hash('abc'),
        'ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad',
      );
    });

    test('when malformed then it is not accepted', () {
      expect(Tokens.looksValid('short'), isFalse);
      expect(Tokens.looksValid('${'a' * 40}!'), isFalse);
    });
  });
}
