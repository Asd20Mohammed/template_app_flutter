// Wraps Dio to provide a strongly typed API client for REST calls.
import 'package:dio/dio.dart';
import 'package:logging/logging.dart';

/// Centralized networking client with interceptors and logging.
class ApiClient {
  /// Creates a new [ApiClient].
  ApiClient({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: 'https://api.your-template.dev',
              connectTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 10),
            ),
          ),
      _logger = Logger('ApiClient');

  final Dio _dio;
  final Logger _logger;

  /// Performs a GET request returning the decoded body.
  Future<Response<dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get<dynamic>(
        path,
        queryParameters: queryParameters,
      );
      return response;
    } on DioException catch (error, stackTrace) {
      _logger.severe('GET $path failed', error, stackTrace);
      rethrow;
    }
  }

  /// Performs a POST request with the provided [data].
  Future<Response<dynamic>> post(String path, {Object? data}) async {
    try {
      final response = await _dio.post<dynamic>(path, data: data);
      return response;
    } on DioException catch (error, stackTrace) {
      _logger.severe('POST $path failed', error, stackTrace);
      rethrow;
    }
  }

  /// Performs a PUT request with the provided [data].
  Future<Response<dynamic>> put(String path, {Object? data}) async {
    try {
      final response = await _dio.put<dynamic>(path, data: data);
      return response;
    } on DioException catch (error, stackTrace) {
      _logger.severe('PUT $path failed', error, stackTrace);
      rethrow;
    }
  }

  /// Performs a DELETE request against the provided [path].
  Future<Response<dynamic>> delete(String path) async {
    try {
      final response = await _dio.delete<dynamic>(path);
      return response;
    } on DioException catch (error, stackTrace) {
      _logger.severe('DELETE $path failed', error, stackTrace);
      rethrow;
    }
  }
}
