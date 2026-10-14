import 'package:docket_client/docket_client.dart' hide Notification;
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../shared/strings.dart';
import '../../../shared/theme/theme.dart';
import '../../../shared/theme/ticket_shape.dart';
import '../../../shared/theme/tokens.dart';
import '../desk_board.dart';
import 'desk_parts.dart';
import 'server_countdown.dart';

/// What the desk can do to a ticket in its room.
class RoomTicketActions {
  const RoomTicketActions({
    required this.startService,
    required this.recall,
    required this.noShow,
    required this.finish,
    required this.transfer,
  });

  final void Function(DeskTicket ticket) startService;
  final void Function(DeskTicket ticket) recall;
  final void Function(DeskTicket ticket) noShow;
  final void Function(DeskTicket ticket) finish;
  final void Function(DeskTicket ticket) transfer;
}

String stateText(TicketState state) => switch (state) {
  TicketState.called => DeskStrings.stateCalled,
  TicketState.confirmed => DeskStrings.stateConfirmed,
  TicketState.inService => DeskStrings.stateInService,
  _ => '',
};

/// The room's current ticket at display size on its state color, then its
/// countdown, delivery and the next steps (DESIGN 5.4). Earlier calls to the
/// same room that are still open sit under it.
class NowServing extends StatelessWidget {
  const NowServing({
    super.key,
    required this.board,
    required this.waitingToSync,
    required this.actions,
  });

  final DeskBoard board;
  final RoomTicketActions actions;

  /// The desk can't reach the server, so a change not yet synced says so.
  /// Online, a change settles before anyone could read the note.
  final bool waitingToSync;

  @override
  Widget build(BuildContext context) {
    final current = board.nowServing;
    final room = board.room;
    if (current == null || room == null) {
      return _Free(roomName: room?.name ?? '');
    }
    final others = board.inRoom.skip(1).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _ServingTicket(ticket: current),
        const SizedBox(height: DocketSpace.s16),
        if (current.pending && waitingToSync) ...[
          Text(
            current.state == TicketState.called
                ? DeskStrings.pendingCall
                : DeskStrings.pendingChange,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: DocketSpace.s16),
        ],
        _TicketButtons(ticket: current, actions: actions),
        if (others.isNotEmpty) ...[
          const SizedBox(height: DocketSpace.s32),
          DeskHeading(DeskStrings.alsoHere),
          const SizedBox(height: DocketSpace.s12),
          for (final t in others) ...[
            _EarlierCall(ticket: t, actions: actions),
            const SizedBox(height: DocketSpace.s16),
          ],
        ],
      ],
    );
  }
}

class _Free extends StatelessWidget {
  const _Free({required this.roomName});

  final String roomName;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Semantics(
      container: true,
      liveRegion: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: DocketSpace.s24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(DeskStrings.roomFree(roomName), style: text.headlineMedium),
            const SizedBox(height: DocketSpace.s8),
            Text(DeskStrings.roomFreeBody, style: text.bodyLarge),
          ],
        ),
      ),
    );
  }
}

class _ServingTicket extends StatelessWidget {
  const _ServingTicket({required this.ticket});

  final DeskTicket ticket;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = ticketPalette(
      state: ticket.state,
      headsUpSent: false,
      reslotted: ticket.reslotted,
      brightness: theme.brightness,
    );
    final ink = palette.text;
    final grace = ticket.graceEndsAt;
    final arrival = ticket.arrivalEndsAt;
    final chips = [
      if (ticket.pushStatus case final status?)
        DeskStrings.delivery(Channel.push, status),
      if (ticket.smsStatus case final status?)
        DeskStrings.delivery(Channel.sms, status),
      if (ticket.isDemo) DeskStrings.chipDemo,
      if (ticket.priorityReason case final reason?)
        DeskStrings.priorityReason(reason),
    ];

