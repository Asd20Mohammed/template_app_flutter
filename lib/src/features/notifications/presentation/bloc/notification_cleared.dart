// Manages notification routing for push, local, and in-app messages.

import '/src/features/notifications/presentation/bloc/notification_event.dart';

/// Clears all notifications from the state.
class NotificationCleared extends NotificationEvent {
  /// Creates a notification clearing event.
  const NotificationCleared();
}
