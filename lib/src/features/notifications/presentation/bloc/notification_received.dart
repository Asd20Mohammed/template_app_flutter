// Manages notification routing for push, local, and in-app messages.

import '/src/features/notifications/presentation/bloc/notification_event.dart';
import '/src/features/notifications/presentation/bloc/notification_type.dart';

/// Emits a notification payload to subscribers.
class NotificationReceived extends NotificationEvent {
  /// Creates a notification with a [title] and [body].
  const NotificationReceived({
    required this.type,
    required this.title,
    required this.body,
  });

  /// Indicates the type of notification received.
  final NotificationType type;

  /// The localized notification title.
  final String title;

  /// The localized notification message.
  final String body;

  @override
  List<Object?> get props => [type, title, body];
}
