// Provides read/write access to user profile data.
import 'package:template_app/domain/entities/user.dart';

/// Repository interface for user data management.
abstract class UserRepository {
  /// Returns the active user profile or null when missing.
  Future<User?> fetchProfile();

  /// Persists profile changes to the data source.
  Future<User> updateProfile(User user);
}
