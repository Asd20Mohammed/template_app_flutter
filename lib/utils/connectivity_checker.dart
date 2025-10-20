// Provides helpers to query current connectivity state.
import 'package:connectivity_plus/connectivity_plus.dart';

/// Utility for quick network availability checks.
class ConnectivityChecker {
  /// Creates a new [ConnectivityChecker].
  ConnectivityChecker({Connectivity? connectivity})
    : _connectivity = connectivity ?? Connectivity();

  final Connectivity _connectivity;

  /// Returns true when the device has a usable connection.
  Future<bool> isOnline() async {
    final results = await _connectivity.checkConnectivity();
    if (results.isEmpty) {
      return false;
    }
    return results.any((result) => result != ConnectivityResult.none);
  }
}
