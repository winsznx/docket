import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../shared/strings.dart';
import '../../shared/theme/theme.dart';
import '../../shared/theme/tokens.dart';

/// The widest the owner console gets, so lines of text stay readable
/// (DESIGN.md 5.6).
const ownerColumnWidth = 720.0;

/// Space between groups of settings, in place of boxes or dividers.
const groupGap = DocketSpace.s48;

/// One column, at most 720 wide, left aligned, scrolling as a whole.
class OwnerPage extends StatelessWidget {
  const OwnerPage({super.key, required this.children, this.top});

  final List<Widget> children;

  /// Something pinned above the scroll, such as the section pills.
  final Widget? top;

  @override
  Widget build(BuildContext context) {
    final narrow = MediaQuery.sizeOf(context).width < 600;
    final inline = narrow ? DocketSpace.s16 : DocketSpace.s32;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            inline,
            narrow ? DocketSpace.s24 : DocketSpace.s48,
            inline,
            DocketSpace.s96,
          ),
          child: Align(
            alignment: Alignment.topLeft,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: ownerColumnWidth),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [?top, ...children],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Color softText(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark
    ? DocketColors.nightSoft
    : DocketColors.registerSoft;

Color errorText(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark
    ? DocketColors.daylight
    : DocketColors.missed;

class PageTitle extends StatelessWidget {
  const PageTitle(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) => Semantics(
    header: true,
    child: Text(text, style: Theme.of(context).textTheme.headlineLarge),
  );
}

class GroupTitle extends StatelessWidget {
  const GroupTitle(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) => Semantics(
    header: true,
    child: Text(
      text,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 22),
    ),
  );
}

/// A one-line plain explanation in the soft text color.
class Explanation extends StatelessWidget {
  const Explanation(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: Theme.of(
      context,
    ).textTheme.bodyMedium?.copyWith(color: softText(context)),
  );
}

/// A refusal or error, in the server's words, read out when it appears.
class ErrorLine extends StatelessWidget {
  const ErrorLine(this.message, {super.key});

  final String message;

  @override
  Widget build(BuildContext context) => Semantics(
    container: true,
    liveRegion: true,
    child: Text(
      message,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: errorText(context),
        fontWeight: FontWeight.w700,
      ),
    ),
  );
}

/// A labelled input: the label above, an optional explanation, then the
/// wash-filled field. Screen readers hear the label as the field's name.
class LabeledField extends StatelessWidget {
  const LabeledField({
    super.key,
    required this.label,
    required this.controller,
    this.explanation,
    this.hint,
    this.error,
    this.width,
    this.keyboardType,
    this.inputFormatters,
    this.onChanged,
    this.onSubmitted,
    this.suffix,
    this.textCapitalization = TextCapitalization.none,
    this.autofocus = false,
    this.maxLength,
  });

  final String label;
  final TextEditingController controller;
  final String? explanation;
  final String? hint;
  final String? error;
  final double? width;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final String? suffix;
  final TextCapitalization textCapitalization;
  final bool autofocus;
  final int? maxLength;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final explanation = this.explanation;
    final error = this.error;
    final field = Semantics(
      label: label,
      child: TextField(
        controller: controller,
        autofocus: autofocus,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        textCapitalization: textCapitalization,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        maxLength: maxLength,
        decoration: InputDecoration(
          hintText: hint,
          counterText: '',
          suffixText: suffix,
          suffixStyle: text.bodyLarge?.copyWith(color: softText(context)),
        ),
      ),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ExcludeSemantics(child: Text(label, style: text.titleMedium)),
        if (explanation != null) ...[
          const SizedBox(height: DocketSpace.s4),
          Explanation(explanation),
        ],
        const SizedBox(height: DocketSpace.s8),
        if (width == null)
          field
        else
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: width!),
            child: field,
          ),
        if (error != null) ...[
          const SizedBox(height: DocketSpace.s8),
          ErrorLine(error),
        ],
      ],
    );
  }
}

/// A link to hand to someone: the address itself, read out like any text,
/// then Copy and Open.
class LinkBlock extends StatelessWidget {
  const LinkBlock({
    super.key,
    required this.url,
    required this.onOpen,
    this.title,
    this.explanation,
    this.note,
  });

  final String url;
  final VoidCallback onOpen;
  final String? title;
  final String? explanation;

  /// A line under the actions, such as when an invite runs out.
  final String? note;

  Future<void> _copy(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: url));
    if (!context.mounted) return;
    announce(context, OwnerStrings.linkCopied);
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final title = this.title;
    final explanation = this.explanation;
    final note = this.note;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) GroupTitle(title),
        if (explanation != null) ...[
          const SizedBox(height: DocketSpace.s4),
          Explanation(explanation),
        ],
        if (title != null || explanation != null)
          const SizedBox(height: DocketSpace.s12),
        Text(
          url,
          style: text.bodyLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: DocketSpace.s8),
        Wrap(
          spacing: DocketSpace.s8,
          runSpacing: DocketSpace.s8,
          children: [
            DocketButton(
              onPressed: () => _copy(context),
              label: OwnerStrings.copyLink,
              icon: LucideIcons.copy,
              filled: true,
            ),
            DocketButton(onPressed: onOpen, label: OwnerStrings.openLink),
          ],
        ),
        if (note != null) ...[
          const SizedBox(height: DocketSpace.s8),
          Explanation(note),
        ],
      ],
    );
  }
}

