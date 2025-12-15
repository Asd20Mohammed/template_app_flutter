// Represents errors occurring during network calls.
import '/src/core/errors/models/app_error.dart';

/// Specific exception for network failures.
class NetworkError extends AppError {
  /// Creates a new [NetworkError].
  NetworkError(super.message, {int? statusCode, super.stackTrace})
    : statusCode = statusCode ?? -1;

  /// Keeps track of the HTTP status code when available.
  final int statusCode;
}
