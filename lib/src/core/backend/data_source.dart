// Abstract interface for remote data sources.
// This abstraction allows switching between Firebase, REST API, etc.

/// Generic result wrapper for data operations.
class DataResult<T> {
  /// Creates a successful result.
  const DataResult.success(this.data)
      : error = null,
        isSuccess = true;

  /// Creates a failed result.
  const DataResult.failure(this.error)
      : data = null,
        isSuccess = false;

  /// The data if successful.
  final T? data;

  /// The error if failed.
  final String? error;

  /// Whether the operation succeeded.
  final bool isSuccess;

  /// Whether the operation failed.
  bool get isFailure => !isSuccess;
}

/// Abstract interface for authentication data source.
abstract class AuthDataSource {
  /// Signs in with email and password.
  Future<DataResult<Map<String, dynamic>>> signInWithEmail({
    required String email,
    required String password,
  });

  /// Creates a new user with email and password.
  Future<DataResult<Map<String, dynamic>>> createUserWithEmail({
    required String email,
    required String password,
  });

  /// Signs out the current user.
  Future<DataResult<void>> signOut();

  /// Gets the currently signed in user.
  Future<DataResult<Map<String, dynamic>?>> getCurrentUser();

  /// Sends a password reset email.
  Future<DataResult<void>> sendPasswordResetEmail(String email);

  /// Stream of auth state changes.
  Stream<Map<String, dynamic>?> get authStateChanges;
}

/// Abstract interface for document-based data source (like Firestore).
abstract class DocumentDataSource {
  /// Gets a single document by path.
  Future<DataResult<Map<String, dynamic>?>> getDocument(String path);

  /// Sets (creates or overwrites) a document.
  Future<DataResult<void>> setDocument(
    String path,
    Map<String, dynamic> data, {
    bool merge = false,
  });

  /// Updates specific fields in a document.
  Future<DataResult<void>> updateDocument(
    String path,
    Map<String, dynamic> data,
  );

  /// Deletes a document.
  Future<DataResult<void>> deleteDocument(String path);

  /// Gets all documents in a collection.
  Future<DataResult<List<Map<String, dynamic>>>> getCollection(
    String path, {
    List<QueryFilter>? filters,
    String? orderBy,
    bool descending = false,
    int? limit,
  });

  /// Adds a new document to a collection with auto-generated ID.
  Future<DataResult<String>> addDocument(
    String collectionPath,
    Map<String, dynamic> data,
  );

  /// Listens to real-time changes on a document.
  Stream<Map<String, dynamic>?> documentStream(String path);

  /// Listens to real-time changes on a collection.
  Stream<List<Map<String, dynamic>>> collectionStream(
    String path, {
    List<QueryFilter>? filters,
    String? orderBy,
    bool descending = false,
    int? limit,
  });
}

/// Filter for querying collections.
class QueryFilter {
  /// Creates a new [QueryFilter].
  const QueryFilter({
    required this.field,
    required this.operator,
    required this.value,
  });

  /// Creates an equality filter.
  factory QueryFilter.equals(String field, dynamic value) {
    return QueryFilter(field: field, operator: FilterOperator.equals, value: value);
  }

  /// Creates a greater than filter.
  factory QueryFilter.greaterThan(String field, dynamic value) {
    return QueryFilter(field: field, operator: FilterOperator.greaterThan, value: value);
  }

  /// Creates a less than filter.
  factory QueryFilter.lessThan(String field, dynamic value) {
    return QueryFilter(field: field, operator: FilterOperator.lessThan, value: value);
  }

  /// Creates an array contains filter.
  factory QueryFilter.arrayContains(String field, dynamic value) {
    return QueryFilter(field: field, operator: FilterOperator.arrayContains, value: value);
  }

  /// The field to filter on.
  final String field;

  /// The comparison operator.
  final FilterOperator operator;

  /// The value to compare against.
  final dynamic value;
}

/// Supported filter operators.
enum FilterOperator {
  equals,
  notEquals,
  greaterThan,
  greaterThanOrEquals,
  lessThan,
  lessThanOrEquals,
  arrayContains,
  arrayContainsAny,
  whereIn,
  whereNotIn,
}

/// Abstract interface for file storage.
abstract class StorageDataSource {
  /// Uploads a file and returns the download URL.
  Future<DataResult<String>> uploadFile(
    String path,
    List<int> bytes, {
    String? contentType,
  });

  /// Downloads a file as bytes.
  Future<DataResult<List<int>>> downloadFile(String path);

  /// Deletes a file.
  Future<DataResult<void>> deleteFile(String path);

  /// Gets the download URL for a file.
  Future<DataResult<String>> getDownloadUrl(String path);
}
