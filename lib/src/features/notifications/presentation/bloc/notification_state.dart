// Manages notification routing for push, local, and in-app messages.

import 'package:equatable/equatable.dart';
import '/src/features/notifications/presentation/bloc/notification_item.dart';

/// Holds all currently delivered notification items.
class NotificationState extends Equatable {
  /// Creates a new [NotificationState].
  const NotificationState({required this.items, required this.registered});

  /// The current delivered notifications.
  final List<NotificationItem> items;

  /// Whether the device registered for push notifications.
  final bool registered;

  /// Creates the initial empty notification state.
  factory NotificationState.initial() =>
      const NotificationState(items: [], registered: false);

  /// Returns a copy with overrides.
  NotificationState copyWith({
    List<NotificationItem>? items,
    bool? registered,
  }) {
    return NotificationState(
      items: items ?? this.items,
      registered: registered ?? this.registered,
    );
  }

  @override
  List<Object?> get props => [items, registered];
}
