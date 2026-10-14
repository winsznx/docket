import 'dart:async';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'package:flutter/foundation.dart';
import 'package:web/web.dart' as web;

import 'patient_browser_base.dart';

final PatientBrowser patientBrowser = _WebPatientBrowser();

/// One script owns scope `/`: Web Push for patients and the app shell cache
/// the desk needs offline (PRD 14.3, 15.6).
const _workerUrl = '/push-sw.js';
const _workerScope = '/';
const _callPattern = [300, 120, 300, 120, 600];

final class _WebPatientBrowser implements PatientBrowser {
  web.Navigator get _navigator => web.window.navigator;

  @override
  String? splashText(String elementId) {
    final text = web.document.getElementById(elementId)?.textContent?.trim();
    return text == null || text.isEmpty ? null : text;
  }

  bool get _isAppleTouchDevice {
    final agent = _navigator.userAgent;
    final iPadAsMac =
        agent.contains('Macintosh') && _navigator.maxTouchPoints > 1;
    return RegExp('iPhone|iPad|iPod').hasMatch(agent) || iPadAsMac;
  }

  /// Safari's `navigator.standalone`, or the display mode other browsers
  /// report for an installed web app.
  bool get _isStandalone {
    final legacy = (_navigator as JSObject).getProperty<JSAny?>(
      'standalone'.toJS,
    );
    if (legacy?.dartify() == true) return true;
    return web.window.matchMedia('(display-mode: standalone)').matches;
  }

  bool _has(JSObject target, String property) =>
      target.hasProperty(property.toJS).toDart;

  @override
  AlertsSupport get alertsSupport {
    if (_isAppleTouchDevice && !_isStandalone) {
      return AlertsSupport.addToHomeScreen;
    }
    if (!web.window.isSecureContext) return AlertsSupport.insecure;
    final complete =
        _has(_navigator, 'serviceWorker') &&
        _has(web.window, 'PushManager') &&
        _has(web.window, 'Notification');
    return complete ? AlertsSupport.push : AlertsSupport.unsupported;
  }

  @override
  Future<PushKeys> subscribePush(Future<String> applicationServerKey) async {
    if (alertsSupport != AlertsSupport.push) {
      throw const PushSetupException(PushSetupFailure.unsupported);
    }
    if (web.Notification.permission == 'denied') {
      throw const PushSetupException(PushSetupFailure.denied);
    }
    final container = _navigator.serviceWorker;
    // Both start inside the tap, so Safari still counts the permission
    // request as the user's own gesture.
    final registering = container
        .register(_workerUrl.toJS, web.RegistrationOptions(scope: _workerScope))
        .toDart;
    registering.ignore();
    final asking = web.Notification.requestPermission().toDart;

    final String permission;
    try {
      permission = (await asking).toDart;
    } on Object catch (e) {
      throw PushSetupException(PushSetupFailure.failed, e);
    }
    if (permission == 'denied') {
      throw const PushSetupException(PushSetupFailure.denied);
    }
    if (permission != 'granted') {
      throw const PushSetupException(PushSetupFailure.dismissed);
    }

    final key = await applicationServerKey;
    if (key.trim().isEmpty) {
      throw const PushSetupException(PushSetupFailure.notConfigured);
    }
    final serverKey = decodeBase64Url(key);

    try {
      final registration = await registering;
      await container.ready.toDart;
      final manager = registration.pushManager;
      var subscription = await manager.getSubscription().toDart;
      if (subscription != null &&
          !_sameKey(subscription.options.applicationServerKey, serverKey)) {
        await subscription.unsubscribe().toDart;
        subscription = null;
      }
      subscription ??= await manager
          .subscribe(
            web.PushSubscriptionOptionsInit(
              userVisibleOnly: true,
              applicationServerKey: serverKey.toJS,
            ),
          )
          .toDart;
      final p256dh = subscription.getKey('p256dh');
      final auth = subscription.getKey('auth');
      if (p256dh == null || auth == null) {
        throw const PushSetupException(PushSetupFailure.failed);
      }
      return PushKeys(
        endpoint: subscription.endpoint,
        p256dh: encodeBase64UrlNoPad(p256dh.toDart.asUint8List()),
        auth: encodeBase64UrlNoPad(auth.toDart.asUint8List()),
      );
    } on PushSetupException {
      rethrow;
    } on Object catch (e) {
      throw PushSetupException(PushSetupFailure.failed, e);
    }
  }

  bool _sameKey(JSArrayBuffer? current, Uint8List wanted) {
    if (current == null) return false;
    return listEquals(current.toDart.asUint8List(), wanted);
  }

  @override
  void vibrateForCall() {
    final android = _navigator.userAgent.contains('Android');
    final visible = web.document.visibilityState == 'visible';
    if (!android || !visible || !_has(_navigator, 'vibrate')) return;
    _navigator.vibrate(_callPattern.map((ms) => ms.toJS).toList().toJS);
  }

  @override
  Stream<void> get resumed {
    final online = web.EventStreamProviders.onlineEvent.forTarget(web.window);
    final shown = const web.EventStreamProvider<web.Event>('visibilitychange')
        .forTarget(web.document)
        .where((_) => web.document.visibilityState == 'visible');
    final controller = StreamController<void>();
    final subscriptions = <StreamSubscription<web.Event>>[];
    controller
      ..onListen = () {
        subscriptions
          ..add(online.listen((_) => controller.add(null)))
          ..add(shown.listen((_) => controller.add(null)));
      }
      ..onCancel = () async {
        for (final s in subscriptions) {
          await s.cancel();
        }
      };
    return controller.stream;
  }

  /// Storage can be blocked, for example in some private windows. Then the
  /// page works without it.
  @override
  String? read(String key) {
    try {
      return web.window.localStorage.getItem(key);
    } on Object catch (e) {
      debugPrint('Docket: storage unavailable, $e');
      return null;
    }
  }

  @override
  void write(String key, String value) {
    try {
      web.window.localStorage.setItem(key, value);
    } on Object catch (e) {
      debugPrint('Docket: storage unavailable, $e');
    }
  }

  @override
  void openHome() => web.window.location.assign('/');
}
