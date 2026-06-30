import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/router/home_route_resolver.dart';
import 'package:frantend/core/router/kitchen_access_policy.dart';
import 'package:frantend/core/router/route_names.dart';
import 'package:frantend/features/auth/data/models/user_model.dart';
import 'package:frantend/features/restaurant/domain/entities/business_feature_flags.dart';
import 'package:frantend/features/restaurant/presentation/utils/kot_status_utils.dart';

const _kitchenStaffKeys = [
  'restaurant.kot.view',
  'restaurant.kot.update_status',
];

void main() {
  group('HomeRouteResolver', () {
    const kitchenUser = UserModel(
      id: 'u1',
      businessId: 'b1',
      name: 'Kitchen Staff',
      role: 'kitchen',
      permissionKeys: _kitchenStaffKeys,
    );

    const cashierUser = UserModel(
      id: 'u2',
      businessId: 'b1',
      name: 'Cashier',
      role: 'cashier',
      permissionKeys: ['sales.create', 'restaurant.kot.view'],
    );

    const enabledFlags = BusinessFeatureFlags(
      enableRestaurant: true,
      enableKot: true,
    );

    test('kitchen-only staff land on /kitchen when KOT enabled', () {
      expect(
        HomeRouteResolver.resolve(user: kitchenUser, flags: enabledFlags),
        RouteNames.kitchen,
      );
    });

    test('cashier lands on dashboard', () {
      expect(
        HomeRouteResolver.resolve(user: cashierUser, flags: enabledFlags),
        RouteNames.dashboard,
      );
    });

    test('kitchen-only with KOT disabled lands on dashboard', () {
      expect(
        HomeRouteResolver.resolve(
          user: kitchenUser,
          flags: BusinessFeatureFlags.disabled,
        ),
        RouteNames.dashboard,
      );
    });
  });

  group('KotStatusUtils', () {
    test('advances pending through served', () {
      expect(KotStatusUtils.nextStatus('pending'), 'preparing');
      expect(KotStatusUtils.nextStatus('preparing'), 'ready');
      expect(KotStatusUtils.nextStatus('ready'), 'served');
      expect(KotStatusUtils.nextStatus('served'), isNull);
    });
  });

  group('KitchenAccessPolicy', () {
    test('kitchen-only user on /pos redirects to /kitchen', () {
      expect(
        KitchenAccessPolicy.redirectKitchenOnlyUser(
          isAuthenticated: true,
          isKitchenOnly: true,
          location: RouteNames.pos,
        ),
        RouteNames.kitchen,
      );
    });

    test('kitchen-only user on /kitchen is not redirected', () {
      expect(
        KitchenAccessPolicy.redirectKitchenOnlyUser(
          isAuthenticated: true,
          isKitchenOnly: true,
          location: RouteNames.kitchen,
        ),
        isNull,
      );
    });

    test('cashier on /pos is not redirected', () {
      expect(
        KitchenAccessPolicy.redirectKitchenOnlyUser(
          isAuthenticated: true,
          isKitchenOnly: false,
          location: RouteNames.pos,
        ),
        isNull,
      );
    });
  });
}
