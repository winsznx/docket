import 'package:docket_client/docket_client.dart' hide Notification;

/// Which clinic this desk works for and how it proves it: a signed-in staff
/// member, or the sandbox token from `/try` (PRD 9.3).
class DeskAccess {
  DeskAccess.sandbox(SandboxStart start)
    : clinicId = start.clinicId,
      sandboxToken = start.sandboxToken,
      sandbox = start;

  const DeskAccess.staff(this.clinicId) : sandboxToken = null, sandbox = null;

  final UuidValue clinicId;
  final String? sandboxToken;

  /// The sandbox this desk runs, with its board and join links.
  final SandboxStart? sandbox;

  bool get isSandbox => sandbox != null;
}
