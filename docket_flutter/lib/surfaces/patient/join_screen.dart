import 'dart:async';
import 'dart:math' as math;

import 'package:docket_client/docket_client.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../client.dart';
import '../../shared/strings.dart';
import '../../shared/theme/tokens.dart';
import '../../shared/widgets/progress_line.dart';
import 'browser/patient_browser.dart';
import 'joined_ticket.dart';
import 'patient_sheets.dart';
import 'patient_widgets.dart';
import 'ticket_copy.dart';

/// Joining a clinic's line from the code at the desk, `/j/<slug>`
/// (PRD 17.1). No sign-in and nothing to install.
class JoinScreen extends StatefulWidget {
  const JoinScreen({super.key, required this.slug, this.lineCode});

  final String slug;

  /// The line a poster's code points at, preselected when it's open.
  final String? lineCode;

  @override
  State<JoinScreen> createState() => _JoinScreenState();
}

class _JoinScreenState extends State<JoinScreen> {
  static const _nameLimit = 40;
  static const double _pinnedTextScale = 1.3;
  static const double _pinnedMinHeight = 560;

  final _name = TextEditingController();
  final _phone = TextEditingController();

  ClinicPublicInfo? _clinic;
  DocketException? _refusal;
  bool _loadFailed = false;
  UuidValue? _lineId;
  bool _consent = false;
  bool _joining = false;
  String? _error;
  ({String token, PatientView view})? _existing;
  StreamSubscription<void>? _resumed;

  String get _slug => widget.slug.trim().toLowerCase();

  @override
  void initState() {
    super.initState();
    unawaited(_load());
    unawaited(_findExisting());
    _resumed = patientBrowser.resumed.listen((_) {
      if (_clinic != null || _loadFailed) unawaited(_load());
    });
  }

