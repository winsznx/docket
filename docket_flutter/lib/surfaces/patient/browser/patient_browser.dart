/// The browser features the patient pages use: the first-paint splash, Web
/// Push, vibration, storage and page visibility. The web build talks to the
/// real browser. Other platforms, which only the widget tests run on, get a
/// headless browser with no push support.
library;

export 'patient_browser_base.dart';
export 'patient_browser_headless.dart'
    if (dart.library.js_interop) 'patient_browser_web.dart';
