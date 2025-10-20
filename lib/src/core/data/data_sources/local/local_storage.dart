// Provides a simple key-value storage layer using shared preferences.
import 'package:shared_preferences/shared_preferences.dart';

/// Handles interactions with [SharedPreferences].
class LocalStorage {
  /// Creates a new [LocalStorage].
  LocalStorage();

  SharedPreferences? _prefs;

  /// Ensures the storage is ready before use.
  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  /// Reads a string value for the provided [key].
  Future<String?> readString(String key) async {
    await init();
    return _prefs!.getString(key);
  }

  /// Writes a string value for the provided [key].
  Future<void> writeString(String key, String value) async {
    await init();
    await _prefs!.setString(key, value);
  }

  /// Reads a bool flag from preferences.
  Future<bool?> readBool(String key) async {
    await init();
    return _prefs!.getBool(key);
  }

  /// Writes a bool flag into preferences.
  Future<void> writeBool(String key, bool value) async {
    await init();
    await _prefs!.setBool(key, value);
  }

  /// Removes a value for the provided [key].
  Future<void> delete(String key) async {
    await init();
    await _prefs!.remove(key);
  }

  /// Clears all stored keys.
  Future<void> clear() async {
    await init();
    await _prefs!.clear();
  }
}
