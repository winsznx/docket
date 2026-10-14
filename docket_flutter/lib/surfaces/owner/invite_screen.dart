import 'package:docket_client/docket_client.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../../client.dart';
import '../../shared/strings.dart';
import '../../shared/theme/tokens.dart';
import '../../shared/widgets/progress_line.dart';
import 'owner_logic.dart';
import 'owner_widgets.dart';
import 'sign_in_panel.dart';

/// A staff invite at `/invite/<code>`: sign in, accept, then go to the desk
/// or the console. A used or expired invite shows the server's message.
class InviteScreen extends StatefulWidget {
  const InviteScreen({super.key, required this.code});

  final String code;

  @override
  State<InviteScreen> createState() => _InviteScreenState();
}

class _InviteScreenState extends State<InviteScreen> {
  bool _restored = false;
  bool _accepting = false;
  Membership? _membership;
  String? _error;

  @override
  void initState() {
    super.initState();
    client.auth.authInfoListenable.addListener(_authChanged);
    client.auth.restore().whenComplete(() {
      if (!mounted) return;
      setState(() => _restored = true);
      _authChanged();
    });
  }

  @override
  void dispose() {
    client.auth.authInfoListenable.removeListener(_authChanged);
    super.dispose();
  }

  void _authChanged() {
    if (!mounted || !_restored) return;
    if (client.auth.isAuthenticated) {
      _accept();
    } else {
      setState(() {});
    }
  }

  Future<void> _accept() async {
    if (_accepting || _membership != null || _error != null) return;
    setState(() => _accepting = true);
    try {
      final membership = await client.staff.acceptInvite(widget.code);
      if (!mounted) return;
      setState(() => _membership = membership);
      announce(
        context,
        OwnerStrings.joinedAs(
          membership.clinicName,
          _roleName(membership.role),
        ),
        snack: false,
      );
    } on Object catch (e) {
      if (mounted) setState(() => _error = messageOf(e));
    } finally {
      if (mounted) setState(() => _accepting = false);
    }
  }

  static String _roleName(StaffRole role) => switch (role) {
    StaffRole.owner => OwnerStrings.roleOwnerName,
    StaffRole.desk => OwnerStrings.roleDeskName,
  };

  @override
  Widget build(BuildContext context) {
    final membership = _membership;
    final error = _error;
    if (!_restored) {
      return const Scaffold(
        body: Align(
          alignment: Alignment.topCenter,
          child: DocketProgressLine(semanticsLabel: OwnerStrings.loading),
        ),
      );
    }
    if (!client.auth.isAuthenticated) {
      return OwnerPage(
        children: [
          const PageTitle(OwnerStrings.inviteSignInTitle),
          const SizedBox(height: DocketSpace.s12),
          const Explanation(OwnerStrings.inviteSignInLead),
          const SizedBox(height: DocketSpace.s16),
          Align(
            alignment: Alignment.topLeft,
            child: const SignInPanel(),
          ),
        ],
      );
    }
    return OwnerPage(
      children: [
        const PageTitle(OwnerStrings.inviteSignInTitle),
        const SizedBox(height: DocketSpace.s24),
        if (_accepting)
          const DocketProgressLine(semanticsLabel: OwnerStrings.accepting),
        if (error != null) ErrorLine(error),
        if (membership != null) ...[
          Text(
            OwnerStrings.joinedAs(
              membership.clinicName,
              _roleName(membership.role),
            ),
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: DocketSpace.s24),
          Wrap(
            spacing: DocketSpace.s12,
            runSpacing: DocketSpace.s12,
            children: [
              DocketButton(
                onPressed: () => context.go('/desk'),
                label: OwnerStrings.openDesk,
                icon: LucideIcons.monitor,
                filled: true,
              ),
              if (membership.role == StaffRole.owner)
                DocketButton(
                  onPressed: () => context.go('/owner'),
                  label: OwnerStrings.openOwnerConsole,
                  icon: LucideIcons.layoutDashboard,
                ),
            ],
          ),
        ],
      ],
    );
  }
}
