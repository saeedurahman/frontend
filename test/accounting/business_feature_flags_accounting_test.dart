import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/features/restaurant/domain/entities/business_feature_flags.dart';
import 'package:frantend/features/settings/data/models/business_config_model.dart';

void main() {
  group('BusinessFeatureFlags accounting', () {
    test('enable_accounting defaults false when config is null', () {
      expect(
        BusinessFeatureFlags.fromConfig(null),
        BusinessFeatureFlags.disabled,
      );
      expect(BusinessFeatureFlags.disabled.enableAccounting, isFalse);
      expect(BusinessFeatureFlags.disabled.showAccountingNav, isFalse);
    });

    test('prefers config_json over enable_accounting column', () {
      const config = BusinessConfigModel(
        id: 'cfg-1',
        businessId: 'biz-1',
        enableAccounting: true,
        configJson: {'enable_accounting': false},
      );

      final flags = BusinessFeatureFlags.fromConfig(config);
      expect(flags.enableAccounting, isFalse);
      expect(flags.showAccountingNav, isFalse);
    });

    test('falls back to enable_accounting column when config_json omits key', () {
      const config = BusinessConfigModel(
        id: 'cfg-1',
        businessId: 'biz-1',
        enableAccounting: true,
        configJson: {},
      );

      final flags = BusinessFeatureFlags.fromConfig(config);
      expect(flags.enableAccounting, isTrue);
      expect(flags.showAccountingNav, isTrue);
    });

    test('config_json string true enables accounting nav', () {
      const config = BusinessConfigModel(
        id: 'cfg-1',
        businessId: 'biz-1',
        configJson: {'enable_accounting': 'true'},
      );

      final flags = BusinessFeatureFlags.fromConfig(config);
      expect(flags.enableAccounting, isTrue);
      expect(flags.showAccountingNav, isTrue);
    });
  });
}
