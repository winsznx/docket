/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: dead_code, unnecessary_type_check

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:docket_server/src/generated/tables/notification.dart'
    as _i5kmsnma;
import 'package:docket_server/src/generated/tables/smoke_run.dart' as _ihlom2lm;
import 'package:docket_server/src/generated/tables/staff_member.dart'
    as _in3dutg9;
import 'package:docket_server/src/generated/tables/ticket_event.dart'
    as _i4alk30e;
import 'package:docket_server/src/generated/wire/membership.dart' as _iu90snls;
import 'package:serverpod/protocol.dart' as _isp;
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _iacs;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _iais;
import 'client/desk_meta.dart' as _itsmgqrp;
import 'client/local_ticket.dart' as _ifnbbn5d;
import 'client/outbox_action.dart' as _ipibroog;
import 'enums/action_outcome.dart' as _id6z13wr;
import 'enums/actor_type.dart' as _ip5zeyz4;
import 'enums/channel.dart' as _ihe3eiri;
import 'enums/day_state.dart' as _iiugpsnp;
import 'enums/delivery_status.dart' as _iz7e19vi;
import 'enums/docket_error_code.dart' as _i9onbghe;
import 'enums/docket_exception.dart' as _icekk0hy;
import 'enums/notification_kind.dart' as _ivjbs79x;
import 'enums/priority_reason.dart' as _i1vgsurr;
import 'enums/room_state.dart' as _isbuatcx;
import 'enums/staff_role.dart' as _ij8mfwy5;
import 'enums/ticket_event_type.dart' as _ivoofwb9;
import 'enums/ticket_state.dart' as _ih6coe2p;
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
import 'tables/clinic.dart' as _i1tv74l0;
import 'tables/day_report.dart' as _i6l2o3m9;
import 'tables/desk_action_receipt.dart' as _itbbh7rx;
import 'tables/desk_presence.dart' as _ichzzdg7;
import 'tables/line.dart' as _iuohjp42;
import 'tables/notification.dart' as _izbep4h6;
import 'tables/push_target.dart' as _i0f5mftr;
import 'tables/rate_bucket.dart' as _i6umewsv;
import 'tables/room.dart' as _ie9hxdgh;
import 'tables/service_day.dart' as _iwu7p9fm;
import 'tables/service_sample.dart' as _ik8e9gcd;
import 'tables/smoke_run.dart' as _i35vexo7;
import 'tables/sms_target.dart' as _ibpxb7a0;
import 'tables/staff_invite.dart' as _iiv296lb;
import 'tables/staff_member.dart' as _ioipfu19;
import 'tables/ticket.dart' as _ibp03sd9;
import 'tables/ticket_event.dart' as _i2hyp4di;
import 'wire/board_call.dart' as _insujfc6;
import 'wire/board_room.dart' as _iu648fp6;
import 'wire/board_view.dart' as _i8bbdmi3;
import 'wire/clinic_changed.dart' as _i55fq8ss;
import 'wire/clinic_public_info.dart' as _imia8rlj;
import 'wire/clinic_settings.dart' as _idokcveh;
import 'wire/clinic_setup.dart' as _idcgk93b;
import 'wire/day_report_data.dart' as _ilvaaaqm;
import 'wire/desk_action.dart' as _imnqx1va;
import 'wire/desk_action_result.dart' as _ifdo9b42;
import 'wire/desk_view.dart' as _i6zaqvnc;
import 'wire/join_request.dart' as _iiyugm4n;
import 'wire/join_result.dart' as _irl6or83;
import 'wire/line_changed.dart' as _iaav6pk8;
import 'wire/line_public_info.dart' as _i8u9vtwn;
import 'wire/line_report.dart' as _ib23o5eu;
import 'wire/line_setup.dart' as _iz6z9tvl;
import 'wire/line_view.dart' as _ii0c3htl;
import 'wire/membership.dart' as _i02wmc63;
import 'wire/owner_view.dart' as _i8afvum2;
import 'wire/patient_view.dart' as _iv020hjy;
import 'wire/push_subscription_input.dart' as _irbn5ekl;
import 'wire/room_setup.dart' as _igi3ijtw;
import 'wire/room_view.dart' as _irlx3wvg;
import 'wire/sandbox_start.dart' as _if96k0su;
import 'wire/smoke_tick.dart' as _i840or10;
import 'wire/staff_invite_view.dart' as _izd9tkxm;
import 'wire/sync_batch.dart' as _i31pag7v;
import 'wire/sync_result.dart' as _il8pbprb;
import 'wire/ticket_changed.dart' as _i0kt8to1;
import 'wire/ticket_view.dart' as _isastcde;
export 'client/desk_meta.dart';
export 'client/local_ticket.dart';
export 'client/outbox_action.dart';
export 'enums/action_outcome.dart';
export 'enums/actor_type.dart';
export 'enums/channel.dart';
export 'enums/day_state.dart';
export 'enums/delivery_status.dart';
export 'enums/docket_error_code.dart';
export 'enums/docket_exception.dart';
export 'enums/notification_kind.dart';
export 'enums/priority_reason.dart';
export 'enums/room_state.dart';
export 'enums/staff_role.dart';
export 'enums/ticket_event_type.dart';
export 'enums/ticket_state.dart';
export 'tables/clinic.dart';
export 'tables/day_report.dart';
export 'tables/desk_action_receipt.dart';
export 'tables/desk_presence.dart';
export 'tables/line.dart';
export 'tables/notification.dart';
export 'tables/push_target.dart';
export 'tables/rate_bucket.dart';
export 'tables/room.dart';
export 'tables/service_day.dart';
export 'tables/service_sample.dart';
export 'tables/smoke_run.dart';
export 'tables/sms_target.dart';
export 'tables/staff_invite.dart';
export 'tables/staff_member.dart';
export 'tables/ticket.dart';
export 'tables/ticket_event.dart';
export 'wire/board_call.dart';
export 'wire/board_room.dart';
export 'wire/board_view.dart';
export 'wire/clinic_changed.dart';
export 'wire/clinic_public_info.dart';
export 'wire/clinic_settings.dart';
export 'wire/clinic_setup.dart';
export 'wire/day_report_data.dart';
export 'wire/desk_action.dart';
export 'wire/desk_action_result.dart';
export 'wire/desk_view.dart';
export 'wire/join_request.dart';
export 'wire/join_result.dart';
export 'wire/line_changed.dart';
export 'wire/line_public_info.dart';
export 'wire/line_report.dart';
export 'wire/line_setup.dart';
export 'wire/line_view.dart';
export 'wire/membership.dart';
export 'wire/owner_view.dart';
export 'wire/patient_view.dart';
export 'wire/push_subscription_input.dart';
export 'wire/room_setup.dart';
export 'wire/room_view.dart';
export 'wire/sandbox_start.dart';
export 'wire/smoke_tick.dart';
export 'wire/staff_invite_view.dart';
export 'wire/sync_batch.dart';
export 'wire/sync_result.dart';
export 'wire/ticket_changed.dart';
export 'wire/ticket_view.dart';

