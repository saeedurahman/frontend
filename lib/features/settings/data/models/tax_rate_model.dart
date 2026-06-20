import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frantend/core/utils/api_json_utils.dart';

part 'tax_rate_model.freezed.dart';
part 'tax_rate_model.g.dart';

@freezed
class TaxRateModel with _$TaxRateModel {
  const factory TaxRateModel({
    required String id,
    @JsonKey(name: 'business_id') required String businessId,
    required String name,
    required String rate,
    @JsonKey(name: 'is_compound') @Default(false) bool isCompound,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
  }) = _TaxRateModel;

  factory TaxRateModel.fromJson(Map<String, dynamic> json) =>
      _$TaxRateModelFromJson(_normalizeJson(json));

  static Map<String, dynamic> _normalizeJson(Map<String, dynamic> json) {
    final normalized = Map<String, dynamic>.from(json);
    if (normalized['rate'] != null) {
      normalized['rate'] = ApiJsonUtils.stringValue(normalized['rate']);
    }
    return normalized;
  }
}
