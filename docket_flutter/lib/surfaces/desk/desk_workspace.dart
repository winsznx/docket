import 'dart:async';

import 'package:docket_client/docket_client.dart' hide Notification;
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../shared/strings.dart';
import '../../shared/theme/tokens.dart';
import '../../shared/widgets/progress_line.dart';
import 'desk_access.dart';
import 'desk_board.dart';
import 'desk_controller.dart';
import 'desk_keys.dart';
import 'widgets/call_next_button.dart';
import 'widgets/desk_parts.dart';
import 'widgets/desk_sheets.dart';
import 'widgets/desk_top_bar.dart';
import 'widgets/now_serving.dart';
import 'widgets/queue_list.dart';
import 'widgets/room_controls.dart';
import 'widgets/sandbox_panel.dart';

/// Leaving the desk: the sandbox, a clinic switch or a sign-out.
class DeskSessionAction {
  const DeskSessionAction(this.label, this.icon, this.run);

  final String label;
  final IconData icon;
  final VoidCallback run;
}

/// The working desk for one clinic, once the entry knows who's at it.
class DeskWorkspace extends StatefulWidget {
  const DeskWorkspace({
    super.key,
    required this.access,
    required this.session,
    required this.fatalAction,
  });

  final DeskAccess access;

  /// Leave the sandbox, switch clinic or sign out, for the top bar. They
  /// wait while actions are still unsynced, so nothing saved here is lost.
  final List<DeskSessionAction> session;

  /// What to offer when the server refuses this desk for good.
  final Widget fatalAction;

  @override
  State<DeskWorkspace> createState() => _DeskWorkspaceState();
}

class _DeskWorkspaceState extends State<DeskWorkspace> {
  late final DeskController _desk = DeskController(widget.access);
  StreamSubscription<void>? _rejections;
  DeskConnection? _lastConnection;
  String? _lastServing;
  bool _drawerWanted = false;

  static const _wide = 1200.0;
  static const _medium = 840.0;

  /// Narrow or short screens get one scrolling page instead of columns.
  static bool _onePage(BuildContext context, BoxConstraints c) =>
      _layoutWidth(context, c) < _medium || c.maxHeight < _columnsMinHeight;

  static const _columnsMinHeight = 560.0;

  /// The width the layout plans for: the real width divided by the text
  /// scale, so large text gets the roomier one-column layout instead of
  /// squeezed columns.
  static double _layoutWidth(BuildContext context, BoxConstraints c) {
    final scale = MediaQuery.textScalerOf(context).scale(1);
    return c.maxWidth / (scale < 1 ? 1 : scale);
  }

  @override
  void initState() {
    super.initState();
    _desk
      ..addListener(_announce)
      ..addListener(_openCorrectionsIfWanted);
    _rejections = _desk.rejections.listen((_) {
      _drawerWanted = true;
      _openCorrectionsIfWanted();
    });
    unawaited(_desk.open());
  }

  @override
  void dispose() {
    unawaited(_rejections?.cancel());
    _desk
      ..removeListener(_announce)
      ..removeListener(_openCorrectionsIfWanted);
    _desk.dispose();
    super.dispose();
  }

  /// Screen readers hear the connection change and each new call.
  void _announce() {
    if (!mounted || !_desk.opened) return;
    final connection = _desk.connection;
    final serving = _desk.board?.nowServing;
    final servingKey = serving == null ? null : '${serving.id}${serving.state}';
    String? message;
    if (_lastConnection != null && connection != _lastConnection) {
      message = switch (connection) {
        DeskConnection.offline => DeskStrings.wentOffline,
        DeskConnection.syncing => DeskStrings.syncing(_desk.pendingCount),
        DeskConnection.online => DeskStrings.backOnline,
      };
    } else if (servingKey != _lastServing && serving != null) {
      message = DeskStrings.ticketSemantics(
        serving.label,
        serving.displayName,
        stateText(serving.state),
      );
    }
    _lastConnection = connection;
    _lastServing = servingKey;
    if (message != null) {
      unawaited(
        SemanticsService.sendAnnouncement(
          View.of(context),
          message,
          TextDirection.ltr,
        ),
      );
    }
  }

  /// PRD 5.4: the drawer opens by itself once a sync brings a rejection,
  /// unless the person is in a sheet, where the top bar's count waits.
  void _openCorrectionsIfWanted() {
    if (!_drawerWanted || !mounted || _desk.corrections.isEmpty) return;
    _drawerWanted = false;
    if (!(ModalRoute.of(context)?.isCurrent ?? false)) return;
    unawaited(_openCorrections());
  }

