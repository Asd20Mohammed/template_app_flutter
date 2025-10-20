// Describes a role that aggregates multiple permissions.
import 'package:equatable/equatable.dart';
import 'package:template_app/domain/entities/permission.dart';

/// Immutable role entity that groups permissions.
class Role extends Equatable {
  /// Creates a new [Role].
  const Role({required this.id, required this.name, required this.permissions});

  /// Unique identifier for the role.
  final String id;

  /// Human readable role name.
  final String name;

  /// Collection of permissions granted by this role.
  final List<Permission> permissions;

  @override
  List<Object?> get props => [id, name, permissions];
}
