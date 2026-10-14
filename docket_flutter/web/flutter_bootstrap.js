{{flutter_js}}
{{flutter_build_config}}

// Docket's own push-sw.js owns scope "/", so Flutter's service worker is
// never registered here. Loading without serviceWorkerSettings keeps that
// true even after Flutter drops the deprecated --pwa-strategy flag.
_flutter.loader.load();
