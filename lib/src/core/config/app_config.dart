// Provides runtime configuration for various app environments.
class AppConfig {
  /// Creates a new [AppConfig].
  const AppConfig({
    required this.environment,
    required this.apiBaseUrl,
    required this.enableLogging,
  });

  /// Indicates the active configuration target.
  final String environment;

  /// Base url for remote API calls.
  final String apiBaseUrl;

  /// Whether verbose logging is enabled.
  final bool enableLogging;

  /// Creates the default configuration used by the template.
  factory AppConfig.defaultConfig() {
    return const AppConfig(
      environment: 'development',
      apiBaseUrl: 'https://api.your-template.dev',
      enableLogging: true,
    );
  }
}
