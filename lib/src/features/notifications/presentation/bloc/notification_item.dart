// Manages notification routing for push, local, and in-app messages.

import 'package:equatable/equatable.dart';
import 'package:template_app/src/features/notifications/presentation/bloc/notification_type.dart';

/// Represents a single notification item in memory.
class NotificationItem extends Equatable {
  /// Creates a notification item.
  const NotificationItem({
    required this.type,
    required this.title,
    required this.body,
  });

  /// The notification classification.
  final NotificationType type;

  /// Title text for the notification.
  final String title;

  /// Body text for the notification.
  final String body;

  @override
  List<Object?> get props => [type, title, body];
}
