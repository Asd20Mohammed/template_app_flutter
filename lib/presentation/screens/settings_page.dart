// Shows user configurable application settings.
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:template_app/app/bloc/app_bloc.dart';
import 'package:template_app/app/bloc/auth_bloc.dart';
import 'package:template_app/app/bloc/settings_bloc.dart';
import 'package:template_app/presentation/widgets/buttons/primary_button.dart';

/// Settings screen containing preferences and account actions.
class SettingsPage extends StatelessWidget {
  /// Creates a new [SettingsPage].
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, settingsState) {
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            SwitchListTile(
              value: context.watch<AppBloc>().state.themeMode == ThemeMode.dark,
              title: const Text('Dark mode'),
              onChanged: (enabled) {
                context.read<AppBloc>().add(
                  AppThemeChanged(enabled ? ThemeMode.dark : ThemeMode.light),
                );
              },
            ),
            SwitchListTile(
              value: settingsState.notificationsEnabled,
              title: const Text('Push notifications'),
              onChanged: (enabled) {
                context.read<SettingsBloc>().add(
                  SettingsNotificationToggled(enabled),
                );
              },
            ),
            DropdownButtonFormField<String>(
              initialValue: settingsState.localeCode,
              decoration: const InputDecoration(labelText: 'Language'),
              items: const [
                DropdownMenuItem(value: 'en', child: Text('English')),
                DropdownMenuItem(value: 'ar', child: Text('العربية')),
              ],
              onChanged: (value) {
                if (value != null) {
                  context.read<SettingsBloc>().add(
                    SettingsLocaleChanged(value),
                  );
                }
              },
            ),
            const SizedBox(height: 32),
            PrimaryButton(
              label: 'Logout',
              onPressed: () {
                context.read<AuthBloc>().add(const AuthLogoutRequested());
                Navigator.of(context).popUntil((route) => route.isFirst);
                Navigator.of(context).pushReplacementNamed('/login');
              },
            ),
          ],
        );
      },
    );
  }
}
