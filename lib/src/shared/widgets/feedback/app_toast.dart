// Displays lightweight toast messages using overlays.
import 'package:flutter/material.dart';

/// Helper for showing toasts without blocking UI interactions.
class AppToast {
  /// Prevents instantiation.
  const AppToast._();

  /// Shows a toast with the given [message].
  static void show(BuildContext context, String message) {
    final overlay = Overlay.maybeOf(context);
    if (overlay == null) {
      return;
    }
    final entry = OverlayEntry(
      builder: (context) {
        return Positioned(
          bottom: 60,
          left: 16,
          right: 16,
          child: Material(
            elevation: 6,
            borderRadius: BorderRadius.circular(8),
            color: Colors.black.withValues(alpha: 0.8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Text(
                message,
                style: const TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      },
    );
    overlay.insert(entry);
    Future<void>.delayed(const Duration(seconds: 2), entry.remove);
  }
}
