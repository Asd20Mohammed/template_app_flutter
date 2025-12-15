import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'circular_notched_rectangle_clipper_fix.dart';

/// A wrapper for AnimatedBottomNavigationBar that handles potential clipping issues
/// and prevents the "Scaffold.geometryOf() must only be accessed during the paint phase" error.
class SafeBottomNavigationBar extends StatelessWidget {
  final List<IconData> icons;
  final int? activeIndex;
  final Function(int) onTap;
  final NotchSmoothness notchSmoothness;
  final GapLocation gapLocation;
  final Color activeColor;
  final Color backgroundColor;
  final Color inactiveColor;
  final double leftCornerRadius;
  final double rightCornerRadius;
  final int splashSpeedInMilliseconds;
  final Color splashColor;
  final double iconSize;
  final Curve hideAnimationCurve;
  final double scaleFactor;
  final double elevation;
  final BoxShadow? shadow;
  final bool blurEffect;
  final List<int>? colorlessIndices;

  const SafeBottomNavigationBar({
    super.key,
    required this.icons,
    required this.activeIndex,
    required this.onTap,
    this.notchSmoothness = NotchSmoothness.defaultEdge,
    this.gapLocation = GapLocation.center,
    required this.activeColor,
    required this.backgroundColor,
    required this.inactiveColor,
    this.leftCornerRadius = 0,
    this.rightCornerRadius = 0,
    this.splashSpeedInMilliseconds = 300,
    required this.splashColor,
    this.iconSize = 24,
    this.hideAnimationCurve = Curves.easeOutQuad,
    this.scaleFactor = 1.0,
    this.elevation = 8,
    this.shadow,
    this.blurEffect = false,
    this.colorlessIndices,
  });

  @override
  Widget build(BuildContext context) {
    // Use RepaintBoundary to isolate the painting process
    return RepaintBoundary(
      child: ClipPath(
        // Custom clipper that safely handles scaffold geometry
        clipper: SafeCircularNotchedAndCorneredRectangleClipper(
          leftCornerRadius: leftCornerRadius,
          rightCornerRadius: rightCornerRadius,
        ),
        child: AnimatedBottomNavigationBar.builder(
          itemCount: icons.length,
          tabBuilder: (int index, bool isActive) {
            // Check if this index should be colorless/invisible
            final shouldBeColorless =
                colorlessIndices?.contains(index) ?? false;

            if (shouldBeColorless) {
              // Return a completely transparent/empty widget
              return SizedBox(width: iconSize, height: iconSize);
            }

            // Normal icon rendering
            final iconColor = isActive ? activeColor : inactiveColor;
            return Icon(icons[index], size: iconSize, color: iconColor);
          },
          activeIndex: activeIndex ?? 0,
          gapLocation: gapLocation,
          notchSmoothness: notchSmoothness,
          leftCornerRadius: leftCornerRadius,
          rightCornerRadius: rightCornerRadius,
          onTap: onTap,
          backgroundColor: backgroundColor,
          splashColor: splashColor,
          splashSpeedInMilliseconds: splashSpeedInMilliseconds,
          hideAnimationCurve: hideAnimationCurve,
          scaleFactor: scaleFactor,
          elevation: elevation,
          shadow: shadow,
          blurEffect: blurEffect,
        ),
      ),
    );
  }
}
