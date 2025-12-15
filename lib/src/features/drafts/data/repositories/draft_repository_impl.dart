// Draft repository backed by [DraftLocalDataSource].
import '/src/features/drafts/data/data_sources/draft_local_data_source.dart';
import '/src/features/drafts/domain/entities/draft_entry.dart';
import '/src/features/drafts/domain/repositories/draft_repository.dart';

/// Stores draft entries locally for offline usage.
class DraftRepositoryImpl implements DraftRepository {
  /// Creates a new [DraftRepositoryImpl].
  DraftRepositoryImpl(this._localDataSource);

  final DraftLocalDataSource _localDataSource;

  @override
  Future<List<DraftEntry>> fetchDrafts() async {
    final raw = await _localDataSource.loadDrafts();
    return raw.map(DraftEntry.fromJson).toList();
  }

  @override
  Future<DraftEntry> saveDraft(DraftEntry draft) async {
    final drafts = await fetchDrafts();
    final existingIndex = drafts.indexWhere((entry) => entry.id == draft.id);
    if (existingIndex >= 0) {
      drafts[existingIndex] = draft.copyWith(updatedAt: draft.updatedAt);
    } else {
      drafts.add(draft);
    }
    await _persist(drafts);
    return draft;
  }

  @override
  Future<void> deleteDraft(String id) async {
    final drafts = await fetchDrafts();
    drafts.removeWhere((entry) => entry.id == id);
    await _persist(drafts);
  }

  Future<void> _persist(List<DraftEntry> drafts) async {
    await _localDataSource.saveDrafts(
      drafts.map((entry) => entry.toJson()).toList(),
    );
  }
}
