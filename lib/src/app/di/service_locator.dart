// Configures dependency injection using get_it.
import 'package:get_it/get_it.dart';

import '/src/app/router/deep_link_handler.dart';
import '/src/core/backend/backend_config.dart';
import '/src/core/backend/backend_module.dart';
import '/src/core/config/app_config.dart';
import '/src/core/data/data_sources/local/cache_storage.dart';
import '/src/core/data/data_sources/local/local_storage.dart';
import '/src/core/data/data_sources/local/secure_storage.dart';
import '/src/core/data/data_sources/remote/api_client.dart';
import '/src/core/data/data_sources/remote/realtime_service.dart';
import '/src/core/logging/app_logger.dart';
import '/src/core/localization/localization_manager.dart';
import '/src/core/services/background/background_fetch_service.dart';
import '/src/core/services/background/data_sync_service.dart';
import '/src/core/services/background/scheduler_service.dart';
import '/src/core/services/location/location_service.dart';
import '/src/core/services/network/connectivity_service.dart';
import '/src/core/services/notifications/in_app_notification_service.dart';
import '/src/core/services/notifications/local_notification_service.dart';
import '/src/core/services/notifications/push_notification_service.dart';
import '/src/core/services/security/biometric_auth.dart';
import '/src/core/services/security/data_encryption.dart';
import '/src/core/services/security/network_security.dart';
import '/src/core/services/session/session_manager.dart';
import '/src/core/utils/connectivity_checker.dart';
import '/src/features/auth/domain/usecases/auth_usecases.dart';
import '/src/features/feature_flags/data/repositories/feature_repository_impl.dart';
import '/src/features/feature_flags/domain/repositories/feature_repository.dart';
import '/src/features/profile/domain/usecases/user_usecases.dart';
import '/src/features/settings/domain/usecases/settings_usecases.dart';

/// Global access point to the dependency container.
final GetIt serviceLocator = GetIt.instance;

/// Current backend configuration.
/// Change this to switch between backends.
BackendConfig _backendConfig = BackendConfig.offline();

/// Gets the current backend configuration.
BackendConfig get currentBackendConfig => _backendConfig;

/// Configures and wires up all dependencies for the template.
///
/// [backendConfig] - Optional backend configuration. Defaults to offline mode.
///
/// ## Usage Examples:
///
/// ### Firebase Backend:
/// ```dart
/// await configureDependencies(
///   backendConfig: BackendConfig.firebase(),
/// );
/// ```
///
/// ### REST API Backend:
/// ```dart
/// await configureDependencies(
///   backendConfig: BackendConfig.restApi(
///     baseUrl: 'https://api.yourserver.com',
///     apiKey: 'your-api-key',
///   ),
/// );
/// ```
///
/// ### Offline Mode (default):
/// ```dart
/// await configureDependencies(
///   backendConfig: BackendConfig.offline(),
/// );
/// ```
Future<void> configureDependencies({
  BackendConfig? backendConfig,
}) async {
  _backendConfig = backendConfig ?? BackendConfig.offline();

  // Core services (independent of backend)
  _registerCoreServices();

  // Backend-specific dependencies (repositories, data sources)
  final backendModule = BackendModule(config: _backendConfig);
  backendModule.registerDependencies(serviceLocator);

  // Use cases (depend on repositories)
  _registerUseCases();

  // Additional services
  _registerAdditionalServices();

  // Initialize storage
  final storage = serviceLocator<LocalStorage>();
  await storage.init();

  AppLogger.configure(enableDebugLogging: true);
}

/// Registers core services that are independent of backend type.
void _registerCoreServices() {
  serviceLocator.registerLazySingleton(AppConfig.defaultConfig);
  serviceLocator.registerLazySingleton(SessionManager.new);
  serviceLocator.registerLazySingleton(ApiClient.new);
  serviceLocator.registerLazySingleton(SecureStorage.new);
  serviceLocator.registerLazySingleton(LocalStorage.new);
  serviceLocator.registerLazySingleton(CacheStorage.new);
  serviceLocator.registerLazySingleton(RealTimeService.new);
  serviceLocator.registerLazySingleton(() => DataEncryption('template-secret'));
  serviceLocator.registerLazySingleton(BiometricAuth.new);
  serviceLocator.registerLazySingleton(NetworkSecurity.new);
  serviceLocator.registerLazySingleton(ConnectivityService.new);
  serviceLocator.registerLazySingleton(
    () => ConnectivityChecker(connectivity: serviceLocator()),
  );
  serviceLocator.registerLazySingleton(LocalizationManager.new);
}

/// Registers use cases that depend on repositories.
void _registerUseCases() {
  // Auth use cases
  serviceLocator.registerLazySingleton(() => LoginUseCase(serviceLocator()));
  serviceLocator.registerLazySingleton(() => RegisterUseCase(serviceLocator()));
  serviceLocator.registerLazySingleton(() => LogoutUseCase(serviceLocator()));
  serviceLocator.registerLazySingleton(
    () => GetCurrentUserUseCase(serviceLocator()),
  );

  // User use cases
  serviceLocator.registerLazySingleton(
    () => FetchUserProfileUseCase(serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => UpdateUserProfileUseCase(serviceLocator()),
  );

  // Settings use cases
  serviceLocator.registerLazySingleton(
    () => ReadBoolSettingUseCase(serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => WriteBoolSettingUseCase(serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => ReadStringSettingUseCase(serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => WriteStringSettingUseCase(serviceLocator()),
  );
}

/// Registers additional services.
void _registerAdditionalServices() {
  serviceLocator.registerLazySingleton(PushNotificationService.new);
  serviceLocator.registerLazySingleton(LocalNotificationService.new);
  serviceLocator.registerLazySingleton(InAppNotificationService.new);
  serviceLocator.registerLazySingleton(SchedulerService.new);
  serviceLocator.registerLazySingleton(
    () => DataSyncService(serviceLocator<ApiClient>()),
  );
  serviceLocator.registerLazySingleton(BackgroundFetchService.new);
  serviceLocator.registerLazySingleton(LocationService.new);

  // Feature flags (always local for now)
  serviceLocator.registerLazySingleton(
    () => FeatureRepositoryImpl(serviceLocator()),
  );
  serviceLocator.registerLazySingleton<FeatureRepository>(
    () => serviceLocator<FeatureRepositoryImpl>(),
  );

  serviceLocator.registerLazySingleton(DeepLinkHandler.new);
}

/// Resets all dependencies (useful for testing or switching backends).
Future<void> resetDependencies() async {
  await serviceLocator.reset();
}

/// Switches to a new backend configuration.
///
/// This will reset all dependencies and reconfigure with the new backend.
Future<void> switchBackend(BackendConfig newConfig) async {
  await resetDependencies();
  await configureDependencies(backendConfig: newConfig);
}
