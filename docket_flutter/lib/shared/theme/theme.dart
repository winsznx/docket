import 'package:docket_client/docket_client.dart';
import 'package:flutter/material.dart';

import 'tokens.dart';

/// Font features for every live number, so digits keep their width as the
/// value changes.
const tabularFigures = [FontFeature.tabularFigures()];

const _staleFieldOpacity = 0.6;

// DESIGN.md names no opacities for these, so they keep Material 3's values.
const _hoverLayerOpacity = 0.08;
const _pressedLayerOpacity = 0.1;
const _scrimOpacity = 0.32;
const _selectionOpacity = 0.4;

/// The colors a ticket shows in one state. Ticket state decides the color of
/// the ticket and nothing else does.
@immutable
class TicketPalette {
  const TicketPalette({
    required this.field,
    required this.text,
    Color? headline,
    this.opacity = 1,
  }) : headline = headline ?? text;

  final Color field;
  final Color text;

  /// The headline's color. It differs from [text] only after a re-slot.
  final Color headline;

  /// The opacity of [field]. Text always stays at full strength.
  final double opacity;

  TicketPalette _stale() => TicketPalette(
    field: field,
    text: text,
    headline: headline,
    opacity: _staleFieldOpacity,
  );

  @override
  bool operator ==(Object other) =>
      other is TicketPalette &&
      other.field == field &&
      other.text == text &&
      other.headline == headline &&
      other.opacity == opacity;

  @override
  int get hashCode => Object.hash(field, text, headline, opacity);

  @override
  String toString() =>
      'TicketPalette(field: $field, text: $text, headline: $headline, '
      'opacity: $opacity)';
}

/// The ticket state table from DESIGN.md 3.1.
///
/// A heads-up wins over a re-slot, since it's the newer event. A re-slotted
/// ticket stays on daylight in dark mode too, so its missed headline keeps
/// its contrast.
TicketPalette ticketPalette({
  required TicketState state,
  required bool headsUpSent,
  required bool reslotted,
  required Brightness brightness,
  bool stale = false,
}) {
  final dark = brightness == Brightness.dark;
  const lifted = TicketPalette(
    field: DocketColors.registerLift,
    text: DocketColors.daylight,
  );

  final palette = switch (state) {
    TicketState.waiting when headsUpSent => const TicketPalette(
      field: DocketColors.danfo,
      text: DocketColors.register,
    ),
    TicketState.waiting when reslotted => const TicketPalette(
      field: DocketColors.daylight,
      text: DocketColors.register,
      headline: DocketColors.missed,
    ),
    TicketState.waiting ||
    TicketState.served ||
    TicketState.transferred => dark ? lifted : _daylightTicket,
    TicketState.called => const TicketPalette(
      field: DocketColors.go,
      text: DocketColors.daylight,
    ),
    TicketState.confirmed => dark ? lifted : _registerTicket,
    TicketState.inService => dark ? lifted : _washTicket,
    TicketState.expired => const TicketPalette(
      field: DocketColors.missed,
      text: DocketColors.daylight,
    ),
    TicketState.cancelled ||
    TicketState.removed ||
    TicketState.closed => dark ? _endedTicketDark : _endedTicket,
  };
  return stale ? palette._stale() : palette;
}

const _daylightTicket = TicketPalette(
  field: DocketColors.daylight,
  text: DocketColors.register,
);
const _registerTicket = TicketPalette(
  field: DocketColors.register,
  text: DocketColors.daylight,
);
const _washTicket = TicketPalette(
  field: DocketColors.wash,
  text: DocketColors.register,
);
const _endedTicket = TicketPalette(
  field: DocketColors.wash,
  text: DocketColors.registerSoft,
);
const _endedTicketDark = TicketPalette(
  field: DocketColors.registerLift,
  text: DocketColors.nightSoft,
);

