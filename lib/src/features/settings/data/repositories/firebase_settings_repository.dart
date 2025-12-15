// Firebase implementation of SettingsRepository using the abstraction layer.
import '/src/core/backend/data_source.dart';
import '/src/core/services/session/session_manager.dart';
import '/src/features/settings/domain/repositories/settings_repository.dart';

/// Firebase-backed settings repository.
/// Settings are stored per-user in Firestore.
class FirebaseSettingsRepository implements SettingsRepository {
  /// Creates a new [FirebaseSettingsRepository].
  FirebaseSettingsRepository({
    required DocumentDataSource documentDataSource,
    required SessionManager sessionManager,
  })  : _documentDataSource = documentDataSource,
        _sessionManager = sessionManager;

  final DocumentDataSource _documentDataSource;
  final SessionManager _sessionManager;

  String get _settingsPath {
    final userId = _sessionManager.currentUser?.id ?? 'anonymous';
    return 'users/$userId/settings/preferences';
  }

  @override
  Future<bool> readBool(String key, {bool defaultValue = false}) async {
    final result = await _documentDataSource.getDocument(_settingsPath);
    if (result.isFailure || result.data == null) {
      return defaultValue;
    }
    return result.data![key] as bool? ?? defaultValue;
  }

  @override
  Future<void> writeBool(String key, bool value) async {
    await _documentDataSource.setDocument(
      _settingsPath,
      {key: value},
      merge: true,
    );
  }

  @override
  Future<String?> readString(String key) async {
    final result = await _documentDataSource.getDocument(_settingsPath);
    if (result.isFailure || result.data == null) {
      return null;
    }
    return result.data![key] as String?;
  }

  @override
  Future<void> writeString(String key, String value) async {
    await _documentDataSource.setDocument(
      _settingsPath,
      {key: value},
      merge: true,
    );
  }
}
