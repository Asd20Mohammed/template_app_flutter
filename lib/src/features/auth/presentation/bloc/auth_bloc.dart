// Manages authentication flows such as login and registration.
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:template_app/src/features/auth/domain/usecases/auth_usecases.dart';
import 'package:template_app/src/features/profile/domain/entities/user.dart';

/// Represents the authentication status transitions.
enum AuthStatus { unknown, authenticated, unauthenticated, loading, failure }

/// Base class for authentication events.
abstract class AuthEvent extends Equatable {
  /// Creates a new auth event.
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Requests a sign in attempt with the provided credentials.
class AuthLoginRequested extends AuthEvent {
  /// Creates an [AuthLoginRequested] event with [email] and [password].
  const AuthLoginRequested({required this.email, required this.password});

  /// The user email credential.
  final String email;

  /// The user password credential.
  final String password;

  @override
  List<Object?> get props => [email, password];
}

/// Requests a new user registration.
class AuthRegisterRequested extends AuthEvent {
  /// Creates an [AuthRegisterRequested] event with [email] and [password].
  const AuthRegisterRequested({required this.email, required this.password});

  /// The registration email.
  final String email;

  /// The registration password.
  final String password;

  @override
  List<Object?> get props => [email, password];
}

/// Requests the current user to be signed out.
class AuthLogoutRequested extends AuthEvent {
  /// Creates an [AuthLogoutRequested] event.
  const AuthLogoutRequested();
}

/// Requests the bloc to inspect the current session state.
class AuthStatusCheckRequested extends AuthEvent {
  /// Creates a new [AuthStatusCheckRequested] event.
  const AuthStatusCheckRequested();
}

/// Represents the immutable authentication state.
class AuthState extends Equatable {
  /// Creates a new [AuthState].
  const AuthState({required this.status, this.user, this.errorMessage});

  /// The overarching authentication status.
  final AuthStatus status;

  /// The authenticated user data if available.
  final User? user;

  /// The last error message if the status is [AuthStatus.failure].
  final String? errorMessage;

  /// Creates an initial unknown authentication state.
  factory AuthState.initial() => const AuthState(status: AuthStatus.unknown);

  /// Returns a copy with optional overrides.
  AuthState copyWith({
    AuthStatus? status,
    User? user,
    String? errorMessage,
    bool clearUser = false,
    bool clearError = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: clearUser ? null : (user ?? this.user),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [status, user, errorMessage];
}

/// Handles authentication commands and state transitions.
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  /// Creates a new [AuthBloc].
  AuthBloc({
    required LoginUseCase loginUseCase,
    required RegisterUseCase registerUseCase,
    required LogoutUseCase logoutUseCase,
    required GetCurrentUserUseCase getCurrentUserUseCase,
  }) : _loginUseCase = loginUseCase,
       _registerUseCase = registerUseCase,
       _logoutUseCase = logoutUseCase,
       _getCurrentUserUseCase = getCurrentUserUseCase,
       super(AuthState.initial()) {
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthRegisterRequested>(_onRegisterRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<AuthStatusCheckRequested>(_onStatusCheckRequested);
  }

  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final LogoutUseCase _logoutUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;

  /// Handles the login request by invoking the use case.
  Future<void> _onLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading, clearError: true));
    try {
      final user = await _loginUseCase.execute(event.email, event.password);
      _emitAuthenticated(user, emit);
    } catch (error) {
      emit(
        state.copyWith(
          status: AuthStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  /// Simulates a registration flow for the template.
  Future<void> _onRegisterRequested(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading, clearError: true));
    try {
      final user = await _registerUseCase.execute(event.email, event.password);
      _emitAuthenticated(user, emit);
    } catch (error) {
      emit(
        state.copyWith(
          status: AuthStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  /// Clears the authentication state to represent a signed-out user.
  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _logoutUseCase.execute();
    final user = await _getCurrentUserUseCase.execute();
    if (user != null) {
      _emitAuthenticated(user, emit);
    } else {
      emit(
        state.copyWith(
          status: AuthStatus.unauthenticated,
          clearUser: true,
          clearError: true,
        ),
      );
    }
  }

  /// Checks the current session and updates the state accordingly.
  Future<void> _onStatusCheckRequested(
    AuthStatusCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    final user = await _getCurrentUserUseCase.execute();
    if (user != null) {
      _emitAuthenticated(user, emit);
    } else {
      emit(
        state.copyWith(
          status: AuthStatus.unauthenticated,
          clearUser: true,
          clearError: true,
        ),
      );
    }
  }

  void _emitAuthenticated(User user, Emitter<AuthState> emit) {
    emit(
      state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
        clearError: true,
      ),
    );
  }
}
