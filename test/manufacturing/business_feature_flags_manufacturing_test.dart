import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/features/restaurant/domain/entities/business_feature_flags.dart';
import 'package:frantend/features/settings/data/models/business_config_model.dart';

void main() {
  group('BusinessFeatureFlags manufacturing', () {
    test('enable_manufacturing defaults false when config is null', () {
      expect(
        BusinessFeatureFlags.fromConfig(null),
        BusinessFeatureFlags.disabled,
      );
      expect(BusinessFeatureFlags.disabled.enableManufacturing, isFalse);
      expect(BusinessFeatureFlags.disabled.showManufacturingNav, isFalse);
    });

    test('prefers config_json over enable_manufacturing column', () {
      const config = BusinessConfigModel(
        id: 'cfg-1',
        businessId: 'biz-1',
        enableManufacturing: true,
        configJson: {'enable_manufacturing': false},
      );

      final flags = BusinessFeatureFlags.fromConfig(config);
      expect(flags.enableManufacturing, isFalse);
      expect(flags.showManufacturingNav, isFalse);
    });

    test('falls back to enable_manufacturing column when config_json omits key', () {
      const config = BusinessConfigModel(
        id: 'cfg-1',
        businessId: 'biz-1',
        enableManufacturing: true,
        configJson: {},
      );

      final flags = BusinessFeatureFlags.fromConfig(config);
      expect(flags.enableManufacturing, isTrue);
      expect(flags.showManufacturingNav, isTrue);
    });

    test('config_json string true enables manufacturing nav', () {
      const config = BusinessConfigModel(
        id: 'cfg-1',
        businessId: 'biz-1',
        configJson: {'enable_manufacturing': 'true'},
      );

      final flags = BusinessFeatureFlags.fromConfig(config);
      expect(flags.enableManufacturing, isTrue);
      expect(flags.showManufacturingNav, isTrue);
    });
  });
}
