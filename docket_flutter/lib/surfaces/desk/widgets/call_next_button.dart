import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../shared/strings.dart';
import '../../../shared/theme/tokens.dart';
import '../desk_board.dart';

String callNextLabel(CallNextBlock? block) => switch (block) {
  null => DeskStrings.callNext,
  CallNextBlock.dayClosed => DeskStrings.blockedDayClosed,
  CallNextBlock.roomPaused => DeskStrings.blockedRoomPaused,
  CallNextBlock.roomClosed => DeskStrings.blockedRoomClosed,
  CallNextBlock.noOneWaiting => DeskStrings.blockedNoOne,
};

/// The largest control on the desk. When it can't run, its label says why
/// (PRD 17.3, DESIGN 5.4).
class CallNextButton extends StatelessWidget {
  const CallNextButton({
    super.key,
    required this.block,
    required this.onPressed,
  });

  final CallNextBlock? block;
  final VoidCallback onPressed;

  static const double minHeight = 96;
  static const double iconSize = 24;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: block == null ? onPressed : null,
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(minHeight),
          padding: const EdgeInsets.symmetric(
            horizontal: DocketSpace.s32,
            vertical: DocketSpace.s24,
          ),
          textStyle: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: DocketType.displayWeight,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // A blocked button shows only its reason, so the icon never
            // suggests it will call.
            if (block == null) ...[
              const Icon(LucideIcons.megaphone, size: iconSize),
              const SizedBox(width: DocketSpace.s12),
            ],
            Flexible(
              child: Text(callNextLabel(block), textAlign: TextAlign.center),
            ),
          ],
        ),
      ),
    );
  }
}
