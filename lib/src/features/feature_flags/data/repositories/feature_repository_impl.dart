// Concrete implementation managing feature flags.
import 'dart:convert';

import 'package:template_app/src/core/data/data_sources/local/local_storage.dart';
import 'package:template_app/src/features/feature_flags/domain/repositories/feature_repository.dart';

/// Persists feature flags as a single json blob.
class FeatureRepositoryImpl implements FeatureRepository {
  /// Creates a new [FeatureRepositoryImpl].
  FeatureRepositoryImpl(this._localStorage);

  final LocalStorage _localStorage;

  static const _flagsKey = 'feature_flags';

  @override
  Future<Map<String, bool>> loadFlags() async {
    final stored = await _localStorage.readString(_flagsKey);
    if (stored == null) {
      return {};
    }
    final map = jsonDecode(stored) as Map<String, dynamic>;
    return map.map((key, value) => MapEntry(key, value as bool? ?? false));
  }

  @override
  Future<void> updateFlag(String key, bool enabled) async {
    final current = await loadFlags();
    current[key] = enabled;
    final json = jsonEncode(current);
    await _localStorage.writeString(_flagsKey, json);
  }
}
