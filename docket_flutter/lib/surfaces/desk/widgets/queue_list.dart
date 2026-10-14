import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../shared/strings.dart';
import '../../../shared/theme/theme.dart';
import '../../../shared/theme/tokens.dart';
import '../desk_board.dart';
import 'desk_parts.dart';

/// What the desk can do from a queue row's menu.
class QueueRowActions {
  const QueueRowActions({
    required this.canCall,
    required this.canLink,
    required this.waitingToSync,
    required this.call,
    required this.remove,
    required this.showQr,
  });

  final bool canCall;

  /// Unsynced rows are marked only while the server can't be reached.
  final bool waitingToSync;

  /// A QR needs the server, so it waits for a connection.
  final bool canLink;

  final void Function(DeskTicket ticket) call;
  final void Function(DeskTicket ticket) remove;
  final void Function(DeskTicket ticket) showQr;
}

/// The room's line in call order, as tall rows separated by space
/// (DESIGN 5.4).
class QueueList extends StatelessWidget {
  const QueueList({super.key, required this.line, required this.actions});

  final DeskLine line;
  final QueueRowActions actions;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DeskHeading(
          DeskStrings.queueTitle(line.name),
          trailing: DeskStrings.waitingCount(line.waiting.length),
        ),
        const SizedBox(height: DocketSpace.s12),
        if (line.waiting.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: DocketSpace.s16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(DeskStrings.queueEmpty, style: text.bodyLarge),
                const SizedBox(height: DocketSpace.s8),
                Text(DeskStrings.queueEmptyBody, style: text.bodyMedium),
              ],
            ),
          )
        else
          for (final (i, t) in line.waiting.indexed) ...[
            if (i > 0) const SizedBox(height: DocketSpace.s8),
            _QueueRow(ticket: t, actions: actions),
          ],
      ],
    );
  }
}

class _QueueRow extends StatefulWidget {
  const _QueueRow({required this.ticket, required this.actions});

  final DeskTicket ticket;
  final QueueRowActions actions;

  @override
  State<_QueueRow> createState() => _QueueRowState();
}

class _QueueRowState extends State<_QueueRow> {
  /// Below this width, at normal text size, the label sits above the name.
  static const double _sideBySideFrom = 300;

  final _menu = MenuController();

  void _toggle() => _menu.isOpen ? _menu.close() : _menu.open();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = widget.ticket;
    final a = widget.actions;
    final chips = [
      if (t.isDemo) DeskStrings.chipDemo,
      if (t.priorityReason case final reason?)
        DeskStrings.priorityReason(reason),
      if (t.reslotted) DeskStrings.chipReslotted,
      if (t.alertsOn) DeskStrings.chipAlerts,
      if (t.pending && a.waitingToSync) DeskStrings.chipUnsynced,
    ];

    return MenuAnchor(
      controller: _menu,
      alignmentOffset: const Offset(DocketSpace.s16, 0),
      menuChildren: [
        MenuItemButton(
          leadingIcon: const Icon(LucideIcons.megaphone, size: pillIconSize),
          onPressed: a.canCall ? () => a.call(t) : null,
          child: const Text(DeskStrings.callThis),
        ),
        MenuItemButton(
          leadingIcon: const Icon(LucideIcons.trash2, size: pillIconSize),
          onPressed: () => a.remove(t),
          child: const Text(DeskStrings.remove),
        ),
        MenuItemButton(
          leadingIcon: const Icon(LucideIcons.qrCode, size: pillIconSize),
          onPressed: a.canLink && t.known ? () => a.showQr(t) : null,
          child: Text(
            a.canLink ? DeskStrings.showQr : DeskStrings.showQrOffline,
          ),
        ),
      ],
      child: Semantics(
        container: true,
        button: true,
        label: DeskStrings.rowOptions(t.label),
        child: InkWell(
          onTap: _toggle,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 80),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: DocketSpace.s16,
                vertical: DocketSpace.s12,
              ),
              child: LayoutBuilder(
                builder: (context, c) {
                  final label = Text(
                    t.label,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontFeatures: tabularFigures,
                    ),
                  );
                  final details = Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(t.displayName, style: theme.textTheme.bodyLarge),
                      if (t.priorityNote case final note? when note.isNotEmpty)
                        Text(note, style: theme.textTheme.bodySmall),
                      if (chips.isNotEmpty) ...[
                        const SizedBox(height: DocketSpace.s8),
                        Wrap(
                          spacing: DocketSpace.s8,
                          runSpacing: DocketSpace.s8,
                          children: [for (final c in chips) DeskChip(c)],
                        ),
                      ],
                    ],
                  );
                  final more = ExcludeSemantics(
                    child: Icon(
                      LucideIcons.ellipsis,
                      size: pillIconSize,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  );
                  final scale = MediaQuery.textScalerOf(context).scale(1);
                  if (c.maxWidth / scale < _sideBySideFrom) {
                    return Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              label,
                              const SizedBox(height: DocketSpace.s4),
                              details,
                            ],
                          ),
                        ),
                        more,
                      ],
                    );
                  }
                  return Row(
                    children: [
                      ConstrainedBox(
                        constraints: const BoxConstraints(minWidth: 112),
                        child: label,
                      ),
                      const SizedBox(width: DocketSpace.s16),
                      Expanded(child: details),
                      more,
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
