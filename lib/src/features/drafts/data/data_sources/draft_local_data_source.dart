// Low-level data source persisting drafts using [LocalStorage].
import 'dart:convert';

import '/src/core/data/data_sources/local/local_storage.dart';

/// Handles raw persistence for draft entries.
class DraftLocalDataSource {
  /// Creates a [DraftLocalDataSource].
  DraftLocalDataSource({required LocalStorage localStorage})
    : _localStorage = localStorage;

  final LocalStorage _localStorage;

  static const _draftKey = 'draft_entries';

  /// Loads all stored drafts as json objects.
  Future<List<Map<String, dynamic>>> loadDrafts() async {
    final stored = await _localStorage.readString(_draftKey);
    if (stored == null) {
      return const [];
    }
    final decoded = jsonDecode(stored) as List<dynamic>;
    return decoded
        .map((value) => Map<String, dynamic>.from(value as Map))
        .toList();
  }

  /// Saves the draft json list.
  Future<void> saveDrafts(List<Map<String, dynamic>> drafts) async {
    await _localStorage.writeString(_draftKey, jsonEncode(drafts));
  }

  /// Clears all stored drafts.
  Future<void> clear() async {
    await _localStorage.delete(_draftKey);
  }
}
