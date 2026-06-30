import 'package:frantend/core/router/route_names.dart';
import 'package:frantend/features/auth/data/models/user_model.dart';
import 'package:frantend/features/auth/domain/utils/user_role_utils.dart';
import 'package:frantend/features/restaurant/domain/entities/business_feature_flags.dart';

/// Resolves the post-login landing route from cached user + business flags.
abstract final class HomeRouteResolver {
  static String resolve({
    required UserModel? user,
    required BusinessFeatureFlags flags,
  }) {
    if (flags.showKitchenNav &&
        UserRoleUtils.isKitchenOnlyUser(
          role: user?.role,
          permissionKeys: user?.permissionKeys ?? const [],
        )) {
      return RouteNames.kitchen;
    }
    return RouteNames.dashboard;
  }
}
