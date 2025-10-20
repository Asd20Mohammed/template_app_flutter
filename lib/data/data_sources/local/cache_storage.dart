// Provides an in-memory cache for lightweight data.
class CacheStorage {
  /// Creates a new [CacheStorage].
  CacheStorage();

  final Map<String, Object?> _cache = {};

  /// Reads a value from the cache.
  T? read<T>(String key) {
    final value = _cache[key];
    if (value is T) {
      return value;
    }
    return null;
  }

  /// Writes a value into the cache.
  void write<T>(String key, T value) {
    _cache[key] = value;
  }

  /// Removes a value from the cache.
  void remove(String key) {
    _cache.remove(key);
  }

  /// Clears all cache entries.
  void clear() {
    _cache.clear();
  }
}
