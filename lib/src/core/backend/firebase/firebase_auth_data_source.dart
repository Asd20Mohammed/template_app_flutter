// Firebase implementation of AuthDataSource.
import 'package:firebase_auth/firebase_auth.dart' as fb;

import '../data_source.dart';

/// Firebase implementation of [AuthDataSource].
class FirebaseAuthDataSource implements AuthDataSource {
  /// Creates a new [FirebaseAuthDataSource].
  FirebaseAuthDataSource({fb.FirebaseAuth? firebaseAuth})
      : _auth = firebaseAuth ?? fb.FirebaseAuth.instance;

  final fb.FirebaseAuth _auth;

  @override
  Future<DataResult<Map<String, dynamic>>> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return DataResult.success(_userToMap(credential.user));
    } on fb.FirebaseAuthException catch (e) {
      return DataResult.failure(_mapFirebaseError(e));
    } catch (e) {
      return DataResult.failure(e.toString());
    }
  }

  @override
  Future<DataResult<Map<String, dynamic>>> createUserWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return DataResult.success(_userToMap(credential.user));
    } on fb.FirebaseAuthException catch (e) {
      return DataResult.failure(_mapFirebaseError(e));
    } catch (e) {
      return DataResult.failure(e.toString());
    }
  }

  @override
  Future<DataResult<void>> signOut() async {
    try {
      await _auth.signOut();
      return const DataResult.success(null);
    } catch (e) {
      return DataResult.failure(e.toString());
    }
  }

  @override
  Future<DataResult<Map<String, dynamic>?>> getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        return const DataResult.success(null);
      }
      return DataResult.success(_userToMap(user));
    } catch (e) {
      return DataResult.failure(e.toString());
    }
  }

  @override
  Future<DataResult<void>> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return const DataResult.success(null);
    } on fb.FirebaseAuthException catch (e) {
      return DataResult.failure(_mapFirebaseError(e));
    } catch (e) {
      return DataResult.failure(e.toString());
    }
  }

  @override
  Stream<Map<String, dynamic>?> get authStateChanges {
    return _auth.authStateChanges().map((user) {
      if (user == null) return null;
      return _userToMap(user);
    });
  }

  Map<String, dynamic> _userToMap(fb.User? user) {
    if (user == null) {
      return {};
    }
    return {
      'id': user.uid,
      'email': user.email,
      'displayName': user.displayName,
      'photoUrl': user.photoURL,
      'emailVerified': user.emailVerified,
      'phoneNumber': user.phoneNumber,
      'createdAt': user.metadata.creationTime?.toIso8601String(),
      'lastSignInAt': user.metadata.lastSignInTime?.toIso8601String(),
    };
  }

  String _mapFirebaseError(fb.FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'invalid-email':
        return 'The email address is invalid.';
      case 'weak-password':
        return 'The password is too weak.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many requests. Please try again later.';
      case 'operation-not-allowed':
        return 'This operation is not allowed.';
      default:
        return e.message ?? 'An authentication error occurred.';
    }
  }
}
