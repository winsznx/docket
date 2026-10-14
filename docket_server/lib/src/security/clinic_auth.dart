import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

import '../domain/actor.dart';
import '../domain/views.dart';
import '../generated/protocol.dart';
import '../strings.dart';
import 'tokens.dart';

/// Clinic roles are checked in code against StaffMember, never with global
/// scopes, because one person can own one clinic and staff another (PRD 3).
abstract final class ClinicAuth {
  /// A signed-in active desk or owner of the clinic, or a valid sandbox token
  /// for a sandbox clinic (PRD 9.3).
  static Future<({Clinic clinic, Actor actor})> desk(
    Session session,
    UuidValue clinicId,
    String? sandboxToken,
  ) =>
      _require(session, clinicId, sandboxToken, ownerOnly: false, cached: true);

  /// A signed-in owner of the clinic, or a sandbox token (PRD 9.5).
  static Future<({Clinic clinic, Actor actor})> owner(
    Session session,
    UuidValue clinicId,
    String? sandboxToken,
  ) => _require(session, clinicId, sandboxToken, ownerOnly: true);

  static Future<({Clinic clinic, Actor actor})> _require(
    Session session,
    UuidValue clinicId,
    String? sandboxToken, {
    required bool ownerOnly,
    bool cached = false,
  }) async {
    // The desk path reads the clinic through a 5-second cache that owner
    // changes invalidate. The owner path always reads it fresh, since it
    // writes the row back.
    final clinic = cached
        ? await Views.clinicOrNull(session, clinicId)
        : await Clinic.db.findById(session, clinicId);
    if (clinic == null) {
      throw DocketException(
        code: DocketErrorCode.clinicNotFound,
        message: Copy.clinicNotFound,
      );
    }
    if (sandboxToken != null && sandboxToken.isNotEmpty) {
      final valid =
          clinic.isSandbox &&
          clinic.sandboxTokenHash != null &&
          clinic.sandboxTokenHash == Tokens.hash(sandboxToken);
      if (!valid) {
        throw DocketException(
          code: DocketErrorCode.notStaff,
          message: Copy.notStaff,
        );
      }
      if (clinic.sandboxExpiresAt != null &&
          DateTime.now().toUtc().isAfter(clinic.sandboxExpiresAt!)) {
        throw DocketException(
          code: DocketErrorCode.sandboxExpired,
          message: Copy.sandboxExpired,
        );
      }
      return (
        clinic: clinic,
        actor: const Actor(ActorType.sandbox, ref: 'sandbox'),
      );
    }
    final user = session.authenticated?.userIdentifier;
    if (user == null) {
      throw DocketException(
        code: DocketErrorCode.notStaff,
        message: Copy.notStaff,
      );
    }
    final member = await StaffMember.db.findFirstRow(
      session,
      where: (t) =>
          t.clinicId.equals(clinicId) &
          t.userIdentifier.equals(user) &
          t.active.equals(true),
    );
    if (member == null) {
      throw DocketException(
        code: DocketErrorCode.notStaff,
        message: Copy.notStaff,
      );
    }
    if (ownerOnly && member.role != StaffRole.owner) {
      throw DocketException(
        code: DocketErrorCode.notOwner,
        message: Copy.notOwner,
      );
    }
    return (
      clinic: clinic,
      actor: Actor(
        member.role == StaffRole.owner ? ActorType.owner : ActorType.desk,
        ref: member.id.toString(),
      ),
    );
  }

  static Future<String> displayNameFor(Session session) async {
    final info = session.authenticated;
    if (info == null) return 'Staff';
    final profile = await UserProfile.db.findFirstRow(
      session,
      where: (t) => t.authUserId.equals(info.authUserId),
    );
    return profile?.fullName ?? profile?.userName ?? profile?.email ?? 'Staff';
  }
}
