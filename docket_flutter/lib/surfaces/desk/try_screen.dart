import 'package:docket_client/docket_client.dart' hide Notification;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../client.dart';
import '../../shared/sandbox_store.dart';
import '../../shared/strings.dart';
import '../../shared/theme/tokens.dart';
import '../../shared/widgets/progress_line.dart';
import 'desk_errors.dart';
import 'widgets/desk_parts.dart';

/// `/try`: one decision, a throwaway clinic and its desk (PRD 17.6,
/// DESIGN 5.7).
class TryScreen extends StatefulWidget {
  const TryScreen({super.key});

  @override
  State<TryScreen> createState() => _TryScreenState();
}

class _TryScreenState extends State<TryScreen> {
  final SandboxStart? _existing = SandboxStore.read();
  bool _starting = false;
  String? _error;

  Future<void> _start() async {
    setState(() {
      _starting = true;
      _error = null;
    });
    String? error;
    try {
      final start = await client.sandbox.start();
      SandboxStore.save(start);
      if (mounted) context.go('/desk');
      return;
    } on Exception catch (e) {
      error = errorText(e);
    }
    if (!mounted) return;
    setState(() {
      _starting = false;
      _error = error;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final wide = MediaQuery.sizeOf(context).width >= 840;
    final statement = theme.textTheme.headlineLarge?.copyWith(
      fontSize: wide ? 48 : DocketType.headline,
      height: DocketType.headingLeading,
      fontWeight: DocketType.displayWeight,
    );
    final existing = _existing;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 2,
              child: _starting
                  ? const DocketProgressLine(
                      semanticsLabel: DeskStrings.tryLoading,
                    )
                  : null,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: wide ? DocketSpace.s64 : DocketSpace.s16,
                  vertical: wide ? DocketSpace.s96 : DocketSpace.s48,
                ),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 760),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Semantics(
                          container: true,
                          header: true,
                          child: Text(DeskStrings.tryTitle, style: statement),
                        ),
                        const SizedBox(height: DocketSpace.s16),
                        Text(
                          DeskStrings.tryBody,
                          style: theme.textTheme.bodyLarge,
                        ),
                        const SizedBox(height: DocketSpace.s48),
                        if (existing != null) ...[
                          Text(
                            DeskStrings.tryExisting(
                              existing.expiresAt
                                  .difference(DateTime.now().toUtc())
                                  .inHours,
                            ),
                            style: theme.textTheme.bodyLarge,
                          ),
                          const SizedBox(height: DocketSpace.s16),
                          _PrimaryButton(
                            icon: LucideIcons.play,
                            label: DeskStrings.tryReopen,
                            onPressed: _starting
                                ? null
                                : () => context.go('/desk'),
                          ),
                          const SizedBox(height: DocketSpace.s16),
                          TonalPill(
                            label: _starting
                                ? DeskStrings.tryStarting
                                : DeskStrings.tryStartFresh,
                            onPressed: _starting ? null : _start,
                          ),
                        ] else
                          _PrimaryButton(
                            icon: LucideIcons.play,
                            label: _starting
                                ? DeskStrings.tryStarting
                                : DeskStrings.tryStart,
                            onPressed: _starting ? null : _start,
                          ),
                        if (_error case final error?) ...[
                          const SizedBox(height: DocketSpace.s24),
                          Semantics(
                            container: true,
                            liveRegion: true,
                            child: Text(
                              error,
                              style: theme.textTheme.bodyLarge,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        minimumSize: const Size(0, 72),
        padding: const EdgeInsets.symmetric(
          horizontal: DocketSpace.s32,
          vertical: DocketSpace.s16,
        ),
        textStyle: Theme.of(
          context,
        ).textTheme.titleLarge?.copyWith(fontSize: 22),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 24),
          const SizedBox(width: DocketSpace.s12),
          Flexible(child: Text(label)),
        ],
      ),
    );
  }
}
