import 'package:serverpod/serverpod.dart';

import '../app_config.dart';
import '../domain/clinic_time.dart';
import '../domain/line_queue.dart';
import '../domain/reports.dart';
import '../generated/protocol.dart';
import '../security/clinic_auth.dart';
import '../security/tokens.dart';
import '../strings.dart';

/// The owner console. `requireLogin` stays false so sandbox tokens work,
/// and every method authorizes through [ClinicAuth.owner] (PRD 9.5).
class OwnerEndpoint extends Endpoint {
  static final _slug = RegExp(r'^[a-z0-9](?:[a-z0-9-]{1,38}[a-z0-9])$');
  static final _code = RegExp(r'^[A-Z]$');

  Future<Clinic> createClinic(Session session, ClinicSetup setup) async {
    final user = session.authenticated?.userIdentifier;
    if (user == null) {
      throw DocketException(
        code: DocketErrorCode.notStaff,
        message: 'Sign in to set up a clinic.',
      );
    }
    final name = setup.name.trim();
    final slug = setup.slug.trim().toLowerCase();
    _check(name.isNotEmpty && name.length <= 60, 'Give the clinic a name.');
    _check(
      _slug.hasMatch(slug) && !slug.startsWith('sandbox'),
      'Use 3 to 40 lowercase letters, numbers or hyphens for the link.',
    );
    _check(ClinicTime.isValidZone(setup.timezone), "That timezone isn't known.");
    _check(
      setup.lines.isNotEmpty && setup.lines.length <= 8,
      'Add between one and eight lines.',
    );
    final codes = setup.lines.map((l) => l.code.trim().toUpperCase()).toList();
    _check(
      codes.every(_code.hasMatch) && codes.toSet().length == codes.length,
      'Each line needs its own one-letter code.',
    );
    _check(setup.rooms.isNotEmpty, 'Add at least one room.');
    for (final room in setup.rooms) {
      _check(
        codes.contains(room.lineCode.trim().toUpperCase()) &&
            room.name.trim().isNotEmpty,
        'Every room needs a name and a line to call from.',
      );
    }
    for (final line in setup.lines) {
      _serviceSeconds(line.defaultServiceSeconds);
    }
    final taken = await Clinic.db.findFirstRow(
      session,
      where: (t) => t.slug.equals(slug),
    );
    _check(taken == null, 'That link is taken. Try another.');

    final displayName = await ClinicAuth.displayNameFor(session);
    final clinic = await session.db.transaction((t) async {
      final clinic = await Clinic.db.insertRow(
        session,
        Clinic(
          name: name,
          slug: slug,
          timezone: setup.timezone,
          boardTokenHash: Tokens.hash(Tokens.mint()),
        ),
        transaction: t,
      );
      final lineIds = <String, UuidValue>{};
      for (var i = 0; i < setup.lines.length; i++) {
        final l = setup.lines[i];
        final line = await Line.db.insertRow(
          session,
          Line(
            clinicId: clinic.id!,
            name: l.name.trim(),
            code: l.code.trim().toUpperCase(),
            defaultServiceSeconds: l.defaultServiceSeconds,
            sortOrder: i,
          ),
          transaction: t,
        );
        lineIds[line.code] = line.id!;
      }
      for (var i = 0; i < setup.rooms.length; i++) {
        final r = setup.rooms[i];
        await Room.db.insertRow(
          session,
          Room(
            clinicId: clinic.id!,
            lineId: lineIds[r.lineCode.trim().toUpperCase()]!,
            name: r.name.trim(),
            sortOrder: i,
          ),
          transaction: t,
        );
      }
      await StaffMember.db.insertRow(
        session,
        StaffMember(
          clinicId: clinic.id!,
          userIdentifier: user,
          displayName: displayName,
          role: StaffRole.owner,
        ),
        transaction: t,
      );
      return clinic;
    });
    session.log('[auth] clinic ${clinic.slug} created');
    return clinic;
  }

