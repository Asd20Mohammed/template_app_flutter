// Concrete implementation for user profile persistence.
import 'dart:convert';

import '/src/core/data/data_sources/local/local_storage.dart';
import '/src/features/profile/data/models/permission_model.dart';
import '/src/features/profile/data/models/role_model.dart';
import '/src/features/profile/data/models/user_model.dart';
import '/src/features/profile/domain/entities/role.dart';
import '/src/features/profile/domain/entities/user.dart';
import '/src/features/profile/domain/repositories/user_repository.dart';

/// Persists user profiles using local storage for the template.
class UserRepositoryImpl implements UserRepository {
  /// Creates a new [UserRepositoryImpl].
  UserRepositoryImpl(this._localStorage);

  final LocalStorage _localStorage;

  static const _userKey = 'user_profile';

  @override
  Future<User?> fetchProfile() async {
    final jsonString = await _localStorage.readString(_userKey);
    if (jsonString == null) {
      return null;
    }
    final map = jsonDecode(jsonString) as Map<String, dynamic>;
    return UserModel.fromJson(map);
  }

  @override
  Future<User> updateProfile(User user) async {
    final model = UserModel(
      id: user.id,
      email: user.email,
      displayName: user.displayName,
      avatarUrl: user.avatarUrl,
      roles: user.roles.map(_mapRole).toList(),
      isGuest: user.isGuest,
    );
    final jsonString = jsonEncode(model.toJson());
    await _localStorage.writeString(_userKey, jsonString);
    return model;
  }

  RoleModel _mapRole(Role role) {
    return RoleModel(
      id: role.id,
      name: role.name,
      permissions: role.permissions
          .map(
            (permission) => PermissionModel(
              key: permission.key,
              description: permission.description,
            ),
          )
          .toList(),
    );
  }
}
