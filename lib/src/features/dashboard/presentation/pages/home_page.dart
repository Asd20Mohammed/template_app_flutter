// Home dashboard showcasing the available template components.
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:template_app/src/app/bloc/blocs.dart';
import 'package:template_app/src/core/theme/spacing.dart';
import 'package:template_app/src/core/utils/responsive_utils.dart';
import 'package:template_app/src/shared/widgets/cards/app_card.dart';
import 'package:template_app/src/shared/widgets/cards/list_item.dart';
import 'package:template_app/src/shared/widgets/layout/section_header.dart';
import 'package:template_app/src/shared/widgets/state/loading_view.dart';

/// Landing page for authenticated users.
class HomePage extends StatelessWidget {
  /// Creates a new [HomePage].
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveUtils.horizontalPadding(context),
        vertical: SpacingSystem.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: 'Dashboard'),
          const SizedBox(height: SpacingSystem.md),
          Expanded(
            child: BlocBuilder<UserBloc, UserState>(
              builder: (context, state) {
                if (state.loading) {
                  return const LoadingView();
                }
                return ListView(
                  children: [
                    AppCard(
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
                            subtitle: state.user?.displayName ?? 'Guest',
                          ),
                          AppListItem(
                            title: 'Email',
                            subtitle:
                                state.user?.email ?? 'anonymous@example.com',
                          ),
                        ],
                      ),
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
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
