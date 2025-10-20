// Displays a section header with optional subtitle.
import 'package:flutter/material.dart';
import 'package:template_app/src/core/theme/spacing.dart';

/// Reusable section header widget.
class SectionHeader extends StatelessWidget {
  /// Creates a new [SectionHeader].
  const SectionHeader({required this.title, this.subtitle, super.key});

  /// Header title text.
  final String title;

  /// Optional subtitle rendered below the title.
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.headlineMedium),
        if (subtitle != null) ...[
          const SizedBox(height: SpacingSystem.xs),
          Text(subtitle!, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ],
    );
  }
}
