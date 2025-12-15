// Configuration for backend selection and settings.
import 'backend_type.dart';

/// Holds configuration for the selected backend.
class BackendConfig {
  /// Creates a new [BackendConfig].
  const BackendConfig({
    required this.type,
    this.baseUrl,
    this.apiKey,
    this.enableOfflineSupport = true,
    this.cacheTimeout = const Duration(minutes: 5),
  });

  /// Creates a Firebase configuration.
  factory BackendConfig.firebase({
    bool enableOfflineSupport = true,
  }) {
    return BackendConfig(
      type: BackendType.firebase,
      enableOfflineSupport: enableOfflineSupport,
    );
  }

  /// Creates a REST API configuration.
  factory BackendConfig.restApi({
    required String baseUrl,
    String? apiKey,
    bool enableOfflineSupport = true,
  }) {
    return BackendConfig(
      type: BackendType.restApi,
      baseUrl: baseUrl,
      apiKey: apiKey,
      enableOfflineSupport: enableOfflineSupport,
    );
  }

  /// Creates an offline-only configuration.
  factory BackendConfig.offline() {
    return const BackendConfig(
      type: BackendType.offline,
      enableOfflineSupport: true,
    );
  }

  /// Creates a Supabase configuration.
  factory BackendConfig.supabase({
    required String baseUrl,
    required String apiKey,
    bool enableOfflineSupport = true,
  }) {
    return BackendConfig(
      type: BackendType.supabase,
      baseUrl: baseUrl,
      apiKey: apiKey,
      enableOfflineSupport: enableOfflineSupport,
    );
  }

  /// The type of backend to use.
  final BackendType type;

  /// Base URL for REST API or Supabase.
  final String? baseUrl;

  /// API key for authenticated backends.
  final String? apiKey;

  /// Whether to enable offline caching and sync.
  final bool enableOfflineSupport;

  /// How long to cache data before refreshing.
  final Duration cacheTimeout;

  /// Returns true if using Firebase backend.
  bool get isFirebase => type == BackendType.firebase;

  /// Returns true if using REST API backend.
  bool get isRestApi => type == BackendType.restApi;

  /// Returns true if using offline-only mode.
  bool get isOffline => type == BackendType.offline;
}
