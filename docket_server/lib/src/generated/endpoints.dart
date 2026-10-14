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
import 'package:docket_server/src/generated/enums/staff_role.dart' as _i3mk4hxi;
import 'package:docket_server/src/generated/future_calls.dart' as _iiwedh6t;
import 'package:docket_server/src/generated/tables/line.dart' as _if2dxarq;
import 'package:docket_server/src/generated/tables/room.dart' as _i5r8i9bj;
import 'package:docket_server/src/generated/wire/clinic_settings.dart'
    as _ict8zozl;
import 'package:docket_server/src/generated/wire/clinic_setup.dart'
    as _ixhioq28;
import 'package:docket_server/src/generated/wire/desk_action.dart' as _is5rundd;
import 'package:docket_server/src/generated/wire/join_request.dart'
    as _isnloaz6;
import 'package:docket_server/src/generated/wire/push_subscription_input.dart'
    as _igga5eoi;
import 'package:docket_server/src/generated/wire/sync_batch.dart' as _ipm7q0mh;
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _iacs;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _iais;
import '../auth/email_idp_endpoint.dart' as _iuc1hd5t;
import '../auth/jwt_refresh_endpoint.dart' as _inwq3ztq;
import '../endpoints/board_endpoint.dart' as _i3kupj20;
import '../endpoints/desk_endpoint.dart' as _isnuj8i8;
import '../endpoints/owner_endpoint.dart' as _i84vvo9h;
import '../endpoints/public_clinic_endpoint.dart' as _ia5ygczj;
import '../endpoints/sandbox_endpoint.dart' as _ie7tqwnd;
import '../endpoints/smoke_endpoint.dart' as _ivabzmjp;
import '../endpoints/staff_endpoint.dart' as _ih67es4w;
import '../endpoints/ticket_endpoint.dart' as _isjz18to;
export 'future_calls.dart' show ServerpodFutureCallsGetter;

