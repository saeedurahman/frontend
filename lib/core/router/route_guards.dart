import 'package:flutter/foundation.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/permissions/user_access.dart';
import 'package:frantend/core/router/home_route_resolver.dart';
import 'package:frantend/core/router/route_access_policy.dart';
import 'package:frantend/core/session/business_session_cubit.dart';
import 'package:frantend/core/storage/secure_storage.dart';
import 'package:frantend/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:frantend/features/auth/data/models/user_model.dart';
import 'package:frantend/features/auth/domain/utils/user_role_utils.dart';
import 'package:frantend/features/restaurant/domain/entities/business_feature_flags.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AuthGuard extends ChangeNotifier {
  AuthGuard(this._secureStorage);

  final SecureStorage _secureStorage;
  bool _isAuthenticated = false;
  bool _subscriptionBlocked = false;
  UserModel? _cachedUser;

  /// Business feature flags; overridable so the guard can be tested without DI.
  @visibleForTesting
  BusinessFeatureFlags Function() flagsProvider =
      () => sl<BusinessSessionCubit>().state.flags;

  bool get isAuthenticated => _isAuthenticated;
  bool get isSubscriptionBlocked => _subscriptionBlocked;

  UserAccess get access => _cachedUser == null
      ? UserAccess.none
      : UserAccess(
          role: _cachedUser!.role,
          roles: _cachedUser!.roles,
          permissionKeys: _cachedUser!.permissionKeys,
        );

  String get homeRoute => HomeRouteResolver.resolve(
        user: _cachedUser,
        flags: flagsProvider(),
      );

  bool get isKitchenOnlyUser {
    if (!flagsProvider().showKitchenNav) return false;
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
      _subscriptionBlocked = false;
    }
    notifyListeners();
  }

  Future<void> refreshSessionContext() async {
    if (_isAuthenticated) {
      _cachedUser = await sl<AuthLocalDataSource>().getCachedUser();
      notifyListeners();
    }
  }

  /// Installs the live user (fresh permissions) and re-runs the route guard,
  /// so a page the user just lost access to closes at once.
  void updateUser(UserModel user) {
    if (!_isAuthenticated) return;
    _cachedUser = user;
    notifyListeners();
  }

  /// Subscription gate: while blocked only `/subscription-expired` is open.
  void setSubscriptionBlocked(bool value) {
    if (_subscriptionBlocked == value) return;
    _subscriptionBlocked = value;
    notifyListeners();
  }

  void setAuthenticated(bool value) {
    _isAuthenticated = value;
    if (!value) {
      _cachedUser = null;
      _subscriptionBlocked = false;
    }
    notifyListeners();
  }

  String? redirect(String location) => RouteAccessPolicy.redirect(
        location: location,
        isAuthenticated: _isAuthenticated,
        isSubscriptionBlocked: _subscriptionBlocked,
        access: access,
        isKitchenOnly: _isAuthenticated && isKitchenOnlyUser,
        homeRoute: homeRoute,
      );
}
