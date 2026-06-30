import 'package:equatable/equatable.dart';
import 'package:frantend/features/settings/data/models/business_config_model.dart';

/// Restaurant module feature gates — parsed from GET /business/me → config.
///
/// Backend runtime source of truth is config_json; boolean columns are fallbacks
/// for keys exposed on [BusinessConfigModel] (enable_restaurant, enable_kot).
class BusinessFeatureFlags extends Equatable {
  const BusinessFeatureFlags({
    this.enableRestaurant = false,
    this.enableTableManagement = false,
    this.enableKot = false,
  });

  static const disabled = BusinessFeatureFlags();

  final bool enableRestaurant;
  final bool enableTableManagement;
  final bool enableKot;

  /// Tables nav + floor view.
  bool get showTablesNav => enableRestaurant && enableTableManagement;

  /// Kitchen display nav / route.
  bool get showKitchenNav => enableRestaurant && enableKot;

  /// Build from GET /business/me config — no separate feature_flags field exists.
  factory BusinessFeatureFlags.fromConfig(BusinessConfigModel? config) {
    if (config == null) return disabled;

    bool readFlag(
      String key, {
      bool columnFallback = false,
    }) {
      final json = config.configJson;
      if (json.containsKey(key)) {
        final value = json[key];
        if (value is bool) return value;
        if (value == true || value == 'true') return true;
        return false;
      }
      return columnFallback;
    }

    return BusinessFeatureFlags(
      enableRestaurant: readFlag(
        'enable_restaurant',
        columnFallback: config.enableRestaurant,
      ),
      enableTableManagement: readFlag('enable_table_management'),
      enableKot: readFlag(
        'enable_kot',
        columnFallback: config.enableKot,
      ),
    );
  }

  @override
  List<Object?> get props => [
        enableRestaurant,
        enableTableManagement,
        enableKot,
      ];
}
