import 'package:docket_client/docket_client.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter/services.dart';

import '../../client.dart';
import '../../shared/strings.dart';
import '../../shared/theme/tokens.dart';
import '../../shared/widgets/progress_line.dart';
import 'owner_access.dart';
import 'owner_logic.dart';
import 'owner_widgets.dart';

/// Every clinic setting from PRD 4.2, grouped, each with its range and a
/// one-line plain explanation. Saved together with `updateSettings`.
class SettingsSection extends StatefulWidget {
  const SettingsSection({
    super.key,
    required this.access,
    required this.view,
    required this.onSaved,
  });

  final OwnerAccess access;
  final OwnerView view;
  final VoidCallback onSaved;

  @override
  State<SettingsSection> createState() => _SettingsSectionState();
}

class _SettingsSectionState extends State<SettingsSection> {
  late final ClinicSettings _start = settingsOf(widget.view.clinic);
  late final Map<SettingSpec, TextEditingController> _numbers = {
    for (final (_, specs) in settingGroups)
      for (final spec in specs)
        spec: TextEditingController(text: '${spec.read(_start)}'),
    autoCloseSpec: TextEditingController(
      text: '${autoCloseSpec.read(_start)}',
    ),
  };
  late final _open = TextEditingController(text: _start.openTime);
  late final _cutoff = TextEditingController(text: _start.joinCutoffTime);
  late final _close = TextEditingController(text: _start.closeTime);
  late final _zone = TextEditingController(text: _start.timezone);
  late bool _sms = _start.smsEnabled;

  bool _tried = false;
  bool _saving = false;
  String? _serverError;

  @override
  void dispose() {
    for (final c in [..._numbers.values, _open, _cutoff, _close, _zone]) {
      c.dispose();
    }
    super.dispose();
  }

  String? _firstError() {
    for (final MapEntry(key: spec, value: c) in _numbers.entries) {
      final e = spec.validate(c.text);
      if (e != null) return e;
    }
    return validateHours(_open.text, _cutoff.text, _close.text) ??
        validateTimezone(_zone.text);
  }

  Future<void> _save() async {
    setState(() {
      _tried = true;
      _serverError = null;
    });
    final local = _firstError();
    if (local != null) {
      announce(context, local);
      return;
    }
    var settings = _start.copyWith(
      openTime: _open.text.trim(),
      joinCutoffTime: _cutoff.text.trim(),
      closeTime: _close.text.trim(),
      timezone: _zone.text.trim(),
      smsEnabled: _sms,
    );
    for (final MapEntry(key: spec, value: c) in _numbers.entries) {
      settings = spec.write(settings, int.parse(c.text.trim()));
    }
    setState(() => _saving = true);
    try {
      await client.owner.updateSettings(
        widget.access.clinicId,
        settings,
        widget.access.sandboxToken,
      );
      if (!mounted) return;
      announce(context, OwnerStrings.settingsSaved);
      widget.onSaved();
    } on Object catch (e) {
      if (mounted) setState(() => _serverError = messageOf(e));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Widget _number(SettingSpec spec) {
    final c = _numbers[spec]!;
    return LabeledField(
      label: spec.label,
      explanation: '${spec.explanation} ${spec.rangeText}',
      controller: c,
      width: 200,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      maxLength: 4,
      suffix: spec.unit,
      onChanged: (_) => setState(() {}),
      error: _tried ? spec.validate(c.text) : null,
    );
  }

  Widget _time(String label, String explanation, TextEditingController c) =>
      LabeledField(
        label: label,
        explanation: '$explanation ${OwnerStrings.timeFormat}',
        controller: c,
        width: 160,
        keyboardType: TextInputType.datetime,
        maxLength: 5,
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9:]'))],
        onChanged: (_) => setState(() {}),
        error: _tried ? validateTime(c.text) : null,
      );

  @override
  Widget build(BuildContext context) {
    final serverError = _serverError;
    final hoursError = _tried
        ? validateHours(_open.text, _cutoff.text, _close.text)
        : null;
    final sandbox = widget.view.clinic.isSandbox;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final (title, specs) in settingGroups) ...[
          GroupTitle(title),
          const SizedBox(height: DocketSpace.s16),
          for (final spec in specs) ...[
            _number(spec),
            const SizedBox(height: DocketSpace.s24),
          ],
          const SizedBox(height: groupGap - DocketSpace.s24),
        ],
        const GroupTitle(OwnerStrings.hoursGroup),
        const SizedBox(height: DocketSpace.s16),
        _time(OwnerStrings.openLabel, OwnerStrings.openExplain, _open),
        const SizedBox(height: DocketSpace.s24),
        _time(OwnerStrings.cutoffLabel, OwnerStrings.cutoffExplain, _cutoff),
        const SizedBox(height: DocketSpace.s24),
        _time(OwnerStrings.closeLabel, OwnerStrings.closeExplain, _close),
        if (hoursError != null && hoursError == OwnerStrings.hoursOrder) ...[
          const SizedBox(height: DocketSpace.s12),
          const ErrorLine(OwnerStrings.hoursOrder),
        ],
        const SizedBox(height: DocketSpace.s24),
        _number(autoCloseSpec),
        const SizedBox(height: DocketSpace.s24),
        LabeledField(
          label: OwnerStrings.timezoneLabel,
          explanation: OwnerStrings.timezoneSettingExplain,
          controller: _zone,
          width: 320,
          onChanged: (_) => setState(() {}),
          error: _tried ? validateTimezone(_zone.text) : null,
        ),
        const SizedBox(height: groupGap),
        const GroupTitle(OwnerStrings.textsGroup),
        const SizedBox(height: DocketSpace.s16),
        if (sandbox)
          const Explanation(OwnerStrings.smsSandbox)
        else if (widget.view.smsAvailable)
          DocketSwitch(
            label: OwnerStrings.smsLabel,
            explanation: OwnerStrings.smsExplain,
            value: _sms,
            onChanged: (v) => setState(() => _sms = v),
          )
        else
          const Explanation(OwnerStrings.smsUnavailable),
        const SizedBox(height: groupGap),
        if (serverError != null) ...[
          ErrorLine(serverError),
          const SizedBox(height: DocketSpace.s16),
        ],
        if (_saving) ...[
          const DocketProgressLine(semanticsLabel: OwnerStrings.saveSettings),
          const SizedBox(height: DocketSpace.s16),
        ],
        Align(
          alignment: Alignment.centerLeft,
          child: DocketButton(
            onPressed: _saving ? null : _save,
            label: OwnerStrings.saveSettings,
            icon: LucideIcons.check,
            filled: true,
          ),
        ),
      ],
    );
  }
}
