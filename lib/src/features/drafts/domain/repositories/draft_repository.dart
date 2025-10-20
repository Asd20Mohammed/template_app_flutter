// Contract describing draft storage operations.
import 'package:template_app/src/features/drafts/domain/entities/draft_entry.dart';

/// Repository responsible for managing offline draft entries.
abstract class DraftRepository {
  /// Returns all stored drafts.
  Future<List<DraftEntry>> fetchDrafts();

  /// Persists a draft and returns the saved record.
  Future<DraftEntry> saveDraft(DraftEntry draft);

  /// Deletes a draft by its [id].
  Future<void> deleteDraft(String id);
}
