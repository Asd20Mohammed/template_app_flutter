import '/src/app/app.dart';
import '/src/app/bootstrap.dart';
// ignore: unused_import
import '/src/core/backend/backend_config.dart';

/// Entry point for the Flutter application.
///
/// ## Backend Configuration:
///
/// To switch between backends, change the [backendConfig] parameter:
///
/// ### Offline Mode (Default - No server required):
/// ```dart
/// void main() {
///   bootstrap(() async => App());
/// }
/// ```
///
/// ### Firebase Backend:
/// ```dart
/// void main() {
///   bootstrap(
///     () async => App(),
///     backendConfig: BackendConfig.firebase(),
///   );
/// }
/// ```
///
/// ### REST API Backend:
/// ```dart
/// void main() {
///   bootstrap(
///     () async => App(),
///     backendConfig: BackendConfig.restApi(
///       baseUrl: 'https://api.yourserver.com',
///       apiKey: 'your-api-key', // optional
///     ),
///   );
/// }
/// ```
void main() {
  // Default: Offline mode (no backend required)
  bootstrap(() async => App());

  // Uncomment below to use Firebase:
  // bootstrap(
  //   () async => App(),
  //   backendConfig: BackendConfig.firebase(),
  // );

  // Uncomment below to use REST API:
  // bootstrap(
  //   () async => App(),
  //   backendConfig: BackendConfig.restApi(
  //     baseUrl: 'https://api.yourserver.com',
  //   ),
  // );
}
