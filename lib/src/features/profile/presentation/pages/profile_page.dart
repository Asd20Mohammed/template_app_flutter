import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/src/app/bloc/blocs.dart';
import '/src/core/theme/spacing.dart';

/// Displays the user profile information.
class ProfilePage extends StatelessWidget {
  /// Creates a new [ProfilePage].
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    final user = authState.user;
    final displayName = user?.displayName ?? 'Guest User';
    final email = user?.email ?? 'anonymous@example.com';
    final mode = (user?.isGuest ?? true) ? 'Guest mode' : 'Authenticated user';
    final initial = displayName.trim().isNotEmpty
        ? displayName.trim()[0].toUpperCase()
        : 'G';

    return Padding(
      padding: const EdgeInsets.all(SpacingSystem.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(radius: 28, child: Text(initial)),
            title: Text(
              displayName,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            subtitle: Text(email),
          ),
          const SizedBox(height: SpacingSystem.lg),
          Text('Account', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: SpacingSystem.sm),
          Card(
            child: ListTile(
              leading: const Icon(Icons.badge_outlined),
              title: const Text('Account status'),
              subtitle: Text(mode),
            ),
          ),
          const SizedBox(height: SpacingSystem.lg),
          Text('Actions', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: SpacingSystem.sm),
          Card(
            child: Column(
              children: const [
                ListTile(
                  leading: Icon(Icons.edit),
                  title: Text('Edit profile (coming soon)'),
                  subtitle: Text('Connect a backend service to enable updates'),
                ),
                Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.cloud_upload_outlined),
                  title: Text('Sync with backend'),
                  subtitle: Text(
                    'Integrate MongoDB, Firebase, or other APIs later',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
