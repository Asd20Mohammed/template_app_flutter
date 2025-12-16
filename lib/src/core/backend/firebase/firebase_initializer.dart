// Handles Firebase initialization.
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

/// Initializes Firebase for the application.
class FirebaseInitializer {
  static bool _initialized = false;

  /// Initializes Firebase if not already initialized.
  ///
  /// Call this before using any Firebase services.
  /// Returns true if initialization was successful.
  static Future<bool> initialize() async {
    if (_initialized) {
      return true;
    }

    try {
      await Firebase.initializeApp();
      _initialized = true;
      return true;
    } catch (e) {
      debugPrint('Firebase initialization failed: $e');
      return false;
    }
  }

  /// Returns whether Firebase has been initialized.
  static bool get isInitialized => _initialized;
}
