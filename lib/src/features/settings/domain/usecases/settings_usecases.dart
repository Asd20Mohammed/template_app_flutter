// Wraps settings mutations into declarative use cases.
import '/src/features/settings/domain/repositories/settings_repository.dart';

/// Reads a boolean flag from settings.
class ReadBoolSettingUseCase {
  /// Creates a new [ReadBoolSettingUseCase].
  const ReadBoolSettingUseCase(this._repository);

  final SettingsRepository _repository;

  /// Reads the value stored under [key].
  Future<bool> execute(String key, {bool defaultValue = false}) {
    return _repository.readBool(key, defaultValue: defaultValue);
  }
}

/// Persists a bool flag.
class WriteBoolSettingUseCase {
  /// Creates a new [WriteBoolSettingUseCase].
  const WriteBoolSettingUseCase(this._repository);

  final SettingsRepository _repository;

  /// Writes [value] to the provided [key].
  Future<void> execute(String key, bool value) {
    return _repository.writeBool(key, value);
  }
}

/// Reads a string setting.
class ReadStringSettingUseCase {
  /// Creates a new [ReadStringSettingUseCase].
  const ReadStringSettingUseCase(this._repository);

  final SettingsRepository _repository;

  /// Reads the value stored under [key].
  Future<String?> execute(String key) => _repository.readString(key);
}

/// Persists a string setting.
class WriteStringSettingUseCase {
  /// Creates a new [WriteStringSettingUseCase].
  const WriteStringSettingUseCase(this._repository);

  final SettingsRepository _repository;

  /// Writes [value] under the [key].
  Future<void> execute(String key, String value) {
    return _repository.writeString(key, value);
  }
}
