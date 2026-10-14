import 'package:serverpod/serverpod.dart';

import '../../app_config.dart';
import '../../notify/dispatcher.dart';
import '../../notify/twilio_sms.dart';

/// `POST /api/twilio/status`: Twilio's delivery reports, so the owner's log
/// shows what reached a phone and not only what Twilio accepted (BUILD A5).
class TwilioStatusRoute extends Route {
  TwilioStatusRoute() : super(methods: {Method.post});

  @override
  Future<Result> handleCall(Session session, Request request) async {
    final token = session.passwords['twilioAuthToken'];
    if (token == null || token.isEmpty) return Response(503);
    final body = await request.readAsString();
    final params = Uri.splitQueryString(body);
    final signature = request.headers['X-Twilio-Signature']?.firstOrNull ?? '';
    final url =
        '${AppConfig.publicBaseUrl(session.serverpod)}/api/twilio/status';
    if (!verifyTwilioSignature(
      authToken: token,
      url: url,
      params: params,
      signature: signature,
    )) {
      session.log('[notify] rejected a Twilio callback with a bad signature');
      return Response.forbidden();
    }
    final sid = params['MessageSid'];
    final status = params['MessageStatus'];
    if (sid != null && status != null) {
      await Dispatcher.applyTwilioStatus(
        session,
        sid,
        status,
        params['ErrorCode'],
      );
    }
    return Response.noContent();
  }
}
