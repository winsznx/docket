import 'package:docket_client/docket_client.dart' hide Notification;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../shared/strings.dart';
import '../../../shared/theme/tokens.dart';
import '../../../shared/widgets/progress_line.dart';
import '../desk_board.dart';
import '../desk_controller.dart';
import '../desk_errors.dart';
import 'call_next_button.dart';
import 'desk_parts.dart';

/// A tall, full-width choice row inside a sheet.
class _ChoiceRow extends StatelessWidget {
  const _ChoiceRow({required this.label, this.detail, required this.onTap});

  final String label;
  final String? detail;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: onTap,
        style: FilledButton.styleFrom(
          backgroundColor: tonalFill(theme),
          foregroundColor: theme.colorScheme.onSurface,
          alignment: AlignmentDirectional.centerStart,
          minimumSize: const Size.fromHeight(DocketSpace.s64),
          padding: const EdgeInsets.symmetric(
            horizontal: DocketSpace.s24,
            vertical: DocketSpace.s12,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label),
            if (detail != null)
              Text(
                detail!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// The label above a text field. The field keeps its own label for screen
/// readers, which this one repeats on screen.
class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: DocketSpace.s8),
    child: ExcludeSemantics(
      child: Text(text, style: Theme.of(context).textTheme.titleMedium),
    ),
  );
}

class _SheetTitle extends StatelessWidget {
  const _SheetTitle(this.title, {this.body});

  final String title;
  final String? body;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          container: true,
          header: true,
          child: Text(title, style: text.headlineMedium),
        ),
        if (body != null) ...[
          const SizedBox(height: DocketSpace.s8),
          Text(body!, style: text.bodyLarge),
        ],
        const SizedBox(height: DocketSpace.s24),
      ],
    );
  }
}

Future<void> showRoomPicker(BuildContext context, DeskController controller) {
  final board = controller.board;
  if (board == null) return Future.value();
  return showDeskSheet<void>(
    context,
    builder: (context) => Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SheetTitle(
          DeskStrings.pickRoomTitle,
          body: DeskStrings.pickRoomBody,
        ),
        for (final room in board.rooms) ...[
          _ChoiceRow(
            label: room.name,
            detail: DeskStrings.roomServes(board.line(room.lineId)?.name ?? ''),
            onTap: () {
              Navigator.of(context).pop();
              controller.selectRoom(room.id);
            },
          ),
          const SizedBox(height: DocketSpace.s8),
        ],
      ],
    ),
  );
}

Future<void> showRemoveSheet(
  BuildContext context,
  DeskController controller,
  DeskTicket ticket,
) => showDeskSheet<void>(
  context,
  builder: (context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      _SheetTitle(
        DeskStrings.removeTitle(ticket.label),
        body: DeskStrings.removeBody,
      ),
      for (final reason in DeskStrings.removeReasons) ...[
        _ChoiceRow(
          label: reason,
          onTap: () {
            Navigator.of(context).pop();
            controller.remove(ticket.id, reason);
          },
        ),
        const SizedBox(height: DocketSpace.s8),
      ],
      const SizedBox(height: DocketSpace.s16),
      Align(
        alignment: Alignment.centerLeft,
        child: TonalPill(
          label: DeskStrings.cancel,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
    ],
  ),
);

Future<void> showTransferSheet(
  BuildContext context,
  DeskController controller,
  DeskTicket ticket,
) {
  final lines =
      controller.board?.lines.where((l) => l.id != ticket.lineId).toList() ??
      const <DeskLine>[];
  return showDeskSheet<void>(
    context,
    builder: (context) => Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SheetTitle(
          DeskStrings.transferTitle(ticket.label),
          body: DeskStrings.transferBody,
        ),
        if (lines.isEmpty)
          Text(
            DeskStrings.noOtherLines,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        for (final line in lines) ...[
          _ChoiceRow(
            label: line.name,
            detail: DeskStrings.waitingCount(line.waiting.length),
            onTap: () {
              Navigator.of(context).pop();
              controller.transfer(ticket.id, line.id);
            },
          ),
          const SizedBox(height: DocketSpace.s8),
        ],
        const SizedBox(height: DocketSpace.s16),
        Align(
          alignment: Alignment.centerLeft,
          child: TonalPill(
            label: DeskStrings.cancel,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ],
    ),
  );
}

/// A fresh ticket link as a QR, for a patient whose phone joins late.
Future<void> showTicketQrSheet(
  BuildContext context,
  DeskController controller,
  DeskTicket ticket,
) => showDeskSheet<void>(
  context,
  builder: (context) =>
      _TicketQr(link: controller.linkPhone(ticket.id), label: ticket.label),
);

class _TicketQr extends StatelessWidget {
  const _TicketQr({required this.link, required this.label});

  final Future<String> link;
  final String label;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return FutureBuilder<String>(
      future: link,
      builder: (context, snapshot) {
        final error = snapshot.error;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SheetTitle(DeskStrings.scanToFollow, body: label),
            if (snapshot.connectionState != ConnectionState.done)
              const DocketProgressLine(semanticsLabel: DeskStrings.showQr)
            else if (error != null)
              Semantics(
                container: true,
                liveRegion: true,
                child: Text(errorText(error), style: text.bodyLarge),
              )
            else ...[
              DeskQr(
                data: snapshot.data!,
                size: 240,
                semanticsLabel: DeskStrings.ticketQrSemantics,
              ),
              const SizedBox(height: DocketSpace.s12),
              SelectableText(snapshot.data!, style: text.bodySmall),
              const SizedBox(height: DocketSpace.s12),
              Text(DeskStrings.qrReplaces, style: text.bodyMedium),
            ],
            const SizedBox(height: DocketSpace.s24),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(DeskStrings.done),
            ),
          ],
        );
      },
    );
  }
}

