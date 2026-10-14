import 'package:flutter/material.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../../client.dart';

/// Serverpod's SignInWidget on the page's left axis, with type sized for
/// its fixed 330 px form.
///
/// The widget pads itself by 24 and centers a 400 wide column, so it's
/// pulled back by that padding. Its forms have a fixed height, so inside it
/// the type steps down to Material's sizes and text scaling stops at 1.5,
/// which keeps the password rules and the button from being cut off.
class SignInPanel extends StatelessWidget {
  const SignInPanel({super.key});

  static const _ownPadding = 24.0;
  static const _ownWidth = 400.0;
  static const _maxTextScale = 1.5;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = theme.textTheme;
    final fitted = theme.copyWith(
      textTheme: text.copyWith(
        headlineMedium: text.headlineMedium?.copyWith(fontSize: 26),
        bodyLarge: text.bodyLarge?.copyWith(fontSize: 16, height: 1.4),
        bodyMedium: text.bodyMedium?.copyWith(fontSize: 16, height: 1.4),
        bodySmall: text.bodySmall?.copyWith(fontSize: 13, height: 1.3),
        labelLarge: text.labelLarge?.copyWith(fontSize: 16),
      ),
    );
    return Transform.translate(
      offset: const Offset(-_ownPadding, 0),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: _ownWidth + 2 * _ownPadding,
        ),
        child: MediaQuery.withClampedTextScaling(
          maxScaleFactor: _maxTextScale,
          child: Theme(
            data: fitted,
            child: SignInWidget(client: client),
          ),
        ),
      ),
    );
  }
}
