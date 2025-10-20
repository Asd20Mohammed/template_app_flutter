// Provides a reusable checkbox form field with a label.
import 'package:flutter/material.dart';

/// Checkbox widget that integrates nicely with forms.
class AppCheckbox extends StatelessWidget {
  /// Creates a new [AppCheckbox].
  const AppCheckbox({
    required this.label,
    required this.value,
    required this.onChanged,
    super.key,
  });

  /// Description displayed next to the checkbox.
  final String label;

  /// Current value of the checkbox.
  final bool value;

  /// Callback invoked when the value changes.
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      value: value,
      title: Text(label),
      onChanged: onChanged,
      controlAffinity: ListTileControlAffinity.leading,
    );
  }
}
