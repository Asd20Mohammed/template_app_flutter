// Handles syncing data with remote sources in the background.
import 'package:logging/logging.dart';
import 'package:template_app/src/core/data/data_sources/remote/api_client.dart';

/// Coordinates background data synchronization tasks.
class DataSyncService {
  /// Creates a new [DataSyncService].
  DataSyncService(this._apiClient) : _logger = Logger('DataSyncService');

  final ApiClient _apiClient;
  final Logger _logger;

  /// Performs a synchronization pass for all registered collections.
  Future<void> syncAll() async {
    _logger.info('Performing background synchronization');
    await _apiClient.get('/sync');
  }
}
