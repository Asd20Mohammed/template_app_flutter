// Manages notification routing for push, local, and in-app messages.
import 'package:flutter_bloc/flutter_bloc.dart';
import '/src/core/services/notifications/push_notification_service.dart';
import '/src/features/notifications/presentation/bloc/notification_cleared.dart';
import '/src/features/notifications/presentation/bloc/notification_event.dart';
import '/src/features/notifications/presentation/bloc/notification_item.dart';
import '/src/features/notifications/presentation/bloc/notification_received.dart';
import '/src/features/notifications/presentation/bloc/notification_registration_requested.dart';
import '/src/features/notifications/presentation/bloc/notification_state.dart';

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
