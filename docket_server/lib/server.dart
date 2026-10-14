import 'dart:io';

import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:serverpod_cloud_storage/serverpod_cloud_storage.dart';

import 'src/domain/clinic_time.dart';
import 'src/domain/local_scheduler.dart';
import 'src/domain/timers.dart';
import 'src/generated/serverpod.dart';
import 'src/web/health.dart';
import 'src/web/rate_limit.dart';
import 'src/web/routes/app_config_route.dart';
import 'src/web/routes/first_paint_route.dart';
import 'src/web/routes/poster_route.dart';
import 'src/web/routes/ticket_shell_route.dart';
import 'src/web/routes/twilio_status_route.dart';
import 'src/web/site/site.dart';

String _timerMode = 'starting';

void run(List<String> args) async {
  ClinicTime.ensureLoaded();
  final pod = Serverpod(
    args,
    healthConfig: HealthConfig(
      additionalReadinessIndicators: [
        OverdueTimersIndicator(),
        TimerModeIndicator(() => _timerMode),
      ],
    ),
  );

  pod.initializeAuthServices(
    tokenManagerBuilders: [JwtConfigFromPasswords()],
    identityProviderBuilders: [
      ServerpodCloudEmailIdpConfig(appDisplayName: 'Docket'),
    ],
  );

  pod.server.addMiddleware(rateLimitMiddleware());

  registerSite(pod);

  pod.webServer.addRoute(FirstPaintRoute(), '/api/t/:token');
  pod.webServer.addRoute(PosterRoute(), '/api/poster/:slug');
  pod.webServer.addRoute(TwilioStatusRoute(), '/api/twilio/status');
  pod.webServer.addRoute(
    AppConfigRoute(apiConfig: pod.config.apiServer),
    '/assets/assets/config.json',
  );

  final appDir = Directory(Uri(path: 'web/app').toFilePath());
  if (appDir.existsSync()) {
    pod.webServer.addRoute(
      TicketShellRoute(File(Uri(path: 'web/app/index.html').toFilePath())),
      '/t/:token',
    );
    pod.webServer.addRoute(FlutterRoute(appDir, enableWasmHeaders: false));
  } else {
    pod.webServer.addRoute(
      StaticRoute.file(
        File(Uri(path: 'web/pages/build_flutter_app.html').toFilePath()),
      ),
      '/app/**',
    );
  }

  pod.addCloudStorage(
    await ServerpodCloudProvider.private(
      fallback: () => DatabaseCloudStorage('private'),
    ),
  );
  pod.addCloudStorage(
    await ServerpodCloudProvider.public(
      fallback: () => DatabaseCloudStorage('public'),
    ),
  );

  await pod.start();
  _timerMode = Timers.mode(pod);

  if (!Timers.executing(pod)) {
    final scheduler = LocalScheduler(pod)..start();
    pod.experimental.shutdownTasks.addTask(
      'docket-local-scheduler',
      () async => scheduler.stop(),
    );
    return;
  }

  // Recurring calls register after start, since scheduling before start
  // throws. Each is cancelled by identifier first so a restart never stacks
  // duplicates (PRD 11).
  final calls = pod.futureCalls;
  await calls.cancel('timer-sweep');
  await calls
      .callRecurring(identifier: 'timer-sweep')
      .every(const Duration(seconds: 30))
      .clinicJobs
      .timerSweep();
  await calls.cancel('presence-sweep');
  await calls
      .callRecurring(identifier: 'presence-sweep')
      .every(const Duration(seconds: 15))
      .clinicJobs
      .presenceSweep();
  await calls.cancel('nightly');
  await calls
      .callRecurring(identifier: 'nightly')
      .cron('0 1 * * *')
      .clinicJobs
      .nightly();
}
