import 'package:docket_client/docket_client.dart' hide Notification;
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:web/web.dart' as web;

import '../../../shared/strings.dart';
import '../../../shared/theme/tokens.dart';
import '../../../shared/widgets/progress_line.dart';
import '../desk_errors.dart';
import 'desk_parts.dart';

/// The `/try` side panel: the join QR for the visitor's own phone, demo
/// patients, and the waiting-room board (PRD 17.6).
class SandboxPanel extends StatefulWidget {
  const SandboxPanel({
    super.key,
    required this.sandbox,
    required this.joinUrl,
    required this.online,
    required this.onAddDemo,
  });

  final SandboxStart sandbox;
  final String joinUrl;
  final bool online;

  /// Adds the demo patients and completes once the desk shows them.
  final Future<void> Function() onAddDemo;

  @override
  State<SandboxPanel> createState() => _SandboxPanelState();
}

class _SandboxPanelState extends State<SandboxPanel> {
  bool _adding = false;
  String? _error;

  Future<void> _addDemo() async {
    setState(() {
      _adding = true;
      _error = null;
    });
    String? error;
    try {
      await widget.onAddDemo();
    } on Exception catch (e) {
      error = errorText(e);
    }
    if (!mounted) return;
    setState(() {
      _adding = false;
      _error = error;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const DeskHeading(DeskStrings.sandboxTitle),
        const SizedBox(height: DocketSpace.s8),
        Text(DeskStrings.sandboxBody, style: theme.textTheme.bodyMedium),
        const SizedBox(height: DocketSpace.s16),
        DeskQr(
          data: widget.joinUrl,
          size: 168,
          semanticsLabel: DeskStrings.joinQrSemantics,
        ),
        const SizedBox(height: DocketSpace.s12),
        SelectableText(
          widget.joinUrl,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: DocketSpace.s24),
        if (_adding) ...[
          const DocketProgressLine(semanticsLabel: DeskStrings.addingDemo),
          const SizedBox(height: DocketSpace.s8),
        ],
        Wrap(
          spacing: DocketSpace.s12,
          runSpacing: DocketSpace.s12,
          children: [
            TonalPill(
              icon: LucideIcons.users,
              label: widget.online
                  ? (_adding ? DeskStrings.addingDemo : DeskStrings.addDemo)
                  : DeskStrings.needsConnection,
              onPressed: widget.online && !_adding ? _addDemo : null,
            ),
            TonalPill(
              label: DeskStrings.openBoard,
              icon: LucideIcons.monitor,
              onPressed: () =>
                  web.window.open(widget.sandbox.boardUrl, '_blank'),
            ),
          ],
        ),
        if (_error != null) ...[
          const SizedBox(height: DocketSpace.s12),
          Semantics(
            container: true,
            liveRegion: true,
            child: Text(_error!, style: theme.textTheme.bodyMedium),
          ),
        ],
      ],
    );
  }
}
