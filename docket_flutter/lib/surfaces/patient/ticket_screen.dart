import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:docket_client/docket_client.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter/semantics.dart';
import 'package:go_router/go_router.dart';

import '../../client.dart';
import '../../shared/live_stream.dart';
import '../../shared/server_clock.dart';
import '../../shared/strings.dart';
import '../../shared/theme/theme.dart';
import '../../shared/theme/tokens.dart';
import '../../shared/widgets/progress_line.dart';
import 'browser/patient_browser.dart';
import 'joined_ticket.dart';
import 'patient_sheets.dart';
import 'patient_widgets.dart';
import 'ticket_copy.dart';
import 'ticket_face.dart';

/// The patient's live ticket at `/t/<token>` (PRD 17.2). The token is the
/// capability, so there's no sign-in.
class TicketScreen extends StatefulWidget {
  const TicketScreen({super.key, required this.token});

  final String token;

  @override
  State<TicketScreen> createState() => _TicketScreenState();
}

enum _Busy { confirm, leave, alerts, alertsOff }

class _TicketScreenState extends State<TicketScreen> {
  /// How long "Next stop: Lab, L-007" shows before the page follows it.
  static const _followDelay = Duration(milliseconds: 2500);

  LiveStream<PatientView>? _live;
  PatientView? _view;
  DocketException? _missing;
  String? _splashLabel;
  String? _splashDetail;
  Timer? _tick;
  Timer? _follow;
  StreamSubscription<void>? _resumed;
  _Busy? _busy;
  String? _message;
  bool _offerSms = false;

  @override
  void initState() {
    super.initState();
    // The splash is still on the page during the first frame. Painting its
    // label keeps the swap from Flutter's loading screen still.
    _splashLabel = patientBrowser.splashText('fp-label');
    _splashDetail = patientBrowser.splashText('fp-detail');
    _resumed = patientBrowser.resumed.listen((_) => _live?.reconnectNow());
    _open();
    _scheduleTick();
  }