  Future<void> _openCorrections() => showCorrections(
    context,
    _desk,
    onCallNext: _desk.callNext,
    onAdd: ({required priority}) => _add(priority: priority),
  );

  void _add({required bool priority}) =>
      unawaited(showAddPatientSheet(context, _desk, priority: priority));

  void _command(DeskCommand command) {
    final serving = _desk.board?.nowServing;
    final state = serving?.state;
    switch (command) {
      case DeskCommand.callNext:
        unawaited(_desk.callNext());
      case DeskCommand.recall when state == TicketState.called:
        unawaited(_desk.recall(serving!.id));
      case DeskCommand.startService
          when state == TicketState.called || state == TicketState.confirmed:
        unawaited(_desk.startService(serving!.id));
      case DeskCommand.finish when state == TicketState.inService:
        unawaited(_desk.finish(serving!.id));
      case DeskCommand.noShow
          when state == TicketState.called || state == TicketState.confirmed:
        unawaited(_desk.noShow(serving!.id));
      default:
        break;
    }
  }

  List<Widget> _sessionPills({required bool guarded}) => [
    for (final action in widget.session)
      TonalPill(
        label: action.label,
        icon: action.icon,
        onPressed: () {
          if (guarded && _desk.pendingCount > 0) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text(DeskStrings.leaveBlocked)),
            );
            return;
          }
          action.run();
        },
      ),
  ];

  Future<void> _closeDay() async {
    if (await confirmCloseDay(context)) await _desk.closeDay();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: ListenableBuilder(
        listenable: _desk,
        builder: (context, _) => _body(context),
      ),
    ),
  );

  Widget _body(BuildContext context) {
    final text = Theme.of(context).textTheme;
    if (_desk.fatal case final fatal?) {
      return _Message(
        title: fatal.message,
        actions: [widget.fatalAction, ..._sessionPills(guarded: false)],
      );
    }
    if (_desk.openError != null) {
      return _Message(
        title: DeskStrings.storageError,
        actions: _sessionPills(guarded: false),
      );
    }
    final board = _desk.board;
    if (board == null) {
      if (_desk.opened && _desk.connection == DeskConnection.offline) {
        return _Message(
          title: DeskStrings.offlineNoDesk,
          actions: _sessionPills(guarded: false),
        );
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const DocketProgressLine(semanticsLabel: DeskStrings.openingDesk),
          Padding(
            padding: const EdgeInsets.all(DocketSpace.s24),
            child: Text(DeskStrings.openingDesk, style: text.bodyLarge),
          ),
        ],
      );
    }

    final topBar = DeskTopBar(
      clinicName: board.view.clinicName,
      roomName: board.room?.name,
      day: board.day,
      connection: _desk.connection,
      pending: _desk.pendingCount,
      corrections: _desk.corrections.length,
      onChangeRoom: () => unawaited(showRoomPicker(context, _desk)),
      onCorrections: () => unawaited(_openCorrections()),
      onCloseDay: board.day == DayState.closed ? null : _closeDay,
      session: _sessionPills(guarded: true),
    );
    final band = ConnectionBand(
      connection: _desk.connection,
      pending: _desk.pendingCount,
    );

    return DeskKeyboard(
      onCommand: _command,
      child: LayoutBuilder(
        builder: (context, c) {
          // On a phone the bar scrolls away with the page, so the ticket and
          // Call next get the screen. The connection band always stays.
          final fixedBar = !_onePage(context, c) || board.room == null;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (fixedBar) topBar,
              band,
              Expanded(
                child: board.room == null
                    ? _RoomPicker(board: board, onPick: _desk.selectRoom)
                    : _layout(context, board, c, topBar: topBar),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _layout(
    BuildContext context,
    DeskBoard board,
    BoxConstraints c, {
    required Widget topBar,
  }) {
    final width = _layoutWidth(context, c);
    final sandbox = widget.access.sandbox;
    final serving = _serving(context, board, showHint: width >= _medium);
    final room = _roomSection(board);
    final queue = board.roomLine == null
        ? const SizedBox.shrink()
        : QueueList(line: board.roomLine!, actions: _rowActions(board));
    final panel = sandbox == null
        ? null
        : SandboxPanel(
            sandbox: sandbox,
            joinUrl: board.view.joinUrl,
            online: _desk.canSend,
            onAddDemo: _desk.addDemoWalkIns,
          );

    Widget column(List<Widget> children) => ListView(
      padding: const EdgeInsets.fromLTRB(
        DocketSpace.s24,
        DocketSpace.s16,
        DocketSpace.s24,
        DocketSpace.s48,
      ),
      children: children,
    );

    if (width >= _wide && panel != null) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 5, child: column([serving, _gap, room])),
          Expanded(flex: 4, child: column([queue])),
          SizedBox(width: 320, child: column([panel])),
        ],
      );
    }
    if (!_onePage(context, c)) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 5, child: column([serving, _gap, room])),
          Expanded(
            flex: 4,
            child: column([
              if (panel != null) ...[panel, _gap],
              queue,
            ]),
          ),
        ],
      );
    }
    const phoneGutter = EdgeInsets.symmetric(horizontal: DocketSpace.s16);
    return ListView(
      padding: const EdgeInsets.only(bottom: DocketSpace.s48),
      children: [
        topBar,
        for (final section in [
          serving,
          _gap,
          if (panel != null) ...[panel, _gap],
          queue,
          _gap,
          room,
        ])
          Padding(padding: phoneGutter, child: section),
      ],
    );
  }

  static const _gap = SizedBox(height: DocketSpace.s48);

  Widget _serving(
    BuildContext context,
    DeskBoard board, {
    required bool showHint,
  }) {
    final text = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        NowServing(
          board: board,
          actions: _roomActions,
          waitingToSync: _desk.connection != DeskConnection.online,
        ),
        const SizedBox(height: DocketSpace.s32),
        CallNextButton(block: board.callNextBlock, onPressed: _desk.callNext),
        if (showHint) ...[
          const SizedBox(height: DocketSpace.s8),
          Text(DeskStrings.shortcutsHint, style: text.bodySmall),
        ],
        const SizedBox(height: DocketSpace.s24),
        Wrap(
          spacing: DocketSpace.s12,
          runSpacing: DocketSpace.s12,
          children: [
            TonalPill(
              label: DeskStrings.addWalkIn,
              icon: LucideIcons.userPlus,
              onPressed: board.day == DayState.closed
                  ? null
                  : () => _add(priority: false),
            ),
            TonalPill(
              label: DeskStrings.addPriority,
              icon: LucideIcons.badgeAlert,
              onPressed: board.day == DayState.closed
                  ? null
                  : () => _add(priority: true),
            ),
          ],
        ),
      ],
    );
  }

  Widget _roomSection(DeskBoard board) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      RoomStateSwitch(
        room: board.room!,
        onChanged: (state) => unawaited(_desk.setRoomState(state)),
      ),
      _gap,
      OtherLines(lines: board.otherLines),
    ],
  );

  RoomTicketActions get _roomActions => RoomTicketActions(
    startService: (t) => unawaited(_desk.startService(t.id)),
    recall: (t) => unawaited(_desk.recall(t.id)),
    noShow: (t) => unawaited(_desk.noShow(t.id)),
    finish: (t) => unawaited(_desk.finish(t.id)),
    transfer: (t) => unawaited(showTransferSheet(context, _desk, t)),
  );

  QueueRowActions _rowActions(DeskBoard board) {
    final block = board.callNextBlock;
    return QueueRowActions(
      canCall: block == null,
      canLink: _desk.canSend,
      waitingToSync: _desk.connection != DeskConnection.online,
      call: (t) => unawaited(_desk.callSpecific(t.id)),
      remove: (t) => unawaited(showRemoveSheet(context, _desk, t)),
      showQr: (t) => unawaited(showTicketQrSheet(context, _desk, t)),
    );
  }
}

