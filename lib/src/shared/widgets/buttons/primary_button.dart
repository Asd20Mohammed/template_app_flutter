// Primary elevated button used across the app.
import 'package:flutter/material.dart';
import 'package:template_app/src/core/theme/spacing.dart';

/// Styled elevated button with full-width support.
class PrimaryButton extends StatelessWidget {
  /// Creates a new [PrimaryButton].
  const PrimaryButton({
    required this.label,
    required this.onPressed,
    this.expand = true,
    super.key,
  });

  /// Text displayed inside the button.
  final String label;

  /// Callback invoked when the button is pressed.
  final VoidCallback onPressed;

  /// Whether the button should expand to fill the width.
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final button = ElevatedButton(
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: SpacingSystem.sm),
        child: Text(label),
      ),
    );
    if (expand) {
      return SizedBox(width: double.infinity, child: button);
    }
    return button;
  }
}
