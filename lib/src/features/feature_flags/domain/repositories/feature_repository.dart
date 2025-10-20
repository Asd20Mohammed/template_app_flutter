// Handles feature flag persistence and hydration.
abstract class FeatureRepository {
  /// Loads all feature flags into memory.
  Future<Map<String, bool>> loadFlags();

  /// Updates a single feature flag value.
  Future<void> updateFlag(String key, bool enabled);
}
