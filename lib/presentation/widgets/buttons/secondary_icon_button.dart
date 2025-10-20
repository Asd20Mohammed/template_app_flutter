// Provides a styled icon button with tooltip support.
import 'package:flutter/material.dart';

/// Secondary icon button used for toolbar actions.
class SecondaryIconButton extends StatelessWidget {
  /// Creates a new [SecondaryIconButton].
  const SecondaryIconButton({
    required this.icon,
    required this.onPressed,
    this.tooltip,
    super.key,
  });

  /// Icon drawn for the button.
  final IconData icon;

  /// Optional tooltip text when long pressed.
  final String? tooltip;

  /// Callback executed when the button is pressed.
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(tooltip: tooltip, onPressed: onPressed, icon: Icon(icon));
  }
}
