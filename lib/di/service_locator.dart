// Configures dependency injection using get_it.
import 'package:get_it/get_it.dart';
import 'package:template_app/app/router/deep_link_handler.dart';
import 'package:template_app/app/router/route_guard.dart';
import 'package:template_app/core/config/app_config.dart';
import 'package:template_app/core/logging/app_logger.dart';
import 'package:template_app/core/localization/localization_manager.dart';
import 'package:template_app/data/data_sources/local/cache_storage.dart';
import 'package:template_app/data/data_sources/local/local_storage.dart';
import 'package:template_app/data/data_sources/local/secure_storage.dart';
import 'package:template_app/data/data_sources/remote/api_client.dart';
import 'package:template_app/data/data_sources/remote/realtime_service.dart';
import 'package:template_app/data/repositories/auth_repository_impl.dart';
import 'package:template_app/data/repositories/feature_repository_impl.dart';
import 'package:template_app/data/repositories/settings_repository_impl.dart';
import 'package:template_app/data/repositories/user_repository_impl.dart';
import 'package:template_app/domain/repositories/auth_repository.dart';
import 'package:template_app/domain/repositories/feature_repository.dart';
import 'package:template_app/domain/repositories/settings_repository.dart';
import 'package:template_app/domain/repositories/user_repository.dart';
import 'package:template_app/domain/usecases/auth_usecases.dart';
import 'package:template_app/domain/usecases/settings_usecases.dart';
import 'package:template_app/domain/usecases/user_usecases.dart';
import 'package:template_app/services/background/background_fetch_service.dart';
import 'package:template_app/services/background/data_sync_service.dart';
import 'package:template_app/services/background/scheduler_service.dart';
import 'package:template_app/services/location/location_service.dart';
import 'package:template_app/services/network/connectivity_service.dart';
import 'package:template_app/services/notifications/in_app_notification_service.dart';
import 'package:template_app/services/notifications/local_notification_service.dart';
import 'package:template_app/services/notifications/push_notification_service.dart';
import 'package:template_app/services/security/biometric_auth.dart';
import 'package:template_app/services/security/data_encryption.dart';
import 'package:template_app/services/security/network_security.dart';
import 'package:template_app/services/session/session_manager.dart';
import 'package:template_app/utils/connectivity_checker.dart';

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
    () => AuthRepositoryImpl(
      apiClient: serviceLocator(),
      secureStorage: serviceLocator(),
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
  serviceLocator.registerLazySingleton(
    () => RouteGuard(sessionManager: serviceLocator()),
  );
  AppLogger.configure(enableDebugLogging: true);

  final storage = serviceLocator<LocalStorage>();
  await storage.init();
}
