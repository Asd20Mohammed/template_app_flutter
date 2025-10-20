// Handles encrypted key-value persistence for sensitive data.
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Wrapper around [FlutterSecureStorage].
class SecureStorage {
  /// Creates a new [SecureStorage] with platform defaults.
  SecureStorage({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  /// Reads a secure value for the provided [key].
  Future<String?> read(String key) => _storage.read(key: key);

  /// Writes a secure value for the provided [key].
  Future<void> write(String key, String value) =>
      _storage.write(key: key, value: value);

  /// Deletes a value from secure storage.
  Future<void> delete(String key) => _storage.delete(key: key);

  /// Clears all secured values.
  Future<void> clear() => _storage.deleteAll();
}
