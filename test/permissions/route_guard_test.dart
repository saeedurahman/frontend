import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/permissions/permission_keys.dart';
import 'package:frantend/core/permissions/route_permissions.dart';
import 'package:frantend/core/permissions/user_access.dart';
import 'package:frantend/core/router/route_access_policy.dart';
import 'package:frantend/core/router/route_guards.dart';
import 'package:frantend/core/router/route_names.dart';
import 'package:frantend/features/auth/data/models/user_model.dart';
import 'package:frantend/features/restaurant/domain/entities/business_feature_flags.dart';

import '../helpers/fake_http.dart';
import '../helpers/session_fixtures.dart';

String? redirectFor(
  String location,
  UserAccess access, {
  bool authenticated = true,
  bool blocked = false,
  bool kitchenOnly = false,
}) =>
    RouteAccessPolicy.redirect(
      location: location,
      isAuthenticated: authenticated,
      isSubscriptionBlocked: blocked,
      access: access,
      isKitchenOnly: kitchenOnly,
      homeRoute: RouteNames.dashboard,
    );

void main() {
  group('RoutePermissions table', () {
    test('most specific rule wins', () {
      expect(RoutePermissions.requiredFor('/products'), [Perm.productsView]);
      expect(RoutePermissions.requiredFor('/products/new'),
          [Perm.productsCreate]);
      expect(RoutePermissions.requiredFor('/products/abc/edit'),
          [Perm.productsUpdate]);
      expect(RoutePermissions.requiredFor('/purchases/9/receive'),
          [Perm.purchasesReceive]);
      expect(RoutePermissions.requiredFor('/sales/42/return'),
          [Perm.returnsCreate]);
      expect(RoutePermissions.requiredFor('/sales/42'), [Perm.salesView]);
    });

    test('every protected area is mapped (or explicitly open)', () {
      const areas = <String, String>{
        RouteNames.pos: 'sales',
        RouteNames.products: 'products',
        RouteNames.inventory: 'inventory',
        RouteNames.purchases: 'purchases',
        RouteNames.manufacturing: 'manufacturing',
        RouteNames.sales: 'sales',
        RouteNames.returns: 'returns',
        RouteNames.restaurantTables: 'restaurant',
        RouteNames.kitchen: 'restaurant',
        RouteNames.customers: 'customers',
        RouteNames.suppliers: 'suppliers',
        RouteNames.expenses: 'expenses',
        RouteNames.accounting: 'accounting',
        RouteNames.cashRegister: 'cash register',
        RouteNames.analytics: 'analytics',
        RouteNames.staff: 'staff',
        RouteNames.settingsRoles: 'roles',
        RouteNames.notifications: 'notifications',
        RouteNames.auditLogs: 'audit logs',
      };
      for (final route in areas.keys) {
        expect(RoutePermissions.requiredFor(route), isNotNull,
            reason: '${areas[route]} ($route) must require a permission');
      }
      for (final open in RoutePermissions.openRoutes) {
        expect(RoutePermissions.requiredFor(open), isNull, reason: open);
      }
    });

    test('settings account pages stay open to every signed-in user', () {
      expect(RoutePermissions.requiredFor(RouteNames.settings), isNull);
      expect(RoutePermissions.requiredFor(RouteNames.changePassword), isNull);
      expect(
          RoutePermissions.requiredFor(RouteNames.settingsSubscription), isNull);
      expect(RoutePermissions.requiredFor(RouteNames.settingsRoles),
          [Perm.rolesManage]);
    });
  });

  group('RouteAccessPolicy.redirect', () {
    test('signed out: public pages open, everything else -> login', () {
      expect(redirectFor('/login', UserAccess.none, authenticated: false),
          isNull);
      expect(redirectFor('/register/step1', UserAccess.none,
          authenticated: false), isNull);
      expect(redirectFor('/products', UserAccess.none, authenticated: false),
          RouteNames.login);
      expect(
        redirectFor(RouteNames.subscriptionExpired, UserAccess.none,
            authenticated: false),
        RouteNames.login,
      );
    });

    test('cashier: allowed pages pass, others land on No access (not login)',
        () {
      expect(redirectFor('/pos', cashierAccess), isNull);
      expect(redirectFor('/products', cashierAccess), isNull);
      final denied = redirectFor('/returns', cashierAccess);
      expect(denied, startsWith(RouteNames.noAccess));
      expect(denied, isNot(contains('login')));
    });

    test('deep links and typed URLs are checked like menu clicks', () {
      expect(redirectFor('/products/123/edit', cashierAccess),
          startsWith(RouteNames.noAccess));
      expect(redirectFor('/products/123/edit', managerAccess), isNull);
      expect(redirectFor('/audit-logs', managerAccess),
          startsWith(RouteNames.noAccess));
      expect(redirectFor('/audit-logs', ownerAccess), isNull);
      expect(redirectFor('/settings/roles/new', managerAccess),
          startsWith(RouteNames.noAccess));
      expect(redirectFor('/settings/roles/new', ownerAccess), isNull);
      expect(redirectFor('/sales/9/return?x=1', cashierAccess),
          startsWith(RouteNames.noAccess));
    });

    test('custom role sees only what its keys allow', () {
      expect(redirectFor('/inventory', customAccess), isNull);
      expect(redirectFor('/products', customAccess), isNull);
      expect(redirectFor('/sales', customAccess),
          startsWith(RouteNames.noAccess));
      expect(redirectFor('/dashboard', customAccess), isNull);
      expect(redirectFor('/settings', customAccess), isNull);
    });

    test('a non-owner with no permissions is denied everywhere but open pages',
        () {
      const nothing = UserAccess(role: 'manager');
      expect(redirectFor('/dashboard', nothing), isNull);
      expect(redirectFor('/settings/change-password', nothing), isNull);
      expect(redirectFor('/products', nothing),
          startsWith(RouteNames.noAccess));
    });

    test('No access page returns the user once access is granted', () {
      final from = Uri.encodeQueryComponent('/returns');
      final target = '${RouteNames.noAccess}?from=$from';
      expect(redirectFor(target, cashierAccess), isNull);
      expect(redirectFor(target, managerAccess), '/returns');
    });

    test('No access page cannot be used to bounce into a forbidden page', () {
      final target =
          '${RouteNames.noAccess}?from=${Uri.encodeQueryComponent('//evil')}';
      expect(redirectFor(target, managerAccess), isNull);
    });

    test('blocked subscription: only /subscription-expired is reachable', () {
      for (final path in ['/dashboard', '/pos', '/products', '/settings',
          RouteNames.noAccess, RouteNames.login]) {
        expect(redirectFor(path, ownerAccess, blocked: true),
            RouteNames.subscriptionExpired,
            reason: path);
      }
      expect(
        redirectFor(RouteNames.subscriptionExpired, ownerAccess, blocked: true),
        isNull,
      );
    });

    test('active subscription: the expired page sends the user home', () {
      expect(redirectFor(RouteNames.subscriptionExpired, ownerAccess),
          RouteNames.dashboard);
    });

    test('logged-in users are moved off login/landing', () {
      expect(redirectFor('/login', cashierAccess), RouteNames.dashboard);
      expect(redirectFor('/landing', cashierAccess), RouteNames.dashboard);
    });

    test('kitchen-only staff stay on the kitchen display', () {
      expect(redirectFor('/pos', cashierAccess, kitchenOnly: true),
          RouteNames.kitchen);
      const kitchen = UserAccess(
        role: 'kitchen',
        permissionKeys: [Perm.kotView, Perm.kotUpdateStatus],
      );
      expect(redirectFor('/kitchen', kitchen, kitchenOnly: true), isNull);
      expect(redirectFor('/kitchen', cashierAccess),
          startsWith(RouteNames.noAccess));
    });
  });

  group('AuthGuard', () {
    late AuthGuard guard;

    setUp(() {
      guard = AuthGuard(FakeSecureStorage(access: 'a'));
      guard.flagsProvider = () => BusinessFeatureFlags.disabled;
      guard.setAuthenticated(true);
    });

    UserModel model(String role, List<String> keys) => UserModel(
          id: '1',
          name: 'n',
          role: role,
          roles: [role],
          permissionKeys: keys,
        );

    test('live permission update re-routes and notifies the router', () {
      var notified = 0;
      guard.addListener(() => notified++);

      guard.updateUser(model('cashier', cashierKeys));
      expect(guard.redirect('/returns'), startsWith(RouteNames.noAccess));

      // An admin grants returns mid-session.
      guard.updateUser(model('cashier', [...cashierKeys, Perm.returnsView]));
      expect(guard.redirect('/returns'), isNull);
      expect(notified, 2);
    });

    test('subscription block gates the whole router and clears on logout', () {
      guard.updateUser(model('owner', const []));
      expect(guard.redirect('/pos'), isNull);

      guard.setSubscriptionBlocked(true);
      expect(guard.redirect('/pos'), RouteNames.subscriptionExpired);
      expect(guard.redirect(RouteNames.subscriptionExpired), isNull);

      guard.setSubscriptionBlocked(false);
      expect(guard.redirect(RouteNames.subscriptionExpired),
          RouteNames.dashboard);

      guard.setSubscriptionBlocked(true);
      guard.setAuthenticated(false);
      expect(guard.isSubscriptionBlocked, isFalse);
      expect(guard.redirect('/pos'), RouteNames.login);
    });

    test('unknown user (cache empty) is denied until permissions arrive', () {
      expect(guard.redirect('/products'), startsWith(RouteNames.noAccess));
      expect(guard.redirect('/dashboard'), isNull);
    });
  });
}