  Future<OwnerView> getOwnerView(
    Session session,
    UuidValue clinicId,
    String? sandboxToken,
  ) async {
    final auth = await ClinicAuth.owner(session, clinicId, sandboxToken);
    final clinic = auth.clinic;
    final date = LineQueue.serviceDateNow(clinic);
    final day = await ServiceDay.db.findFirstRow(
      session,
      where: (t) => t.clinicId.equals(clinicId) & t.serviceDate.equals(date),
    );
    return OwnerView(
      clinic: clinic,
      lines: await Line.db.find(
        session,
        where: (t) => t.clinicId.equals(clinicId),
        orderByList: (t) => [t.sortOrder.asc(), t.code.asc()],
      ),
      rooms: await Room.db.find(
        session,
        where: (t) => t.clinicId.equals(clinicId),
        orderByList: (t) => [t.sortOrder.asc(), t.name.asc()],
      ),
      serviceDate: date,
      day: day?.state,
      smsAvailable: AppConfig.twilioConfigured(session),
    );
  }

  Future<Clinic> updateSettings(
    Session session,
    UuidValue clinicId,
    ClinicSettings settings,
    String? sandboxToken,
  ) async {
    final auth = await ClinicAuth.owner(session, clinicId, sandboxToken);
    void range(int v, int min, int max, String what) => _check(
      v >= min && v <= max,
      '$what has to be between $min and $max.',
    );
    range(settings.graceSeconds, 60, 900, 'Time to confirm');
    range(settings.graceReminderSeconds, 15, 120, 'The reminder');
    range(settings.arrivalSeconds, 120, 1800, 'Time to reach the room');
    range(settings.headsUpPositions, 1, 5, 'Heads-up place');
    range(settings.headsUpMinutes, 3, 30, 'Heads-up minutes');
    range(settings.reslotOffset, 1, 10, 'Places back after a miss');
    range(settings.maxReslots, 0, 3, 'Misses allowed');
    range(settings.autoCloseAfterMinutes, 0, 600, 'Auto close');
    for (final t in [settings.openTime, settings.joinCutoffTime, settings.closeTime]) {
      _check(ClinicTime.isValidHhmm(t), 'Use 24-hour times like 08:00.');
    }
    _check(
      ClinicTime.minutesOf(settings.openTime) <
              ClinicTime.minutesOf(settings.joinCutoffTime) &&
          ClinicTime.minutesOf(settings.joinCutoffTime) <=
              ClinicTime.minutesOf(settings.closeTime),
      'Opening has to come before the last join, and that before closing.',
    );
    _check(ClinicTime.isValidZone(settings.timezone), "That timezone isn't known.");
    _check(
      !(settings.smsEnabled && auth.clinic.isSandbox),
      "Sandboxes don't send texts.",
    );
    final updated = await Clinic.db.updateRow(
      session,
      auth.clinic.copyWith(
        graceSeconds: settings.graceSeconds,
        graceReminderSeconds: settings.graceReminderSeconds,
        arrivalSeconds: settings.arrivalSeconds,
        headsUpPositions: settings.headsUpPositions,
        headsUpMinutes: settings.headsUpMinutes,
        reslotOffset: settings.reslotOffset,
        maxReslots: settings.maxReslots,
        openTime: settings.openTime,
        joinCutoffTime: settings.joinCutoffTime,
        closeTime: settings.closeTime,
        autoCloseAfterMinutes: settings.autoCloseAfterMinutes,
        timezone: settings.timezone,
        smsEnabled: settings.smsEnabled,
      ),
    );
    await _clinicChanged(session, clinicId);
    return updated;
  }

