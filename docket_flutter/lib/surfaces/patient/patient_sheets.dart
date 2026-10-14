import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter/services.dart';

import '../../shared/strings.dart';
import '../../shared/theme/tokens.dart';
import 'patient_widgets.dart';

/// Opens a sheet with the top corners rounded, sized to its content and
/// scrollable at large text sizes.
Future<T?> showPatientSheet<T>(
  BuildContext context, {
  required WidgetBuilder builder,
}) => showModalBottomSheet<T>(
  context: context,
  isScrollControlled: true,
  useSafeArea: true,
  constraints: const BoxConstraints(maxWidth: patientMaxWidth),
  builder: (context) => Padding(
    padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
    child: SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        DocketSpace.s24,
        DocketSpace.s32,
        DocketSpace.s24,
        DocketSpace.s24,
      ),
      child: builder(context),
    ),
  ),
);

/// Asks before leaving, since a stolen link could also be used to leave
/// (PRD 17.2, 18). Resolves true when the patient confirms.
Future<bool> confirmLeave(BuildContext context, String label) async {
  final leave = await showPatientSheet<bool>(
    context,
    builder: (context) {
      final text = Theme.of(context).textTheme;
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Semantics(
            header: true,
            child: Text(PatientStrings.leaveTitle, style: text.headlineMedium),
          ),
          const SizedBox(height: DocketSpace.s12),
          Text(PatientStrings.leaveBody(label), style: text.bodyLarge),
          const SizedBox(height: DocketSpace.s32),
          PrimaryPill(
            label: PatientStrings.leaveConfirm,
            icon: LucideIcons.logOut,
            color: DocketColors.missed,
            textColor: DocketColors.daylight,
            onPressed: () => Navigator.of(context).pop(true),
          ),
          const SizedBox(height: DocketSpace.s8),
          SecondaryPill(
            label: PatientStrings.leaveKeep,
            icon: LucideIcons.ticket,
            onPressed: () => Navigator.of(context).pop(false),
          ),
        ],
      );
    },
  );
  return leave ?? false;
}

/// Saves a phone number for texts. Returns the server's refusal, or null
/// when it worked.
typedef SmsSubmit = Future<String?> Function(String phone, bool consent);

/// iPhone outside the Home Screen: the three taps to add Docket, with texts
/// beside them when the clinic sends texts (PRD 14.3).
Future<void> showInstallSheet(BuildContext context, {SmsSubmit? onSms}) =>
    showPatientSheet<void>(
      context,
      builder: (context) {
        final text = Theme.of(context).textTheme;
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Semantics(
              header: true,
              child: Text(
                PatientStrings.installTitle,
                style: text.headlineMedium,
              ),
            ),
            const SizedBox(height: DocketSpace.s12),
            Text(PatientStrings.installIntro, style: text.bodyLarge),
            const SizedBox(height: DocketSpace.s24),
            for (final (i, step) in PatientStrings.installSteps.indexed)
              Padding(
                padding: const EdgeInsets.only(bottom: DocketSpace.s16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: DocketSpace.s32,
                      child: Text(
                        '${i + 1}',
                        style: text.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          height: DocketType.bodyLeading,
                        ),
                      ),
                    ),
                    Expanded(child: Text(step, style: text.bodyLarge)),
                  ],
                ),
              ),
            if (onSms != null) ...[
              const SizedBox(height: DocketSpace.s16),
              Semantics(
                header: true,
                child: Text(
                  PatientStrings.smsInstead,
                  style: text.titleMedium,
                ),
              ),
              const SizedBox(height: DocketSpace.s12),
              SmsForm(onSubmit: onSms),
            ],
            const SizedBox(height: DocketSpace.s8),
            SecondaryPill(
              label: PatientStrings.close,
              icon: LucideIcons.x,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );

/// Texts as the alert channel, for browsers without push.
Future<void> showSmsSheet(BuildContext context, {required SmsSubmit onSms}) =>
    showPatientSheet<void>(
      context,
      builder: (context) {
        final text = Theme.of(context).textTheme;
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Semantics(
              header: true,
              child: Text(PatientStrings.smsTitle, style: text.headlineMedium),
            ),
            const SizedBox(height: DocketSpace.s24),
            SmsForm(onSubmit: onSms),
            const SizedBox(height: DocketSpace.s8),
            SecondaryPill(
              label: PatientStrings.close,
              icon: LucideIcons.x,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );

/// Phone number, the unticked consent box and "Text me". Closes its sheet
/// once the server accepts the number.
class SmsForm extends StatefulWidget {
  const SmsForm({super.key, required this.onSubmit});

  final SmsSubmit onSubmit;

  @override
  State<SmsForm> createState() => _SmsFormState();
}

class _SmsFormState extends State<SmsForm> {
  final _phone = TextEditingController();
  bool _consent = false;
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _phone.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_phone.text.trim().isEmpty) {
      setState(() => _error = PatientStrings.phoneMissing);
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    final refusal = await widget.onSubmit(_phone.text.trim(), _consent);
    if (!mounted) return;
    if (refusal == null) {
      Navigator.of(context).pop();
      return;
    }
    setState(() {
      _busy = false;
      _error = refusal;
    });
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PhoneField(controller: _phone, enabled: !_busy),
        const SizedBox(height: DocketSpace.s8),
        ConsentBox(
          value: _consent,
          onChanged: _busy ? null : (v) => setState(() => _consent = v),
        ),
        if (_error != null) ...[
          const SizedBox(height: DocketSpace.s8),
          Semantics(
            liveRegion: true,
            child: Text(
              _error!,
              style: text.bodySmall?.copyWith(color: scheme.error),
            ),
          ),
        ],
        const SizedBox(height: DocketSpace.s16),
        PrimaryPill(
          label: _busy ? PatientStrings.smsTurningOn : PatientStrings.smsTurnOn,
          icon: LucideIcons.messageSquareText,
          onPressed: _busy ? null : _submit,
        ),
      ],
    );
  }
}

/// A labelled phone input, wash-filled per the theme.
class PhoneField extends StatelessWidget {
  const PhoneField({super.key, required this.controller, this.enabled = true});

  final TextEditingController controller;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return LabelledField(
      label: PatientStrings.phoneLabel,
      child: TextField(
        controller: controller,
        enabled: enabled,
        keyboardType: TextInputType.phone,
        autofillHints: const [AutofillHints.telephoneNumber],
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[0-9+ ()-]')),
          LengthLimitingTextInputFormatter(20),
        ],
        decoration: const InputDecoration(hintText: PatientStrings.phoneHint),
      ),
    );
  }
}

/// "Text me when it's my turn", unticked until the patient ticks it.
class ConsentBox extends StatelessWidget {
  const ConsentBox({super.key, required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      value: value,
      onChanged: onChanged == null ? null : (v) => onChanged!(v ?? false),
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: EdgeInsets.zero,
      shape: const StadiumBorder(),
      title: Text(
        PatientStrings.smsConsent,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }
}

/// A field with its label above it, since floating labels are off.
class LabelledField extends StatelessWidget {
  const LabelledField({
    super.key,
    required this.label,
    required this.child,
    this.helper,
  });

  final String label;
  final String? helper;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final soft = Theme.of(context).colorScheme.onSurfaceVariant;
    return MergeSemantics(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text.rich(
            TextSpan(
              children: [
                TextSpan(text: label, style: text.titleMedium),
                if (helper != null)
                  TextSpan(
                    text: '  $helper',
                    style: text.bodySmall?.copyWith(color: soft),
                  ),
              ],
            ),
          ),
          const SizedBox(height: DocketSpace.s8),
          child,
        ],
      ),
    );
  }
}
