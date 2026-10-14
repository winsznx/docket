import 'package:docket_client/docket_client.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../client.dart';
import '../../shared/strings.dart';
import '../../shared/theme/tokens.dart';
import '../../shared/widgets/progress_line.dart';
import 'audit_section.dart';
import 'browser.dart';
import 'lines_rooms_section.dart';
import 'links_sections.dart';
import 'owner_access.dart';
import 'owner_logic.dart';
import 'owner_widgets.dart';
import 'reports_section.dart';
import 'settings_section.dart';
import 'staff_section.dart';
import 'today_section.dart';

enum _Section {
  today(OwnerStrings.today),
  settings(OwnerStrings.settings),
  linesAndRooms(OwnerStrings.linesAndRooms),
  staff(OwnerStrings.staff),
  posters(OwnerStrings.posters),
  board(OwnerStrings.board),
  reports(OwnerStrings.reports),
  audit(OwnerStrings.audit);

  const _Section(this.label);

  final String label;
}

/// Everything an owner runs once the clinic exists, one section at a time
/// in a single column (DESIGN.md 5.6).
class OwnerConsole extends StatefulWidget {
  const OwnerConsole({
    super.key,
    required this.access,
    required this.onSwitchClinic,
    this.onSignOut,
  });

  final OwnerAccess access;
  final VoidCallback onSwitchClinic;
  final VoidCallback? onSignOut;

  @override
  State<OwnerConsole> createState() => _OwnerConsoleState();
}

class _OwnerConsoleState extends State<OwnerConsole> {
  _Section _section = _Section.today;
  OwnerView? _view;
  String? _error;
  String _base = Browser.origin;

  OwnerAccess get _access => widget.access;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _error = null);
    try {
      final view = await client.owner.getOwnerView(
        _access.clinicId,
        _access.sandboxToken,
      );
      final known = _access.boardUrl;
      final base = known != null
          ? Uri.parse(known).origin
          : await _publicBase();
      if (!mounted) return;
      setState(() {
        _view = view;
        _base = base;
      });
    } on Object catch (e) {
      if (mounted) setState(() => _error = messageOf(e));
    }
  }

  /// The address patients join at, from the server's own join link, so
  /// desk and poster links point at the public site.
  Future<String> _publicBase() async {
    try {
      final desk = await client.desk.getView(
        _access.clinicId,
        _access.sandboxToken,
      );
      return Uri.parse(desk.joinUrl).origin;
    } on Object catch (e) {
      debugPrint('Using this page for links, the join link failed: $e');
      return Browser.origin;
    }
  }

  void _replaceView(OwnerView view) => setState(() => _view = view);

  @override
  Widget build(BuildContext context) {
    final view = _view;
    final error = _error;
    final text = Theme.of(context).textTheme;
    final onSignOut = widget.onSignOut;

    if (view == null) {
      return OwnerPage(
        children: [
          PageTitle(
            _access.isSandbox ? OwnerStrings.loading : _access.clinicName,
          ),
          const SizedBox(height: DocketSpace.s24),
          if (error == null)
            const DocketProgressLine(semanticsLabel: OwnerStrings.loading)
          else ...[
            ErrorLine(error),
            const SizedBox(height: DocketSpace.s12),
            Wrap(
              spacing: DocketSpace.s12,
              children: [
                DocketButton(
                  onPressed: _load,
                  label: OwnerStrings.tryAgain,
                  icon: LucideIcons.refreshCw,
                  filled: true,
                ),
                DocketButton(
                  onPressed: widget.onSwitchClinic,
                  label: OwnerStrings.switchClinic,
                  icon: LucideIcons.building2,
                ),
              ],
            ),
          ],
        ],
      );
    }

    final dayState = switch (view.day) {
      DayState.open => OwnerStrings.dayOpen,
      DayState.closed => OwnerStrings.dayClosed,
      null => OwnerStrings.dayNotOpened,
    };

    return OwnerPage(
      top: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PageTitle(view.clinic.name),
          const SizedBox(height: DocketSpace.s8),
          Text(readableDate(view.serviceDate), style: text.bodyLarge),
          Text(
            dayState,
            style: text.bodyLarge?.copyWith(color: softText(context)),
          ),
          if (_access.isSandbox) ...[
            const SizedBox(height: DocketSpace.s8),
            const Explanation(OwnerStrings.sandboxNote),
          ],
          const SizedBox(height: DocketSpace.s8),
          Wrap(
            spacing: DocketSpace.s8,
            children: [
              if (_access.isSandbox && onSignOut == null)
                DocketButton(
                  onPressed: widget.onSwitchClinic,
                  label: OwnerStrings.signInForReal,
                  icon: LucideIcons.logIn,
                )
              else
                DocketButton(
                  onPressed: widget.onSwitchClinic,
                  label: OwnerStrings.switchClinic,
                  icon: LucideIcons.building2,
                ),
              if (onSignOut != null)
                DocketButton(
                  onPressed: onSignOut,
                  label: OwnerStrings.signOut,
                  icon: LucideIcons.logOut,
                ),
            ],
          ),
          const SizedBox(height: DocketSpace.s24),
          Semantics(
            label: OwnerStrings.sections,
            container: true,
            child: Wrap(
              spacing: DocketSpace.s8,
              runSpacing: DocketSpace.s8,
              children: [
                for (final s in _Section.values)
                  ChoicePill(
                    label: s.label,
                    selected: s == _section,
                    onSelected: () => setState(() => _section = s),
                  ),
              ],
            ),
          ),
          const SizedBox(height: groupGap),
        ],
      ),
      children: [
        KeyedSubtree(
          key: ValueKey(_section),
          child: switch (_section) {
            _Section.today => TodaySection(access: _access, view: view),
            _Section.settings => SettingsSection(
              access: _access,
              view: view,
              onSaved: _load,
            ),
            _Section.linesAndRooms => LinesRoomsSection(
              access: _access,
              view: view,
              onChanged: _replaceView,
            ),
            _Section.staff => StaffSection(
              access: _access,
              view: view,
              base: _base,
            ),
            _Section.posters => PostersSection(view: view, base: _base),
            _Section.board => BoardSection(
              access: _access,
              onRotated: (url) => setState(() {
                _access.boardUrl = url;
                _base = Uri.parse(url).origin;
              }),
            ),
            _Section.reports => ReportsSection(access: _access, view: view),
            _Section.audit => AuditSection(access: _access, view: view),
          },
        ),
      ],
    );
  }
}
