/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _ida;
import 'package:docket_client/src/protocol/enums/staff_role.dart' as _i3qgajxm;
import 'package:docket_client/src/protocol/tables/clinic.dart' as _iffp8h9p;
import 'package:docket_client/src/protocol/tables/day_report.dart' as _ixct4di9;
import 'package:docket_client/src/protocol/tables/line.dart' as _ilz2ieho;
import 'package:docket_client/src/protocol/tables/notification.dart'
    as _i08rcprj;
import 'package:docket_client/src/protocol/tables/room.dart' as _i2y3joxt;
import 'package:docket_client/src/protocol/tables/smoke_run.dart' as _ifwjb9hw;
import 'package:docket_client/src/protocol/tables/staff_member.dart'
    as _iwfe05od;
import 'package:docket_client/src/protocol/tables/ticket_event.dart'
    as _ixk98hjp;
import 'package:docket_client/src/protocol/wire/board_view.dart' as _iuif7oq6;
import 'package:docket_client/src/protocol/wire/clinic_public_info.dart'
    as _iu1rdjxj;
import 'package:docket_client/src/protocol/wire/clinic_settings.dart'
    as _ifqseceo;
import 'package:docket_client/src/protocol/wire/clinic_setup.dart' as _ifuvo1c8;
import 'package:docket_client/src/protocol/wire/desk_action.dart' as _i2krub4f;
import 'package:docket_client/src/protocol/wire/desk_action_result.dart'
    as _iy725f4v;
import 'package:docket_client/src/protocol/wire/desk_view.dart' as _iao3udcf;
import 'package:docket_client/src/protocol/wire/join_request.dart' as _iwm48qjc;
import 'package:docket_client/src/protocol/wire/join_result.dart' as _i13ilj48;
import 'package:docket_client/src/protocol/wire/membership.dart' as _in4aq3n2;
import 'package:docket_client/src/protocol/wire/owner_view.dart' as _i2ldla8y;
import 'package:docket_client/src/protocol/wire/patient_view.dart' as _ixr3t5cv;
import 'package:docket_client/src/protocol/wire/push_subscription_input.dart'
    as _iszl4h9f;
import 'package:docket_client/src/protocol/wire/sandbox_start.dart'
    as _itaujsh3;
import 'package:docket_client/src/protocol/wire/smoke_tick.dart' as _i51jr89c;
import 'package:docket_client/src/protocol/wire/staff_invite_view.dart'
    as _ir0qtcv3;
import 'package:docket_client/src/protocol/wire/sync_batch.dart' as _iu5zihe5;
import 'package:docket_client/src/protocol/wire/sync_result.dart' as _imo7as3p;
import 'package:http/http.dart' as _i85jenna;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _iacc;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _iaic;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'package:serverpod_database/serverpod_database.dart' as _isd;
import 'protocol.dart' as _il2as5qe;
import 'package:docket_client/migrations/migration_registry.dart';

