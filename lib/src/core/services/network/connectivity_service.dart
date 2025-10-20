// Provides a thin wrapper over connectivity_plus to support DI.
import 'package:connectivity_plus/connectivity_plus.dart';

/// Service used for querying network state.
class ConnectivityService {
  /// Creates a new [ConnectivityService].
  ConnectivityService({Connectivity? connectivity})
    : _connectivity = connectivity ?? Connectivity();

  final Connectivity _connectivity;

  /// Returns the underlying connectivity instance.
  Connectivity get connectivity => _connectivity;

  /// Returns the current connectivity results.
  Future<List<ConnectivityResult>> checkConnectivity() {
    return _connectivity.checkConnectivity();
  }

  /// Emits connectivity updates as they arrive.
  Stream<List<ConnectivityResult>> get onStatusChanged =>
      _connectivity.onConnectivityChanged;
}
