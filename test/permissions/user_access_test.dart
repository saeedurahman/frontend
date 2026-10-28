import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/permissions/permission_keys.dart';
import 'package:frantend/core/permissions/user_access.dart';
import 'package:frantend/features/auth/domain/utils/user_role_utils.dart';

import '../helpers/session_fixtures.dart';

void main() {
  group('UserAccess', () {
    test('owner is detected explicitly and may do everything', () {
      expect(ownerAccess.isOwner, isTrue);
      expect(ownerAccess.can(Perm.auditView), isTrue);
      expect(ownerAccess.can('anything.at.all'), isTrue);
    });

    test('owner detected from the roles list too', () {
      const access = UserAccess(role: '', roles: ['Owner']);
      expect(access.isOwner, isTrue);
    });

    test('empty permission list does NOT make a non-owner an owner', () {
      for (final role in ['manager', 'cashier', 'custom', '']) {
        final access = UserAccess(role: role, permissionKeys: const []);
        expect(access.isOwner, isFalse, reason: role);
        expect(access.can(Perm.salesCreate), isFalse, reason: role);
        expect(access.canAny([Perm.productsView, Perm.salesView]), isFalse);
      }
    });

    test('missing role is not an owner', () {
      expect(const UserAccess().can(Perm.productsView), isFalse);
      expect(UserAccess.none.isOwner, isFalse);
    });

    test('permission keys decide for everyone else', () {
      expect(cashierAccess.can(Perm.salesCreate), isTrue);
      expect(cashierAccess.can(Perm.returnsCreate), isFalse);
      expect(managerAccess.can(Perm.returnsCreate), isTrue);
      expect(managerAccess.can(Perm.rolesManage), isFalse);
    });
  });

  group('UserRoleUtils is permission-first', () {
    test('manager/owner role names are no shortcut for prices or reports', () {
      expect(UserRoleUtils.canManagePrices(role: 'manager'), isFalse);
      expect(UserRoleUtils.canViewReports(role: 'manager'), isFalse);
      expect(UserRoleUtils.canViewAuditLogs(role: 'manager'), isFalse);
    });

    test('keys grant exactly what they say', () {
      expect(
        UserRoleUtils.canManagePrices(
          role: 'cashier',
          permissionKeys: const [Perm.productsManagePrices],
        ),
        isTrue,
      );
      expect(
        UserRoleUtils.canViewReports(
          role: 'custom',
          permissionKeys: const [Perm.reportsView],
        ),
        isTrue,
      );
      expect(
        UserRoleUtils.canViewAuditLogs(
          role: 'custom',
          permissionKeys: const [Perm.auditView],
        ),
        isTrue,
      );
    });

    test('owner passes every helper with an empty key list', () {
      expect(UserRoleUtils.canManagePrices(role: 'owner'), isTrue);
      expect(UserRoleUtils.canViewReports(role: 'owner'), isTrue);
      expect(UserRoleUtils.canViewAuditLogs(role: 'owner'), isTrue);
      expect(UserRoleUtils.canVoidSales(role: 'owner'), isTrue);
    });

    test('non-owner with no keys fails every helper', () {
      expect(UserRoleUtils.canCreateSales(role: 'cashier'), isFalse);
      expect(UserRoleUtils.canViewUsers(role: 'manager'), isFalse);
      expect(UserRoleUtils.canAccessManufacturing(role: 'manager'), isFalse);
      expect(UserRoleUtils.canAccessAccounting(role: 'manager'), isFalse);
      expect(UserRoleUtils.isKitchenOnlyUser(role: 'manager'), isFalse);
    });

    test('can() / canAny() are the single entry points', () {
      expect(
        UserRoleUtils.can(
          Perm.salesVoid,
          role: 'x',
          permissionKeys: const [Perm.salesVoid],
        ),
        isTrue,
      );
      expect(
        UserRoleUtils.canAny(
          const [Perm.salesVoid, Perm.salesCancel],
          role: 'x',
          permissionKeys: const [Perm.salesCancel],
        ),
        isTrue,
      );
      expect(UserRoleUtils.can(Perm.salesVoid, role: 'x'), isFalse);
    });

    test('line tax edit needs price override or tax management', () {
      expect(
        UserRoleUtils.canEditLineTax(
          role: 'cashier',
          permissionKeys: cashierKeys,
        ),
        isFalse,
      );
      expect(
        UserRoleUtils.canEditLineTax(
          role: 'manager',
          permissionKeys: managerKeys,
        ),
        isTrue,
      );
    });
  });
}
