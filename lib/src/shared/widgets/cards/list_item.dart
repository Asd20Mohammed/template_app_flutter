// Provides a reusable list tile component with consistent styling.
import 'package:flutter/material.dart';

/// Simple list tile for use in cards or lists.
class AppListItem extends StatelessWidget {
  /// Creates a new [AppListItem].
  const AppListItem({
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    super.key,
  });

  /// Primary title text.
  final String title;

  /// Optional secondary text displayed below the title.
  final String? subtitle;

  /// Optional widget displayed at the end of the tile.
  final Widget? trailing;

  /// Callback triggered when the tile is tapped.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing: trailing,
      onTap: onTap,
    );
  }
}
