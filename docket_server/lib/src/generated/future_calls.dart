/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: depend_on_referenced_packages

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _ida;
import 'package:clock/clock.dart' as _io0w16m8;
import 'package:serverpod/serverpod.dart' as _is;
import '../future_calls/clinic_jobs_future_call.dart' as _ixul5df8;
import '../future_calls/dispatch_future_call.dart' as _ismsz80w;
import '../future_calls/smoke_future_call.dart' as _i7gnn9mc;
import '../future_calls/ticket_timers_future_call.dart' as _iqqk37p5;
import 'future_calls_generated_models/clinic_jobs_future_call_auto_close_day_model.dart'
    as _ilmgu8hh;
import 'future_calls_generated_models/dispatch_future_call_send_model.dart'
    as _i65bud0x;
import 'future_calls_generated_models/smoke_future_call_fire_model.dart'
    as _il52xcea;
import 'future_calls_generated_models/ticket_timers_future_call_arrival_expired_model.dart'
    as _it6gb6op;
import 'future_calls_generated_models/ticket_timers_future_call_grace_expired_model.dart'
    as _ikoguwcg;
import 'future_calls_generated_models/ticket_timers_future_call_grace_reminder_model.dart'
    as _iau54etg;

/// Invokes a future call.
typedef _InvokeFutureCall =
    Future<void> Function(String name, _is.SerializableModel? object);

extension ServerpodFutureCallsGetter on _is.Serverpod {
  /// Generated future calls.
  FutureCalls get futureCalls => FutureCalls();
}

class FutureCalls extends _is.FutureCallDispatch<_FutureCallRef> {
  FutureCalls._();

  factory FutureCalls() {
    return _instance;
  }

  static final FutureCalls _instance = FutureCalls._();

  _is.FutureCallManager? _futureCallManager;

  String? _serverId;

  String get _effectiveServerId {
    if (_serverId == null) {
      throw StateError('FutureCalls is not initialized.');
    }
    return _serverId!;
  }

  _is.FutureCallManager get _effectiveFutureCallManager {
    if (_futureCallManager == null) {
      throw StateError('FutureCalls is not initialized.');
    }
    return _futureCallManager!;
  }

  @override
  void initialize(
    _is.FutureCallManager futureCallManager,
    String serverId,
  ) {
    var registeredFutureCalls = <String, _is.InvokableFutureCall>{
      'ClinicJobsAutoCloseDayFutureCall': ClinicJobsAutoCloseDayFutureCall(),
      'ClinicJobsNightlyFutureCall': ClinicJobsNightlyFutureCall(),
      'ClinicJobsPresenceSweepFutureCall': ClinicJobsPresenceSweepFutureCall(),
      'ClinicJobsTimerSweepFutureCall': ClinicJobsTimerSweepFutureCall(),
      'DispatchSendFutureCall': DispatchSendFutureCall(),
      'SmokeFireFutureCall': SmokeFireFutureCall(),
      'TicketTimersGraceReminderFutureCall':
          TicketTimersGraceReminderFutureCall(),
      'TicketTimersGraceExpiredFutureCall':
          TicketTimersGraceExpiredFutureCall(),
      'TicketTimersArrivalExpiredFutureCall':
          TicketTimersArrivalExpiredFutureCall(),
    };
    _futureCallManager = futureCallManager;
    _serverId = serverId;
    for (final entry in registeredFutureCalls.entries) {
      _futureCallManager?.registerFutureCall(entry.value, entry.key);
    }
  }

  @override
  _FutureCallRef callAtTime(
    DateTime time, {
    String? identifier,
  }) {
    return _FutureCallRef(
      (name, object) {
        return _effectiveFutureCallManager.scheduleFutureCall(
          name,
          object,
          time,
          _effectiveServerId,
          identifier,
        );
      },
    );
  }

  @override
  _FutureCallRef callWithDelay(
    Duration delay, {
    String? identifier,
  }) {
    return _FutureCallRef(
      (name, object) {
        return _effectiveFutureCallManager.scheduleFutureCall(
          name,
          object,
          DateTime.now().toUtc().add(delay),
          _effectiveServerId,
          identifier,
        );
      },
    );
  }

  @override
  _is.RecurringFutureCallDispatch<_FutureCallRef> callRecurring({
    String? identifier,
  }) {
    return _RecurringFutureCallDispatchImpl(
      _effectiveFutureCallManager,
      _effectiveServerId,
      identifier,
    );
  }

  @override
  Future<void> cancel(String identifier) async {
    await _effectiveFutureCallManager.cancelFutureCall(identifier);
  }
}

