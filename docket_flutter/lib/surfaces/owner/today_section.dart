import 'dart:async';

import 'package:docket_client/docket_client.dart';
import 'package:flutter/material.dart';

import '../../client.dart';
import '../../shared/strings.dart';
import '../../shared/theme/tokens.dart';
import '../../shared/widgets/progress_line.dart';
import 'browser.dart';
import 'owner_access.dart';
import 'owner_logic.dart';
import 'owner_widgets.dart';

/// Today's numbers per line: waiting now, served, and the median wait so
/// far, refreshed while the section is open.
class TodaySection extends StatefulWidget {
  const TodaySection({super.key, required this.access, required this.view});

  final OwnerAccess access;
  final OwnerView view;

  @override
  State<TodaySection> createState() => _TodaySectionState();
}

class _TodaySectionState extends State<TodaySection> {
  static const _refresh = Duration(seconds: 20);

  DayReportData? _report;
  DateTime? _updated;
  String? _error;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _load();
    _timer = Timer.periodic(_refresh, (_) => _load());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final report = await client.owner.dayReport(
        widget.access.clinicId,
        widget.view.serviceDate,
        widget.access.sandboxToken,
      );
      if (!mounted) return;
      setState(() {
        _report = report.data;
        _updated = DateTime.now();
        _error = null;
      });
    } on Object catch (e) {
      if (mounted) setState(() => _error = messageOf(e));
    }
  }

  @override
  Widget build(BuildContext context) {
    final report = _report;
    final error = _error;
    final updated = _updated;
    final text = Theme.of(context).textTheme;
    final accepting = {
      for (final l in widget.view.lines) l.name: l.acceptingJoins,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (error != null) ...[ErrorLine(error), const SizedBox(height: 16)],
        if (report == null && error == null)
          const DocketProgressLine(semanticsLabel: OwnerStrings.loading),
        if (report != null && report.lines.isEmpty)
          const Explanation(OwnerStrings.noLines),
        if (report != null)
          for (final line in report.lines) ...[
            GroupTitle(line.lineName),
            const SizedBox(height: DocketSpace.s4),
            Explanation(
              accepting[line.lineName] == false
                  ? OwnerStrings.notTakingPatients
                  : OwnerStrings.takingPatients,
            ),
            const SizedBox(height: DocketSpace.s16),
            Wrap(
              spacing: DocketSpace.s48,
              runSpacing: DocketSpace.s16,
              children: [
                Figure(
                  value: '${line.waitingNow}',
                  caption: OwnerStrings.waiting,
                ),
                Figure(value: '${line.served}', caption: OwnerStrings.served),
                Figure(
                  value: line.medianWaitSeconds == null
                      ? OwnerStrings.noWaitYet
                      : formatDuration(line.medianWaitSeconds),
                  caption: OwnerStrings.medianWait,
                ),
              ],
            ),
            const SizedBox(height: groupGap),
          ],
        if (updated != null)
          Text(
            OwnerStrings.updatedAt(
              Browser.clockIn(widget.view.clinic.timezone, updated),
            ),
            style: text.bodySmall?.copyWith(color: softText(context)),
          ),
      ],
    );
  }
}
