import 'dart:convert';
import 'dart:io';

import 'package:serverpod/serverpod.dart';

/// One measured number shown on the reliability page, read from
/// `web/site/data/measurements.json`. Nothing on the page is a target or an
/// estimate: a measure appears only once a real run has been recorded.
class Measurement {
  const Measurement({
    required this.measure,
    required this.value,
    required this.runs,
    required this.method,
    required this.measuredOn,
  });

  factory Measurement.fromJson(Map<String, Object?> json) {
    final measuredOn = DateTime.parse(json['measuredOn'] as String);
    return Measurement(
      measure: json['measure'] as String,
      value: json['value'] as String,
      runs: json['runs'] as int,
      method: json['method'] as String,
      measuredOn: measuredOn,
    );
  }

  final String measure;
  final String value;
  final int runs;
  final String method;
  final DateTime measuredOn;

  Map<String, Object> toTemplateValues() => {
    'measure': measure,
    'value': value,
    'runs': runs == 1 ? '1 run' : '$runs runs',
    'method': method,
    'measuredOn': _longDate(measuredOn),
    'measuredOnIso': _isoDate(measuredOn),
  };
}

/// Reads the measurements file on every request, so a newly recorded run
/// shows without a restart. A missing or malformed file is logged as an error
/// and the page shows no numbers rather than wrong ones.
Future<List<Measurement>> readMeasurements(Session session, File file) async {
  if (!await file.exists()) {
    session.log('${file.path} is missing', level: LogLevel.error);
    return const [];
  }
  try {
    final json = jsonDecode(await file.readAsString()) as List<Object?>;
    return [
      for (final entry in json)
        Measurement.fromJson(entry as Map<String, Object?>),
    ];
  } on FormatException catch (e, stackTrace) {
    session.log(
      '${file.path} is not valid measurement JSON',
      level: LogLevel.error,
      exception: e,
      stackTrace: stackTrace,
    );
  } on TypeError catch (e, stackTrace) {
    session.log(
      '${file.path} has an entry with a missing or mistyped field',
      level: LogLevel.error,
      exception: e,
      stackTrace: stackTrace,
    );
  }
  return const [];
}

const _months = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];

String _longDate(DateTime d) => '${d.day} ${_months[d.month - 1]} ${d.year}';

String _isoDate(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-'
    '${d.month.toString().padLeft(2, '0')}-'
    '${d.day.toString().padLeft(2, '0')}';