/// The app theme: Material 3 widgets with their defaults replaced by the
/// tokens.
ThemeData docketTheme(Brightness brightness) {
  final roles = switch (brightness) {
    Brightness.light => _Roles.light,
    Brightness.dark => _Roles.dark,
  };
  final textTheme = _textTheme(roles.text);
  final scrim = DocketColors.night.withValues(alpha: _scrimOpacity);
  const flat = RoundedRectangleBorder();
  final filledButton = _pillStyle(
    label: textTheme.labelLarge,
    focusRing: roles.focusRing,
    fill: roles.action,
    text: roles.onAction,
    disabledFill: roles.disabledFill,
    disabledText: roles.disabledText,
  );
  final textButton = _pillStyle(
    label: textTheme.labelLarge,
    focusRing: roles.focusRing,
    fill: Colors.transparent,
    text: roles.text,
    disabledFill: Colors.transparent,
    disabledText: roles.disabledText,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: _colorScheme(brightness),
    fontFamily: DocketType.sans,
    textTheme: textTheme,
    primaryTextTheme: _textTheme(roles.onAction),
    splashFactory: NoSplash.splashFactory,
    splashColor: Colors.transparent,
    highlightColor: roles.field,
    hoverColor: roles.field,
    focusColor: roles.field,
    scaffoldBackgroundColor: roles.background,
    canvasColor: roles.background,
    cardColor: roles.background,
    dividerColor: roles.field,
    disabledColor: roles.disabledText,
    hintColor: roles.textSoft,
    shadowColor: Colors.transparent,
    applyElevationOverlayColor: false,
    visualDensity: VisualDensity.standard,
    materialTapTargetSize: MaterialTapTargetSize.padded,
    iconTheme: IconThemeData(color: roles.text),
    appBarTheme: AppBarThemeData(
      backgroundColor: roles.background,
      foregroundColor: roles.text,
      elevation: 0,
      scrolledUnderElevation: 0,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      centerTitle: false,
      titleTextStyle: textTheme.titleLarge,
      iconTheme: IconThemeData(color: roles.text),
    ),
    filledButtonTheme: FilledButtonThemeData(style: filledButton),
    elevatedButtonTheme: ElevatedButtonThemeData(style: filledButton),
    textButtonTheme: TextButtonThemeData(style: textButton),
    outlinedButtonTheme: OutlinedButtonThemeData(style: textButton),
    inputDecorationTheme: _inputTheme(roles, textTheme),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: roles.focusRing,
      selectionColor: roles.focusRing.withValues(alpha: _selectionOpacity),
      selectionHandleColor: roles.focusRing,
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: roles.raised,
      modalBackgroundColor: roles.raised,
      modalBarrierColor: scrim,
      elevation: 0,
      modalElevation: 0,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      showDragHandle: false,
      clipBehavior: Clip.antiAlias,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(DocketRadius.sheet),
        ),
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: roles.raised,
      barrierColor: scrim,
      elevation: 0,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(DocketRadius.sheet)),
      ),
      titleTextStyle: textTheme.titleLarge,
      contentTextStyle: textTheme.bodyMedium,
    ),
    cardTheme: CardThemeData(
      color: roles.background,
      elevation: 0,
      margin: EdgeInsets.zero,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      shape: flat,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: roles.field,
      disabledColor: roles.disabledFill,
      selectedColor: roles.action,
      labelStyle: textTheme.labelMedium?.copyWith(color: roles.onField),
      secondaryLabelStyle: textTheme.labelMedium?.copyWith(
        color: roles.onAction,
      ),
      side: BorderSide.none,
      shape: const StadiumBorder(),
      elevation: 0,
      pressElevation: 0,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      checkmarkColor: roles.onAction,
      padding: const EdgeInsets.symmetric(
        horizontal: DocketSpace.s12,
        vertical: DocketSpace.s4,
      ),
    ),
    checkboxTheme: CheckboxThemeData(
      shape: flat,
      side: WidgetStateBorderSide.resolveWith(
        (states) => states.contains(WidgetState.selected)
            ? BorderSide.none
            : BorderSide(color: roles.text, width: 2),
      ),
      fillColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected)
            ? roles.action
            : Colors.transparent,
      ),
      checkColor: WidgetStatePropertyAll(roles.onAction),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: roles.inverse,
      contentTextStyle: textTheme.bodyMedium?.copyWith(color: roles.onInverse),
      actionTextColor: roles.onInverse,
      elevation: 0,
      behavior: SnackBarBehavior.fixed,
      shape: flat,
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: roles.progress,
      linearTrackColor: Colors.transparent,
      linearMinHeight: 2,
      borderRadius: BorderRadius.zero,
    ),
    menuTheme: MenuThemeData(style: _menuStyle(roles)),
    dropdownMenuTheme: DropdownMenuThemeData(menuStyle: _menuStyle(roles)),
    popupMenuTheme: PopupMenuThemeData(
      color: roles.field,
      elevation: 0,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      shape: flat,
      textStyle: textTheme.bodyMedium?.copyWith(color: roles.onField),
    ),
    bottomAppBarTheme: BottomAppBarThemeData(
      color: roles.background,
      elevation: 0,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: roles.background,
      elevation: 0,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      indicatorColor: roles.field,
      indicatorShape: const StadiumBorder(),
    ),
    navigationRailTheme: NavigationRailThemeData(
      backgroundColor: roles.background,
      elevation: 0,
      indicatorColor: roles.field,
      indicatorShape: const StadiumBorder(),
    ),
    drawerTheme: DrawerThemeData(
      backgroundColor: roles.raised,
      scrimColor: scrim,
      elevation: 0,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      shape: flat,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: roles.action,
      foregroundColor: roles.onAction,
      elevation: 0,
      focusElevation: 0,
      hoverElevation: 0,
      highlightElevation: 0,
      disabledElevation: 0,
      shape: const StadiumBorder(),
    ),
  );
}

