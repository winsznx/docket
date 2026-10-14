import 'dart:math';

import 'package:serverpod/serverpod.dart';

import '../app_config.dart';
import '../domain/actor.dart';
import '../domain/queue_service.dart';
import '../domain/views.dart';
import '../generated/protocol.dart';
import '../security/tokens.dart';
import '../strings.dart';

/// Throwaway clinics for judges and demos, purged after 24 hours
/// (PRD 9.7). Sandboxes never send SMS and hold at most 200 tickets.
class SandboxEndpoint extends Endpoint {
  static const lifetime = Duration(hours: 24);
  static final _random = Random.secure();

  Future<SandboxStart> start(Session session) async {
    const letters = 'ABCDEFGHJKLMNPQRSTUVWXYZ';
    final suffix = List.generate(
      4,
      (_) => letters[_random.nextInt(letters.length)],
    ).join();
    final sandboxToken = Tokens.mint();
    final boardToken = Tokens.mint();
    final expires = DateTime.now().toUtc().add(lifetime);
    final slug =
        'sandbox-${suffix.toLowerCase()}-${Tokens.mint(bytes: 3).toLowerCase().replaceAll(RegExp('[^a-z0-9]'), '')}';
    final clinic = await session.db.transaction((t) async {
      final clinic = await Clinic.db.insertRow(
        session,
        Clinic(
          name: 'Sandbox clinic',
          slug: slug,
          openTime: '00:00',
          joinCutoffTime: '23:59',
          closeTime: '23:59',
          autoCloseAfterMinutes: 0,
          isSandbox: true,
          sandboxExpiresAt: expires,
          boardTokenHash: Tokens.hash(boardToken),
          sandboxTokenHash: Tokens.hash(sandboxToken),
        ),
        transaction: t,
      );
      final consultation = await Line.db.insertRow(
        session,
        Line(
          clinicId: clinic.id!,
          name: 'Consultation',
          code: 'C',
          sortOrder: 0,
        ),
        transaction: t,
      );
      final lab = await Line.db.insertRow(
        session,
        Line(
          clinicId: clinic.id!,
          name: 'Lab',
          code: 'L',
          defaultServiceSeconds: 300,
          sortOrder: 1,
        ),
        transaction: t,
      );
      await Room.db.insert(session, [
        Room(
          clinicId: clinic.id!,
          lineId: consultation.id!,
          name: 'Room 1',
          sortOrder: 0,
        ),
        Room(
          clinicId: clinic.id!,
          lineId: consultation.id!,
          name: 'Room 2',
          sortOrder: 1,
        ),
        Room(
          clinicId: clinic.id!,
          lineId: lab.id!,
          name: 'Lab Bench',
          sortOrder: 2,
        ),
      ], transaction: t);
      return clinic;
    });
    await QueueService.openDay(session, clinic);
    session.log('[auth] sandbox ${clinic.slug} started');
    return SandboxStart(
      clinicId: clinic.id!,
      clinicSlug: clinic.slug,
      sandboxToken: sandboxToken,
      boardUrl: AppConfig.boardUrl(session.serverpod, boardToken),
      joinUrl: AppConfig.joinUrl(session.serverpod, clinic.slug),
      expiresAt: expires,
    );
  }

  /// Demo patients go through the same join path as real ones and carry
  /// `isDemo`, which every surface labels DEMO.
  Future<DeskView> addDemoWalkIns(
    Session session,
    String sandboxToken,
    UuidValue lineId,
    int count,
  ) async {
    if (count < 1 || count > 10) {
      throw DocketException(
        code: DocketErrorCode.validation,
        message: 'Add between 1 and 10 demo patients at a time.',
      );
    }
    final clinic = await Clinic.db.findFirstRow(
      session,
      where: (t) =>
          t.sandboxTokenHash.equals(Tokens.hash(sandboxToken)) &
          t.isSandbox.equals(true),
    );
    if (clinic == null) {
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
    final line = await Line.db.findById(session, lineId);
    if (line == null || line.clinicId != clinic.id) {
      throw DocketException(
        code: DocketErrorCode.validation,
        message: "That line isn't part of this sandbox.",
      );
    }
    final already = await Ticket.db.count(
      session,
      where: (t) => t.clinicId.equals(clinic.id!) & t.isDemo.equals(true),
    );
    for (var i = 1; i <= count; i++) {
      final fresh = (await Line.db.findById(session, lineId))!;
      await QueueService.join(
        session,
        clinic: clinic,
        line: fresh,
        displayName: 'Demo ${already + i}',
        isDemo: true,
        actor: const Actor(ActorType.sandbox, ref: 'demo'),
      );
    }
    return Views.desk(session, clinic.id!);
  }
}
