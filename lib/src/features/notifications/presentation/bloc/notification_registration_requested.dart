// Manages notification routing for push, local, and in-app messages.

import 'package:template_app/src/features/notifications/presentation/bloc/notification_event.dart';

/// Registers the device for remote push notifications.
class NotificationRegistrationRequested extends NotificationEvent {
  /// Creates the registration request event.
  const NotificationRegistrationRequested();
}
