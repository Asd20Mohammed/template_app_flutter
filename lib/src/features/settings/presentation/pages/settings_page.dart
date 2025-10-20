// Shows user configurable application settings.
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:template_app/src/app/bloc/blocs.dart';
import 'package:template_app/src/app/router/app_router.dart';
import 'package:template_app/src/shared/widgets/buttons/primary_button.dart';

/// Settings screen containing preferences and account actions.
class SettingsPage extends StatelessWidget {
  /// Creates a new [SettingsPage].
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, settingsState) {
        final appState = context.watch<AppBloc>().state;
        final user = context.watch<AuthBloc>().state.user;
        final seedColor = appState.seedColor;
        final colors = <Color>[
          Colors.blue,
          Colors.indigo,
          Colors.teal,
          Colors.orange,
          Colors.pink,
          Colors.purple,
          Colors.brown,
        ];
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: seedColor,
                  child: Text(
                    (() {
                      final name = (user?.displayName ?? 'Guest').trim();
                      return name.isNotEmpty ? name[0].toUpperCase() : 'G';
                    })(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                title: Text(user?.displayName ?? 'Guest User'),
                subtitle: Text(user?.email ?? 'anonymous@example.com'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => const ProfileRoute().go(context),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Appearance',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    SegmentedButton<ThemeMode>(
                      segments: const [
                        ButtonSegment(
                          value: ThemeMode.system,
                          icon: Icon(Icons.settings_suggest),
                          label: Text('System'),
                        ),
                        ButtonSegment(
                          value: ThemeMode.light,
                          icon: Icon(Icons.wb_sunny_outlined),
                          label: Text('Light'),
                        ),
                        ButtonSegment(
                          value: ThemeMode.dark,
                          icon: Icon(Icons.nightlight_round),
                          label: Text('Dark'),
                        ),
                      ],
                      selected: <ThemeMode>{appState.themeMode},
                      onSelectionChanged: (selection) {
                        context.read<AppBloc>().add(
                          AppThemeChanged(selection.first),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Accent color',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: colors
                          .map(
                            (color) => GestureDetector(
                              onTap: () => context.read<AppBloc>().add(
                                AppColorSeedChanged(color),
                              ),
                              child: Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: color,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: color == seedColor
                                        ? Colors.white
                                        : Colors.transparent,
                                    width: 2,
                                  ),
                                ),
                                child: color == seedColor
                                    ? const Icon(
                                        Icons.check,
                                        color: Colors.white,
                                      )
                                    : null,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Text size (${settingsState.textScale.toStringAsFixed(2)}x)',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    Slider(
                      value: settingsState.textScale,
                      min: 0.8,
                      max: 1.4,
                      divisions: 6,
                      label: settingsState.textScale.toStringAsFixed(2),
                      onChanged: (value) => context.read<SettingsBloc>().add(
                        SettingsTextScaleChanged(value),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Interface scale (${settingsState.layoutScale.toStringAsFixed(2)}x)',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    Slider(
                      value: settingsState.layoutScale,
                      min: 0.8,
                      max: 1.4,
                      divisions: 6,
                      label: settingsState.layoutScale.toStringAsFixed(2),
                      onChanged: (value) => context.read<SettingsBloc>().add(
                        SettingsLayoutScaleChanged(value),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'General',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
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
                    const SizedBox(height: 16),
                    PrimaryButton(
                      label: 'Switch to guest mode',
                      onPressed: () {
                        context.read<AuthBloc>().add(
                          const AuthLogoutRequested(),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    PrimaryButton(
                      label: 'Sign in / Register',
                      onPressed: () {
                        final locale = context
                            .read<SettingsBloc>()
                            .state
                            .localeCode;
                        LoginRoute(locale: locale).go(context);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
