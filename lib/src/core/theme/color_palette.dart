// Defines the brand color palette for the template.
import 'package:flutter/material.dart';

/// Central place for color definitions to keep styles consistent.
class ColorPalette {
  /// Prevents instantiation.
  const ColorPalette._();

  /// Primary brand color.
  static const Color primary = Color(0xFF1E88E5);

  /// Accent color used for highlights.
  static const Color accent = Color(0xFF26C6DA);

  /// Neutral surface color.
  static const Color surface = Color(0xFFF2F5F7);

  /// Neutral dark text color.
  static const Color textPrimary = Color(0xFF1F2933);

  /// Neutral light text color.
  static const Color textOnPrimary = Colors.white;
}
