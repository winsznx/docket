import 'dart:js_interop';

import 'package:flutter/foundation.dart';
import 'package:web/web.dart' as web;

/// Registers `/push-sw.js` for the whole origin. Besides Web Push it caches
/// the app shell, so a desk that reloads during an outage still opens
/// (PRD 15.6). Registering the same script twice is a no-op, so the patient
/// page and the desk can both call this.
Future<void> registerAppShellWorker() async {
  try {
    final container = web.window.navigator.serviceWorker;
    await container
        .register('/push-sw.js'.toJS, web.RegistrationOptions(scope: '/'))
        .toDart;
    // Ask the worker for the whole shell, CanvasKit and fonts included, so a
    // desk that has never reloaded can still reopen during an outage.
    final ready = await container.ready.toDart;
    ready.active?.postMessage({'type': 'warm-shell'}.jsify());
  } on Object catch (e) {
    // The browser refuses when the worker file is missing or the page isn't
    // a secure context. The desk still works online, it just can't reopen
    // from cache during an outage.
    debugPrint('Docket app shell worker not registered: $e');
  }
}
