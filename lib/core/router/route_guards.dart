import 'package:flutter/foundation.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/router/kitchen_access_policy.dart';
import 'package:frantend/core/router/home_route_resolver.dart';
import 'package:frantend/core/router/route_names.dart';
import 'package:frantend/core/session/business_session_cubit.dart';
import 'package:frantend/core/storage/secure_storage.dart';
import 'package:frantend/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:frantend/features/auth/data/models/user_model.dart';
import 'package:frantend/features/auth/domain/utils/user_role_utils.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AuthGuard extends ChangeNotifier {
  AuthGuard(this._secureStorage);

  final SecureStorage _secureStorage;
  bool _isAuthenticated = false;
  UserModel? _cachedUser;

  bool get isAuthenticated => _isAuthenticated;

  String get homeRoute => HomeRouteResolver.resolve(
        user: _cachedUser,
        flags: sl<BusinessSessionCubit>().state.flags,
      );

  bool get isKitchenOnlyUser {
    final flags = sl<BusinessSessionCubit>().state.flags;
    if (!flags.showKitchenNav) return false;
    return UserRoleUtils.isKitchenOnlyUser(
      role: _cachedUser?.role,
      permissionKeys: _cachedUser?.permissionKeys ?? const [],
    );
  }

  Future<void> checkAuth() async {
    _isAuthenticated = await _secureStorage.hasValidSession();
    if (_isAuthenticated) {
      _cachedUser = await sl<AuthLocalDataSource>().getCachedUser();
    } else {
      _cachedUser = null;
    }
    notifyListeners();
  }

  Future<void> refreshSessionContext() async {
    if (_isAuthenticated) {
      _cachedUser = await sl<AuthLocalDataSource>().getCachedUser();
      notifyListeners();
    }
  }

  void setAuthenticated(bool value) {
    _isAuthenticated = value;
    if (!value) {
      _cachedUser = null;
    }
    notifyListeners();
  }

  String? redirect(String location) {
    final isPublicRoute = _publicRoutes.any(
      (route) => location == route || location.startsWith('$route/'),
    );

    if (!_isAuthenticated && !isPublicRoute) {
      return RouteNames.login;
    }

    if (_isAuthenticated && isKitchenOnlyUser) {
      final kitchenRedirect = KitchenAccessPolicy.redirectKitchenOnlyUser(
        isAuthenticated: _isAuthenticated,
        isKitchenOnly: isKitchenOnlyUser,
        location: location,
      );
      if (kitchenRedirect != null) return kitchenRedirect;
    }

    if (_isAuthenticated &&
        (location == RouteNames.login ||
            location == RouteNames.landing ||
            location == RouteNames.pinLogin)) {
      return homeRoute;
    }

    return null;
  }

  static bool _isKitchenRoute(String location) =>
      KitchenAccessPolicy.isKitchenRoute(location);

  static const List<String> _publicRoutes = [
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
}