Future<void> showAddPatientSheet(
  BuildContext context,
  DeskController controller, {
  required bool priority,
}) => showDeskSheet<void>(
  context,
  builder: (context) => _AddPatient(controller: controller, priority: priority),
);

class _AddPatient extends StatefulWidget {
  const _AddPatient({required this.controller, required this.priority});

  final DeskController controller;
  final bool priority;

  @override
  State<_AddPatient> createState() => _AddPatientState();
}

enum _AddStage { form, sending, done }

class _AddPatientState extends State<_AddPatient> {
  final _name = TextEditingController();
  final _note = TextEditingController();
  final _phone = TextEditingController();
  late UuidValue? _lineId = widget.controller.board?.room?.lineId;
  PriorityReason? _reason;
  bool _consent = false;
  String? _error;
  _AddStage _stage = _AddStage.form;
  DeskActionResult? _result;

  @override
  void dispose() {
    _name.dispose();
    _note.dispose();
    _phone.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final lineId = _lineId;
    if (lineId == null) return;
    if (widget.priority && _reason == null) {
      setState(() => _error = DeskStrings.pickReason);
      return;
    }
    final phone = _phone.text.trim();
    if (phone.isNotEmpty && !_consent) {
      setState(() => _error = DeskStrings.consentNeeded);
      return;
    }
    setState(() {
      _error = null;
      _stage = _AddStage.sending;
    });
    final note = _note.text.trim();
    final c = widget.controller;
    final result = widget.priority
        ? await c.addPriority(
            lineId: lineId,
            displayName: _name.text.trim(),
            reason: _reason!,
            note: note.isEmpty ? null : note,
            phoneE164: phone.isEmpty ? null : phone,
          )
        : await c.addWalkIn(
            lineId: lineId,
            displayName: _name.text.trim(),
            phoneE164: phone.isEmpty ? null : phone,
          );
    if (!mounted) return;
    if (result != null && result.outcome == ActionOutcome.rejected) {
      await c.dismissAction(result.actionId);
      if (!mounted) return;
      setState(() {
        _stage = _AddStage.form;
        _error = result.message;
      });
      return;
    }
    setState(() {
      _stage = _AddStage.done;
      _result = result;
    });
  }

  @override
  Widget build(BuildContext context) =>
      _stage == _AddStage.done ? _done(context) : _form(context);

