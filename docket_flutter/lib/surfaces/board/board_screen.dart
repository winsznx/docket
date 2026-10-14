import 'dart:convert';
import 'dart:js_interop';

import 'package:docket_client/docket_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:web/web.dart' as web;

import '../../client.dart';
import '../../shared/strings.dart';
import '../../shared/theme/theme.dart';
import '../../shared/theme/tokens.dart';
import 'announcer.dart';
import 'board_controller.dart';
import 'board_layout.dart';
import 'local_board_source.dart';
import 'web_announcer.dart';

/// The waiting-room board at `/b/<token>`: always night, readable across a
/// room, and it calls each number aloud (PRD 17.4, DESIGN.md 5.5).
class BoardScreen extends StatefulWidget {
  const BoardScreen({super.key, required this.token});

  final String token;

  @override
  State<BoardScreen> createState() => _BoardScreenState();
}

class _BoardScreenState extends State<BoardScreen> {
  late final Announcer _announcer = WebAnnouncer();
  late final BoardController _board = BoardController(
    snapshot: () => client.board.get(widget.token),
    watch: () => client.board.watch(widget.token),
    local: DeskDatabaseBoardSource(),
    announcer: _announcer,
    cached: _BoardCache.read(widget.token),
    onServerView: (view) => _BoardCache.write(widget.token, view),
    onCall: _announceToScreenReader,
  );
  late final JSFunction _onOnline = ((web.Event _) {
    _board.browserOnline();
  }).toJS;
  late final JSFunction _onOffline = ((web.Event _) {
    _board.browserOffline();
  }).toJS;
  bool _unlocked = false;

  @override
  void initState() {
    super.initState();
    _board.start();
    web.window.addEventListener('online', _onOnline);
    web.window.addEventListener('offline', _onOffline);
    if (!web.window.navigator.onLine) _board.browserOffline();
  }

  @override
  void dispose() {
    web.window.removeEventListener('online', _onOnline);
    web.window.removeEventListener('offline', _onOffline);
    _board.dispose();
    _announcer.dispose();
    super.dispose();
  }

  void _announceToScreenReader(BoardCall call) {
    if (!mounted) return;
    SemanticsService.sendAnnouncement(
      View.of(context),
      BoardStrings.callAnnouncement(call.label, call.roomName),
      TextDirection.ltr,
    );
  }

