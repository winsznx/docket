import 'dart:async';

import 'package:docket_client/docket_client.dart' hide Notification;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:web/web.dart' as web;

import '../../client.dart';
import '../../shared/sandbox_store.dart';
import '../../shared/strings.dart';
import '../../shared/theme/tokens.dart';
import '../../shared/widgets/progress_line.dart';
import 'desk_access.dart';
import 'desk_errors.dart';
import 'desk_workspace.dart';
import 'offline/app_shell_worker.dart';
import 'offline/desk_store.dart';
import 'widgets/desk_parts.dart';

/// `/desk`: a sandbox desk from `/try`, or a staff desk after sign-in, a
/// clinic pick and a room pick (PRD 17.3).
class DeskScreen extends StatefulWidget {
  const DeskScreen({super.key});

  @override
  State<DeskScreen> createState() => _DeskScreenState();
}

class _DeskScreenState extends State<DeskScreen> {
  SandboxStart? _sandbox = SandboxStore.read();
  List<Membership>? _memberships;
  UuidValue? _clinicId;
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    unawaited(registerAppShellWorker());
    client.auth.authInfoListenable.addListener(_onAuth);
    _onAuth();
  }

  @override
  void dispose() {
    client.auth.authInfoListenable.removeListener(_onAuth);
    super.dispose();
  }

  void _onAuth() {
    if (!mounted) return;
    if (!client.auth.isAuthenticated) {
      setState(() {
        _memberships = null;
        _clinicId = null;
      });
      return;
    }
    if (_sandbox == null && _memberships == null && !_loading) {
      unawaited(_loadClinics());
    }
  }

  Future<void> _loadClinics() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final memberships = await client.staff.myClinics();
      final remembered = (await _rememberedClinic())?.clinicId;
      if (!mounted) return;
      setState(() {
        _memberships = memberships;
        _clinicId = memberships.length == 1
            ? memberships.single.clinicId
            : memberships
                  .where((m) => m.clinicId == remembered)
                  .firstOrNull
                  ?.clinicId;
      });
    } on Exception catch (e) {
      if (!isTransient(e)) {
        if (mounted) setState(() => _error = errorText(e));
        return;
      }
      final offlineClinic = await _rememberedClinic();
      if (!mounted) return;
      setState(() {
        if (offlineClinic?.lastViewJson != null) {
          _memberships = const [];
          _clinicId = offlineClinic!.clinicId;
        } else {
          _error = DeskStrings.networkError;
        }
      });
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  /// The clinic this device last opened, so a reload during an outage can
  /// open the same desk from its saved view.
  Future<DeskMeta?> _rememberedClinic() async {
    try {
      final store = await DeskStore.open();
      return await store.meta();
    } on Object catch (e) {
      debugPrint('Desk storage unavailable while picking a clinic: $e');
      return null;
    }
  }

  void _leaveSandbox() {
    SandboxStore.clear();
    setState(() => _sandbox = null);
    _onAuth();
  }

  Future<void> _signOut() async {
    await client.auth.signOutDevice();
    if (mounted) {
      setState(() {
        _memberships = null;
        _clinicId = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final sandbox = _sandbox;
    if (sandbox != null) {
      return DeskWorkspace(
        key: ValueKey(sandbox.clinicId),
        access: DeskAccess.sandbox(sandbox),
        session: [
          DeskSessionAction(
            DeskStrings.leaveSandbox,
            LucideIcons.logOut,
            _leaveSandbox,
          ),
        ],
        fatalAction: PrimaryPill(
          label: DeskStrings.sandboxGone,
          icon: LucideIcons.play,
          onPressed: () {
            SandboxStore.clear();
            context.go('/try');
          },
        ),
      );
    }

    final clinicId = _clinicId;
    if (client.auth.isAuthenticated && clinicId != null) {
      final many = (_memberships?.length ?? 0) > 1;
      final signOut = TonalPill(
        label: DeskStrings.signOut,
        icon: LucideIcons.logOut,
        onPressed: _signOut,
      );
      return DeskWorkspace(
        key: ValueKey(clinicId),
        access: DeskAccess.staff(clinicId),
        session: [
          if (many)
            DeskSessionAction(
              DeskStrings.switchClinic,
              LucideIcons.building2,
              () => setState(() => _clinicId = null),
            ),
          DeskSessionAction(DeskStrings.signOut, LucideIcons.logOut, _signOut),
        ],
        fatalAction: signOut,
      );
    }

    return Scaffold(body: SafeArea(child: _entry(context)));
  }

  Widget _entry(BuildContext context) {
    final theme = Theme.of(context);
    final text = theme.textTheme;
    if (!client.auth.isAuthenticated) {
      return _Page(
        children: [
          _Title(DeskStrings.signInTitle, body: DeskStrings.signInBody),
          // Staff arrive with an account from their invite, so the email
          // form opens on sign-in. In dark mode its links take the page's
          // text color, since the theme's primary is registerLift there.
          Theme(
            data: theme.copyWith(
              colorScheme: theme.colorScheme.copyWith(
                primary: theme.colorScheme.onSurface,
              ),
            ),
            child: SignInWidget(
              client: client,
              onAuthenticated: _onAuth,
              emailSignInWidget: EmailSignInWidget(
                client: client,
                startScreen: EmailFlowScreen.login,
                onAuthenticated: _onAuth,
              ),
            ),
          ),
          const SizedBox(height: DocketSpace.s24),
          Align(
            alignment: Alignment.centerLeft,
            child: TonalPill(
              label: DeskStrings.tryInstead,
              onPressed: () => context.go('/try'),
            ),
          ),
        ],
      );
    }
    if (_error case final error?) {
      return _Page(
        children: [
          Semantics(
            container: true,
            liveRegion: true,
            child: Text(error, style: text.headlineMedium),
          ),
          const SizedBox(height: DocketSpace.s24),
          Wrap(
            spacing: DocketSpace.s12,
            runSpacing: DocketSpace.s12,
            children: [
              PrimaryPill(
                label: DeskStrings.retry,
                icon: LucideIcons.refreshCw,
                onPressed: _loadClinics,
              ),
              TonalPill(
                label: DeskStrings.signOut,
                icon: LucideIcons.logOut,
                onPressed: _signOut,
              ),
            ],
          ),
        ],
      );
    }
    final memberships = _memberships;
    if (memberships == null) {
      return const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DocketProgressLine(semanticsLabel: DeskStrings.loadingClinics),
        ],
      );
    }
    if (memberships.isEmpty) {
      return _Page(
        children: [
          const _Title(
            DeskStrings.noClinicsTitle,
            body: DeskStrings.noClinicsBody,
          ),
          Wrap(
            spacing: DocketSpace.s12,
            runSpacing: DocketSpace.s12,
            children: [
              PrimaryPill(
                label: DeskStrings.setUpClinic,
                icon: LucideIcons.building2,
                onPressed: () => web.window.location.assign('/owner'),
              ),
              TonalPill(
                label: DeskStrings.signOut,
                icon: LucideIcons.logOut,
                onPressed: _signOut,
              ),
            ],
          ),
        ],
      );
    }
    return _Page(
      children: [
        const _Title(DeskStrings.pickClinicTitle),
        for (final m in memberships) ...[
          Align(
            alignment: Alignment.centerLeft,
            child: TonalPill(
              label: m.clinicName,
              onPressed: () => setState(() => _clinicId = m.clinicId),
            ),
          ),
          const SizedBox(height: DocketSpace.s12),
        ],
        const SizedBox(height: DocketSpace.s12),
        Align(
          alignment: Alignment.centerLeft,
          child: TonalPill(
            label: DeskStrings.signOut,
            icon: LucideIcons.logOut,
            onPressed: _signOut,
          ),
        ),
      ],
    );
  }
}

class _Page extends StatelessWidget {
  const _Page({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.topLeft,
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 640),
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(DocketSpace.s24),
        children: children,
      ),
    ),
  );
}

class _Title extends StatelessWidget {
  const _Title(this.title, {this.body});

  final String title;
  final String? body;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: DocketSpace.s24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
            container: true,
            header: true,
            child: Text(title, style: text.headlineLarge),
          ),
          if (body != null) ...[
            const SizedBox(height: DocketSpace.s12),
            Text(body!, style: text.bodyLarge),
          ],
        ],
      ),
    );
  }
}
