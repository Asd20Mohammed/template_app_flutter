// Offers helper methods for responsive layout calculations.
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:template_app/src/features/settings/presentation/bloc/settings_bloc.dart';

/// Styling helpers for responsive sizing.
class ResponsiveUtils {
  /// Prevents instantiation.
  const ResponsiveUtils._();

  /// Returns a responsive padding based on the screen width.
  static double horizontalPadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final layoutScale = context.select(
      (SettingsBloc bloc) => bloc.state.layoutScale,
    );
    final clampedScale = layoutScale.clamp(0.8, 1.4);
    if (width >= 1200) {
      return 64 * clampedScale;
    }
    if (width >= 800) {
      return 32 * clampedScale;
    }
    return 16 * clampedScale;
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
