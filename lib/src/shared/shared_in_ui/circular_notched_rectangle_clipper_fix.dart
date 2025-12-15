import 'package:flutter/material.dart';
import 'dart:math' as math;

// Create a global navigator key to access context safely
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

/// A fixed version of CircularNotchedRectangle that safely handles the
/// "Scaffold.geometryOf() must only be accessed during the paint phase" error.
class SafeCircularNotchedRectangle extends NotchedShape {
  /// Creates a [SafeCircularNotchedRectangle].
  ///
  /// The same as [CircularNotchedRectangle] but with error handling.
  const SafeCircularNotchedRectangle();

  @override
  Path getOuterPath(Rect host, Rect? guest) {
    if (guest == null || !host.overlaps(guest)) {
      return Path()..addRect(host);
    }

    // The guest's shape is a circle bounded by the guest rectangle.
    // So the guest's radius is half the guest width.
    final double notchRadius = guest.width / 2.0;

    // We build a path for the notch by:
    //
    // 1. Starting at the top left of the host.
    // 2. Add a rectangle for the left side of the host.
    // 3. Add a circle for the notch.
    // 4. Add a rectangle for the right side of the host.
    //
    // In order to find the path centers, we need to:
    //
    // 1. Construct a rectangle representing the right half of the notch.
    // 2. Construct a rectangle representing the left half of the notch.
    // 3. Calculate the top-center point for the notch.
    // 4. Create a circle using the top-center point as its center and the notch
    //    radius as its radius.

    // The notch sits in the top edge of the host and is centered on the guest.
    // The notch is a circle with diameter equal to the guest's width.
    // The circle's center is at the top of the guest and the center of its width.

    const double s2 = 1.0;

    final double r = notchRadius;
    final double a = -1.0 * r - s2;
    final double b = host.top - guest.center.dy;

    final double n2 = math.sqrt(b * b * r * r * (1.0 - b * b / (r * r)));
    final double p2xA = guest.center.dx + a - n2;
    final double p2xB = guest.center.dx + a + n2;
    final double p2yA = host.top - b;
    final double p2yB = host.top - b;

    final Path path = Path()
      ..moveTo(host.left, host.top)
      ..lineTo(p2xA, p2yA)
      ..arcToPoint(
        Offset(p2xB, p2yB),
        radius: Radius.circular(notchRadius),
        clockwise: false,
      )
      ..lineTo(host.right, host.top)
      ..lineTo(host.right, host.bottom)
      ..lineTo(host.left, host.bottom)
      ..close();
    return path;
  }
}

/// A fixed version of CircularNotchedAndCorneredRectangleClipper to handle the error
class SafeCircularNotchedAndCorneredRectangleClipper
    extends CustomClipper<Path> {
  final double leftCornerRadius;
  final double rightCornerRadius;
  final double notchMargin;

  SafeCircularNotchedAndCorneredRectangleClipper({
    required this.leftCornerRadius,
    required this.rightCornerRadius,
    this.notchMargin = 6,
  });

  @override
  Path getClip(Size size) {
    // This is where the error happens in the original implementation
    final Rect host = Rect.fromLTWH(0, 0, size.width, size.height);
    final SafeCircularNotchedRectangle clipper = SafeCircularNotchedRectangle();

    try {
      // Try to get FAB geometry, but if it causes an error, just return a path without notch
      if (navigatorKey.currentContext == null) {
        return getPathWithoutNotch(size);
      }

      final scaffoldState = Scaffold.maybeOf(navigatorKey.currentContext!);
      Rect? guest;

      if (scaffoldState != null) {
        try {
          // The issue occurs here - we need to capture and handle the error properly
          final geometryListenable = Scaffold.geometryOf(
            navigatorKey.currentContext!,
          );

          // Get the current geometry value
          final ScaffoldGeometry geometry = geometryListenable.value;

          // Get the FAB location
          if (geometry.floatingActionButtonArea != null) {
            guest = geometry.floatingActionButtonArea;
          }
        } catch (e) {
          // If accessing the geometry fails (during hit test), return a path without notch
          return getPathWithoutNotch(size);
        }
      }

      // Get the path with notch for the FAB
      return getPathWithCorners(
        clipper.getOuterPath(host, guest),
        leftCornerRadius,
        rightCornerRadius,
        size,
      );
    } catch (e) {
      // If any error happens, return a safe path without notch
      return getPathWithoutNotch(size);
    }
  }

  Path getPathWithoutNotch(Size size) {
    final Path path = Path();
    path.moveTo(leftCornerRadius, 0);
    path.lineTo(size.width - rightCornerRadius, 0);
    path.arcToPoint(
      Offset(size.width, rightCornerRadius),
      radius: Radius.circular(rightCornerRadius),
      clockwise: true,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, leftCornerRadius);
    path.arcToPoint(
      Offset(leftCornerRadius, 0),
      radius: Radius.circular(leftCornerRadius),
      clockwise: true,
    );
    path.close();
    return path;
  }

  Path getPathWithCorners(
    Path notchedPath,
    double leftCornerRadius,
    double rightCornerRadius,
    Size size,
  ) {
    if (leftCornerRadius == 0 && rightCornerRadius == 0) {
      return notchedPath;
    }

    final Path path = Path();

    // Start from left-top corner
    if (leftCornerRadius != 0) {
      path.moveTo(0, leftCornerRadius);
      path.arcToPoint(
        Offset(leftCornerRadius, 0),
        radius: Radius.circular(leftCornerRadius),
        clockwise: true,
      );
    } else {
      path.moveTo(0, 0);
    }

    // Get the notched path coordinates
    final metrics = notchedPath.computeMetrics();
    bool foundNotch = false;

    for (final metric in metrics) {
      final double length = metric.length;
      int divideBy = (length > 200) ? 10 : 1;

      // Sample the path at regular intervals to find the notch
      for (int i = 0; i <= length; i += (length ~/ divideBy)) {
        final double distance = i.toDouble();
        final tangent = metric.getTangentForOffset(distance);

        if (tangent != null) {
          final Offset position = tangent.position;

          // Check if we're at the top of the path (where the notch would be)
          if (position.dy.round() == 0 &&
              position.dx > leftCornerRadius &&
              position.dx < (size.width - rightCornerRadius)) {
            if (!foundNotch) {
              foundNotch = true;
              path.lineTo(position.dx, position.dy);
            } else {
              // We're at the end of the notch, continue with the right side
              path.lineTo(position.dx, 0);
              break;
            }
          }

          // If we've already found and processed the notch, we're done
          if (foundNotch && position.dy.round() > 0) {
            break;
          }
        }
      }
    }

    // If no notch was found, continue with a straight line
    if (!foundNotch) {
      path.lineTo(size.width - rightCornerRadius, 0);
    }

    // Add right-top corner
    if (rightCornerRadius != 0) {
      path.lineTo(size.width - rightCornerRadius, 0);
      path.arcToPoint(
        Offset(size.width, rightCornerRadius),
        radius: Radius.circular(rightCornerRadius),
        clockwise: true,
      );
    } else {
      path.lineTo(size.width, 0);
    }

    // Complete the path
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, leftCornerRadius);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
