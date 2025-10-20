// Offers helper methods for responsive layout calculations.
import 'package:flutter/widgets.dart';

/// Styling helpers for responsive sizing.
class ResponsiveUtils {
  /// Prevents instantiation.
  const ResponsiveUtils._();

  /// Returns a responsive padding based on the screen width.
  static double horizontalPadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 1200) {
      return 64;
    }
    if (width >= 800) {
      return 32;
    }
    return 16;
  }

  /// Chooses a breakpoint-specific column count.
  static int columnsForWidth(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 1200) {
      return 4;
    }
    if (width >= 800) {
      return 3;
    }
    if (width >= 600) {
      return 2;
    }
    return 1;
  }
}
