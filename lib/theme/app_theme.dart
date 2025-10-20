// Builds the light and dark theme configurations.
import 'package:flutter/material.dart';
import 'package:template_app/theme/color_palette.dart';
import 'package:template_app/theme/typography.dart';

/// Provides theme data for MaterialApp.
class AppTheme {
  /// Returns the configured light theme.
  static ThemeData light() {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: ColorPalette.primary,
      colorScheme: ColorScheme.fromSeed(
        seedColor: ColorPalette.primary,
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
  static ThemeData dark() {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: ColorPalette.accent,
      colorScheme: ColorScheme.fromSeed(
        seedColor: ColorPalette.accent,
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
