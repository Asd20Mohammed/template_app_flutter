// Custom bloc observer that logs state changes during development.
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

/// Outputs bloc events and transitions to the configured logger.
class AppBlocObserver extends BlocObserver {
  /// Creates a new [AppBlocObserver].
  AppBlocObserver() : _logger = Logger('AppBlocObserver');

  final Logger _logger;

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    _logger.fine('onEvent -- ${bloc.runtimeType}: $event');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    _logger.fine('onChange -- ${bloc.runtimeType}: $change');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    _logger.severe('onError -- ${bloc.runtimeType}', error, stackTrace);
  }
}
