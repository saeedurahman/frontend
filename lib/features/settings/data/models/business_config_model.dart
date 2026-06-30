import 'package:freezed_annotation/freezed_annotation.dart';

part 'business_config_model.freezed.dart';
part 'business_config_model.g.dart';

/// Mirrors backend [BusinessConfigResponse] on GET /business/me → config.
@freezed
class BusinessConfigModel with _$BusinessConfigModel {
  const factory BusinessConfigModel({
    required String id,
    @JsonKey(name: 'business_id') required String businessId,
    @JsonKey(name: 'enable_restaurant') @Default(false) bool enableRestaurant,
    @JsonKey(name: 'enable_manufacturing')
    @Default(false)
    bool enableManufacturing,
    @JsonKey(name: 'enable_weight_billing')
    @Default(false)
    bool enableWeightBilling,
    @JsonKey(name: 'enable_kot') @Default(false) bool enableKot,
    @JsonKey(name: 'fifo_costing_enabled')
    @Default(true)
    bool fifoCostingEnabled,
    @JsonKey(name: 'allow_negative_stock')
    @Default(false)
    bool allowNegativeStock,
    @JsonKey(name: 'config_json') @Default({}) Map<String, dynamic> configJson,
  }) = _BusinessConfigModel;

  factory BusinessConfigModel.fromJson(Map<String, dynamic> json) =>
      _$BusinessConfigModelFromJson(json);
}
