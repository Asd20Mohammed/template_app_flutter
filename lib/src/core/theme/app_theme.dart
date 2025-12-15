// Builds the light and dark theme configurations.
import 'package:flutter/material.dart';
import '/src/core/theme/typography.dart';

/// Provides theme data for MaterialApp.
class AppTheme {
  /// Returns the configured light theme.
  static ThemeData light(Color seedColor) {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: seedColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: seedColor,
        brightness: Brightness.light,
      ),
      textTheme: const TextTheme(
        headlineMedium: AppTypography.headline,
        titleMedium: AppTypography.subtitle,
        bodyMedium: AppTypography.body,
        labelSmall: AppTypography.caption,
      ),
    );
  }

  /// Returns the configured dark theme.
  static ThemeData dark(Color seedColor) {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: seedColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: seedColor,
        brightness: Brightness.dark,
      ),
      textTheme: const TextTheme(
        headlineMedium: AppTypography.headline,
        titleMedium: AppTypography.subtitle,
        bodyMedium: AppTypography.body,
        labelSmall: AppTypography.caption,
      ),
    );
  }
}
