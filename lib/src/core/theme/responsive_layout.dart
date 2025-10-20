// Builds responsive layouts depending on the available width.
import 'package:flutter/widgets.dart';

/// Provides breakpoints and builders for responsive layout.
class ResponsiveLayout extends StatelessWidget {
  /// Creates a new [ResponsiveLayout].
  const ResponsiveLayout({
    required this.mobile,
    required this.tablet,
    required this.desktop,
    super.key,
  });

  /// Builder for mobile views.
  final WidgetBuilder mobile;

  /// Builder for tablet views.
  final WidgetBuilder tablet;

  /// Builder for desktop views.
  final WidgetBuilder desktop;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 1200) {
      return desktop(context);
    }
    if (width >= 800) {
      return tablet(context);
    }
    return mobile(context);
  }
}
