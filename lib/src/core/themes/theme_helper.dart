import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeHelper {
  ThemeHelper._();

  static bool get isDarkMode {
    return Get.isDarkMode;
  }

  static T adaptiveColor<T>({
    required T lightColor,
    required T darkColor,
  }) {
    return isDarkMode ? darkColor : lightColor;
  }

  static Color adaptiveTextColor(BuildContext context) {
    return isDarkMode ? Colors.white : Colors.black;
  }

  static Color adaptiveBackgroundColor(BuildContext context) {
    return isDarkMode ? const Color(0xFF121212) : Colors.white;
  }

  static Color adaptiveCardColor(BuildContext context) {
    return isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
  }

  static Color get contrastColor {
    return isDarkMode ? Colors.black : Colors.white;
  }

  static Color get darkOverlayColor {
    return Colors.black54;
  }

  static Color get iconColor {
    return isDarkMode ? Colors.white70 : Colors.black54;
  }
}
