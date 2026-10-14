import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../shared/theme/tokens.dart';

/// The size of a Lucide line icon inside a pill, before its label.
const double pillIconSize = 20;

/// A pill's label, with its line icon in front when it has one. The icon
/// takes the label's color from the button and says nothing on its own.
Widget _pillChild(String label, IconData? icon, String? semanticsLabel) {
  final text = Text(label, semanticsLabel: semanticsLabel);
  if (icon == null) return text;
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, size: pillIconSize),
      const SizedBox(width: DocketSpace.s8),
      Flexible(child: text),
    ],
  );
}

/// The primary pill, register filled from the theme, with an optional line
/// icon before its label.
class PrimaryPill extends StatelessWidget {
  const PrimaryPill({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.autofocus = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool autofocus;

  @override
  Widget build(BuildContext context) => FilledButton(
    onPressed: onPressed,
    autofocus: autofocus,
    child: _pillChild(label, icon, null),
  );
}

/// The fill of a quiet pill: wash on daylight. On night and on the register
/// sheets of dark mode it's a faint tint of the text color, which reads on
/// both and stays apart from the registerLift primary pill.
Color tonalFill(ThemeData theme) => theme.brightness == Brightness.dark
    ? theme.colorScheme.onSurface.withValues(alpha: _darkTonalAlpha)
    : theme.colorScheme.surfaceContainerHighest;

const _darkTonalAlpha = 0.12;

/// A pill for secondary actions, a step quieter than the primary pill the
/// theme gives [FilledButton].
class TonalPill extends StatelessWidget {
  const TonalPill({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.semanticsLabel,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: tonalFill(theme),
        foregroundColor: theme.colorScheme.onSurface,
      ),
      child: _pillChild(label, icon, semanticsLabel),
    );
  }
}

/// One option of a single choice. The picked one takes the page's text
/// color as its fill, so it stands out from both kinds of pill in either
/// mode.
class ChoicePill extends StatelessWidget {
  const ChoicePill({
    super.key,
    required this.label,
    required this.selected,
    required this.onPressed,
    this.icon,
  });

  final String label;
  final bool selected;
  final VoidCallback onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return MergeSemantics(
      child: Semantics(
        selected: selected,
        inMutuallyExclusiveGroup: true,
        child: selected
            ? FilledButton(
                onPressed: onPressed,
                style: FilledButton.styleFrom(
                  backgroundColor: scheme.onSurface,
                  foregroundColor: scheme.surface,
                ),
                child: _pillChild(label, icon, null),
              )
            : TonalPill(label: label, icon: icon, onPressed: onPressed),
      ),
    );
  }
}

/// A small pill that labels a fact about a ticket. Chips are never colored
/// by meaning, since color belongs to ticket state.
class DeskChip extends StatelessWidget {
  const DeskChip(this.text, {super.key, this.semanticsLabel, this.ink});

  final String text;
  final String? semanticsLabel;

  /// The text color of the ticket the chip sits on. The chip then takes a
  /// faint fill of that color, so it reads on any state's field.
  final Color? ink;

  static const _onTicketFill = 0.14;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ink = this.ink;
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: ink == null
            ? theme.colorScheme.surfaceContainerHighest
            : ink.withValues(alpha: _onTicketFill),
        shape: const StadiumBorder(),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: DocketSpace.s12,
          vertical: DocketSpace.s4,
        ),
        child: Text(
          text,
          semanticsLabel: semanticsLabel,
          style: theme.textTheme.labelMedium?.copyWith(
            color: ink ?? theme.colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}

/// A QR code on a white field, so it scans in light and dark mode.
class DeskQr extends StatelessWidget {
  const DeskQr({
    super.key,
    required this.data,
    required this.semanticsLabel,
    this.size = 200,
  });

  final String data;
  final String semanticsLabel;
  final double size;

  @override
  Widget build(BuildContext context) => ColoredBox(
    color: DocketColors.daylight,
    child: Padding(
      padding: const EdgeInsets.all(DocketSpace.s12),
      child: QrImageView(
        data: data,
        size: size,
        padding: EdgeInsets.zero,
        backgroundColor: DocketColors.daylight,
        semanticsLabel: semanticsLabel,
        eyeStyle: const QrEyeStyle(
          eyeShape: QrEyeShape.square,
          color: DocketColors.register,
        ),
        dataModuleStyle: const QrDataModuleStyle(
          dataModuleShape: QrDataModuleShape.square,
          color: DocketColors.register,
        ),
      ),
    ),
  );
}

/// A section heading on the desk, at subheading weight.
class DeskHeading extends StatelessWidget {
  const DeskHeading(this.text, {super.key, this.trailing});

  final String text;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Semantics(
      container: true,
      header: true,
      child: Wrap(
        spacing: DocketSpace.s12,
        crossAxisAlignment: WrapCrossAlignment.end,
        children: [
          Text(text, style: theme.textTheme.titleLarge),
          if (trailing != null)
            Text(
              trailing!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
        ],
      ),
    );
  }
}

/// Shows a modal sheet with the desk's sheet layout: radius 28 on the top
/// corners from the theme, 24 px of padding, and at most 640 px wide.
Future<T?> showDeskSheet<T>(
  BuildContext context, {
  required WidgetBuilder builder,
}) => showModalBottomSheet<T>(
  context: context,
  isScrollControlled: true,
  useSafeArea: true,
  constraints: const BoxConstraints(maxWidth: 640),
  builder: (context) => Padding(
    padding: EdgeInsets.only(
      bottom: MediaQuery.viewInsetsOf(context).bottom,
    ),
    child: SingleChildScrollView(
      padding: const EdgeInsets.all(DocketSpace.s24),
      child: Builder(builder: builder),
    ),
  ),
);