  Widget _done(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final url = _result?.ticketUrl;
    final label = _result?.ticket?.label;
    return Semantics(
      container: true,
      liveRegion: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SheetTitle(
            url == null
                ? DeskStrings.addedOfflineTitle
                : DeskStrings.scanToFollow,
            body: label == null ? null : DeskStrings.addedAs(label),
          ),
          if (url != null) ...[
            DeskQr(
              data: url,
              size: 240,
              semanticsLabel: DeskStrings.ticketQrSemantics,
            ),
            const SizedBox(height: DocketSpace.s12),
            SelectableText(url, style: text.bodySmall),
          ] else
            Text(DeskStrings.addedOffline, style: text.bodyLarge),
          const SizedBox(height: DocketSpace.s24),
          FilledButton(
            autofocus: true,
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(DeskStrings.done),
          ),
        ],
      ),
    );
  }

  Widget _form(BuildContext context) {
    final theme = Theme.of(context);
    final board = widget.controller.board;
    final lines = board?.lines ?? const <DeskLine>[];
    final sending = _stage == _AddStage.sending;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SheetTitle(
          widget.priority
              ? DeskStrings.addPriorityTitle
              : DeskStrings.addWalkInTitle,
          body: widget.priority ? DeskStrings.addPriorityBody : null,
        ),
        if (lines.length > 1) ...[
          Text(DeskStrings.lineLabel, style: theme.textTheme.titleMedium),
          const SizedBox(height: DocketSpace.s8),
          _Choices<UuidValue>(
            values: [for (final l in lines) l.id],
            label: (id) => board!.line(id)!.name,
            selected: _lineId,
            onSelected: (id) => setState(() => _lineId = id),
          ),
          const SizedBox(height: DocketSpace.s24),
        ],
        if (widget.priority) ...[
          Text(DeskStrings.reasonLabel, style: theme.textTheme.titleMedium),
          const SizedBox(height: DocketSpace.s8),
          _Choices<PriorityReason>(
            values: PriorityReason.values,
            label: DeskStrings.priorityReason,
            selected: _reason,
            onSelected: (r) => setState(() => _reason = r),
          ),
          const SizedBox(height: DocketSpace.s24),
        ],
        const _FieldLabel(DeskStrings.nameLabel),
        TextField(
          controller: _name,
          autofocus: true,
          enabled: !sending,
          textCapitalization: TextCapitalization.words,
          maxLength: 40,
          decoration: const InputDecoration(
            labelText: DeskStrings.nameLabel,
            hintText: DeskStrings.nameHint,
          ),
        ),
        if (widget.priority) ...[
          const SizedBox(height: DocketSpace.s16),
          const _FieldLabel(DeskStrings.noteLabel),
          TextField(
            controller: _note,
            enabled: !sending,
            maxLength: 60,
            maxLengthEnforcement: MaxLengthEnforcement.enforced,
            decoration: const InputDecoration(
              labelText: DeskStrings.noteLabel,
              helperText: DeskStrings.noteHint,
            ),
          ),
        ],
        if (widget.controller.smsEnabled) ...[
          const SizedBox(height: DocketSpace.s16),
          const _FieldLabel(DeskStrings.phoneLabel),
          TextField(
            controller: _phone,
            enabled: !sending,
            keyboardType: TextInputType.phone,
            autofillHints: const [AutofillHints.telephoneNumber],
            decoration: const InputDecoration(
              labelText: DeskStrings.phoneLabel,
              hintText: DeskStrings.phoneHint,
            ),
          ),
          const SizedBox(height: DocketSpace.s8),
          CheckboxListTile(
            value: _consent,
            onChanged: sending
                ? null
                : (v) => setState(() => _consent = v ?? false),
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
            title: Text(
              DeskStrings.phoneConsent,
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ],
        if (_error != null) ...[
          const SizedBox(height: DocketSpace.s16),
          Semantics(
            container: true,
            liveRegion: true,
            child: Text(_error!, style: theme.textTheme.bodyLarge),
          ),
        ],
        const SizedBox(height: DocketSpace.s24),
        if (sending) ...[
          const DocketProgressLine(semanticsLabel: DeskStrings.adding),
          const SizedBox(height: DocketSpace.s12),
        ],
        Wrap(
          spacing: DocketSpace.s12,
          runSpacing: DocketSpace.s12,
          children: [
            PrimaryPill(
              label: sending ? DeskStrings.adding : DeskStrings.addToLine,
              icon: widget.priority
                  ? LucideIcons.badgeAlert
                  : LucideIcons.userPlus,
              onPressed: sending || _lineId == null ? null : _submit,
            ),
            TonalPill(
              label: DeskStrings.cancel,
              onPressed: sending ? null : () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ],
    );
  }
}

/// A single choice as pills: the picked one filled, the rest wash.
class _Choices<T> extends StatelessWidget {
  const _Choices({
    required this.values,
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  final List<T> values;
  final String Function(T value) label;
  final T? selected;
  final ValueChanged<T> onSelected;

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: DocketSpace.s8,
    runSpacing: DocketSpace.s8,
    children: [
      for (final v in values)
        ChoicePill(
          label: label(v),
          selected: v == selected,
          onPressed: () => onSelected(v),
        ),
    ],
  );
}

Future<bool> confirmCloseDay(BuildContext context) async =>
    await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(DeskStrings.closeDayTitle),
        content: const Text(DeskStrings.closeDayBody),
        actions: [
          TonalPill(
            label: DeskStrings.keepOpen,
            onPressed: () => Navigator.of(context).pop(false),
          ),
          PrimaryPill(
            label: DeskStrings.closeDayConfirm,
            icon: LucideIcons.moon,
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    ) ??
    false;

/// PRD 15.4: actions the server turned down, each with its message and the
/// obvious next step. Nothing here is retried on its own.
Future<void> showCorrections(
  BuildContext context,
  DeskController controller, {
  required VoidCallback onCallNext,
  required void Function({required bool priority}) onAdd,
}) => showDeskSheet<void>(
  context,
  builder: (context) => ListenableBuilder(
    listenable: controller,
    builder: (context, _) {
      final items = controller.corrections;
      final board = controller.board;
      if (items.isEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (context.mounted && (ModalRoute.of(context)?.isCurrent ?? false)) {
            Navigator.of(context).pop();
          }
        });
        return const SizedBox.shrink();
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _SheetTitle(
            DeskStrings.correctionsTitle,
            body: DeskStrings.correctionsBody,
          ),
          for (final item in items) ...[
            _CorrectionItem(
              correction: item,
              board: board,
              onDismiss: () => controller.dismiss(item),
              nextStep: _nextStep(item.action, board, () async {
                if (context.mounted) Navigator.of(context).pop();
                await controller.dismiss(item);
                switch (item.action) {
                  case AddWalkInAction():
                    onAdd(priority: false);
                  case AddPriorityAction():
                    onAdd(priority: true);
                  default:
                    onCallNext();
                }
              }),
            ),
            const SizedBox(height: DocketSpace.s24),
          ],
          if (items.length > 1)
            Align(
              alignment: Alignment.centerLeft,
              child: TonalPill(
                label: DeskStrings.dismissAll,
                onPressed: controller.dismissAll,
              ),
            ),
        ],
      );
    },
  ),
);

/// The obvious next step for a turned-down action, or null if there is
/// none beyond reading the message.
({String label, IconData icon, VoidCallback run})? _nextStep(
  DeskAction action,
  DeskBoard? board,
  VoidCallback run,
) => switch (action) {
  AddWalkInAction() => (
    label: DeskStrings.addWalkIn,
    icon: LucideIcons.userPlus,
    run: run,
  ),
  AddPriorityAction() => (
    label: DeskStrings.addPriority,
    icon: LucideIcons.badgeAlert,
    run: run,
  ),
  CallNextAction() ||
  CallSpecificAction() ||
  RecallAction() ||
  StartServiceAction() ||
  FinishAction() ||
  MarkNoShowAction() when board?.callNextBlock == null => (
    label: callNextLabel(null),
    icon: LucideIcons.megaphone,
    run: run,
  ),
  _ => null,
};

class _CorrectionItem extends StatelessWidget {
  const _CorrectionItem({
    required this.correction,
    required this.board,
    required this.onDismiss,
    required this.nextStep,
  });

  final Correction correction;
  final DeskBoard? board;
  final VoidCallback onDismiss;
  final ({String label, IconData icon, VoidCallback run})? nextStep;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final action = correction.action;
    final ticketId = switch (action) {
      CallSpecificAction(:final ticketId) ||
      RecallAction(:final ticketId) ||
      StartServiceAction(:final ticketId) ||
      FinishAction(:final ticketId) ||
      MarkNoShowAction(:final ticketId) ||
      RemoveAction(:final ticketId) ||
      TransferAction(:final ticketId) => ticketId,
      _ => null,
    };
    final roomId = switch (action) {
      CallNextAction(:final roomId) ||
      CallSpecificAction(:final roomId) ||
      SetRoomStateAction(:final roomId) => roomId,
      _ => null,
    };
    final label = ticketId == null ? null : board?.ticket(ticketId)?.label;
    final room = roomId == null ? null : board?.roomById(roomId)?.name;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(correction.message, style: text.titleMedium),
        const SizedBox(height: DocketSpace.s4),
        Text(DeskStrings.describe(action, label, room), style: text.bodyMedium),
        const SizedBox(height: DocketSpace.s12),
        Wrap(
          spacing: DocketSpace.s12,
          runSpacing: DocketSpace.s12,
          children: [
            if (nextStep case final step?)
              PrimaryPill(
                label: step.label,
                icon: step.icon,
                onPressed: step.run,
              ),
            TonalPill(
              label: DeskStrings.gotIt,
              icon: LucideIcons.check,
              onPressed: onDismiss,
            ),
          ],
        ),
      ],
    );
  }
}
