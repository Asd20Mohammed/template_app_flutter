// Provides the global application state and lifecycle coordination.
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:template_app/core/constants/app_constants.dart';
import 'package:template_app/data/data_sources/local/local_storage.dart';

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
  const AppState({required this.themeMode, required this.initialized});

  /// The current theme mode in use by the app.
  final ThemeMode themeMode;

  /// Whether the application finished bootstrapping.
  final bool initialized;

  /// Creates a copy of the current state with optional overrides.
  AppState copyWith({ThemeMode? themeMode, bool? initialized}) {
    return AppState(
      themeMode: themeMode ?? this.themeMode,
      initialized: initialized ?? this.initialized,
    );
  }

  /// Provides the initial state before any logic runs.
  factory AppState.initial() =>
      const AppState(themeMode: ThemeMode.system, initialized: false);

  @override
  List<Object?> get props => [themeMode, initialized];
}

/// Coordinates high-level application behaviours such as bootstrapping.
class AppBloc extends Bloc<AppEvent, AppState> {
  /// Builds a new [AppBloc] using the default initial state.
  AppBloc({required LocalStorage localStorage})
    : _localStorage = localStorage,
      super(AppState.initial()) {
    on<AppStarted>(_onAppStarted);
    on<AppThemeChanged>(_onThemeChanged);
  }

  final LocalStorage _localStorage;

  /// Handles the application bootstrap flow.
  Future<void> _onAppStarted(AppStarted event, Emitter<AppState> emit) async {
    final storedTheme = await _localStorage.readString(
      AppConstants.themePreferenceKey,
    );
    final themeMode = _mapTheme(storedTheme);
    emit(state.copyWith(initialized: true, themeMode: themeMode));
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
}
