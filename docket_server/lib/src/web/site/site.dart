import 'dart:io';

import 'package:serverpod/serverpod.dart';

import 'page_content.dart';
import 'site_pages.dart';
import 'site_route.dart';

/// Registers the server-rendered site from DESIGN.md section 4.
///
/// Runs before `lib/server.dart` adds the Flutter app's `FlutterRoute` at the
/// root. Each page sits at a literal path, and a literal segment beats the
/// Flutter route's tail, so `/` is the home page while every app path, such
/// as `/try` or `/t/<token>`, still reaches the app and its SPA fallback.
/// `docs/DECISIONS.md` under "Site home route" records how that was checked.
void registerSite(Serverpod pod) {
  final siteDirectory = Directory(Uri(path: 'web/site').toFilePath());
  final assets = CacheBustingConfig(
    mountPrefix: '/site',
    fileSystemRoot: siteDirectory,
  );

  pod.webServer.addRoute(
    StaticRoute.directory(
      siteDirectory,
      cacheBustingConfig: assets,
      cacheControlFactory: StaticRoute.publicImmutable(
        maxAge: const Duration(days: 365),
      ),
    ),
    '/site/',
  );

  final origin = _publicOrigin(pod.config.webServer);
  final content = pageContent(assets);
  for (final page in sitePages) {
    final pageContent = content[page.path];
    if (pageContent == null) {
      throw StateError('No content builder for site page ${page.path}');
    }
    pod.webServer.addRoute(
      SitePageRoute(
        page: page,
        content: pageContent,
        origin: origin,
        assets: assets,
      ),
      page.path,
    );
  }
}

String _publicOrigin(ServerConfig? config) {
  if (config == null) return '';
  final defaultPort = switch (config.publicScheme) {
    'https' => 443,
    'http' => 80,
    _ => null,
  };
  return Uri(
    scheme: config.publicScheme,
    host: config.publicHost,
    port: config.publicPort == defaultPort ? null : config.publicPort,
  ).toString();
}
