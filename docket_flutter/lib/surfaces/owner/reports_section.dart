import 'package:docket_client/docket_client.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../client.dart';
import '../../shared/strings.dart';
import '../../shared/theme/tokens.dart';
import '../../shared/widgets/progress_line.dart';
import 'arrivals_chart.dart';
import 'browser.dart';
import 'owner_access.dart';
import 'owner_logic.dart';
import 'owner_widgets.dart';

/// One day's report: arrivals by hour, wait and visit medians with the
/// 90th percentile, the counts, and the CSV.
class ReportsSection extends StatefulWidget {
  const ReportsSection({super.key, required this.access, required this.view});

  final OwnerAccess access;
  final OwnerView view;

  @override
  State<ReportsSection> createState() => _ReportsSectionState();
}

class _ReportsSectionState extends State<ReportsSection> {
  late String _date = widget.view.serviceDate;
  DayReportData? _report;
  String? _error;
  bool _downloading = false;

  OwnerAccess get _access => widget.access;
  Clinic get _clinic => widget.view.clinic;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _report = null;
      _error = null;
    });
    final date = _date;
    try {
      final report = await client.owner.dayReport(
        _access.clinicId,
        date,
        _access.sandboxToken,
      );
      if (mounted && date == _date) setState(() => _report = report.data);
    } on Object catch (e) {
      if (mounted) setState(() => _error = messageOf(e));
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

  Future<void> _downloadCsv() async {
    setState(() => _downloading = true);
    try {
      final csv = await client.owner.dayReportCsv(
        _access.clinicId,
        _date,
        _access.sandboxToken,
      );
      Browser.download('docket-${_clinic.slug}-$_date.csv', csv);
      if (mounted) announce(context, OwnerStrings.csvReady);
    } on Object catch (e) {
      if (mounted) setState(() => _error = messageOf(e));
    } finally {
      if (mounted) setState(() => _downloading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final report = _report;
    final error = _error;
    final text = Theme.of(context).textTheme;
    final isToday = _date == widget.view.serviceDate;

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
        const SizedBox(height: DocketSpace.s32),
        if (error != null) ...[
          ErrorLine(error),
          const SizedBox(height: DocketSpace.s16),
        ],
        if (report == null && error == null)
          const DocketProgressLine(semanticsLabel: OwnerStrings.loading),
        if (report != null) ..._details(report, isToday),
      ],
    );
  }

  List<Widget> _details(DayReportData report, bool isToday) {
    final totals = totalArrivals(report.lines);
    final (first, last) = chartHours(
      totals,
      _clinic.openTime,
      _clinic.closeTime,
    );
    final anyone = totals.any((n) => n > 0);
    return [
      const GroupTitle(OwnerStrings.arrivalsTitle),
      const SizedBox(height: DocketSpace.s16),
      if (anyone)
        ArrivalsChart(
          counts: totals,
          firstHour: first,
          lastHour: last,
          currentHour: isToday ? Browser.hourIn(_clinic.timezone) : null,
        )
      else
        const Explanation(OwnerStrings.noArrivals),
      const SizedBox(height: groupGap),
      for (final line in report.lines) ...[
        GroupTitle(line.lineName),
        const SizedBox(height: DocketSpace.s16),
        Wrap(
          spacing: DocketSpace.s48,
          runSpacing: DocketSpace.s24,
          children: [
            Figure(
              value: formatDuration(line.medianWaitSeconds),
              caption: OwnerStrings.waitMedian,
            ),
            Figure(
              value: formatDuration(line.p90WaitSeconds),
              caption: OwnerStrings.waitP90,
            ),
            Figure(
              value: formatDuration(line.medianServiceSeconds),
              caption: OwnerStrings.serviceMedian,
            ),
            Figure(
              value: formatDuration(line.p90ServiceSeconds),
              caption: OwnerStrings.serviceP90,
            ),
          ],
        ),
        const SizedBox(height: DocketSpace.s24),
        Wrap(
          spacing: DocketSpace.s32,
          runSpacing: DocketSpace.s16,
          children: [
            for (final (n, caption) in [
              (line.joined, OwnerStrings.joined),
              (line.served, OwnerStrings.served),
              (line.cancelled, OwnerStrings.cancelled),
              (line.removed, OwnerStrings.removed),
              (line.expired, OwnerStrings.expired),
              (line.reslotted, OwnerStrings.reslotted),
            ])
              Figure(value: '$n', caption: caption),
          ],
        ),
        const SizedBox(height: groupGap),
      ],
      Align(
        alignment: Alignment.centerLeft,
        child: DocketButton(
          onPressed: _downloading ? null : _downloadCsv,
          label: OwnerStrings.downloadCsv,
          icon: LucideIcons.download,
        ),
      ),
    ];
  }
}
