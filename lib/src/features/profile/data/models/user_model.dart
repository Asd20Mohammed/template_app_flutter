// Data transfer object for [User] including serialization helpers.
import 'package:template_app/src/features/profile/data/models/role_model.dart';
import 'package:template_app/src/features/profile/domain/entities/user.dart';

/// Represents a persisted user profile record.
class UserModel extends User {
  /// Creates a new [UserModel].
  const UserModel({
    required super.id,
    required super.email,
    required super.displayName,
    required List<RoleModel> super.roles,
    super.avatarUrl,
    super.isGuest = false,
  }) : _roles = roles;

  final List<RoleModel> _roles;

  /// Parses the json map into a [UserModel].
  factory UserModel.fromJson(Map<String, dynamic> json) {
    final rawRoles = json['roles'] as List<dynamic>? ?? [];
    final roles = rawRoles
        .map((dynamic e) => RoleModel.fromJson(e as Map<String, dynamic>))
        .toList();
    return UserModel(
      id: json['id'] as String? ?? '',
      email: json['email'] as String? ?? '',
      displayName: json['displayName'] as String? ?? '',
      avatarUrl: json['avatarUrl'] as String?,
      roles: roles,
      isGuest: json['isGuest'] as bool? ?? false,
    );
  }

  /// Converts the model into a json map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'avatarUrl': avatarUrl,
      'roles': _roles.map((e) => e.toJson()).toList(),
      'isGuest': isGuest,
    };
  }

  /// Creates a guest user template.
  factory UserModel.guest() => const UserModel(
    id: 'guest-0',
    email: 'guest@local.app',
    displayName: 'Guest User',
    roles: [],
    isGuest: true,
  );
}