/// By extending [EmailIdpBaseEndpoint], the email identity provider endpoints
/// are made available on the server and enable the corresponding sign-in widget
/// on the client.
/// {@category Endpoint}
class EndpointEmailIdp extends _iaic.EndpointEmailIdpBase {
  EndpointEmailIdp(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'emailIdp';

  /// Logs in the user and returns a new session.
  ///
  /// Throws an [EmailAccountLoginException] in case of errors, with reason:
  /// - [EmailAccountLoginExceptionReason.invalidCredentials] if the email or
  ///   password is incorrect.
  /// - [EmailAccountLoginExceptionReason.tooManyAttempts] if there have been
  ///   too many failed login attempts.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  @override
  _ida.Future<_iacc.AuthSuccess> login({
    required String email,
    required String password,
  }) => caller.callServerEndpoint<_iacc.AuthSuccess>(
    'emailIdp',
    'login',
    {
      'email': email,
      'password': password,
    },
  );

  /// Starts the registration for a new user account with an email-based login
  /// associated to it.
  ///
  /// Upon successful completion of this method, an email will have been
  /// sent to [email] with a verification link, which the user must open to
  /// complete the registration.
  ///
  /// Always returns a account request ID, which can be used to complete the
  /// registration. If the email is already registered, the returned ID will not
  /// be valid.
  @override
  _ida.Future<_isc.UuidValue> startRegistration({required String email}) =>
      caller.callServerEndpoint<_isc.UuidValue>(
        'emailIdp',
        'startRegistration',
        {'email': email},
      );

  /// Verifies an account request code and returns a token
  /// that can be used to complete the account creation.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the account request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.policyViolation] if the password
  ///   does not comply with the password policy.
  /// - [EmailAccountRequestExceptionReason.invalid] if no request exists
  ///   for the given [accountRequestId] or [verificationCode] is invalid.
  @override
  _ida.Future<String> verifyRegistrationCode({
    required _isc.UuidValue accountRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<String>(
    'emailIdp',
    'verifyRegistrationCode',
    {
      'accountRequestId': accountRequestId,
      'verificationCode': verificationCode,
    },
  );

  /// Completes a new account registration, creating a new auth user with a
  /// profile and attaching the given email account to it.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the account request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.policyViolation] if the password
  ///   does not comply with the password policy.
  /// - [EmailAccountRequestExceptionReason.invalid] if the [registrationToken]
  ///   is invalid.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  ///
  /// Returns a session for the newly created user.
  @override
  _ida.Future<_iacc.AuthSuccess> finishRegistration({
    required String registrationToken,
    required String password,
  }) => caller.callServerEndpoint<_iacc.AuthSuccess>(
    'emailIdp',
    'finishRegistration',
    {
      'registrationToken': registrationToken,
      'password': password,
    },
  );

  /// Requests a password reset for [email].
  ///
  /// If the email address is registered, an email with reset instructions will
  /// be send out. If the email is unknown, this method will have no effect.
  ///
  /// Always returns a password reset request ID, which can be used to complete
  /// the reset. If the email is not registered, the returned ID will not be
  /// valid.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts trying to request a password reset.
  ///
  @override
  _ida.Future<_isc.UuidValue> startPasswordReset({required String email}) =>
      caller.callServerEndpoint<_isc.UuidValue>(
        'emailIdp',
        'startPasswordReset',
        {'email': email},
      );

  /// Verifies a password reset code and returns a finishPasswordResetToken
  /// that can be used to finish the password reset.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.expired] if the password reset
  ///   request has already expired.
  /// - [EmailAccountPasswordResetExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts trying to verify the password reset.
  /// - [EmailAccountPasswordResetExceptionReason.invalid] if no request exists
  ///   for the given [passwordResetRequestId] or [verificationCode] is invalid.
  ///
  /// If multiple steps are required to complete the password reset, this endpoint
  /// should be overridden to return credentials for the next step instead
  /// of the credentials for setting the password.
  @override
  _ida.Future<String> verifyPasswordResetCode({
    required _isc.UuidValue passwordResetRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<String>(
    'emailIdp',
    'verifyPasswordResetCode',
    {
      'passwordResetRequestId': passwordResetRequestId,
      'verificationCode': verificationCode,
    },
  );

  /// Completes a password reset request by setting a new password.
  ///
  /// The [verificationCode] returned from [verifyPasswordResetCode] is used to
  /// validate the password reset request.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.expired] if the password reset
  ///   request has already expired.
  /// - [EmailAccountPasswordResetExceptionReason.policyViolation] if the new
  ///   password does not comply with the password policy.
  /// - [EmailAccountPasswordResetExceptionReason.invalid] if no request exists
  ///   for the given [passwordResetRequestId] or [verificationCode] is invalid.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  @override
  _ida.Future<void> finishPasswordReset({
    required String finishPasswordResetToken,
    required String newPassword,
  }) => caller.callServerEndpoint<void>(
    'emailIdp',
    'finishPasswordReset',
    {
      'finishPasswordResetToken': finishPasswordResetToken,
      'newPassword': newPassword,
    },
  );

  @override
  _ida.Future<bool> hasAccount() => caller.callServerEndpoint<bool>(
    'emailIdp',
    'hasAccount',
    {},
  );
}

/// By extending [RefreshJwtTokensEndpoint], the JWT token refresh endpoint
/// is made available on the server and enables automatic token refresh on the client.
/// {@category Endpoint}
class EndpointJwtRefresh extends _iacc.EndpointRefreshJwtTokens {
  EndpointJwtRefresh(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'jwtRefresh';

  /// Creates a new token pair for the given [refreshToken].
  ///
  /// If [refreshToken] is omitted, cookie-mode web clients fall back to the
  /// configured HttpOnly refresh cookie. When neither source is present this
  /// throws [RefreshTokenNotFoundException], the same public "no usable refresh
  /// credential" exception used for unknown refresh tokens.
  ///
  /// Can throw the following exceptions:
  /// -[RefreshTokenMalformedException]: refresh token is malformed and could
  ///   not be parsed. Not expected to happen for tokens issued by the server.
  /// -[RefreshTokenNotFoundException]: refresh token is unknown to the server.
  ///   Either the token was deleted or generated by a different server.
  /// -[RefreshTokenExpiredException]: refresh token has expired. Will happen
  ///   only if it has not been used within configured `refreshTokenLifetime`.
  /// -[RefreshTokenInvalidSecretException]: refresh token is incorrect, meaning
  ///   it does not refer to the current secret refresh token. This indicates
  ///   either a malfunctioning client or a malicious attempt by someone who has
  ///   obtained the refresh token. In this case the underlying refresh token
  ///   will be deleted, and access to it will expire fully when the last access
  ///   token is elapsed.
  ///
  /// This endpoint is unauthenticated, meaning the client won't include any
  /// authentication information with the call.
  @override
  _ida.Future<_iacc.AuthSuccess> refreshAccessToken({String? refreshToken}) =>
      caller.callServerEndpoint<_iacc.AuthSuccess>(
        'jwtRefresh',
        'refreshAccessToken',
        {'refreshToken': refreshToken},
        authenticated: false,
      );
}

/// The waiting-room screen, read-only by board token (PRD 9.4).
/// {@category Endpoint}
class EndpointBoard extends _isc.EndpointRef {
  EndpointBoard(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'board';

  _ida.Future<_iuif7oq6.BoardView> get(String boardToken) =>
      caller.callServerEndpoint<_iuif7oq6.BoardView>(
        'board',
        'get',
        {'boardToken': boardToken},
      );

  _ida.Stream<_iuif7oq6.BoardView> watch(String boardToken) =>
      caller.callStreamingServerEndpoint<
        _ida.Stream<_iuif7oq6.BoardView>,
        _iuif7oq6.BoardView
      >(
        'board',
        'watch',
        {'boardToken': boardToken},
        {},
      );
}

/// The desk. `requireLogin` stays false so sandbox tokens work, and every
/// method authorizes through [ClinicAuth.desk] first (PRD 9.3).
/// {@category Endpoint}
class EndpointDesk extends _isc.EndpointRef {
  EndpointDesk(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'desk';

  _ida.Future<_iao3udcf.DeskView> getView(
    _isc.UuidValue clinicId,
    String? sandboxToken,
  ) => caller.callServerEndpoint<_iao3udcf.DeskView>(
    'desk',
    'getView',
    {
      'clinicId': clinicId,
      'sandboxToken': sandboxToken,
    },
  );

  _ida.Stream<_iao3udcf.DeskView> watch(
    _isc.UuidValue clinicId,
    _isc.UuidValue deviceId,
    String? sandboxToken,
  ) =>
      caller.callStreamingServerEndpoint<
        _ida.Stream<_iao3udcf.DeskView>,
        _iao3udcf.DeskView
      >(
        'desk',
        'watch',
        {
          'clinicId': clinicId,
          'deviceId': deviceId,
          'sandboxToken': sandboxToken,
        },
        {},
      );

  _ida.Future<_iy725f4v.DeskActionResult> act(
    _i2krub4f.DeskAction action,
    String? sandboxToken,
  ) => caller.callServerEndpoint<_iy725f4v.DeskActionResult>(
    'desk',
    'act',
    {
      'action': action,
      'sandboxToken': sandboxToken,
    },
  );

  /// Replays an offline outbox in `seq` order. Authorization is checked
  /// again for every action, and the server's answer always wins (PRD 15.4).
  _ida.Future<_imo7as3p.SyncResult> sync(
    _iu5zihe5.SyncBatch batch,
    String? sandboxToken,
  ) => caller.callServerEndpoint<_imo7as3p.SyncResult>(
    'desk',
    'sync',
    {
      'batch': batch,
      'sandboxToken': sandboxToken,
    },
  );

  _ida.Future<void> heartbeat(
    _isc.UuidValue clinicId,
    _isc.UuidValue deviceId,
    _isc.UuidValue? roomId,
    String? sandboxToken,
  ) => caller.callServerEndpoint<void>(
    'desk',
    'heartbeat',
    {
      'clinicId': clinicId,
      'deviceId': deviceId,
      'roomId': roomId,
      'sandboxToken': sandboxToken,
    },
  );

  /// Rotates a ticket's token so the desk can show a fresh QR to a walk-in.
  /// The old link stops working (PRD 18).
  _ida.Future<String> linkPhone(
    _isc.UuidValue ticketId,
    String? sandboxToken,
  ) => caller.callServerEndpoint<String>(
    'desk',
    'linkPhone',
    {
      'ticketId': ticketId,
      'sandboxToken': sandboxToken,
    },
  );
}

/// The owner console. `requireLogin` stays false so sandbox tokens work,
/// and every method authorizes through [ClinicAuth.owner] (PRD 9.5).
/// {@category Endpoint}
class EndpointOwner extends _isc.EndpointRef {
  EndpointOwner(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'owner';

  _ida.Future<_iffp8h9p.Clinic> createClinic(_ifuvo1c8.ClinicSetup setup) =>
      caller.callServerEndpoint<_iffp8h9p.Clinic>(
        'owner',
        'createClinic',
        {'setup': setup},
      );

  _ida.Future<_i2ldla8y.OwnerView> getOwnerView(
    _isc.UuidValue clinicId,
    String? sandboxToken,
  ) => caller.callServerEndpoint<_i2ldla8y.OwnerView>(
    'owner',
    'getOwnerView',
    {
      'clinicId': clinicId,
      'sandboxToken': sandboxToken,
    },
  );

  _ida.Future<_iffp8h9p.Clinic> updateSettings(
    _isc.UuidValue clinicId,
    _ifqseceo.ClinicSettings settings,
    String? sandboxToken,
  ) => caller.callServerEndpoint<_iffp8h9p.Clinic>(
    'owner',
    'updateSettings',
    {
      'clinicId': clinicId,
      'settings': settings,
      'sandboxToken': sandboxToken,
    },
  );

  _ida.Future<_ilz2ieho.Line> upsertLine(
    _isc.UuidValue clinicId,
    _ilz2ieho.Line line,
    String? sandboxToken,
  ) => caller.callServerEndpoint<_ilz2ieho.Line>(
    'owner',
    'upsertLine',
    {
      'clinicId': clinicId,
      'line': line,
      'sandboxToken': sandboxToken,
    },
  );

  _ida.Future<_i2y3joxt.Room> upsertRoom(
    _isc.UuidValue clinicId,
    _i2y3joxt.Room room,
    String? sandboxToken,
  ) => caller.callServerEndpoint<_i2y3joxt.Room>(
    'owner',
    'upsertRoom',
    {
      'clinicId': clinicId,
      'room': room,
      'sandboxToken': sandboxToken,
    },
  );

  _ida.Future<_ir0qtcv3.StaffInviteView> createInvite(
    _isc.UuidValue clinicId,
    _i3qgajxm.StaffRole role,
    String? sandboxToken,
  ) => caller.callServerEndpoint<_ir0qtcv3.StaffInviteView>(
    'owner',
    'createInvite',
    {
      'clinicId': clinicId,
      'role': role,
      'sandboxToken': sandboxToken,
    },
  );

  _ida.Future<List<_iwfe05od.StaffMember>> listStaff(
    _isc.UuidValue clinicId,
    String? sandboxToken,
  ) => caller.callServerEndpoint<List<_iwfe05od.StaffMember>>(
    'owner',
    'listStaff',
    {
      'clinicId': clinicId,
      'sandboxToken': sandboxToken,
    },
  );

  _ida.Future<void> deactivateStaff(
    _isc.UuidValue clinicId,
    _isc.UuidValue staffMemberId,
    String? sandboxToken,
  ) => caller.callServerEndpoint<void>(
    'owner',
    'deactivateStaff',
    {
      'clinicId': clinicId,
      'staffMemberId': staffMemberId,
      'sandboxToken': sandboxToken,
    },
  );

  _ida.Future<String> rotateBoardToken(
    _isc.UuidValue clinicId,
    String? sandboxToken,
  ) => caller.callServerEndpoint<String>(
    'owner',
    'rotateBoardToken',
    {
      'clinicId': clinicId,
      'sandboxToken': sandboxToken,
    },
  );

  _ida.Future<_ixct4di9.DayReport> dayReport(
    _isc.UuidValue clinicId,
    String serviceDate,
    String? sandboxToken,
  ) => caller.callServerEndpoint<_ixct4di9.DayReport>(
    'owner',
    'dayReport',
    {
      'clinicId': clinicId,
      'serviceDate': serviceDate,
      'sandboxToken': sandboxToken,
    },
  );

  _ida.Future<String> dayReportCsv(
    _isc.UuidValue clinicId,
    String serviceDate,
    String? sandboxToken,
  ) => caller.callServerEndpoint<String>(
    'owner',
    'dayReportCsv',
    {
      'clinicId': clinicId,
      'serviceDate': serviceDate,
      'sandboxToken': sandboxToken,
    },
  );

  _ida.Future<List<_ixk98hjp.TicketEvent>> audit(
    _isc.UuidValue clinicId,
    String serviceDate,
    int limit,
    _isc.UuidValue? before,
    String? sandboxToken,
  ) => caller.callServerEndpoint<List<_ixk98hjp.TicketEvent>>(
    'owner',
    'audit',
    {
      'clinicId': clinicId,
      'serviceDate': serviceDate,
      'limit': limit,
      'before': before,
      'sandboxToken': sandboxToken,
    },
  );

  _ida.Future<List<_i08rcprj.Notification>> notificationLog(
    _isc.UuidValue clinicId,
    String serviceDate,
    int limit,
    String? sandboxToken,
  ) => caller.callServerEndpoint<List<_i08rcprj.Notification>>(
    'owner',
    'notificationLog',
    {
      'clinicId': clinicId,
      'serviceDate': serviceDate,
      'limit': limit,
      'sandboxToken': sandboxToken,
    },
  );
}

/// Joining a line, no sign-in (PRD 9.1).
/// {@category Endpoint}
class EndpointPublicClinic extends _isc.EndpointRef {
  EndpointPublicClinic(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'publicClinic';

  _ida.Future<_iu1rdjxj.ClinicPublicInfo> getClinic(String slug) =>
      caller.callServerEndpoint<_iu1rdjxj.ClinicPublicInfo>(
        'publicClinic',
        'getClinic',
        {'slug': slug},
      );

  _ida.Future<_i13ilj48.JoinResult> join(_iwm48qjc.JoinRequest request) =>
      caller.callServerEndpoint<_i13ilj48.JoinResult>(
        'publicClinic',
        'join',
        {'request': request},
      );

  _ida.Future<String> vapidPublicKey() => caller.callServerEndpoint<String>(
    'publicClinic',
    'vapidPublicKey',
    {},
  );
}

/// Throwaway clinics for judges and demos, purged after 24 hours
/// (PRD 9.7). Sandboxes never send SMS and hold at most 200 tickets.
/// {@category Endpoint}
class EndpointSandbox extends _isc.EndpointRef {
  EndpointSandbox(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'sandbox';

  _ida.Future<_itaujsh3.SandboxStart> start() =>
      caller.callServerEndpoint<_itaujsh3.SandboxStart>(
        'sandbox',
        'start',
        {},
      );

  /// Demo patients go through the same join path as real ones and carry
  /// `isDemo`, which every surface labels DEMO.
  _ida.Future<_iao3udcf.DeskView> addDemoWalkIns(
    String sandboxToken,
    _isc.UuidValue lineId,
    int count,
  ) => caller.callServerEndpoint<_iao3udcf.DeskView>(
    'sandbox',
    'addDemoWalkIns',
    {
      'sandboxToken': sandboxToken,
      'lineId': lineId,
      'count': count,
    },
  );
}

/// Component 1 Cloud check: a stream that ticks once a second and a future
/// call scheduled a minute out whose firing time is stored.
/// {@category Endpoint}
class EndpointSmoke extends _isc.EndpointRef {
  EndpointSmoke(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'smoke';

  _ida.Stream<_i51jr89c.SmokeTick> ticks(int count) =>
      caller.callStreamingServerEndpoint<
        _ida.Stream<_i51jr89c.SmokeTick>,
        _i51jr89c.SmokeTick
      >(
        'smoke',
        'ticks',
        {'count': count},
        {},
      );

  /// Sends one value, stays silent for [seconds], then sends another, to
  /// measure how long an idle stream survives Cloud's load balancer
  /// (PRD 23).
  _ida.Stream<_i51jr89c.SmokeTick> idle(int seconds) =>
      caller.callStreamingServerEndpoint<
        _ida.Stream<_i51jr89c.SmokeTick>,
        _i51jr89c.SmokeTick
      >(
        'smoke',
        'idle',
        {'seconds': seconds},
        {},
      );

  _ida.Future<_ifwjb9hw.SmokeRun> schedule(int delaySeconds) =>
      caller.callServerEndpoint<_ifwjb9hw.SmokeRun>(
        'smoke',
        'schedule',
        {'delaySeconds': delaySeconds},
      );

  /// Times [count] trivial round trips to the database from this podlet,
  /// in microseconds each, to separate database latency from network.
  _ida.Future<List<int>> dbPing(int count) =>
      caller.callServerEndpoint<List<int>>(
        'smoke',
        'dbPing',
        {'count': count},
      );

  /// A fixed CPU workload, timed in milliseconds, to compare this podlet's
  /// CPU with a development machine.
  _ida.Future<int> cpu() => caller.callServerEndpoint<int>(
    'smoke',
    'cpu',
    {},
  );

  /// [count] primary-key reads through the ORM, in microseconds each.
  _ida.Future<List<int>> ormPing(int count) =>
      caller.callServerEndpoint<List<int>>(
        'smoke',
        'ormPing',
        {'count': count},
      );

  _ida.Future<List<_ifwjb9hw.SmokeRun>> runs() =>
      caller.callServerEndpoint<List<_ifwjb9hw.SmokeRun>>(
        'smoke',
        'runs',
        {},
      );
}

/// Memberships for a signed-in person (PRD 9.6).
/// {@category Endpoint}
class EndpointStaff extends _isc.EndpointRef {
  EndpointStaff(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'staff';

  _ida.Future<List<_in4aq3n2.Membership>> myClinics() =>
      caller.callServerEndpoint<List<_in4aq3n2.Membership>>(
        'staff',
        'myClinics',
        {},
      );

  _ida.Future<_in4aq3n2.Membership> acceptInvite(String code) =>
      caller.callServerEndpoint<_in4aq3n2.Membership>(
        'staff',
        'acceptInvite',
        {'code': code},
      );
}

/// The patient's ticket. The token in the URL is the capability, no sign-in
/// (PRD 9.2).
/// {@category Endpoint}
class EndpointTicket extends _isc.EndpointRef {
  EndpointTicket(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'ticket';

  _ida.Future<_ixr3t5cv.PatientView> get(String token) =>
      caller.callServerEndpoint<_ixr3t5cv.PatientView>(
        'ticket',
        'get',
        {'token': token},
      );

  _ida.Stream<_ixr3t5cv.PatientView> watch(String token) =>
      caller.callStreamingServerEndpoint<
        _ida.Stream<_ixr3t5cv.PatientView>,
        _ixr3t5cv.PatientView
      >(
        'ticket',
        'watch',
        {'token': token},
        {},
      );

  _ida.Future<_ixr3t5cv.PatientView> confirmComing(String token) =>
      caller.callServerEndpoint<_ixr3t5cv.PatientView>(
        'ticket',
        'confirmComing',
        {'token': token},
      );

  _ida.Future<_ixr3t5cv.PatientView> leave(String token) =>
      caller.callServerEndpoint<_ixr3t5cv.PatientView>(
        'ticket',
        'leave',
        {'token': token},
      );

  _ida.Future<_ixr3t5cv.PatientView> registerPush(
    String token,
    _iszl4h9f.PushSubscriptionInput subscription,
  ) => caller.callServerEndpoint<_ixr3t5cv.PatientView>(
    'ticket',
    'registerPush',
    {
      'token': token,
      'subscription': subscription,
    },
  );

  _ida.Future<_ixr3t5cv.PatientView> setPhone(
    String token,
    String phoneE164,
    bool smsConsent,
  ) => caller.callServerEndpoint<_ixr3t5cv.PatientView>(
    'ticket',
    'setPhone',
    {
      'token': token,
      'phoneE164': phoneE164,
      'smsConsent': smsConsent,
    },
  );

  _ida.Future<_ixr3t5cv.PatientView> disableAlerts(String token) =>
      caller.callServerEndpoint<_ixr3t5cv.PatientView>(
        'ticket',
        'disableAlerts',
        {'token': token},
      );
}

class Modules {
  Modules(Client client) {
    serverpod_auth_idp = _iaic.Caller(client);
    serverpod_auth_core = _iacc.Caller(client);
  }

  late final _iaic.Caller serverpod_auth_idp;

  late final _iacc.Caller serverpod_auth_core;
}

class Client extends _isc.ServerpodClientShared {
  Client(
    String host, {
    dynamic securityContext,
    Duration? streamingConnectionTimeout,
    Duration? connectionTimeout,
    Function(
      _isc.MethodCallContext,
      Object,
      StackTrace,
    )?
    onFailedCall,
    Function(_isc.MethodCallContext)? onSucceededCall,
    bool? disconnectStreamsOnLostInternetConnection,
    _i85jenna.Client? httpClientOverride,
  }) : super(
         host,
         _il2as5qe.Protocol(),
         securityContext: securityContext,
         streamingConnectionTimeout: streamingConnectionTimeout,
         connectionTimeout: connectionTimeout,
         onFailedCall: onFailedCall,
         onSucceededCall: onSucceededCall,
         disconnectStreamsOnLostInternetConnection:
             disconnectStreamsOnLostInternetConnection,
         httpClientOverride: httpClientOverride,
       ) {
    emailIdp = EndpointEmailIdp(this);
    jwtRefresh = EndpointJwtRefresh(this);
    board = EndpointBoard(this);
    desk = EndpointDesk(this);
    owner = EndpointOwner(this);
    publicClinic = EndpointPublicClinic(this);
    sandbox = EndpointSandbox(this);
    smoke = EndpointSmoke(this);
    staff = EndpointStaff(this);
    ticket = EndpointTicket(this);
    modules = Modules(this);
  }

  late final EndpointEmailIdp emailIdp;

  late final EndpointJwtRefresh jwtRefresh;

  late final EndpointBoard board;

  late final EndpointDesk desk;

  late final EndpointOwner owner;

  late final EndpointPublicClinic publicClinic;

  late final EndpointSandbox sandbox;

  late final EndpointSmoke smoke;

  late final EndpointStaff staff;

  late final EndpointTicket ticket;

  late final Modules modules;

  @override
  Map<String, _isc.EndpointRef> get endpointRefLookup => {
    'emailIdp': emailIdp,
    'jwtRefresh': jwtRefresh,
    'board': board,
    'desk': desk,
    'owner': owner,
    'publicClinic': publicClinic,
    'sandbox': sandbox,
    'smoke': smoke,
    'staff': staff,
    'ticket': ticket,
  };

  @override
  Map<String, _isc.ModuleEndpointCaller> get moduleLookup => {
    'serverpod_auth_idp': modules.serverpod_auth_idp,
    'serverpod_auth_core': modules.serverpod_auth_core,
  };

  /// Creates a new client-side database session for the given path.
  ///
  /// The [path] is the file path to the SQLite database file. Since SQLite uses
  /// WAL mode, note that `[path]-shm` and `[path]-wal` files might also exist
  /// transiently for the database while the session is open.
  ///
  /// If [runMigrations] is true, pending migrations will be applied when
  /// opening the database. Be careful when setting this to false, as it might
  /// lead to inconsistencies between the models and the database.
  ///
  /// If [isDebugMode] is true, the database integrity will be verified after
  /// the migrations are applied to provide feedback of possible issues. On a
  /// Flutter application, this should be set to [kDebugMode].
  _ida.Future<_isd.ClientDatabaseSession> createSession(
    String path, {
    bool runMigrations = true,
    bool isDebugMode = false,
  }) async {
    return await _isd.ClientDatabaseSession.open(
      path,
      _il2as5qe.Protocol(),
      clientMigrations: MigrationRegistry.migrations,
      runMigrations: runMigrations,
      isDebugMode: isDebugMode,
    );
  }
}
