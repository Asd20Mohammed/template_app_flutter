// Provides APIs to display local notifications to the user.
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

/// Simple local notification helper using ScaffoldMessenger.
class LocalNotificationService {
  /// Creates a new [LocalNotificationService].
  LocalNotificationService() : _logger = Logger('LocalNotificationService');

  final Logger _logger;

  /// Shows a notification using the nearest [ScaffoldMessenger].
  void showNotification(BuildContext context, String message) {
    _logger.info('Displaying local notification: $message');
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
