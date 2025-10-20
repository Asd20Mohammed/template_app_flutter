// Displays a splash screen while the app initializes.
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:template_app/src/app/router/app_router.dart';
import 'package:template_app/src/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:template_app/src/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:template_app/src/shared/widgets/state/loading_view.dart';

/// Splash screen that decides the initial navigation pathway.
class SplashPage extends StatefulWidget {
  /// Creates a new [SplashPage].
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _navigateWhenReady();
  }

  Future<void> _navigateWhenReady() async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    if (!mounted) {
      return;
    }
    final authStatus = context.read<AuthBloc>().state.status;
    final locale = context.read<SettingsBloc>().state.localeCode;
    if (authStatus == AuthStatus.authenticated) {
      HomeRoute(locale: locale).go(context);
    } else {
      LoginRoute(locale: locale).go(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: LoadingView());
  }
}
