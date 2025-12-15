// Firebase Firestore implementation of DocumentDataSource.
import 'package:cloud_firestore/cloud_firestore.dart';

import '../data_source.dart';

/// Firebase Firestore implementation of [DocumentDataSource].
class FirebaseDocumentDataSource implements DocumentDataSource {
  /// Creates a new [FirebaseDocumentDataSource].
  FirebaseDocumentDataSource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  @override
  Future<DataResult<Map<String, dynamic>?>> getDocument(String path) async {
    try {
      final doc = await _firestore.doc(path).get();
      if (!doc.exists) {
        return const DataResult.success(null);
      }
      return DataResult.success({
        'id': doc.id,
        ...doc.data()!,
      });
    } on FirebaseException catch (e) {
      return DataResult.failure(e.message ?? 'Failed to get document');
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
      await _firestore.doc(path).set(data, SetOptions(merge: merge));
      return const DataResult.success(null);
    } on FirebaseException catch (e) {
      return DataResult.failure(e.message ?? 'Failed to set document');
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
      await _firestore.doc(path).update(data);
      return const DataResult.success(null);
    } on FirebaseException catch (e) {
      return DataResult.failure(e.message ?? 'Failed to update document');
    } catch (e) {
      return DataResult.failure(e.toString());
    }
  }

  @override
  Future<DataResult<void>> deleteDocument(String path) async {
    try {
      await _firestore.doc(path).delete();
      return const DataResult.success(null);
    } on FirebaseException catch (e) {
      return DataResult.failure(e.message ?? 'Failed to delete document');
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
      Query<Map<String, dynamic>> query = _firestore.collection(path);

      if (filters != null) {
        for (final filter in filters) {
          query = _applyFilter(query, filter);
        }
      }

      if (orderBy != null) {
        query = query.orderBy(orderBy, descending: descending);
      }

      if (limit != null) {
        query = query.limit(limit);
      }

      final snapshot = await query.get();
      final docs = snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          ...doc.data(),
        };
      }).toList();

      return DataResult.success(docs);
    } on FirebaseException catch (e) {
      return DataResult.failure(e.message ?? 'Failed to get collection');
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
      final docRef = await _firestore.collection(collectionPath).add(data);
      return DataResult.success(docRef.id);
    } on FirebaseException catch (e) {
      return DataResult.failure(e.message ?? 'Failed to add document');
    } catch (e) {
      return DataResult.failure(e.toString());
    }
  }

  @override
  Stream<Map<String, dynamic>?> documentStream(String path) {
    return _firestore.doc(path).snapshots().map((doc) {
      if (!doc.exists) return null;
      return {
        'id': doc.id,
        ...doc.data()!,
      };
    });
  }

  @override
  Stream<List<Map<String, dynamic>>> collectionStream(
    String path, {
    List<QueryFilter>? filters,
    String? orderBy,
    bool descending = false,
    int? limit,
  }) {
    Query<Map<String, dynamic>> query = _firestore.collection(path);

    if (filters != null) {
      for (final filter in filters) {
        query = _applyFilter(query, filter);
      }
    }

    if (orderBy != null) {
      query = query.orderBy(orderBy, descending: descending);
    }

    if (limit != null) {
      query = query.limit(limit);
    }

    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          ...doc.data(),
        };
      }).toList();
    });
  }

  Query<Map<String, dynamic>> _applyFilter(
    Query<Map<String, dynamic>> query,
    QueryFilter filter,
  ) {
    switch (filter.operator) {
      case FilterOperator.equals:
        return query.where(filter.field, isEqualTo: filter.value);
      case FilterOperator.notEquals:
        return query.where(filter.field, isNotEqualTo: filter.value);
      case FilterOperator.greaterThan:
        return query.where(filter.field, isGreaterThan: filter.value);
      case FilterOperator.greaterThanOrEquals:
        return query.where(filter.field, isGreaterThanOrEqualTo: filter.value);
      case FilterOperator.lessThan:
        return query.where(filter.field, isLessThan: filter.value);
      case FilterOperator.lessThanOrEquals:
        return query.where(filter.field, isLessThanOrEqualTo: filter.value);
      case FilterOperator.arrayContains:
        return query.where(filter.field, arrayContains: filter.value);
      case FilterOperator.arrayContainsAny:
        return query.where(filter.field, arrayContainsAny: filter.value as List);
      case FilterOperator.whereIn:
        return query.where(filter.field, whereIn: filter.value as List);
      case FilterOperator.whereNotIn:
        return query.where(filter.field, whereNotIn: filter.value as List);
    }
  }
}