  Future<Line> upsertLine(
    Session session,
    UuidValue clinicId,
    Line line,
    String? sandboxToken,
  ) async {
    await ClinicAuth.owner(session, clinicId, sandboxToken);
    final code = line.code.trim().toUpperCase();
    _check(_code.hasMatch(code), 'The line code is one capital letter.');
    _check(
      line.name.trim().isNotEmpty && line.name.trim().length <= 40,
      'Give the line a name.',
    );
    _serviceSeconds(line.defaultServiceSeconds);
    final clash = await Line.db.findFirstRow(
      session,
      where: (t) => t.clinicId.equals(clinicId) & t.code.equals(code),
    );
    _check(
      clash == null || clash.id == line.id,
      'Another line already uses $code.',
    );
    final Line saved;
    if (line.id == null) {
      saved = await Line.db.insertRow(
        session,
        Line(
          clinicId: clinicId,
          name: line.name.trim(),
          code: code,
          defaultServiceSeconds: line.defaultServiceSeconds,
          acceptingJoins: line.acceptingJoins,
          sortOrder: line.sortOrder,
        ),
      );
    } else {
      final existing = await Line.db.findById(session, line.id!);
      _check(existing?.clinicId == clinicId, "That line isn't in this clinic.");
      saved = await Line.db.updateRow(
        session,
        existing!.copyWith(
          name: line.name.trim(),
          code: code,
          defaultServiceSeconds: line.defaultServiceSeconds,
          acceptingJoins: line.acceptingJoins,
          sortOrder: line.sortOrder,
          version: existing.version + 1,
        ),
      );
      await session.messages.postMessage(
        'line.${saved.id}',
        LineChanged(lineId: saved.id!, version: saved.version, reason: 'settings'),
      );
    }
    await _clinicChanged(session, clinicId);
    return saved;
  }

  Future<Room> upsertRoom(
    Session session,
    UuidValue clinicId,
    Room room,
    String? sandboxToken,
  ) async {
    await ClinicAuth.owner(session, clinicId, sandboxToken);
    _check(
      room.name.trim().isNotEmpty && room.name.trim().length <= 40,
      'Give the room a name.',
    );
    final line = await Line.db.findById(session, room.lineId);
    _check(line?.clinicId == clinicId, 'Pick a line for the room to call from.');
    final Room saved;
    if (room.id == null) {
      saved = await Room.db.insertRow(
        session,
        Room(
          clinicId: clinicId,
          lineId: room.lineId,
          name: room.name.trim(),
          state: room.state,
          sortOrder: room.sortOrder,
        ),
      );
    } else {
      final existing = await Room.db.findById(session, room.id!);
      _check(existing?.clinicId == clinicId, "That room isn't in this clinic.");
      saved = await Room.db.updateRow(
        session,
        existing!.copyWith(
          lineId: room.lineId,
          name: room.name.trim(),
          state: room.state,
          sortOrder: room.sortOrder,
        ),
      );
    }
    await _clinicChanged(session, clinicId);
    return saved;
  }

  Future<StaffInviteView> createInvite(
    Session session,
    UuidValue clinicId,
    StaffRole role,
    String? sandboxToken,
  ) async {
    await ClinicAuth.owner(session, clinicId, sandboxToken);
    final code = Tokens.inviteCode();
    final expires = DateTime.now().toUtc().add(const Duration(hours: 48));
    await StaffInvite.db.insertRow(
      session,
      StaffInvite(
        clinicId: clinicId,
        codeHash: Tokens.hash(code),
        role: role,
        expiresAt: expires,
      ),
    );
    return StaffInviteView(
      inviteUrl: AppConfig.inviteUrl(session.serverpod, code),
      role: role,
      expiresAt: expires,
    );
  }

  Future<List<StaffMember>> listStaff(
    Session session,
    UuidValue clinicId,
    String? sandboxToken,
  ) async {
    await ClinicAuth.owner(session, clinicId, sandboxToken);
    return StaffMember.db.find(
      session,
      where: (t) => t.clinicId.equals(clinicId),
      orderByList: (t) => [t.active.desc(), t.createdAt.asc()],
    );
  }

  Future<void> deactivateStaff(
    Session session,
    UuidValue clinicId,
    UuidValue staffMemberId,
    String? sandboxToken,
  ) async {
    await ClinicAuth.owner(session, clinicId, sandboxToken);
    final member = await StaffMember.db.findById(session, staffMemberId);
    _check(member?.clinicId == clinicId, "That person isn't on this clinic's staff.");
    if (member!.role == StaffRole.owner) {
      final owners = await StaffMember.db.count(
        session,
        where: (t) =>
            t.clinicId.equals(clinicId) &
            t.role.equals(StaffRole.owner) &
            t.active.equals(true),
      );
      _check(owners > 1, Copy.lastOwner);
    }
    await StaffMember.db.updateRow(session, member.copyWith(active: false));
    session.log('[auth] staff ${member.id} deactivated');
  }

