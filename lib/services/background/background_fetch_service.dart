// Provides APIs to trigger data refreshes in the background.
import 'package:logging/logging.dart';

/// Simulates background fetch events for the template.
class BackgroundFetchService {
  /// Creates a new [BackgroundFetchService].
  BackgroundFetchService() : _logger = Logger('BackgroundFetchService');

  final Logger _logger;

  /// Triggers a background fetch event.
  Future<void> performFetch() async {
    _logger.info('Performing background fetch');
    await Future<void>.delayed(const Duration(seconds: 1));
  }
}
