import 'package:docket_client/docket_client.dart' hide Notification;
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../shared/strings.dart';
import '../../../shared/theme/tokens.dart';
import '../desk_controller.dart';
import 'desk_parts.dart';

/// Clinic, room, day state, connection with the outbox count, then the
/// day and session controls (PRD 17.3). It wraps on narrow screens.
class DeskTopBar extends StatelessWidget {
  const DeskTopBar({
    super.key,
    required this.clinicName,
    required this.roomName,
    required this.day,
    required this.connection,
    required this.pending,
    required this.corrections,
    required this.onChangeRoom,
    required this.onCorrections,
    required this.onCloseDay,
    required this.session,
  });

  final String clinicName;
  final String? roomName;
  final DayState? day;
  final DeskConnection connection;
  final int pending;
  final int corrections;
  final VoidCallback onChangeRoom;
  final VoidCallback onCorrections;
  final VoidCallback? onCloseDay;

  /// Leave the sandbox, switch clinic or sign out.
  final List<Widget> session;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final soft = theme.textTheme.bodyMedium?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );
    final dayText = switch (day) {
      DayState.open => DeskStrings.dayOpen,
      DayState.closed => DeskStrings.dayClosed,
      null => DeskStrings.dayNotStarted,
    };
    final connectionText = switch (connection) {
      DeskConnection.online => DeskStrings.online,
      DeskConnection.offline => DeskStrings.offlineSaved(pending),
      DeskConnection.syncing => DeskStrings.syncing(pending),
    };

    final info = Wrap(
      spacing: DocketSpace.s16,
      runSpacing: DocketSpace.s8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Semantics(
          container: true,
          header: true,
          child: Text(clinicName, style: theme.textTheme.titleLarge),
        ),
        if (roomName != null)
          TonalPill(
            label: roomName!,
            semanticsLabel: DeskStrings.changeRoom(roomName!),
            onPressed: onChangeRoom,
          ),
        Text(dayText, style: soft),
        Semantics(
          container: true,
          liveRegion: true,
          child: Text(connectionText, style: soft),
        ),
      ],
    );
    final actions = Wrap(
      spacing: DocketSpace.s8,
      runSpacing: DocketSpace.s8,
      children: [
        if (corrections > 0)
          PrimaryPill(
            label: DeskStrings.toReview(corrections),
            icon: LucideIcons.triangleAlert,
            onPressed: onCorrections,
          ),
        if (onCloseDay != null)
          TonalPill(
            label: DeskStrings.closeDay,
            icon: LucideIcons.moon,
            onPressed: onCloseDay,
          ),
        ...session,
      ],
    );

    return LayoutBuilder(
      builder: (context, c) => Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isWide(context, c.maxWidth)
              ? DocketSpace.s24
              : DocketSpace.s16,
          vertical: DocketSpace.s12,
        ),
        child: isWide(context, c.maxWidth)
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(child: info),
                  const SizedBox(width: DocketSpace.s16),
                  actions,
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  info,
                  const SizedBox(height: DocketSpace.s12),
                  actions,
                ],
              ),
      ),
    );
  }

  /// From this width the actions sit at the end of the bar.
  static const double wideFrom = 840;

  /// Wide enough for one row, counting large text as narrower space.
  static bool isWide(BuildContext context, double width) {
    final scale = MediaQuery.textScalerOf(context).scale(1);
    return width / (scale < 1 ? 1 : scale) >= wideFrom;
  }
}

/// The full-width band for an offline or syncing desk (PRD 5.4). Danfo only
/// when offline, since that's the state the clinic has to notice.
class ConnectionBand extends StatelessWidget {
  const ConnectionBand({
    super.key,
    required this.connection,
    required this.pending,
  });

  final DeskConnection connection;
  final int pending;

  @override
  Widget build(BuildContext context) {
    if (connection == DeskConnection.online) return const SizedBox.shrink();
    final theme = Theme.of(context);
    final offline = connection == DeskConnection.offline;
    final field = offline
        ? DocketColors.danfo
        : theme.colorScheme.surfaceContainerHighest;
    final ink = offline ? DocketColors.register : theme.colorScheme.onSurface;
    final text = offline
        ? DeskStrings.offlineBand
        : DeskStrings.syncingBand(pending);
    final detail = offline && pending > 0
        ? DeskStrings.waitingActions(pending)
        : null;
    final gutter = DeskTopBar.isWide(context, MediaQuery.sizeOf(context).width)
        ? DocketSpace.s24
        : DocketSpace.s16;
    return Semantics(
      liveRegion: true,
      container: true,
      child: ColoredBox(
        color: field,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: gutter,
            vertical: DocketSpace.s12,
          ),
          child: Wrap(
            spacing: DocketSpace.s16,
            runSpacing: DocketSpace.s4,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    offline ? LucideIcons.wifiOff : LucideIcons.refreshCw,
                    size: pillIconSize,
                    color: ink,
                  ),
                  const SizedBox(width: DocketSpace.s8),
                  Flexible(
                    child: Text(
                      text,
                      style: theme.textTheme.titleMedium?.copyWith(color: ink),
                    ),
                  ),
                ],
              ),
              if (detail != null)
                Text(
                  detail,
                  style: theme.textTheme.bodyLarge?.copyWith(color: ink),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
