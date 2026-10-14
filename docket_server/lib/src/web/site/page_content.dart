import 'dart:io';

import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../../strings.dart';
import 'app_shots.dart';
import 'measurements.dart';
import 'problem_chart.dart';
import 'site_route.dart';

/// The template values each page body needs, keyed by page path.
///
/// Timings come from the `Clinic` model's defaults, which are the PRD 4.2
/// values, so the site can't drift from what a new clinic actually gets.
Map<String, PageContent> pageContent(CacheBustingConfig assets) {
  final defaults = Clinic(name: '', slug: '');
  final measurementsFile = File.fromUri(
    Uri.directory(
      assets.fileSystemRoot.path,
    ).resolve('data/measurements.json'),
  );

  Future<Map<String, Object?>> none(Session session) async => const {};

  return {
    '/': (session) async => {
      'graceClock': _clock(defaults.graceSeconds),
      'graceSeconds': defaults.graceSeconds,
      'arrivalClock': _clock(defaults.arrivalSeconds),
      'arrivalSeconds': defaults.arrivalSeconds,
    },
    '/problem': (session) async => problemChartValues(),
    '/how-it-works': (session) async => {
      'headsUpPosition': Copy.ordinal(defaults.headsUpPositions),
      'headsUpMinutes': defaults.headsUpMinutes,
      'graceMinutes': Copy.minutesWords(defaults.graceSeconds),
      'arrivalMinutes': Copy.minutesWords(defaults.arrivalSeconds),
      'reslotOffset': defaults.reslotOffset,
      'reslotTimes': _times(defaults.maxReslots),
    },
    '/patients': (session) async => {
      'graceMinutes': Copy.minutesWords(defaults.graceSeconds),
      'reslotOffset': defaults.reslotOffset,
      'reslotTimes': _times(defaults.maxReslots),
      'ticketShot': await shotFigure(session, assets, patientTicketShot),
    },
    '/clinics': (session) async => {
      'deskShot': await shotFigure(session, assets, deskShot),
      'boardShot': await shotFigure(session, assets, boardShot),
      'ownerShot': await shotFigure(session, assets, ownerShot),
    },
    '/reliability': (session) async {
      final measurements = await readMeasurements(session, measurementsFile);
      return {
        'graceMinutes': Copy.minutesWords(defaults.graceSeconds),
        'hasMeasurements': measurements.isNotEmpty,
        'measurements': [
          for (final m in measurements) m.toTemplateValues(),
        ],
      };
    },
    '/under-the-hood': none,
    '/privacy': none,
  };
}

/// `180` as `3:00`, the way the ticket shows a countdown.
String _clock(int seconds) =>
    '${seconds ~/ 60}:${(seconds % 60).toString().padLeft(2, '0')}';

String _times(int count) => switch (count) {
  1 => 'once',
  2 => 'twice',
  _ => '$count times',
};
