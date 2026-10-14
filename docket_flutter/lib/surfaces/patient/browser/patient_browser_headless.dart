import 'dart:async';

import 'patient_browser_base.dart';

/// Used where there's no browser, which in this web-only app means the
/// widget tests. It has no push, no splash and no vibration, and keeps
/// storage in memory.
final PatientBrowser patientBrowser = _HeadlessPatientBrowser();

final class _HeadlessPatientBrowser implements PatientBrowser {
  final _storage = <String, String>{};

  @override
  String? splashText(String elementId) => null;

  @override
  AlertsSupport get alertsSupport => AlertsSupport.unsupported;

  @override
  Future<PushKeys> subscribePush(Future<String> applicationServerKey) =>
      Future.error(const PushSetupException(PushSetupFailure.unsupported));

  @override
  void vibrateForCall() {}

  @override
  Stream<void> get resumed => const Stream.empty();

  @override
  String? read(String key) => _storage[key];

  @override
  void write(String key, String value) => _storage[key] = value;

  @override
  void openHome() {}
}
