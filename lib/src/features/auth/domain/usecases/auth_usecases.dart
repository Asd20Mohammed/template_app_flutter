// Encapsulates authentication business logic.
import 'package:template_app/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:template_app/src/features/profile/domain/entities/user.dart';

/// Use case responsible for logging in a user.
class LoginUseCase {
  /// Creates a new [LoginUseCase].
  const LoginUseCase(this._repository);

  final AuthRepository _repository;

  /// Executes the login workflow and returns the authenticated user.
  Future<User> execute(String email, String password) {
    return _repository.login(email: email, password: password);
  }
}

/// Use case responsible for registering a new user.
class RegisterUseCase {
  /// Creates a new [RegisterUseCase].
  const RegisterUseCase(this._repository);

  final AuthRepository _repository;

  /// Executes the registration flow and returns the created user profile.
  Future<User> execute(String email, String password) {
    return _repository.register(email: email, password: password);
  }
}

/// Use case responsible for logging the user out.
class LogoutUseCase {
  /// Creates a new [LogoutUseCase].
  const LogoutUseCase(this._repository);

  final AuthRepository _repository;

  /// Executes the logout flow and clears credentials.
  Future<void> execute() => _repository.logout();
}

/// Use case responsible for retrieving the current session.
class GetCurrentUserUseCase {
  /// Creates a new [GetCurrentUserUseCase].
  const GetCurrentUserUseCase(this._repository);

  final AuthRepository _repository;

  /// Returns the currently authenticated user when available.
  Future<User?> execute() => _repository.getCurrentUser();
}
