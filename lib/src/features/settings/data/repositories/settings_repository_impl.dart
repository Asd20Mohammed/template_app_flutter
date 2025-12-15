// Concrete implementation of [SettingsRepository].
import '/src/core/data/data_sources/local/local_storage.dart';
import '/src/features/settings/domain/repositories/settings_repository.dart';

/// Stores settings using shared preferences.
class SettingsRepositoryImpl implements SettingsRepository {
  /// Creates a new [SettingsRepositoryImpl].
  SettingsRepositoryImpl(this._localStorage);

  final LocalStorage _localStorage;

  @override
  Future<bool> readBool(String key, {bool defaultValue = false}) async {
    final value = await _localStorage.readBool(key);
    return value ?? defaultValue;
  }

  @override
  Future<void> writeBool(String key, bool value) {
    return _localStorage.writeBool(key, value);
  }

  @override
  Future<String?> readString(String key) {
    return _localStorage.readString(key);
  }

  @override
  Future<void> writeString(String key, String value) {
    return _localStorage.writeString(key, value);
  }
}
