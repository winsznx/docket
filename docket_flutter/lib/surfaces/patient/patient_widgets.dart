import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../shared/strings.dart';
import '../../shared/theme/tokens.dart';

/// Content width on screens wider than a phone, so lines stay short.
const double patientMaxWidth = 520;

/// Page gutters, matching the app shell splash so the first frame lands
/// where the splash was.
const patientGutter = EdgeInsets.symmetric(horizontal: DocketSpace.s16);

/// The ticket mark in danfo beside "Docket", as the splash draws it.
class DocketWordmark extends StatelessWidget {
  const DocketWordmark({super.key});

  static const double _size = 22;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.onSurface;
    return Semantics(
      label: PatientStrings.wordmark,
      excludeSemantics: true,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CustomPaint(
            size: Size(_size * 1.5, _size),
            painter: _MarkPainter(),
          ),
          const SizedBox(width: DocketSpace.s8),
          Text(
            PatientStrings.wordmark,
            style: TextStyle(
              fontFamily: DocketType.sans,
              fontSize: _size,
              height: 1.25,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

/// The splash's SVG path, a 48 by 32 ticket with a notch on each side.
class _MarkPainter extends CustomPainter {
  const _MarkPainter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 48, size.height / 32);
    final path = Path()
      ..moveTo(6, 0)
      ..lineTo(42, 0)
      ..arcToPoint(const Offset(48, 6), radius: const Radius.circular(6))
      ..lineTo(48, 11)
      ..arcToPoint(
        const Offset(48, 21),
        radius: const Radius.circular(5),
        clockwise: false,
      )
      ..lineTo(48, 26)
      ..arcToPoint(const Offset(42, 32), radius: const Radius.circular(6))
      ..lineTo(6, 32)
      ..arcToPoint(const Offset(0, 26), radius: const Radius.circular(6))
      ..lineTo(0, 21)
      ..arcToPoint(
        const Offset(0, 11),
        radius: const Radius.circular(5),
        clockwise: false,
      )
      ..lineTo(0, 6)
      ..arcToPoint(const Offset(6, 0), radius: const Radius.circular(6))
      ..close();
    canvas.drawPath(path, Paint()..color = DocketColors.danfo);
  }

  @override
  bool shouldRepaint(_MarkPainter oldDelegate) => false;
}

/// The page's top row: the wordmark, and the DEMO chip when it applies.
class PatientTopBar extends StatelessWidget {
  const PatientTopBar({super.key, this.demo = false});

  final bool demo;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        DocketSpace.s16,
        DocketSpace.s24,
        DocketSpace.s16,
        0,
      ),
      child: Row(
        children: [
          const DocketWordmark(),
          const Spacer(),
          if (demo) const DemoChip(),
        ],
      ),
    );
  }
}

/// The literal DEMO chip, the one place capitals are allowed.
class DemoChip extends StatelessWidget {
  const DemoChip({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: scheme.surfaceContainerHighest,
        shape: const StadiumBorder(),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: DocketSpace.s12,
          vertical: DocketSpace.s4,
        ),
        child: Text(
          CommonStrings.demo,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: scheme.onSurface,
          ),
        ),
      ),
    );
  }
}

