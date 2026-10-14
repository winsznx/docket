import 'dart:convert';
import 'dart:typed_data';

/// Whether this browser can turn on Web Push for a ticket (PRD 14.3).
enum AlertsSupport {
  /// Service worker, Push API and notifications are all there.
  push,

  /// iPhone or iPad outside a Home Screen web app. iOS delivers Web Push only
  /// to web apps added to the Home Screen.
  addToHomeScreen,

  /// The page isn't on https, so the browser hides the Push API.
  insecure,

  /// The browser has no Push API.
  unsupported,
}

/// Why turning on push stopped.
enum PushSetupFailure { denied, dismissed, unsupported, notConfigured, failed }

class PushSetupException implements Exception {
  const PushSetupException(this.failure, [this.cause]);

  final PushSetupFailure failure;
  final Object? cause;

  @override
  String toString() => 'PushSetupException(${failure.name}, $cause)';
}

/// A push subscription as the server stores it, keys in base64url.
class PushKeys {
  const PushKeys({
    required this.endpoint,
    required this.p256dh,
    required this.auth,
  });

  final String endpoint;
  final String p256dh;
  final String auth;
}

abstract interface class PatientBrowser {
  /// Text the app shell's first-paint script wrote into the splash element
  /// [elementId], or null when it's empty or gone.
  String? splashText(String elementId);

  AlertsSupport get alertsSupport;

  /// Registers `/push-sw.js`, asks for permission and subscribes with the
  /// server's VAPID key. Call it straight from the tap, so the permission
  /// prompt keeps the user's gesture. Throws [PushSetupException].
  Future<PushKeys> subscribePush(Future<String> applicationServerKey);

  /// Buzzes an Android phone for a call while the page is in front.
  void vibrateForCall();

  /// Fires when the network comes back or the page is shown again.
  Stream<void> get resumed;

  String? read(String key);
  void write(String key, String value);

  /// Leaves the app for the site's home page.
  void openHome();
}

/// Base64url without padding, the encoding the push service and the server
/// use for subscription keys.
String encodeBase64UrlNoPad(List<int> bytes) =>
    base64Url.encode(bytes).replaceAll('=', '');

/// Decodes base64url with or without padding.
Uint8List decodeBase64Url(String value) =>
    base64Url.decode(base64Url.normalize(value.trim()));
