import 'dart:typed_data';

import 'package:docket_server/src/web/site/app_shots.dart';
import 'package:docket_server/src/web/site/measurements.dart';
import 'package:docket_server/src/web/site/problem_chart.dart';
import 'package:docket_server/src/web/site/site_pages.dart';
import 'package:test/test.dart';

void main() {
  group('webpSize', () {
    // The first 30 bytes of files written by cwebp 1.5.
    test('reads a lossy VP8 header', () {
      final header = Uint8List.fromList([
        82, 73, 70, 70, 168, 2, 0, 0, 87, 69, 66, 80, 86, 80, 56, 32, //
        156, 2, 0, 0, 240, 74, 0, 157, 1, 42, 134, 1, 76, 3,
      ]);
      expect(webpSize(header), (width: 390, height: 844));
    });

    test('reads a lossless VP8L header', () {
      final header = Uint8List.fromList([
        82, 73, 70, 70, 78, 0, 0, 0, 87, 69, 66, 80, 86, 80, 56, 76, //
        65, 0, 0, 0, 47, 255, 196, 179, 0, 7, 80, 150, 98, 20,
      ]);
      expect(webpSize(header), (width: 1280, height: 720));
    });

    test('reads an extended VP8X header', () {
      final header = Uint8List.fromList([
        82, 73, 70, 70, 226, 9, 0, 0, 87, 69, 66, 80, 86, 80, 56, 88, //
        10, 0, 0, 0, 16, 0, 0, 0, 11, 3, 0, 151, 6, 0,
      ]);
      expect(webpSize(header), (width: 780, height: 1688));
    });

    test('returns null for a PNG', () {
      final header = Uint8List(30)
        ..setAll(0, [137, 80, 78, 71, 13, 10, 26, 10]);
      expect(webpSize(header), isNull);
    });

    test('returns null for a short file', () {
      expect(webpSize(Uint8List(12)), isNull);
    });
  });

  group('Measurement', () {
    test('formats the run count and date for the page', () {
      final measurement = Measurement.fromJson({
        'measure': 'Desk tap to visible change on the phone',
        'value': 'median 0.8 s',
        'runs': 10,
        'method': 'Desk and phone filmed in one 60 fps frame.',
        'measuredOn': '2026-10-14',
      });

      final values = measurement.toTemplateValues();

      expect(values['runs'], '10 runs');
      expect(values['measuredOn'], '14 October 2026');
      expect(values['measuredOnIso'], '2026-10-14');
    });

    test('says 1 run for a single run', () {
      final measurement = Measurement.fromJson({
        'measure': 'Podlets',
        'value': '1',
        'runs': 1,
        'method': 'Cloud console.',
        'measuredOn': '2026-10-14',
      });

      expect(measurement.toTemplateValues()['runs'], '1 run');
    });

    test('rejects an entry with a missing field', () {
      expect(
        () => Measurement.fromJson({'measure': 'Reconnect', 'value': '2 s'}),
        throwsA(isA<TypeError>()),
      );
    });
  });

  group('problem chart', () {
    final values = problemChartValues();
    final svg = values['chartSvg'] as String;

    test('draws the longest visit at 72% of the width', () {
      expect(svg, contains('width="72.00%"'));
    });

    test('draws only the private hospital in the soft color', () {
      expect('chart-bar-soft'.allMatches(svg), hasLength(1));
      expect(visitLengths.where((v) => v.isPrivate).single.minutes, 44.9);
    });

    test('labels every bar with its value', () {
      for (final label in ['274 min', '162 min', '122.6 min', '44.9 min']) {
        expect(svg, contains(label));
      }
    });

    test('lists each source once under the chart', () {
      expect(values['sources'], hasLength(3));
      expect(values['chartRows'], hasLength(4));
    });
  });

  group('reading order', () {
    test('starts at home and ends at the live demo', () {
      expect(sitePages.first.path, '/');
      expect(nextAfter(sitePages.first).path, '/problem');
      expect(nextAfter(sitePages.last), tryLiveClinic);
    });

    test('gives every page its own title and description', () {
      expect(
        sitePages.map((p) => p.title).toSet(),
        hasLength(sitePages.length),
      );
      expect(
        sitePages.map((p) => p.description).toSet(),
        hasLength(sitePages.length),
      );
    });
  });
}
