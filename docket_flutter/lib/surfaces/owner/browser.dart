import 'dart:async';
import 'dart:js_interop';

import 'package:web/web.dart' as web;

/// Browser actions the owner console needs: new tabs, file downloads and
/// clock times in the clinic's own timezone through `Intl`.
abstract final class Browser {
  static String get origin => web.window.location.origin;

  static void openInNewTab(String url) {
    web.window.open(url, '_blank', 'noopener');
  }

  /// Saves [text] as a file named [filename] with a Blob and an anchor with
  /// `download`, so nothing leaves the browser again.
  static void download(
    String filename,
    String text, {
    String type = 'text/csv',
  }) {
    final blob = web.Blob(
      [text.toJS].toJS,
      web.BlobPropertyBag(type: '$type;charset=utf-8'),
    );
    final url = web.URL.createObjectURL(blob);
    final anchor = web.HTMLAnchorElement()
      ..href = url
      ..download = filename
      ..style.display = 'none';
    web.document.body?.append(anchor);
    anchor.click();
    anchor.remove();
    Timer(const Duration(seconds: 1), () => web.URL.revokeObjectURL(url));
  }

  /// The hour of the day right now in [timeZone], 0 to 23.
  static int? hourIn(String timeZone) {
    final parts = _parts(timeZone, DateTime.now(), {'hour': '2-digit'});
    return parts == null ? null : int.tryParse(parts['hour'] ?? '');
  }

  /// A clock time in [timeZone], such as "10:42" or "10:42:07".
  static String clockIn(
    String timeZone,
    DateTime time, {
    bool seconds = false,
  }) {
    final parts = _parts(timeZone, time, {
      'hour': '2-digit',
      'minute': '2-digit',
      if (seconds) 'second': '2-digit',
    });
    if (parts == null) return _fallbackClock(time, seconds: seconds);
    final hm = '${parts['hour']}:${parts['minute']}';
    return seconds ? '$hm:${parts['second']}' : hm;
  }

  /// A day and time in [timeZone], such as "Fri 16 Oct, 18:52".
  static String dayAndTimeIn(String timeZone, DateTime time) {
    final parts = _parts(timeZone, time, {
      'weekday': 'short',
      'day': 'numeric',
      'month': 'short',
      'hour': '2-digit',
      'minute': '2-digit',
    });
    if (parts == null) return _fallbackClock(time, seconds: false);
    return '${parts['weekday']} ${parts['day']} ${parts['month']}, '
        '${parts['hour']}:${parts['minute']}';
  }

  static Map<String, String>? _parts(
    String timeZone,
    DateTime time,
    Map<String, String> fields,
  ) {
    try {
      final options =
          <String, String>{
                'timeZone': timeZone,
                'hourCycle': 'h23',
                ...fields,
              }.jsify()!
              as JSObject;
      final format = _DateTimeFormat('en-GB'.toJS, options);
      final date = _JsDate(time.toUtc().millisecondsSinceEpoch.toJS);
      return {
        for (final part in format.formatToParts(date).toDart)
          part.type.toDart: part.value.toDart,
      };
    } on Object {
      return null;
    }
  }

  static String _fallbackClock(DateTime time, {required bool seconds}) {
    final t = time.toLocal();
    String two(int n) => n.toString().padLeft(2, '0');
    final hm = '${two(t.hour)}:${two(t.minute)}';
    return seconds ? '$hm:${two(t.second)}' : hm;
  }
}

@JS('Intl.DateTimeFormat')
extension type _DateTimeFormat._(JSObject _) implements JSObject {
  external factory _DateTimeFormat(JSString locale, JSObject options);
  external JSArray<_DatePart> formatToParts(_JsDate date);
}

extension type _DatePart._(JSObject _) implements JSObject {
  external JSString get type;
  external JSString get value;
}

@JS('Date')
extension type _JsDate._(JSObject _) implements JSObject {
  external factory _JsDate(JSNumber millisecondsSinceEpoch);
}
