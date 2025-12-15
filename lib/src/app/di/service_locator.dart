// Configures dependency injection using get_it.
import 'package:get_it/get_it.dart';
import '/src/app/router/deep_link_handler.dart';
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
import '/src/features/auth/data/repositories/offline_auth_repository.dart';
import '/src/features/auth/domain/repositories/auth_repository.dart';
import '/src/features/auth/domain/usecases/auth_usecases.dart';
import '/src/features/feature_flags/data/repositories/feature_repository_impl.dart';
import '/src/features/feature_flags/domain/repositories/feature_repository.dart';
import '/src/features/profile/data/repositories/user_repository_impl.dart';
import '/src/features/profile/domain/repositories/user_repository.dart';
import '/src/features/profile/domain/usecases/user_usecases.dart';
import '/src/features/drafts/data/data_sources/draft_local_data_source.dart';
import '/src/features/drafts/data/repositories/draft_repository_impl.dart';
import '/src/features/drafts/domain/repositories/draft_repository.dart';
import '/src/features/settings/data/repositories/settings_repository_impl.dart';
import '/src/features/settings/domain/repositories/settings_repository.dart';
import '/src/features/settings/domain/usecases/settings_usecases.dart';

/// Global access point to the dependency container.
final GetIt serviceLocator = GetIt.instance;

/// Configures and wires up all dependencies for the template.
Future<void> configureDependencies() async {
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
  serviceLocator.registerLazySingleton(PushNotificationService.new);
  serviceLocator.registerLazySingleton(LocalNotificationService.new);
  serviceLocator.registerLazySingleton(InAppNotificationService.new);
  serviceLocator.registerLazySingleton(SchedulerService.new);
  serviceLocator.registerLazySingleton(
    () => DataSyncService(serviceLocator<ApiClient>()),
  );
  serviceLocator.registerLazySingleton(BackgroundFetchService.new);
  serviceLocator.registerLazySingleton(LocationService.new);
  serviceLocator.registerLazySingleton(ConnectivityService.new);
  serviceLocator.registerLazySingleton(
    () => ConnectivityChecker(connectivity: serviceLocator()),
  );
  serviceLocator.registerLazySingleton(LocalizationManager.new);
  serviceLocator.registerLazySingleton<AuthRepository>(
    () => OfflineAuthRepository(
      localStorage: serviceLocator(),
      sessionManager: serviceLocator(),
    ),
  );
  serviceLocator.registerLazySingleton(
    () => SettingsRepositoryImpl(serviceLocator()),
  );
  serviceLocator.registerLazySingleton<SettingsRepository>(
    () => serviceLocator<SettingsRepositoryImpl>(),
  );
  serviceLocator.registerLazySingleton(
    () => FeatureRepositoryImpl(serviceLocator()),
  );
  serviceLocator.registerLazySingleton<FeatureRepository>(
    () => serviceLocator<FeatureRepositoryImpl>(),
  );
  serviceLocator.registerLazySingleton(
    () => UserRepositoryImpl(serviceLocator()),
  );
  serviceLocator.registerLazySingleton<UserRepository>(
    () => serviceLocator<UserRepositoryImpl>(),
  );
  serviceLocator.registerLazySingleton(
    () => DraftLocalDataSource(localStorage: serviceLocator()),
  );
  serviceLocator.registerLazySingleton<DraftRepository>(
    () => DraftRepositoryImpl(serviceLocator()),
  );
  serviceLocator.registerLazySingleton(() => LoginUseCase(serviceLocator()));
  serviceLocator.registerLazySingleton(() => RegisterUseCase(serviceLocator()));
  serviceLocator.registerLazySingleton(() => LogoutUseCase(serviceLocator()));
  serviceLocator.registerLazySingleton(
    () => GetCurrentUserUseCase(serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => FetchUserProfileUseCase(serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => UpdateUserProfileUseCase(serviceLocator()),
  );
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
  serviceLocator.registerLazySingleton(DeepLinkHandler.new);
  AppLogger.configure(enableDebugLogging: true);

  final storage = serviceLocator<LocalStorage>();
  await storage.init();
}