  @override
  void didUpdateWidget(TicketScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.token == widget.token) return;
    _close();
    _view = null;
    _missing = null;
    _message = null;
    _offerSms = false;
    _busy = null;
    _open();
  }

  @override
  void dispose() {
    _close();
    _tick?.cancel();
    _resumed?.cancel();
    super.dispose();
  }

  void _open() {
    final token = widget.token;
    final handed = JoinedTicket.take(token);
    if (handed != null) {
      ServerClock.instance.observe(handed.serverTime);
      _view = handed;
    } else {
      // Its server time is old, so it doesn't set the clock.
      _view = _remembered(token);
    }
    _live = LiveStream<PatientView>(
      snapshot: () => client.ticket.get(token),
      open: () => client.ticket.watch(token),
      onValue: _accept,
      onFatal: (error) {
        if (error is DocketException &&
            error.code == DocketErrorCode.ticketNotFound) {
          _missing = error;
          return true;
        }
        return false;
      },
    )..addListener(_onConnection);
    _live!.start();
  }

  void _close() {
    _follow?.cancel();
    _follow = null;
    _live
      ?..removeListener(_onConnection)
      ..dispose();
    _live = null;
  }

  void _onConnection() {
    if (mounted) setState(() {});
  }

  /// Redraws on each second of server time, so countdowns tick over with
  /// the server's clock rather than the phone's.
  void _scheduleTick() {
    final wait = 1000 - ServerClock.instance.now().millisecond;
    _tick = Timer(Duration(milliseconds: wait + 10), () {
      if (!mounted) return;
      setState(() {});
      _scheduleTick();
    });
  }

  /// Takes a view from the stream or from an action's reply, whichever is
  /// newer by server time.
  void _accept(PatientView next) {
    final previous = _view;
    if (previous != null && next.serverTime.isBefore(previous.serverTime)) {
      return;
    }
    ServerClock.instance.observe(next.serverTime);
    _view = next;
    if (mounted) setState(() {});
    patientBrowser.write(
      JoinedTicket.viewKey(widget.token),
      jsonEncode(next.toJson()),
    );

    final before = previous == null ? null : phaseOf(previous);
    final phase = phaseOf(next);
    final changed = before != phase || previous?.position != next.position;
    if (previous != null && changed) _announce(next);
    if (phase == TicketPhase.called && before != null && before != phase) {
      patientBrowser.vibrateForCall();
    }
    final nextToken = next.transferredToToken;
    if (phase == TicketPhase.transferred && nextToken != null) {
      _follow ??= Timer(_followDelay, () => _goTo(nextToken));
    }
  }

  PatientView? _remembered(String token) {
    final raw = patientBrowser.read(JoinedTicket.viewKey(token));
    if (raw == null) return null;
    try {
      return PatientView.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } on Object catch (e) {
      debugPrint('Docket: the saved ticket view was unreadable, $e');
      return null;
    }
  }

  void _announce(PatientView view) {
    if (!mounted) return;
    final copy = ticketCopy(view, now: ServerClock.instance.now());
    final countdown = copy.countdown;
    final text = copy.announcement(
      spokenLabel(view.label),
      countdownText: countdown == null
          ? null
          : '${countdown.digits(ServerClock.instance)}${countdown.suffix}',
    );
    unawaited(
      SemanticsService.sendAnnouncement(
        View.of(context),
        text,
        TextDirection.ltr,
      ),
    );
  }

  void _goTo(String token) {
    if (!mounted) return;
    context.go('/t/$token');
  }

  Future<void> _run(_Busy busy, Future<PatientView> Function() action) async {
    setState(() {
      _busy = busy;
      _message = null;
      _offerSms = false;
    });
    try {
      _accept(await action());
    } on DocketException catch (e) {
      _message = e.message;
    } on Object catch (e) {
      debugPrint('Docket: ticket action failed, $e');
      _message = PatientStrings.networkError;
    } finally {
      if (mounted) setState(() => _busy = null);
    }
  }

  void _confirm() =>
      _run(_Busy.confirm, () => client.ticket.confirmComing(widget.token));

  Future<void> _leave(PatientView view) async {
    if (!await confirmLeave(context, view.label)) return;
    await _run(_Busy.leave, () => client.ticket.leave(widget.token));
  }

  void _turnOffAlerts() =>
      _run(_Busy.alertsOff, () => client.ticket.disableAlerts(widget.token));

  void _getAlerts(PatientView view) {
    final support = patientBrowser.alertsSupport;
    switch (support) {
      case AlertsSupport.addToHomeScreen:
        unawaited(
          showInstallSheet(
            context,
            onSms: view.smsEnabled ? _saveSms : null,
          ),
        );
      case AlertsSupport.insecure || AlertsSupport.unsupported:
        setState(() {
          _message = support == AlertsSupport.insecure
              ? PatientStrings.pushInsecure
              : PatientStrings.pushUnsupported;
          _offerSms = view.smsEnabled;
        });
      case AlertsSupport.push:
        // Asked for in parallel, so the permission prompt still opens
        // inside the tap.
        final serverKey = client.publicClinic.vapidPublicKey();
        serverKey.ignore();
        unawaited(_enablePush(view, serverKey));
    }
  }

  Future<void> _enablePush(PatientView view, Future<String> serverKey) async {
    setState(() {
      _busy = _Busy.alerts;
      _message = null;
      _offerSms = false;
    });
    try {
      final keys = await patientBrowser.subscribePush(serverKey);
      _accept(
        await client.ticket.registerPush(
          widget.token,
          PushSubscriptionInput(
            endpoint: keys.endpoint,
            p256dh: keys.p256dh,
            auth: keys.auth,
          ),
        ),
      );
    } on PushSetupException catch (e) {
      debugPrint('Docket: push setup stopped, $e');
      _message = _pushFailureText(e.failure);
      _offerSms =
          view.smsEnabled &&
          e.failure != PushSetupFailure.dismissed &&
          e.failure != PushSetupFailure.failed;
    } on DocketException catch (e) {
      _message = e.message;
    } on Object catch (e) {
      debugPrint('Docket: turning on alerts failed, $e');
      _message = PatientStrings.networkError;
    } finally {
      if (mounted) setState(() => _busy = null);
    }
  }

  static String _pushFailureText(PushSetupFailure failure) => switch (failure) {
    PushSetupFailure.denied => PatientStrings.pushDenied,
    PushSetupFailure.dismissed => PatientStrings.pushDismissed,
    PushSetupFailure.unsupported => PatientStrings.pushUnsupported,
    PushSetupFailure.notConfigured => PatientStrings.pushNotConfigured,
    PushSetupFailure.failed => PatientStrings.pushFailed,
  };

  Future<String?> _saveSms(String phone, bool consent) async {
    try {
      _accept(await client.ticket.setPhone(widget.token, phone, consent));
      if (mounted) {
        setState(() {
          _message = null;
          _offerSms = false;
        });
      }
      return null;
    } on DocketException catch (e) {
      return e.message;
    } on Object catch (e) {
      debugPrint('Docket: saving the phone failed, $e');
      return PatientStrings.networkError;
    }
  }

  @override
  Widget build(BuildContext context) {
    final missing = _missing;
    if (missing != null) return _MissingTicket(message: missing.message);

    final view = _view;
    final live = _live;
    final stale = live?.state == LiveState.stale;
    final phase = view == null ? null : phaseOf(view);
    final copy = view == null
        ? null
        : ticketCopy(view, now: ServerClock.instance.now());
    final palette = ticketPalette(
      state: view?.state ?? TicketState.waiting,
      headsUpSent: view?.headsUpSent ?? false,
      reslotted: (view?.reslotCount ?? 0) > 0,
      brightness: Theme.of(context).brightness,
      stale: stale && view != null,
    );

    final String? band;
    if (stale && view == null) {
      band = PatientStrings.networkError;
    } else if (stale) {
      band = PatientStrings.reconnecting(
        clockTime(live?.lastUpdate ?? view!.serverTime),
      );
    } else if (view != null && !view.deskOnline && phase!.isActive) {
      band = PatientStrings.deskOffline;
    } else {
      band = null;
    }

    final alertsOn = view != null && (view.pushActive || view.smsActive);
    final width =
        math.min(MediaQuery.sizeOf(context).width, patientMaxWidth) -
        2 * DocketSpace.s16;
    final face = TicketFace(
      label: view?.label ?? _splashLabel ?? '',
      palette: palette,
      width: width,
      where: view == null
          ? null
          : PatientStrings.ticketContext(view.lineName, view.clinicName),
      copy: copy,
      countdownDigits: copy?.countdown?.digits(ServerClock.instance),
      fallbackDetail: _splashDetail,
    );

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
                    PatientTopBar(demo: view?.isDemo ?? false),
                    const SizedBox(height: DocketSpace.s24),
                    if (band != null) PatientBand(text: band),
                    // The ticket fills the screen above the actions, and the
                    // page scrolls once its words need more room.
                    Expanded(
                      child: CustomScrollView(
                        slivers: [
                          SliverFillRemaining(
                            hasScrollBody: false,
                            // Focusable, so a keyboard can reach the region
                            // and scroll it with the arrow and page keys
                            // when the ticket's words outgrow the screen.
                            child: Focus(
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(
                                  DocketSpace.s16,
                                  band == null ? 0 : DocketSpace.s16,
                                  DocketSpace.s16,
                                  DocketSpace.s12,
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Expanded(child: face),
                                    if (view != null && phase!.isActive) ...[
                                      if (alertsOn) ...[
                                        const SizedBox(height: DocketSpace.s32),
                                        _AlertsOn(
                                          view: view,
                                          busy: _busy == _Busy.alertsOff,
                                          onTurnOff: _busy == null
                                              ? _turnOffAlerts
                                              : null,
                                        ),
                                      ],
                                      const SizedBox(height: DocketSpace.s24),
                                      _Quiet(PatientStrings.linkWarning),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    _ActionBar(
                      note: copy?.note,
                      message: _message,
                      busy: _busy != null && _busy != _Busy.alertsOff,
                      actions: _actions(view, copy, stale, alertsOn),
                    ),
                  ],
                ),
              ),
            ),
            if (view == null && !stale)
              const Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: DocketProgressLine(
                  semanticsLabel: PatientStrings.loadingTicket,
                ),
              ),
          ],
        ),
      ),
    );
  }

  List<Widget> _actions(
    PatientView? view,
    TicketCopy? copy,
    bool stale,
    bool alertsOn,
  ) {
    if (view == null || copy == null) {
      return [
        if (stale)
          PrimaryPill(
            label: PatientStrings.retry,
            icon: LucideIcons.rotateCw,
            onPressed: () => _live?.reconnectNow(),
          ),
      ];
    }
    final idle = _busy == null;
    final actions = copy.actions;
    final nextToken = view.transferredToToken;
    return [
      if (actions.contains(TicketAction.confirm))
        PrimaryPill(
          label: _busy == _Busy.confirm
              ? PatientStrings.confirming
              : PatientStrings.confirm,
          icon: LucideIcons.footprints,
          onPressed: idle ? _confirm : null,
        ),
      if (actions.contains(TicketAction.getAlerts) && !alertsOn)
        PrimaryPill(
          label: _busy == _Busy.alerts
              ? PatientStrings.gettingAlerts
              : PatientStrings.getAlerts,
          icon: LucideIcons.bell,
          onPressed: idle ? () => _getAlerts(view) : null,
        ),
      if (_offerSms && !view.smsActive)
        SecondaryPill(
          label: PatientStrings.getTextsInstead,
          icon: LucideIcons.messageSquareText,
          onPressed: idle ? () => showSmsSheet(context, onSms: _saveSms) : null,
        ),
      if (actions.contains(TicketAction.leave))
        SecondaryPill(
          label: PatientStrings.leave,
          icon: LucideIcons.logOut,
          onPressed: idle ? () => _leave(view) : null,
        ),
      if (view.state == TicketState.transferred && nextToken != null)
        SecondaryPill(
          label: PatientStrings.openNextTicket(view.transferredToLabel),
          icon: LucideIcons.ticket,
          onPressed: () => _goTo(nextToken),
        ),
      if (const {
        TicketState.served,
        TicketState.cancelled,
        TicketState.removed,
        TicketState.expired,
      }.contains(view.state))
        SecondaryPill(
          label: PatientStrings.goHome,
          icon: LucideIcons.house,
          onPressed: patientBrowser.openHome,
        ),
    ];
  }
}

