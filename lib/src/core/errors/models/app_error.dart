// Represents a high-level application error.
class AppError implements Exception {
  /// Creates a new [AppError].
  AppError(this.message, {this.stackTrace});

  /// Human readable error message.
  final String message;

  /// Optional stack trace for debugging.
  final StackTrace? stackTrace;

  @override
  String toString() => 'AppError(message: $message)';
}
