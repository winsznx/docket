import 'dart:io';
import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';

/// A screenshot of the running app that `e2e/capture-site-shots.spec.ts`
/// writes into `web/site/img/`. A page shows it only once the file exists.
class AppShot {
  const AppShot({
    required this.file,
    required this.alt,
    required this.caption,
    this.displayWidth,
  });

  /// File name inside `web/site/img/`.
  final String file;

  final String alt;
  final String caption;

  /// The CSS width to show the image at, with the height following its
  /// aspect ratio. When null, the image's pixel size is used and CSS scales it
  /// down to fit the column.
  final int? displayWidth;
}

const patientTicketShot = AppShot(
  file: 'shot-patient-ticket.webp',
  alt:
      'The Docket ticket on a phone, with the ticket number, the place in '
      'line and what just happened in the line.',
  caption: 'A patient ticket, captured from the running app on a 390 px phone.',
  displayWidth: 390,
);

const deskShot = AppShot(
  file: 'shot-desk.webp',
  alt:
      'The Docket desk, with the patient now being served, the Call next '
      'button and the line in order.',
  caption: 'The desk, captured from the running app.',
);

const boardShot = AppShot(
  file: 'shot-board.webp',
  alt:
      "The waiting-room board, with each room's current number, the last "
      'calls and a QR code to join the line.',
  caption: 'The waiting-room board, captured from the running app.',
);

const ownerShot = AppShot(
  file: 'shot-owner.webp',
  alt: "The owner's console for setting up the clinic and reading the day.",
  caption: "The owner's console, captured from the running app.",
);

/// Template values for an `<img>` of [shot], or null when the capture hasn't
/// been made, so the page leaves the figure out.
Future<Map<String, Object>?> shotFigure(
  Session session,
  CacheBustingConfig assets,
  AppShot shot,
) async {
  final file = File.fromUri(
    Uri.directory(assets.fileSystemRoot.path).resolve('img/${shot.file}'),
  );
  if (!await file.exists()) return null;

  final size = webpSize(await _readHeader(file));
  if (size == null) {
    session.log(
      'web/site/img/${shot.file} is not a WebP image, so the page leaves it out',
      level: LogLevel.warning,
    );
    return null;
  }

  final width = shot.displayWidth ?? size.width;
  final height = shot.displayWidth == null
      ? size.height
      : (shot.displayWidth! * size.height / size.width).round();
  return {
    'src': await assets.assetPath('/site/img/${shot.file}'),
    'width': width,
    'height': height,
    'alt': shot.alt,
    'caption': shot.caption,
  };
}

Future<Uint8List> _readHeader(File file) async {
  final builder = BytesBuilder(copy: false);
  await for (final chunk in file.openRead(0, _webpHeaderLength)) {
    builder.add(chunk);
  }
  return builder.takeBytes();
}

const _webpHeaderLength = 30;

/// Pixel size from the first 30 bytes of a WebP file, for the lossy (`VP8 `),
/// lossless (`VP8L`) and extended (`VP8X`) formats. Null when [bytes] isn't a
/// WebP header.
({int width, int height})? webpSize(Uint8List bytes) {
  if (bytes.length < _webpHeaderLength) return null;
  String fourCc(int at) => String.fromCharCodes(bytes, at, at + 4);
  if (fourCc(0) != 'RIFF' || fourCc(8) != 'WEBP') return null;

  int le16(int at) => bytes[at] | bytes[at + 1] << 8;
  int le24(int at) => le16(at) | bytes[at + 2] << 16;

  switch (fourCc(12)) {
    case 'VP8X':
      return (width: le24(24) + 1, height: le24(27) + 1);
    case 'VP8L':
      final bits = le24(21) | bytes[24] << 24;
      return (width: (bits & 0x3FFF) + 1, height: (bits >> 14 & 0x3FFF) + 1);
    case 'VP8 ':
      return (width: le16(26) & 0x3FFF, height: le16(28) & 0x3FFF);
  }
  return null;
}
