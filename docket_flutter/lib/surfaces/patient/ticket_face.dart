import 'package:flutter/material.dart';

import '../../shared/strings.dart';
import '../../shared/theme/theme.dart';
import '../../shared/theme/ticket_shape.dart';
import '../../shared/theme/tokens.dart';
import 'patient_widgets.dart';
import 'ticket_copy.dart';

/// The patient's ticket: the label as large as the width allows above the
/// tear, and what's happening below it (DESIGN 5.3).
///
/// Give it a bounded height to fill a space, or let it take the height its
/// content needs.
class TicketFace extends StatelessWidget {
  const TicketFace({
    super.key,
    required this.label,
    required this.palette,
    required this.width,
    this.where,
    this.copy,
    this.countdownDigits,
    this.fallbackDetail,
  });

  final String label;
  final TicketPalette palette;

  /// The ticket's width, which sets how large the label can be.
  final double width;

  /// "Consultation at Grace Clinic".
  final String? where;
  final TicketCopy? copy;

  /// The countdown's digits for this second, from server time.
  final String? countdownDigits;

  /// What the app shell splash said before the first live view arrived.
  final String? fallbackDetail;

  static const double padding = DocketSpace.s24;

  /// Where the tear sits, as a fraction of the height. The label keeps its
  /// size as text gets larger while the words below it grow, so the tear
  /// moves up with the text scale. The estimate is a typical waiting ticket:
  /// the label and the line's name above, a two-line headline, the ETA and
  /// three strip lines below.
  static double tearFraction(TextScaler scaler) {
    double scaled(double size, double leading, {int lines = 1}) =>
        scaler.scale(size) * leading * lines;
    final above =
        2 * padding +
        DocketType.ticketLabelMin * DocketType.displayLeading +
        DocketSpace.s8 +
        scaled(DocketType.small, DocketType.smallLeading);
    final below =
        2 * padding +
        scaled(DocketType.headline, DocketType.headingLeading, lines: 2) +
        DocketSpace.s8 +
        scaled(DocketType.body, DocketType.bodyLeading) +
        DocketSpace.s24 +
        scaled(DocketType.small, DocketType.smallLeading, lines: 3) +
        2 * DocketSpace.s4;
    return (above / (above + below)).clamp(0.25, 0.5);
  }

  /// The largest label size from 96 to 128 that fits [available], or
  /// smaller still on a very narrow screen rather than clipping.
  static double labelSize(String label, TextStyle style, double available) {
    const largest = DocketType.ticketLabelMax;
    if (label.isEmpty || available <= 0) return largest;
    final painter = TextPainter(
      text: TextSpan(
        text: label,
        style: style.copyWith(fontSize: largest),
      ),
      textDirection: TextDirection.ltr,
      textScaler: TextScaler.noScaling,
      maxLines: 1,
    )..layout();
    final natural = painter.width;
    painter.dispose();
    if (natural <= available) return largest;
    // Rounded down to a whole pixel, so it always fits.
    final fit = largest * available / natural;
    return fit - fit % 1;
  }

  @override
  Widget build(BuildContext context) {
    final page = Theme.of(context).scaffoldBackgroundColor;
    final field = Color.lerp(page, palette.field, palette.opacity)!;
    final duration = MediaQuery.disableAnimationsOf(context)
        ? Duration.zero
        : DocketMotion.ticket;
    final labelStyle = Theme.of(context).textTheme.displayLarge!.copyWith(
      fontFeatures: tabularFigures,
    );
    final size = labelSize(label, labelStyle, width - 2 * padding);

    return TweenAnimationBuilder<_Ink>(
      tween: _InkTween(end: _Ink(palette.text, palette.headline)),
      duration: duration,
      curve: DocketMotion.curve,
      builder: (context, ink, _) => DocketTicket(
        color: field,
        tearFraction: tearFraction(MediaQuery.textScalerOf(context)),
        top: _TopHalf(
          label: label,
          labelStyle: labelStyle.copyWith(fontSize: size, color: ink.text),
          where: where,
          ink: ink.text,
        ),
        bottom: _BottomHalf(
          copy: copy,
          ink: ink,
          countdownDigits: countdownDigits,
          fallbackDetail: fallbackDetail,
          textWidth: width - 2 * padding,
        ),
      ),
    );
  }
}

class _TopHalf extends StatelessWidget {
  const _TopHalf({
    required this.label,
    required this.labelStyle,
    required this.where,
    required this.ink,
  });

  final String label;
  final TextStyle labelStyle;
  final String? where;
  final Color ink;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    // The label holds the top and the line's name sits on the tear, like
    // the print on a real ticket stub.
    return Padding(
      padding: const EdgeInsets.all(TicketFace.padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Semantics(
            label: spokenLabel(label),
            excludeSemantics: true,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: AlignmentDirectional.centerStart,
              // Already as large as the width allows, so text scaling
              // can't make it bigger.
              child: Text(
                label,
                maxLines: 1,
                softWrap: false,
                textScaler: TextScaler.noScaling,
                style: labelStyle,
              ),
            ),
          ),
          if (where != null)
            Padding(
              padding: const EdgeInsets.only(top: DocketSpace.s8),
              child: Text(where!, style: text.bodySmall?.copyWith(color: ink)),
            ),
        ],
      ),
    );
  }
}

