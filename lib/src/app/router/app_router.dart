// Configures all navigation routes and nested navigation stacks.
import 'package:flutter/material.dart';
import 'package:template_app/src/app/presentation/pages/splash_page.dart';
import 'package:template_app/src/app/router/deep_link_handler.dart';
import 'package:template_app/src/app/router/route_guard.dart';
import 'package:template_app/src/features/auth/presentation/pages/login_page.dart';
import 'package:template_app/src/features/dashboard/presentation/pages/home_page.dart';
import 'package:template_app/src/features/settings/presentation/pages/settings_page.dart';
import 'package:template_app/src/shared/widgets/layout/app_shell.dart';

/// Provides route names as constants to avoid typos.
class AppRoutes {
  /// Prevents instantiation.
  const AppRoutes._();

  /// Splash screen route name.
  static const splash = '/';

  /// Home screen route name.
  static const home = '/home';

  /// Login screen route name.
  static const login = '/login';

  /// Settings screen route name.
  static const settings = '/settings';
}

/// Handles navigation and deep link resolution.
class AppRouter {
  /// Creates a new [AppRouter].
  AppRouter({
    required RouteGuard routeGuard,
    required DeepLinkHandler deepLinkHandler,
  }) : _routeGuard = routeGuard,
       _deepLinkHandler = deepLinkHandler;

  final RouteGuard _routeGuard;
  final DeepLinkHandler _deepLinkHandler;

  /// Resolves routes for the [MaterialApp].
  Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final name = settings.name ?? AppRoutes.splash;
    final arguments = settings.arguments;

    if (_deepLinkHandler.canHandle(name)) {
      final resolvedRoute = _deepLinkHandler.resolve(name);
      return onGenerateRoute(
        RouteSettings(name: resolvedRoute, arguments: arguments),
      );
    }

    if (!_routeGuard.canActivate(name)) {
      return MaterialPageRoute<void>(
        builder: (_) => const LoginPage(),
        settings: const RouteSettings(name: AppRoutes.login),
      );
    }

    switch (name) {
      case AppRoutes.splash:
        return MaterialPageRoute<void>(
          builder: (_) => const SplashPage(),
          settings: settings,
        );
      case AppRoutes.home:
        return MaterialPageRoute<void>(
          builder: (_) => const AppShell(child: HomePage()),
          settings: settings,
        );
      case AppRoutes.settings:
        return MaterialPageRoute<void>(
          builder: (_) => const AppShell(child: SettingsPage()),
          settings: settings,
        );
      case AppRoutes.login:
        return MaterialPageRoute<void>(
          builder: (_) => const LoginPage(),
          settings: settings,
        );
      default:
        return MaterialPageRoute<void>(
          builder: (_) => const SplashPage(),
          settings: settings,
        );
    }
  }
}