/// "Alerts on", the channels in use, and the way to turn them off.
class _AlertsOn extends StatelessWidget {
  const _AlertsOn({
    required this.view,
    required this.busy,
    required this.onTurnOff,
  });

  final PatientView view;
  final bool busy;
  final VoidCallback? onTurnOff;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final soft = Theme.of(context).colorScheme.onSurfaceVariant;
    final last4 = view.smsLast4;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          header: true,
          child: Text(PatientStrings.alertsOn, style: text.titleMedium),
        ),
        const SizedBox(height: DocketSpace.s4),
        if (view.pushActive)
          Text(
            PatientStrings.alertsByPush,
            style: text.bodySmall?.copyWith(color: soft),
          ),
        if (view.smsActive)
          Text(
            last4 == null
                ? PatientStrings.alertsBySmsNoNumber
                : PatientStrings.alertsBySms(last4),
            style: text.bodySmall?.copyWith(color: soft),
          ),
        const SizedBox(height: DocketSpace.s8),
        InlineAction(
          label: busy
              ? PatientStrings.turningOffAlerts
              : PatientStrings.turnOffAlerts,
          icon: LucideIcons.bellOff,
          onPressed: onTurnOff,
        ),
      ],
    );
  }
}

class _Quiet extends StatelessWidget {
  const _Quiet(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }
}

