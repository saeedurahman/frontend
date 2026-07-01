import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/features/auth/domain/utils/user_role_utils.dart';
import 'package:frantend/features/restaurant/domain/entities/business_feature_flags.dart';

const _accountingViewKeys = [
  'accounting.coa.view',
  'accounting.journal.view',
];

void main() {
  group('accounting nav gating', () {
    test('hidden when feature flag is off', () {
      const flags = BusinessFeatureFlags(enableAccounting: false);
      expect(flags.showAccountingNav, isFalse);
    });

    test('hidden for cashier even when flag is on', () {
      const flags = BusinessFeatureFlags(enableAccounting: true);
      final showNav = flags.showAccountingNav &&
          UserRoleUtils.canAccessAccounting(
            role: 'cashier',
            permissionKeys: const [],
          );
      expect(showNav, isFalse);
    });

    test('visible for manager with journal view permission', () {
      const flags = BusinessFeatureFlags(enableAccounting: true);
      final showNav = flags.showAccountingNav &&
          UserRoleUtils.canAccessAccounting(
            role: 'manager',
            permissionKeys: _accountingViewKeys,
          );
      expect(showNav, isTrue);
    });

    test('owner passes without explicit keys when flag is on', () {
      const flags = BusinessFeatureFlags(enableAccounting: true);
      final showNav = flags.showAccountingNav &&
          UserRoleUtils.canAccessAccounting(role: 'owner');
      expect(showNav, isTrue);
    });
  });
}