class _BottomHalf extends StatelessWidget {
  const _BottomHalf({
    required this.copy,
    required this.ink,
    required this.countdownDigits,
    required this.fallbackDetail,
    required this.textWidth,
  });

  /// The width inside the ticket's padding.
  final double textWidth;

  final TicketCopy? copy;
  final _Ink ink;
  final String? countdownDigits;
  final String? fallbackDetail;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final copy = this.copy;
    final body = text.bodyLarge?.copyWith(color: ink.text);
    final small = text.bodySmall?.copyWith(color: ink.text);

    final message = <Widget>[];
    final strip = <Widget>[];
    if (copy == null) {
      if (fallbackDetail != null) {
        message.add(Text(fallbackDetail!, style: body));
      }
    } else {
      message.add(
        _Headline(
          text: copy.headline,
          position: copy.headlinePosition,
          style: text.headlineMedium!.copyWith(color: ink.headline),
          maxWidth: textWidth,
        ),
      );
      if (copy.supporting != null) {
        message
          ..add(const SizedBox(height: DocketSpace.s8))
          ..add(Text(copy.supporting!, style: body));
      }
      final countdown = copy.countdown;
      if (copy.strip.isNotEmpty || countdown != null) {
        strip.add(const SizedBox(height: DocketSpace.s24));
      }
      if (countdown != null && countdownDigits != null) {
        strip.add(
          CountdownText(
            digits: countdownDigits!,
            suffix: countdown.suffix,
            color: ink.text,
          ),
        );
      }
      for (final (i, line) in copy.strip.indexed) {
        if (i > 0) strip.add(const SizedBox(height: DocketSpace.s4));
        strip.add(Text(line, style: small));
      }
    }

    // The countdown and the strip sit at the foot of the ticket, next to
    // the actions, when the ticket is taller than its words.
    return Padding(
      padding: const EdgeInsets.all(TicketFace.padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: message,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: strip,
          ),
        ],
      ),
    );
  }
}

/// The headline, with the position inside it rolling when it changes.
class _Headline extends StatelessWidget {
  const _Headline({
    required this.text,
    required this.position,
    required this.style,
    required this.maxWidth,
  });

  final String text;
  final int? position;
  final TextStyle style;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final scaler = wordSafeScaler(context, text, style, maxWidth);
    final ordinal = position == null ? null : PatientStrings.ordinal(position!);
    final at = ordinal == null ? -1 : text.indexOf(ordinal);
    if (at < 0) {
      return Semantics(
        header: true,
        child: Text(text, style: style, textScaler: scaler),
      );
    }
    return Semantics(
      header: true,
      label: text,
      excludeSemantics: true,
      child: Text.rich(
        textScaler: scaler,
        TextSpan(
          style: style,
          children: [
            TextSpan(text: text.substring(0, at)),
            WidgetSpan(
              alignment: PlaceholderAlignment.baseline,
              baseline: TextBaseline.alphabetic,
              // The paragraph scales its inline widgets itself, so the
              // ordinal is laid out unscaled to match the words around it.
              child: RollingText(
                ordinal!,
                style: style.copyWith(fontFeatures: tabularFigures),
                textScaler: TextScaler.noScaling,
              ),
            ),
            TextSpan(text: text.substring(at + ordinal.length)),
          ],
        ),
      ),
    );
  }
}

/// "2:41 to confirm", with the digits in the mono face so they never jitter.
class CountdownText extends StatelessWidget {
  const CountdownText({
    super.key,
    required this.digits,
    required this.suffix,
    required this.color,
  });

  final String digits;
  final String suffix;
  final Color color;

  /// Half again the headline, so the seconds read from arm's length.
  static const double size = DocketType.headline * 1.5;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: digits,
            style: TextStyle(
              fontFamily: DocketType.mono,
              fontSize: size,
              fontWeight: FontWeight.w500,
              height: DocketType.headingLeading,
              fontFeatures: tabularFigures,
              color: color,
            ),
          ),
          TextSpan(
            text: suffix,
            style: text.bodyLarge?.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}

/// The ticket's two text colors, cross-faded together.
@immutable
class _Ink {
  const _Ink(this.text, this.headline);

  final Color text;
  final Color headline;
}

class _InkTween extends Tween<_Ink> {
  _InkTween({super.end});

  @override
  _Ink lerp(double t) => _Ink(
    Color.lerp(begin!.text, end!.text, t)!,
    Color.lerp(begin!.headline, end!.headline, t)!,
  );
}
