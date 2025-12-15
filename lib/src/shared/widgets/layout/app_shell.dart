// Provides a shared scaffold wrapper for feature screens.
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/src/app/bloc/blocs.dart';
import '/src/app/router/app_router.dart';
import '/src/shared/widgets/feedback/app_snackbar.dart';

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
        drawer: const _AppDrawer(),
        body: child,
      ),
    );
  }
}

class _AppDrawer extends StatelessWidget {
  const _AppDrawer();

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    final user = authState.user;
    final displayName = user?.displayName ?? 'Guest User';
    final trimmed = displayName.trim();
    final initial = trimmed.isNotEmpty ? trimmed[0].toUpperCase() : 'G';
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            ListTile(
              leading: CircleAvatar(child: Text(initial)),
              title: Text(displayName),
              subtitle: Text(user?.email ?? 'anonymous@example.com'),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.of(context).pop();
                const HomeRoute().go(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                Navigator.of(context).pop();
                const ProfileRoute().go(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.of(context).pop();
                const SettingsRoute().go(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
