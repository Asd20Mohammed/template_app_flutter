// Displays a friendly message when there is no content to show.
import 'package:flutter/material.dart';
import '/src/core/theme/spacing.dart';

/// Simple reusable empty state.
class EmptyView extends StatelessWidget {
  /// Creates a new [EmptyView].
  const EmptyView({required this.title, required this.message, super.key});

  /// Title displayed prominently.
  final String title;

  /// Supporting descriptive message.
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(SpacingSystem.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: SpacingSystem.md),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