/// The bottom of the screen, in thumb reach: a note, the last refusal, then
/// full-width actions.
class _ActionBar extends StatelessWidget {
  const _ActionBar({
    required this.note,
    required this.message,
    required this.busy,
    required this.actions,
  });

  final List<Widget> actions;
  final String? note;
  final String? message;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    if (actions.isEmpty && note == null && message == null) {
      return const SizedBox(height: DocketSpace.s16);
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        DocketSpace.s16,
        DocketSpace.s12,
        DocketSpace.s16,
        DocketSpace.s16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (busy)
            const Padding(
              padding: EdgeInsets.only(bottom: DocketSpace.s12),
              child: DocketProgressLine(),
            ),
          if (note != null) ...[
            Text(
              note!,
              style: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
            ),
            const SizedBox(height: DocketSpace.s12),
          ],
          if (message != null) ...[
            Semantics(
              liveRegion: true,
              child: Text(
                message!,
                style: text.bodySmall?.copyWith(
                  color: scheme.onSurface,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: DocketSpace.s12),
          ],
          for (final (i, action) in actions.indexed) ...[
            if (i > 0) const SizedBox(height: DocketSpace.s8),
            action,
          ],
        ],
      ),
    );
  }
}

/// An unknown or replaced link: the server's words and a way home.
class _MissingTicket extends StatelessWidget {
  const _MissingTicket({required this.message});

  final String message;

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
                    label: PatientStrings.goHome,
                    icon: LucideIcons.house,
                    onPressed: patientBrowser.openHome,
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
