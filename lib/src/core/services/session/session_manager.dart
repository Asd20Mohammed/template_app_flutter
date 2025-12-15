// Coordinates authentication session lifecycle and caching.
import 'package:logging/logging.dart';
import '/src/features/profile/domain/entities/user.dart';

/// Stores the active user session in memory.
class SessionManager {
  /// Creates a new [SessionManager].
  SessionManager() : _logger = Logger('SessionManager');

  final Logger _logger;
  User? _currentUser;

  /// Returns the currently authenticated user if any.
  User? get currentUser => _currentUser;

  /// Starts a new authenticated session for [user].
  Future<void> startSession(User user) async {
    _logger.info('Starting session for ${user.email}');
    _currentUser = user;
  }

  /// Ends the active session and clears cached credentials.
  Future<void> endSession() async {
    if (_currentUser != null) {
      _logger.info('Ending session for ${_currentUser!.email}');
    }
    _currentUser = null;
  }
}
