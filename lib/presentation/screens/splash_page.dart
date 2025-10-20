// Displays a splash screen while the app initializes.
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:template_app/app/bloc/auth_bloc.dart';
import 'package:template_app/app/router/app_router.dart';
import 'package:template_app/presentation/widgets/state/loading_view.dart';

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
    if (authStatus == AuthStatus.authenticated) {
      Navigator.of(context).pushReplacementNamed(AppRoutes.home);
    } else {
      Navigator.of(context).pushReplacementNamed(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: LoadingView());
  }
}
