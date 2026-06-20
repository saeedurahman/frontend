import 'package:frantend/core/utils/api_json_utils.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'expense_payment_response_model.freezed.dart';
part 'expense_payment_response_model.g.dart';

@freezed
class ExpensePaymentResponseModel with _$ExpensePaymentResponseModel {
  const factory ExpensePaymentResponseModel({
    required String id,
    @JsonKey(name: 'expense_id') required String expenseId,
    required String amount,
    @JsonKey(name: 'payment_method') required String paymentMethod,
    @JsonKey(name: 'reference_no') String? referenceNo,
    @JsonKey(name: 'paid_at') String? paidAt,
    @JsonKey(name: 'total_paid') required String totalPaid,
    @JsonKey(name: 'remaining_balance') required String remainingBalance,
  }) = _ExpensePaymentResponseModel;

  factory ExpensePaymentResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ExpensePaymentResponseModelFromJson(_normalizeJson(json));

  static Map<String, dynamic> _normalizeJson(Map<String, dynamic> json) {
    final normalized = Map<String, dynamic>.from(json);
    for (final key in ['amount', 'total_paid', 'remaining_balance']) {
      if (normalized[key] != null) {
        normalized[key] = ApiJsonUtils.stringValue(normalized[key]);
      }
    }
    return normalized;
  }
}
