import 'dart:convert';

import 'package:docket_server/src/notify/twilio_sms.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:test/test.dart';

const _accountSid = 'AC0123456789abcdef0123456789abcdef';
const _authToken = 'test-auth-token';
const _from = '+15005550006';
const _to = '+2348031234567';

void main() {
  group('Given a TwilioSmsSender with a mock Twilio API', () {
    Future<(SmsResult, http.Request)> sendWith(
      http.Response response, {
      String? statusCallback,
    }) async {
      late http.Request captured;
      final sender = TwilioSmsSender(
        accountSid: _accountSid,
        authToken: _authToken,
        from: _from,
        client: MockClient((request) async {
          captured = request;
          return response;
        }),
      );
      final result = await sender.send(
        to: _to,
        body: 'Ticket A-042, please come to room 3.',
        statusCallback: statusCallback,
      );
      return (result, captured);
    }

    http.Response json(Object body, int status) => http.Response(
      jsonEncode(body),
      status,
      headers: {'content-type': 'application/json; charset=utf-8'},
    );

    test('when sent then it posts the form to the account Messages resource '
        'with basic auth', () async {
      final (_, request) = await sendWith(
        json({'sid': 'SM0001', 'status': 'queued'}, 201),
        statusCallback: 'https://docket.example/twilio/status',
      );

      expect(request.method, 'POST');
      expect(
        request.url.toString(),
        'https://api.twilio.com/2010-04-01/Accounts/$_accountSid/Messages.json',
      );
      expect(
        request.headers['Authorization'],
        'Basic ${base64.encode(utf8.encode('$_accountSid:$_authToken'))}',
      );
      expect(
        request.headers['Content-Type'],
        startsWith('application/x-www-form-urlencoded'),
      );
      expect(request.bodyFields, {
        'To': _to,
        'From': _from,
        'Body': 'Ticket A-042, please come to room 3.',
        'StatusCallback': 'https://docket.example/twilio/status',
      });
    });

    test(
      'when no status callback is given then the field is left out',
      () async {
        final (_, request) = await sendWith(
          json({'sid': 'SM0001', 'status': 'queued'}, 201),
        );
        expect(request.bodyFields.containsKey('StatusCallback'), isFalse);
      },
    );

    test('when Twilio accepts the message then sid and status are '
        'parsed', () async {
      final (result, _) = await sendWith(
        json({'sid': 'SM0001', 'status': 'queued', 'to': _to}, 201),
      );

      expect(result.ok, isTrue);
      expect(result.sid, 'SM0001');
      expect(result.status, 'queued');
      expect(result.error, isNull);
      expect(result.transient, isFalse);
    });

    test('when Twilio rejects the number then the error is permanent and '
        'does not repeat the recipient', () async {
      final (result, _) = await sendWith(
        json({
          'code': 21211,
          'message': "The 'To' number $_to is not a valid phone number.",
          'more_info': 'https://www.twilio.com/docs/errors/21211',
          'status': 400,
        }, 400),
      );

      expect(result.ok, isFalse);
      expect(result.transient, isFalse);
      expect(result.status, isNull);
      expect(result.error, contains('21211'));
      expect(result.error, contains('not a valid phone number'));
      expect(result.error, isNot(contains(_to)));
    });

    for (final status in [429, 500, 503]) {
      test(
        'when Twilio answers $status then the failure is transient',
        () async {
          final (result, _) = await sendWith(
            http.Response('<html>upstream unavailable</html>', status),
          );

          expect(result.ok, isFalse);
          expect(result.transient, isTrue);
          expect(result.error, contains('$status'));
        },
      );
    }

    test('when the network fails then the failure is transient', () async {
      final sender = TwilioSmsSender(
        accountSid: _accountSid,
        authToken: _authToken,
        from: _from,
        client: MockClient(
          (_) async => throw http.ClientException('Connection reset'),
        ),
      );
      final result = await sender.send(to: _to, body: 'hello');

      expect(result.ok, isFalse);
      expect(result.transient, isTrue);
      expect(result.error, contains('Connection reset'));
    });

    test('when the account SID is malformed then construction fails', () {
      expect(
        () => TwilioSmsSender(
          accountSid: 'not-a-sid',
          authToken: _authToken,
          from: _from,
        ),
        throwsArgumentError,
      );
    });
  });

  group('Given the Twilio SDK request validator vector', () {
    // From twilio-python tests/unit/test_request_validator.py. The current
    // webhooks-security docs page reads the auth token from an environment
    // variable, so its sample signature cannot be reproduced.
    const authToken = '12345';
    const url = 'https://mycompany.com/myapp.php?foo=1&bar=2';
    const params = {
      'CallSid': 'CA1234567890ABCDE',
      'Digits': '1234',
      'From': '+14158675309',
      'To': '+18005551212',
      'Caller': '+14158675309',
    };
    const signature = 'RSOYDt4T1cUTdK1PDd93/VVr8B8=';

    test('when verified then the documented signature is accepted', () {
      expect(
        verifyTwilioSignature(
          authToken: authToken,
          url: url,
          params: params,
          signature: signature,
        ),
        isTrue,
      );
    });

    test('when the signature is wrong then it is rejected', () {
      expect(
        verifyTwilioSignature(
          authToken: authToken,
          url: url,
          params: params,
          signature: 'RSOYDt4T1cUTdK1PDd93/VVr8B9=',
        ),
        isFalse,
      );
    });

    test('when a parameter was changed then it is rejected', () {
      expect(
        verifyTwilioSignature(
          authToken: authToken,
          url: url,
          params: {...params, 'Digits': '9999'},
          signature: signature,
        ),
        isFalse,
      );
    });

    test('when the auth token is different then it is rejected', () {
      expect(
        verifyTwilioSignature(
          authToken: '54321',
          url: url,
          params: params,
          signature: signature,
        ),
        isFalse,
      );
    });

    test('when the signature is not base64 then it is rejected', () {
      expect(
        verifyTwilioSignature(
          authToken: authToken,
          url: url,
          params: params,
          signature: 'not a signature',
        ),
        isFalse,
      );
    });
  });
}