/// A full-width register-on-wash band for the connection states (PRD 5.5).
class PatientBand extends StatelessWidget {
  const PatientBand({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      child: ColoredBox(
        color: DocketColors.wash,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: DocketSpace.s16,
            vertical: DocketSpace.s12,
          ),
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: DocketColors.register,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

/// Text that rolls to its new value, the old one leaving upward and the new
/// one arriving from below. Under reduced motion it just changes.
class RollingText extends StatelessWidget {
  const RollingText(
    this.text, {
    super.key,
    required this.style,
    this.textScaler,
  });

  final String text;
  final TextStyle? style;
  final TextScaler? textScaler;

  @override
  Widget build(BuildContext context) {
    final still = MediaQuery.disableAnimationsOf(context);
    return ClipRect(
      child: AnimatedSwitcher(
        duration: still ? Duration.zero : DocketMotion.ticket,
        switchInCurve: DocketMotion.curve,
        switchOutCurve: DocketMotion.curve,
        layoutBuilder: (current, previous) => Stack(
          alignment: AlignmentDirectional.centerStart,
          children: [...previous, ?current],
        ),
        transitionBuilder: (child, animation) {
          final arriving = child.key == ValueKey(text);
          return SlideTransition(
            position: Tween(
              begin: Offset(0, arriving ? 1 : -1),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
        child: Text(
          text,
          key: ValueKey(text),
          style: style,
          textScaler: textScaler,
        ),
      ),
    );
  }
}

/// How a screen reader says a label: "C-031" becomes "C 31", as the board's
/// voice reads it (PRD 4.4).
String spokenLabel(String label) {
  final match = RegExp(r'^([A-Za-z]+)-0*(\d+)$').firstMatch(label);
  if (match == null) return label;
  return '${match.group(1)} ${match.group(2)}';
}

/// Size of the line icon that labels a control, before its words.
const double controlIconSize = 20;

/// Flat: no elevation, no shadow, nothing moves on press. The ticket is
/// the only object with depth.
const _flat = ButtonStyle(
  elevation: WidgetStatePropertyAll(0),
  shadowColor: WidgetStatePropertyAll(Colors.transparent),
  surfaceTintColor: WidgetStatePropertyAll(Colors.transparent),
);

/// The icon takes the label's color in every state, where Material would
/// otherwise use the primary color.
ButtonStyle _iconLikeText(ButtonStyle? theme) =>
    ButtonStyle(iconColor: theme?.foregroundColor);

/// A control's icon and words. The icon takes the label's color from the
/// button, and the words wrap at large text sizes.
class _IconLabel extends StatelessWidget {
  const _IconLabel({
    required this.icon,
    required this.label,
    this.center = true,
  });

  final IconData? icon;
  final String label;
  final bool center;

  @override
  Widget build(BuildContext context) {
    final text = Text(
      label,
      textAlign: center ? TextAlign.center : TextAlign.start,
    );
    if (icon == null) return text;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ExcludeSemantics(
          child: Icon(icon, size: controlIconSize),
        ),
        const SizedBox(width: DocketSpace.s8),
        Flexible(child: text),
      ],
    );
  }
}

/// A tall, full-width pill for the screen's main action.
class PrimaryPill extends StatelessWidget {
  const PrimaryPill({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.color,
    this.textColor,
  });

  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final Color? color;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(DocketSpace.s64 - DocketSpace.s8),
        backgroundColor: color,
        foregroundColor: textColor,
        iconColor: textColor,
      ).merge(_iconLikeText(FilledButtonTheme.of(context).style)).merge(_flat),
      child: _IconLabel(icon: icon, label: label),
    );
  }
}

/// A full-width text button for the quieter action.
class SecondaryPill extends StatelessWidget {
  const SecondaryPill({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  });

  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        minimumSize: const Size.fromHeight(DocketSpace.s48),
      ).merge(_iconLikeText(TextButtonTheme.of(context).style)).merge(_flat),
      child: _IconLabel(icon: icon, label: label),
    );
  }
}

/// A text action that sits on the page's left edge with the words around
/// it, keeping a 48 px target.
class InlineAction extends StatelessWidget {
  const InlineAction({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  });

  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: const Size(DocketSpace.s48, DocketSpace.s48),
        alignment: AlignmentDirectional.centerStart,
      ).merge(_iconLikeText(TextButtonTheme.of(context).style)).merge(_flat),
      child: _IconLabel(icon: icon, label: label, center: false),
    );
  }
}

/// Grows [style] with the reader's text size, but stops before the longest
/// word of [text] would be wider than [maxWidth] and break mid-word.
TextScaler wordSafeScaler(
  BuildContext context,
  String text,
  TextStyle style,
  double maxWidth,
) {
  final scaler = MediaQuery.textScalerOf(context);
  final size = style.fontSize ?? DocketType.body;
  var widest = 0.0;
  for (final word in text.split(RegExp(r'\s+'))) {
    if (word.isEmpty) continue;
    final painter = TextPainter(
      text: TextSpan(text: word, style: style),
      textDirection: TextDirection.ltr,
      textScaler: TextScaler.noScaling,
      maxLines: 1,
    )..layout();
    widest = math.max(widest, painter.width);
    painter.dispose();
  }
  if (widest == 0 || maxWidth <= 0) return scaler;
  // A hair under the exact fit, so rounding never tips a word over.
  final fits = maxWidth / widest * 0.98;
  return scaler.scale(size) / size <= fits ? scaler : TextScaler.linear(fits);
}
