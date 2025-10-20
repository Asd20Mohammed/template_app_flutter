// Data transfer object for [Role].
import 'package:template_app/data/models/permission_model.dart';
import 'package:template_app/domain/entities/role.dart';

/// Converts [Role] domain objects to and from json.
class RoleModel extends Role {
  /// Creates a new [RoleModel].
  const RoleModel({
    required super.id,
    required super.name,
    required List<PermissionModel> super.permissions,
  }) : _permissions = permissions;

  final List<PermissionModel> _permissions;

  /// Parses a [RoleModel] from json.
  factory RoleModel.fromJson(Map<String, dynamic> json) {
    final rawPermissions = json['permissions'] as List<dynamic>? ?? [];
    final permissions = rawPermissions
        .map((dynamic e) => PermissionModel.fromJson(e as Map<String, dynamic>))
        .toList();
    return RoleModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      permissions: permissions,
    );
  }

  /// Converts the model to json.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'permissions': _permissions.map((e) => e.toJson()).toList(),
    };
  }
}
