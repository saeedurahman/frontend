import 'package:frantend/core/utils/api_json_utils.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'customer_model.freezed.dart';
part 'customer_model.g.dart';

@freezed
class CustomerModel with _$CustomerModel {
  const factory CustomerModel({
    required String id,
    @JsonKey(name: 'business_id') required String businessId,
    required String name,
    String? email,
    String? phone,
    @JsonKey(name: 'tax_id') String? taxId,
    @JsonKey(name: 'address_line1') String? addressLine1,
    String? city,
    @JsonKey(name: 'credit_limit') @Default('0') String creditLimit,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
    @JsonKey(includeFromJson: false, includeToJson: false) String? balance,
  }) = _CustomerModel;

  factory CustomerModel.fromJson(Map<String, dynamic> json) =>
      _$CustomerModelFromJson(_normalizeJson(json));

  static Map<String, dynamic> _normalizeJson(Map<String, dynamic> json) {
    final normalized = Map<String, dynamic>.from(json);
    if (normalized['credit_limit'] != null) {
      normalized['credit_limit'] =
          ApiJsonUtils.stringValue(normalized['credit_limit']);
    }
    return normalized;
  }
}