/// Tells the person what just happened: the words to a screen reader, and a
/// snack bar on screen unless the page itself already says it.
void announce(BuildContext context, String message, {bool snack = true}) {
  SemanticsService.sendAnnouncement(
    View.of(context),
    message,
    TextDirection.ltr,
  );
  if (!snack) return;
  ScaffoldMessenger.maybeOf(context)
    ?..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}

/// A pill-shaped choice, register filled when chosen.
class ChoicePill extends StatelessWidget {
  const ChoicePill({
    super.key,
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final bool selected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final fill = selected
        ? (dark ? DocketColors.daylight : DocketColors.register)
        : (dark ? DocketColors.registerLift : DocketColors.wash);
    final ink = selected
        ? (dark ? DocketColors.register : DocketColors.daylight)
        : (dark ? DocketColors.daylight : DocketColors.register);
    return Semantics(
      selected: selected,
      inMutuallyExclusiveGroup: true,
      child: TextButton(
        onPressed: onSelected,
        style: TextButton.styleFrom(
          backgroundColor: fill,
          foregroundColor: ink,
          padding: const EdgeInsets.symmetric(
            horizontal: DocketSpace.s16,
            vertical: DocketSpace.s8,
          ),
        ),
        child: Text(label),
      ),
    );
  }
}

/// An on and off switch that matches the tokens: no outline, register
/// when on.
class DocketSwitch extends StatelessWidget {
  const DocketSwitch({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.explanation,
  });

  final String label;
  final String? explanation;
  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final text = Theme.of(context).textTheme;
    final explanation = this.explanation;
    return MergeSemantics(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: text.titleMedium),
                if (explanation != null) ...[
                  const SizedBox(height: DocketSpace.s4),
                  Explanation(explanation),
                ],
              ],
            ),
          ),
          const SizedBox(width: DocketSpace.s16),
          Switch(
            value: value,
            onChanged: onChanged,
            thumbColor: WidgetStateProperty.resolveWith(
              (states) => states.contains(WidgetState.selected)
                  ? (dark ? DocketColors.register : DocketColors.daylight)
                  : (dark ? DocketColors.nightSoft : DocketColors.registerSoft),
            ),
            trackColor: WidgetStateProperty.resolveWith(
              (states) => states.contains(WidgetState.selected)
                  ? (dark ? DocketColors.daylight : DocketColors.register)
                  : (dark ? DocketColors.registerLift : DocketColors.wash),
            ),
            trackOutlineColor: const WidgetStatePropertyAll(
              Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }
}

/// A live number with its caption under it, read as one phrase.
class Figure extends StatelessWidget {
  const Figure({super.key, required this.value, required this.caption});

  final String value;
  final String caption;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return MergeSemantics(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: text.headlineLarge?.copyWith(
              fontWeight: FontWeight.w800,
              fontFeatures: tabularFigures,
            ),
          ),
          Text(
            caption,
            style: text.bodyMedium?.copyWith(color: softText(context)),
          ),
        ],
      ),
    );
  }
}

/// The size of every icon inside a control.
const controlIconSize = 20.0;

/// A flat pill button, filled or text, with an optional Lucide icon before
/// its label in the label's own color. Icons only ever label a control.
class DocketButton extends StatelessWidget {
  const DocketButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.filled = false,
  });

  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final base = filled
        ? theme.filledButtonTheme.style
        : theme.textButtonTheme.style;
    final style = ButtonStyle(
      iconColor: base?.foregroundColor,
      iconSize: const WidgetStatePropertyAll(controlIconSize),
      elevation: const WidgetStatePropertyAll(0),
      shadowColor: const WidgetStatePropertyAll(Colors.transparent),
    );
    final text = Text(label);
    final icon = this.icon;
    if (icon == null) {
      return filled
          ? FilledButton(onPressed: onPressed, style: style, child: text)
          : TextButton(onPressed: onPressed, style: style, child: text);
    }
    return filled
        ? FilledButton.icon(
            onPressed: onPressed,
            style: style,
            icon: Icon(icon),
            label: text,
          )
        : TextButton.icon(
            onPressed: onPressed,
            style: style,
            icon: Icon(icon),
            label: text,
          );
  }
}

/// The date picker with the tokens: flat, no lift.
Future<DateTime?> pickServiceDate(
  BuildContext context, {
  required DateTime initial,
  required DateTime first,
  required DateTime last,
  required String helpText,
}) => showDatePicker(
  context: context,
  initialDate: initial,
  firstDate: first,
  lastDate: last,
  helpText: helpText,
  builder: (context, child) => Theme(
    data: Theme.of(context).copyWith(
      datePickerTheme: const DatePickerThemeData(
        elevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
      ),
    ),
    child: child!,
  ),
);
