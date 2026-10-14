import 'dart:convert';

import 'package:serverpod/serverpod.dart';

import '../../domain/views.dart';
import '../../endpoints/ticket_endpoint.dart';
import '../../generated/protocol.dart';
import '../../strings.dart';

/// `GET /api/t/<token>`: the few facts the app shell paints before Flutter
/// boots (PRD 16). Never cached.
class FirstPaintRoute extends Route {
  static const _token = PathParam<String>(#token, _id);
  static String _id(String v) => v;

  @override
  Future<Result> handleCall(Session session, Request request) async {
    final token = request.pathParameters.get(_token);
    try {
      final ticket = await TicketEndpoint.resolve(session, token);
      final view = await Views.patient(session, ticket.id!);
      return _json(200, {
        'label': view.label,
        'state': view.state.name,
        'position': view.position,
        'etaText': view.etaText,
        'roomName': view.roomName,
        'detail': detail(view),
        'serverTime': view.serverTime.toIso8601String(),
      });
    } on DocketException catch (e) {
      return _json(404, {'error': e.message});
    }
  }

  static String detail(PatientView v) => switch (v.state) {
    TicketState.waiting when v.position != null =>
      "You're ${Copy.ordinal(v.position!)} in line for ${v.lineName}."
          '${v.etaText == null ? '' : ' ${_cap(v.etaText!)}.'}',
    TicketState.called => "Your turn. Go to ${v.roomName ?? 'the room'}.",
    TicketState.confirmed => '${v.roomName ?? 'The room'} is expecting you.',
    TicketState.inService =>
      "You're being seen in ${v.roomName ?? 'the room'}.",
    TicketState.served => 'Done. Thanks for waiting with Docket.',
    TicketState.transferred => 'Next stop: ${v.transferredToLineName ?? ''}.',
    TicketState.expired => 'This ticket expired.',
    TicketState.cancelled => 'You left the line.',
    TicketState.removed => 'The desk removed this ticket.',
    TicketState.closed => 'The clinic closed for today.',
    TicketState.waiting => v.lineName,
  };

  static String _cap(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

  static Response _json(int status, Map<String, Object?> body) => Response(
    status,
    headers: Headers.build((h) => h.cacheControl = CacheControlHeader(noStore: true)),
    body: Body.fromString(jsonEncode(body), mimeType: MimeType.json),
  );
}
