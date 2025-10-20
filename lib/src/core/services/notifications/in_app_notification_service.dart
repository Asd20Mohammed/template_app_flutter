// Coordinates in-app notification banners and prompts.
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

/// Displays unobtrusive notification banners inside the app.
class InAppNotificationService {
  /// Creates a new [InAppNotificationService].
  InAppNotificationService() : _logger = Logger('InAppNotificationService');

  final Logger _logger;

  /// Shows a material banner with the provided [message].
  void showBanner(BuildContext context, String message) {
    _logger.info('Displaying in-app banner: $message');
    ScaffoldMessenger.of(context).showMaterialBanner(
      MaterialBanner(
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () =>
                ScaffoldMessenger.of(context).hideCurrentMaterialBanner(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
