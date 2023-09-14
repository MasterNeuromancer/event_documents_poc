import 'package:event_documents_poc/auth/firebase_auth_repository.dart';
import 'package:event_documents_poc/go_router_refresh_stream.dart';
import 'package:event_documents_poc/sign_in/custom_sign_in_screen.dart';
import 'package:event_documents_poc/widgets/scaffold_with_nav_rail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

class AppPages {
  static String signIn = '/sign_in';
  static String home = '/';
  static String rooms = '/rooms';
  static String server = '/server';
}

final routerProvider = Provider<GoRouter>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,
    initialLocation: AppPages.signIn,
    redirect: (BuildContext context, GoRouterState state) {
      final isAuthenticated = authRepository.currentUser != null;
      final isLoggingIn = state.uri.toString() == AppPages.signIn;

      if (!isAuthenticated && !isLoggingIn) {
        return AppPages.signIn;
      }

      if (isAuthenticated && isLoggingIn) {
        return AppPages.home;
      }

      return null;
    },
    refreshListenable: GoRouterRefreshStream(authRepository.authStateChanges()),
    routes: <RouteBase>[
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppPages.signIn,
        builder: (BuildContext context, GoRouterState state) {
          return const CustomSignInScreen();
        },
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => ScaffoldWithNavRail(child: child),
        routes: <RouteBase>[
          GoRoute(
            parentNavigatorKey: _shellNavigatorKey,
            path: AppPages.home,
            pageBuilder: (BuildContext context, GoRouterState state) {
              return const NoTransitionPage(
                child: Column(
                  children: [
                    Center(
                      child: Text(
                        'hello from file upload screen',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          GoRoute(
            parentNavigatorKey: _shellNavigatorKey,
            path: AppPages.rooms,
            pageBuilder: (BuildContext context, GoRouterState state) {
              return const NoTransitionPage(
                child: Column(
                  children: [
                    Center(
                      child: Text(
                        'hello from Rooms Screen',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          GoRoute(
            parentNavigatorKey: _shellNavigatorKey,
            path: AppPages.server,
            pageBuilder: (BuildContext context, GoRouterState state) {
              return const NoTransitionPage(
                child: Column(
                  children: [
                    Center(
                      child: Text(
                        'hello from Server Screen',
                        style: TextStyle(color: Colors.greenAccent),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    ],
  );
});
