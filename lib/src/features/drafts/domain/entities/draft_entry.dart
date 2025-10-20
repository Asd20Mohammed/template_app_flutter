// Represents a locally stored draft record.
import 'package:equatable/equatable.dart';

/// Immutable draft entry used for offline storage.
class DraftEntry extends Equatable {
  /// Creates a new [DraftEntry].
  const DraftEntry({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Unique identifier for the draft.
  final String id;

  /// Title summarising the draft content.
  final String title;

  /// Rich description or body of the draft.
  final String description;

  /// Timestamp when the draft was created.
  final DateTime createdAt;

  /// Timestamp when the draft was last updated.
  final DateTime updatedAt;

  /// Creates a copy with optional overrides.
  DraftEntry copyWith({
    String? title,
    String? description,
    DateTime? updatedAt,
  }) {
    return DraftEntry(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Serialises the draft to JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Parses the draft from JSON.
  factory DraftEntry.fromJson(Map<String, dynamic> json) {
    return DraftEntry(
      id: json['id'] as String,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  @override
  List<Object?> get props => [id, title, description, createdAt, updatedAt];
}
