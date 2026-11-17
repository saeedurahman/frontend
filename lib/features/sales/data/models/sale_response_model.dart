import 'package:frantend/core/utils/json_num.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frantend/features/customers/data/models/customer_model.dart';

part 'sale_response_model.freezed.dart';
part 'sale_response_model.g.dart';

@freezed
abstract class SaleLineModel with _$SaleLineModel {
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
    @JsonKey(name: 'net_amount') String? netAmount,
    @JsonKey(name: 'line_total') String? lineTotal,
    String? notes,
    @JsonKey(name: 'line_order', fromJson: JsonNum.intOrNull) int? lineOrder,
    @JsonKey(name: 'product_name') String? productName,
    @JsonKey(name: 'variation_name') String? variationName,
    @JsonKey(name: 'returned_qty') @Default('0') String returnedQty,
  }) = _SaleLineModel;

  factory SaleLineModel.fromJson(Map<String, dynamic> json) =>
      _$SaleLineModelFromJson(json);
}

/// One row of the receipt's tax breakdown: a tax rate with the net amount it
/// applied to and the tax charged.
@freezed
abstract class SaleTaxBreakdownModel with _$SaleTaxBreakdownModel {
  const factory SaleTaxBreakdownModel({
    @JsonKey(name: 'tax_label') String? taxLabel,
    @JsonKey(name: 'tax_rate') @Default('0') String taxRate,
    @JsonKey(name: 'net_amount') @Default('0') String netAmount,
    @JsonKey(name: 'tax_amount') @Default('0') String taxAmount,
  }) = _SaleTaxBreakdownModel;

  factory SaleTaxBreakdownModel.fromJson(Map<String, dynamic> json) =>
      _$SaleTaxBreakdownModelFromJson(json);
}

@freezed
abstract class SalePaymentModel with _$SalePaymentModel {
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
abstract class SaleResponseModel with _$SaleResponseModel {
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
    @JsonKey(name: 'net_amount') String? netAmount,
    @JsonKey(name: 'exact_total') String? exactTotal,
    // Snapshot of the tax mode the sale was made in (never the current
    // settings), so an old sale reprints identically.
    @JsonKey(name: 'rounding_amount') @Default('0') String roundingAmount,
    @JsonKey(name: 'tax_inclusive', readValue: _readBool) @Default(false) bool taxInclusive,
    @JsonKey(name: 'tax_rounding_mode') @Default('none') String taxRoundingMode,
    @JsonKey(name: 'tax_label') String? taxLabel,
    @JsonKey(name: 'show_tax_breakdown') bool? showTaxBreakdown,
    @JsonKey(name: 'tax_breakdown') @Default([]) List<SaleTaxBreakdownModel> taxBreakdown,
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

Object? _readBool(Map<dynamic, dynamic> json, String key) {
  final v = json[key];
  if (v is num) return v != 0; // local rows store 0 / 1
  return v;
}

Object? _readSaleStatus(Map<dynamic, dynamic> json, String key) {
  return json['sale_status'] ?? json['status'];
}
