// Provides a consistent dropdown widget for forms.
import 'package:flutter/material.dart';

/// Dropdown widget that handles label and validation.
class AppDropdown<T> extends StatelessWidget {
  /// Creates a new [AppDropdown].
  const AppDropdown({
    required this.label,
    required this.items,
    required this.onChanged,
    this.value,
    super.key,
  });

  /// Label shown above the dropdown.
  final String label;

  /// Items rendered inside the dropdown.
  final List<DropdownMenuItem<T>> items;

  /// Current selected value.
  final T? value;

  /// Callback triggered when the value changes.
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      initialValue: value,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      items: items,
      onChanged: onChanged,
    );
  }
}
