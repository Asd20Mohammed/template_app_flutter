// Provides a shared scaffold wrapper for feature screens.
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:template_app/src/app/bloc/blocs.dart';
import 'package:template_app/src/shared/widgets/feedback/app_snackbar.dart';

/// Base layout used across authenticated screens.
class AppShell extends StatelessWidget {
  /// Creates a new [AppShell].
  const AppShell({required this.child, super.key});

  /// Widget rendered inside the scaffold body.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ErrorBloc, ErrorState>(
      listener: (context, state) {
        if (state.message != null) {
          AppSnackbar.showError(context, state.message!);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Template Core'),
          actions: [
            IconButton(
              onPressed: () {
                final settingsBloc = context.read<SettingsBloc>();
                final nextValue = !settingsBloc.state.notificationsEnabled;
                settingsBloc.add(SettingsNotificationToggled(nextValue));
              },
              icon: const Icon(Icons.notifications),
            ),
          ],
        ),
        body: child,
      ),
    );
  }
}
