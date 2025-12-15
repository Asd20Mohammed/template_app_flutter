import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/src/app/bloc/blocs.dart';
import '/src/app/di/service_locator.dart';
import '/src/core/data/data_sources/local/local_storage.dart';
import '/src/core/services/network/connectivity_service.dart';
import '/src/core/services/notifications/push_notification_service.dart';
import '/src/features/auth/domain/usecases/auth_usecases.dart';
import '/src/features/feature_flags/domain/repositories/feature_repository.dart';
import '/src/features/notifications/presentation/bloc/notification_registration_requested.dart';
import '/src/features/profile/domain/usecases/user_usecases.dart';
import '/src/features/settings/domain/usecases/settings_usecases.dart';
import '/src/features/drafts/presentation/bloc/draft_bloc.dart';

/// State management setup for the application.
/// This class provides all the BlocProviders needed for the app.
class StateManagement extends StatelessWidget {
  /// Creates a new [StateManagement] wrapper.
  const StateManagement({required this.child, super.key});

  /// The child widget to wrap with providers.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AppBloc>(
          create: (_) =>
              AppBloc(localStorage: serviceLocator<LocalStorage>())
                ..add(const AppStarted()),
        ),
        BlocProvider<AuthBloc>(
          create: (_) => AuthBloc(
            loginUseCase: serviceLocator<LoginUseCase>(),
            registerUseCase: serviceLocator<RegisterUseCase>(),
            logoutUseCase: serviceLocator<LogoutUseCase>(),
            getCurrentUserUseCase: serviceLocator<GetCurrentUserUseCase>(),
          )..add(const AuthStatusCheckRequested()),
        ),
        BlocProvider<UserBloc>(
          create: (_) => UserBloc(
            fetchUserProfileUseCase: serviceLocator<FetchUserProfileUseCase>(),
            updateUserProfileUseCase:
                serviceLocator<UpdateUserProfileUseCase>(),
          )..add(const UserProfileRequested()),
        ),
        BlocProvider<SettingsBloc>(
          create: (_) => SettingsBloc(
            readBoolSettingUseCase: serviceLocator<ReadBoolSettingUseCase>(),
            writeBoolSettingUseCase: serviceLocator<WriteBoolSettingUseCase>(),
            readStringSettingUseCase:
                serviceLocator<ReadStringSettingUseCase>(),
            writeStringSettingUseCase:
                serviceLocator<WriteStringSettingUseCase>(),
          )..add(const SettingsInitialized()),
        ),
        BlocProvider<FeatureBloc>(
          create: (_) => FeatureBloc(
            featureRepository: serviceLocator<FeatureRepository>(),
          )..add(const FeatureFlagsRequested()),
        ),
        BlocProvider<NetworkBloc>(
          create: (_) => NetworkBloc(
            connectivity: serviceLocator<ConnectivityService>().connectivity,
          )..add(const NetworkCheckRequested()),
        ),
        BlocProvider<NotificationBloc>(
          create: (_) => NotificationBloc(
            pushNotificationService: serviceLocator<PushNotificationService>(),
          )..add(const NotificationRegistrationRequested()),
        ),
        BlocProvider<DraftBloc>(
          create: (_) =>
              DraftBloc(serviceLocator())..add(const DraftLoadRequested()),
        ),
        BlocProvider<ErrorBloc>(create: (_) => ErrorBloc()),
        BlocProvider<TemplateFormBloc>(create: (_) => TemplateFormBloc()),
      ],
      child: child,
    );
  }
}
