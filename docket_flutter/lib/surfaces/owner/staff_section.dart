import 'package:docket_client/docket_client.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../client.dart';
import '../../shared/strings.dart';
import '../../shared/theme/tokens.dart';
import '../../shared/widgets/progress_line.dart';
import 'browser.dart';
import 'owner_access.dart';
import 'owner_logic.dart';
import 'owner_widgets.dart';

/// Invites with a copyable link and expiry, the staff list, and
/// deactivation with a confirmation.
class StaffSection extends StatefulWidget {
  const StaffSection({
    super.key,
    required this.access,
    required this.view,
    required this.base,
  });

  final OwnerAccess access;
  final OwnerView view;
  final String base;

  @override
  State<StaffSection> createState() => _StaffSectionState();
}

class _StaffSectionState extends State<StaffSection> {
  StaffRole _role = StaffRole.desk;
  StaffInviteView? _invite;
  bool _inviting = false;
  String? _inviteError;
  List<StaffMember>? _staff;
  String? _listError;

  OwnerAccess get _access => widget.access;

  @override
  void initState() {
    super.initState();
    _loadStaff();
  }

  Future<void> _loadStaff() async {
    try {
      final staff = await client.owner.listStaff(
        _access.clinicId,
        _access.sandboxToken,
      );
      if (mounted) {
        setState(() {
          _staff = staff;
          _listError = null;
        });
      }
    } on Object catch (e) {
      if (mounted) setState(() => _listError = messageOf(e));
    }
  }

  Future<void> _createInvite() async {
    setState(() {
      _inviting = true;
      _inviteError = null;
    });
    try {
      final invite = await client.owner.createInvite(
        _access.clinicId,
        _role,
        _access.sandboxToken,
      );
      if (mounted) setState(() => _invite = invite);
    } on Object catch (e) {
      if (mounted) setState(() => _inviteError = messageOf(e));
    } finally {
      if (mounted) setState(() => _inviting = false);
    }
  }

  Future<void> _deactivate(StaffMember member) async {
    final sure = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(OwnerStrings.deactivateTitle(member.displayName)),
        content: const Text(OwnerStrings.deactivateBody),
        actions: [
          DocketButton(
            onPressed: () => Navigator.of(context).pop(false),
            label: OwnerStrings.cancel,
            icon: LucideIcons.x,
          ),
          DocketButton(
            onPressed: () => Navigator.of(context).pop(true),
            label: OwnerStrings.deactivate,
            icon: LucideIcons.userX,
            filled: true,
          ),
        ],
      ),
    );
    if (sure != true || !mounted) return;
    try {
      await client.owner.deactivateStaff(
        _access.clinicId,
        member.id!,
        _access.sandboxToken,
      );
      if (!mounted) return;
      announce(context, OwnerStrings.wasDeactivated(member.displayName));
      await _loadStaff();
    } on Object catch (e) {
      if (mounted) setState(() => _listError = messageOf(e));
    }
  }

  /// The server refuses to deactivate the last active owner, so the button
  /// isn't offered.
  static bool _isLastOwner(StaffMember member, List<StaffMember> staff) =>
      member.role == StaffRole.owner &&
      staff.where((m) => m.active && m.role == StaffRole.owner).length == 1;

  String _roleName(StaffRole role) => switch (role) {
    StaffRole.desk => OwnerStrings.roleDesk,
    StaffRole.owner => OwnerStrings.roleOwner,
  };

  @override
  Widget build(BuildContext context) {
    final invite = _invite;
    final inviteError = _inviteError;
    final staff = _staff;
    final listError = _listError;
    final text = Theme.of(context).textTheme;
    final desk = '${widget.base}/desk';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const GroupTitle(OwnerStrings.inviteTitle),
        const SizedBox(height: DocketSpace.s4),
        const Explanation(OwnerStrings.inviteExplain),
        const SizedBox(height: DocketSpace.s16),
        Wrap(
          spacing: DocketSpace.s8,
          runSpacing: DocketSpace.s8,
          children: [
            for (final role in [StaffRole.desk, StaffRole.owner])
              ChoicePill(
                label: _roleName(role),
                selected: _role == role,
                onSelected: () => setState(() {
                  _role = role;
                  _invite = null;
                }),
              ),
          ],
        ),
        const SizedBox(height: DocketSpace.s8),
        Explanation(
          _role == StaffRole.desk
              ? OwnerStrings.roleDeskExplain
              : OwnerStrings.roleOwnerExplain,
        ),
        const SizedBox(height: DocketSpace.s16),
        if (invite == null)
          Align(
            alignment: Alignment.centerLeft,
            child: DocketButton(
              onPressed: _inviting ? null : _createInvite,
              label: OwnerStrings.createInvite,
              icon: LucideIcons.userPlus,
              filled: true,
            ),
          )
        else
          LinkBlock(
            title: OwnerStrings.inviteFor(_roleName(invite.role)),
            url: invite.inviteUrl,
            onOpen: () => Browser.openInNewTab(invite.inviteUrl),
            note: OwnerStrings.inviteExpires(
              Browser.dayAndTimeIn(
                widget.view.clinic.timezone,
                invite.expiresAt,
              ),
            ),
          ),
        if (inviteError != null) ...[
          const SizedBox(height: DocketSpace.s12),
          ErrorLine(inviteError),
        ],
        const SizedBox(height: DocketSpace.s24),
        Text(
          OwnerStrings.deskAt(desk),
          style: text.bodyMedium?.copyWith(color: softText(context)),
        ),
        const SizedBox(height: groupGap),
        const GroupTitle(OwnerStrings.staffList),
        const SizedBox(height: DocketSpace.s16),
        if (listError != null) ...[
          ErrorLine(listError),
          const SizedBox(height: DocketSpace.s12),
        ],
        if (staff == null && listError == null)
          const DocketProgressLine(semanticsLabel: OwnerStrings.loading),
        if (staff != null && staff.isEmpty)
          const Explanation(OwnerStrings.noStaff),
        if (staff != null)
          for (final member in staff)
            Padding(
              padding: const EdgeInsets.only(bottom: DocketSpace.s16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: MergeSemantics(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            member.displayName,
                            style: text.titleMedium,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            member.active
                                ? _roleName(member.role)
                                : '${_roleName(member.role)}. '
                                      '${OwnerStrings.deactivated}',
                            style: text.bodyMedium?.copyWith(
                              color: softText(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (member.active && !_isLastOwner(member, staff))
                    DocketButton(
                      onPressed: () => _deactivate(member),
                      label: OwnerStrings.deactivate,
                      icon: LucideIcons.userX,
                    ),
                ],
              ),
            ),
      ],
    );
  }
}
