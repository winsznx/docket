import 'package:docket_client/docket_client.dart';
import 'package:docket_flutter/shared/server_clock.dart';
import 'package:docket_flutter/shared/theme/theme.dart';
import 'package:docket_flutter/shared/theme/tokens.dart';
import 'package:docket_flutter/surfaces/patient/ticket_copy.dart';
import 'package:docket_flutter/surfaces/patient/ticket_face.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'patient_view_fixture.dart';

final _now = DateTime.utc(2026, 10, 14, 9, 42, 3);

/// Lays the ticket out the way the ticket screen does: filling the space
/// above the actions, scrolling once its words need more room.
Future<void> _pump(
  WidgetTester tester,
  PatientView view, {
  double width = 390,
  double height = 844,
  double textScale = 1,
  Brightness brightness = Brightness.light,
  bool reduceMotion = true,
}) async {
  tester.view.physicalSize = Size(width, height);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final copy = ticketCopy(view, now: _now);
  final face = TicketFace(
    label: view.label,
    palette: ticketPalette(
      state: view.state,
      headsUpSent: view.headsUpSent,
      reslotted: view.reslotCount > 0,
      brightness: brightness,
    ),
    width: width - 2 * DocketSpace.s16,
    where: '${view.lineName} at ${view.clinicName}',
    copy: copy,
    countdownDigits: copy.countdown == null ? null : '2:41',
  );
  await tester.pumpWidget(
    MaterialApp(
      theme: docketTheme(brightness),
      home: Builder(
        builder: (context) => MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(textScale),
            disableAnimations: reduceMotion,
          ),
          child: Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding: const EdgeInsets.all(DocketSpace.s16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [Expanded(child: face)],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

PatientView _stateView(TicketState state) => patientView(
  state: state,
  position: state == TicketState.waiting ? 3 : null,
  roomName: 'Room 2',
  graceEndsAt: state == TicketState.called
      ? _now.add(const Duration(seconds: 161))
      : null,
  arrivalEndsAt: state == TicketState.confirmed
      ? _now.add(const Duration(minutes: 9))
      : null,
  transferredToToken: state == TicketState.transferred ? 'next' : null,
  transferredToLabel: state == TicketState.transferred ? 'L-007' : null,
  transferredToLineName: state == TicketState.transferred ? 'Lab' : null,
  closedReason: state == TicketState.removed ? 'Left the clinic' : null,
  reslotCount: state == TicketState.expired ? 1 : 0,
  lineMovedAt: _now.subtract(const Duration(seconds: 40)),
);

/// Loads the real faces, so the label is measured the way phones draw it.
Future<void> _loadFonts() async {
  final sans = FontLoader(DocketType.sans);
  for (final weight in ['Regular', 'Medium', 'Bold', 'ExtraBold']) {
    sans.addFont(
      rootBundle.load('assets/fonts/AtkinsonHyperlegibleNext-$weight.ttf'),
    );
  }
  final mono = FontLoader(DocketType.mono)
    ..addFont(
      rootBundle.load('assets/fonts/AtkinsonHyperlegibleMono-Regular.ttf'),
    )
    ..addFont(
      rootBundle.load('assets/fonts/AtkinsonHyperlegibleMono-Medium.ttf'),
    );
  await Future.wait([sans.load(), mono.load()]);
}

void main() {
  setUpAll(_loadFonts);
  setUp(() => ServerClock.instance.observe(_now));

  testWidgets('waiting shows the label, the place and the strip', (
    tester,
  ) async {
    await _pump(tester, _stateView(TicketState.waiting));
    expect(find.text('C-031'), findsOneWidget);
    expect(
      find.bySemanticsLabel("You're 3rd in line for Consultation."),
      findsOneWidget,
    );
    expect(find.text('About 14 min.'), findsOneWidget);
    expect(find.text('Line moved 40 s ago'), findsOneWidget);
    expect(find.text('Now serving C-028'), findsOneWidget);
    expect(find.text("You're 2nd when C-029 is called"), findsOneWidget);
    expect(find.text('Consultation at Grace Clinic'), findsOneWidget);
  });

  testWidgets('every state draws its headline without overflow', (
    tester,
  ) async {
    for (final state in TicketState.values) {
      final view = _stateView(state);
      await _pump(tester, view);
      final headline = ticketCopy(view, now: _now).headline;
      expect(
        find.bySemanticsLabel(headline),
        findsOneWidget,
        reason: state.name,
      );
      expect(tester.takeException(), isNull, reason: state.name);
    }
  });

  testWidgets('the countdown digits use the mono face', (tester) async {
    await _pump(tester, _stateView(TicketState.called));
    expect(find.text('Your turn. Go to Room 2.'), findsOneWidget);
    final countdown = tester.widget<RichText>(
      find.descendant(
        of: find.byType(CountdownText),
        matching: find.byType(RichText),
      ),
    );
    TextSpan? digits;
    countdown.text.visitChildren((span) {
      if (span is TextSpan && span.text == '2:41') digits = span;
      return digits == null;
    });
    expect(digits?.style?.fontFamily, DocketType.mono);
    expect(digits?.style?.fontFeatures, tabularFigures);
    expect(countdown.text.toPlainText(), '2:41 to confirm');
  });

  testWidgets('the label is as large as fits, from 96 to 128', (
    tester,
  ) async {
    await _pump(tester, _stateView(TicketState.waiting));
    final label = tester.widget<Text>(find.text('C-031'));
    final size = label.style!.fontSize!;
    expect(size, greaterThanOrEqualTo(DocketType.ticketLabelMin));
    expect(size, lessThanOrEqualTo(DocketType.ticketLabelMax));

    await _pump(tester, _stateView(TicketState.waiting), width: 1200);
    final wide = tester.widget<Text>(find.text('C-031'));
    expect(wide.style!.fontSize, DocketType.ticketLabelMax);
  });

  testWidgets('holds at 360 px and 200% text in every state', (tester) async {
    // In place, one state after another, as a live ticket changes.
    for (final state in TicketState.values) {
      await _pump(
        tester,
        _stateView(state),
        width: 360,
        height: 800,
        textScale: 2,
      );
      expect(tester.takeException(), isNull, reason: state.name);
    }
  });

  testWidgets('large text grows the headline but never breaks a word', (
    tester,
  ) async {
    final view = patientView(
      state: TicketState.confirmed,
      position: null,
      roomName: 'Room 2',
      lineName: 'Consultation',
    );
    await _pump(tester, view, width: 360, height: 800, textScale: 2);
    final headline = tester.widget<Text>(find.text('Room 2 is expecting you'));
    final size = headline.textScaler!.scale(DocketType.headline);
    expect(size, greaterThan(DocketType.headline));
    expect(size, lessThan(DocketType.headline * 2));

    final painter = TextPainter(
      text: TextSpan(
        text: 'expecting',
        style: headline.style!.copyWith(fontSize: size),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    expect(painter.width, lessThanOrEqualTo(360 - 32 - 48));
    painter.dispose();
  });

  testWidgets('the rolling place is the same size as its sentence', (
    tester,
  ) async {
    await _pump(tester, patientView(), width: 360, height: 800, textScale: 2);
    final sentence = tester.firstWidget<RichText>(
      find.byWidgetPredicate(
        (w) => w is RichText && w.text.toPlainText().startsWith("You're "),
      ),
    );
    final line =
        sentence.textScaler.scale(DocketType.headline) *
        DocketType.headingLeading;
    expect(tester.getRect(find.text('3rd')).height, closeTo(line, 2));
  });

  testWidgets('normal text keeps the headline at its size', (tester) async {
    await _pump(tester, _stateView(TicketState.inService));
    final headline = tester.widget<Text>(
      find.text("You're being seen in Room 2"),
    );
    expect(
      headline.textScaler!.scale(DocketType.headline),
      DocketType.headline,
    );
  });

  testWidgets('the ticket fills the screen above the actions', (
    tester,
  ) async {
    await _pump(tester, _stateView(TicketState.waiting));
    expect(tester.takeException(), isNull);
    expect(tester.getSize(find.byType(TicketFace)).height, 844 - 32);
  });

  testWidgets('the ticket grows when a state needs more words', (
    tester,
  ) async {
    await _pump(
      tester,
      _stateView(TicketState.served),
      width: 360,
      height: 640,
      textScale: 2,
    );
    final short = tester.getSize(find.byType(TicketFace)).height;
    await _pump(
      tester,
      patientView(reslotCount: 1, lineMovedAt: _now),
      width: 360,
      height: 640,
      textScale: 2,
    );
    expect(tester.takeException(), isNull);
    expect(tester.getSize(find.byType(TicketFace)).height, greaterThan(short));
  });

  testWidgets('dark mode lifts the waiting ticket off night', (tester) async {
    await _pump(
      tester,
      _stateView(TicketState.waiting),
      brightness: Brightness.dark,
    );
    final label = tester.widget<Text>(find.text('C-031'));
    expect(label.style?.color, DocketColors.daylight);
  });

  testWidgets('a re-slot draws the headline in missed', (tester) async {
    await _pump(tester, patientView(reslotCount: 1));
    final headline = tester.widget<Text>(find.text('You missed your call'));
    expect(headline.style?.color, DocketColors.missed);
  });

  testWidgets('the position rolls to its new value', (tester) async {
    await _pump(tester, patientView(position: 3), reduceMotion: false);
    expect(find.text('3rd'), findsOneWidget);
    await _pump(tester, patientView(position: 2), reduceMotion: false);
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('3rd'), findsOneWidget);
    expect(find.text('2nd'), findsOneWidget);
    await tester.pumpAndSettle();
    expect(find.text('3rd'), findsNothing);
    expect(find.text('2nd'), findsOneWidget);
  });

  testWidgets('under reduced motion the position changes at once', (
    tester,
  ) async {
    await _pump(tester, patientView(position: 3));
    await _pump(tester, patientView(position: 2));
    await tester.pump();
    expect(find.text('3rd'), findsNothing);
    expect(find.text('2nd'), findsOneWidget);
  });
}
