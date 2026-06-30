import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/features/auth/domain/utils/user_role_utils.dart';

/// Mirrors backend CASHIER_PERMISSION_KEYS from role_permission_seed.py.
const _cashierKeys = [
  'auth.login',
  'auth.logout',
  'auth.refresh',
  'products.view',
  'inventory.view',
  'sales.view',
  'sales.create',
  'sales.payments.view',
  'discounts.view',
  'customers.view',
  'customers.create',
  'registers.view',
  'shifts.open',
  'shifts.close',
  'shifts.cash_movement',
  'notifications.view',
];

const _managerExtraKeys = [
  'sales.returns.view',
  'sales.returns.create',
  'sales.cancel',
  'shifts.view',
  'users.roles.manage',
];

void main() {
  group('cashier permission seed', () {
    test('cashier can create sales and open/close shifts', () {
      expect(
        UserRoleUtils.canCreateSales(role: 'cashier', permissionKeys: _cashierKeys),
        isTrue,
      );
      expect(
        UserRoleUtils.canOpenShift(role: 'cashier', permissionKeys: _cashierKeys),
        isTrue,
      );
      expect(
        UserRoleUtils.canCloseShift(role: 'cashier', permissionKeys: _cashierKeys),
        isTrue,
      );
    });

    test('cashier cannot view shifts, process returns, cancel, or manage roles', () {
      expect(
        UserRoleUtils.canViewShifts(role: 'cashier', permissionKeys: _cashierKeys),
        isFalse,
      );
      expect(
        UserRoleUtils.canCreateReturns(role: 'cashier', permissionKeys: _cashierKeys),
        isFalse,
      );
      expect(
        UserRoleUtils.canCancelSales(role: 'cashier', permissionKeys: _cashierKeys),
        isFalse,
      );
      expect(
        UserRoleUtils.canManageRoles(role: 'cashier', permissionKeys: _cashierKeys),
        isFalse,
      );
    });
  });

  group('manager-style permissions', () {
    final keys = [..._cashierKeys, ..._managerExtraKeys];

    test('manager permissions unlock gated screens', () {
      expect(
        UserRoleUtils.canViewShifts(role: 'manager', permissionKeys: keys),
        isTrue,
      );
      expect(
        UserRoleUtils.canCreateReturns(role: 'manager', permissionKeys: keys),
        isTrue,
      );
      expect(
        UserRoleUtils.canCancelSales(role: 'manager', permissionKeys: keys),
        isTrue,
      );
      expect(
        UserRoleUtils.canManageRoles(role: 'manager', permissionKeys: keys),
        isTrue,
      );
    });
  });

  group('empty permission keys owner fallback', () {
    test('owner role passes when permission_keys empty (legacy cache)', () {
      expect(UserRoleUtils.canCreateSales(role: 'owner'), isTrue);
      expect(UserRoleUtils.canViewShifts(role: 'owner'), isTrue);
      expect(UserRoleUtils.canManageRoles(role: 'owner'), isTrue);
    });

    test('cashier role fails when permission_keys empty', () {
      expect(UserRoleUtils.canCreateSales(role: 'cashier'), isFalse);
      expect(UserRoleUtils.canViewShifts(role: 'cashier'), isFalse);
    });
  });
}
