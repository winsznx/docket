import 'package:docket_client/docket_client.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../../client.dart';
import '../../shared/sandbox_store.dart';
import '../../shared/strings.dart';
import '../../shared/theme/tokens.dart';
import '../../shared/widgets/progress_line.dart';
import 'owner_access.dart';
import 'owner_console.dart';
import 'owner_logic.dart';
import 'owner_widgets.dart';
import 'sign_in_panel.dart';
import 'setup_wizard.dart';

/// The owner console at `/owner`: sign in, pick or set up a clinic, then
/// run it (PRD 17.5). A visitor with a sandbox from `/try` arrives straight
/// in their sandbox clinic.
class OwnerScreen extends StatefulWidget {
  const OwnerScreen({super.key});

  @override
  State<OwnerScreen> createState() => _OwnerScreenState();
}

class _OwnerScreenState extends State<OwnerScreen> {
  final SandboxStart? _sandbox = SandboxStore.read();
  bool _restored = false;
  bool _wantsSignIn = false;
  bool _settingUp = false;
  bool _picked = false;
  List<Membership>? _memberships;
  String? _error;
  OwnerAccess? _open;

  bool get _signedIn => client.auth.isAuthenticated;

  @override
  void initState() {
    super.initState();
    client.auth.authInfoListenable.addListener(_authChanged);
    client.auth.restore().whenComplete(() {
      if (!mounted) return;
      setState(() => _restored = true);
      if (_signedIn) _loadMemberships();
    });
  }

  @override
  void dispose() {
    client.auth.authInfoListenable.removeListener(_authChanged);
    super.dispose();
  }

  void _authChanged() {
    if (!mounted) return;
    if (_signedIn) {
      _loadMemberships();
    } else {
      setState(() {
        _memberships = null;
        _picked = false;
        if (_open?.isSandbox != true) _open = null;
      });
    }
  }

  Future<void> _loadMemberships() async {
    setState(() => _error = null);
    try {
      final all = await client.staff.myClinics();
      if (!mounted) return;
      setState(() {
        _memberships = all;
        final owned = all.where((m) => m.role == StaffRole.owner).toList();
        if (!_picked &&
            _open == null &&
            owned.length == 1 &&
            _sandbox == null) {
          _open = OwnerAccess(
            clinicId: owned.single.clinicId,
            clinicName: owned.single.clinicName,
          );
        }
      });
    } on Object catch (e) {
      if (mounted) setState(() => _error = messageOf(e));
    }
  }

  OwnerAccess _sandboxAccess(SandboxStart s) => OwnerAccess(
    clinicId: s.clinicId,
    clinicName: s.clinicSlug,
    sandboxToken: s.sandboxToken,
    boardUrl: s.boardUrl,
  );

  Future<void> _signOut() async {
    await client.auth.signOutDevice();
    if (!mounted) return;
    setState(() {
      _open = null;
      _picked = false;
      _wantsSignIn = false;
    });
  }

  void _switchClinic() => setState(() {
    _open = null;
    _picked = true;
    if (!_signedIn) _wantsSignIn = true;
  });

  @override
  Widget build(BuildContext context) {
    if (!_restored) {
      return const Scaffold(
        body: Align(
          alignment: Alignment.topCenter,
          child: DocketProgressLine(semanticsLabel: OwnerStrings.loading),
        ),
      );
    }
    final open = _open;
    if (open != null) {
      return OwnerConsole(
        key: ValueKey(open.clinicId),
        access: open,
        onSwitchClinic: _switchClinic,
        onSignOut: _signedIn ? _signOut : null,
      );
    }
    final sandbox = _sandbox;
    if (!_signedIn) {
      if (sandbox != null && !_wantsSignIn) {
        return OwnerConsole(
          access: _sandboxAccess(sandbox),
          onSwitchClinic: _switchClinic,
        );
      }
      return _SignInPage(
        onOpenSandbox: sandbox == null
            ? null
            : () => setState(() => _open = _sandboxAccess(sandbox)),
      );
    }
    if (_settingUp) {
      return SetupWizard(
        onCancel: () => setState(() => _settingUp = false),
        onDone: (access) {
          setState(() {
            _settingUp = false;
            _open = access;
          });
          _loadMemberships();
        },
      );
    }
    return _ClinicPicker(
      memberships: _memberships,
      error: _error,
      sandbox: sandbox,
      onRetry: _loadMemberships,
      onPick: (m) => setState(
        () =>
            _open = OwnerAccess(clinicId: m.clinicId, clinicName: m.clinicName),
      ),
      onPickSandbox: sandbox == null
          ? null
          : () => setState(() => _open = _sandboxAccess(sandbox)),
      onSetUp: () => setState(() => _settingUp = true),
      onSignOut: _signOut,
    );
  }
}

