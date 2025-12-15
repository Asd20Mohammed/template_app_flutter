// Manages user profile data across the application.
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/src/features/profile/domain/entities/user.dart';
import '/src/features/profile/domain/usecases/user_usecases.dart';

/// Defines the events supported by [UserBloc].
abstract class UserEvent extends Equatable {
  /// Initializes a new user event.
  const UserEvent();

  @override
  List<Object?> get props => [];
}

/// Requests the user profile to be loaded from storage.
class UserProfileRequested extends UserEvent {
  /// Creates the profile load event.
  const UserProfileRequested();
}

/// Updates the in-memory user profile.
class UserProfileUpdated extends UserEvent {
  /// Creates an update event with the new [user].
  const UserProfileUpdated(this.user);

  /// The latest user profile snapshot.
  final User user;

  @override
  List<Object?> get props => [user];
}

/// Represents the immutable user state consumed by the UI.
class UserState extends Equatable {
  /// Creates a new [UserState].
  const UserState({required this.loading, this.user});

  /// Indicates whether a user request is in flight.
  final bool loading;

  /// The active user profile if any.
  final User? user;

  /// The initial state with no user data.
  factory UserState.initial() => const UserState(loading: false);

  /// Creates a copy with optional overrides.
  UserState copyWith({bool? loading, User? user}) {
    return UserState(loading: loading ?? this.loading, user: user ?? this.user);
  }

  @override
  List<Object?> get props => [loading, user];
}

/// Coordinates user profile actions for the presentation layer.
class UserBloc extends Bloc<UserEvent, UserState> {
  /// Creates a new [UserBloc].
  UserBloc({
    required FetchUserProfileUseCase fetchUserProfileUseCase,
    required UpdateUserProfileUseCase updateUserProfileUseCase,
  }) : _fetchUserProfileUseCase = fetchUserProfileUseCase,
       _updateUserProfileUseCase = updateUserProfileUseCase,
       super(UserState.initial()) {
    on<UserProfileRequested>(_onProfileRequested);
    on<UserProfileUpdated>(_onProfileUpdated);
  }

  final FetchUserProfileUseCase _fetchUserProfileUseCase;
  final UpdateUserProfileUseCase _updateUserProfileUseCase;

  /// Loads the persisted user profile for display.
  Future<void> _onProfileRequested(
    UserProfileRequested event,
    Emitter<UserState> emit,
  ) async {
    emit(state.copyWith(loading: true));
    final user = await _fetchUserProfileUseCase.execute();
    emit(state.copyWith(loading: false, user: user));
  }

  /// Sets the user profile to the latest value.
  Future<void> _onProfileUpdated(
    UserProfileUpdated event,
    Emitter<UserState> emit,
  ) async {
    emit(state.copyWith(loading: true));
    final updatedUser = await _updateUserProfileUseCase.execute(event.user);
    emit(state.copyWith(loading: false, user: updatedUser));
  }
}
