import 'package:docket_flutter/surfaces/desk/desk_keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

KeyDownEvent _down(LogicalKeyboardKey key, PhysicalKeyboardKey physical) =>
    KeyDownEvent(
      physicalKey: physical,
      logicalKey: key,
      timeStamp: Duration.zero,
    );

void main() {
  group('deskCommandFor', () {
    test('maps Space, R, S, F and N', () {
      expect(
        deskCommandFor(
          _down(LogicalKeyboardKey.space, PhysicalKeyboardKey.space),
          modified: false,
        ),
        DeskCommand.callNext,
      );
      expect(
        deskCommandFor(
          _down(LogicalKeyboardKey.keyR, PhysicalKeyboardKey.keyR),
          modified: false,
        ),
        DeskCommand.recall,
      );
      expect(
        deskCommandFor(
          _down(LogicalKeyboardKey.keyS, PhysicalKeyboardKey.keyS),
          modified: false,
        ),
        DeskCommand.startService,
      );
      expect(
        deskCommandFor(
          _down(LogicalKeyboardKey.keyF, PhysicalKeyboardKey.keyF),
          modified: false,
        ),
        DeskCommand.finish,
      );
      expect(
        deskCommandFor(
          _down(LogicalKeyboardKey.keyN, PhysicalKeyboardKey.keyN),
          modified: false,
        ),
        DeskCommand.noShow,
      );
    });

    test('leaves other keys, key releases and modified keys alone', () {
      expect(
        deskCommandFor(
          _down(LogicalKeyboardKey.keyA, PhysicalKeyboardKey.keyA),
          modified: false,
        ),
        isNull,
      );
      expect(
        deskCommandFor(
          const KeyUpEvent(
            physicalKey: PhysicalKeyboardKey.space,
            logicalKey: LogicalKeyboardKey.space,
            timeStamp: Duration.zero,
          ),
          modified: false,
        ),
        isNull,
      );
      expect(
        deskCommandFor(
          _down(LogicalKeyboardKey.keyR, PhysicalKeyboardKey.keyR),
          modified: true,
        ),
        isNull,
      );
    });
  });

  group('DeskKeyboard', () {
    late List<DeskCommand> heard;
    late int buttonPresses;

    Future<void> pump(WidgetTester tester) {
      heard = [];
      buttonPresses = 0;
      return tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DeskKeyboard(
              onCommand: heard.add,
              child: Column(
                children: [
                  const TextField(key: Key('name')),
                  TextButton(
                    key: const Key('other'),
                    onPressed: () => buttonPresses++,
                    child: const Text('Add walk-in'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    testWidgets('runs each shortcut from the desk', (tester) async {
      await pump(tester);
      for (final key in [
        LogicalKeyboardKey.space,
        LogicalKeyboardKey.keyR,
        LogicalKeyboardKey.keyS,
        LogicalKeyboardKey.keyF,
        LogicalKeyboardKey.keyN,
      ]) {
        await tester.sendKeyEvent(key);
      }
      expect(heard, [
        DeskCommand.callNext,
        DeskCommand.recall,
        DeskCommand.startService,
        DeskCommand.finish,
        DeskCommand.noShow,
      ]);
    });

    testWidgets('never fires while a text field has focus', (tester) async {
      await pump(tester);
      await tester.tap(find.byKey(const Key('name')));
      await tester.pump();
      for (final key in [
        LogicalKeyboardKey.space,
        LogicalKeyboardKey.keyR,
        LogicalKeyboardKey.keyS,
        LogicalKeyboardKey.keyF,
        LogicalKeyboardKey.keyN,
      ]) {
        await tester.sendKeyEvent(key);
      }
      expect(heard, isEmpty);
    });

    testWidgets('a focused button keeps Space, the letters still work', (
      tester,
    ) async {
      await pump(tester);
      Focus.of(tester.element(find.text('Add walk-in'))).requestFocus();
      await tester.pump();

      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      await tester.pump();
      expect(buttonPresses, 1);
      expect(heard, isEmpty);

      await tester.sendKeyEvent(LogicalKeyboardKey.keyF);
      expect(heard, [DeskCommand.finish]);
    });
  });
}
