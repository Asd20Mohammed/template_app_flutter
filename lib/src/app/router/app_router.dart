// Defines all application routes using go_router's code generation.
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:template_app/src/app/bloc/blocs.dart';
import 'package:template_app/src/app/presentation/pages/splash_page.dart';
import 'package:template_app/src/features/auth/presentation/pages/login_page.dart';
import 'package:template_app/src/features/dashboard/presentation/pages/home_page.dart';
import 'package:template_app/src/features/profile/presentation/pages/profile_page.dart';
import 'package:template_app/src/features/settings/presentation/pages/settings_page.dart';
import 'package:template_app/src/shared/widgets/layout/app_shell.dart';
import 'package:template_app/src/shared/widgets/state/loading_view.dart';

part 'app_router.g.dart';

/// Splash route rendered while the application determines the initial screen.
@TypedGoRoute<SplashRoute>(path: '/')
class SplashRoute extends GoRouteData with $SplashRoute {
  /// Creates a splash route with an optional locale query parameter.
  const SplashRoute({this.locale});

  /// Optional locale code passed through query parameters.
  final String? locale;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    _syncLocale(context, locale);
    return const SplashPage();
  }
}

/// Authentication route that presents the login/register form.
@TypedGoRoute<LoginRoute>(path: '/login')
class LoginRoute extends GoRouteData with $LoginRoute {
  /// Creates a new login route.
  const LoginRoute({this.locale});

  /// Optional locale to apply when the screen is opened.
  final String? locale;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    _syncLocale(context, locale);
    return const LoginPage();
  }

  @override
  String? redirect(BuildContext context, GoRouterState state) {
    final authStatus = context.read<AuthBloc>().state.status;
    if (authStatus == AuthStatus.authenticated) {
      return HomeRoute(locale: locale ?? _currentLocale(context)).location;
    }
    return null;
  }
}

/// Shell-less home route wrapped in the shared [AppShell].
@TypedGoRoute<HomeRoute>(path: '/home')
class HomeRoute extends GoRouteData with $HomeRoute {
  /// Creates a new home route.
  const HomeRoute({this.locale});

  /// Optional locale to set when navigating.
  final String? locale;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    _syncLocale(context, locale);
    return AppShell(child: const HomePage());
  }

  @override
  String? redirect(BuildContext context, GoRouterState state) {
    final authStatus = context.read<AuthBloc>().state.status;
    if (authStatus != AuthStatus.authenticated) {
      return LoginRoute(locale: locale ?? _currentLocale(context)).location;
    }
    return null;
  }
}

/// Settings route for managing user preferences.
@TypedGoRoute<SettingsRoute>(path: '/settings')
class SettingsRoute extends GoRouteData with $SettingsRoute {
  /// Creates a new settings route.
  const SettingsRoute({this.locale});

  /// Optional locale applied during navigation.
  final String? locale;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    _syncLocale(context, locale);
    return const AppShell(child: SettingsPage());
  }

  @override
  String? redirect(BuildContext context, GoRouterState state) {
    final authStatus = context.read<AuthBloc>().state.status;
    if (authStatus != AuthStatus.authenticated) {
      return LoginRoute(locale: locale ?? _currentLocale(context)).location;
    }
    return null;
  }
}

/// Profile route showing user information.
@TypedGoRoute<ProfileRoute>(path: '/profile')
class ProfileRoute extends GoRouteData with $ProfileRoute {
  /// Creates a profile route.
  const ProfileRoute({this.locale});

  /// Optional locale applied during navigation.
  final String? locale;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    _syncLocale(context, locale);
    return const AppShell(child: ProfilePage());
  }

  @override
  String? redirect(BuildContext context, GoRouterState state) {
    final authStatus = context.read<AuthBloc>().state.status;
    if (authStatus != AuthStatus.authenticated) {
      return LoginRoute(locale: locale ?? _currentLocale(context)).location;
    }
    return null;
  }
}

/// Error route rendered when an unknown location is reached.
class NotFoundRoute extends GoRouteData {
  /// Creates the not found route with an optional error object.
  const NotFoundRoute({this.error});

  /// The underlying error that triggered the fallback.
  final Exception? error;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const Scaffold(body: LoadingView());
  }
}

void _syncLocale(BuildContext context, String? locale) {
  if (locale == null || locale.isEmpty) {
    return;
  }
  final settingsBloc = context.read<SettingsBloc>();
  if (settingsBloc.state.localeCode != locale) {
    settingsBloc.add(SettingsLocaleChanged(locale));
  }
}

String _currentLocale(BuildContext context) {
  return context.read<SettingsBloc>().state.localeCode;
}
