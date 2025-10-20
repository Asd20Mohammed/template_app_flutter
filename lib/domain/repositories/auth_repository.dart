// Declares the contract required for authentication workflows.
import 'package:template_app/domain/entities/user.dart';

/// Authentication repository abstraction for DI.
abstract class AuthRepository {
  /// Signs the user in and returns the authenticated profile.
  Future<User> login({required String email, required String password});

  /// Registers a brand-new user profile.
  Future<User> register({required String email, required String password});

  /// Logs out the active user session.
  Future<void> logout();

  /// Retrieves the currently signed in user if available.
  Future<User?> getCurrentUser();
}
