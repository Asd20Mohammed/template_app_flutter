// Handles deep link parsing and navigation mapping.
class DeepLinkHandler {
  /// Creates a new [DeepLinkHandler].
  const DeepLinkHandler();

  /// Returns true when the handler understands the [link].
  bool canHandle(String link) {
    return link.startsWith('template://');
  }

  /// Resolves a deep link url to an internal route name.
  String resolve(String link) {
    if (!canHandle(link)) {
      return link;
    }
    final uri = Uri.parse(link);
    switch (uri.host) {
      case 'settings':
        return '/settings';
      case 'home':
        return '/home';
      default:
        return '/';
    }
  }
}
