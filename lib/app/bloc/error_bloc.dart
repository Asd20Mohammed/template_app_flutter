// Aggregates domain and network errors for centralized handling.
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Base class for error events.
abstract class ErrorEvent extends Equatable {
  /// Creates a new error event.
  const ErrorEvent();

  @override
  List<Object?> get props => [];
}

/// Adds a new error to the queue for display or logging.
class ErrorReported extends ErrorEvent {
  /// Creates an [ErrorReported] event.
  const ErrorReported({required this.message, this.details});

  /// The user facing error message.
  final String message;

  /// Extra debugging details.
  final String? details;

  @override
  List<Object?> get props => [message, details];
}

/// Removes the current error from the queue.
class ErrorDismissed extends ErrorEvent {
  /// Creates an [ErrorDismissed] event.
  const ErrorDismissed();
}

/// Holds error meta data for display or analytics.
class ErrorState extends Equatable {
  /// Creates a new [ErrorState].
  const ErrorState({required this.message, required this.details});

  /// The latest error message or null if there is none.
  final String? message;

  /// Optional technical details for logs.
  final String? details;

  /// Provides an empty error state.
  factory ErrorState.initial() =>
      const ErrorState(message: null, details: null);

  /// Creates a copy with overrides.
  ErrorState copyWith({String? message, String? details}) {
    return ErrorState(message: message, details: details);
  }

  @override
  List<Object?> get props => [message, details];
}

/// Routes application errors to the presentation layer.
class ErrorBloc extends Bloc<ErrorEvent, ErrorState> {
  /// Creates a new [ErrorBloc].
  ErrorBloc() : super(ErrorState.initial()) {
    on<ErrorReported>(_onErrorReported);
    on<ErrorDismissed>(_onErrorDismissed);
  }

  /// Stores the error in the state for rendering and logging.
  void _onErrorReported(ErrorReported event, Emitter<ErrorState> emit) {
    emit(state.copyWith(message: event.message, details: event.details));
  }

  /// Clears the current error from the state.
  void _onErrorDismissed(ErrorDismissed event, Emitter<ErrorState> emit) {
    emit(ErrorState.initial());
  }
}
