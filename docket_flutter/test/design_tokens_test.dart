import 'dart:convert';
import 'dart:io';

import 'package:docket_flutter/shared/theme/tokens.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';

const _minimumTextContrast = 4.5;
const _statedRatioTolerance = 0.15;

const _dartColors = {
  'daylight': DocketColors.daylight,
  'register': DocketColors.register,
  'registerSoft': DocketColors.registerSoft,
  'wash': DocketColors.wash,
  'danfo': DocketColors.danfo,
  'go': DocketColors.go,
  'missed': DocketColors.missed,
  'night': DocketColors.night,
  'nightSoft': DocketColors.nightSoft,
  'registerLift': DocketColors.registerLift,
};

/// Every pair in the "Contrast, checked" column of DESIGN.md 3.1, with the
/// ratio stated there.
const _designPairs = [
  (text: 'register', field: 'daylight', stated: 12.9),
  (text: 'registerSoft', field: 'daylight', stated: 7.0),
  (text: 'register', field: 'wash', stated: 11.8),
  (text: 'register', field: 'danfo', stated: 8.4),
  (text: 'daylight', field: 'go', stated: 5.4),
  (text: 'daylight', field: 'missed', stated: 6.6),
  (text: 'daylight', field: 'night', stated: 17.7),
  (text: 'danfo', field: 'night', stated: 11.5),
  (text: 'nightSoft', field: 'night', stated: 8.5),
  (text: 'daylight', field: 'registerLift', stated: 10.2),
];

/// Pairs the theme and the ticket palette add where DESIGN.md is silent.
const _themePairs = [
  (text: 'registerSoft', field: 'wash'),
  (text: 'missed', field: 'daylight'),
  (text: 'nightSoft', field: 'registerLift'),
  (text: 'nightSoft', field: 'register'),
  (text: 'daylight', field: 'register'),
];

void main() {
  final repoRoot = _findRepoRoot();
  final jsonColors = _readJsonColors(repoRoot);

  test('the generated token files match design/tokens.json', () async {
    final result = await Process.run(_dartExecutable(), [
      'run',
      'tool/gen_tokens.dart',
      '--check',
    ], workingDirectory: repoRoot.path);

    expect(result.exitCode, 0, reason: '${result.stdout}${result.stderr}');
  });

  test('every DocketColors value equals design/tokens.json', () {
    expect(_dartColors.keys, unorderedEquals(jsonColors.keys));
    for (final MapEntry(key: name, value: color) in _dartColors.entries) {
      expect(color, jsonColors[name], reason: name);
    }
  });

  group('DESIGN.md 3.1 contrast', () {
    for (final pair in _designPairs) {
      test('${pair.text} on ${pair.field} is ${pair.stated}:1', () {
        final ratio = _contrast(pair.text, pair.field);

        expect(ratio, greaterThanOrEqualTo(_minimumTextContrast));
        expect(ratio, closeTo(pair.stated, _statedRatioTolerance));
      });
    }
  });

  group('theme contrast', () {
    for (final pair in _themePairs) {
      test('${pair.text} on ${pair.field} meets WCAG AA', () {
        expect(
          _contrast(pair.text, pair.field),
          greaterThanOrEqualTo(_minimumTextContrast),
        );
      });
    }
  });
}

double _contrast(String text, String field) {
  final a = _dartColors[text]!.computeLuminance();
  final b = _dartColors[field]!.computeLuminance();
  final (lighter, darker) = a > b ? (a, b) : (b, a);
  return (lighter + 0.05) / (darker + 0.05);
}

Directory _findRepoRoot() {
  var dir = Directory.current.absolute;
  while (!File('${dir.path}/design/tokens.json').existsSync()) {
    final parent = dir.parent;
    if (parent.path == dir.path) {
      throw StateError('design/tokens.json not found above the test directory');
    }
    dir = parent;
  }
  return dir;
}

Map<String, Color> _readJsonColors(Directory repoRoot) {
  final tokens =
      jsonDecode(File('${repoRoot.path}/design/tokens.json').readAsStringSync())
          as Map<String, Object?>;
  final colors = tokens['color']! as Map<String, Object?>;
  return {
    for (final MapEntry(key: name, value: hex) in colors.entries)
      name: Color(
        0xFF000000 | int.parse((hex! as String).substring(1), radix: 16),
      ),
  };
}

/// The Dart that ships with the running Flutter SDK, falling back to PATH.
String _dartExecutable() {
  final flutterRoot = Platform.environment['FLUTTER_ROOT'];
  if (flutterRoot != null) {
    final dart = File('$flutterRoot/bin/dart');
    if (dart.existsSync()) return dart.path;
  }
  return 'dart';
}
