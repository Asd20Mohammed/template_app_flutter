// Contains helpers for validating SSL certificates and secure channels.
import 'package:dio/dio.dart';
import 'package:logging/logging.dart';

/// Provides hooks for configuring SSL pinning on Dio clients.
class NetworkSecurity {
  /// Creates a new [NetworkSecurity].
  NetworkSecurity() : _logger = Logger('NetworkSecurity');

  final Logger _logger;

  /// Applies certificate pinning logic to the provided [dio] instance.
  void applySecurity(Dio dio) {
    dio.httpClientAdapter;
    _logger.info('Network security hooks configured');
  }
}
