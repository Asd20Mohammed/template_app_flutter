// Presents an error state with retry support.
import 'package:flutter/material.dart';
import '/src/core/theme/spacing.dart';

/// Reusable error widget for the UI layer.
class ErrorView extends StatelessWidget {
  /// Creates a new [ErrorView].
  const ErrorView({required this.message, this.onRetry, super.key});

  /// Message describing the error.
  final String message;

  /// Optional callback for retry actions.
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: SpacingSystem.md),
          if (onRetry != null)
            ElevatedButton(onPressed: onRetry, child: const Text('Try again')),
        ],
      ),
    );
  }
}
