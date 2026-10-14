import 'package:docket_client/docket_client.dart';
import 'package:docket_flutter/surfaces/owner/owner_logic.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('suggestSlug', () {
    test('lowercases and joins words with single hyphens', () {
      expect(suggestSlug('Ikeja Family Clinic'), 'ikeja-family-clinic');
      expect(suggestSlug("St. Mary's Clinic, Ikeja"), 'st-marys-clinic-ikeja');
      expect(suggestSlug('  Lagos   Island  '), 'lagos-island');
    });

    test('drops accents and anything else outside a-z and 0-9', () {
      expect(suggestSlug('Clínica Ọjọ́ 2'), 'clinica-ojo-2');
      expect(suggestSlug('A&B Health (Yaba)'), 'a-b-health-yaba');
    });

    test('stops at 40 characters without a trailing hyphen', () {
      final slug = suggestSlug(
        'The Very Long Name Of A Community Health Centre In Surulere',
      );
      expect(slug.length, lessThanOrEqualTo(40));
      expect(slug.endsWith('-'), isFalse);
      expect(validateSlug(slug), isNull);
    });

    test('a suggested slug passes the same check as the server', () {
      for (final name in ['Ikeja Family Clinic', 'Ward 7', 'Yaba Lab']) {
        expect(validateSlug(suggestSlug(name)), isNull, reason: name);
      }
    });
  });

  group('validation messages', () {
    test('slugs follow the server rule, sandbox names are kept back', () {
      const message =
          'Use 3 to 40 lowercase letters, numbers or hyphens for the link.';
      expect(validateSlug('ab'), message);
      expect(validateSlug('-ikeja'), message);
      expect(validateSlug('Ikeja'), message);
      expect(validateSlug('sandbox-ikeja'), message);
      expect(validateSlug('ikeja-family'), isNull);
    });

    test('each number setting names itself and its range', () {
      final grace = settingGroups.first.$2.first;
      expect(
        grace.validate('30'),
        'Time to confirm has to be between 60 and 900.',
      );
      expect(
        grace.validate('901'),
        'Time to confirm has to be between 60 and 900.',
      );
      expect(grace.validate('180'), isNull);
      expect(grace.validate('three'), 'Use a whole number.');
      expect(grace.rangeText, '60 to 900 seconds.');

      final reminder = settingGroups.first.$2[1];
      expect(
        reminder.validate('10'),
        'The reminder has to be between 15 and 120.',
      );

      expect(autoCloseSpec.validate('0'), isNull);
      expect(
        autoCloseSpec.validate('601'),
        'Auto close has to be between 0 and 600.',
      );
    });

    test('every setting from PRD 4.2 has a range that matches it', () {
      final ranges = {
        for (final (_, specs) in settingGroups)
          for (final s in specs) s.label: (s.min, s.max),
        autoCloseSpec.label: (autoCloseSpec.min, autoCloseSpec.max),
      };
      expect(ranges.values.toList(), [
        (60, 900),
        (15, 120),
        (120, 1800),
        (1, 5),
        (3, 30),
        (1, 10),
        (0, 3),
        (0, 600),
      ]);
    });

    test('hours must run open, last join, close', () {
      expect(validateHours('08:00', '17:00', '18:00'), isNull);
      expect(validateHours('08:00', '18:00', '18:00'), isNull);
      expect(
        validateHours('17:00', '08:00', '18:00'),
        'Opening has to come before the last join, and that before closing.',
      );
      expect(
        validateHours('8am', '17:00', '18:00'),
        'Use 24-hour times like 08:00.',
      );
      expect(
        validateHours('08:00', '24:00', '18:00'),
        'Use 24-hour times like 08:00.',
      );
    });

    test('lines need a name, one capital letter and 1 to 60 minutes', () {
      expect(validateLineName(' '), 'Give the line a name.');
      expect(validateLineCode('CC'), 'The line code is one capital letter.');
      expect(validateLineCode('c'), isNull);
      expect(
        validateServiceMinutes('0'),
        'Usual time per patient has to be between 1 and 60 minutes.',
      );
      expect(validateServiceMinutes('8'), isNull);
    });

    test('line codes are suggested from the name, never twice', () {
      expect(suggestLineCode('Lab', const ['C']), 'L');
      expect(suggestLineCode('Lab', const ['L', 'C']), 'A');
      expect(suggestLineCode('', const ['A', 'B']), 'C');
    });
  });

  group('reports', () {
    test('wait and visit times read the way people say them', () {
      expect(formatDuration(null), 'None yet');
      expect(formatDuration(40), 'under 1 min');
      expect(formatDuration(14 * 60 + 10), '14 min');
      expect(formatDuration(60 * 60), '1 h');
      expect(formatDuration(95 * 60), '1 h 35 min');
    });

    test('the chart spans opening hours and any hour with arrivals', () {
      final counts = List<int>.filled(24, 0)
        ..[7] = 2
        ..[12] = 9;
      expect(chartHours(counts, '08:00', '18:00'), (7, 17));
      expect(chartHours(List.filled(24, 0), '08:00', '18:00'), (8, 17));
    });

    test('arrivals add up across lines', () {
      LineReport line(List<int> hours) => LineReport(
        lineName: 'x',
        joined: 0,
        served: 0,
        cancelled: 0,
        removed: 0,
        expired: 0,
        reslotted: 0,
        waitingNow: 0,
        arrivalsByHour: hours,
      );
      final a = List<int>.filled(24, 0)..[9] = 3;
      final b = List<int>.filled(24, 0)
        ..[9] = 1
        ..[10] = 4;
      final total = totalArrivals([line(a), line(b)]);
      expect(total[9], 4);
      expect(total[10], 4);
    });

    test('service dates round trip', () {
      expect(serviceDateOf(DateTime(2026, 3, 4)), '2026-03-04');
      expect(readableDate('2026-10-14'), 'Wed 14 Oct 2026');
    });

    test('a poster link names the clinic and the line', () {
      expect(
        posterUrl('https://docket.example', 'ikeja-family', 'C'),
        'https://docket.example/api/poster/ikeja-family?line=C',
      );
    });
  });

  test('a refusal shows the server message as written', () {
    expect(
      messageOf(
        DocketException(
          code: DocketErrorCode.validation,
          message: 'That link is taken. Try another.',
        ),
      ),
      'That link is taken. Try another.',
    );
    expect(messageOf(StateError('socket')), contains("couldn't be reached"));
  });
}
