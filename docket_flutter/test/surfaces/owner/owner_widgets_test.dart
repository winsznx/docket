import 'package:docket_flutter/shared/theme/theme.dart';
import 'package:docket_flutter/surfaces/owner/owner_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

void main() {
  Future<void> pumpAt360(
    WidgetTester tester,
    Widget child, {
    double textScale = 2,
    Brightness brightness = Brightness.light,
  }) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        theme: docketTheme(brightness),
        home: MediaQuery(
          data: MediaQueryData(
            size: const Size(360, 800),
            textScaler: TextScaler.linear(textScale),
          ),
          child: Scaffold(
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: child,
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('a field, a link and its buttons hold at 360 px and 200% text', (
    tester,
  ) async {
    // #given the owner console's building blocks on a narrow phone
    final controller = TextEditingController(text: '180');
    addTearDown(controller.dispose);
    await pumpAt360(
      tester,
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LabeledField(
            label: 'Time to confirm',
            explanation:
                "How long a called patient has to tap I'm coming. "
                '60 to 900 seconds.',
            controller: controller,
            width: 200,
            suffix: 'seconds',
            error: 'Time to confirm has to be between 60 and 900.',
          ),
          LinkBlock(
            title: 'The waiting-room board',
            url:
                'https://docket.serverpod.space/b/'
                '4FWXlyfxgtGpFgOUTVIK5ppGmH20qMTZAUtORQK29aA',
            onOpen: () {},
            note: 'Works once, until Fri 16 Oct, 20:26.',
          ),
          DocketButton(
            label: 'Rotate the board link',
            icon: LucideIcons.rotateCcw,
            onPressed: () {},
          ),
        ],
      ),
    );

    // #then nothing overflows
    expect(tester.takeException(), isNull);
  });

  testWidgets('a field takes its label as its name for screen readers', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    final controller = TextEditingController();
    addTearDown(controller.dispose);
    await pumpAt360(
      tester,
      LabeledField(label: 'Clinic name', controller: controller),
      textScale: 1,
    );
    expect(
      tester.getSemantics(find.byType(EditableText)).label,
      'Clinic name',
    );
    semantics.dispose();
  });

  testWidgets('an icon in a button takes the label color, at size 20', (
    tester,
  ) async {
    for (final brightness in Brightness.values) {
      await pumpAt360(
        tester,
        DocketButton(
          label: 'Download CSV',
          icon: LucideIcons.download,
          onPressed: () {},
        ),
        textScale: 1,
        brightness: brightness,
      );
      final icon = tester.widget<RichText>(
        find.descendant(
          of: find.byType(Icon),
          matching: find.byType(RichText),
        ),
      );
      final label = tester.widget<RichText>(
        find.descendant(
          of: find.text('Download CSV'),
          matching: find.byType(RichText),
        ),
      );
      expect(icon.text.style?.color, label.text.style?.color);
      expect(icon.text.style?.fontSize, controlIconSize);
    }
  });
}
