// Provides user domain operations as injectable use cases.
import 'package:template_app/src/features/profile/domain/entities/user.dart';
import 'package:template_app/src/features/profile/domain/repositories/user_repository.dart';

/// Returns the active user profile.
class FetchUserProfileUseCase {
  /// Creates a new [FetchUserProfileUseCase].
  const FetchUserProfileUseCase(this._repository);

  final UserRepository _repository;

  /// Executes the read operation.
  Future<User?> execute() => _repository.fetchProfile();
}

/// Persists user profile updates.
class UpdateUserProfileUseCase {
  /// Creates a new [UpdateUserProfileUseCase].
  const UpdateUserProfileUseCase(this._repository);

  final UserRepository _repository;

  /// Executes the update operation for the provided [user].
  Future<User> execute(User user) => _repository.updateProfile(user);
}
