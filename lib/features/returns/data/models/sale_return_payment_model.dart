import 'package:freezed_annotation/freezed_annotation.dart';

part 'sale_return_payment_model.freezed.dart';
part 'sale_return_payment_model.g.dart';

@freezed
class SaleReturnPaymentModel with _$SaleReturnPaymentModel {
  const factory SaleReturnPaymentModel({
    required String id,
    @JsonKey(name: 'business_id') required String businessId,
    @JsonKey(name: 'sale_return_id') required String saleReturnId,
    @JsonKey(name: 'payment_method') required String paymentMethod,
    required String amount,
    required String status,
    @JsonKey(name: 'refunded_at') String? refundedAt,
    @JsonKey(name: 'created_at') String? createdAt,
  }) = _SaleReturnPaymentModel;

  factory SaleReturnPaymentModel.fromJson(Map<String, dynamic> json) =>
      _$SaleReturnPaymentModelFromJson(json);
}