  Future<void> _unlock() async {
    if (_unlocked) return;
    setState(() => _unlocked = true);
    await _announcer.unlock();
  }

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (_unlocked || event is! KeyDownEvent) return KeyEventResult.ignored;
    _unlock();
    return KeyEventResult.handled;
  }

  void _openSettings() {
    // The board is always night, so the sheet is too, whatever the
    // system's color scheme.
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: DocketColors.register,
      builder: (context) => Theme(
        data: docketTheme(Brightness.dark),
        child: _BoardSettings(board: _board, announcer: _announcer),
      ),
    );
  }

  String? _status() {
    if (_board.isLocal || !_board.isStale) return null;
    final last = _board.lastServerUpdate;
    if (last == null) return BoardStrings.reconnecting;
    return BoardStrings.reconnectingSince(_clock(last.toLocal()));
  }

  static String _clock(DateTime t) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(t.hour)}:${two(t.minute)}:${two(t.second)}';
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: docketTheme(Brightness.dark),
      child: MediaQuery.withNoTextScaling(
        child: Scaffold(
          backgroundColor: DocketColors.night,
          body: Focus(
            autofocus: true,
            onKeyEvent: _onKey,
            child: ListenableBuilder(
              listenable: _board,
              builder: (context, _) => _body(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _body() {
    final fatal = _board.fatalMessage;
    if (fatal != null) return BoardMessage(message: fatal);
    final view = _board.view;
    if (view == null) return const BoardLoading();
    return Stack(
      fit: StackFit.expand,
      children: [
        BoardLayout(
          view: view,
          flashes: _board.flashes,
          isLocal: _board.isLocal,
          status: _status(),
          notice: _unlocked ? null : BoardStrings.tapToTurnOn,
          onOpenSettings: _openSettings,
        ),
        if (!_unlocked) _UnlockLayer(onUnlock: _unlock),
      ],
    );
  }
}

/// Browsers only play sound after a gesture, so until the first tap, or a
/// key press on a TV remote, the whole screen is one button that turns
/// announcements on. The band that asks for it is drawn by [BoardLayout].
class _UnlockLayer extends StatelessWidget {
  const _UnlockLayer({required this.onUnlock});

  final VoidCallback onUnlock;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      button: true,
      label: BoardStrings.tapToTurnOn,
      onTap: onUnlock,
      child: ExcludeSemantics(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onUnlock,
          child: const SizedBox.expand(),
        ),
      ),
    );
  }
}

class _BoardSettings extends StatelessWidget {
  const _BoardSettings({required this.board, required this.announcer});

  final BoardController board;
  final Announcer announcer;

  bool get _fullScreen => web.document.fullscreenElement != null;

  Future<void> _toggleFullScreen() async {
    if (_fullScreen) {
      await web.document.exitFullscreen().toDart;
    } else {
      await web.document.documentElement?.requestFullscreen().toDart;
    }
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          DocketSpace.s24,
          DocketSpace.s32,
          DocketSpace.s24,
          DocketSpace.s24,
        ),
        child: Align(
          alignment: Alignment.topLeft,
          heightFactor: 1,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: ListenableBuilder(
              listenable: Listenable.merge([board, announcer.voice]),
              builder: (context, _) => Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Semantics(
                    header: true,
                    child: Text(
                      BoardStrings.settingsTitle,
                      style: text.headlineSmall,
                    ),
                  ),
                  if (board.isLocal) ...[
                    const SizedBox(height: DocketSpace.s12),
                    Text(
                      BoardStrings.localModeHint,
                      style: text.bodyMedium?.copyWith(
                        color: DocketColors.nightSoft,
                      ),
                    ),
                  ],
                  const SizedBox(height: DocketSpace.s24),
                  switch (announcer.voice.value) {
                    VoiceSupport.available => _Toggle(
                      label: BoardStrings.sayAloud,
                      icon: board.speak
                          ? LucideIcons.volume2
                          : LucideIcons.volumeX,
                      value: board.speak,
                      onChanged: board.setSpeak,
                    ),
                    VoiceSupport.checking => Text(
                      BoardStrings.voiceChecking,
                      style: text.bodyMedium,
                    ),
                    VoiceSupport.unavailable => Semantics(
                      container: true,
                      liveRegion: true,
                      child: Text(
                        BoardStrings.voiceUnavailable,
                        style: text.bodyMedium,
                      ),
                    ),
                  },
                  const SizedBox(height: DocketSpace.s12),
                  _Toggle(
                    label: BoardStrings.playChime,
                    icon: board.chime ? LucideIcons.bell : LucideIcons.bellOff,
                    value: board.chime,
                    onChanged: board.setChime,
                  ),
                  const SizedBox(height: DocketSpace.s24),
                  Wrap(
                    spacing: DocketSpace.s12,
                    runSpacing: DocketSpace.s12,
                    children: [
                      FilledButton.icon(
                        onPressed: () async {
                          await announcer.unlock();
                          board.testSound();
                        },
                        style: _flat(context, filled: true),
                        icon: const Icon(LucideIcons.volume2),
                        label: const Text(BoardStrings.testSound),
                      ),
                      TextButton.icon(
                        onPressed: () async {
                          await _toggleFullScreen();
                          if (context.mounted) Navigator.of(context).pop();
                        },
                        style: _flat(context),
                        icon: Icon(
                          _fullScreen
                              ? LucideIcons.minimize
                              : LucideIcons.maximize,
                        ),
                        label: Text(
                          _fullScreen
                              ? BoardStrings.leaveFullScreen
                              : BoardStrings.fullScreen,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () => Navigator.of(context).pop(),
                        style: _flat(context),
                        icon: const Icon(LucideIcons.check),
                        label: const Text(BoardStrings.done),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Flat buttons whose icon takes the label's color, at the control icon
/// size.
ButtonStyle _flat(BuildContext context, {bool filled = false}) {
  final theme = Theme.of(context);
  final base = filled
      ? theme.filledButtonTheme.style
      : theme.textButtonTheme.style;
  return ButtonStyle(
    iconColor: base?.foregroundColor,
    iconSize: const WidgetStatePropertyAll(_iconSize),
    elevation: const WidgetStatePropertyAll(0),
    shadowColor: const WidgetStatePropertyAll(Colors.transparent),
  );
}

const _iconSize = 20.0;

class _Toggle extends StatelessWidget {
  const _Toggle({
    required this.label,
    required this.icon,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final IconData icon;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return MergeSemantics(
      child: InkWell(
        onTap: () => onChanged(!value),
        borderRadius: BorderRadius.circular(DocketRadius.input),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: DocketSpace.s48),
          child: Row(
            children: [
              Icon(
                icon,
                size: _iconSize,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
              const SizedBox(width: DocketSpace.s12),
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              const SizedBox(width: DocketSpace.s16),
              Switch(
                value: value,
                onChanged: onChanged,
                thumbColor: const WidgetStateProperty.fromMap({
                  WidgetState.selected: DocketColors.register,
                  WidgetState.any: DocketColors.nightSoft,
                }),
                trackColor: const WidgetStateProperty.fromMap({
                  WidgetState.selected: DocketColors.daylight,
                  WidgetState.any: DocketColors.registerLift,
                }),
                trackOutlineColor: const WidgetStatePropertyAll(
                  Colors.transparent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The last server view, kept in this browser so a board that reloads
/// during an outage still has its rooms and can switch to local mode. Only a
/// convenience: the board works the same without it.
abstract final class _BoardCache {
  static String _key(String token) =>
      'docket.board.${token.length > 16 ? token.substring(0, 16) : token}';

  static BoardView? read(String token) {
    try {
      final raw = web.window.localStorage.getItem(_key(token));
      if (raw == null) return null;
      return BoardView.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } on Object catch (error) {
      debugPrint('Board cache unreadable: $error');
      return null;
    }
  }

  static void write(String token, BoardView view) {
    try {
      web.window.localStorage.setItem(_key(token), jsonEncode(view.toJson()));
    } on Object catch (error) {
      debugPrint('Board cache not saved: $error');
    }
  }
}