class _SignInPage extends StatelessWidget {
  const _SignInPage({required this.onOpenSandbox});

  final VoidCallback? onOpenSandbox;

  @override
  Widget build(BuildContext context) {
    final onOpenSandbox = this.onOpenSandbox;
    return OwnerPage(
      children: [
        const PageTitle(OwnerStrings.signInTitle),
        const SizedBox(height: DocketSpace.s12),
        const Explanation(OwnerStrings.signInLead),
        const SizedBox(height: DocketSpace.s16),
        Align(
          alignment: Alignment.topLeft,
          child: const SignInPanel(),
        ),
        if (onOpenSandbox != null) ...[
          const SizedBox(height: DocketSpace.s24),
          Align(
            alignment: Alignment.centerLeft,
            child: DocketButton(
              onPressed: onOpenSandbox,
              label: OwnerStrings.openSandbox,
              icon: LucideIcons.building2,
            ),
          ),
        ],
      ],
    );
  }
}

class _ClinicPicker extends StatelessWidget {
  const _ClinicPicker({
    required this.memberships,
    required this.error,
    required this.sandbox,
    required this.onRetry,
    required this.onPick,
    required this.onPickSandbox,
    required this.onSetUp,
    required this.onSignOut,
  });

  final List<Membership>? memberships;
  final String? error;
  final SandboxStart? sandbox;
  final VoidCallback onRetry;
  final ValueChanged<Membership> onPick;
  final VoidCallback? onPickSandbox;
  final VoidCallback onSetUp;
  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context) {
    final error = this.error;
    final all = memberships;
    final onPickSandbox = this.onPickSandbox;
    final text = Theme.of(context).textTheme;
    final owned = all?.where((m) => m.role == StaffRole.owner).toList() ?? [];
    final deskOnly =
        all?.where((m) => m.role == StaffRole.desk).toList() ?? const [];

    return OwnerPage(
      children: [
        const PageTitle(OwnerStrings.pickTitle),
        const SizedBox(height: DocketSpace.s12),
        Explanation(
          all != null && owned.isEmpty
              ? OwnerStrings.noClinicsYet
              : OwnerStrings.pickLead,
        ),
        const SizedBox(height: DocketSpace.s24),
        if (error != null) ...[
          ErrorLine(error),
          const SizedBox(height: DocketSpace.s12),
          Align(
            alignment: Alignment.centerLeft,
            child: DocketButton(
              onPressed: onRetry,
              label: OwnerStrings.tryAgain,
              icon: LucideIcons.refreshCw,
            ),
          ),
        ] else if (all == null)
          const DocketProgressLine(semanticsLabel: OwnerStrings.loading),
        for (final m in owned)
          _ClinicRow(title: m.clinicName, onTap: () => onPick(m)),
        if (onPickSandbox != null)
          _ClinicRow(
            title: sandbox!.clinicSlug,
            note: OwnerStrings.sandboxRowNote,
            onTap: onPickSandbox,
          ),
        const SizedBox(height: DocketSpace.s24),
        Align(
          alignment: Alignment.centerLeft,
          child: DocketButton(
            onPressed: onSetUp,
            label: OwnerStrings.setUpNew,
            icon: LucideIcons.plus,
            filled: true,
          ),
        ),
        for (final m in deskOnly) ...[
          const SizedBox(height: groupGap),
          Text(OwnerStrings.deskOnly(m.clinicName), style: text.bodyLarge),
          const SizedBox(height: DocketSpace.s8),
          Align(
            alignment: Alignment.centerLeft,
            child: DocketButton(
              onPressed: () => context.go('/desk'),
              label: OwnerStrings.openDesk,
              icon: LucideIcons.monitor,
            ),
          ),
        ],
        const SizedBox(height: groupGap),
        Align(
          alignment: Alignment.centerLeft,
          child: DocketButton(
            onPressed: onSignOut,
            label: OwnerStrings.signOut,
            icon: LucideIcons.logOut,
          ),
        ),
      ],
    );
  }
}

/// A tall row to open one clinic. No card, just space and a wash on hover.
class _ClinicRow extends StatelessWidget {
  const _ClinicRow({required this.title, required this.onTap, this.note});

  final String title;
  final String? note;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final note = this.note;
    return Semantics(
      container: true,
      button: true,
      label: note == null ? title : '$title. $note',
      onTap: onTap,
      child: ExcludeSemantics(
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(DocketRadius.input),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: DocketSpace.s12,
              vertical: DocketSpace.s16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: text.headlineSmall?.copyWith(fontSize: 24),
                ),
                if (note != null) ...[
                  const SizedBox(height: DocketSpace.s4),
                  Explanation(note),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
