import 'package:freezed_annotation/freezed_annotation.dart';

part 'expense_payment_model.freezed.dart';
part 'expense_payment_model.g.dart';

@freezed
class ExpensePaymentModel with _$ExpensePaymentModel {
  const factory ExpensePaymentModel({
    required String id,
    @JsonKey(name: 'expense_id') required String expenseId,
    @JsonKey(name: 'payment_method') required String paymentMethod,
    required String amount,
    @Default('completed') String status,
    @JsonKey(name: 'reference_no') String? referenceNo,
    @JsonKey(name: 'paid_at') String? paidAt,
    @JsonKey(name: 'created_at') String? createdAt,
  }) = _ExpensePaymentModel;

  factory ExpensePaymentModel.fromJson(Map<String, dynamic> json) =>
      _$ExpensePaymentModelFromJson(json);
}
