import 'package:frantend/core/permissions/route_permissions.dart';
import 'package:frantend/core/permissions/user_access.dart';
import 'package:frantend/core/router/kitchen_access_policy.dart';
import 'package:frantend/core/router/route_names.dart';

/// Pure redirect rules for the router (no DI, so they are unit-testable).
///
/// Order matters:
/// 1. Signed out: only the public pages.
/// 2. Subscription blocked: only `/subscription-expired` (logout is an action
///    on that page, not a route).
/// 3. Kitchen-only staff stay on the kitchen display.
/// 4. Everything else needs the permission mapped in [RoutePermissions];
///    without it the user lands on "No access" (never logged out).
abstract final class RouteAccessPolicy {
  static const publicRoutes = <String>[
    RouteNames.landing,
    RouteNames.login,
    RouteNames.pinLogin,
    RouteNames.register,
    RouteNames.registerStep1,
    RouteNames.registerStep2,
    RouteNames.registerStep3,
    RouteNames.registerStep4,
    RouteNames.registerSuccess,
  ];

  static bool isPublic(String location) => publicRoutes.any(
        (route) => location == route || location.startsWith('$route/'),
      );

  static String? redirect({
    required String location,
    required bool isAuthenticated,
    required bool isSubscriptionBlocked,
    required UserAccess access,
    required bool isKitchenOnly,
    required String homeRoute,
  }) {
    final uri = Uri.tryParse(location);
    final path = uri?.path ?? location;

    if (!isAuthenticated) {
      return isPublic(path) ? null : RouteNames.login;
    }

    if (isSubscriptionBlocked) {
      return path == RouteNames.subscriptionExpired
          ? null
          : RouteNames.subscriptionExpired;
    }
    if (path == RouteNames.subscriptionExpired) return homeRoute;

    final kitchenRedirect = KitchenAccessPolicy.redirectKitchenOnlyUser(
      isAuthenticated: isAuthenticated,
      isKitchenOnly: isKitchenOnly,
      location: path,
    );
    if (kitchenRedirect != null) return kitchenRedirect;

    if (path == RouteNames.login ||
        path == RouteNames.landing ||
        path == RouteNames.pinLogin) {
      return homeRoute;
    }

    if (path == RouteNames.noAccess) {
      // Permissions can arrive (or be granted) after the redirect: go back to
      // where the user was headed as soon as it is allowed.
      final from = uri?.queryParameters['from'];
      if (from != null &&
          from.startsWith('/') &&
          !from.startsWith('//') &&
          from != RouteNames.noAccess &&
          RoutePermissions.isAllowed(from, access.can)) {
        return from;
      }
      return null;
    }
    if (!RoutePermissions.isAllowed(path, access.can)) {
      return noAccessFor(path);
    }
    return null;
  }

  /// `/no-access?from=<blocked path>`.
  static String noAccessFor(String blockedPath) =>
      '${RouteNames.noAccess}?from=${Uri.encodeQueryComponent(blockedPath)}';
}
