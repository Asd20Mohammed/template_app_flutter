// Represents the core user domain entity.
import 'package:equatable/equatable.dart';
import 'package:template_app/src/features/profile/domain/entities/role.dart';

/// Immutable user object utilised across the app.
class User extends Equatable {
  /// Creates a new [User].
  const User({
    required this.id,
    required this.email,
    required this.displayName,
    required this.roles,
    this.avatarUrl,
  });

  /// Unique user identifier.
  final String id;

  /// Email address used for authentication.
  final String email;

  /// Friendly display name.
  final String displayName;

  /// Optional avatar image url.
  final String? avatarUrl;

  /// Roles assigned to the user for authorization decisions.
  final List<Role> roles;

  @override
  List<Object?> get props => [id, email, displayName, avatarUrl, roles];
}
