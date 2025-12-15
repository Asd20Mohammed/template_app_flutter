// Wraps [TextFormField] with template styling and validation.
import 'package:flutter/material.dart';
import '/src/core/theme/spacing.dart';

/// Primary text field widget for forms.
class AppTextField extends StatelessWidget {
  /// Creates a new [AppTextField].
  const AppTextField({
    required this.label,
    this.controller,
    this.validator,
    this.obscureText = false,
    super.key,
  });

  /// Field label shown above the input.
  final String label;

  /// Optional controller for reading input values.
  final TextEditingController? controller;

  /// Optional validator returning an error message.
  final String? Function(String?)? validator;

  /// Whether to obscure the field, useful for passwords.
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: SpacingSystem.sm),
      child: TextFormField(
        controller: controller,
        validator: validator,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