/// What each color does in one brightness. Dark mode lifts register-colored
/// and wash-colored surfaces to registerLift so they separate from night.
final class _Roles {
  const _Roles({
    required this.background,
    required this.text,
    required this.textSoft,
    required this.action,
    required this.onAction,
    required this.field,
    required this.onField,
    required this.raised,
    required this.inverse,
    required this.onInverse,
    required this.focusRing,
    required this.errorText,
    required this.disabledFill,
    required this.disabledText,
    required this.progress,
  });

  static const light = _Roles(
    background: DocketColors.daylight,
    text: DocketColors.register,
    textSoft: DocketColors.registerSoft,
    action: DocketColors.register,
    onAction: DocketColors.daylight,
    field: DocketColors.wash,
    onField: DocketColors.register,
    raised: DocketColors.daylight,
    inverse: DocketColors.night,
    onInverse: DocketColors.daylight,
    focusRing: DocketColors.register,
    errorText: DocketColors.missed,
    disabledFill: DocketColors.wash,
    disabledText: DocketColors.registerSoft,
    progress: DocketColors.register,
  );

  static const dark = _Roles(
    background: DocketColors.night,
    text: DocketColors.daylight,
    textSoft: DocketColors.nightSoft,
    action: DocketColors.registerLift,
    onAction: DocketColors.daylight,
    field: DocketColors.registerLift,
    onField: DocketColors.daylight,
    raised: DocketColors.register,
    inverse: DocketColors.daylight,
    onInverse: DocketColors.register,
    focusRing: DocketColors.daylight,
    errorText: DocketColors.daylight,
    disabledFill: DocketColors.register,
    disabledText: DocketColors.nightSoft,
    progress: DocketColors.nightSoft,
  );

  final Color background;
  final Color text;
  final Color textSoft;
  final Color action;
  final Color onAction;
  final Color field;
  final Color onField;
  final Color raised;
  final Color inverse;
  final Color onInverse;
  final Color focusRing;
  final Color errorText;
  final Color disabledFill;
  final Color disabledText;
  final Color progress;
}

