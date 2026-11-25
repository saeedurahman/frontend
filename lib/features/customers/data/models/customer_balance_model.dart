import 'package:frantend/core/utils/api_json_utils.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'customer_balance_model.freezed.dart';
part 'customer_balance_model.g.dart';

@freezed
abstract class CustomerBalanceModel with _$CustomerBalanceModel {
  const factory CustomerBalanceModel({
    @JsonKey(name: 'customer_id') required String customerId,
    required String balance,
    @JsonKey(name: 'balance_owed') String? balanceOwed,
    @JsonKey(name: 'credit_limit') String? creditLimit,
    @JsonKey(name: 'credit_available') String? creditAvailable,
  }) = _CustomerBalanceModel;

  factory CustomerBalanceModel.fromJson(Map<String, dynamic> json) =>
      _$CustomerBalanceModelFromJson(_normalizeJson(json));

  static Map<String, dynamic> _normalizeJson(Map<String, dynamic> json) {
    final normalized = Map<String, dynamic>.from(json);
    for (final key in [
      'balance',
      'balance_owed',
      'credit_limit',
      'credit_available',
    ]) {
      if (normalized[key] != null) {
        normalized[key] = ApiJsonUtils.stringValue(normalized[key]);
      }
    }
    return normalized;
  }
}
