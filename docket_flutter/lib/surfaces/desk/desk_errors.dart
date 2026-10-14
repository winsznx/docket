import 'package:docket_client/docket_client.dart' hide Notification;

import '../../shared/strings.dart';

/// Status codes that mean "try again later", not "no".
const _transientStatus = {408, 429, 502, 503, 504};

/// True when the server may never have seen the request, or asked for a
/// pause, so sending the same action again later is the right move.
bool isTransient(Object error) => switch (error) {
  DocketException() => false,
  ServerpodClientHttpException(:final statusCode) => _transientStatus.contains(
    statusCode,
  ),
  _ => true,
};

/// What to tell the person when a call to the server fails. The server's own
/// refusals are product copy and show as they are.
String errorText(Object error) => switch (error) {
  DocketException(:final message) => message,
  ServerpodClientHttpException(statusCode: 429) => DeskStrings.tooManyTries,
  _ => DeskStrings.networkError,
};
