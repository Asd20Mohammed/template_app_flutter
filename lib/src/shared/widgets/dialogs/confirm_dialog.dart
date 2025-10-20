// Provides a reusable confirmation dialog.
import 'package:flutter/material.dart';

/// Displays a confirm/cancel dialog and returns the user's choice.
class ConfirmDialog {
  /// Shows the confirmation dialog and returns true on acceptance.
  static Future<bool> show(
    BuildContext context, {
    required String title,
    required String message,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
    return result ?? false;
  }
}
