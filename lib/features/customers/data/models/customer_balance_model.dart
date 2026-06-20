import 'package:frantend/core/utils/api_json_utils.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'customer_balance_model.freezed.dart';
part 'customer_balance_model.g.dart';

@freezed
class CustomerBalanceModel with _$CustomerBalanceModel {
  const factory CustomerBalanceModel({
    @JsonKey(name: 'customer_id') required String customerId,
    required String balance,
  }) = _CustomerBalanceModel;

  factory CustomerBalanceModel.fromJson(Map<String, dynamic> json) =>
      _$CustomerBalanceModelFromJson(_normalizeJson(json));

  static Map<String, dynamic> _normalizeJson(Map<String, dynamic> json) {
    final normalized = Map<String, dynamic>.from(json);
    if (normalized['balance'] != null) {
      normalized['balance'] = ApiJsonUtils.stringValue(normalized['balance']);
    }
    return normalized;
  }
}
