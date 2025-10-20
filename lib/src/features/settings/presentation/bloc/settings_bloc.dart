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

/// Updates the text scale factor used across the app.
class SettingsTextScaleChanged extends SettingsEvent {
  /// Creates a text scale change event.
  const SettingsTextScaleChanged(this.textScale);

  /// Desired text scale factor.
  final double textScale;

  @override
  List<Object?> get props => [textScale];
}

/// Updates the responsive/layout scale factor used across the app.
class SettingsLayoutScaleChanged extends SettingsEvent {
  /// Creates a layout scale change event.
  const SettingsLayoutScaleChanged(this.layoutScale);

  /// Desired layout scale factor.
  final double layoutScale;

  @override
  List<Object?> get props => [layoutScale];
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
    required this.textScale,
    required this.layoutScale,
  });

  /// Whether push notifications are enabled.
  final bool notificationsEnabled;

  /// The active locale code.
  final String localeCode;

  /// Global text scale factor applied via [MediaQuery].
  final double textScale;

  /// Layout scale multiplier used by responsive utilities.
  final double layoutScale;

  /// The initial settings state.
  factory SettingsState.initial() => const SettingsState(
    notificationsEnabled: true,
    localeCode: 'en',
    textScale: 1.0,
    layoutScale: 1.0,
  );

  /// Creates a copy with optional overrides.
  SettingsState copyWith({
    bool? notificationsEnabled,
    String? localeCode,
    double? textScale,
    double? layoutScale,
  }) {
    return SettingsState(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      localeCode: localeCode ?? this.localeCode,
      textScale: textScale ?? this.textScale,
      layoutScale: layoutScale ?? this.layoutScale,
    );
  }

  @override
  List<Object?> get props => [
    notificationsEnabled,
    localeCode,
    textScale,
    layoutScale,
  ];
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
    on<SettingsTextScaleChanged>(_onTextScaleChanged);
    on<SettingsLayoutScaleChanged>(_onLayoutScaleChanged);
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
    final textScaleString = await _readStringSettingUseCase.execute(
      AppConstants.textScalePreferenceKey,
    );
    final layoutScaleString = await _readStringSettingUseCase.execute(
      AppConstants.layoutScalePreferenceKey,
    );
    final textScale = double.tryParse(textScaleString ?? '') ?? 1.0;
    final layoutScale = double.tryParse(layoutScaleString ?? '') ?? 1.0;
    emit(
      state.copyWith(
        notificationsEnabled: notificationsEnabled,
        localeCode: localeCode,
        textScale: textScale,
        layoutScale: layoutScale,
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

  Future<void> _onTextScaleChanged(
    SettingsTextScaleChanged event,
    Emitter<SettingsState> emit,
  ) async {
    final scale = event.textScale.clamp(0.8, 1.4);
    await _writeStringSettingUseCase.execute(
      AppConstants.textScalePreferenceKey,
      scale.toStringAsFixed(2),
    );
    emit(state.copyWith(textScale: scale));
  }

  Future<void> _onLayoutScaleChanged(
    SettingsLayoutScaleChanged event,
    Emitter<SettingsState> emit,
  ) async {
    final scale = event.layoutScale.clamp(0.8, 1.4);
    await _writeStringSettingUseCase.execute(
      AppConstants.layoutScalePreferenceKey,
      scale.toStringAsFixed(2),
    );
    emit(state.copyWith(layoutScale: scale));
  }
}
