import 'package:docket_client/docket_client.dart';

/// Hands a fresh join from the join page to the ticket page, so the ticket
/// paints from the join's own view instead of waiting for the stream.
abstract final class JoinedTicket {
  static final _views = <String, PatientView>{};

  static void remember(String token, PatientView view) => _views[token] = view;

  static PatientView? take(String token) => _views.remove(token);

  /// Where this browser keeps its ticket for a clinic, so scanning the code
  /// again offers the ticket it already has.
  static String storageKey(String slug) => 'docket.ticket.$slug';

  /// Where this browser keeps the last view of a ticket, so a reload with
  /// no signal still shows the ticket, dimmed, with its last update time.
  static String viewKey(String token) => 'docket.view.$token';
}
