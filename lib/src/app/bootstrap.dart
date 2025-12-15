// Handles asynchronous initialization before rendering the app.
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/src/app/di/service_locator.dart';
import '/src/core/backend/backend_config.dart';
import '/src/core/logging/app_bloc_observer.dart';

/// Bootstraps the application before running the widget tree.
///
/// [backendConfig] - Optional backend configuration.
///
/// ## Usage Examples:
///
/// ### With Firebase:
/// ```dart
/// void main() {
///   bootstrap(
///     () async => App(),
///     backendConfig: BackendConfig.firebase(),
///   );
/// }
/// ```
///
/// ### With REST API:
/// ```dart
/// void main() {
///   bootstrap(
///     () async => App(),
///     backendConfig: BackendConfig.restApi(
///       baseUrl: 'https://api.yourserver.com',
///     ),
///   );
/// }
/// ```
///
/// ### Offline Mode (default):
/// ```dart
/// void main() {
///   bootstrap(() async => App());
/// }
/// ```
Future<void> bootstrap(
  Future<Widget> Function() builder, {
  BackendConfig? backendConfig,
}) async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = AppBlocObserver();
  await configureDependencies(backendConfig: backendConfig);
  final app = await builder();
  runApp(app);
}
