import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

import '../../shared/strings.dart';
import '../../shared/theme/theme.dart';
import '../../shared/theme/tokens.dart';
import 'owner_logic.dart';

/// Arrivals by hour as bars in register, with the current hour in danfo,
/// each bar labelled with its count and hour, no gridlines (DESIGN.md 5.6).
///
/// Screen readers get a table of the same numbers instead of the picture.
/// Its cells sit over the bars they describe and draw nothing.
class ArrivalsChart extends StatelessWidget {
  const ArrivalsChart({
    super.key,
    required this.counts,
    required this.firstHour,
    required this.lastHour,
    this.currentHour,
    this.barAreaHeight = 160,
  });

  /// Arrivals for each of the 24 hours of the day.
  final List<int> counts;
  final int firstHour;
  final int lastHour;

  /// The hour to draw in danfo, when the chart shows today.
  final int? currentHour;
  final double barAreaHeight;

  List<int> get _hours => [for (var h = firstHour; h <= lastHour; h++) h];

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final text = Theme.of(context).textTheme;
    final hours = _hours;
    final countStyle = text.bodySmall!.copyWith(
      fontWeight: FontWeight.w700,
      fontFeatures: tabularFigures,
      color: dark ? DocketColors.daylight : DocketColors.register,
    );
    final hourStyle = text.bodySmall!.copyWith(
      fontFeatures: tabularFigures,
      color: dark ? DocketColors.nightSoft : DocketColors.registerSoft,
    );
    final scale = MediaQuery.textScalerOf(context);
    final labelHeight = scale.scale(countStyle.fontSize!) * 1.6;
    final height = barAreaHeight + labelHeight * 2;

    var total = 0;
    int? busiest;
    for (final h in hours) {
      total += counts[h];
      if (counts[h] > 0 && (busiest == null || counts[h] > counts[busiest])) {
        busiest = h;
      }
    }

    return Semantics(
      container: true,
      explicitChildNodes: true,
      label: OwnerStrings.arrivalsSummary(
        total,
        busiest == null ? null : hourLabel(busiest),
        busiest == null ? null : counts[busiest],
      ),
      child: SizedBox(
        height: height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            ExcludeSemantics(
              child: CustomPaint(
                painter: _BarsPainter(
                  hours: hours,
                  counts: counts,
                  currentHour: currentHour,
                  bar: dark ? DocketColors.nightSoft : DocketColors.register,
                  current: DocketColors.danfo,
                  baseline: dark
                      ? DocketColors.registerLift
                      : DocketColors.wash,
                  countStyle: countStyle,
                  hourStyle: hourStyle,
                  labelHeight: labelHeight,
                  textScaler: scale,
                ),
              ),
            ),
            _HiddenTable(hours: hours, counts: counts),
          ],
        ),
      ),
    );
  }
}

class _HiddenTable extends StatelessWidget {
  const _HiddenTable({required this.hours, required this.counts});

  final List<int> hours;
  final List<int> counts;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      role: SemanticsRole.table,
      label: OwnerStrings.arrivalsTitle,
      explicitChildNodes: true,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final h in hours)
            Expanded(
              child: Semantics(
                container: true,
                role: SemanticsRole.row,
                explicitChildNodes: true,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Semantics(
                        container: true,
                        role: SemanticsRole.cell,
                        label: hourLabel(h),
                        child: const SizedBox.expand(),
                      ),
                    ),
                    Expanded(
                      child: Semantics(
                        container: true,
                        role: SemanticsRole.cell,
                        label: OwnerStrings.arrivalsCell(counts[h]),
                        child: const SizedBox.expand(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _BarsPainter extends CustomPainter {
  _BarsPainter({
    required this.hours,
    required this.counts,
    required this.currentHour,
    required this.bar,
    required this.current,
    required this.baseline,
    required this.countStyle,
    required this.hourStyle,
    required this.labelHeight,
    required this.textScaler,
  });

  final List<int> hours;
  final List<int> counts;
  final int? currentHour;
  final Color bar;
  final Color current;
  final Color baseline;
  final TextStyle countStyle;
  final TextStyle hourStyle;
  final double labelHeight;
  final TextScaler textScaler;

  static const _barShare = 0.62;

  @override
  void paint(Canvas canvas, Size size) {
    if (hours.isEmpty) return;
    final slot = size.width / hours.length;
    final barWidth = slot * _barShare;
    final top = labelHeight;
    final bottom = size.height - labelHeight;
    final area = bottom - top;
    final peak = hours.map((h) => counts[h]).fold(0, math.max);
    final hourEvery = _hourStep(slot);

    canvas.drawRect(
      Rect.fromLTWH(0, bottom, size.width, 1),
      Paint()..color = baseline,
    );

    for (var i = 0; i < hours.length; i++) {
      final h = hours[i];
      final n = counts[h];
      final x = slot * i + (slot - barWidth) / 2;
      final barHeight = peak == 0 ? 0.0 : area * n / peak;
      if (n > 0) {
        canvas.drawRect(
          Rect.fromLTWH(x, bottom - barHeight, barWidth, barHeight),
          Paint()..color = h == currentHour ? current : bar,
        );
        _label(
          canvas,
          '$n',
          countStyle,
          Offset(slot * i + slot / 2, bottom - barHeight - labelHeight * 0.9),
          slot,
        );
      }
      if (i % hourEvery == 0 || h == currentHour) {
        _label(
          canvas,
          '$h',
          hourStyle,
          Offset(slot * i + slot / 2, bottom + labelHeight * 0.15),
          slot * hourEvery,
        );
      }
    }
  }

  /// Every hour gets a label when there's room, otherwise every second or
  /// third, so labels never collide on a phone.
  int _hourStep(double slot) {
    final needed = textScaler.scale(hourStyle.fontSize!) * 1.6;
    if (slot >= needed) return 1;
    if (slot * 2 >= needed) return 2;
    return 3;
  }

  void _label(
    Canvas canvas,
    String text,
    TextStyle style,
    Offset topCenter,
    double maxWidth,
  ) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
      textScaler: textScaler,
      maxLines: 1,
    )..layout();
    if (painter.width <= maxWidth + 8) {
      painter.paint(canvas, topCenter - Offset(painter.width / 2, 0));
    }
    painter.dispose();
  }

  @override
  bool shouldRepaint(_BarsPainter old) =>
      old.counts != counts ||
      old.hours.length != hours.length ||
      old.currentHour != currentHour ||
      old.bar != bar ||
      old.textScaler != textScaler;
}
