// Firebase implementation of AuthRepository using the abstraction layer.
import '/src/core/backend/data_source.dart';
import '/src/core/services/session/session_manager.dart';
import '/src/features/auth/domain/repositories/auth_repository.dart';
import '/src/features/profile/data/models/user_model.dart';
import '/src/features/profile/domain/entities/user.dart';

/// Firebase-backed authentication repository.
class FirebaseAuthRepository implements AuthRepository {
  /// Creates a new [FirebaseAuthRepository].
  FirebaseAuthRepository({
    required AuthDataSource authDataSource,
    required DocumentDataSource documentDataSource,
    required SessionManager sessionManager,
  })  : _authDataSource = authDataSource,
        _documentDataSource = documentDataSource,
        _sessionManager = sessionManager;

  final AuthDataSource _authDataSource;
  final DocumentDataSource _documentDataSource;
  final SessionManager _sessionManager;

  @override
  Future<User> login({
    required String email,
    required String password,
  }) async {
    final result = await _authDataSource.signInWithEmail(
      email: email,
      password: password,
    );

    if (result.isFailure) {
      throw AuthException(result.error ?? 'Login failed');
    }

    final authData = result.data!;
    final user = await _fetchOrCreateUserProfile(authData);
    await _sessionManager.startSession(user);
    return user;
  }

  @override
  Future<User> register({
    required String email,
    required String password,
  }) async {
    final result = await _authDataSource.createUserWithEmail(
      email: email,
      password: password,
    );

    if (result.isFailure) {
      throw AuthException(result.error ?? 'Registration failed');
    }

    final authData = result.data!;
    final user = await _createUserProfile(authData);
    await _sessionManager.startSession(user);
    return user;
  }

  @override
  Future<void> logout() async {
    final result = await _authDataSource.signOut();
    if (result.isFailure) {
      throw AuthException(result.error ?? 'Logout failed');
    }
    await _sessionManager.endSession();
  }

  @override
  Future<User?> getCurrentUser() async {
    final result = await _authDataSource.getCurrentUser();

    if (result.isFailure) {
      return null;
    }

    final authData = result.data;
    if (authData == null || authData.isEmpty) {
      return null;
    }

    final user = await _fetchOrCreateUserProfile(authData);
    await _sessionManager.startSession(user);
    return user;
  }

  /// Fetches user profile from Firestore, creates if doesn't exist.
  Future<User> _fetchOrCreateUserProfile(Map<String, dynamic> authData) async {
    final userId = authData['id'] as String;
    final profileResult = await _documentDataSource.getDocument('users/$userId');

    if (profileResult.isSuccess && profileResult.data != null) {
      return UserModel.fromJson(profileResult.data!);
    }

    return _createUserProfile(authData);
  }

  /// Creates a new user profile in Firestore.
  Future<User> _createUserProfile(Map<String, dynamic> authData) async {
    final user = UserModel(
      id: authData['id'] as String,
      email: authData['email'] as String? ?? '',
      displayName: authData['displayName'] as String? ??
          (authData['email'] as String?)?.split('@').first ??
          'User',
      avatarUrl: authData['photoUrl'] as String?,
      roles: const [],
    );

    await _documentDataSource.setDocument(
      'users/${user.id}',
      {
        'id': user.id,
        'email': user.email,
        'displayName': user.displayName,
        'avatarUrl': user.avatarUrl,
        'roles': [],
        'createdAt': DateTime.now().toIso8601String(),
      },
    );

    return user;
  }
}

/// Exception thrown when authentication operations fail.
class AuthException implements Exception {
  /// Creates a new [AuthException].
  const AuthException(this.message);

  /// The error message.
  final String message;

  @override
  String toString() => 'AuthException: $message';
}
