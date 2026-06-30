import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/features/restaurant/domain/entities/business_feature_flags.dart';
import 'package:frantend/features/settings/data/models/business_config_model.dart';

void main() {
  group('BusinessFeatureFlags.fromConfig', () {
    test('returns all disabled when config is null', () {
      expect(
        BusinessFeatureFlags.fromConfig(null),
        BusinessFeatureFlags.disabled,
      );
    });

    test('prefers config_json over boolean columns', () {
      const config = BusinessConfigModel(
        id: 'cfg-1',
        businessId: 'biz-1',
        enableRestaurant: true,
        enableKot: true,
        configJson: {
          'enable_restaurant': false,
          'enable_table_management': true,
          'enable_kot': false,
        },
      );

      final flags = BusinessFeatureFlags.fromConfig(config);
      expect(flags.enableRestaurant, isFalse);
      expect(flags.enableTableManagement, isTrue);
      expect(flags.enableKot, isFalse);
      expect(flags.showTablesNav, isFalse);
      expect(flags.showKitchenNav, isFalse);
    });

    test('falls back to boolean columns when config_json omits keys', () {
      const config = BusinessConfigModel(
        id: 'cfg-1',
        businessId: 'biz-1',
        enableRestaurant: true,
        enableKot: true,
        configJson: {},
      );

      final flags = BusinessFeatureFlags.fromConfig(config);
      expect(flags.enableRestaurant, isTrue);
      expect(flags.enableKot, isTrue);
      expect(flags.enableTableManagement, isFalse);
      expect(flags.showTablesNav, isFalse);
      expect(flags.showKitchenNav, isTrue);
    });

    test('restaurant preset enables tables and kitchen nav', () {
      const config = BusinessConfigModel(
        id: 'cfg-1',
        businessId: 'biz-1',
        configJson: {
          'enable_restaurant': true,
          'enable_table_management': true,
          'enable_kot': true,
        },
      );

      final flags = BusinessFeatureFlags.fromConfig(config);
      expect(flags.showTablesNav, isTrue);
      expect(flags.showKitchenNav, isTrue);
    });
  });
}
