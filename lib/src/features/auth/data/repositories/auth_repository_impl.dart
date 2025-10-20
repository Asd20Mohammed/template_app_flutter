// Concrete authentication repository wiring together data sources.
import 'package:template_app/src/core/data/data_sources/local/secure_storage.dart';
import 'package:template_app/src/core/data/data_sources/remote/api_client.dart';
import 'package:template_app/src/core/services/session/session_manager.dart';
import 'package:template_app/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:template_app/src/features/profile/data/models/user_model.dart';
import 'package:template_app/src/features/profile/domain/entities/user.dart';

/// Implements authentication use cases backed by HTTP APIs.
class AuthRepositoryImpl implements AuthRepository {
  /// Creates a new [AuthRepositoryImpl].
  AuthRepositoryImpl({
    required ApiClient apiClient,
    required SecureStorage secureStorage,
    required SessionManager sessionManager,
  }) : _apiClient = apiClient,
       _secureStorage = secureStorage,
       _sessionManager = sessionManager;

  final ApiClient _apiClient;
  final SecureStorage _secureStorage;
  final SessionManager _sessionManager;

  static const _tokenKey = 'auth_token';

  @override
  Future<User> login({required String email, required String password}) async {
    await _apiClient.post(
      '/login',
      data: {'email': email, 'password': password},
    );
    final user = UserModel(
      id: '1',
      email: 'template@app.dev',
      displayName: 'Template User',
      roles: [],
    );
    await _secureStorage.write(_tokenKey, 'template-token');
    await _sessionManager.startSession(user);
    return user;
  }

  @override
  Future<User> register({
    required String email,
    required String password,
  }) async {
    await _apiClient.post(
      '/register',
      data: {'email': email, 'password': password},
    );
    final user = UserModel(
      id: '2',
      email: 'template@app.dev',
      displayName: 'Template User',
      roles: [],
    );
    await _secureStorage.write(_tokenKey, 'template-token');
    await _sessionManager.startSession(user);
    return user;
  }

  @override
  Future<void> logout() async {
    await _secureStorage.delete(_tokenKey);
    await _sessionManager.endSession();
  }

  @override
  Future<User?> getCurrentUser() async {
    final token = await _secureStorage.read(_tokenKey);
    if (token == null) {
      return null;
    }
    return _sessionManager.currentUser;
  }
}