ColorScheme _colorScheme(Brightness brightness) => switch (brightness) {
  Brightness.light => const ColorScheme(
    brightness: Brightness.light,
    primary: DocketColors.register,
    onPrimary: DocketColors.daylight,
    primaryContainer: DocketColors.wash,
    onPrimaryContainer: DocketColors.register,
    secondary: DocketColors.registerSoft,
    onSecondary: DocketColors.daylight,
    secondaryContainer: DocketColors.wash,
    onSecondaryContainer: DocketColors.register,
    tertiary: DocketColors.danfo,
    onTertiary: DocketColors.register,
    tertiaryContainer: DocketColors.danfo,
    onTertiaryContainer: DocketColors.register,
    error: DocketColors.missed,
    onError: DocketColors.daylight,
    errorContainer: DocketColors.missed,
    onErrorContainer: DocketColors.daylight,
    surface: DocketColors.daylight,
    onSurface: DocketColors.register,
    onSurfaceVariant: DocketColors.registerSoft,
    surfaceDim: DocketColors.wash,
    surfaceBright: DocketColors.daylight,
    surfaceContainerLowest: DocketColors.daylight,
    surfaceContainerLow: DocketColors.daylight,
    surfaceContainer: DocketColors.daylight,
    surfaceContainerHigh: DocketColors.daylight,
    surfaceContainerHighest: DocketColors.wash,
    outline: DocketColors.registerSoft,
    outlineVariant: DocketColors.wash,
    shadow: DocketColors.night,
    scrim: DocketColors.night,
    inverseSurface: DocketColors.night,
    onInverseSurface: DocketColors.daylight,
    inversePrimary: DocketColors.nightSoft,
    surfaceTint: Colors.transparent,
  ),
  Brightness.dark => const ColorScheme(
    brightness: Brightness.dark,
    primary: DocketColors.registerLift,
    onPrimary: DocketColors.daylight,
    primaryContainer: DocketColors.register,
    onPrimaryContainer: DocketColors.daylight,
    secondary: DocketColors.nightSoft,
    onSecondary: DocketColors.night,
    secondaryContainer: DocketColors.registerLift,
    onSecondaryContainer: DocketColors.daylight,
    tertiary: DocketColors.danfo,
    onTertiary: DocketColors.register,
    tertiaryContainer: DocketColors.danfo,
    onTertiaryContainer: DocketColors.register,
    error: DocketColors.missed,
    onError: DocketColors.daylight,
    errorContainer: DocketColors.missed,
    onErrorContainer: DocketColors.daylight,
    surface: DocketColors.night,
    onSurface: DocketColors.daylight,
    onSurfaceVariant: DocketColors.nightSoft,
    surfaceDim: DocketColors.night,
    surfaceBright: DocketColors.register,
    surfaceContainerLowest: DocketColors.night,
    surfaceContainerLow: DocketColors.night,
    surfaceContainer: DocketColors.register,
    surfaceContainerHigh: DocketColors.register,
    surfaceContainerHighest: DocketColors.registerLift,
    outline: DocketColors.nightSoft,
    outlineVariant: DocketColors.registerLift,
    shadow: DocketColors.night,
    scrim: DocketColors.night,
    inverseSurface: DocketColors.daylight,
    onInverseSurface: DocketColors.register,
    inversePrimary: DocketColors.register,
    surfaceTint: Colors.transparent,
  ),
};

/// Maps the Material roles onto the phone sizes from DESIGN.md 3.2: the
/// ticket label from 96 to 128, headline 32, body 18 and small 15.
TextTheme _textTheme(Color color) {
  TextStyle style(
    double size,
    FontWeight weight,
    double leading, {
    double trackingEm = 0,
  }) => TextStyle(
    fontFamily: DocketType.sans,
    fontSize: size,
    fontWeight: weight,
    height: leading,
    letterSpacing: size * trackingEm,
    leadingDistribution: TextLeadingDistribution.even,
    color: color,
  );

  TextStyle ticketLabel(double size) => style(
    size,
    DocketType.displayWeight,
    DocketType.displayLeading,
    trackingEm: DocketType.displayTrackingEm,
  );
  final headline = style(
    DocketType.headline,
    DocketType.headingWeight,
    DocketType.headingLeading,
  );
  final body = style(
    DocketType.body,
    DocketType.bodyWeight,
    DocketType.bodyLeading,
  );
  final small = style(
    DocketType.small,
    DocketType.smallWeight,
    DocketType.smallLeading,
  );

  return TextTheme(
    displayLarge: ticketLabel(DocketType.ticketLabelMax),
    displayMedium: ticketLabel(DocketType.ticketLabelMin),
    displaySmall: ticketLabel(DocketType.ticketLabelMin),
    headlineLarge: headline,
    headlineMedium: headline,
    headlineSmall: headline,
    titleLarge: style(
      DocketType.body,
      DocketType.subheadingWeight,
      DocketType.subheadingLeading,
    ),
    titleMedium: style(
      DocketType.body,
      DocketType.subheadingWeight,
      DocketType.subheadingLeading,
    ),
    titleSmall: style(
      DocketType.small,
      DocketType.subheadingWeight,
      DocketType.subheadingLeading,
    ),
    bodyLarge: body,
    bodyMedium: body,
    bodySmall: small,
    labelLarge: style(
      DocketType.body,
      DocketType.subheadingWeight,
      DocketType.subheadingLeading,
    ),
    labelMedium: small,
    labelSmall: small,
  );
}

