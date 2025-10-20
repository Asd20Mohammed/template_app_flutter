// Exposes location updates for interested components.
import 'package:logging/logging.dart';

/// Mock location service that emits template coordinates.
class LocationService {
  /// Creates a new [LocationService].
  LocationService() : _logger = Logger('LocationService');

  final Logger _logger;

  /// Retrieves the current device coordinates once.
  Future<Map<String, double>> getCurrentLocation() async {
    _logger.info('Fetching current location');
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return {'lat': 0.0, 'lng': 0.0};
  }
}
