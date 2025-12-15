// Home dashboard showcasing the available template components.
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/src/app/bloc/blocs.dart';
import '/src/core/theme/spacing.dart';
import '/src/core/utils/responsive_utils.dart';
import '/src/features/drafts/presentation/bloc/draft_bloc.dart';
import '/src/shared/widgets/cards/app_card.dart';
import '/src/shared/widgets/cards/list_item.dart';
import '/src/shared/widgets/layout/section_header.dart';
import '/src/shared/widgets/state/empty_view.dart';
import '/src/shared/widgets/state/error_view.dart';
import '/src/shared/widgets/state/loading_view.dart';

/// Landing page for authenticated users.
class HomePage extends StatelessWidget {
  /// Creates a new [HomePage].
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveUtils.horizontalPadding(context),
            vertical: SpacingSystem.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeader(title: 'Dashboard'),
              const SizedBox(height: SpacingSystem.md),
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, authState) {
                  final user = authState.user;
                  final name = user?.displayName ?? 'Guest';
                  final mode = (user?.isGuest ?? true)
                      ? 'Guest mode'
                      : 'Signed in';
                  return Padding(
                    padding: const EdgeInsets.only(bottom: SpacingSystem.md),
                    child: Text(
                      'Welcome, $name • $mode',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  );
                },
              ),
              Expanded(
                child: ListView(
                  children: [
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, authState) {
                        final user = authState.user;
                        return AppCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'User Profile',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: SpacingSystem.sm),
                              AppListItem(
                                title: 'Name',
                                subtitle: user?.displayName ?? 'Guest',
                              ),
                              AppListItem(
                                title: 'Email',
                                subtitle:
                                    user?.email ?? 'anonymous@example.com',
                              ),
                              AppListItem(
                                title: 'Mode',
                                subtitle: (user?.isGuest ?? true)
                                    ? 'Guest'
                                    : 'Authenticated',
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: SpacingSystem.md),
                    BlocBuilder<NetworkBloc, NetworkState>(
                      builder: (context, networkState) {
                        return AppCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Network',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: SpacingSystem.sm),
                              Text('Status: ${networkState.status.name}'),
                              const SizedBox(height: SpacingSystem.sm),
                              ElevatedButton(
                                onPressed: () => context
                                    .read<NetworkBloc>()
                                    .add(const NetworkCheckRequested()),
                                child: const Text('Check connectivity'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: SpacingSystem.md),
                    BlocBuilder<FeatureBloc, FeatureState>(
                      builder: (context, featureState) {
                        return AppCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Feature Flags',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: SpacingSystem.sm),
                              Text(
                                featureState.flags.isEmpty
                                    ? 'No feature flags configured.'
                                    : featureState.flags.entries
                                          .map((e) => '${e.key}: ${e.value}')
                                          .join('\n'),
                              ),
                              const SizedBox(height: SpacingSystem.sm),
                              ElevatedButton(
                                onPressed: () =>
                                    context.read<FeatureBloc>().add(
                                      const FeatureFlagChanged(
                                        featureKey: 'demo',
                                        enabled: true,
                                      ),
                                    ),
                                child: const Text('Enable Demo Feature'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: SpacingSystem.md),
                    BlocBuilder<DraftBloc, DraftState>(
                      builder: (context, draftState) {
                        Widget content;
                        switch (draftState.status) {
                          case DraftStatus.loading:
                            content = const LoadingView();
                            break;
                          case DraftStatus.failure:
                            content = ErrorView(
                              message:
                                  draftState.errorMessage ??
                                  'Failed to load drafts',
                              onRetry: () => context.read<DraftBloc>().add(
                                const DraftLoadRequested(),
                              ),
                            );
                            break;
                          default:
                            if (draftState.drafts.isEmpty) {
                              content = const EmptyView(
                                title: 'No drafts yet',
                                message:
                                    'Create drafts locally and sync them when you connect to a backend.',
                              );
                            } else {
                              content = Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: draftState.drafts
                                    .map(
                                      (entry) => AppListItem(
                                        title: entry.title,
                                        subtitle: entry.description,
                                        trailing: IconButton(
                                          icon: const Icon(
                                            Icons.delete_outline,
                                          ),
                                          onPressed: () =>
                                              context.read<DraftBloc>().add(
                                                DraftDeleteRequested(
                                                  id: entry.id,
                                                ),
                                              ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              );
                            }
                            break;
                        }
                        return AppCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Drafts',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: SpacingSystem.sm),
                              content,
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: SpacingSystem.lg,
          right: SpacingSystem.lg,
          child: FloatingActionButton.extended(
            onPressed: () => _showCreateDraftDialog(context),
            icon: const Icon(Icons.add),
            label: const Text('New draft'),
          ),
        ),
      ],
    );
  }

  Future<void> _showCreateDraftDialog(BuildContext context) async {
    final formKey = GlobalKey<FormState>();
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final draftBloc = context.read<DraftBloc>();
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('New draft'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                  validator: (value) => (value == null || value.trim().isEmpty)
                      ? 'Please provide a title'
                      : null,
                ),
                const SizedBox(height: SpacingSystem.sm),
                TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState?.validate() ?? false) {
                  Navigator.of(dialogContext).pop(true);
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    if (result == true) {
      draftBloc.add(
        DraftCreateRequested(
          title: titleController.text.trim(),
          description: descriptionController.text.trim(),
        ),
      );
    }
  }
}
