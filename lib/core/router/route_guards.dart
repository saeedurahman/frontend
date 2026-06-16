import 'package:flutter/foundation.dart';
import 'package:frantend/core/router/route_names.dart';
import 'package:frantend/core/storage/secure_storage.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AuthGuard extends ChangeNotifier {
  AuthGuard(this._secureStorage);

  final SecureStorage _secureStorage;
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;

  Future<void> checkAuth() async {
    _isAuthenticated = await _secureStorage.hasValidSession();
    notifyListeners();
  }

  void setAuthenticated(bool value) {
    _isAuthenticated = value;
    notifyListeners();
  }

  String? redirect(String location) {
    final isPublicRoute = _publicRoutes.any(
      (route) => location == route || location.startsWith('$route/'),
    );

    if (!_isAuthenticated && !isPublicRoute) {
      return RouteNames.login;
    }

    if (_isAuthenticated &&
        (location == RouteNames.login ||
            location == RouteNames.landing ||
            location == RouteNames.pinLogin)) {
      return RouteNames.dashboard;
    }

    return null;
  }

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
