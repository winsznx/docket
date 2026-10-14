import 'package:docket_client/docket_client.dart';
import 'package:docket_flutter/shared/theme/theme.dart';
import 'package:docket_flutter/shared/theme/ticket_shape.dart';
import 'package:docket_flutter/shared/theme/tokens.dart';
import 'package:docket_flutter/shared/widgets/progress_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const _light = Brightness.light;
const _dark = Brightness.dark;

void main() {
  group('ticketPalette', () {
    final rows = [
      (
        row: 'waiting',
        state: TicketState.waiting,
        headsUp: false,
        reslotted: false,
        light: (DocketColors.daylight, DocketColors.register),
        dark: (DocketColors.registerLift, DocketColors.daylight),
      ),
      (
        row: 'waiting with heads-up sent',
        state: TicketState.waiting,
        headsUp: true,
        reslotted: false,
        light: (DocketColors.danfo, DocketColors.register),
        dark: (DocketColors.danfo, DocketColors.register),
      ),
      (
        row: 'called',
        state: TicketState.called,
        headsUp: false,
        reslotted: false,
        light: (DocketColors.go, DocketColors.daylight),
        dark: (DocketColors.go, DocketColors.daylight),
      ),
      (
        row: 'confirmed',
        state: TicketState.confirmed,
        headsUp: false,
        reslotted: false,
        light: (DocketColors.register, DocketColors.daylight),
        dark: (DocketColors.registerLift, DocketColors.daylight),
      ),
      (
        row: 'inService',
        state: TicketState.inService,
        headsUp: false,
        reslotted: false,
        light: (DocketColors.wash, DocketColors.register),
        dark: (DocketColors.registerLift, DocketColors.daylight),
      ),
      (
        row: 'served',
        state: TicketState.served,
        headsUp: false,
        reslotted: false,
        light: (DocketColors.daylight, DocketColors.register),
        dark: (DocketColors.registerLift, DocketColors.daylight),
      ),
      (
        row: 'transferred',
        state: TicketState.transferred,
        headsUp: false,
        reslotted: false,
        light: (DocketColors.daylight, DocketColors.register),
        dark: (DocketColors.registerLift, DocketColors.daylight),
      ),
      (
        row: 'waiting after a re-slot',
        state: TicketState.waiting,
        headsUp: false,
        reslotted: true,
        light: (DocketColors.daylight, DocketColors.register),
        dark: (DocketColors.daylight, DocketColors.register),
      ),
      (
        row: 'expired',
        state: TicketState.expired,
        headsUp: false,
        reslotted: false,
        light: (DocketColors.missed, DocketColors.daylight),
        dark: (DocketColors.missed, DocketColors.daylight),
      ),
      for (final state in [
        TicketState.cancelled,
        TicketState.removed,
        TicketState.closed,
      ])
        (
          row: state.name,
          state: state,
          headsUp: false,
          reslotted: false,
          light: (DocketColors.wash, DocketColors.registerSoft),
          dark: (DocketColors.registerLift, DocketColors.nightSoft),
        ),
    ];

    for (final row in rows) {
      for (final (brightness, (field, text)) in [
        (_light, row.light),
        (_dark, row.dark),
      ]) {
        test('${row.row} in ${brightness.name} mode', () {
          final palette = ticketPalette(
            state: row.state,
            headsUpSent: row.headsUp,
            reslotted: row.reslotted,
            brightness: brightness,
          );

          expect(palette.field, field);
          expect(palette.text, text);
          expect(palette.opacity, 1);
        });
      }
    }

    test('a re-slot puts the headline in missed', () {
      for (final brightness in Brightness.values) {
        final palette = ticketPalette(
          state: TicketState.waiting,
          headsUpSent: false,
          reslotted: true,
          brightness: brightness,
        );
        expect(palette.headline, DocketColors.missed);
      }
    });

    test('every other headline uses the text color', () {
      final palette = ticketPalette(
        state: TicketState.called,
        headsUpSent: false,
        reslotted: false,
        brightness: _light,
      );
      expect(palette.headline, palette.text);
    });

    test('a heads-up after a re-slot shows danfo', () {
      final palette = ticketPalette(
        state: TicketState.waiting,
        headsUpSent: true,
        reslotted: true,
        brightness: _light,
      );
      expect(palette.field, DocketColors.danfo);
      expect(palette.headline, DocketColors.register);
    });

    test('a heads-up only colors a waiting ticket', () {
      final palette = ticketPalette(
        state: TicketState.called,
        headsUpSent: true,
        reslotted: false,
        brightness: _light,
      );
      expect(palette.field, DocketColors.go);
    });

    test('stale keeps the last field at 60% and the text unchanged', () {
      for (final state in TicketState.values) {
        for (final brightness in Brightness.values) {
          final live = ticketPalette(
            state: state,
            headsUpSent: false,
            reslotted: false,
            brightness: brightness,
          );
          final stale = ticketPalette(
            state: state,
            headsUpSent: false,
            reslotted: false,
            brightness: brightness,
            stale: true,
          );
          expect(stale.field, live.field);
          expect(stale.text, live.text);
          expect(stale.headline, live.headline);
          expect(stale.opacity, 0.6);
        }
      }
    });
  });

  group('docketTheme', () {
    test('is built from the tokens in both modes', () {
      final light = docketTheme(_light);
      final dark = docketTheme(_dark);

      expect(light.colorScheme.brightness, _light);
      expect(light.colorScheme.primary, DocketColors.register);
      expect(light.scaffoldBackgroundColor, DocketColors.daylight);
      expect(dark.colorScheme.brightness, _dark);
      expect(dark.scaffoldBackgroundColor, DocketColors.night);
      for (final theme in [light, dark]) {
        expect(theme.splashFactory, NoSplash.splashFactory);
        expect(theme.textTheme.bodyMedium?.fontFamily, DocketType.sans);
        expect(theme.textTheme.bodyMedium?.fontSize, DocketType.body);
        expect(theme.textTheme.headlineMedium?.fontSize, DocketType.headline);
        expect(theme.textTheme.bodySmall?.fontSize, DocketType.small);
        expect(
          theme.textTheme.displayLarge?.fontSize,
          DocketType.ticketLabelMax,
        );
        expect(theme.appBarTheme.elevation, 0);
        expect(theme.bottomSheetTheme.elevation, 0);
        expect(theme.dialogTheme.elevation, 0);
        expect(theme.cardTheme.elevation, 0);
      }
    });

    test('fills inputs with wash and rings focus in register', () {
      final input = docketTheme(_light).inputDecorationTheme;

      expect(input.filled, isTrue);
      expect(input.fillColor, DocketColors.wash);
      expect(input.enabledBorder?.borderSide, BorderSide.none);
      expect(
        input.focusedBorder,
        const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(DocketRadius.input)),
          borderSide: BorderSide(color: DocketColors.register, width: 2),
        ),
      );
    });

    testWidgets('renders pill buttons and an input without exceptions', (
      tester,
    ) async {
      for (final brightness in Brightness.values) {
        await tester.pumpWidget(
          MaterialApp(
            theme: docketTheme(brightness),
            home: Scaffold(
              body: Column(
                children: [
                  FilledButton(onPressed: () {}, child: const Text('Join')),
                  const FilledButton(onPressed: null, child: Text('Join')),
                  TextButton(onPressed: () {}, child: const Text('Leave')),
                  const TextField(),
                ],
              ),
            ),
          ),
        );
        await tester.tap(find.byType(TextField));
        await tester.pump();

        expect(tester.takeException(), isNull);
      }
    });
  });

  group('TicketShapeBorder', () {
    const shape = TicketShapeBorder(
      tearFraction: 0.6,
      perforationColor: DocketColors.wash,
    );
    const rect = Rect.fromLTWH(0, 0, 360, 500);

    test('cuts a notch into each side at the tear line', () {
      final path = shape.getOuterPath(rect);
      const tearY = 300.0;

      expect(path.contains(const Offset(180, 250)), isTrue);
      expect(path.contains(const Offset(4, tearY)), isFalse);
      expect(path.contains(const Offset(356, tearY)), isFalse);
      expect(path.contains(const Offset(4, tearY - 20)), isTrue);
      expect(path.contains(const Offset(1, 1)), isFalse);
    });

    test('keeps its geometry on rects smaller than the radii', () {
      for (final small in [
        const Rect.fromLTWH(0, 0, 20, 10),
        const Rect.fromLTWH(0, 0, 1, 1),
        Rect.zero,
      ]) {
        expect(() => shape.getOuterPath(small), returnsNormally);
      }
    });

    test('lerps between tickets', () {
      const hero = TicketShapeBorder(
        tearFraction: 0.6,
        perforationColor: DocketColors.wash,
        radius: DocketRadius.ticketHero,
      );
      final mid = shape.lerpTo(hero, 0.5)! as TicketShapeBorder;

      expect(mid.radius, (DocketRadius.ticket + DocketRadius.ticketHero) / 2);
    });

    testWidgets('paints as a decoration and a Material shape', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Column(
            children: [
              const SizedBox(
                width: 360,
                height: 200,
                child: DecoratedBox(
                  decoration: ShapeDecoration(
                    color: DocketColors.danfo,
                    shape: shape,
                    shadows: DocketShadows.ticket,
                  ),
                ),
              ),
              const Material(
                color: DocketColors.go,
                shape: shape,
                child: SizedBox(width: 200, height: 120),
              ),
            ],
          ),
        ),
      );

      expect(tester.takeException(), isNull);
    });
  });

  group('DocketTicket', () {
    Widget ticket({
      Color color = DocketColors.daylight,
      double tearFraction = 0.6,
      Widget top = const Text('C-031'),
      Widget bottom = const Text('Leave line'),
      bool disableAnimations = false,
      bool bounded = true,
    }) {
      final child = DocketTicket(
        top: top,
        bottom: bottom,
        color: color,
        tearFraction: tearFraction,
      );
      return MaterialApp(
        theme: docketTheme(_light),
        builder: (context, app) =>
            _withAnimations(context, app!, disabled: disableAnimations),
        home: Scaffold(
          body: bounded
              ? Center(child: SizedBox(width: 360, height: 500, child: child))
              : SingleChildScrollView(child: child),
        ),
      );
    }

    Color fieldColor(WidgetTester tester) {
      final box = tester.widget<DecoratedBox>(
        find.descendant(
          of: find.byType(DocketTicket),
          matching: find.byType(DecoratedBox),
        ),
      );
      return (box.decoration as ShapeDecoration).color!;
    }

    testWidgets('puts the tear at tearFraction of a bounded height', (
      tester,
    ) async {
      await tester.pumpWidget(ticket());

      expect(tester.takeException(), isNull);
      expect(find.text('C-031'), findsOneWidget);
      expect(find.text('Leave line'), findsOneWidget);
      final ticketTop = tester.getTopLeft(find.byType(DocketTicket)).dy;
      final bottomTop = tester.getTopLeft(find.text('Leave line')).dy;
      expect(bottomTop - ticketTop, closeTo(300, 0.01));
    });

    testWidgets('sizes itself to fit both halves when height is unbounded', (
      tester,
    ) async {
      await tester.pumpWidget(
        ticket(
          bounded: false,
          top: const SizedBox(height: 120),
          bottom: const SizedBox(height: 120),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(tester.getSize(find.byType(DocketTicket)).height, 300);
    });

    testWidgets('cross-fades its field over the ticket duration', (
      tester,
    ) async {
      await tester.pumpWidget(ticket());
      await tester.pumpWidget(ticket(color: DocketColors.go));
      await tester.pump(DocketMotion.ticket ~/ 2);

      final midway = fieldColor(tester);
      expect(midway, isNot(DocketColors.daylight));
      expect(midway, isNot(DocketColors.go));

      await tester.pump(DocketMotion.ticket);
      expect(fieldColor(tester), DocketColors.go);
    });

    testWidgets('mixes a stale field with the page so it stays opaque', (
      tester,
    ) async {
      final stale = DocketColors.go.withValues(alpha: 0.6);
      await tester.pumpWidget(ticket(color: stale));

      expect(
        fieldColor(tester),
        Color.alphaBlend(stale, DocketColors.daylight),
      );
      expect(fieldColor(tester).a, 1);
    });

    testWidgets('switches its field at once under reduced motion', (
      tester,
    ) async {
      await tester.pumpWidget(ticket(disableAnimations: true));
      await tester.pumpWidget(
        ticket(color: DocketColors.go, disableAnimations: true),
      );
      await tester.pump();

      expect(fieldColor(tester), DocketColors.go);
    });
  });

  group('DocketProgressLine', () {
    for (final disableAnimations in [false, true]) {
      testWidgets('runs with disableAnimations $disableAnimations', (
        tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: docketTheme(_light),
            builder: (context, app) =>
                _withAnimations(context, app!, disabled: disableAnimations),
            home: const Scaffold(body: DocketProgressLine()),
          ),
        );
        await tester.pump(DocketProgressLine.period ~/ 2);

        expect(tester.takeException(), isNull);
        expect(
          tester.getSize(find.byType(DocketProgressLine)).height,
          DocketProgressLine.thickness,
        );
        expect(tester.hasRunningAnimations, !disableAnimations);
      });
    }
  });
}

Widget _withAnimations(
  BuildContext context,
  Widget child, {
  required bool disabled,
}) => MediaQuery(
  data: MediaQuery.of(context).copyWith(disableAnimations: disabled),
  child: child,
);
