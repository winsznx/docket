import 'package:docket_client/docket_client.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../client.dart';
import '../../shared/strings.dart';
import '../../shared/theme/tokens.dart';
import 'browser.dart';
import 'owner_access.dart';
import 'owner_logic.dart';
import 'owner_widgets.dart';

/// One poster per line, an A4 PDF made on the server, opened in a new tab
/// to print.
class PostersSection extends StatelessWidget {
  const PostersSection({super.key, required this.view, required this.base});

  final OwnerView view;
  final String base;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const GroupTitle(OwnerStrings.postersTitle),
        const SizedBox(height: DocketSpace.s4),
        const Explanation(OwnerStrings.postersLead),
        const SizedBox(height: DocketSpace.s16),
        if (view.lines.isEmpty) const Explanation(OwnerStrings.noLines),
        for (final line in view.lines)
          Padding(
            padding: const EdgeInsets.only(bottom: DocketSpace.s8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: DocketButton(
                onPressed: () => Browser.openInNewTab(
                  posterUrl(base, view.clinic.slug, line.code),
                ),
                label: OwnerStrings.posterFor(line.name, line.code),
                icon: LucideIcons.printer,
              ),
            ),
          ),
      ],
    );
  }
}

/// The board link, when it's known, and rotating it with a warning that
/// the old screen stops working.
class BoardSection extends StatefulWidget {
  const BoardSection({
    super.key,
    required this.access,
    required this.onRotated,
  });

  final OwnerAccess access;
  final ValueChanged<String> onRotated;

  @override
  State<BoardSection> createState() => _BoardSectionState();
}

class _BoardSectionState extends State<BoardSection> {
  bool _busy = false;
  String? _error;

  Future<void> _rotate() async {
    final sure = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(OwnerStrings.rotateTitle),
        content: const Text(OwnerStrings.rotateWarning),
        actions: [
          DocketButton(
            onPressed: () => Navigator.of(context).pop(false),
            label: OwnerStrings.cancel,
            icon: LucideIcons.x,
          ),
          DocketButton(
            onPressed: () => Navigator.of(context).pop(true),
            label: OwnerStrings.rotateConfirm,
            icon: LucideIcons.rotateCcw,
            filled: true,
          ),
        ],
      ),
    );
    if (sure != true || !mounted) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final url = await client.owner.rotateBoardToken(
        widget.access.clinicId,
        widget.access.sandboxToken,
      );
      if (!mounted) return;
      widget.onRotated(url);
      announce(context, OwnerStrings.boardRotated);
    } on Object catch (e) {
      if (mounted) setState(() => _error = messageOf(e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final url = widget.access.boardUrl;
    final error = _error;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const GroupTitle(OwnerStrings.boardLinkTitle),
        const SizedBox(height: DocketSpace.s4),
        const Explanation(OwnerStrings.boardLead),
        const SizedBox(height: DocketSpace.s16),
        if (url != null)
          LinkBlock(url: url, onOpen: () => Browser.openInNewTab(url))
        else
          const Explanation(OwnerStrings.boardHidden),
        const SizedBox(height: DocketSpace.s32),
        const Explanation(OwnerStrings.rotateWarning),
        const SizedBox(height: DocketSpace.s12),
        Align(
          alignment: Alignment.centerLeft,
          child: DocketButton(
            onPressed: _busy ? null : _rotate,
            label: OwnerStrings.rotateBoard,
            icon: LucideIcons.rotateCcw,
          ),
        ),
        if (error != null) ...[
          const SizedBox(height: DocketSpace.s12),
          ErrorLine(error),
        ],
      ],
    );
  }
}
