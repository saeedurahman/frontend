import 'package:frantend/core/router/route_names.dart';

/// Route access rules for kitchen-only staff (testable without DI).
abstract final class KitchenAccessPolicy {
  static bool isKitchenRoute(String location) {
    return location == RouteNames.kitchen ||
        location.startsWith('${RouteNames.kitchen}/');
  }

  /// Returns `/kitchen` when a kitchen-only user hits a non-kitchen protected route.
  static String? redirectKitchenOnlyUser({
    required bool isAuthenticated,
    required bool isKitchenOnly,
    required String location,
  }) {
    if (!isAuthenticated || !isKitchenOnly) return null;
    if (isKitchenRoute(location)) return null;
    return RouteNames.kitchen;
  }
}
