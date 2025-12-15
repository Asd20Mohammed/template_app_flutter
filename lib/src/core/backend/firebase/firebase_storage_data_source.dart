// Firebase Storage implementation of StorageDataSource.
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

import '../data_source.dart';

/// Firebase Storage implementation of [StorageDataSource].
class FirebaseStorageDataSource implements StorageDataSource {
  /// Creates a new [FirebaseStorageDataSource].
  FirebaseStorageDataSource({FirebaseStorage? storage})
      : _storage = storage ?? FirebaseStorage.instance;

  final FirebaseStorage _storage;

  @override
  Future<DataResult<String>> uploadFile(
    String path,
    List<int> bytes, {
    String? contentType,
  }) async {
    try {
      final ref = _storage.ref(path);
      final metadata = contentType != null
          ? SettableMetadata(contentType: contentType)
          : null;

      await ref.putData(Uint8List.fromList(bytes), metadata);
      final downloadUrl = await ref.getDownloadURL();

      return DataResult.success(downloadUrl);
    } on FirebaseException catch (e) {
      return DataResult.failure(e.message ?? 'Failed to upload file');
    } catch (e) {
      return DataResult.failure(e.toString());
    }
  }

  @override
  Future<DataResult<List<int>>> downloadFile(String path) async {
    try {
      final ref = _storage.ref(path);
      final data = await ref.getData();

      if (data == null) {
        return const DataResult.failure('File not found');
      }

      return DataResult.success(data.toList());
    } on FirebaseException catch (e) {
      return DataResult.failure(e.message ?? 'Failed to download file');
    } catch (e) {
      return DataResult.failure(e.toString());
    }
  }

  @override
  Future<DataResult<void>> deleteFile(String path) async {
    try {
      await _storage.ref(path).delete();
      return const DataResult.success(null);
    } on FirebaseException catch (e) {
      return DataResult.failure(e.message ?? 'Failed to delete file');
    } catch (e) {
      return DataResult.failure(e.toString());
    }
  }

  @override
  Future<DataResult<String>> getDownloadUrl(String path) async {
    try {
      final url = await _storage.ref(path).getDownloadURL();
      return DataResult.success(url);
    } on FirebaseException catch (e) {
      return DataResult.failure(e.message ?? 'Failed to get download URL');
    } catch (e) {
      return DataResult.failure(e.toString());
    }
  }
}
