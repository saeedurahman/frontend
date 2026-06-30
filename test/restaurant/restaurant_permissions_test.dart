import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/features/auth/domain/utils/user_role_utils.dart';

const _kitchenStaffKeys = [
  'auth.login',
  'auth.logout',
  'restaurant.kot.view',
  'restaurant.kot.update_status',
  'notifications.view',
];

const _cashierKeys = [
  'auth.login',
  'sales.create',
  'restaurant.kot.view',
  'restaurant.tables.view',
];

void main() {
  group('restaurant permission helpers', () {
    test('kitchen-only user lacks POS but has KOT', () {
      expect(
        UserRoleUtils.isKitchenOnlyUser(
          role: 'kitchen',
          permissionKeys: _kitchenStaffKeys,
        ),
        isTrue,
      );
      expect(
        UserRoleUtils.canCreateSales(
          role: 'kitchen',
          permissionKeys: _kitchenStaffKeys,
        ),
        isFalse,
      );
      expect(
        UserRoleUtils.canViewKot(
          role: 'kitchen',
          permissionKeys: _kitchenStaffKeys,
        ),
        isTrue,
      );
      expect(
        UserRoleUtils.canViewTables(
          role: 'kitchen',
          permissionKeys: _kitchenStaffKeys,
        ),
        isFalse,
      );
    });

    test('cashier with KOT is not kitchen-only', () {
      expect(
        UserRoleUtils.isKitchenOnlyUser(
          role: 'cashier',
          permissionKeys: _cashierKeys,
        ),
        isFalse,
      );
      expect(
        UserRoleUtils.canViewTables(
          role: 'cashier',
          permissionKeys: _cashierKeys,
        ),
        isTrue,
      );
    });
  });
}