class _RecurringFutureCallDispatchImpl
    extends _is.RecurringFutureCallDispatch<_FutureCallRef> {
  _RecurringFutureCallDispatchImpl(
    this._futureCallManager,
    this._serverId,
    this._identifier,
  );

  final _is.FutureCallManager _futureCallManager;

  final String _serverId;

  final String? _identifier;

  @override
  _FutureCallRef cron(String cronExpression) {
    return _FutureCallRef(
      (name, object) {
        return _futureCallManager.scheduleFutureCall(
          name,
          object,
          _is.Cron.parse(cronExpression).nextTime(),
          _serverId,
          _identifier,
          scheduling: _is.CronFutureCallScheduling(cron: cronExpression),
        );
      },
    );
  }

  @override
  _FutureCallRef every(
    Duration interval, {
    DateTime? start,
  }) {
    final now = _io0w16m8.clock.now().toUtc();
    return _FutureCallRef(
      (name, object) {
        return _futureCallManager.scheduleFutureCall(
          name,
          object,
          start ?? now.add(interval),
          _serverId,
          _identifier,
          scheduling: _is.IntervalFutureCallScheduling(
            interval: interval,
            start: start,
          ),
        );
      },
    );
  }
}

class _FutureCallRef {
  _FutureCallRef(this._invokeFutureCall);

  final _InvokeFutureCall _invokeFutureCall;

  late final clinicJobs = _ClinicJobsFutureCallDispatcher(_invokeFutureCall);

  late final dispatch = _DispatchFutureCallDispatcher(_invokeFutureCall);

  late final smoke = _SmokeFutureCallDispatcher(_invokeFutureCall);

  late final ticketTimers = _TicketTimersFutureCallDispatcher(
    _invokeFutureCall,
  );
}

class _ClinicJobsFutureCallDispatcher {
  _ClinicJobsFutureCallDispatcher(this._invokeFutureCall);

  final _InvokeFutureCall _invokeFutureCall;

  Future<void> autoCloseDay(
    _is.UuidValue clinicId,
    String serviceDate,
  ) {
    var object = _ilmgu8hh.ClinicJobsFutureCallAutoCloseDayModel(
      clinicId: clinicId,
      serviceDate: serviceDate,
    );
    return _invokeFutureCall(
      'ClinicJobsAutoCloseDayFutureCall',
      object,
    );
  }

  Future<void> nightly() {
    return _invokeFutureCall(
      'ClinicJobsNightlyFutureCall',
      null,
    );
  }

  Future<void> presenceSweep() {
    return _invokeFutureCall(
      'ClinicJobsPresenceSweepFutureCall',
      null,
    );
  }

  Future<void> timerSweep() {
    return _invokeFutureCall(
      'ClinicJobsTimerSweepFutureCall',
      null,
    );
  }
}

class _DispatchFutureCallDispatcher {
  _DispatchFutureCallDispatcher(this._invokeFutureCall);

  final _InvokeFutureCall _invokeFutureCall;

  Future<void> send(_is.UuidValue notificationId) {
    var object = _i65bud0x.DispatchFutureCallSendModel(
      notificationId: notificationId,
    );
    return _invokeFutureCall(
      'DispatchSendFutureCall',
      object,
    );
  }
}

class _SmokeFutureCallDispatcher {
  _SmokeFutureCallDispatcher(this._invokeFutureCall);

  final _InvokeFutureCall _invokeFutureCall;

  Future<void> fire(_is.UuidValue runId) {
    var object = _il52xcea.SmokeFutureCallFireModel(runId: runId);
    return _invokeFutureCall(
      'SmokeFireFutureCall',
      object,
    );
  }
}

class _TicketTimersFutureCallDispatcher {
  _TicketTimersFutureCallDispatcher(this._invokeFutureCall);

  final _InvokeFutureCall _invokeFutureCall;

  Future<void> graceReminder(
    _is.UuidValue ticketId,
    int callVersion,
  ) {
    var object = _iau54etg.TicketTimersFutureCallGraceReminderModel(
      ticketId: ticketId,
      callVersion: callVersion,
    );
    return _invokeFutureCall(
      'TicketTimersGraceReminderFutureCall',
      object,
    );
  }

  Future<void> graceExpired(
    _is.UuidValue ticketId,
    int callVersion,
  ) {
    var object = _ikoguwcg.TicketTimersFutureCallGraceExpiredModel(
      ticketId: ticketId,
      callVersion: callVersion,
    );
    return _invokeFutureCall(
      'TicketTimersGraceExpiredFutureCall',
      object,
    );
  }

  Future<void> arrivalExpired(
    _is.UuidValue ticketId,
    int callVersion,
  ) {
    var object = _it6gb6op.TicketTimersFutureCallArrivalExpiredModel(
      ticketId: ticketId,
      callVersion: callVersion,
    );
    return _invokeFutureCall(
      'TicketTimersArrivalExpiredFutureCall',
      object,
    );
  }
}

