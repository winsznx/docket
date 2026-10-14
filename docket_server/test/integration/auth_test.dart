import 'package:docket_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import 'helpers.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod(
    'Given a real clinic with an owner and a desk member',
    rollbackDatabase: RollbackDatabase.disabled,
    (builder, endpoints) {
      const ownerId = '01928a6e-0000-7000-8000-00000000aaaa';
      const deskId = '01928a6e-0000-7000-8000-00000000bbbb';
      const strangerId = '01928a6e-0000-7000-8000-00000000cccc';
      TestSessionBuilder as(String id) => builder.copyWith(
        authentication: AuthenticationOverride.authenticationInfo(id, {}),
      );
      late Clinic clinic;

      setUp(() async {
        clinic = await endpoints.owner.createClinic(
          as(ownerId),
          ClinicSetup(
            name: 'Grace Clinic',
            slug: 'grace-${DateTime.now().microsecondsSinceEpoch}',
            timezone: 'Africa/Lagos',
            lines: [LineSetup(name: 'Consultation', code: 'C', defaultServiceSeconds: 480)],
            rooms: [RoomSetup(name: 'Room 2', lineCode: 'C')],
          ),
        );
        final invite = await endpoints.owner.createInvite(
          as(ownerId),
          clinic.id!,
          StaffRole.desk,
          null,
        );
        final code = invite.inviteUrl.split('/').last;
        await endpoints.staff.acceptInvite(as(deskId), code);
      });

      Matcher refused(DocketErrorCode code) =>
          throwsA(isA<DocketException>().having((e) => e.code, 'code', code));

      test('when a stranger calls the desk then it is refused', () async {
        await expectLater(
          endpoints.desk.getView(as(strangerId), clinic.id!, null),
          refused(DocketErrorCode.notStaff),
        );
      });

      test('when a desk member calls owner methods then they are refused',
          () async {
        expect(
          await endpoints.desk.getView(as(deskId), clinic.id!, null),
          isA<DeskView>(),
        );
        await expectLater(
          endpoints.owner.listStaff(as(deskId), clinic.id!, null),
          refused(DocketErrorCode.notOwner),
        );
        await expectLater(
          endpoints.owner.rotateBoardToken(as(deskId), clinic.id!, null),
          refused(DocketErrorCode.notOwner),
        );
      });

      test('when a desk member is deactivated then the desk refuses them',
          () async {
        final staff = await endpoints.owner.listStaff(as(ownerId), clinic.id!, null);
        final member = staff.firstWhere((s) => s.userIdentifier == deskId);
        await endpoints.owner.deactivateStaff(
          as(ownerId),
          clinic.id!,
          member.id!,
          null,
        );
        await expectLater(
          endpoints.desk.getView(as(deskId), clinic.id!, null),
          refused(DocketErrorCode.notStaff),
        );
      });

      test('when the last owner is deactivated then it is refused', () async {
        final staff = await endpoints.owner.listStaff(as(ownerId), clinic.id!, null);
        final owner = staff.firstWhere((s) => s.userIdentifier == ownerId);
        await expectLater(
          endpoints.owner.deactivateStaff(as(ownerId), clinic.id!, owner.id!, null),
          refused(DocketErrorCode.validation),
        );
      });

      test('when a sandbox token is used on a real clinic then it is refused',
          () async {
        final f = await Fixture.create(builder, endpoints);
        await expectLater(
          endpoints.desk.getView(builder, clinic.id!, f.token),
          refused(DocketErrorCode.notStaff),
        );
        await expectLater(
          endpoints.owner.getOwnerView(builder, clinic.id!, f.token),
          refused(DocketErrorCode.notStaff),
        );
      });

      test('when an invite is reused then it is refused', () async {
        final invite = await endpoints.owner.createInvite(
          as(ownerId),
          clinic.id!,
          StaffRole.desk,
          null,
        );
        final code = invite.inviteUrl.split('/').last;
        await endpoints.staff.acceptInvite(as(strangerId), code);
        await expectLater(
          endpoints.staff.acceptInvite(as(strangerId), code),
          refused(DocketErrorCode.inviteInvalid),
        );
      });
    },
  );
}
