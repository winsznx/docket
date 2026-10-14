import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// A calm, indeterminate 2 px line for loading. Docket never shows a spinner.
///
/// A short segment drifts slowly across the width. With reduced motion it
/// rests in the middle instead.
class DocketProgressLine extends StatefulWidget {
  const DocketProgressLine({super.key, this.color, this.semanticsLabel});

  /// Defaults to the theme's progress indicator color.
  final Color? color;

  /// What's loading, for screen readers.
  final String? semanticsLabel;

  static const double thickness = 2;
  static const double segmentFraction = 1 / 3;
  static const period = Duration(milliseconds: 2400);

  @override
  State<DocketProgressLine> createState() => _DocketProgressLineState();
}

class _DocketProgressLineState extends State<DocketProgressLine>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: DocketProgressLine.period,
  );
  late final Animation<double> _travel = CurvedAnimation(
    parent: _controller,
    curve: DocketMotion.curve,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.stop();
    } else if (!_controller.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color =
        widget.color ??
        ProgressIndicatorTheme.of(context).color ??
        Theme.of(context).colorScheme.primary;
    final still = MediaQuery.disableAnimationsOf(context);

    return Semantics(
      label: widget.semanticsLabel,
      child: SizedBox(
        height: DocketProgressLine.thickness,
        width: double.infinity,
        child: CustomPaint(
          painter: _SegmentPainter(
            color: color,
            travel: still ? const AlwaysStoppedAnimation(0.5) : _travel,
          ),
        ),
      ),
    );
  }
}

class _SegmentPainter extends CustomPainter {
  _SegmentPainter({required this.color, required this.travel})
    : super(repaint: travel);

  final Color color;
  final Animation<double> travel;

  @override
  void paint(Canvas canvas, Size size) {
    final segment = size.width * DocketProgressLine.segmentFraction;
    final left = -segment + (size.width + segment) * travel.value;
    canvas.drawRect(
      Rect.fromLTWH(left, 0, segment, size.height),
      Paint()..color = color,
    );
  }

  @override
  bool shouldRepaint(_SegmentPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.travel != travel;
}
