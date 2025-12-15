// REST API implementation of DocumentDataSource.
import 'dart:async';

import 'package:dio/dio.dart';

import '../data_source.dart';

/// REST API implementation of [DocumentDataSource].
class RestDocumentDataSource implements DocumentDataSource {
  /// Creates a new [RestDocumentDataSource].
  RestDocumentDataSource({required Dio dio}) : _dio = dio;

  final Dio _dio;

  @override
  Future<DataResult<Map<String, dynamic>?>> getDocument(String path) async {
    try {
      final response = await _dio.get('/$path');
      return DataResult.success(response.data as Map<String, dynamic>?);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return const DataResult.success(null);
      }
      return DataResult.failure(_mapDioError(e));
    } catch (e) {
      return DataResult.failure(e.toString());
    }
  }

  @override
  Future<DataResult<void>> setDocument(
    String path,
    Map<String, dynamic> data, {
    bool merge = false,
  }) async {
    try {
      if (merge) {
        await _dio.patch('/$path', data: data);
      } else {
        await _dio.put('/$path', data: data);
      }
      return const DataResult.success(null);
    } on DioException catch (e) {
      return DataResult.failure(_mapDioError(e));
    } catch (e) {
      return DataResult.failure(e.toString());
    }
  }

  @override
  Future<DataResult<void>> updateDocument(
    String path,
    Map<String, dynamic> data,
  ) async {
    try {
      await _dio.patch('/$path', data: data);
      return const DataResult.success(null);
    } on DioException catch (e) {
      return DataResult.failure(_mapDioError(e));
    } catch (e) {
      return DataResult.failure(e.toString());
    }
  }

  @override
  Future<DataResult<void>> deleteDocument(String path) async {
    try {
      await _dio.delete('/$path');
      return const DataResult.success(null);
    } on DioException catch (e) {
      return DataResult.failure(_mapDioError(e));
    } catch (e) {
      return DataResult.failure(e.toString());
    }
  }

  @override
  Future<DataResult<List<Map<String, dynamic>>>> getCollection(
    String path, {
    List<QueryFilter>? filters,
    String? orderBy,
    bool descending = false,
    int? limit,
  }) async {
    try {
      final queryParams = <String, dynamic>{};

      if (filters != null) {
        for (final filter in filters) {
          queryParams['filter[${filter.field}][${filter.operator.name}]'] =
              filter.value;
        }
      }

      if (orderBy != null) {
        queryParams['orderBy'] = orderBy;
        queryParams['order'] = descending ? 'desc' : 'asc';
      }

      if (limit != null) {
        queryParams['limit'] = limit;
      }

      final response = await _dio.get(
        '/$path',
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );

      final data = response.data;
      if (data is List) {
        return DataResult.success(
          data.map((e) => e as Map<String, dynamic>).toList(),
        );
      }

      return const DataResult.success([]);
    } on DioException catch (e) {
      return DataResult.failure(_mapDioError(e));
    } catch (e) {
      return DataResult.failure(e.toString());
    }
  }

  @override
  Future<DataResult<String>> addDocument(
    String collectionPath,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _dio.post('/$collectionPath', data: data);
      final id = response.data?['id']?.toString() ?? '';
      return DataResult.success(id);
    } on DioException catch (e) {
      return DataResult.failure(_mapDioError(e));
    } catch (e) {
      return DataResult.failure(e.toString());
    }
  }

  @override
  Stream<Map<String, dynamic>?> documentStream(String path) {
    // REST APIs typically don't support real-time streams
    // Return a single-value stream from current data
    return Stream.fromFuture(getDocument(path).then((result) => result.data));
  }

  @override
  Stream<List<Map<String, dynamic>>> collectionStream(
    String path, {
    List<QueryFilter>? filters,
    String? orderBy,
    bool descending = false,
    int? limit,
  }) {
    // REST APIs typically don't support real-time streams
    return Stream.fromFuture(
      getCollection(
        path,
        filters: filters,
        orderBy: orderBy,
        descending: descending,
        limit: limit,
      ).then((result) => result.data ?? []),
    );
  }

  String _mapDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timeout. Please try again.';
      case DioExceptionType.badResponse:
        final message = e.response?.data?['message'];
        return message ?? 'Server error occurred.';
      case DioExceptionType.cancel:
        return 'Request was cancelled.';
      case DioExceptionType.connectionError:
        return 'No internet connection.';
      default:
        return e.message ?? 'An error occurred.';
    }
  }
}
