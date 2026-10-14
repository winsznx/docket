import 'package:docket_client/docket_client.dart' hide Notification;
import 'package:docket_client/docket_client.dart' as docket show Notification;
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../client.dart';
import '../../shared/strings.dart';
import '../../shared/theme/theme.dart';
import '../../shared/theme/tokens.dart';
import '../../shared/widgets/progress_line.dart';
import 'browser.dart';
import 'owner_access.dart';
import 'owner_logic.dart';
import 'owner_widgets.dart';

/// Every ticket event for a day, newest first and filterable by label,
/// then the messages sent to patients with what happened to each.
class AuditSection extends StatefulWidget {
  const AuditSection({super.key, required this.access, required this.view});

  final OwnerAccess access;
  final OwnerView view;

  @override
  State<AuditSection> createState() => _AuditSectionState();
}

class _AuditSectionState extends State<AuditSection> {
  static const _page = 50;
  static const _messages = 200;

  late String _date = widget.view.serviceDate;
  final _filter = TextEditingController();
  List<TicketEvent>? _events;
  List<docket.Notification>? _sent;
  bool _more = false;
  bool _loadingOlder = false;
  String? _error;

  OwnerAccess get _access => widget.access;
  String get _zone => widget.view.clinic.timezone;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _filter.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _events = null;
      _sent = null;
      _error = null;
    });
    final date = _date;
    try {
      final (events, sent) = await (
        client.owner.audit(
          _access.clinicId,
          date,
          _page,
          null,
          _access.sandboxToken,
        ),
        client.owner.notificationLog(
          _access.clinicId,
          date,
          _messages,
          _access.sandboxToken,
        ),
      ).wait;
      if (!mounted || date != _date) return;
      setState(() {
        _events = events;
        _sent = sent;
        _more = events.length == _page;
      });
    } on Object catch (e) {
      if (mounted) setState(() => _error = messageOf(e));
    }
  }

  Future<void> _older() async {
    final events = _events;
    if (events == null || events.isEmpty) return;
    setState(() => _loadingOlder = true);
    try {
      final older = await client.owner.audit(
        _access.clinicId,
        _date,
        _page,
        events.last.id,
        _access.sandboxToken,
      );
      if (!mounted) return;
      setState(() {
        _events = [...events, ...older];
        _more = older.length == _page;
      });
    } on Object catch (e) {
      if (mounted) setState(() => _error = messageOf(e));
    } finally {
      if (mounted) setState(() => _loadingOlder = false);
    }
  }

  Future<void> _pickDate() async {
    final today = parseServiceDate(widget.view.serviceDate);
    final picked = await pickServiceDate(
      context,
      initial: parseServiceDate(_date),
      first: DateTime(today.year - 1, today.month, today.day),
      last: today,
      helpText: OwnerStrings.reportDate,
    );
    if (picked == null || !mounted) return;
    setState(() => _date = serviceDateOf(picked));
    await _load();
  }

  bool _matches(String label) {
    final want = _filter.text.trim().toUpperCase();
    return want.isEmpty || label.toUpperCase().contains(want);
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final events = _events;
    final sent = _sent;
    final error = _error;
    final shown = events?.where((e) => _matches(e.ticketLabel)).toList();
    final shownSent = sent?.where((n) => _matches(n.ticketLabel)).toList();
    final rooms = {for (final r in widget.view.rooms) r.id: r.name};
    final filtering = _filter.text.trim().isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(OwnerStrings.reportDate, style: text.titleMedium),
        const SizedBox(height: DocketSpace.s4),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: DocketSpace.s16,
          runSpacing: DocketSpace.s8,
          children: [
            Text(readableDate(_date), style: text.headlineSmall),
            DocketButton(
              onPressed: _pickDate,
              label: OwnerStrings.changeDate,
              icon: LucideIcons.calendar,
            ),
          ],
        ),
        const SizedBox(height: DocketSpace.s24),
        LabeledField(
          label: OwnerStrings.filterLabel,
          controller: _filter,
          hint: OwnerStrings.filterHint,
          width: 240,
          textCapitalization: TextCapitalization.characters,
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: DocketSpace.s32),
        if (error != null) ...[
          ErrorLine(error),
          const SizedBox(height: DocketSpace.s16),
        ],
        const GroupTitle(OwnerStrings.eventsTitle),
        const SizedBox(height: DocketSpace.s16),
        if (events == null && error == null)
          const DocketProgressLine(semanticsLabel: OwnerStrings.loading),
        if (shown != null && shown.isEmpty)
          Explanation(
            filtering ? OwnerStrings.noMatches : OwnerStrings.noEvents,
          ),
        if (shown != null)
          for (final e in shown)
            _Row(
              time: Browser.clockIn(_zone, e.at, seconds: true),
              label: e.ticketLabel,
              title: describeEvent(e.type),
              detail: [
                describeActor(e.actor),
                if (e.roomId != null && rooms[e.roomId] != null)
                  rooms[e.roomId]!,
              ].join(', '),
              note: e.reason,
            ),
        if (_more) ...[
          const SizedBox(height: DocketSpace.s8),
          Align(
            alignment: Alignment.centerLeft,
            child: DocketButton(
              onPressed: _loadingOlder ? null : _older,
              label: OwnerStrings.showOlder,
              icon: LucideIcons.history,
            ),
          ),
        ],
        const SizedBox(height: groupGap),
        const GroupTitle(OwnerStrings.messagesTitle),
        const SizedBox(height: DocketSpace.s16),
        if (sent == null && error == null)
          const DocketProgressLine(semanticsLabel: OwnerStrings.loading),
        if (shownSent != null && shownSent.isEmpty)
          Explanation(
            filtering ? OwnerStrings.noMatches : OwnerStrings.noMessages,
          ),
        if (shownSent != null)
          for (final n in shownSent)
            _Row(
              time: Browser.clockIn(_zone, n.createdAt, seconds: true),
              label: n.ticketLabel,
              title: describeKind(n.kind),
              detail:
                  '${describeChannel(n.channel)} '
                  '${describeStatus(n.status).toLowerCase()}',
              note: n.error,
              alert:
                  n.status == DeliveryStatus.failed ||
                  n.status == DeliveryStatus.undelivered,
            ),
      ],
    );
  }
}

/// One audit line: the clinic time, the ticket label, what happened and
/// who did it. No borders, space between rows.
class _Row extends StatelessWidget {
  const _Row({
    required this.time,
    required this.label,
    required this.title,
    required this.detail,
    this.note,
    this.alert = false,
  });

  final String time;
  final String label;
  final String title;
  final String detail;
  final String? note;
  final bool alert;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final note = this.note;
    final soft = softText(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: DocketSpace.s16),
      child: MergeSemantics(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: MediaQuery.textScalerOf(context).scale(96),
              child: Text(
                time,
                style: text.bodyMedium?.copyWith(
                  color: soft,
                  fontFeatures: tabularFigures,
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: label,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        const TextSpan(text: '  '),
                        TextSpan(text: title),
                      ],
                    ),
                    style: text.bodyLarge,
                  ),
                  Text(
                    detail,
                    style: text.bodyMedium?.copyWith(
                      color: alert ? errorText(context) : soft,
                      fontWeight: alert ? FontWeight.w700 : null,
                    ),
                  ),
                  if (note != null && note.isNotEmpty)
                    Text(note, style: text.bodyMedium?.copyWith(color: soft)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