class Protocol extends _is.DatabaseSerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._().._registerHostProtocols();

  static List<_isp.TableDefinition> get targetTableDefinitions => [
    _isp.TableDefinition(
      name: 'clinic',
      dartName: 'Clinic',
      schema: 'public',
      module: 'docket',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'name',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'slug',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'timezone',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
          columnDefault: '\'Africa/Lagos\'',
        ),
        _isp.ColumnDefinition(
          name: 'openTime',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
          columnDefault: '\'08:00\'',
        ),
        _isp.ColumnDefinition(
          name: 'joinCutoffTime',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
          columnDefault: '\'17:00\'',
        ),
        _isp.ColumnDefinition(
          name: 'closeTime',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
          columnDefault: '\'18:00\'',
        ),
        _isp.ColumnDefinition(
          name: 'autoCloseAfterMinutes',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '120',
        ),
        _isp.ColumnDefinition(
          name: 'graceSeconds',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '180',
        ),
        _isp.ColumnDefinition(
          name: 'graceReminderSeconds',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '60',
        ),
        _isp.ColumnDefinition(
          name: 'arrivalSeconds',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '600',
        ),
        _isp.ColumnDefinition(
          name: 'headsUpPositions',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '2',
        ),
        _isp.ColumnDefinition(
          name: 'headsUpMinutes',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '10',
        ),
        _isp.ColumnDefinition(
          name: 'reslotOffset',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '3',
        ),
        _isp.ColumnDefinition(
          name: 'maxReslots',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '1',
        ),
        _isp.ColumnDefinition(
          name: 'smsEnabled',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
        _isp.ColumnDefinition(
          name: 'isSandbox',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
        _isp.ColumnDefinition(
          name: 'sandboxExpiresAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'boardTokenHash',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'sandboxTokenHash',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'clinic_slug_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'slug',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'day_report',
      dartName: 'DayReport',
      schema: 'public',
      module: 'docket',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'clinicId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'serviceDate',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'generatedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'data',
          columnType: _isp.ColumnType.jsonb,
          isNullable: false,
          dartType: 'protocol:DayReportData',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'day_report_clinic_date_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'clinicId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'serviceDate',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'desk_action_receipt',
      dartName: 'DeskActionReceipt',
      schema: 'public',
      module: 'docket',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'actionId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'deviceId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'seq',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'clinicId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'outcome',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:ActionOutcome',
        ),
        _isp.ColumnDefinition(
          name: 'code',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'protocol:DocketErrorCode?',
        ),
        _isp.ColumnDefinition(
          name: 'message',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'ticketId',
          columnType: _isp.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _isp.ColumnDefinition(
          name: 'appliedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'desk_action_receipt_action_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'actionId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'desk_presence',
      dartName: 'DeskPresence',
      schema: 'public',
      module: 'docket',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'clinicId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'deviceId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'roomId',
          columnType: _isp.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _isp.ColumnDefinition(
          name: 'actorRef',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'lastSeenAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'desk_presence_device_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'deviceId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'desk_presence_clinic_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'clinicId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'lastSeenAt',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'line',
      dartName: 'Line',
      schema: 'public',
      module: 'docket',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'clinicId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'name',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'code',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'defaultServiceSeconds',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '480',
        ),
        _isp.ColumnDefinition(
          name: 'acceptingJoins',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'true',
        ),
        _isp.ColumnDefinition(
          name: 'version',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _isp.ColumnDefinition(
          name: 'sortOrder',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'line_fk_0',
          columns: ['clinicId'],
          referenceTable: 'clinic',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'line_clinic_code_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'clinicId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'code',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'notification',
      dartName: 'Notification',
      schema: 'public',
      module: 'docket',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'ticketId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'clinicId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'ticketLabel',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'kind',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:NotificationKind',
        ),
        _isp.ColumnDefinition(
          name: 'channel',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:Channel',
        ),
        _isp.ColumnDefinition(
          name: 'status',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:DeliveryStatus',
        ),
        _isp.ColumnDefinition(
          name: 'dedupeKey',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'callVersion',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _isp.ColumnDefinition(
          name: 'attempts',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _isp.ColumnDefinition(
          name: 'providerRef',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'error',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
        _isp.ColumnDefinition(
          name: 'sentAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'notification_dedupe_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'dedupeKey',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'notification_clinic_created_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'clinicId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'createdAt',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'notification_ticket_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'ticketId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'notification_provider_ref_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'providerRef',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'push_target',
      dartName: 'PushTarget',
      schema: 'public',
      module: 'docket',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'ticketId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'endpoint',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'p256dh',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'authSecret',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'linkCipher',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'active',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'true',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'push_target_ticket_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'ticketId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'rate_bucket',
      dartName: 'RateBucket',
      schema: 'public',
      module: 'docket',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'bucketKey',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'windowStart',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'hits',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'rate_bucket_key_window_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'bucketKey',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'windowStart',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'room',
      dartName: 'Room',
      schema: 'public',
      module: 'docket',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'clinicId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'lineId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'name',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'state',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:RoomState',
          columnDefault: '\'open\'',
        ),
        _isp.ColumnDefinition(
          name: 'sortOrder',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'room_fk_0',
          columns: ['clinicId'],
          referenceTable: 'clinic',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
        _isp.ForeignKeyDefinition(
          constraintName: 'room_fk_1',
          columns: ['lineId'],
          referenceTable: 'line',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'service_day',
      dartName: 'ServiceDay',
      schema: 'public',
      module: 'docket',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'clinicId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'serviceDate',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'state',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:DayState',
        ),
        _isp.ColumnDefinition(
          name: 'openedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'closedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'service_day_fk_0',
          columns: ['clinicId'],
          referenceTable: 'clinic',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'service_day_clinic_date_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'clinicId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'serviceDate',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'service_sample',
      dartName: 'ServiceSample',
      schema: 'public',
      module: 'docket',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'lineId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'roomId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'serviceSeconds',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'callToStartSeconds',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'at',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'service_sample_line_at_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'lineId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'at',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'smoke_run',
      dartName: 'SmokeRun',
      schema: 'public',
      module: 'docket',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'label',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'scheduledFor',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'firedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'serverId',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'sms_target',
      dartName: 'SmsTarget',
      schema: 'public',
      module: 'docket',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'ticketId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'phoneCipher',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'phoneLast4',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'consentAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'linkCipher',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'active',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'true',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'sms_target_ticket_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'ticketId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'staff_invite',
      dartName: 'StaffInvite',
      schema: 'public',
      module: 'docket',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'clinicId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'codeHash',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'role',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:StaffRole',
        ),
        _isp.ColumnDefinition(
          name: 'expiresAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'acceptedBy',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'acceptedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'staff_invite_code_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'codeHash',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'staff_member',
      dartName: 'StaffMember',
      schema: 'public',
      module: 'docket',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'clinicId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'userIdentifier',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'displayName',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'role',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:StaffRole',
        ),
        _isp.ColumnDefinition(
          name: 'active',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'true',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'staff_member_fk_0',
          columns: ['clinicId'],
          referenceTable: 'clinic',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'staff_clinic_user_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'clinicId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'userIdentifier',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'ticket',
      dartName: 'Ticket',
      schema: 'public',
      module: 'docket',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'clinicId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'lineId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'serviceDate',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'number',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'label',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'tokenHash',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'displayName',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'state',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:TicketState',
        ),
        _isp.ColumnDefinition(
          name: 'priorityRank',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '1',
        ),
        _isp.ColumnDefinition(
          name: 'priorityReason',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'protocol:PriorityReason?',
        ),
        _isp.ColumnDefinition(
          name: 'priorityNote',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'sortKey',
          columnType: _isp.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _isp.ColumnDefinition(
          name: 'reslotCount',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _isp.ColumnDefinition(
          name: 'callVersion',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _isp.ColumnDefinition(
          name: 'roomId',
          columnType: _isp.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _isp.ColumnDefinition(
          name: 'joinedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'calledAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'confirmedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'serviceStartedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'finishedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'headsUpSentAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'transferredFromTicketId',
          columnType: _isp.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _isp.ColumnDefinition(
          name: 'transferredToTicketId',
          columnType: _isp.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _isp.ColumnDefinition(
          name: 'closedReason',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'transferTokenCipher',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'isDemo',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'ticket_fk_0',
          columns: ['clinicId'],
          referenceTable: 'clinic',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
        _isp.ForeignKeyDefinition(
          constraintName: 'ticket_fk_1',
          columns: ['lineId'],
          referenceTable: 'line',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'ticket_line_queue_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'lineId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'state',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'priorityRank',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'sortKey',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'ticket_line_day_number_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'lineId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'serviceDate',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'number',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'ticket_token_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'tokenHash',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'ticket_event',
      dartName: 'TicketEvent',
      schema: 'public',
      module: 'docket',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'clinicId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'lineId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'ticketId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'ticketLabel',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'type',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:TicketEventType',
        ),
        _isp.ColumnDefinition(
          name: 'fromState',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'protocol:TicketState?',
        ),
        _isp.ColumnDefinition(
          name: 'toState',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'protocol:TicketState?',
        ),
        _isp.ColumnDefinition(
          name: 'actor',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:ActorType',
        ),
        _isp.ColumnDefinition(
          name: 'actorRef',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'deviceId',
          columnType: _isp.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _isp.ColumnDefinition(
          name: 'actionId',
          columnType: _isp.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _isp.ColumnDefinition(
          name: 'roomId',
          columnType: _isp.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _isp.ColumnDefinition(
          name: 'reason',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'lineVersion',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'at',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'ticket_event_clinic_at_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'clinicId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'at',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'ticket_event_ticket_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'ticketId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    ..._iais.Protocol.targetTableDefinitions,
    ..._iacs.Protocol.targetTableDefinitions,
    ..._isp.Protocol.targetTableDefinitions,
  ];

  static String? getClassNameFromObjectJson(dynamic data) {
    if (data is! Map) return null;
    final className = data['__className__'] as String?;
    return className;
  }

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;

    final dataClassName = getClassNameFromObjectJson(data);
    if (dataClassName != null && dataClassName != getClassNameForType(t)) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on _is.DeserializationClassNameNotFoundException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _itsmgqrp.DeskMeta) {
      return _itsmgqrp.DeskMeta.fromJson(data) as T;
    }
    if (t == _ifnbbn5d.LocalTicket) {
      return _ifnbbn5d.LocalTicket.fromJson(data) as T;
    }
    if (t == _ipibroog.OutboxAction) {
      return _ipibroog.OutboxAction.fromJson(data) as T;
    }
    if (t == _id6z13wr.ActionOutcome) {
      return _id6z13wr.ActionOutcome.fromJson(data) as T;
    }
    if (t == _ip5zeyz4.ActorType) {
      return _ip5zeyz4.ActorType.fromJson(data) as T;
    }
    if (t == _ihe3eiri.Channel) {
      return _ihe3eiri.Channel.fromJson(data) as T;
    }
    if (t == _iiugpsnp.DayState) {
      return _iiugpsnp.DayState.fromJson(data) as T;
    }
    if (t == _iz7e19vi.DeliveryStatus) {
      return _iz7e19vi.DeliveryStatus.fromJson(data) as T;
    }
    if (t == _i9onbghe.DocketErrorCode) {
      return _i9onbghe.DocketErrorCode.fromJson(data) as T;
    }
    if (t == _icekk0hy.DocketException) {
      return _icekk0hy.DocketException.fromJson(data) as T;
    }
    if (t == _ivjbs79x.NotificationKind) {
      return _ivjbs79x.NotificationKind.fromJson(data) as T;
    }
    if (t == _i1vgsurr.PriorityReason) {
      return _i1vgsurr.PriorityReason.fromJson(data) as T;
    }
    if (t == _isbuatcx.RoomState) {
      return _isbuatcx.RoomState.fromJson(data) as T;
    }
    if (t == _ij8mfwy5.StaffRole) {
      return _ij8mfwy5.StaffRole.fromJson(data) as T;
    }
    if (t == _ivoofwb9.TicketEventType) {
      return _ivoofwb9.TicketEventType.fromJson(data) as T;
    }
    if (t == _ih6coe2p.TicketState) {
      return _ih6coe2p.TicketState.fromJson(data) as T;
    }
    if (t == _ilmgu8hh.ClinicJobsFutureCallAutoCloseDayModel) {
      return _ilmgu8hh.ClinicJobsFutureCallAutoCloseDayModel.fromJson(data)
          as T;
    }
    if (t == _i65bud0x.DispatchFutureCallSendModel) {
      return _i65bud0x.DispatchFutureCallSendModel.fromJson(data) as T;
    }
    if (t == _il52xcea.SmokeFutureCallFireModel) {
      return _il52xcea.SmokeFutureCallFireModel.fromJson(data) as T;
    }
    if (t == _it6gb6op.TicketTimersFutureCallArrivalExpiredModel) {
      return _it6gb6op.TicketTimersFutureCallArrivalExpiredModel.fromJson(data)
          as T;
    }
    if (t == _ikoguwcg.TicketTimersFutureCallGraceExpiredModel) {
      return _ikoguwcg.TicketTimersFutureCallGraceExpiredModel.fromJson(data)
          as T;
    }
    if (t == _iau54etg.TicketTimersFutureCallGraceReminderModel) {
      return _iau54etg.TicketTimersFutureCallGraceReminderModel.fromJson(data)
          as T;
    }
    if (t == _i1tv74l0.Clinic) {
      return _i1tv74l0.Clinic.fromJson(data) as T;
    }
    if (t == _i6l2o3m9.DayReport) {
      return _i6l2o3m9.DayReport.fromJson(data) as T;
    }
    if (t == _itbbh7rx.DeskActionReceipt) {
      return _itbbh7rx.DeskActionReceipt.fromJson(data) as T;
    }
    if (t == _ichzzdg7.DeskPresence) {
      return _ichzzdg7.DeskPresence.fromJson(data) as T;
    }
    if (t == _iuohjp42.Line) {
      return _iuohjp42.Line.fromJson(data) as T;
    }
    if (t == _izbep4h6.Notification) {
      return _izbep4h6.Notification.fromJson(data) as T;
    }
    if (t == _i0f5mftr.PushTarget) {
      return _i0f5mftr.PushTarget.fromJson(data) as T;
    }
    if (t == _i6umewsv.RateBucket) {
      return _i6umewsv.RateBucket.fromJson(data) as T;
    }
    if (t == _ie9hxdgh.Room) {
      return _ie9hxdgh.Room.fromJson(data) as T;
    }
    if (t == _iwu7p9fm.ServiceDay) {
      return _iwu7p9fm.ServiceDay.fromJson(data) as T;
    }
    if (t == _ik8e9gcd.ServiceSample) {
      return _ik8e9gcd.ServiceSample.fromJson(data) as T;
    }
    if (t == _i35vexo7.SmokeRun) {
      return _i35vexo7.SmokeRun.fromJson(data) as T;
    }
    if (t == _ibpxb7a0.SmsTarget) {
      return _ibpxb7a0.SmsTarget.fromJson(data) as T;
    }
    if (t == _iiv296lb.StaffInvite) {
      return _iiv296lb.StaffInvite.fromJson(data) as T;
    }
    if (t == _ioipfu19.StaffMember) {
      return _ioipfu19.StaffMember.fromJson(data) as T;
    }
    if (t == _ibp03sd9.Ticket) {
      return _ibp03sd9.Ticket.fromJson(data) as T;
    }
    if (t == _i2hyp4di.TicketEvent) {
      return _i2hyp4di.TicketEvent.fromJson(data) as T;
    }
    if (t == _imnqx1va.AddPriorityAction) {
      return _imnqx1va.AddPriorityAction.fromJson(data) as T;
    }
    if (t == _imnqx1va.AddWalkInAction) {
      return _imnqx1va.AddWalkInAction.fromJson(data) as T;
    }
    if (t == _insujfc6.BoardCall) {
      return _insujfc6.BoardCall.fromJson(data) as T;
    }
    if (t == _iu648fp6.BoardRoom) {
      return _iu648fp6.BoardRoom.fromJson(data) as T;
    }
    if (t == _i8bbdmi3.BoardView) {
      return _i8bbdmi3.BoardView.fromJson(data) as T;
    }
    if (t == _imnqx1va.CallNextAction) {
      return _imnqx1va.CallNextAction.fromJson(data) as T;
    }
    if (t == _imnqx1va.CallSpecificAction) {
      return _imnqx1va.CallSpecificAction.fromJson(data) as T;
    }
    if (t == _i55fq8ss.ClinicChanged) {
      return _i55fq8ss.ClinicChanged.fromJson(data) as T;
    }
    if (t == _imia8rlj.ClinicPublicInfo) {
      return _imia8rlj.ClinicPublicInfo.fromJson(data) as T;
    }
    if (t == _idokcveh.ClinicSettings) {
      return _idokcveh.ClinicSettings.fromJson(data) as T;
    }
    if (t == _idcgk93b.ClinicSetup) {
      return _idcgk93b.ClinicSetup.fromJson(data) as T;
    }
    if (t == _imnqx1va.CloseDayAction) {
      return _imnqx1va.CloseDayAction.fromJson(data) as T;
    }
    if (t == _ilvaaaqm.DayReportData) {
      return _ilvaaaqm.DayReportData.fromJson(data) as T;
    }
    if (t == _imnqx1va.FinishAction) {
      return _imnqx1va.FinishAction.fromJson(data) as T;
    }
    if (t == _imnqx1va.MarkNoShowAction) {
      return _imnqx1va.MarkNoShowAction.fromJson(data) as T;
    }
    if (t == _imnqx1va.RecallAction) {
      return _imnqx1va.RecallAction.fromJson(data) as T;
    }
    if (t == _imnqx1va.RemoveAction) {
      return _imnqx1va.RemoveAction.fromJson(data) as T;
    }
    if (t == _imnqx1va.SetRoomStateAction) {
      return _imnqx1va.SetRoomStateAction.fromJson(data) as T;
    }
    if (t == _imnqx1va.StartServiceAction) {
      return _imnqx1va.StartServiceAction.fromJson(data) as T;
    }
    if (t == _imnqx1va.TransferAction) {
      return _imnqx1va.TransferAction.fromJson(data) as T;
    }
    if (t == _ifdo9b42.DeskActionResult) {
      return _ifdo9b42.DeskActionResult.fromJson(data) as T;
    }
    if (t == _i6zaqvnc.DeskView) {
      return _i6zaqvnc.DeskView.fromJson(data) as T;
    }
    if (t == _iiyugm4n.JoinRequest) {
      return _iiyugm4n.JoinRequest.fromJson(data) as T;
    }
    if (t == _irl6or83.JoinResult) {
      return _irl6or83.JoinResult.fromJson(data) as T;
    }
    if (t == _iaav6pk8.LineChanged) {
      return _iaav6pk8.LineChanged.fromJson(data) as T;
    }
    if (t == _i8u9vtwn.LinePublicInfo) {
      return _i8u9vtwn.LinePublicInfo.fromJson(data) as T;
    }
    if (t == _ib23o5eu.LineReport) {
      return _ib23o5eu.LineReport.fromJson(data) as T;
    }
    if (t == _iz6z9tvl.LineSetup) {
      return _iz6z9tvl.LineSetup.fromJson(data) as T;
    }
    if (t == _ii0c3htl.LineView) {
      return _ii0c3htl.LineView.fromJson(data) as T;
    }
    if (t == _i02wmc63.Membership) {
      return _i02wmc63.Membership.fromJson(data) as T;
    }
    if (t == _i8afvum2.OwnerView) {
      return _i8afvum2.OwnerView.fromJson(data) as T;
    }
    if (t == _iv020hjy.PatientView) {
      return _iv020hjy.PatientView.fromJson(data) as T;
    }
    if (t == _irbn5ekl.PushSubscriptionInput) {
      return _irbn5ekl.PushSubscriptionInput.fromJson(data) as T;
    }
    if (t == _igi3ijtw.RoomSetup) {
      return _igi3ijtw.RoomSetup.fromJson(data) as T;
    }
    if (t == _irlx3wvg.RoomView) {
      return _irlx3wvg.RoomView.fromJson(data) as T;
    }
    if (t == _if96k0su.SandboxStart) {
      return _if96k0su.SandboxStart.fromJson(data) as T;
    }
    if (t == _i840or10.SmokeTick) {
      return _i840or10.SmokeTick.fromJson(data) as T;
    }
    if (t == _izd9tkxm.StaffInviteView) {
      return _izd9tkxm.StaffInviteView.fromJson(data) as T;
    }
    if (t == _i31pag7v.SyncBatch) {
      return _i31pag7v.SyncBatch.fromJson(data) as T;
    }
    if (t == _il8pbprb.SyncResult) {
      return _il8pbprb.SyncResult.fromJson(data) as T;
    }
    if (t == _i0kt8to1.TicketChanged) {
      return _i0kt8to1.TicketChanged.fromJson(data) as T;
    }
    if (t == _isastcde.TicketView) {
      return _isastcde.TicketView.fromJson(data) as T;
    }
    if (t == _is.getType<_itsmgqrp.DeskMeta?>()) {
      return (data != null ? _itsmgqrp.DeskMeta.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ifnbbn5d.LocalTicket?>()) {
      return (data != null ? _ifnbbn5d.LocalTicket.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ipibroog.OutboxAction?>()) {
      return (data != null ? _ipibroog.OutboxAction.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_id6z13wr.ActionOutcome?>()) {
      return (data != null ? _id6z13wr.ActionOutcome.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ip5zeyz4.ActorType?>()) {
      return (data != null ? _ip5zeyz4.ActorType.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ihe3eiri.Channel?>()) {
      return (data != null ? _ihe3eiri.Channel.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iiugpsnp.DayState?>()) {
      return (data != null ? _iiugpsnp.DayState.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iz7e19vi.DeliveryStatus?>()) {
      return (data != null ? _iz7e19vi.DeliveryStatus.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i9onbghe.DocketErrorCode?>()) {
      return (data != null ? _i9onbghe.DocketErrorCode.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_icekk0hy.DocketException?>()) {
      return (data != null ? _icekk0hy.DocketException.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ivjbs79x.NotificationKind?>()) {
      return (data != null ? _ivjbs79x.NotificationKind.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i1vgsurr.PriorityReason?>()) {
      return (data != null ? _i1vgsurr.PriorityReason.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_isbuatcx.RoomState?>()) {
      return (data != null ? _isbuatcx.RoomState.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ij8mfwy5.StaffRole?>()) {
      return (data != null ? _ij8mfwy5.StaffRole.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ivoofwb9.TicketEventType?>()) {
      return (data != null ? _ivoofwb9.TicketEventType.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ih6coe2p.TicketState?>()) {
      return (data != null ? _ih6coe2p.TicketState.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ilmgu8hh.ClinicJobsFutureCallAutoCloseDayModel?>()) {
      return (data != null
              ? _ilmgu8hh.ClinicJobsFutureCallAutoCloseDayModel.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_i65bud0x.DispatchFutureCallSendModel?>()) {
      return (data != null
              ? _i65bud0x.DispatchFutureCallSendModel.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_il52xcea.SmokeFutureCallFireModel?>()) {
      return (data != null
              ? _il52xcea.SmokeFutureCallFireModel.fromJson(data)
              : null)
          as T;
    }
    if (t ==
        _is.getType<_it6gb6op.TicketTimersFutureCallArrivalExpiredModel?>()) {
      return (data != null
              ? _it6gb6op.TicketTimersFutureCallArrivalExpiredModel.fromJson(
                  data,
                )
              : null)
          as T;
    }
    if (t ==
        _is.getType<_ikoguwcg.TicketTimersFutureCallGraceExpiredModel?>()) {
      return (data != null
              ? _ikoguwcg.TicketTimersFutureCallGraceExpiredModel.fromJson(data)
              : null)
          as T;
    }
    if (t ==
        _is.getType<_iau54etg.TicketTimersFutureCallGraceReminderModel?>()) {
      return (data != null
              ? _iau54etg.TicketTimersFutureCallGraceReminderModel.fromJson(
                  data,
                )
              : null)
          as T;
    }
    if (t == _is.getType<_i1tv74l0.Clinic?>()) {
      return (data != null ? _i1tv74l0.Clinic.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i6l2o3m9.DayReport?>()) {
      return (data != null ? _i6l2o3m9.DayReport.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_itbbh7rx.DeskActionReceipt?>()) {
      return (data != null ? _itbbh7rx.DeskActionReceipt.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ichzzdg7.DeskPresence?>()) {
      return (data != null ? _ichzzdg7.DeskPresence.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iuohjp42.Line?>()) {
      return (data != null ? _iuohjp42.Line.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_izbep4h6.Notification?>()) {
      return (data != null ? _izbep4h6.Notification.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i0f5mftr.PushTarget?>()) {
      return (data != null ? _i0f5mftr.PushTarget.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i6umewsv.RateBucket?>()) {
      return (data != null ? _i6umewsv.RateBucket.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ie9hxdgh.Room?>()) {
      return (data != null ? _ie9hxdgh.Room.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iwu7p9fm.ServiceDay?>()) {
      return (data != null ? _iwu7p9fm.ServiceDay.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ik8e9gcd.ServiceSample?>()) {
      return (data != null ? _ik8e9gcd.ServiceSample.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i35vexo7.SmokeRun?>()) {
      return (data != null ? _i35vexo7.SmokeRun.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ibpxb7a0.SmsTarget?>()) {
      return (data != null ? _ibpxb7a0.SmsTarget.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iiv296lb.StaffInvite?>()) {
      return (data != null ? _iiv296lb.StaffInvite.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ioipfu19.StaffMember?>()) {
      return (data != null ? _ioipfu19.StaffMember.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ibp03sd9.Ticket?>()) {
      return (data != null ? _ibp03sd9.Ticket.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i2hyp4di.TicketEvent?>()) {
      return (data != null ? _i2hyp4di.TicketEvent.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_imnqx1va.AddPriorityAction?>()) {
      return (data != null ? _imnqx1va.AddPriorityAction.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_imnqx1va.AddWalkInAction?>()) {
      return (data != null ? _imnqx1va.AddWalkInAction.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_insujfc6.BoardCall?>()) {
      return (data != null ? _insujfc6.BoardCall.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iu648fp6.BoardRoom?>()) {
      return (data != null ? _iu648fp6.BoardRoom.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i8bbdmi3.BoardView?>()) {
      return (data != null ? _i8bbdmi3.BoardView.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_imnqx1va.CallNextAction?>()) {
      return (data != null ? _imnqx1va.CallNextAction.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_imnqx1va.CallSpecificAction?>()) {
      return (data != null ? _imnqx1va.CallSpecificAction.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i55fq8ss.ClinicChanged?>()) {
      return (data != null ? _i55fq8ss.ClinicChanged.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_imia8rlj.ClinicPublicInfo?>()) {
      return (data != null ? _imia8rlj.ClinicPublicInfo.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_idokcveh.ClinicSettings?>()) {
      return (data != null ? _idokcveh.ClinicSettings.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_idcgk93b.ClinicSetup?>()) {
      return (data != null ? _idcgk93b.ClinicSetup.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_imnqx1va.CloseDayAction?>()) {
      return (data != null ? _imnqx1va.CloseDayAction.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ilvaaaqm.DayReportData?>()) {
      return (data != null ? _ilvaaaqm.DayReportData.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_imnqx1va.FinishAction?>()) {
      return (data != null ? _imnqx1va.FinishAction.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_imnqx1va.MarkNoShowAction?>()) {
      return (data != null ? _imnqx1va.MarkNoShowAction.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_imnqx1va.RecallAction?>()) {
      return (data != null ? _imnqx1va.RecallAction.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_imnqx1va.RemoveAction?>()) {
      return (data != null ? _imnqx1va.RemoveAction.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_imnqx1va.SetRoomStateAction?>()) {
      return (data != null ? _imnqx1va.SetRoomStateAction.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_imnqx1va.StartServiceAction?>()) {
      return (data != null ? _imnqx1va.StartServiceAction.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_imnqx1va.TransferAction?>()) {
      return (data != null ? _imnqx1va.TransferAction.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ifdo9b42.DeskActionResult?>()) {
      return (data != null ? _ifdo9b42.DeskActionResult.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i6zaqvnc.DeskView?>()) {
      return (data != null ? _i6zaqvnc.DeskView.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iiyugm4n.JoinRequest?>()) {
      return (data != null ? _iiyugm4n.JoinRequest.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_irl6or83.JoinResult?>()) {
      return (data != null ? _irl6or83.JoinResult.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iaav6pk8.LineChanged?>()) {
      return (data != null ? _iaav6pk8.LineChanged.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i8u9vtwn.LinePublicInfo?>()) {
      return (data != null ? _i8u9vtwn.LinePublicInfo.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ib23o5eu.LineReport?>()) {
      return (data != null ? _ib23o5eu.LineReport.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iz6z9tvl.LineSetup?>()) {
      return (data != null ? _iz6z9tvl.LineSetup.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ii0c3htl.LineView?>()) {
      return (data != null ? _ii0c3htl.LineView.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i02wmc63.Membership?>()) {
      return (data != null ? _i02wmc63.Membership.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i8afvum2.OwnerView?>()) {
      return (data != null ? _i8afvum2.OwnerView.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iv020hjy.PatientView?>()) {
      return (data != null ? _iv020hjy.PatientView.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_irbn5ekl.PushSubscriptionInput?>()) {
      return (data != null
              ? _irbn5ekl.PushSubscriptionInput.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_igi3ijtw.RoomSetup?>()) {
      return (data != null ? _igi3ijtw.RoomSetup.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_irlx3wvg.RoomView?>()) {
      return (data != null ? _irlx3wvg.RoomView.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_if96k0su.SandboxStart?>()) {
      return (data != null ? _if96k0su.SandboxStart.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i840or10.SmokeTick?>()) {
      return (data != null ? _i840or10.SmokeTick.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_izd9tkxm.StaffInviteView?>()) {
      return (data != null ? _izd9tkxm.StaffInviteView.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i31pag7v.SyncBatch?>()) {
      return (data != null ? _i31pag7v.SyncBatch.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_il8pbprb.SyncResult?>()) {
      return (data != null ? _il8pbprb.SyncResult.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i0kt8to1.TicketChanged?>()) {
      return (data != null ? _i0kt8to1.TicketChanged.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_isastcde.TicketView?>()) {
      return (data != null ? _isastcde.TicketView.fromJson(data) : null) as T;
    }
    if (t == List<_iu648fp6.BoardRoom>) {
      return (data as List)
              .map((e) => deserialize<_iu648fp6.BoardRoom>(e))
              .toList()
          as T;
    }
    if (t == List<_insujfc6.BoardCall>) {
      return (data as List)
              .map((e) => deserialize<_insujfc6.BoardCall>(e))
              .toList()
          as T;
    }
    if (t == Map<String, int>) {
      return (data as Map).map(
            (k, v) => MapEntry(deserialize<String>(k), deserialize<int>(v)),
          )
          as T;
    }
    if (t == List<_i8u9vtwn.LinePublicInfo>) {
      return (data as List)
              .map((e) => deserialize<_i8u9vtwn.LinePublicInfo>(e))
              .toList()
          as T;
    }
    if (t == List<_iz6z9tvl.LineSetup>) {
      return (data as List)
              .map((e) => deserialize<_iz6z9tvl.LineSetup>(e))
              .toList()
          as T;
    }
    if (t == List<_igi3ijtw.RoomSetup>) {
      return (data as List)
              .map((e) => deserialize<_igi3ijtw.RoomSetup>(e))
              .toList()
          as T;
    }
    if (t == List<_ib23o5eu.LineReport>) {
      return (data as List)
              .map((e) => deserialize<_ib23o5eu.LineReport>(e))
              .toList()
          as T;
    }
    if (t == List<_ii0c3htl.LineView>) {
      return (data as List)
              .map((e) => deserialize<_ii0c3htl.LineView>(e))
              .toList()
          as T;
    }
    if (t == List<_irlx3wvg.RoomView>) {
      return (data as List)
              .map((e) => deserialize<_irlx3wvg.RoomView>(e))
              .toList()
          as T;
    }
    if (t == List<int>) {
      return (data as List).map((e) => deserialize<int>(e)).toList() as T;
    }
    if (t == List<_isastcde.TicketView>) {
      return (data as List)
              .map((e) => deserialize<_isastcde.TicketView>(e))
              .toList()
          as T;
    }
    if (t == List<_iuohjp42.Line>) {
      return (data as List).map((e) => deserialize<_iuohjp42.Line>(e)).toList()
          as T;
    }
    if (t == List<_ie9hxdgh.Room>) {
      return (data as List).map((e) => deserialize<_ie9hxdgh.Room>(e)).toList()
          as T;
    }
    if (t == List<_imnqx1va.DeskAction>) {
      return (data as List)
              .map((e) => deserialize<_imnqx1va.DeskAction>(e))
              .toList()
          as T;
    }
    if (t == List<_ifdo9b42.DeskActionResult>) {
      return (data as List)
              .map((e) => deserialize<_ifdo9b42.DeskActionResult>(e))
              .toList()
          as T;
    }
    if (t == List<_in3dutg9.StaffMember>) {
      return (data as List)
              .map((e) => deserialize<_in3dutg9.StaffMember>(e))
              .toList()
          as T;
    }
    if (t == List<_i4alk30e.TicketEvent>) {
      return (data as List)
              .map((e) => deserialize<_i4alk30e.TicketEvent>(e))
              .toList()
          as T;
    }
    if (t == List<_i5kmsnma.Notification>) {
      return (data as List)
              .map((e) => deserialize<_i5kmsnma.Notification>(e))
              .toList()
          as T;
    }
    if (t == List<_ihlom2lm.SmokeRun>) {
      return (data as List)
              .map((e) => deserialize<_ihlom2lm.SmokeRun>(e))
              .toList()
          as T;
    }
    if (t == List<_iu90snls.Membership>) {
      return (data as List)
              .map((e) => deserialize<_iu90snls.Membership>(e))
              .toList()
          as T;
    }
    try {
      return _iais.Protocol().deserialize<T>(data, t);
    } on _is.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _iacs.Protocol().deserialize<T>(data, t);
    } on _is.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _isp.Protocol().deserialize<T>(data, t);
    } on _is.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _itsmgqrp.DeskMeta => 'DeskMeta',
      _ifnbbn5d.LocalTicket => 'LocalTicket',
      _ipibroog.OutboxAction => 'OutboxAction',
      _id6z13wr.ActionOutcome => 'ActionOutcome',
      _ip5zeyz4.ActorType => 'ActorType',
      _ihe3eiri.Channel => 'Channel',
      _iiugpsnp.DayState => 'DayState',
      _iz7e19vi.DeliveryStatus => 'DeliveryStatus',
      _i9onbghe.DocketErrorCode => 'DocketErrorCode',
      _icekk0hy.DocketException => 'DocketException',
      _ivjbs79x.NotificationKind => 'NotificationKind',
      _i1vgsurr.PriorityReason => 'PriorityReason',
      _isbuatcx.RoomState => 'RoomState',
      _ij8mfwy5.StaffRole => 'StaffRole',
      _ivoofwb9.TicketEventType => 'TicketEventType',
      _ih6coe2p.TicketState => 'TicketState',
      _ilmgu8hh.ClinicJobsFutureCallAutoCloseDayModel =>
        'ClinicJobsFutureCallAutoCloseDayModel',
      _i65bud0x.DispatchFutureCallSendModel => 'DispatchFutureCallSendModel',
      _il52xcea.SmokeFutureCallFireModel => 'SmokeFutureCallFireModel',
      _it6gb6op.TicketTimersFutureCallArrivalExpiredModel =>
        'TicketTimersFutureCallArrivalExpiredModel',
      _ikoguwcg.TicketTimersFutureCallGraceExpiredModel =>
        'TicketTimersFutureCallGraceExpiredModel',
      _iau54etg.TicketTimersFutureCallGraceReminderModel =>
        'TicketTimersFutureCallGraceReminderModel',
      _i1tv74l0.Clinic => 'Clinic',
      _i6l2o3m9.DayReport => 'DayReport',
      _itbbh7rx.DeskActionReceipt => 'DeskActionReceipt',
      _ichzzdg7.DeskPresence => 'DeskPresence',
      _iuohjp42.Line => 'Line',
      _izbep4h6.Notification => 'Notification',
      _i0f5mftr.PushTarget => 'PushTarget',
      _i6umewsv.RateBucket => 'RateBucket',
      _ie9hxdgh.Room => 'Room',
      _iwu7p9fm.ServiceDay => 'ServiceDay',
      _ik8e9gcd.ServiceSample => 'ServiceSample',
      _i35vexo7.SmokeRun => 'SmokeRun',
      _ibpxb7a0.SmsTarget => 'SmsTarget',
      _iiv296lb.StaffInvite => 'StaffInvite',
      _ioipfu19.StaffMember => 'StaffMember',
      _ibp03sd9.Ticket => 'Ticket',
      _i2hyp4di.TicketEvent => 'TicketEvent',
      _imnqx1va.AddPriorityAction => 'AddPriorityAction',
      _imnqx1va.AddWalkInAction => 'AddWalkInAction',
      _insujfc6.BoardCall => 'BoardCall',
      _iu648fp6.BoardRoom => 'BoardRoom',
      _i8bbdmi3.BoardView => 'BoardView',
      _imnqx1va.CallNextAction => 'CallNextAction',
      _imnqx1va.CallSpecificAction => 'CallSpecificAction',
      _i55fq8ss.ClinicChanged => 'ClinicChanged',
      _imia8rlj.ClinicPublicInfo => 'ClinicPublicInfo',
      _idokcveh.ClinicSettings => 'ClinicSettings',
      _idcgk93b.ClinicSetup => 'ClinicSetup',
      _imnqx1va.CloseDayAction => 'CloseDayAction',
      _ilvaaaqm.DayReportData => 'DayReportData',
      _imnqx1va.FinishAction => 'FinishAction',
      _imnqx1va.MarkNoShowAction => 'MarkNoShowAction',
      _imnqx1va.RecallAction => 'RecallAction',
      _imnqx1va.RemoveAction => 'RemoveAction',
      _imnqx1va.SetRoomStateAction => 'SetRoomStateAction',
      _imnqx1va.StartServiceAction => 'StartServiceAction',
      _imnqx1va.TransferAction => 'TransferAction',
      _ifdo9b42.DeskActionResult => 'DeskActionResult',
      _i6zaqvnc.DeskView => 'DeskView',
      _iiyugm4n.JoinRequest => 'JoinRequest',
      _irl6or83.JoinResult => 'JoinResult',
      _iaav6pk8.LineChanged => 'LineChanged',
      _i8u9vtwn.LinePublicInfo => 'LinePublicInfo',
      _ib23o5eu.LineReport => 'LineReport',
      _iz6z9tvl.LineSetup => 'LineSetup',
      _ii0c3htl.LineView => 'LineView',
      _i02wmc63.Membership => 'Membership',
      _i8afvum2.OwnerView => 'OwnerView',
      _iv020hjy.PatientView => 'PatientView',
      _irbn5ekl.PushSubscriptionInput => 'PushSubscriptionInput',
      _igi3ijtw.RoomSetup => 'RoomSetup',
      _irlx3wvg.RoomView => 'RoomView',
      _if96k0su.SandboxStart => 'SandboxStart',
      _i840or10.SmokeTick => 'SmokeTick',
      _izd9tkxm.StaffInviteView => 'StaffInviteView',
      _i31pag7v.SyncBatch => 'SyncBatch',
      _il8pbprb.SyncResult => 'SyncResult',
      _i0kt8to1.TicketChanged => 'TicketChanged',
      _isastcde.TicketView => 'TicketView',
      _ => null,
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst('docket.', '');
    }

    switch (data) {
      case _itsmgqrp.DeskMeta():
        return 'DeskMeta';
      case _ifnbbn5d.LocalTicket():
        return 'LocalTicket';
      case _ipibroog.OutboxAction():
        return 'OutboxAction';
      case _id6z13wr.ActionOutcome():
        return 'ActionOutcome';
      case _ip5zeyz4.ActorType():
        return 'ActorType';
      case _ihe3eiri.Channel():
        return 'Channel';
      case _iiugpsnp.DayState():
        return 'DayState';
      case _iz7e19vi.DeliveryStatus():
        return 'DeliveryStatus';
      case _i9onbghe.DocketErrorCode():
        return 'DocketErrorCode';
      case _icekk0hy.DocketException():
        return 'DocketException';
      case _ivjbs79x.NotificationKind():
        return 'NotificationKind';
      case _i1vgsurr.PriorityReason():
        return 'PriorityReason';
      case _isbuatcx.RoomState():
        return 'RoomState';
      case _ij8mfwy5.StaffRole():
        return 'StaffRole';
      case _ivoofwb9.TicketEventType():
        return 'TicketEventType';
      case _ih6coe2p.TicketState():
        return 'TicketState';
      case _ilmgu8hh.ClinicJobsFutureCallAutoCloseDayModel():
        return 'ClinicJobsFutureCallAutoCloseDayModel';
      case _i65bud0x.DispatchFutureCallSendModel():
        return 'DispatchFutureCallSendModel';
      case _il52xcea.SmokeFutureCallFireModel():
        return 'SmokeFutureCallFireModel';
      case _it6gb6op.TicketTimersFutureCallArrivalExpiredModel():
        return 'TicketTimersFutureCallArrivalExpiredModel';
      case _ikoguwcg.TicketTimersFutureCallGraceExpiredModel():
        return 'TicketTimersFutureCallGraceExpiredModel';
      case _iau54etg.TicketTimersFutureCallGraceReminderModel():
        return 'TicketTimersFutureCallGraceReminderModel';
      case _i1tv74l0.Clinic():
        return 'Clinic';
      case _i6l2o3m9.DayReport():
        return 'DayReport';
      case _itbbh7rx.DeskActionReceipt():
        return 'DeskActionReceipt';
      case _ichzzdg7.DeskPresence():
        return 'DeskPresence';
      case _iuohjp42.Line():
        return 'Line';
      case _izbep4h6.Notification():
        return 'Notification';
      case _i0f5mftr.PushTarget():
        return 'PushTarget';
      case _i6umewsv.RateBucket():
        return 'RateBucket';
      case _ie9hxdgh.Room():
        return 'Room';
      case _iwu7p9fm.ServiceDay():
        return 'ServiceDay';
      case _ik8e9gcd.ServiceSample():
        return 'ServiceSample';
      case _i35vexo7.SmokeRun():
        return 'SmokeRun';
      case _ibpxb7a0.SmsTarget():
        return 'SmsTarget';
      case _iiv296lb.StaffInvite():
        return 'StaffInvite';
      case _ioipfu19.StaffMember():
        return 'StaffMember';
      case _ibp03sd9.Ticket():
        return 'Ticket';
      case _i2hyp4di.TicketEvent():
        return 'TicketEvent';
      case _imnqx1va.AddPriorityAction():
        return 'AddPriorityAction';
      case _imnqx1va.AddWalkInAction():
        return 'AddWalkInAction';
      case _insujfc6.BoardCall():
        return 'BoardCall';
      case _iu648fp6.BoardRoom():
        return 'BoardRoom';
      case _i8bbdmi3.BoardView():
        return 'BoardView';
      case _imnqx1va.CallNextAction():
        return 'CallNextAction';
      case _imnqx1va.CallSpecificAction():
        return 'CallSpecificAction';
      case _i55fq8ss.ClinicChanged():
        return 'ClinicChanged';
      case _imia8rlj.ClinicPublicInfo():
        return 'ClinicPublicInfo';
      case _idokcveh.ClinicSettings():
        return 'ClinicSettings';
      case _idcgk93b.ClinicSetup():
        return 'ClinicSetup';
      case _imnqx1va.CloseDayAction():
        return 'CloseDayAction';
      case _ilvaaaqm.DayReportData():
        return 'DayReportData';
      case _imnqx1va.FinishAction():
        return 'FinishAction';
      case _imnqx1va.MarkNoShowAction():
        return 'MarkNoShowAction';
      case _imnqx1va.RecallAction():
        return 'RecallAction';
      case _imnqx1va.RemoveAction():
        return 'RemoveAction';
      case _imnqx1va.SetRoomStateAction():
        return 'SetRoomStateAction';
      case _imnqx1va.StartServiceAction():
        return 'StartServiceAction';
      case _imnqx1va.TransferAction():
        return 'TransferAction';
      case _ifdo9b42.DeskActionResult():
        return 'DeskActionResult';
      case _i6zaqvnc.DeskView():
        return 'DeskView';
      case _iiyugm4n.JoinRequest():
        return 'JoinRequest';
      case _irl6or83.JoinResult():
        return 'JoinResult';
      case _iaav6pk8.LineChanged():
        return 'LineChanged';
      case _i8u9vtwn.LinePublicInfo():
        return 'LinePublicInfo';
      case _ib23o5eu.LineReport():
        return 'LineReport';
      case _iz6z9tvl.LineSetup():
        return 'LineSetup';
      case _ii0c3htl.LineView():
        return 'LineView';
      case _i02wmc63.Membership():
        return 'Membership';
      case _i8afvum2.OwnerView():
        return 'OwnerView';
      case _iv020hjy.PatientView():
        return 'PatientView';
      case _irbn5ekl.PushSubscriptionInput():
        return 'PushSubscriptionInput';
      case _igi3ijtw.RoomSetup():
        return 'RoomSetup';
      case _irlx3wvg.RoomView():
        return 'RoomView';
      case _if96k0su.SandboxStart():
        return 'SandboxStart';
      case _i840or10.SmokeTick():
        return 'SmokeTick';
      case _izd9tkxm.StaffInviteView():
        return 'StaffInviteView';
      case _i31pag7v.SyncBatch():
        return 'SyncBatch';
      case _il8pbprb.SyncResult():
        return 'SyncResult';
      case _i0kt8to1.TicketChanged():
        return 'TicketChanged';
      case _isastcde.TicketView():
        return 'TicketView';
    }
    className = _iais.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_idp.$className';
    }
    className = _iacs.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_core.$className';
    }
    className = _isp.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.') ? className : 'serverpod.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'DeskMeta') {
      return deserialize<_itsmgqrp.DeskMeta>(data['data']);
    }
    if (dataClassName == 'LocalTicket') {
      return deserialize<_ifnbbn5d.LocalTicket>(data['data']);
    }
    if (dataClassName == 'OutboxAction') {
      return deserialize<_ipibroog.OutboxAction>(data['data']);
    }
    if (dataClassName == 'ActionOutcome') {
      return deserialize<_id6z13wr.ActionOutcome>(data['data']);
    }
    if (dataClassName == 'ActorType') {
      return deserialize<_ip5zeyz4.ActorType>(data['data']);
    }
    if (dataClassName == 'Channel') {
      return deserialize<_ihe3eiri.Channel>(data['data']);
    }
    if (dataClassName == 'DayState') {
      return deserialize<_iiugpsnp.DayState>(data['data']);
    }
    if (dataClassName == 'DeliveryStatus') {
      return deserialize<_iz7e19vi.DeliveryStatus>(data['data']);
    }
    if (dataClassName == 'DocketErrorCode') {
      return deserialize<_i9onbghe.DocketErrorCode>(data['data']);
    }
    if (dataClassName == 'DocketException') {
      return deserialize<_icekk0hy.DocketException>(data['data']);
    }
    if (dataClassName == 'NotificationKind') {
      return deserialize<_ivjbs79x.NotificationKind>(data['data']);
    }
    if (dataClassName == 'PriorityReason') {
      return deserialize<_i1vgsurr.PriorityReason>(data['data']);
    }
    if (dataClassName == 'RoomState') {
      return deserialize<_isbuatcx.RoomState>(data['data']);
    }
    if (dataClassName == 'StaffRole') {
      return deserialize<_ij8mfwy5.StaffRole>(data['data']);
    }
    if (dataClassName == 'TicketEventType') {
      return deserialize<_ivoofwb9.TicketEventType>(data['data']);
    }
    if (dataClassName == 'TicketState') {
      return deserialize<_ih6coe2p.TicketState>(data['data']);
    }
    if (dataClassName == 'ClinicJobsFutureCallAutoCloseDayModel') {
      return deserialize<_ilmgu8hh.ClinicJobsFutureCallAutoCloseDayModel>(
        data['data'],
      );
    }
    if (dataClassName == 'DispatchFutureCallSendModel') {
      return deserialize<_i65bud0x.DispatchFutureCallSendModel>(data['data']);
    }
    if (dataClassName == 'SmokeFutureCallFireModel') {
      return deserialize<_il52xcea.SmokeFutureCallFireModel>(data['data']);
    }
    if (dataClassName == 'TicketTimersFutureCallArrivalExpiredModel') {
      return deserialize<_it6gb6op.TicketTimersFutureCallArrivalExpiredModel>(
        data['data'],
      );
    }
    if (dataClassName == 'TicketTimersFutureCallGraceExpiredModel') {
      return deserialize<_ikoguwcg.TicketTimersFutureCallGraceExpiredModel>(
        data['data'],
      );
    }
    if (dataClassName == 'TicketTimersFutureCallGraceReminderModel') {
      return deserialize<_iau54etg.TicketTimersFutureCallGraceReminderModel>(
        data['data'],
      );
    }
    if (dataClassName == 'Clinic') {
      return deserialize<_i1tv74l0.Clinic>(data['data']);
    }
    if (dataClassName == 'DayReport') {
      return deserialize<_i6l2o3m9.DayReport>(data['data']);
    }
    if (dataClassName == 'DeskActionReceipt') {
      return deserialize<_itbbh7rx.DeskActionReceipt>(data['data']);
    }
    if (dataClassName == 'DeskPresence') {
      return deserialize<_ichzzdg7.DeskPresence>(data['data']);
    }
    if (dataClassName == 'Line') {
      return deserialize<_iuohjp42.Line>(data['data']);
    }
    if (dataClassName == 'Notification') {
      return deserialize<_izbep4h6.Notification>(data['data']);
    }
    if (dataClassName == 'PushTarget') {
      return deserialize<_i0f5mftr.PushTarget>(data['data']);
    }
    if (dataClassName == 'RateBucket') {
      return deserialize<_i6umewsv.RateBucket>(data['data']);
    }
    if (dataClassName == 'Room') {
      return deserialize<_ie9hxdgh.Room>(data['data']);
    }
    if (dataClassName == 'ServiceDay') {
      return deserialize<_iwu7p9fm.ServiceDay>(data['data']);
    }
    if (dataClassName == 'ServiceSample') {
      return deserialize<_ik8e9gcd.ServiceSample>(data['data']);
    }
    if (dataClassName == 'SmokeRun') {
      return deserialize<_i35vexo7.SmokeRun>(data['data']);
    }
    if (dataClassName == 'SmsTarget') {
      return deserialize<_ibpxb7a0.SmsTarget>(data['data']);
    }
    if (dataClassName == 'StaffInvite') {
      return deserialize<_iiv296lb.StaffInvite>(data['data']);
    }
    if (dataClassName == 'StaffMember') {
      return deserialize<_ioipfu19.StaffMember>(data['data']);
    }
    if (dataClassName == 'Ticket') {
      return deserialize<_ibp03sd9.Ticket>(data['data']);
    }
    if (dataClassName == 'TicketEvent') {
      return deserialize<_i2hyp4di.TicketEvent>(data['data']);
    }
    if (dataClassName == 'AddPriorityAction') {
      return deserialize<_imnqx1va.AddPriorityAction>(data['data']);
    }
    if (dataClassName == 'AddWalkInAction') {
      return deserialize<_imnqx1va.AddWalkInAction>(data['data']);
    }
    if (dataClassName == 'BoardCall') {
      return deserialize<_insujfc6.BoardCall>(data['data']);
    }
    if (dataClassName == 'BoardRoom') {
      return deserialize<_iu648fp6.BoardRoom>(data['data']);
    }
    if (dataClassName == 'BoardView') {
      return deserialize<_i8bbdmi3.BoardView>(data['data']);
    }
    if (dataClassName == 'CallNextAction') {
      return deserialize<_imnqx1va.CallNextAction>(data['data']);
    }
    if (dataClassName == 'CallSpecificAction') {
      return deserialize<_imnqx1va.CallSpecificAction>(data['data']);
    }
    if (dataClassName == 'ClinicChanged') {
      return deserialize<_i55fq8ss.ClinicChanged>(data['data']);
    }
    if (dataClassName == 'ClinicPublicInfo') {
      return deserialize<_imia8rlj.ClinicPublicInfo>(data['data']);
    }
    if (dataClassName == 'ClinicSettings') {
      return deserialize<_idokcveh.ClinicSettings>(data['data']);
    }
    if (dataClassName == 'ClinicSetup') {
      return deserialize<_idcgk93b.ClinicSetup>(data['data']);
    }
    if (dataClassName == 'CloseDayAction') {
      return deserialize<_imnqx1va.CloseDayAction>(data['data']);
    }
    if (dataClassName == 'DayReportData') {
      return deserialize<_ilvaaaqm.DayReportData>(data['data']);
    }
    if (dataClassName == 'FinishAction') {
      return deserialize<_imnqx1va.FinishAction>(data['data']);
    }
    if (dataClassName == 'MarkNoShowAction') {
      return deserialize<_imnqx1va.MarkNoShowAction>(data['data']);
    }
    if (dataClassName == 'RecallAction') {
      return deserialize<_imnqx1va.RecallAction>(data['data']);
    }
    if (dataClassName == 'RemoveAction') {
      return deserialize<_imnqx1va.RemoveAction>(data['data']);
    }
    if (dataClassName == 'SetRoomStateAction') {
      return deserialize<_imnqx1va.SetRoomStateAction>(data['data']);
    }
    if (dataClassName == 'StartServiceAction') {
      return deserialize<_imnqx1va.StartServiceAction>(data['data']);
    }
    if (dataClassName == 'TransferAction') {
      return deserialize<_imnqx1va.TransferAction>(data['data']);
    }
    if (dataClassName == 'DeskActionResult') {
      return deserialize<_ifdo9b42.DeskActionResult>(data['data']);
    }
    if (dataClassName == 'DeskView') {
      return deserialize<_i6zaqvnc.DeskView>(data['data']);
    }
    if (dataClassName == 'JoinRequest') {
      return deserialize<_iiyugm4n.JoinRequest>(data['data']);
    }
    if (dataClassName == 'JoinResult') {
      return deserialize<_irl6or83.JoinResult>(data['data']);
    }
    if (dataClassName == 'LineChanged') {
      return deserialize<_iaav6pk8.LineChanged>(data['data']);
    }
    if (dataClassName == 'LinePublicInfo') {
      return deserialize<_i8u9vtwn.LinePublicInfo>(data['data']);
    }
    if (dataClassName == 'LineReport') {
      return deserialize<_ib23o5eu.LineReport>(data['data']);
    }
    if (dataClassName == 'LineSetup') {
      return deserialize<_iz6z9tvl.LineSetup>(data['data']);
    }
    if (dataClassName == 'LineView') {
      return deserialize<_ii0c3htl.LineView>(data['data']);
    }
    if (dataClassName == 'Membership') {
      return deserialize<_i02wmc63.Membership>(data['data']);
    }
    if (dataClassName == 'OwnerView') {
      return deserialize<_i8afvum2.OwnerView>(data['data']);
    }
    if (dataClassName == 'PatientView') {
      return deserialize<_iv020hjy.PatientView>(data['data']);
    }
    if (dataClassName == 'PushSubscriptionInput') {
      return deserialize<_irbn5ekl.PushSubscriptionInput>(data['data']);
    }
    if (dataClassName == 'RoomSetup') {
      return deserialize<_igi3ijtw.RoomSetup>(data['data']);
    }
    if (dataClassName == 'RoomView') {
      return deserialize<_irlx3wvg.RoomView>(data['data']);
    }
    if (dataClassName == 'SandboxStart') {
      return deserialize<_if96k0su.SandboxStart>(data['data']);
    }
    if (dataClassName == 'SmokeTick') {
      return deserialize<_i840or10.SmokeTick>(data['data']);
    }
    if (dataClassName == 'StaffInviteView') {
      return deserialize<_izd9tkxm.StaffInviteView>(data['data']);
    }
    if (dataClassName == 'SyncBatch') {
      return deserialize<_i31pag7v.SyncBatch>(data['data']);
    }
    if (dataClassName == 'SyncResult') {
      return deserialize<_il8pbprb.SyncResult>(data['data']);
    }
    if (dataClassName == 'TicketChanged') {
      return deserialize<_i0kt8to1.TicketChanged>(data['data']);
    }
    if (dataClassName == 'TicketView') {
      return deserialize<_isastcde.TicketView>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _iais.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _iacs.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod.')) {
      data['className'] = dataClassName.substring(10);
      return _isp.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  void _registerHostProtocols() {
    _iais.Protocol().registerHostProtocol('docket', this);
    _iacs.Protocol().registerHostProtocol('docket', this);
  }

  @override
  _is.Table? getTableForType(Type t) {
    {
      var table = _iais.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _iacs.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _isp.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    switch (t) {
      case _i1tv74l0.Clinic:
        return _i1tv74l0.Clinic.t;
      case _i6l2o3m9.DayReport:
        return _i6l2o3m9.DayReport.t;
      case _itbbh7rx.DeskActionReceipt:
        return _itbbh7rx.DeskActionReceipt.t;
      case _ichzzdg7.DeskPresence:
        return _ichzzdg7.DeskPresence.t;
      case _iuohjp42.Line:
        return _iuohjp42.Line.t;
      case _izbep4h6.Notification:
        return _izbep4h6.Notification.t;
      case _i0f5mftr.PushTarget:
        return _i0f5mftr.PushTarget.t;
      case _i6umewsv.RateBucket:
        return _i6umewsv.RateBucket.t;
      case _ie9hxdgh.Room:
        return _ie9hxdgh.Room.t;
      case _iwu7p9fm.ServiceDay:
        return _iwu7p9fm.ServiceDay.t;
      case _ik8e9gcd.ServiceSample:
        return _ik8e9gcd.ServiceSample.t;
      case _i35vexo7.SmokeRun:
        return _i35vexo7.SmokeRun.t;
      case _ibpxb7a0.SmsTarget:
        return _ibpxb7a0.SmsTarget.t;
      case _iiv296lb.StaffInvite:
        return _iiv296lb.StaffInvite.t;
      case _ioipfu19.StaffMember:
        return _ioipfu19.StaffMember.t;
      case _ibp03sd9.Ticket:
        return _ibp03sd9.Ticket.t;
      case _i2hyp4di.TicketEvent:
        return _i2hyp4di.TicketEvent.t;
    }
    return null;
  }

  @override
  List<_isp.TableDefinition> getTargetTableDefinitions() =>
      targetTableDefinitions;

  @override
  String getModuleName() => 'docket';

  /// Maps any `Record`s known to this [Protocol] to their JSON representation
  ///
  /// Throws in case the record type is not known.
  ///
  /// This method will return `null` (only) for `null` inputs.
  Map<String, dynamic>? mapRecordToJson(Record? record) {
    if (record == null) {
      return null;
    }
    try {
      return _iais.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _iacs.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