  Future<String> rotateBoardToken(
    Session session,
    UuidValue clinicId,
    String? sandboxToken,
  ) async {
    final auth = await ClinicAuth.owner(session, clinicId, sandboxToken);
    final token = Tokens.mint();
    await Clinic.db.updateRow(
      session,
      auth.clinic.copyWith(boardTokenHash: Tokens.hash(token)),
    );
    await _clinicChanged(session, clinicId);
    return AppConfig.boardUrl(session.serverpod, token);
  }

  Future<DayReport> dayReport(
    Session session,
    UuidValue clinicId,
    String serviceDate,
    String? sandboxToken,
  ) async {
    final auth = await ClinicAuth.owner(session, clinicId, sandboxToken);
    _date(serviceDate);
    final stored = await DayReport.db.findFirstRow(
      session,
      where: (t) =>
          t.clinicId.equals(clinicId) & t.serviceDate.equals(serviceDate),
    );
    if (stored != null) return stored;
    return DayReport(
      clinicId: clinicId,
      serviceDate: serviceDate,
      generatedAt: DateTime.now().toUtc(),
      data: await Reports.build(session, auth.clinic, serviceDate),
    );
  }

  Future<String> dayReportCsv(
    Session session,
    UuidValue clinicId,
    String serviceDate,
    String? sandboxToken,
  ) async {
    final auth = await ClinicAuth.owner(session, clinicId, sandboxToken);
    _date(serviceDate);
    final lines = await Line.db.find(
      session,
      where: (t) => t.clinicId.equals(clinicId),
    );
    final tickets = await Ticket.db.find(
      session,
      where: (t) =>
          t.clinicId.equals(clinicId) & t.serviceDate.equals(serviceDate),
      orderBy: (t) => t.joinedAt,
    );
    return Reports.csv(
      auth.clinic,
      {for (final l in lines) l.id!: l.name},
      tickets,
    );
  }

  Future<List<TicketEvent>> audit(
    Session session,
    UuidValue clinicId,
    String serviceDate,
    int limit,
    UuidValue? before,
    String? sandboxToken,
  ) async {
    final auth = await ClinicAuth.owner(session, clinicId, sandboxToken);
    _date(serviceDate);
    final start = ClinicTime.atLocal(auth.clinic.timezone, serviceDate, '00:00');
    final end = start.add(const Duration(days: 1));
    DateTime? cursor;
    if (before != null) {
      cursor = (await TicketEvent.db.findById(session, before))?.at;
    }
    return TicketEvent.db.find(
      session,
      where: (t) {
        var w = t.clinicId.equals(clinicId) & (t.at >= start) & (t.at < end);
        if (cursor != null) w = w & (t.at < cursor);
        return w;
      },
      orderBy: (t) => t.at.desc(),
      limit: limit.clamp(1, 500),
    );
  }

  Future<List<Notification>> notificationLog(
    Session session,
    UuidValue clinicId,
    String serviceDate,
    int limit,
    String? sandboxToken,
  ) async {
    final auth = await ClinicAuth.owner(session, clinicId, sandboxToken);
    _date(serviceDate);
    final start = ClinicTime.atLocal(auth.clinic.timezone, serviceDate, '00:00');
    final end = start.add(const Duration(days: 1));
    return Notification.db.find(
      session,
      where: (t) =>
          t.clinicId.equals(clinicId) &
          (t.createdAt >= start) &
          (t.createdAt < end),
      orderBy: (t) => t.createdAt.desc(),
      limit: limit.clamp(1, 500),
    );
  }

  static void _check(bool ok, String message) {
    if (!ok) {
      throw DocketException(code: DocketErrorCode.validation, message: message);
    }
  }

  static void _serviceSeconds(int value) => _check(
    value >= 60 && value <= 3600,
    'Usual time per patient has to be between 1 and 60 minutes.',
  );

  static void _date(String value) => _check(
    RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(value),
    'Pick a date.',
  );

  static Future<void> _clinicChanged(Session session, UuidValue clinicId) =>
      session.messages.postMessage(
        'clinic.$clinicId',
        ClinicChanged(clinicId: clinicId),
      );
}
