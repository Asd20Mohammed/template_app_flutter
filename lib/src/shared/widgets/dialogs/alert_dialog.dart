// Displays a simple alert dialog with a single button.
import 'package:flutter/material.dart';

/// Utility for showing informational alerts.
class AlertDialogHelper {
  /// Shows an alert dialog with a dismiss button.
  static Future<void> show(
    BuildContext context, {
    required String title,
    required String message,
  }) {
    return showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
