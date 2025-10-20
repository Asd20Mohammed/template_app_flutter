// Handles application-level settings such as localization and preferences.
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:template_app/src/core/constants/app_constants.dart';
import 'package:template_app/src/features/settings/domain/usecases/settings_usecases.dart';

/// Represents the supported events for [SettingsBloc].
abstract class SettingsEvent extends Equatable {
  /// Creates a new settings event.
  const SettingsEvent();

  @override
  List<Object?> get props => [];
}

/// Toggles whether push notifications are enabled.
class SettingsNotificationToggled extends SettingsEvent {
  /// Creates the notification toggle event.
  const SettingsNotificationToggled(this.enabled);

  /// Indicates if notifications should be enabled.
  final bool enabled;

  @override
  List<Object?> get props => [enabled];
}

/// Updates the preferred locale for the application.
class SettingsLocaleChanged extends SettingsEvent {
  /// Creates the locale change event.
  const SettingsLocaleChanged(this.localeCode);

  /// The locale code requested by the user.
  final String localeCode;

  @override
  List<Object?> get props => [localeCode];
}

/// Loads persisted settings from storage.
class SettingsInitialized extends SettingsEvent {
  /// Creates an initialization event.
  const SettingsInitialized();
}

/// Represents the current settings state.
class SettingsState extends Equatable {
  /// Creates a new [SettingsState].
  const SettingsState({
    required this.notificationsEnabled,
    required this.localeCode,
  });

  /// Whether push notifications are enabled.
  final bool notificationsEnabled;

  /// The active locale code.
  final String localeCode;

  /// The initial settings state.
  factory SettingsState.initial() =>
      const SettingsState(notificationsEnabled: true, localeCode: 'en');

  /// Creates a copy with optional overrides.
  SettingsState copyWith({bool? notificationsEnabled, String? localeCode}) {
    return SettingsState(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      localeCode: localeCode ?? this.localeCode,
    );
  }

  @override
  List<Object?> get props => [notificationsEnabled, localeCode];
}

/// Coordinates user preferences across the application.
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  /// Creates a new [SettingsBloc].
  SettingsBloc({
    required ReadBoolSettingUseCase readBoolSettingUseCase,
    required WriteBoolSettingUseCase writeBoolSettingUseCase,
    required ReadStringSettingUseCase readStringSettingUseCase,
    required WriteStringSettingUseCase writeStringSettingUseCase,
  }) : _readBoolSettingUseCase = readBoolSettingUseCase,
       _writeBoolSettingUseCase = writeBoolSettingUseCase,
       _readStringSettingUseCase = readStringSettingUseCase,
       _writeStringSettingUseCase = writeStringSettingUseCase,
       super(SettingsState.initial()) {
    on<SettingsInitialized>(_onInitialized);
    on<SettingsNotificationToggled>(_onNotificationToggled);
    on<SettingsLocaleChanged>(_onLocaleChanged);
  }

  final ReadBoolSettingUseCase _readBoolSettingUseCase;
  final WriteBoolSettingUseCase _writeBoolSettingUseCase;
  final ReadStringSettingUseCase _readStringSettingUseCase;
  final WriteStringSettingUseCase _writeStringSettingUseCase;

  /// Loads persisted preferences from storage.
  Future<void> _onInitialized(
    SettingsInitialized event,
    Emitter<SettingsState> emit,
  ) async {
    final notificationsEnabled = await _readBoolSettingUseCase.execute(
      AppConstants.notificationPreferenceKey,
      defaultValue: true,
    );
    final localeCode =
        await _readStringSettingUseCase.execute(
          AppConstants.localePreferenceKey,
        ) ??
        'en';
    emit(
      state.copyWith(
        notificationsEnabled: notificationsEnabled,
        localeCode: localeCode,
      ),
    );
  }

  /// Persists the notification preference.
  Future<void> _onNotificationToggled(
    SettingsNotificationToggled event,
    Emitter<SettingsState> emit,
  ) async {
    await _writeBoolSettingUseCase.execute(
      AppConstants.notificationPreferenceKey,
      event.enabled,
    );
    emit(state.copyWith(notificationsEnabled: event.enabled));
  }

  /// Applies the requested locale to the state.
  Future<void> _onLocaleChanged(
    SettingsLocaleChanged event,
    Emitter<SettingsState> emit,
  ) async {
    await _writeStringSettingUseCase.execute(
      AppConstants.localePreferenceKey,
      event.localeCode,
    );
    emit(state.copyWith(localeCode: event.localeCode));
  }
}