class Endpoints extends _is.EndpointDispatch {
  @override
  void initializeEndpoints(_is.Server server) {
    var endpoints = <String, _is.Endpoint>{
      'emailIdp': _iuc1hd5t.EmailIdpEndpoint()
        ..initialize(
          server,
          'emailIdp',
          null,
        ),
      'jwtRefresh': _inwq3ztq.JwtRefreshEndpoint()
        ..initialize(
          server,
          'jwtRefresh',
          null,
        ),
      'board': _i3kupj20.BoardEndpoint()
        ..initialize(
          server,
          'board',
          null,
        ),
      'desk': _isnuj8i8.DeskEndpoint()
        ..initialize(
          server,
          'desk',
          null,
        ),
      'owner': _i84vvo9h.OwnerEndpoint()
        ..initialize(
          server,
          'owner',
          null,
        ),
      'publicClinic': _ia5ygczj.PublicClinicEndpoint()
        ..initialize(
          server,
          'publicClinic',
          null,
        ),
      'sandbox': _ie7tqwnd.SandboxEndpoint()
        ..initialize(
          server,
          'sandbox',
          null,
        ),
      'smoke': _ivabzmjp.SmokeEndpoint()
        ..initialize(
          server,
          'smoke',
          null,
        ),
      'staff': _ih67es4w.StaffEndpoint()
        ..initialize(
          server,
          'staff',
          null,
        ),
      'ticket': _isjz18to.TicketEndpoint()
        ..initialize(
          server,
          'ticket',
          null,
        ),
    };
    connectors['emailIdp'] = _is.EndpointConnector(
      name: 'emailIdp',
      endpoint: endpoints['emailIdp']!,
      methodConnectors: {
        'login': _is.MethodConnector(
          name: 'login',
          params: {
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'password': _is.ParameterDescription(
              name: 'password',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint).login(
                    session,
                    email: params['email'],
                    password: params['password'],
                  ),
        ),
        'startRegistration': _is.MethodConnector(
          name: 'startRegistration',
          params: {
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .startRegistration(
                    session,
                    email: params['email'],
                  ),
        ),
        'verifyRegistrationCode': _is.MethodConnector(
          name: 'verifyRegistrationCode',
          params: {
            'accountRequestId': _is.ParameterDescription(
              name: 'accountRequestId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'verificationCode': _is.ParameterDescription(
              name: 'verificationCode',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .verifyRegistrationCode(
                    session,
                    accountRequestId: params['accountRequestId'],
                    verificationCode: params['verificationCode'],
                  ),
        ),
        'finishRegistration': _is.MethodConnector(
          name: 'finishRegistration',
          params: {
            'registrationToken': _is.ParameterDescription(
              name: 'registrationToken',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'password': _is.ParameterDescription(
              name: 'password',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .finishRegistration(
                    session,
                    registrationToken: params['registrationToken'],
                    password: params['password'],
                  ),
        ),
        'startPasswordReset': _is.MethodConnector(
          name: 'startPasswordReset',
          params: {
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .startPasswordReset(
                    session,
                    email: params['email'],
                  ),
        ),
        'verifyPasswordResetCode': _is.MethodConnector(
          name: 'verifyPasswordResetCode',
          params: {
            'passwordResetRequestId': _is.ParameterDescription(
              name: 'passwordResetRequestId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'verificationCode': _is.ParameterDescription(
              name: 'verificationCode',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .verifyPasswordResetCode(
                    session,
                    passwordResetRequestId: params['passwordResetRequestId'],
                    verificationCode: params['verificationCode'],
                  ),
        ),
        'finishPasswordReset': _is.MethodConnector(
          name: 'finishPasswordReset',
          params: {
            'finishPasswordResetToken': _is.ParameterDescription(
              name: 'finishPasswordResetToken',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'newPassword': _is.ParameterDescription(
              name: 'newPassword',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .finishPasswordReset(
                    session,
                    finishPasswordResetToken:
                        params['finishPasswordResetToken'],
                    newPassword: params['newPassword'],
                  ),
        ),
        'hasAccount': _is.MethodConnector(
          name: 'hasAccount',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .hasAccount(session),
        ),
      },
    );
    connectors['jwtRefresh'] = _is.EndpointConnector(
      name: 'jwtRefresh',
      endpoint: endpoints['jwtRefresh']!,
      methodConnectors: {
        'refreshAccessToken': _is.MethodConnector(
          name: 'refreshAccessToken',
          params: {
            'refreshToken': _is.ParameterDescription(
              name: 'refreshToken',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['jwtRefresh'] as _inwq3ztq.JwtRefreshEndpoint)
                      .refreshAccessToken(
                        session,
                        refreshToken: params['refreshToken'],
                      ),
        ),
      },
    );
    connectors['board'] = _is.EndpointConnector(
      name: 'board',
      endpoint: endpoints['board']!,
      methodConnectors: {
        'get': _is.MethodConnector(
          name: 'get',
          params: {
            'boardToken': _is.ParameterDescription(
              name: 'boardToken',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['board'] as _i3kupj20.BoardEndpoint).get(
                session,
                params['boardToken'],
              ),
        ),
        'watch': _is.MethodStreamConnector(
          name: 'watch',
          params: {
            'boardToken': _is.ParameterDescription(
              name: 'boardToken',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          streamParams: {},
          returnType: _is.MethodStreamReturnType.streamType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['board'] as _i3kupj20.BoardEndpoint).watch(
                session,
                params['boardToken'],
              ),
        ),
      },
    );
    connectors['desk'] = _is.EndpointConnector(
      name: 'desk',
      endpoint: endpoints['desk']!,
      methodConnectors: {
        'getView': _is.MethodConnector(
          name: 'getView',
          params: {
            'clinicId': _is.ParameterDescription(
              name: 'clinicId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'sandboxToken': _is.ParameterDescription(
              name: 'sandboxToken',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['desk'] as _isnuj8i8.DeskEndpoint).getView(
                session,
                params['clinicId'],
                params['sandboxToken'],
              ),
        ),
        'act': _is.MethodConnector(
          name: 'act',
          params: {
            'action': _is.ParameterDescription(
              name: 'action',
              type: _is.getType<_is5rundd.DeskAction>(),
              nullable: false,
            ),
            'sandboxToken': _is.ParameterDescription(
              name: 'sandboxToken',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['desk'] as _isnuj8i8.DeskEndpoint).act(
                session,
                params['action'],
                params['sandboxToken'],
              ),
        ),
        'sync': _is.MethodConnector(
          name: 'sync',
          params: {
            'batch': _is.ParameterDescription(
              name: 'batch',
              type: _is.getType<_ipm7q0mh.SyncBatch>(),
              nullable: false,
            ),
            'sandboxToken': _is.ParameterDescription(
              name: 'sandboxToken',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['desk'] as _isnuj8i8.DeskEndpoint).sync(
                session,
                params['batch'],
                params['sandboxToken'],
              ),
        ),
        'heartbeat': _is.MethodConnector(
          name: 'heartbeat',
          params: {
            'clinicId': _is.ParameterDescription(
              name: 'clinicId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'deviceId': _is.ParameterDescription(
              name: 'deviceId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'roomId': _is.ParameterDescription(
              name: 'roomId',
              type: _is.getType<_is.UuidValue?>(),
              nullable: true,
            ),
            'sandboxToken': _is.ParameterDescription(
              name: 'sandboxToken',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['desk'] as _isnuj8i8.DeskEndpoint).heartbeat(
                    session,
                    params['clinicId'],
                    params['deviceId'],
                    params['roomId'],
                    params['sandboxToken'],
                  ),
        ),
        'linkPhone': _is.MethodConnector(
          name: 'linkPhone',
          params: {
            'ticketId': _is.ParameterDescription(
              name: 'ticketId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'sandboxToken': _is.ParameterDescription(
              name: 'sandboxToken',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['desk'] as _isnuj8i8.DeskEndpoint).linkPhone(
                    session,
                    params['ticketId'],
                    params['sandboxToken'],
                  ),
        ),
        'watch': _is.MethodStreamConnector(
          name: 'watch',
          params: {
            'clinicId': _is.ParameterDescription(
              name: 'clinicId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'deviceId': _is.ParameterDescription(
              name: 'deviceId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'sandboxToken': _is.ParameterDescription(
              name: 'sandboxToken',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          streamParams: {},
          returnType: _is.MethodStreamReturnType.streamType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['desk'] as _isnuj8i8.DeskEndpoint).watch(
                session,
                params['clinicId'],
                params['deviceId'],
                params['sandboxToken'],
              ),
        ),
      },
    );
    connectors['owner'] = _is.EndpointConnector(
      name: 'owner',
      endpoint: endpoints['owner']!,
      methodConnectors: {
        'createClinic': _is.MethodConnector(
          name: 'createClinic',
          params: {
            'setup': _is.ParameterDescription(
              name: 'setup',
              type: _is.getType<_ixhioq28.ClinicSetup>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['owner'] as _i84vvo9h.OwnerEndpoint).createClinic(
                    session,
                    params['setup'],
                  ),
        ),
        'getOwnerView': _is.MethodConnector(
          name: 'getOwnerView',
          params: {
            'clinicId': _is.ParameterDescription(
              name: 'clinicId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'sandboxToken': _is.ParameterDescription(
              name: 'sandboxToken',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['owner'] as _i84vvo9h.OwnerEndpoint).getOwnerView(
                    session,
                    params['clinicId'],
                    params['sandboxToken'],
                  ),
        ),
        'updateSettings': _is.MethodConnector(
          name: 'updateSettings',
          params: {
            'clinicId': _is.ParameterDescription(
              name: 'clinicId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'settings': _is.ParameterDescription(
              name: 'settings',
              type: _is.getType<_ict8zozl.ClinicSettings>(),
              nullable: false,
            ),
            'sandboxToken': _is.ParameterDescription(
              name: 'sandboxToken',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['owner'] as _i84vvo9h.OwnerEndpoint)
                  .updateSettings(
                    session,
                    params['clinicId'],
                    params['settings'],
                    params['sandboxToken'],
                  ),
        ),
        'upsertLine': _is.MethodConnector(
          name: 'upsertLine',
          params: {
            'clinicId': _is.ParameterDescription(
              name: 'clinicId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'line': _is.ParameterDescription(
              name: 'line',
              type: _is.getType<_if2dxarq.Line>(),
              nullable: false,
            ),
            'sandboxToken': _is.ParameterDescription(
              name: 'sandboxToken',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['owner'] as _i84vvo9h.OwnerEndpoint).upsertLine(
                    session,
                    params['clinicId'],
                    params['line'],
                    params['sandboxToken'],
                  ),
        ),
        'upsertRoom': _is.MethodConnector(
          name: 'upsertRoom',
          params: {
            'clinicId': _is.ParameterDescription(
              name: 'clinicId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'room': _is.ParameterDescription(
              name: 'room',
              type: _is.getType<_i5r8i9bj.Room>(),
              nullable: false,
            ),
            'sandboxToken': _is.ParameterDescription(
              name: 'sandboxToken',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['owner'] as _i84vvo9h.OwnerEndpoint).upsertRoom(
                    session,
                    params['clinicId'],
                    params['room'],
                    params['sandboxToken'],
                  ),
        ),
        'createInvite': _is.MethodConnector(
          name: 'createInvite',
          params: {
            'clinicId': _is.ParameterDescription(
              name: 'clinicId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'role': _is.ParameterDescription(
              name: 'role',
              type: _is.getType<_i3mk4hxi.StaffRole>(),
              nullable: false,
            ),
            'sandboxToken': _is.ParameterDescription(
              name: 'sandboxToken',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['owner'] as _i84vvo9h.OwnerEndpoint).createInvite(
                    session,
                    params['clinicId'],
                    params['role'],
                    params['sandboxToken'],
                  ),
        ),
        'listStaff': _is.MethodConnector(
          name: 'listStaff',
          params: {
            'clinicId': _is.ParameterDescription(
              name: 'clinicId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'sandboxToken': _is.ParameterDescription(
              name: 'sandboxToken',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['owner'] as _i84vvo9h.OwnerEndpoint).listStaff(
                    session,
                    params['clinicId'],
                    params['sandboxToken'],
                  ),
        ),
        'deactivateStaff': _is.MethodConnector(
          name: 'deactivateStaff',
          params: {
            'clinicId': _is.ParameterDescription(
              name: 'clinicId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'staffMemberId': _is.ParameterDescription(
              name: 'staffMemberId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'sandboxToken': _is.ParameterDescription(
              name: 'sandboxToken',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['owner'] as _i84vvo9h.OwnerEndpoint)
                  .deactivateStaff(
                    session,
                    params['clinicId'],
                    params['staffMemberId'],
                    params['sandboxToken'],
                  ),
        ),
        'rotateBoardToken': _is.MethodConnector(
          name: 'rotateBoardToken',
          params: {
            'clinicId': _is.ParameterDescription(
              name: 'clinicId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'sandboxToken': _is.ParameterDescription(
              name: 'sandboxToken',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['owner'] as _i84vvo9h.OwnerEndpoint)
                  .rotateBoardToken(
                    session,
                    params['clinicId'],
                    params['sandboxToken'],
                  ),
        ),
        'dayReport': _is.MethodConnector(
          name: 'dayReport',
          params: {
            'clinicId': _is.ParameterDescription(
              name: 'clinicId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'serviceDate': _is.ParameterDescription(
              name: 'serviceDate',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'sandboxToken': _is.ParameterDescription(
              name: 'sandboxToken',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['owner'] as _i84vvo9h.OwnerEndpoint).dayReport(
                    session,
                    params['clinicId'],
                    params['serviceDate'],
                    params['sandboxToken'],
                  ),
        ),
        'dayReportCsv': _is.MethodConnector(
          name: 'dayReportCsv',
          params: {
            'clinicId': _is.ParameterDescription(
              name: 'clinicId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'serviceDate': _is.ParameterDescription(
              name: 'serviceDate',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'sandboxToken': _is.ParameterDescription(
              name: 'sandboxToken',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['owner'] as _i84vvo9h.OwnerEndpoint).dayReportCsv(
                    session,
                    params['clinicId'],
                    params['serviceDate'],
                    params['sandboxToken'],
                  ),
        ),
        'audit': _is.MethodConnector(
          name: 'audit',
          params: {
            'clinicId': _is.ParameterDescription(
              name: 'clinicId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'serviceDate': _is.ParameterDescription(
              name: 'serviceDate',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'limit': _is.ParameterDescription(
              name: 'limit',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'before': _is.ParameterDescription(
              name: 'before',
              type: _is.getType<_is.UuidValue?>(),
              nullable: true,
            ),
            'sandboxToken': _is.ParameterDescription(
              name: 'sandboxToken',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['owner'] as _i84vvo9h.OwnerEndpoint).audit(
                session,
                params['clinicId'],
                params['serviceDate'],
                params['limit'],
                params['before'],
                params['sandboxToken'],
              ),
        ),
        'notificationLog': _is.MethodConnector(
          name: 'notificationLog',
          params: {
            'clinicId': _is.ParameterDescription(
              name: 'clinicId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'serviceDate': _is.ParameterDescription(
              name: 'serviceDate',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'limit': _is.ParameterDescription(
              name: 'limit',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'sandboxToken': _is.ParameterDescription(
              name: 'sandboxToken',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['owner'] as _i84vvo9h.OwnerEndpoint)
                  .notificationLog(
                    session,
                    params['clinicId'],
                    params['serviceDate'],
                    params['limit'],
                    params['sandboxToken'],
                  ),
        ),
      },
    );
    connectors['publicClinic'] = _is.EndpointConnector(
      name: 'publicClinic',
      endpoint: endpoints['publicClinic']!,
      methodConnectors: {
        'getClinic': _is.MethodConnector(
          name: 'getClinic',
          params: {
            'slug': _is.ParameterDescription(
              name: 'slug',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['publicClinic'] as _ia5ygczj.PublicClinicEndpoint)
                      .getClinic(
                        session,
                        params['slug'],
                      ),
        ),
        'join': _is.MethodConnector(
          name: 'join',
          params: {
            'request': _is.ParameterDescription(
              name: 'request',
              type: _is.getType<_isnloaz6.JoinRequest>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['publicClinic'] as _ia5ygczj.PublicClinicEndpoint)
                      .join(
                        session,
                        params['request'],
                      ),
        ),
        'vapidPublicKey': _is.MethodConnector(
          name: 'vapidPublicKey',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['publicClinic'] as _ia5ygczj.PublicClinicEndpoint)
                      .vapidPublicKey(session),
        ),
      },
    );
    connectors['sandbox'] = _is.EndpointConnector(
      name: 'sandbox',
      endpoint: endpoints['sandbox']!,
      methodConnectors: {
        'start': _is.MethodConnector(
          name: 'start',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['sandbox'] as _ie7tqwnd.SandboxEndpoint)
                  .start(session),
        ),
        'addDemoWalkIns': _is.MethodConnector(
          name: 'addDemoWalkIns',
          params: {
            'sandboxToken': _is.ParameterDescription(
              name: 'sandboxToken',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'lineId': _is.ParameterDescription(
              name: 'lineId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'count': _is.ParameterDescription(
              name: 'count',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['sandbox'] as _ie7tqwnd.SandboxEndpoint)
                  .addDemoWalkIns(
                    session,
                    params['sandboxToken'],
                    params['lineId'],
                    params['count'],
                  ),
        ),
      },
    );
    connectors['smoke'] = _is.EndpointConnector(
      name: 'smoke',
      endpoint: endpoints['smoke']!,
      methodConnectors: {
        'schedule': _is.MethodConnector(
          name: 'schedule',
          params: {
            'delaySeconds': _is.ParameterDescription(
              name: 'delaySeconds',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['smoke'] as _ivabzmjp.SmokeEndpoint).schedule(
                    session,
                    params['delaySeconds'],
                  ),
        ),
        'dbPing': _is.MethodConnector(
          name: 'dbPing',
          params: {
            'count': _is.ParameterDescription(
              name: 'count',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['smoke'] as _ivabzmjp.SmokeEndpoint).dbPing(
                session,
                params['count'],
              ),
        ),
        'cpu': _is.MethodConnector(
          name: 'cpu',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['smoke'] as _ivabzmjp.SmokeEndpoint).cpu(session),
        ),
        'ormPing': _is.MethodConnector(
          name: 'ormPing',
          params: {
            'count': _is.ParameterDescription(
              name: 'count',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['smoke'] as _ivabzmjp.SmokeEndpoint).ormPing(
                    session,
                    params['count'],
                  ),
        ),
        'runs': _is.MethodConnector(
          name: 'runs',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['smoke'] as _ivabzmjp.SmokeEndpoint).runs(session),
        ),
        'ticks': _is.MethodStreamConnector(
          name: 'ticks',
          params: {
            'count': _is.ParameterDescription(
              name: 'count',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          streamParams: {},
          returnType: _is.MethodStreamReturnType.streamType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['smoke'] as _ivabzmjp.SmokeEndpoint).ticks(
                session,
                params['count'],
              ),
        ),
        'idle': _is.MethodStreamConnector(
          name: 'idle',
          params: {
            'seconds': _is.ParameterDescription(
              name: 'seconds',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          streamParams: {},
          returnType: _is.MethodStreamReturnType.streamType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['smoke'] as _ivabzmjp.SmokeEndpoint).idle(
                session,
                params['seconds'],
              ),
        ),
      },
    );
    connectors['staff'] = _is.EndpointConnector(
      name: 'staff',
      endpoint: endpoints['staff']!,
      methodConnectors: {
        'myClinics': _is.MethodConnector(
          name: 'myClinics',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['staff'] as _ih67es4w.StaffEndpoint)
                  .myClinics(session),
        ),
        'acceptInvite': _is.MethodConnector(
          name: 'acceptInvite',
          params: {
            'code': _is.ParameterDescription(
              name: 'code',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['staff'] as _ih67es4w.StaffEndpoint).acceptInvite(
                    session,
                    params['code'],
                  ),
        ),
      },
    );
    connectors['ticket'] = _is.EndpointConnector(
      name: 'ticket',
      endpoint: endpoints['ticket']!,
      methodConnectors: {
        'get': _is.MethodConnector(
          name: 'get',
          params: {
            'token': _is.ParameterDescription(
              name: 'token',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['ticket'] as _isjz18to.TicketEndpoint).get(
                session,
                params['token'],
              ),
        ),
        'confirmComing': _is.MethodConnector(
          name: 'confirmComing',
          params: {
            'token': _is.ParameterDescription(
              name: 'token',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['ticket'] as _isjz18to.TicketEndpoint)
                  .confirmComing(
                    session,
                    params['token'],
                  ),
        ),
        'leave': _is.MethodConnector(
          name: 'leave',
          params: {
            'token': _is.ParameterDescription(
              name: 'token',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['ticket'] as _isjz18to.TicketEndpoint).leave(
                    session,
                    params['token'],
                  ),
        ),
        'registerPush': _is.MethodConnector(
          name: 'registerPush',
          params: {
            'token': _is.ParameterDescription(
              name: 'token',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'subscription': _is.ParameterDescription(
              name: 'subscription',
              type: _is.getType<_igga5eoi.PushSubscriptionInput>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['ticket'] as _isjz18to.TicketEndpoint)
                  .registerPush(
                    session,
                    params['token'],
                    params['subscription'],
                  ),
        ),
        'setPhone': _is.MethodConnector(
          name: 'setPhone',
          params: {
            'token': _is.ParameterDescription(
              name: 'token',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'phoneE164': _is.ParameterDescription(
              name: 'phoneE164',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'smsConsent': _is.ParameterDescription(
              name: 'smsConsent',
              type: _is.getType<bool>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['ticket'] as _isjz18to.TicketEndpoint).setPhone(
                    session,
                    params['token'],
                    params['phoneE164'],
                    params['smsConsent'],
                  ),
        ),
        'disableAlerts': _is.MethodConnector(
          name: 'disableAlerts',
          params: {
            'token': _is.ParameterDescription(
              name: 'token',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['ticket'] as _isjz18to.TicketEndpoint)
                  .disableAlerts(
                    session,
                    params['token'],
                  ),
        ),
        'watch': _is.MethodStreamConnector(
          name: 'watch',
          params: {
            'token': _is.ParameterDescription(
              name: 'token',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          streamParams: {},
          returnType: _is.MethodStreamReturnType.streamType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['ticket'] as _isjz18to.TicketEndpoint).watch(
                session,
                params['token'],
              ),
        ),
      },
    );
    modules['serverpod_auth_idp'] = _iais.Endpoints()
      ..initializeEndpoints(server);
    modules['serverpod_auth_core'] = _iacs.Endpoints()
      ..initializeEndpoints(server);
  }

  @override
  _is.FutureCallDispatch? get futureCalls {
    return _iiwedh6t.FutureCalls();
  }
}
