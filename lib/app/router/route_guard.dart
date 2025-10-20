// Guards protected routes based on authentication state.
import 'package:template_app/app/router/app_router.dart';
import 'package:template_app/services/session/session_manager.dart';

/// Ensures that users can only access authorized routes.
class RouteGuard {
  /// Creates a new [RouteGuard].
  RouteGuard({
    required SessionManager sessionManager,
    Iterable<String>? protectedRoutes,
  }) : _sessionManager = sessionManager,
       _protectedRoutes = Set<String>.from(
         protectedRoutes ?? const {AppRoutes.home, AppRoutes.settings},
       );

  final SessionManager _sessionManager;
  final Set<String> _protectedRoutes;

  /// Returns true when the route can be activated.
  bool canActivate(String routeName) {
    if (!_protectedRoutes.contains(routeName)) {
      return true;
    }
    return _sessionManager.currentUser != null;
  }
}
