// REST API implementation of AuthDataSource.
import 'dart:async';

import 'package:dio/dio.dart';

import '../data_source.dart';

/// REST API implementation of [AuthDataSource].
class RestAuthDataSource implements AuthDataSource {
  /// Creates a new [RestAuthDataSource].
  RestAuthDataSource({
    required Dio dio,
    String? authEndpoint,
  })  : _dio = dio,
        _authEndpoint = authEndpoint ?? '/auth';

  final Dio _dio;
  final String _authEndpoint;

  final _authStateController = StreamController<Map<String, dynamic>?>.broadcast();
  Map<String, dynamic>? _currentUser;

  @override
  Future<DataResult<Map<String, dynamic>>> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        '$_authEndpoint/login',
        data: {'email': email, 'password': password},
      );

      final userData = response.data as Map<String, dynamic>;
      _currentUser = userData;
      _authStateController.add(userData);

      return DataResult.success(userData);
    } on DioException catch (e) {
      return DataResult.failure(_mapDioError(e));
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
      final response = await _dio.post(
        '$_authEndpoint/register',
        data: {'email': email, 'password': password},
      );

      final userData = response.data as Map<String, dynamic>;
      _currentUser = userData;
      _authStateController.add(userData);

      return DataResult.success(userData);
    } on DioException catch (e) {
      return DataResult.failure(_mapDioError(e));
    } catch (e) {
      return DataResult.failure(e.toString());
    }
  }

  @override
  Future<DataResult<void>> signOut() async {
    try {
      await _dio.post('$_authEndpoint/logout');
      _currentUser = null;
      _authStateController.add(null);
      return const DataResult.success(null);
    } on DioException catch (e) {
      return DataResult.failure(_mapDioError(e));
    } catch (e) {
      return DataResult.failure(e.toString());
    }
  }

  @override
  Future<DataResult<Map<String, dynamic>?>> getCurrentUser() async {
    try {
      final response = await _dio.get('$_authEndpoint/me');
      final userData = response.data as Map<String, dynamic>?;
      _currentUser = userData;
      return DataResult.success(userData);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return const DataResult.success(null);
      }
      return DataResult.failure(_mapDioError(e));
    } catch (e) {
      return DataResult.failure(e.toString());
    }
  }

  @override
  Future<DataResult<void>> sendPasswordResetEmail(String email) async {
    try {
      await _dio.post(
        '$_authEndpoint/password-reset',
        data: {'email': email},
      );
      return const DataResult.success(null);
    } on DioException catch (e) {
      return DataResult.failure(_mapDioError(e));
    } catch (e) {
      return DataResult.failure(e.toString());
    }
  }

  @override
  Stream<Map<String, dynamic>?> get authStateChanges => _authStateController.stream;

  String _mapDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timeout. Please try again.';
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final message = e.response?.data?['message'];
        if (statusCode == 401) {
          return message ?? 'Invalid credentials.';
        }
        if (statusCode == 404) {
          return message ?? 'User not found.';
        }
        if (statusCode == 409) {
          return message ?? 'User already exists.';
        }
        return message ?? 'Server error occurred.';
      case DioExceptionType.cancel:
        return 'Request was cancelled.';
      case DioExceptionType.connectionError:
        return 'No internet connection.';
      default:
        return e.message ?? 'An error occurred.';
    }
  }

  /// Disposes resources.
  void dispose() {
    _authStateController.close();
  }
}
