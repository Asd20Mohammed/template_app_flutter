// Provides a reusable card container for content sections.
import 'package:flutter/material.dart';
import 'package:template_app/theme/spacing.dart';

/// Styled card widget with consistent padding.
class AppCard extends StatelessWidget {
  /// Creates a new [AppCard].
  const AppCard({required this.child, this.onTap, super.key});

  /// Widget displayed inside the card.
  final Widget child;

  /// Optional callback when the card is tapped.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(SpacingSystem.md),
          child: child,
        ),
      ),
    );
  }
}
