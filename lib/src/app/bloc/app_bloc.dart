// Provides the global application state and lifecycle coordination.
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/src/core/constants/app_constants.dart';
import '/src/core/data/data_sources/local/local_storage.dart';
import '/src/core/theme/color_palette.dart';

/// Describes the possible events that can update [AppBloc].
abstract class AppEvent extends Equatable {
  /// Creates a new app event instance.
  const AppEvent();

  @override
  List<Object?> get props => [];
}

/// Notifies the bloc that the app finished its initialization logic.
class AppStarted extends AppEvent {
  /// Creates an [AppStarted] event.
  const AppStarted();
}

/// Requests a theme change for the application.
class AppThemeChanged extends AppEvent {
  /// Creates an [AppThemeChanged] event with the desired [themeMode].
  const AppThemeChanged(this.themeMode);

  /// The theme mode requested by the user.
  final ThemeMode themeMode;

  @override
  List<Object?> get props => [themeMode];
}

/// Carries the immutable view of the application state.
class AppState extends Equatable {
  /// Creates a new [AppState] instance.
  const AppState({
    required this.themeMode,
    required this.initialized,
    required this.seedColor,
  });

  /// The current theme mode in use by the app.
  final ThemeMode themeMode;

  /// Whether the application finished bootstrapping.
  final bool initialized;

  /// Seed color used throughout the theme.
  final Color seedColor;

  /// Creates a copy of the current state with optional overrides.
  AppState copyWith({
    ThemeMode? themeMode,
    bool? initialized,
    Color? seedColor,
  }) {
    return AppState(
      themeMode: themeMode ?? this.themeMode,
      initialized: initialized ?? this.initialized,
      seedColor: seedColor ?? this.seedColor,
    );
  }

  /// Provides the initial state before any logic runs.
  factory AppState.initial() => const AppState(
    themeMode: ThemeMode.system,
    initialized: false,
    seedColor: ColorPalette.primary,
  );

  @override
  List<Object?> get props => [themeMode, initialized, seedColor];
}

/// Coordinates high-level application behaviours such as bootstrapping.
class AppBloc extends Bloc<AppEvent, AppState> {
  /// Builds a new [AppBloc] using the default initial state.
  AppBloc({required LocalStorage localStorage})
    : _localStorage = localStorage,
      super(AppState.initial()) {
    on<AppStarted>(_onAppStarted);
    on<AppThemeChanged>(_onThemeChanged);
    on<AppColorSeedChanged>(_onSeedChanged);
  }

  final LocalStorage _localStorage;

  /// Handles the application bootstrap flow.
  Future<void> _onAppStarted(AppStarted event, Emitter<AppState> emit) async {
    final storedTheme = await _localStorage.readString(
      AppConstants.themePreferenceKey,
    );
    final storedSeed = await _localStorage.readString(
      AppConstants.colorSeedPreferenceKey,
    );
    final themeMode = _mapTheme(storedTheme);
    final seedColor = _mapSeed(storedSeed);
    emit(
      state.copyWith(
        initialized: true,
        themeMode: themeMode,
        seedColor: seedColor,
      ),
    );
  }

  /// Updates the theme mode for the entire application.
  Future<void> _onThemeChanged(
    AppThemeChanged event,
    Emitter<AppState> emit,
  ) async {
    await _localStorage.writeString(
      AppConstants.themePreferenceKey,
      event.themeMode.name,
    );
    emit(state.copyWith(themeMode: event.themeMode));
  }

  /// Updates the color seed for the theme.
  Future<void> _onSeedChanged(
    AppColorSeedChanged event,
    Emitter<AppState> emit,
  ) async {
    // ignore: deprecated_member_use
    final argb = event.seedColor.value;
    await _localStorage.writeString(
      AppConstants.colorSeedPreferenceKey,
      argb.toRadixString(16),
    );
    emit(state.copyWith(seedColor: event.seedColor));
  }

  ThemeMode _mapTheme(String? value) {
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  Color _mapSeed(String? value) {
    if (value == null) {
      return ColorPalette.primary;
    }
    final intValue = int.tryParse(value, radix: 16);
    if (intValue == null) {
      return ColorPalette.primary;
    }
    return Color(intValue);
  }
}

/// Updates the global theme color seed.
class AppColorSeedChanged extends AppEvent {
  /// Creates a new [AppColorSeedChanged] event.
  const AppColorSeedChanged(this.seedColor);

  /// The selected color seed.
  final Color seedColor;

  @override
  List<Object?> get props => [seedColor];
}
