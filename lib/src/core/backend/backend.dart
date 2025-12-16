// Barrel file for backend abstraction layer.
// This layer allows switching between different backend implementations.

// Core abstractions
export 'backend_config.dart';
export 'backend_module.dart';
export 'backend_type.dart';
export 'data_source.dart';

// Firebase implementations
export 'firebase/firebase_auth_data_source.dart';
export 'firebase/firebase_document_data_source.dart';
export 'firebase/firebase_initializer.dart';
export 'firebase/firebase_storage_data_source.dart';

// REST API implementations
export 'rest/rest_auth_data_source.dart';
export 'rest/rest_document_data_source.dart';
