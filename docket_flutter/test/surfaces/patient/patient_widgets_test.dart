import 'package:docket_flutter/shared/theme/theme.dart';
import 'package:docket_flutter/surfaces/patient/patient_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

Future<void> _pump(WidgetTester tester, Brightness brightness) =>
    tester.pumpWidget(
      MaterialApp(
        theme: docketTheme(brightness),
        home: Scaffold(
          body: Column(
            children: [
              PrimaryPill(
                label: 'Get alerts',
                icon: LucideIcons.bell,
                onPressed: () {},
              ),
              SecondaryPill(
                label: 'Leave line',
                icon: LucideIcons.logOut,
                onPressed: () {},
              ),
              InlineAction(
                label: 'Turn off alerts',
                icon: LucideIcons.bellOff,
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );

void main() {
  for (final brightness in Brightness.values) {
    testWidgets('icons take the label color, ${brightness.name}', (
      tester,
    ) async {
      await _pump(tester, brightness);
      for (final (icon, label) in [
        (LucideIcons.bell, 'Get alerts'),
        (LucideIcons.logOut, 'Leave line'),
        (LucideIcons.bellOff, 'Turn off alerts'),
      ]) {
        final iconColor = IconTheme.of(tester.element(find.byIcon(icon))).color;
        final textColor = DefaultTextStyle.of(
          tester.element(find.text(label)),
        ).style.color;
        expect(iconColor, textColor, reason: label);
        expect(tester.getSize(find.byIcon(icon)), const Size(20, 20));
      }
    });
  }

  testWidgets('buttons stay flat when pressed', (tester) async {
    await _pump(tester, Brightness.light);
    for (final label in ['Get alerts', 'Leave line', 'Turn off alerts']) {
      final before = tester.getRect(find.text(label));
      final gesture = await tester.startGesture(
        tester.getCenter(find.text(label)),
      );
      await tester.pump(const Duration(milliseconds: 200));
      final material = tester.widget<Material>(
        find
            .ancestor(of: find.text(label), matching: find.byType(Material))
            .first,
      );
      expect(material.elevation, 0, reason: label);
      expect(material.shadowColor, Colors.transparent, reason: label);
      expect(tester.getRect(find.text(label)), before, reason: label);
      await gesture.up();
      await tester.pump();
    }
  });

  testWidgets('a control icon is hidden from screen readers', (tester) async {
    await _pump(tester, Brightness.light);
    expect(find.bySemanticsLabel('Get alerts'), findsOneWidget);
  });
}
