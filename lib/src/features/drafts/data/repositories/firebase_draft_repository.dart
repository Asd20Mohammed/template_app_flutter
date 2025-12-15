// Firebase implementation of DraftRepository using the abstraction layer.
import '/src/core/backend/data_source.dart';
import '/src/core/services/session/session_manager.dart';
import '/src/features/drafts/domain/entities/draft_entry.dart';
import '/src/features/drafts/domain/repositories/draft_repository.dart';

/// Firebase-backed draft repository.
/// Drafts are stored per-user in Firestore.
class FirebaseDraftRepository implements DraftRepository {
  /// Creates a new [FirebaseDraftRepository].
  FirebaseDraftRepository({
    required DocumentDataSource documentDataSource,
    required SessionManager sessionManager,
  })  : _documentDataSource = documentDataSource,
        _sessionManager = sessionManager;

  final DocumentDataSource _documentDataSource;
  final SessionManager _sessionManager;

  String get _draftsCollection {
    final userId = _sessionManager.currentUser?.id ?? 'anonymous';
    return 'users/$userId/drafts';
  }

  @override
  Future<List<DraftEntry>> fetchDrafts() async {
    final result = await _documentDataSource.getCollection(
      _draftsCollection,
      orderBy: 'updatedAt',
      descending: true,
    );

    if (result.isFailure) {
      return [];
    }

    return result.data?.map((json) => DraftEntry.fromJson(json)).toList() ?? [];
  }

  @override
  Future<DraftEntry> saveDraft(DraftEntry draft) async {
    final data = draft.toJson();

    await _documentDataSource.setDocument(
      '$_draftsCollection/${draft.id}',
      data,
    );

    return draft;
  }

  @override
  Future<void> deleteDraft(String id) async {
    await _documentDataSource.deleteDocument('$_draftsCollection/$id');
  }
}
