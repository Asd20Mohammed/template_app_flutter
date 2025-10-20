// Displays feedback to the user using scaffold snackbars.
import 'package:flutter/material.dart';

/// Collection of helper methods for snackbars.
class AppSnackbar {
  /// Prevents instantiation.
  const AppSnackbar._();

  /// Shows a positive success message.
  static void showSuccess(BuildContext context, String message) {
    _show(context, message, Colors.green);
  }

  /// Shows an error message with a red background.
  static void showError(BuildContext context, String message) {
    _show(context, message, Colors.red);
  }

  static void _show(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
  }
}
