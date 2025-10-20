// Defines a single permission assigned to a role or user.
import 'package:equatable/equatable.dart';

/// Immutable representation of an authorization permission.
class Permission extends Equatable {
  /// Creates a new [Permission].
  const Permission({required this.key, required this.description});

  /// Unique key used for authorization checks.
  final String key;

  /// Human readable description of the permission.
  final String description;

  @override
  List<Object?> get props => [key, description];
}
