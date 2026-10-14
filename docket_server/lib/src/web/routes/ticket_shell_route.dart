import 'dart:convert';
import 'dart:io';

import 'package:serverpod/serverpod.dart';

import '../../domain/views.dart';
import '../../endpoints/ticket_endpoint.dart';
import '../../generated/protocol.dart';
import 'first_paint_route.dart';

/// `GET /t/<token>`: the app shell with the ticket's label and place already
/// written into the splash, so a phone on a slow network paints the ticket
/// from the first response instead of waiting for `/api/t` (PRD 16, 23).
/// Unknown tokens get the plain shell, and the app shows its own message.
class TicketShellRoute extends Route {
  TicketShellRoute(this.indexFile);

  final File indexFile;

  static const _token = PathParam<String>(#token, _id);
  static String _id(String v) => v;
  static const _escape = HtmlEscape();

  @override
  Future<Result> handleCall(Session session, Request request) async {
    var html = await indexFile.readAsString();
    try {
      final ticket = await TicketEndpoint.resolve(
        session,
        request.pathParameters.get(_token),
      );
      final view = await Views.patient(session, ticket.id!);
      html = html
          .replaceFirst(
            '<p id="fp-label"></p>',
            '<p id="fp-label">${_escape.convert(view.label)}</p>',
          )
          .replaceFirst(
            '<p id="fp-detail"></p>',
            '<p id="fp-detail">${_escape.convert(FirstPaintRoute.detail(view))}</p>',
          );
    } on DocketException {
      // The app shell still loads, and the ticket page explains the link.
    }
    return Response.ok(
      headers: Headers.build(
        (h) => h.cacheControl = CacheControlHeader(noStore: true),
      ),
      body: Body.fromString(html, mimeType: MimeType.html),
    );
  }
}
