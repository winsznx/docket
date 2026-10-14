import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../security/clinic_auth.dart';
import '../security/tokens.dart';
import '../strings.dart';

/// Memberships for a signed-in person (PRD 9.6).
class StaffEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  Future<List<Membership>> myClinics(Session session) async {
    final user = session.authenticated!.userIdentifier;
    final members = await StaffMember.db.find(
      session,
      where: (t) => t.userIdentifier.equals(user) & t.active.equals(true),
    );
    final result = <Membership>[];
    for (final m in members) {
      final clinic = await Clinic.db.findById(session, m.clinicId);
      if (clinic == null) continue;
      result.add(
        Membership(clinicId: clinic.id!, clinicName: clinic.name, role: m.role),
      );
    }
    result.sort((a, b) => a.clinicName.compareTo(b.clinicName));
    return result;
  }

  Future<Membership> acceptInvite(Session session, String code) async {
    final user = session.authenticated!.userIdentifier;
    if (!RegExp(r'^[A-Za-z0-9_-]{16,64}$').hasMatch(code)) throw _invalid();
    final invite = await StaffInvite.db.findFirstRow(
      session,
      where: (t) => t.codeHash.equals(Tokens.hash(code)),
    );
    final now = DateTime.now().toUtc();
    if (invite == null ||
        invite.acceptedAt != null ||
        invite.expiresAt.isBefore(now)) {
      throw _invalid();
    }
    final clinic = await Clinic.db.findById(session, invite.clinicId);
    if (clinic == null) throw _invalid();
    final name = await ClinicAuth.displayNameFor(session);
    await session.db.transaction((t) async {
      await StaffInvite.db.updateRow(
        session,
        invite.copyWith(acceptedBy: user, acceptedAt: now),
        transaction: t,
      );
      final existing = await StaffMember.db.findFirstRow(
        session,
        where: (x) => x.clinicId.equals(clinic.id!) & x.userIdentifier.equals(user),
        transaction: t,
      );
      if (existing == null) {
        await StaffMember.db.insertRow(
          session,
          StaffMember(
            clinicId: clinic.id!,
            userIdentifier: user,
            displayName: name,
            role: invite.role,
          ),
          transaction: t,
        );
      } else {
        final role = existing.role == StaffRole.owner && existing.active
            ? StaffRole.owner
            : invite.role;
        await StaffMember.db.updateRow(
          session,
          existing.copyWith(active: true, role: role),
          transaction: t,
        );
      }
    });
    session.log('[auth] invite accepted for ${clinic.slug}');
    final member = await StaffMember.db.findFirstRow(
      session,
      where: (x) => x.clinicId.equals(clinic.id!) & x.userIdentifier.equals(user),
    );
    return Membership(
      clinicId: clinic.id!,
      clinicName: clinic.name,
      role: member!.role,
    );
  }

  static DocketException _invalid() => DocketException(
    code: DocketErrorCode.inviteInvalid,
    message: Copy.inviteInvalid,
  );
}