  @override
  void dispose() {
    _resumed?.cancel();
    _name.dispose();
    _phone.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final clinic = await client.publicClinic.getClinic(_slug);
      if (!mounted) return;
      setState(() {
        _clinic = clinic;
        _loadFailed = false;
        _lineId = _keepOrPick(clinic);
      });
    } on DocketException catch (e) {
      if (mounted) setState(() => _refusal = e);
    } on Object catch (e) {
      debugPrint('Docket: loading the clinic failed, $e');
      if (mounted) setState(() => _loadFailed = _clinic == null);
    }
  }

  /// Keeps the patient's pick across refreshes. Otherwise picks the poster's
  /// line, or the only line, when it's taking patients.
  UuidValue? _keepOrPick(ClinicPublicInfo clinic) {
    final open = clinic.lines.where((l) => l.acceptingJoins).toList();
    if (open.any((l) => l.id == _lineId)) return _lineId;
    final code = widget.lineCode?.trim().toUpperCase();
    for (final line in open) {
      if (line.code.toUpperCase() == code) return line.id;
    }
    if (clinic.lines.length == 1 && open.length == 1) return open.single.id;
    return null;
  }

  /// A ticket this browser already holds here, so scanning the code twice
  /// doesn't quietly make a second one.
  Future<void> _findExisting() async {
    final token = patientBrowser.read(JoinedTicket.storageKey(_slug));
    if (token == null) return;
    try {
      final view = await client.ticket.get(token);
      final phase = phaseOf(view);
      final holding = phase.isActive || phase == TicketPhase.inService;
      if (holding && mounted) {
        setState(() => _existing = (token: token, view: view));
      }
    } on Object catch (e) {
      debugPrint('Docket: the saved ticket is gone, $e');
    }
  }

  Future<void> _join() async {
    final clinic = _clinic;
    if (clinic == null || _joining) return;
    final lineId = _lineId;
    final phone = _phone.text.trim();
    if (lineId == null) {
      setState(() => _error = PatientStrings.pickLineFirst);
      return;
    }
    if (clinic.smsEnabled && _consent && phone.isEmpty) {
      setState(() => _error = PatientStrings.phoneMissing);
      return;
    }
    final name = _name.text.trim();
    setState(() {
      _joining = true;
      _error = null;
    });
    try {
      final result = await client.publicClinic.join(
        JoinRequest(
          clinicSlug: clinic.slug,
          lineId: lineId,
          displayName: name.isEmpty ? null : name,
          phoneE164: clinic.smsEnabled && phone.isNotEmpty ? phone : null,
          smsConsent: clinic.smsEnabled && _consent,
        ),
      );
      JoinedTicket.remember(result.ticketToken, result.view);
      patientBrowser.write(
        JoinedTicket.storageKey(clinic.slug),
        result.ticketToken,
      );
      if (!mounted) return;
      context.go('/t/${result.ticketToken}');
    } on DocketException catch (e) {
      if (mounted) {
        setState(() {
          _joining = false;
          _error = e.message;
        });
      }
    } on Object catch (e) {
      debugPrint('Docket: joining failed, $e');
      if (mounted) {
        setState(() {
          _joining = false;
          _error = PatientStrings.networkError;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final refusal = _refusal;
    if (refusal != null) {
      return _JoinMessage(
        message: refusal.message,
        action: PatientStrings.goHome,
        icon: LucideIcons.house,
        onAction: patientBrowser.openHome,
      );
    }
    if (_loadFailed) {
      return _JoinMessage(
        message: PatientStrings.networkError,
        action: PatientStrings.retry,
        icon: LucideIcons.rotateCw,
        onAction: () {
          setState(() => _loadFailed = false);
          unawaited(_load());
        },
      );
    }

    final clinic = _clinic;
    final canJoin =
        clinic != null && clinic.reasonClosed == null && clinic.acceptingJoins;
    final bar = _JoinBar(
      error: _error,
      joining: _joining,
      onJoin: canJoin && !_joining ? _join : null,
    );
    // Pinned in thumb reach, unless large text would leave the form only a
    // sliver of the screen. Then the button follows the form.
    final pinned =
        MediaQuery.textScalerOf(context).scale(1) <= _pinnedTextScale &&
        MediaQuery.sizeOf(context).height >= _pinnedMinHeight;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: patientMaxWidth),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const PatientTopBar(),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.only(
                          top: DocketSpace.s32,
                          bottom: DocketSpace.s24,
                        ),
                        child: clinic == null
                            ? const SizedBox.shrink()
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  AutofillGroup(child: _form(clinic)),
                                  if (!pinned) ...[
                                    const SizedBox(height: DocketSpace.s32),
                                    bar,
                                  ],
                                ],
                              ),
                      ),
                    ),
                    if (pinned) bar,
                  ],
                ),
              ),
            ),
            if (clinic == null || _joining)
              const Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: DocketProgressLine(
                  semanticsLabel: PatientStrings.loadingClinic,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _form(ClinicPublicInfo clinic) {
    final text = Theme.of(context).textTheme;
    final soft = Theme.of(context).colorScheme.onSurfaceVariant;
    final existing = _existing;
    final status =
        clinic.reasonClosed ??
        (clinic.acceptingJoins
            ? PatientStrings.openNow
            : PatientStrings.noLineOpen);
    final single = clinic.lines.length == 1;
    final nameStyle = text.headlineLarge!.copyWith(
      fontWeight: FontWeight.w800,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: patientGutter,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Semantics(
                header: true,
                child: Text(
                  clinic.name,
                  style: nameStyle,
                  textScaler: wordSafeScaler(
                    context,
                    clinic.name,
                    nameStyle,
                    math.min(
                          MediaQuery.sizeOf(context).width,
                          patientMaxWidth,
                        ) -
                        2 * DocketSpace.s16,
                  ),
                ),
              ),
              const SizedBox(height: DocketSpace.s8),
              Text(status, style: text.bodyLarge),
              if (clinic.isSandbox) ...[
                const SizedBox(height: DocketSpace.s8),
                Text(
                  PatientStrings.sandboxNote,
                  style: text.bodySmall?.copyWith(color: soft),
                ),
              ],
              if (existing != null) ...[
                const SizedBox(height: DocketSpace.s24),
                Text(
                  PatientStrings.alreadyInLine(
                    existing.view.label,
                    existing.view.lineName,
                  ),
                  style: text.bodyLarge,
                ),
                InlineAction(
                  label: PatientStrings.openTicket(existing.view.label),
                  icon: LucideIcons.ticket,
                  onPressed: () => context.go('/t/${existing.token}'),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: DocketSpace.s32),
        if (!single)
          Padding(
            padding: patientGutter,
            child: Semantics(
              header: true,
              child: Text(PatientStrings.pickLine, style: text.titleMedium),
            ),
          ),
        if (!single) const SizedBox(height: DocketSpace.s8),
        for (final line in clinic.lines)
          _LineRow(
            line: line,
            choosable: !single,
            selected: line.id == _lineId,
            onTap: line.acceptingJoins && !single && !_joining
                ? () => setState(() {
                    _lineId = line.id;
                    if (_error == PatientStrings.pickLineFirst) _error = null;
                  })
                : null,
          ),
        const SizedBox(height: DocketSpace.s32),
        Padding(
          padding: patientGutter,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              LabelledField(
                label: PatientStrings.nameLabel,
                helper: PatientStrings.nameHelper,
                child: TextField(
                  controller: _name,
                  enabled: !_joining,
                  textCapitalization: TextCapitalization.words,
                  autofillHints: const [AutofillHints.givenName],
                  textInputAction: clinic.smsEnabled
                      ? TextInputAction.next
                      : TextInputAction.done,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(_nameLimit),
                  ],
                ),
              ),
              if (clinic.smsEnabled) ...[
                const SizedBox(height: DocketSpace.s24),
                PhoneField(controller: _phone, enabled: !_joining),
                const SizedBox(height: DocketSpace.s8),
                ConsentBox(
                  value: _consent,
                  onChanged: _joining
                      ? null
                      : (v) => setState(() => _consent = v),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

/// One line as a tall row: its name, how many wait and how long a new
/// ticket would wait. No boxes, the selected row sits on wash.
class _LineRow extends StatelessWidget {
  const _LineRow({
    required this.line,
    required this.choosable,
    required this.selected,
    required this.onTap,
  });

  final LinePublicInfo line;
  final bool choosable;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = theme.textTheme;
    final scheme = theme.colorScheme;
    final open = line.acceptingJoins;
    final soft = scheme.onSurfaceVariant;
    final ink = open ? scheme.onSurface : soft;

    return Semantics(
      inMutuallyExclusiveGroup: choosable,
      checked: choosable ? selected : null,
      enabled: open,
      child: Material(
        color: selected && choosable
            ? scheme.surfaceContainerHighest
            : Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: DocketSpace.s64 + 8),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: DocketSpace.s16,
                vertical: DocketSpace.s12,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (choosable) ...[
                    _RadioDot(selected: selected, color: ink),
                    const SizedBox(width: DocketSpace.s16),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          line.name,
                          style: text.titleMedium?.copyWith(color: ink),
                        ),
                        const SizedBox(height: DocketSpace.s4),
                        Text(
                          PatientStrings.waitingCount(line.waitingCount),
                          style: text.bodySmall?.copyWith(color: soft),
                        ),
                        Text(
                          open
                              ? PatientStrings.etaForNewJoin(line.etaText)
                              : PatientStrings.lineClosed,
                          style: text.bodySmall?.copyWith(color: soft),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The radio control's ring, filled when chosen.
class _RadioDot extends StatelessWidget {
  const _RadioDot({required this.selected, required this.color});

  final bool selected;
  final Color color;

  static const double _size = 24;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: _size,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          shape: CircleBorder(side: BorderSide(color: color, width: 2)),
        ),
        child: Center(
          child: AnimatedContainer(
            duration: MediaQuery.disableAnimationsOf(context)
                ? Duration.zero
                : DocketMotion.press,
            curve: DocketMotion.curve,
            width: selected ? 12 : 0,
            height: selected ? 12 : 0,
            decoration: ShapeDecoration(
              color: color,
              shape: const CircleBorder(),
            ),
          ),
        ),
      ),
    );
  }
}

/// The pinned bottom: a refusal when there is one, the Join pill and the
/// privacy line under it.
class _JoinBar extends StatelessWidget {
  const _JoinBar({
    required this.error,
    required this.joining,
    required this.onJoin,
  });

  final String? error;
  final bool joining;
  final VoidCallback? onJoin;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        DocketSpace.s16,
        DocketSpace.s8,
        DocketSpace.s16,
        DocketSpace.s16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (error != null) ...[
            Semantics(
              liveRegion: true,
              child: Text(
                error!,
                style: text.bodySmall?.copyWith(
                  color: scheme.onSurface,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: DocketSpace.s12),
          ],
          PrimaryPill(
            label: joining ? PatientStrings.joining : PatientStrings.join,
            icon: LucideIcons.ticket,
            onPressed: onJoin,
          ),
          const SizedBox(height: DocketSpace.s12),
          Text(
            PatientStrings.privacy,
            style: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

/// A clinic link that doesn't work, or a clinic that couldn't load.
class _JoinMessage extends StatelessWidget {
  const _JoinMessage({
    required this.message,
    required this.action,
    required this.icon,
    required this.onAction,
  });

  final String message;
  final String action;
  final IconData icon;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: patientMaxWidth),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const PatientTopBar(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(
                      DocketSpace.s16,
                      DocketSpace.s48,
                      DocketSpace.s16,
                      DocketSpace.s24,
                    ),
                    child: Semantics(
                      liveRegion: true,
                      header: true,
                      child: Text(message, style: text.headlineMedium),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(DocketSpace.s16),
                  child: PrimaryPill(
                    label: action,
                    icon: icon,
                    onPressed: onAction,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
