// Manages notification routing for push, local, and in-app messages.

import 'package:equatable/equatable.dart';

/// Base class for notification events.
abstract class NotificationEvent extends Equatable {
  /// Creates a new notification event.
  const NotificationEvent();

  @override
  List<Object?> get props => [];
}
