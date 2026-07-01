import 'package:equatable/equatable.dart';
import 'package:frantend/features/settings/data/models/business_config_model.dart';

/// Business module feature gates — parsed from GET /business/me → config.
///
/// Backend runtime source of truth is config_json; boolean columns are fallbacks
/// for keys exposed on [BusinessConfigModel].
class BusinessFeatureFlags extends Equatable {
  const BusinessFeatureFlags({
    this.enableRestaurant = false,
    this.enableTableManagement = false,
    this.enableKot = false,
    this.enableManufacturing = false,
    this.enableAccounting = false,
  });

  static const disabled = BusinessFeatureFlags();

  final bool enableRestaurant;
  final bool enableTableManagement;
  final bool enableKot;
  final bool enableManufacturing;
  final bool enableAccounting;

  /// Tables nav + floor view.
  bool get showTablesNav => enableRestaurant && enableTableManagement;

  /// Kitchen display nav / route.
  bool get showKitchenNav => enableRestaurant && enableKot;

  /// Manufacturing nav (production orders + BOM management).
  bool get showManufacturingNav => enableManufacturing;

  /// Accounting nav (journal entries + chart of accounts).
  bool get showAccountingNav => enableAccounting;

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
      enableManufacturing: readFlag(
        'enable_manufacturing',
        columnFallback: config.enableManufacturing,
      ),
      enableAccounting: readFlag(
        'enable_accounting',
        columnFallback: config.enableAccounting,
      ),
    );
  }

  @override
  List<Object?> get props => [
        enableRestaurant,
        enableTableManagement,
        enableKot,
        enableManufacturing,
        enableAccounting,
      ];
}
