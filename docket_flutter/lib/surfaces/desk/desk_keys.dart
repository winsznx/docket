import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// What a desk keyboard shortcut does (PRD 17.3).
enum DeskCommand { callNext, recall, startService, finish, noShow }

/// Space calls next, R recalls, S starts service, F finishes and N marks a
/// no-show. Keys held with Control, Command or Alt stay with the browser, so
/// a reload or a copy never turns into a desk action.
DeskCommand? deskCommandFor(KeyEvent event, {required bool modified}) {
  if (event is! KeyDownEvent || modified) return null;
  final key = event.logicalKey;
  if (key == LogicalKeyboardKey.space) return DeskCommand.callNext;
  if (key == LogicalKeyboardKey.keyR) return DeskCommand.recall;
  if (key == LogicalKeyboardKey.keyS) return DeskCommand.startService;
  if (key == LogicalKeyboardKey.keyF) return DeskCommand.finish;
  if (key == LogicalKeyboardKey.keyN) return DeskCommand.noShow;
  return null;
}

/// Catches the desk shortcuts for everything inside it.
///
/// Nothing fires while a text field has focus. Space only calls next when no
/// other control has keyboard focus, so a focused button still activates
/// with Space the way every button does. The letters work wherever focus is
/// on the desk.
class DeskKeyboard extends StatefulWidget {
  const DeskKeyboard({super.key, required this.onCommand, required this.child});

  final void Function(DeskCommand command) onCommand;
  final Widget child;

  @override
  State<DeskKeyboard> createState() => _DeskKeyboardState();
}

class _DeskKeyboardState extends State<DeskKeyboard> {
  final _node = FocusNode(debugLabel: 'desk shortcuts');

  @override
  void dispose() {
    _node.dispose();
    super.dispose();
  }

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    final keyboard = HardwareKeyboard.instance;
    final command = deskCommandFor(
      event,
      modified:
          keyboard.isControlPressed ||
          keyboard.isMetaPressed ||
          keyboard.isAltPressed,
    );
    if (command == null) return KeyEventResult.ignored;
    final focused = FocusManager.instance.primaryFocus;
    final typing =
        focused?.context?.findAncestorWidgetOfExactType<EditableText>() != null;
    if (typing) return KeyEventResult.ignored;
    if (command == DeskCommand.callNext && focused != _node) {
      return KeyEventResult.ignored;
    }
    widget.onCommand(command);
    return KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context) => Focus(
    focusNode: _node,
    autofocus: true,
    onKeyEvent: _onKey,
    child: widget.child,
  );
}
