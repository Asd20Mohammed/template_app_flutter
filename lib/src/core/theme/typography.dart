// Provides consistent text styles used throughout the app.
import 'package:flutter/material.dart';

/// Defines the typography scale for the design system.
class AppTypography {
  /// Prevents instantiation.
  const AppTypography._();

  /// Headline style for prominent titles.
  static const TextStyle headline = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w600,
  );

  /// Subtitle style for secondary text.
  static const TextStyle subtitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
  );

  /// Body style used for standard paragraphs.
  static const TextStyle body = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  /// Caption style for metadata or helper text.
  static const TextStyle caption = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w300,
  );
}