    return Semantics(
      container: true,
      liveRegion: true,
      label: DeskStrings.ticketSemantics(
        ticket.label,
        ticket.displayName,
        stateText(ticket.state),
      ),
      child: DocketTicket(
        tearFraction: 0.46,
        color: palette.field,
        top: Padding(
          key: ValueKey(ticket.label),
          padding: const EdgeInsets.fromLTRB(
            DocketSpace.s24,
            DocketSpace.s24,
            DocketSpace.s24,
            DocketSpace.s16,
          ),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.bottomLeft,
              child: Text(
                ticket.label,
                style: theme.textTheme.displayMedium?.copyWith(
                  color: palette.headline,
                  fontFeatures: tabularFigures,
                ),
              ),
            ),
          ),
        ),
        // DocketTicket sizes itself from its halves only when a half is
        // inserted, so a key that follows the content gives it a fresh half
        // whenever the bottom grows or shrinks.
        bottom: Padding(
          key: ValueKey((
            ticket.id,
            ticket.state,
            ticket.pending,
            grace != null || arrival != null,
            chips.join(),
          )),
          padding: const EdgeInsets.fromLTRB(
            DocketSpace.s24,
            DocketSpace.s24,
            DocketSpace.s24,
            DocketSpace.s24,
          ),
          child: ExcludeSemantics(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  ticket.displayName,
                  style: theme.textTheme.headlineSmall?.copyWith(color: ink),
                ),
                const SizedBox(height: DocketSpace.s4),
                Text(
                  stateText(ticket.state),
                  style: theme.textTheme.bodyLarge?.copyWith(color: ink),
                ),
                if (grace != null || arrival != null) ...[
                  const SizedBox(height: DocketSpace.s8),
                  ServerCountdown(
                    end: grace ?? arrival!,
                    suffix: grace != null
                        ? DeskStrings.toConfirm
                        : DeskStrings.toArrive,
                    color: ink,
                  ),
                ],
                if (chips.isNotEmpty) ...[
                  const SizedBox(height: DocketSpace.s12),
                  Wrap(
                    spacing: DocketSpace.s8,
                    runSpacing: DocketSpace.s8,
                    children: [for (final c in chips) DeskChip(c, ink: ink)],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TicketButtons extends StatelessWidget {
  const _TicketButtons({required this.ticket, required this.actions});

  final DeskTicket ticket;
  final RoomTicketActions actions;

  @override
  Widget build(BuildContext context) {
    final buttons = switch (ticket.state) {
      TicketState.called || TicketState.confirmed => [
        PrimaryPill(
          label: DeskStrings.startService,
          icon: LucideIcons.play,
          onPressed: () => actions.startService(ticket),
        ),
        if (ticket.state == TicketState.called)
          TonalPill(
            label: DeskStrings.recall,
            icon: LucideIcons.repeat,
            onPressed: () => actions.recall(ticket),
          ),
        TonalPill(
          label: DeskStrings.noShow,
          icon: LucideIcons.userX,
          onPressed: () => actions.noShow(ticket),
        ),
      ],
      TicketState.inService => [
        PrimaryPill(
          label: DeskStrings.finish,
          icon: LucideIcons.check,
          onPressed: () => actions.finish(ticket),
        ),
        TonalPill(
          label: DeskStrings.transfer,
          icon: LucideIcons.arrowRightLeft,
          onPressed: () => actions.transfer(ticket),
        ),
      ],
      _ => const <Widget>[],
    };
    return Wrap(
      spacing: DocketSpace.s12,
      runSpacing: DocketSpace.s12,
      children: buttons,
    );
  }
}

/// An earlier call to this room that is still open, with its own buttons.
class _EarlierCall extends StatelessWidget {
  const _EarlierCall({required this.ticket, required this.actions});

  final DeskTicket ticket;
  final RoomTicketActions actions;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: DocketSpace.s12,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              ticket.label,
              style: text.headlineSmall?.copyWith(
                fontFeatures: tabularFigures,
              ),
            ),
            Text(ticket.displayName, style: text.bodyLarge),
            Text(stateText(ticket.state), style: text.bodyMedium),
          ],
        ),
        const SizedBox(height: DocketSpace.s8),
        _TicketButtons(ticket: ticket, actions: actions),
      ],
    );
  }
}