/// The room list as the page itself, for a device that hasn't picked one.
class _RoomPicker extends StatelessWidget {
  const _RoomPicker({required this.board, required this.onPick});

  final DeskBoard board;
  final ValueChanged<UuidValue> onPick;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return ListView(
      padding: const EdgeInsets.all(DocketSpace.s24),
      children: [
        Semantics(
          container: true,
          header: true,
          child: Text(DeskStrings.pickRoomTitle, style: text.headlineMedium),
        ),
        const SizedBox(height: DocketSpace.s8),
        Text(DeskStrings.pickRoomBody, style: text.bodyLarge),
        const SizedBox(height: DocketSpace.s24),
        for (final room in board.rooms) ...[
          Align(
            alignment: Alignment.centerLeft,
            child: TonalPill(
              label: DeskStrings.roomChoice(
                room.name,
                board.line(room.lineId)?.name ?? '',
              ),
              onPressed: () => onPick(room.id),
            ),
          ),
          const SizedBox(height: DocketSpace.s12),
        ],
      ],
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({required this.title, required this.actions});

  final String title;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(DocketSpace.s24),
    children: [
      Semantics(
        container: true,
        liveRegion: true,
        child: Text(title, style: Theme.of(context).textTheme.headlineMedium),
      ),
      const SizedBox(height: DocketSpace.s24),
      Wrap(
        spacing: DocketSpace.s12,
        runSpacing: DocketSpace.s12,
        children: actions,
      ),
    ],
  );
}
