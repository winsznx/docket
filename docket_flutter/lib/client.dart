import 'dart:async';

import 'package:docket_client/docket_client.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';

/// The API server URL. The web server answers `assets/config.json` with the
/// API address it was configured with, so one build runs locally and on
/// Serverpod Cloud.
final serverUrl = getServerUrl();

late final Client client;

Future<void> initializeClient() async {
  client = Client(await serverUrl)
    ..connectivityMonitor = FlutterConnectivityMonitor()
    ..authSessionManager = FlutterAuthSessionManager();
  unawaited(client.auth.initialize());
}
