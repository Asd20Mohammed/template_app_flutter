// Firebase implementation of UserRepository using the abstraction layer.
import '/src/core/backend/data_source.dart';
import '/src/core/services/session/session_manager.dart';
import '/src/features/profile/data/models/user_model.dart';
import '/src/features/profile/domain/entities/user.dart';
import '/src/features/profile/domain/repositories/user_repository.dart';

/// Firebase-backed user repository.
class FirebaseUserRepository implements UserRepository {
  /// Creates a new [FirebaseUserRepository].
  FirebaseUserRepository({
    required DocumentDataSource documentDataSource,
    required SessionManager sessionManager,
  })  : _documentDataSource = documentDataSource,
        _sessionManager = sessionManager;

  final DocumentDataSource _documentDataSource;
  final SessionManager _sessionManager;

  @override
  Future<User?> fetchProfile() async {
    final currentUser = _sessionManager.currentUser;
    if (currentUser == null) {
      return null;
    }

    final result = await _documentDataSource.getDocument(
      'users/${currentUser.id}',
    );

    if (result.isFailure || result.data == null) {
      return currentUser;
    }

    return UserModel.fromJson(result.data!);
  }

  @override
  Future<User> updateProfile(User user) async {
    final data = {
      'id': user.id,
      'email': user.email,
      'displayName': user.displayName,
      'avatarUrl': user.avatarUrl,
      'isGuest': user.isGuest,
      'updatedAt': DateTime.now().toIso8601String(),
    };

    final result = await _documentDataSource.setDocument(
      'users/${user.id}',
      data,
      merge: true,
    );

    if (result.isFailure) {
      throw UserRepositoryException(result.error ?? 'Failed to update profile');
    }

    final updatedUser = UserModel(
      id: user.id,
      email: user.email,
      displayName: user.displayName,
      avatarUrl: user.avatarUrl,
      roles: const [],
      isGuest: user.isGuest,
    );

    await _sessionManager.startSession(updatedUser);
    return updatedUser;
  }
}

/// Exception thrown when user repository operations fail.
class UserRepositoryException implements Exception {
  /// Creates a new [UserRepositoryException].
  const UserRepositoryException(this.message);

  /// The error message.
  final String message;

  @override
  String toString() => 'UserRepositoryException: $message';
}
