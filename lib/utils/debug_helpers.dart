// Gathers handy debug oriented helper functions.
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

/// Debugging utilities for diagnostics and tracing.
class DebugHelpers {
  /// Prevents instantiation.
  const DebugHelpers._();

  /// Logs the current widget tree depth when in debug mode.
  static void dumpDebugMessage(String message) {
    if (kDebugMode) {
      Logger('Debug').info(message);
    }
  }
}
