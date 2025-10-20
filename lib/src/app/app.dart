// Root widget that composes the dependency graph and renders the app.
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:template_app/src/app/bloc/blocs.dart';
import 'package:template_app/src/app/di/service_locator.dart';
import 'package:template_app/src/app/router/app_router.dart';
import 'package:template_app/src/core/data/data_sources/local/local_storage.dart';
import 'package:template_app/src/core/localization/localization_manager.dart';
import 'package:template_app/src/core/services/network/connectivity_service.dart';
import 'package:template_app/src/core/services/notifications/push_notification_service.dart';
import 'package:template_app/src/core/theme/app_theme.dart';
import 'package:template_app/src/features/auth/domain/usecases/auth_usecases.dart';
import 'package:template_app/src/features/feature_flags/domain/repositories/feature_repository.dart';
import 'package:template_app/src/features/profile/domain/usecases/user_usecases.dart';
import 'package:template_app/src/features/settings/domain/usecases/settings_usecases.dart';

/// MaterialApp wrapper configuring routing, themes, and localization.
class App extends StatelessWidget {
  /// Creates a new [App].
  App({super.key})
    : _router = AppRouter(
        routeGuard: serviceLocator(),
        deepLinkHandler: serviceLocator(),
      ),
      _localizationManager = serviceLocator(),
      _routeObserver = RouteObserver<ModalRoute<void>>();

  final AppRouter _router;
  final LocalizationManager _localizationManager;
  final RouteObserver<ModalRoute<void>> _routeObserver;

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
        BlocProvider<ErrorBloc>(create: (_) => ErrorBloc()),
        BlocProvider<TemplateFormBloc>(create: (_) => TemplateFormBloc()),
      ],
      child: BlocListener<SettingsBloc, SettingsState>(
        listenWhen: (previous, current) =>
            previous.localeCode != current.localeCode,
        listener: (context, state) {
          _localizationManager.updateLocale(Locale(state.localeCode));
        },
        child: AnimatedBuilder(
          animation: _localizationManager,
          builder: (context, _) {
            return BlocBuilder<AppBloc, AppState>(
              builder: (context, appState) {
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: _localizationManager.translate('app_title'),
                  theme: AppTheme.light(),
                  darkTheme: AppTheme.dark(),
                  themeMode: appState.themeMode,
                  locale: _localizationManager.locale,
                  supportedLocales: const [Locale('en'), Locale('ar')],
                  localizationsDelegates: const [
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  onGenerateRoute: _router.onGenerateRoute,
                  navigatorObservers: [_routeObserver],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