/// A 2 px ring with a 2 px gap outside the pill, so focus shows on any fill.
/// A stroke align of 3 centers the 2 px stroke 3 px outside the edge.
BorderSide _focusRing(Color color) =>
    BorderSide(color: color, width: 2, strokeAlign: 3);

ButtonStyle _pillStyle({
  required TextStyle? label,
  required Color focusRing,
  required Color fill,
  required Color text,
  required Color disabledFill,
  required Color disabledText,
}) => ButtonStyle(
  backgroundColor: WidgetStateProperty.resolveWith(
    (states) => states.contains(WidgetState.disabled) ? disabledFill : fill,
  ),
  foregroundColor: WidgetStateProperty.resolveWith(
    (states) => states.contains(WidgetState.disabled) ? disabledText : text,
  ),
  overlayColor: WidgetStateProperty.resolveWith((states) {
    if (states.contains(WidgetState.pressed)) {
      return text.withValues(alpha: _pressedLayerOpacity);
    }
    if (states.contains(WidgetState.hovered)) {
      return text.withValues(alpha: _hoverLayerOpacity);
    }
    return Colors.transparent;
  }),
  side: WidgetStateProperty.resolveWith(
    (states) =>
        states.contains(WidgetState.focused) ? _focusRing(focusRing) : null,
  ),
  shape: const WidgetStatePropertyAll(StadiumBorder()),
  elevation: const WidgetStatePropertyAll(0),
  shadowColor: const WidgetStatePropertyAll(Colors.transparent),
  surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
  textStyle: WidgetStatePropertyAll(label),
  padding: const WidgetStatePropertyAll(
    EdgeInsets.symmetric(
      horizontal: DocketSpace.s24,
      vertical: DocketSpace.s12,
    ),
  ),
  minimumSize: const WidgetStatePropertyAll(
    Size(DocketSpace.s48, DocketSpace.s48),
  ),
  tapTargetSize: MaterialTapTargetSize.padded,
  animationDuration: DocketMotion.press,
  splashFactory: NoSplash.splashFactory,
);

InputDecorationThemeData _inputTheme(_Roles roles, TextTheme textTheme) {
  const shape = BorderRadius.all(Radius.circular(DocketRadius.input));
  const borderless = OutlineInputBorder(
    borderRadius: shape,
    borderSide: BorderSide.none,
  );
  final ring = OutlineInputBorder(
    borderRadius: shape,
    borderSide: BorderSide(color: roles.focusRing, width: 2),
  );
  final soft = textTheme.bodyLarge?.copyWith(color: roles.textSoft);

  return InputDecorationThemeData(
    filled: true,
    fillColor: roles.field,
    hoverColor: Colors.transparent,
    focusColor: Colors.transparent,
    border: borderless,
    enabledBorder: borderless,
    disabledBorder: borderless,
    errorBorder: borderless,
    focusedBorder: ring,
    focusedErrorBorder: ring,
    contentPadding: const EdgeInsets.symmetric(
      horizontal: DocketSpace.s16,
      vertical: DocketSpace.s16,
    ),
    floatingLabelBehavior: FloatingLabelBehavior.never,
    labelStyle: soft,
    hintStyle: soft,
    helperStyle: textTheme.bodySmall?.copyWith(color: roles.textSoft),
    errorStyle: textTheme.bodySmall?.copyWith(color: roles.errorText),
    prefixIconColor: roles.textSoft,
    suffixIconColor: roles.textSoft,
  );
}

MenuStyle _menuStyle(_Roles roles) => MenuStyle(
  backgroundColor: WidgetStatePropertyAll(roles.field),
  elevation: const WidgetStatePropertyAll(0),
  shadowColor: const WidgetStatePropertyAll(Colors.transparent),
  surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
  shape: const WidgetStatePropertyAll(RoundedRectangleBorder()),
);
