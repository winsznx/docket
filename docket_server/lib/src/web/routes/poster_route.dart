import 'dart:io';
import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:serverpod/serverpod.dart';

import '../../app_config.dart';
import '../../generated/protocol.dart';

/// `GET /api/poster/<slug>?line=<code>`: an A4 PDF for the clinic wall with a
/// large QR to the join page and three steps in plain words (PRD 16).
class PosterRoute extends Route {
  static const _slug = PathParam<String>(#slug, _id);
  static String _id(String v) => v;

  static pw.Font? _regular;
  static pw.Font? _bold;

  static pw.Font _font(String file) => pw.Font.ttf(
    File('assets/fonts/$file').readAsBytesSync().buffer.asByteData(),
  );

  @override
  Future<Result> handleCall(Session session, Request request) async {
    final slug = request.pathParameters.get(_slug).toLowerCase();
    final clinic = await Clinic.db.findFirstRow(
      session,
      where: (t) => t.slug.equals(slug),
    );
    if (clinic == null) return _gone();
    final code = (request.queryParameters.raw['line'] ?? '').toUpperCase();
    final lines = await Line.db.find(
      session,
      where: (t) => t.clinicId.equals(clinic.id!),
      orderBy: (t) => t.sortOrder,
    );
    if (lines.isEmpty) return _gone();
    final line = lines.firstWhere(
      (l) => l.code == code,
      orElse: () => lines.first,
    );
    final url =
        '${AppConfig.joinUrl(session.serverpod, clinic.slug)}?line=${line.code}';
    final bytes = await build(clinic.name, line.name, url);
    return Response.ok(
      headers: Headers.build((h) {
        h['Content-Disposition'] = [
          'inline; filename="docket-${clinic.slug}-${line.code}.pdf"',
        ];
        h.cacheControl = CacheControlHeader(noStore: true);
      }),
      body: Body.fromData(bytes, mimeType: MimeType.pdf),
    );
  }

  /// 410 rather than 404, since FlutterRoute's fallback answers any 404
  /// with the app.
  static Response _gone() => Response(
    410,
    body: Body.fromString("There's no clinic or line at that poster link."),
  );

  static Future<Uint8List> build(String clinic, String line, String url) async {
    _regular ??= _font('AtkinsonHyperlegibleNext-Regular.ttf');
    _bold ??= _font('AtkinsonHyperlegibleNext-ExtraBold.ttf');
    const register = PdfColor.fromInt(0xFF182C70);
    const soft = PdfColor.fromInt(0xFF4A5785);
    final doc = pw.Document(title: '$clinic, $line', author: 'Docket');
    pw.TextStyle style(double size, {bool bold = false, PdfColor? color}) =>
        pw.TextStyle(
          font: bold ? _bold : _regular,
          fontSize: size,
          color: color ?? register,
          lineSpacing: 2,
        );
    pw.Widget step(String n, String text) => pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 14),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(
            width: 36,
            child: pw.Text(n, style: style(22, bold: true)),
          ),
          pw.Expanded(child: pw.Text(text, style: style(20))),
        ],
      ),
    );
    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(48),
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(clinic, style: style(20, color: soft)),
            pw.SizedBox(height: 8),
            pw.Text('Wait anywhere.', style: style(48, bold: true)),
            pw.SizedBox(height: 6),
            pw.Text('Scan to join the $line line.', style: style(24)),
            pw.SizedBox(height: 28),
            pw.Center(
              child: pw.BarcodeWidget(
                barcode: pw.Barcode.qrCode(),
                data: url,
                width: 300,
                height: 300,
                color: register,
              ),
            ),
            pw.SizedBox(height: 28),
            step(
              '1',
              'Point your phone camera at the code. Nothing to install.',
            ),
            step(
              '2',
              'Your place in line shows on your phone. Step out if you like.',
            ),
            step(
              '3',
              'Come back when it says so. Tap I\'m coming when called.',
            ),
            pw.Spacer(),
            pw.Text(url, style: style(13, color: soft)),
          ],
        ),
      ),
    );
    return doc.save();
  }
}
