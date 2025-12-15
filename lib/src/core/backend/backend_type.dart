// Defines the available backend types for the application.

/// Enum representing supported backend implementations.
enum BackendType {
  /// Firebase backend (Firestore, Firebase Auth, etc.)
  firebase,

  /// REST API backend (custom server)
  restApi,

  /// Offline/Local storage only
  offline,

  /// GraphQL backend
  graphql,

  /// Supabase backend
  supabase,
}
