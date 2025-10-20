// Manages notification routing for push, local, and in-app messages.
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:template_app/services/notifications/push_notification_service.dart';

/// Defines the types of notifications the template supports.
enum NotificationType { push, local, inApp }

/// Base class for notification events.
abstract class NotificationEvent extends Equatable {
  /// Creates a new notification event.
  const NotificationEvent();

  @override
  List<Object?> get props => [];
}

/// Registers the device for remote push notifications.
class NotificationRegistrationRequested extends NotificationEvent {
  /// Creates the registration request event.
  const NotificationRegistrationRequested();
}

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

/// Clears all notifications from the state.
class NotificationCleared extends NotificationEvent {
  /// Creates a notification clearing event.
  const NotificationCleared();
}

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

/// Coordinates notification handling for multiple channels.
class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  /// Creates a new [NotificationBloc].
  NotificationBloc({required PushNotificationService pushNotificationService})
    : _pushNotificationService = pushNotificationService,
      super(NotificationState.initial()) {
    on<NotificationRegistrationRequested>(_onRegistrationRequested);
    on<NotificationReceived>(_onNotificationReceived);
    on<NotificationCleared>(_onNotificationCleared);
  }

  final PushNotificationService _pushNotificationService;

  /// Marks the bloc as registered for push notifications.
  Future<void> _onRegistrationRequested(
    NotificationRegistrationRequested event,
    Emitter<NotificationState> emit,
  ) async {
    await _pushNotificationService.registerDevice();
    emit(state.copyWith(registered: true));
  }

  /// Adds the received notification to the in-memory list.
  void _onNotificationReceived(
    NotificationReceived event,
    Emitter<NotificationState> emit,
  ) {
    final updatedItems = List<NotificationItem>.from(state.items)
      ..add(
        NotificationItem(
          type: event.type,
          title: event.title,
          body: event.body,
        ),
      );
    emit(state.copyWith(items: updatedItems));
  }

  /// Clears the list of stored notifications.
  void _onNotificationCleared(
    NotificationCleared event,
    Emitter<NotificationState> emit,
  ) {
    emit(state.copyWith(items: []));
  }
}
