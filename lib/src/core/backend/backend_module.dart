// Central module for configuring and providing backend dependencies.
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '/src/core/backend/backend_config.dart';
import '/src/core/backend/backend_type.dart';
import '/src/core/backend/data_source.dart';
import '/src/core/backend/firebase/firebase_auth_data_source.dart';
import '/src/core/backend/firebase/firebase_document_data_source.dart';
import '/src/core/backend/firebase/firebase_storage_data_source.dart';
import '/src/core/backend/rest/rest_auth_data_source.dart';
import '/src/core/backend/rest/rest_document_data_source.dart';
import '/src/core/data/data_sources/local/local_storage.dart';
import '/src/core/services/session/session_manager.dart';
import '/src/features/auth/data/repositories/firebase_auth_repository.dart';
import '/src/features/auth/data/repositories/offline_auth_repository.dart';
import '/src/features/auth/domain/repositories/auth_repository.dart';
import '/src/features/drafts/data/data_sources/draft_local_data_source.dart';
import '/src/features/drafts/data/repositories/draft_repository_impl.dart';
import '/src/features/drafts/data/repositories/firebase_draft_repository.dart';
import '/src/features/drafts/domain/repositories/draft_repository.dart';
import '/src/features/profile/data/repositories/firebase_user_repository.dart';
import '/src/features/profile/data/repositories/user_repository_impl.dart';
import '/src/features/profile/domain/repositories/user_repository.dart';
import '/src/features/settings/data/repositories/firebase_settings_repository.dart';
import '/src/features/settings/data/repositories/settings_repository_impl.dart';
import '/src/features/settings/domain/repositories/settings_repository.dart';

/// Configures backend dependencies based on the selected backend type.
class BackendModule {
  /// Creates a new [BackendModule].
  BackendModule({required this.config});

  /// The backend configuration.
  final BackendConfig config;

  /// Registers all backend-related dependencies.
  void registerDependencies(GetIt sl) {
    // Register data sources based on backend type
    _registerDataSources(sl);

    // Register repositories
    _registerRepositories(sl);
  }

  void _registerDataSources(GetIt sl) {
    switch (config.type) {
      case BackendType.firebase:
        _registerFirebaseDataSources(sl);
        break;
      case BackendType.restApi:
        _registerRestApiDataSources(sl);
        break;
      case BackendType.offline:
        // No remote data sources for offline mode
        break;
      case BackendType.graphql:
      case BackendType.supabase:
        // Can be implemented later
        throw UnimplementedError('${config.type} is not yet supported');
    }
  }

  void _registerFirebaseDataSources(GetIt sl) {
    sl.registerLazySingleton<AuthDataSource>(
      () => FirebaseAuthDataSource(),
    );
    sl.registerLazySingleton<DocumentDataSource>(
      () => FirebaseDocumentDataSource(),
    );
    sl.registerLazySingleton<StorageDataSource>(
      () => FirebaseStorageDataSource(),
    );
  }

  void _registerRestApiDataSources(GetIt sl) {
    final dio = Dio(
      BaseOptions(
        baseUrl: config.baseUrl ?? '',
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          if (config.apiKey != null) 'Authorization': 'Bearer ${config.apiKey}',
        },
      ),
    );

    sl.registerLazySingleton<Dio>(() => dio);
    sl.registerLazySingleton<AuthDataSource>(
      () => RestAuthDataSource(dio: dio),
    );
    sl.registerLazySingleton<DocumentDataSource>(
      () => RestDocumentDataSource(dio: dio),
    );
  }

  void _registerRepositories(GetIt sl) {
    switch (config.type) {
      case BackendType.firebase:
        _registerFirebaseRepositories(sl);
        break;
      case BackendType.restApi:
        _registerRestApiRepositories(sl);
        break;
      case BackendType.offline:
        _registerOfflineRepositories(sl);
        break;
      case BackendType.graphql:
      case BackendType.supabase:
        throw UnimplementedError('${config.type} is not yet supported');
    }
  }

  void _registerFirebaseRepositories(GetIt sl) {
    sl.registerLazySingleton<AuthRepository>(
      () => FirebaseAuthRepository(
        authDataSource: sl<AuthDataSource>(),
        documentDataSource: sl<DocumentDataSource>(),
        sessionManager: sl<SessionManager>(),
      ),
    );

    sl.registerLazySingleton<UserRepository>(
      () => FirebaseUserRepository(
        documentDataSource: sl<DocumentDataSource>(),
        sessionManager: sl<SessionManager>(),
      ),
    );

    sl.registerLazySingleton<SettingsRepository>(
      () => FirebaseSettingsRepository(
        documentDataSource: sl<DocumentDataSource>(),
        sessionManager: sl<SessionManager>(),
      ),
    );

    sl.registerLazySingleton<DraftRepository>(
      () => FirebaseDraftRepository(
        documentDataSource: sl<DocumentDataSource>(),
        sessionManager: sl<SessionManager>(),
      ),
    );
  }

  void _registerRestApiRepositories(GetIt sl) {
    // For REST API, we use the same Firebase repositories
    // since they work with the abstract data sources
    sl.registerLazySingleton<AuthRepository>(
      () => FirebaseAuthRepository(
        authDataSource: sl<AuthDataSource>(),
        documentDataSource: sl<DocumentDataSource>(),
        sessionManager: sl<SessionManager>(),
      ),
    );

    sl.registerLazySingleton<UserRepository>(
      () => FirebaseUserRepository(
        documentDataSource: sl<DocumentDataSource>(),
        sessionManager: sl<SessionManager>(),
      ),
    );

    sl.registerLazySingleton<SettingsRepository>(
      () => FirebaseSettingsRepository(
        documentDataSource: sl<DocumentDataSource>(),
        sessionManager: sl<SessionManager>(),
      ),
    );

    sl.registerLazySingleton<DraftRepository>(
      () => FirebaseDraftRepository(
        documentDataSource: sl<DocumentDataSource>(),
        sessionManager: sl<SessionManager>(),
      ),
    );
  }

  void _registerOfflineRepositories(GetIt sl) {
    sl.registerLazySingleton<AuthRepository>(
      () => OfflineAuthRepository(
        localStorage: sl<LocalStorage>(),
        sessionManager: sl<SessionManager>(),
      ),
    );

    sl.registerLazySingleton<UserRepository>(
      () => UserRepositoryImpl(sl<LocalStorage>()),
    );

    sl.registerLazySingleton<SettingsRepository>(
      () => SettingsRepositoryImpl(sl<LocalStorage>()),
    );

    sl.registerLazySingleton<DraftRepository>(
      () => DraftRepositoryImpl(
        DraftLocalDataSource(localStorage: sl<LocalStorage>()),
      ),
    );
  }
}
