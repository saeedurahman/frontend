import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/features/auth/domain/utils/user_role_utils.dart';
import 'package:frantend/features/restaurant/domain/entities/business_feature_flags.dart';

const _manufacturingKeys = [
  'manufacturing.bom.view',
  'manufacturing.production.view',
];

void main() {
  group('manufacturing nav gating', () {
    test('hidden when feature flag is off', () {
      const flags = BusinessFeatureFlags(enableManufacturing: false);
      expect(flags.showManufacturingNav, isFalse);
    });

    test('hidden for cashier even when flag is on', () {
      const flags = BusinessFeatureFlags(enableManufacturing: true);
      final showNav = flags.showManufacturingNav &&
          UserRoleUtils.canAccessManufacturing(
            role: 'cashier',
            permissionKeys: const [],
          );
      expect(showNav, isFalse);
    });

    test('visible for manager with production view permission', () {
      const flags = BusinessFeatureFlags(enableManufacturing: true);
      final showNav = flags.showManufacturingNav &&
          UserRoleUtils.canAccessManufacturing(
            role: 'manager',
            permissionKeys: _manufacturingKeys,
          );
      expect(showNav, isTrue);
    });

    test('owner passes without explicit keys when flag is on', () {
      const flags = BusinessFeatureFlags(enableManufacturing: true);
      final showNav = flags.showManufacturingNav &&
          UserRoleUtils.canAccessManufacturing(role: 'owner');
      expect(showNav, isTrue);
    });
  });
}
