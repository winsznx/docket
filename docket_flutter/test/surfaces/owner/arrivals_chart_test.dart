import 'package:docket_flutter/shared/theme/theme.dart';
import 'package:docket_flutter/surfaces/owner/arrivals_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final counts = List<int>.filled(24, 0)
    ..[8] = 3
    ..[9] = 7
    ..[10] = 12
    ..[11] = 5;

  Future<void> pumpChart(
    WidgetTester tester, {
    double width = 720,
    Brightness brightness = Brightness.light,
    double textScale = 1,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: docketTheme(brightness),
        home: MediaQuery(
          data: MediaQueryData(textScaler: TextScaler.linear(textScale)),
          child: Scaffold(
            body: Align(
              alignment: Alignment.topLeft,
              child: SizedBox(
                width: width,
                child: ArrivalsChart(
                  counts: counts,
                  firstHour: 8,
                  lastHour: 17,
                  currentHour: 10,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('draws without errors at phone and desktop widths', (
    tester,
  ) async {
    for (final width in [328.0, 720.0]) {
      await pumpChart(tester, width: width);
      expect(tester.takeException(), isNull);
      expect(find.byType(CustomPaint), findsWidgets);
    }
    await pumpChart(tester, width: 328, textScale: 2);
    expect(tester.takeException(), isNull);
    await pumpChart(tester, brightness: Brightness.dark);
    expect(tester.takeException(), isNull);
  });

  testWidgets('screen readers get a table of the same numbers', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await pumpChart(tester);

    final table = tester.getSemantics(
      find.bySemanticsLabel('Arrivals by hour'),
    );
    expect(table.role, SemanticsRole.table);

    final rows = <SemanticsNode>[];
    table.visitChildren((child) {
      rows.add(child);
      return true;
    });
    expect(rows, hasLength(10), reason: 'One row per hour, 08:00 to 17:00.');
    expect(rows.every((r) => r.role == SemanticsRole.row), isTrue);

    List<String> cells(SemanticsNode row) {
      final labels = <String>[];
      row.visitChildren((cell) {
        expect(cell.role, SemanticsRole.cell);
        labels.add(cell.label);
        return true;
      });
      return labels;
    }

    expect(cells(rows[2]), ['10:00', '12 arrivals']);
    expect(cells(rows[0]), ['08:00', '3 arrivals']);
    expect(cells(rows[9]), ['17:00', '0 arrivals']);

    expect(
      find.bySemanticsLabel(RegExp('27 in all, busiest at 10:00 with 12')),
      findsOneWidget,
    );
    semantics.dispose();
  });
}
