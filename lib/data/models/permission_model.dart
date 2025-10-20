// Data transfer object for [Permission].
import 'package:template_app/domain/entities/permission.dart';

/// Implements serialization helpers for [Permission].
class PermissionModel extends Permission {
  /// Creates a new [PermissionModel].
  const PermissionModel({required super.key, required super.description});

  /// Parses a [PermissionModel] from a json map.
  factory PermissionModel.fromJson(Map<String, dynamic> json) {
    return PermissionModel(
      key: json['key'] as String? ?? '',
      description: json['description'] as String? ?? '',
    );
  }

  /// Converts the model to a json map.
  Map<String, dynamic> toJson() {
    return {'key': key, 'description': description};
  }
}
