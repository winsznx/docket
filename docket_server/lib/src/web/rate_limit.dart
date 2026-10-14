import 'package:serverpod/serverpod.dart';

/// Per-IP ceilings on the API server (PRD 18). The client address comes
/// from `X-Forwarded-For` behind Cloud's load balancer. Counters are per
/// podlet, the per-clinic caps live in the database.
Middleware rateLimitMiddleware() {
  const window = Duration(minutes: 1);
  const limits = {
    'sandbox': 6,
    'publicClinic': 60,
    'ticket': 240,
    'staff': 60,
    'owner': 240,
    'desk': 600,
    'board': 120,
  };
  final counters = <String, ({DateTime start, int count})>{};
  var lastSweep = DateTime.now();

  return (Handler inner) {
    return (Request req) async {
      final segments = req.url.pathSegments;
      if (segments.isEmpty) return inner(req);
      final limit = limits[segments.first];
      if (limit == null) return inner(req);
      final forwarded = req.headers['x-forwarded-for']?.firstOrNull;
      final ip = forwarded?.split(',').first.trim() ??
          req.connectionInfo.remote.address.toString();
      final now = DateTime.now();
      if (now.difference(lastSweep) > const Duration(minutes: 5)) {
        counters.removeWhere((_, v) => now.difference(v.start) >= window);
        lastSweep = now;
      }
      final key = '${segments.first}|$ip';
      var entry = counters[key];
      if (entry == null || now.difference(entry.start) >= window) {
        entry = (start: now, count: 0);
      }
      entry = (start: entry.start, count: entry.count + 1);
      counters[key] = entry;
      if (entry.count > limit) {
        return Response(
          429,
          body: Body.fromString('Too many tries. Wait a minute and try again.'),
        );
      }
      return inner(req);
    };
  };
}
