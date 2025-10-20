// Abstraction over settings storage and retrieval.
abstract class SettingsRepository {
  /// Reads a boolean setting from persistence.
  Future<bool> readBool(String key, {bool defaultValue = false});

  /// Persists a boolean setting for later retrieval.
  Future<void> writeBool(String key, bool value);

  /// Reads a string setting from persistence.
  Future<String?> readString(String key);

  /// Persists a string setting into storage.
  Future<void> writeString(String key, String value);
}
