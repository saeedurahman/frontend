import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frantend/features/customers/data/models/customer_model.dart';

part 'sale_response_model.freezed.dart';
part 'sale_response_model.g.dart';

@freezed
class SaleLineModel with _$SaleLineModel {
  const factory SaleLineModel({
    required String id,
    @JsonKey(name: 'product_id') required String productId,
    @JsonKey(name: 'variation_id') String? variationId,
    required String qty,
    @JsonKey(name: 'unit_price') required String unitPrice,
    @JsonKey(name: 'discount_pct') @Default('0') String discountPct,
    @JsonKey(name: 'discount_amount') @Default('0') String discountAmount,
    @JsonKey(name: 'tax_rate') @Default('0') String taxRate,
    @JsonKey(name: 'tax_amount') String? taxAmount,
    @JsonKey(name: 'line_total') String? lineTotal,
    String? notes,
    @JsonKey(name: 'line_order') int? lineOrder,
    @JsonKey(name: 'product_name') String? productName,
    @JsonKey(name: 'variation_name') String? variationName,
    @JsonKey(name: 'returned_qty') @Default('0') String returnedQty,
  }) = _SaleLineModel;

  factory SaleLineModel.fromJson(Map<String, dynamic> json) =>
      _$SaleLineModelFromJson(json);
}

@freezed
class SalePaymentModel with _$SalePaymentModel {
  const factory SalePaymentModel({
    required String id,
    @JsonKey(name: 'payment_method') required String paymentMethod,
    required String amount,
    @JsonKey(name: 'reference_no') String? referenceNo,
    @JsonKey(name: 'paid_at') String? paidAt,
  }) = _SalePaymentModel;

  factory SalePaymentModel.fromJson(Map<String, dynamic> json) =>
      _$SalePaymentModelFromJson(json);
}

@freezed
class SaleResponseModel with _$SaleResponseModel {
  const factory SaleResponseModel({
    required String id,
    @JsonKey(name: 'sale_number') String? saleNumber,
    @JsonKey(name: 'branch_id') required String branchId,
    @JsonKey(name: 'customer_id') String? customerId,
    @JsonKey(name: 'table_id') String? tableId,
    @JsonKey(name: 'sale_type') required String saleType,
    @JsonKey(name: 'sale_status', readValue: _readSaleStatus)
    required String saleStatus,
    @JsonKey(name: 'register_shift_id') String? registerShiftId,
    @JsonKey(name: 'subtotal') String? subtotal,
    @JsonKey(name: 'total_discount') String? totalDiscount,
    @JsonKey(name: 'total_tax') String? totalTax,
    @JsonKey(name: 'total_amount') @Default('0') String totalAmount,
    @JsonKey(name: 'total_paid') String? totalPaid,
    String? notes,
    @JsonKey(name: 'sold_at') String? soldAt,
    @JsonKey(name: 'created_at') String? createdAt,
    CustomerModel? customer,
    @Default([]) List<SaleLineModel> lines,
    @Default([]) List<SalePaymentModel> payments,
    @JsonKey(name: 'offline') @Default(false) bool offline,
  }) = _SaleResponseModel;

  factory SaleResponseModel.fromJson(Map<String, dynamic> json) =>
      _$SaleResponseModelFromJson(json);
}

Object? _readSaleStatus(Map<dynamic, dynamic> json, String key) {
  return json['sale_status'] ?? json['status'];
}
