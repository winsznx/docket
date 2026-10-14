import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:go_router/go_router.dart';
import 'package:web/web.dart' as web;

import 'client.dart';
import 'shared/theme/theme.dart';
import 'surfaces/board/board_screen.dart';
import 'surfaces/common/not_found_screen.dart';
import 'surfaces/desk/desk_screen.dart';
import 'surfaces/desk/try_screen.dart';
import 'surfaces/owner/invite_screen.dart';
import 'surfaces/owner/owner_screen.dart';
import 'surfaces/patient/join_screen.dart';
import 'surfaces/patient/ticket_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  await initializeClient();
  runApp(const DocketApp());
  WidgetsBinding.instance.addPostFrameCallback(
    (_) => web.document.getElementById('splash')?.remove(),
  );
}

/// One app for every surface, chosen by route (PRD 17). The site owns `/`,
/// so a visit there leaves the app with a full page load (BUILD A3).
final router = GoRouter(
  errorBuilder: (context, state) => const NotFoundScreen(),
  redirect: (context, state) {
    if (state.uri.path == '/' || state.uri.path.isEmpty) {
      web.window.location.assign('/');
    }
    return null;
  },
  routes: [
    GoRoute(path: '/', builder: (context, state) => const SizedBox.shrink()),
    GoRoute(
      path: '/j/:slug',
      builder: (context, state) => JoinScreen(
        slug: state.pathParameters['slug']!,
        lineCode: state.uri.queryParameters['line'],
      ),
    ),
    GoRoute(
      path: '/t/:token',
      builder: (context, state) =>
          TicketScreen(token: state.pathParameters['token']!),
    ),
    GoRoute(path: '/desk', builder: (context, state) => const DeskScreen()),
    GoRoute(path: '/try', builder: (context, state) => const TryScreen()),
    GoRoute(
      path: '/b/:token',
      builder: (context, state) =>
          BoardScreen(token: state.pathParameters['token']!),
    ),
    GoRoute(path: '/owner', builder: (context, state) => const OwnerScreen()),
    GoRoute(
      path: '/invite/:code',
      builder: (context, state) =>
          InviteScreen(code: state.pathParameters['code']!),
    ),
  ],
);

class DocketApp extends StatelessWidget {
  const DocketApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Docket',
      debugShowCheckedModeBanner: false,
      theme: docketTheme(Brightness.light),
      darkTheme: docketTheme(Brightness.dark),
      themeMode: ThemeMode.system,
      routerConfig: router,
    );
  }
}
