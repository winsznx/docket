import 'package:docket_client/docket_client.dart';

/// The clinic the console is managing, and how: as a signed-in owner, or
/// with a sandbox token on a sandbox clinic.
class OwnerAccess {
  OwnerAccess({
    required this.clinicId,
    required this.clinicName,
    this.sandboxToken,
    this.boardUrl,
  });

  final UuidValue clinicId;
  final String clinicName;
  final String? sandboxToken;

  /// The board link, known only right after it's made, since the server
  /// keeps just its hash.
  String? boardUrl;

  bool get isSandbox => sandboxToken != null;
}
