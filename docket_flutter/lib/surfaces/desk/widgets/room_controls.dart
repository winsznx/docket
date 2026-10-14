import 'package:docket_client/docket_client.dart' hide Notification;
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../shared/strings.dart';
import '../../../shared/theme/theme.dart';
import '../../../shared/theme/tokens.dart';
import '../desk_board.dart';
import 'desk_parts.dart';

/// Open, on a break or closed, as three pills with the current one filled
/// (PRD 5.2).
class RoomStateSwitch extends StatelessWidget {
  const RoomStateSwitch({
    super.key,
    required this.room,
    required this.onChanged,
  });

  final DeskRoom room;
  final ValueChanged<RoomState> onChanged;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      DeskHeading(DeskStrings.roomStateTitle, trailing: room.name),
      const SizedBox(height: DocketSpace.s12),
      Wrap(
        spacing: DocketSpace.s8,
        runSpacing: DocketSpace.s8,
        children: [
          for (final state in RoomState.values)
            ChoicePill(
              label: DeskStrings.roomState(state),
              icon: switch (state) {
                RoomState.open => LucideIcons.doorOpen,
                RoomState.paused => LucideIcons.coffee,
                RoomState.closed => LucideIcons.doorClosed,
              },
              selected: room.state == state,
              onPressed: () => onChanged(state),
            ),
        ],
      ),
    ],
  );
}

/// Waiting and served counts for the clinic's other lines.
class OtherLines extends StatelessWidget {
  const OtherLines({super.key, required this.lines});

  final List<DeskLine> lines;

  @override
  Widget build(BuildContext context) {
    if (lines.isEmpty) return const SizedBox.shrink();
    final theme = Theme.of(context);
    final soft = theme.textTheme.bodyMedium?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
      fontFeatures: tabularFigures,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const DeskHeading(DeskStrings.otherLinesTitle),
        const SizedBox(height: DocketSpace.s12),
        for (final line in lines)
          Padding(
            padding: const EdgeInsets.only(bottom: DocketSpace.s12),
            child: Wrap(
              spacing: DocketSpace.s16,
              runSpacing: DocketSpace.s4,
              crossAxisAlignment: WrapCrossAlignment.end,
              children: [
                Text(line.name, style: theme.textTheme.titleMedium),
                Text(
                  DeskStrings.waitingCount(line.waiting.length),
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontFeatures: tabularFigures,
                  ),
                ),
                Text(DeskStrings.servedToday(line.servedToday), style: soft),
              ],
            ),
          ),
      ],
    );
  }
}
