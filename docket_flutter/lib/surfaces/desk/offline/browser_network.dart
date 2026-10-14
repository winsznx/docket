import 'dart:js_interop';

import 'package:web/web.dart' as web;

/// The browser's own view of the network: `navigator.onLine` plus its
/// `online` and `offline` events (PRD 5.4).
class BrowserNetwork {
  BrowserNetwork(this.onChange);

  final void Function(bool online) onChange;

  late final JSFunction _online = ((web.Event _) => onChange(true)).toJS;
  late final JSFunction _offline = ((web.Event _) => onChange(false)).toJS;

  bool get online => web.window.navigator.onLine;

  void start() {
    web.window.addEventListener('online', _online);
    web.window.addEventListener('offline', _offline);
  }

  void dispose() {
    web.window.removeEventListener('online', _online);
    web.window.removeEventListener('offline', _offline);
  }
}