class ClinicJobsAutoCloseDayFutureCall
    extends _is.FutureCall<_ilmgu8hh.ClinicJobsFutureCallAutoCloseDayModel>
    implements
        _is.InvokableFutureCall<
          _ilmgu8hh.ClinicJobsFutureCallAutoCloseDayModel
        > {
  @override
  _ida.Future<void> invoke(
    _is.Session session,
    _ilmgu8hh.ClinicJobsFutureCallAutoCloseDayModel? object,
  ) async {
    if (object != null) {
      await _ixul5df8.ClinicJobsFutureCall().autoCloseDay(
        session,
        object.clinicId,
        object.serviceDate,
      );
    }
  }
}

class ClinicJobsNightlyFutureCall extends _is.FutureCall
    implements _is.InvokableFutureCall {
  @override
  _ida.Future<void> invoke(
    _is.Session session,
    _is.SerializableModel? object,
  ) async {
    await _ixul5df8.ClinicJobsFutureCall().nightly(session);
  }
}

class ClinicJobsPresenceSweepFutureCall extends _is.FutureCall
    implements _is.InvokableFutureCall {
  @override
  _ida.Future<void> invoke(
    _is.Session session,
    _is.SerializableModel? object,
  ) async {
    await _ixul5df8.ClinicJobsFutureCall().presenceSweep(session);
  }
}

class ClinicJobsTimerSweepFutureCall extends _is.FutureCall
    implements _is.InvokableFutureCall {
  @override
  _ida.Future<void> invoke(
    _is.Session session,
    _is.SerializableModel? object,
  ) async {
    await _ixul5df8.ClinicJobsFutureCall().timerSweep(session);
  }
}

class DispatchSendFutureCall
    extends _is.FutureCall<_i65bud0x.DispatchFutureCallSendModel>
    implements _is.InvokableFutureCall<_i65bud0x.DispatchFutureCallSendModel> {
  @override
  _ida.Future<void> invoke(
    _is.Session session,
    _i65bud0x.DispatchFutureCallSendModel? object,
  ) async {
    if (object != null) {
      await _ismsz80w.DispatchFutureCall().send(
        session,
        object.notificationId,
      );
    }
  }
}

class SmokeFireFutureCall
    extends _is.FutureCall<_il52xcea.SmokeFutureCallFireModel>
    implements _is.InvokableFutureCall<_il52xcea.SmokeFutureCallFireModel> {
  @override
  _ida.Future<void> invoke(
    _is.Session session,
    _il52xcea.SmokeFutureCallFireModel? object,
  ) async {
    if (object != null) {
      await _i7gnn9mc.SmokeFutureCall().fire(
        session,
        object.runId,
      );
    }
  }
}

class TicketTimersGraceReminderFutureCall
    extends _is.FutureCall<_iau54etg.TicketTimersFutureCallGraceReminderModel>
    implements
        _is.InvokableFutureCall<
          _iau54etg.TicketTimersFutureCallGraceReminderModel
        > {
  @override
  _ida.Future<void> invoke(
    _is.Session session,
    _iau54etg.TicketTimersFutureCallGraceReminderModel? object,
  ) async {
    if (object != null) {
      await _iqqk37p5.TicketTimersFutureCall().graceReminder(
        session,
        object.ticketId,
        object.callVersion,
      );
    }
  }
}

class TicketTimersGraceExpiredFutureCall
    extends _is.FutureCall<_ikoguwcg.TicketTimersFutureCallGraceExpiredModel>
    implements
        _is.InvokableFutureCall<
          _ikoguwcg.TicketTimersFutureCallGraceExpiredModel
        > {
  @override
  _ida.Future<void> invoke(
    _is.Session session,
    _ikoguwcg.TicketTimersFutureCallGraceExpiredModel? object,
  ) async {
    if (object != null) {
      await _iqqk37p5.TicketTimersFutureCall().graceExpired(
        session,
        object.ticketId,
        object.callVersion,
      );
    }
  }
}

class TicketTimersArrivalExpiredFutureCall
    extends _is.FutureCall<_it6gb6op.TicketTimersFutureCallArrivalExpiredModel>
    implements
        _is.InvokableFutureCall<
          _it6gb6op.TicketTimersFutureCallArrivalExpiredModel
        > {
  @override
  _ida.Future<void> invoke(
    _is.Session session,
    _it6gb6op.TicketTimersFutureCallArrivalExpiredModel? object,
  ) async {
    if (object != null) {
      await _iqqk37p5.TicketTimersFutureCall().arrivalExpired(
        session,
        object.ticketId,
        object.callVersion,
      );
    }
  }
}
