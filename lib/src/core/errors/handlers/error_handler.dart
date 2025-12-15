// Central error handling utility that dispatches issues to the [ErrorBloc].
import '/src/core/errors/models/app_error.dart';
import '/src/core/errors/presentation/error_bloc.dart';

/// Converts exceptions into user friendly messages.
class ErrorHandler {
  /// Creates a new [ErrorHandler].
  ErrorHandler(this._errorBloc);

  final ErrorBloc _errorBloc;

  /// Reports the [error] to the global error bloc and logs details.
  void report(Object error, {StackTrace? stackTrace}) {
    var message = 'Something went wrong';
    if (error is AppError) {
      message = error.message;
    }
    _errorBloc.add(
      ErrorReported(message: message, details: stackTrace?.toString()),
    );
  }
}
