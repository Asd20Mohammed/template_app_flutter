// Provides an offline-first authentication implementation backed by local storage.
import 'dart:convert';

import 'package:template_app/src/core/data/data_sources/local/local_storage.dart';
import 'package:template_app/src/core/services/session/session_manager.dart';
import 'package:template_app/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:template_app/src/features/profile/data/models/user_model.dart';
import 'package:template_app/src/features/profile/domain/entities/user.dart';

/// Authentication repository that keeps credentials locally for offline usage.
class OfflineAuthRepository implements AuthRepository {
  /// Creates a new [OfflineAuthRepository].
  OfflineAuthRepository({
    required LocalStorage localStorage,
    required SessionManager sessionManager,
  }) : _localStorage = localStorage,
       _sessionManager = sessionManager;

  final LocalStorage _localStorage;
  final SessionManager _sessionManager;

  static const _userKey = 'offline_auth_user';

  @override
  Future<User> login({required String email, required String password}) async {
    final user = UserModel(
      id: 'user-${email.hashCode}',
      email: email,
      displayName: email.split('@').first,
      avatarUrl: null,
      roles: const [],
      isGuest: false,
    );
    await _persistUser(user);
    return user;
  }

  @override
  Future<User> register({required String email, required String password}) {
    return login(email: email, password: password);
  }

  @override
  Future<void> logout() async {
    await _localStorage.delete(_userKey);
    await _sessionManager.endSession();
  }

  @override
  Future<User?> getCurrentUser() async {
    final stored = await _localStorage.readString(_userKey);
    if (stored == null) {
      final guest = UserModel.guest();
      await _persistUser(guest);
      return guest;
    }
    final map = jsonDecode(stored) as Map<String, dynamic>;
    final user = UserModel.fromJson(map);
    await _sessionManager.startSession(user);
    return user;
  }

  Future<void> _persistUser(User user) async {
    final model = UserModel(
      id: user.id,
      email: user.email,
      displayName: user.displayName,
      avatarUrl: user.avatarUrl,
      roles: const [],
      isGuest: user.isGuest,
    );
    await _localStorage.writeString(_userKey, jsonEncode(model.toJson()));
    await _sessionManager.startSession(model);
  }
}
