// Specialized handler for network related errors.
import 'package:dio/dio.dart';
import 'package:template_app/src/core/errors/models/network_error.dart';

/// Maps Dio errors into strongly typed [NetworkError] instances.
class NetworkErrorHandler {
  /// Converts a [DioException] into a [NetworkError].
  NetworkError fromDio(DioException error) {
    final statusCode = error.response?.statusCode ?? -1;
    final message = error.message ?? 'A network error has occurred';
    return NetworkError(
      message,
      statusCode: statusCode,
      stackTrace: error.stackTrace,
    );
  }
}
