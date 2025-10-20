// Configures logging output for the entire application.
import 'package:logging/logging.dart';

/// Utility responsible for bootstrapping the [Logger] package.
class AppLogger {
  /// Initializes the logging configuration with a pretty printer.
  static void configure({bool enableDebugLogging = true}) {
    if (!enableDebugLogging) {
      Logger.root.level = Level.WARNING;
      return;
    }
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((record) {
      // ignore: avoid_print
      print(
        '${record.level.name.padRight(7)} '
        '${record.time.toIso8601String()} '
        '${record.loggerName}: ${record.message}',
      );
      if (record.error != null) {
        // ignore: avoid_print
        print('Error: ${record.error}');
      }
      if (record.stackTrace != null) {
        // ignore: avoid_print
        print(record.stackTrace);
      }
    });
  }
}
