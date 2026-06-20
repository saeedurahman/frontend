import 'package:frantend/core/utils/api_json_utils.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'customer_payment_response_model.freezed.dart';
part 'customer_payment_response_model.g.dart';

@freezed
class CustomerPaymentResponseModel with _$CustomerPaymentResponseModel {
  const factory CustomerPaymentResponseModel({
    @JsonKey(name: 'ledger_entry_id') required String ledgerEntryId,
    @JsonKey(name: 'customer_id') required String customerId,
    required String amount,
    @JsonKey(name: 'new_balance') required String newBalance,
  }) = _CustomerPaymentResponseModel;

  factory CustomerPaymentResponseModel.fromJson(Map<String, dynamic> json) =>
      _$CustomerPaymentResponseModelFromJson(_normalizeJson(json));

  static Map<String, dynamic> _normalizeJson(Map<String, dynamic> json) {
    final normalized = Map<String, dynamic>.from(json);
    for (final key in ['amount', 'new_balance']) {
      if (normalized[key] != null) {
        normalized[key] = ApiJsonUtils.stringValue(normalized[key]);
      }
    }
    return normalized;
  }
}
