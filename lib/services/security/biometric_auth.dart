// Provides hooks for biometric authentication flows.
import 'package:logging/logging.dart';

/// Simulates biometric authentication prompts.
class BiometricAuth {
  /// Creates a new [BiometricAuth].
  BiometricAuth() : _logger = Logger('BiometricAuth');

  final Logger _logger;

  /// Attempts to authenticate the user via biometrics.
  Future<bool> authenticate() async {
    _logger.info('Prompting biometric authentication');
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return true;
  }
}
