// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sale_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SaleLineModel _$SaleLineModelFromJson(Map<String, dynamic> json) =>
    _SaleLineModel(
      id: json['id'] as String,
      productId: json['product_id'] as String,
      variationId: json['variation_id'] as String?,
      qty: json['qty'] as String,
      unitPrice: json['unit_price'] as String,
      discountPct: json['discount_pct'] as String? ?? '0',
      discountAmount: json['discount_amount'] as String? ?? '0',
      taxRate: json['tax_rate'] as String? ?? '0',
      taxAmount: json['tax_amount'] as String?,
      netAmount: json['net_amount'] as String?,
      lineTotal: json['line_total'] as String?,
      notes: json['notes'] as String?,
      lineOrder: JsonNum.intOrNull(json['line_order']),
      productName: json['product_name'] as String?,
      variationName: json['variation_name'] as String?,
      returnedQty: json['returned_qty'] as String? ?? '0',
      batches:
          (json['batches'] as List<dynamic>?)
              ?.map(
                (e) => SaleLineBatchModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
    );

Map<String, dynamic> _$SaleLineModelToJson(_SaleLineModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'product_id': instance.productId,
      'variation_id': instance.variationId,
      'qty': instance.qty,
      'unit_price': instance.unitPrice,
      'discount_pct': instance.discountPct,
      'discount_amount': instance.discountAmount,
      'tax_rate': instance.taxRate,
      'tax_amount': instance.taxAmount,
      'net_amount': instance.netAmount,
      'line_total': instance.lineTotal,
      'notes': instance.notes,
      'line_order': instance.lineOrder,
      'product_name': instance.productName,
      'variation_name': instance.variationName,
      'returned_qty': instance.returnedQty,
      'batches': instance.batches,
    };

_SaleLineBatchModel _$SaleLineBatchModelFromJson(Map<String, dynamic> json) =>
    _SaleLineBatchModel(
      batchNo: json['batch_no'] as String?,
      expiryDate: json['expiry_date'] as String?,
      qty: json['qty'] as String? ?? '0',
    );

Map<String, dynamic> _$SaleLineBatchModelToJson(_SaleLineBatchModel instance) =>
    <String, dynamic>{
      'batch_no': instance.batchNo,
      'expiry_date': instance.expiryDate,
      'qty': instance.qty,
    };

_SaleTaxBreakdownModel _$SaleTaxBreakdownModelFromJson(
  Map<String, dynamic> json,
) => _SaleTaxBreakdownModel(
  taxLabel: json['tax_label'] as String?,
  taxRate: json['tax_rate'] as String? ?? '0',
  netAmount: json['net_amount'] as String? ?? '0',
  taxAmount: json['tax_amount'] as String? ?? '0',
);

Map<String, dynamic> _$SaleTaxBreakdownModelToJson(
  _SaleTaxBreakdownModel instance,
) => <String, dynamic>{
  'tax_label': instance.taxLabel,
  'tax_rate': instance.taxRate,
  'net_amount': instance.netAmount,
  'tax_amount': instance.taxAmount,
};

_SalePaymentModel _$SalePaymentModelFromJson(Map<String, dynamic> json) =>
    _SalePaymentModel(
      id: json['id'] as String,
      paymentMethod: json['payment_method'] as String,
      amount: json['amount'] as String,
      referenceNo: json['reference_no'] as String?,
      paidAt: json['paid_at'] as String?,
      tenderedAmount: json['tendered_amount'] as String?,
      changeGiven: json['change_given'] as String?,
    );

Map<String, dynamic> _$SalePaymentModelToJson(_SalePaymentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'payment_method': instance.paymentMethod,
      'amount': instance.amount,
      'reference_no': instance.referenceNo,
      'paid_at': instance.paidAt,
      'tendered_amount': instance.tenderedAmount,
      'change_given': instance.changeGiven,
    };

_SaleResponseModel _$SaleResponseModelFromJson(Map<String, dynamic> json) =>
    _SaleResponseModel(
      id: json['id'] as String,
      saleNumber: json['sale_number'] as String?,
      clientReceiptNo: json['client_receipt_no'] as String?,
      branchId: json['branch_id'] as String,
      customerId: json['customer_id'] as String?,
      tableId: json['table_id'] as String?,
      saleType: json['sale_type'] as String,
      saleStatus: _readSaleStatus(json, 'sale_status') as String,
      registerShiftId: json['register_shift_id'] as String?,
      subtotal: json['subtotal'] as String?,
      totalDiscount: json['total_discount'] as String?,
      totalTax: json['total_tax'] as String?,
      netAmount: json['net_amount'] as String?,
      exactTotal: json['exact_total'] as String?,
      roundingAmount: json['rounding_amount'] as String? ?? '0',
      taxInclusive: _readBool(json, 'tax_inclusive') as bool? ?? false,
      taxRoundingMode: json['tax_rounding_mode'] as String? ?? 'none',
      taxLabel: json['tax_label'] as String?,
      showTaxBreakdown: json['show_tax_breakdown'] as bool?,
      taxBreakdown:
          (json['tax_breakdown'] as List<dynamic>?)
              ?.map(
                (e) =>
                    SaleTaxBreakdownModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
      totalAmount: json['total_amount'] as String? ?? '0',
      totalPaid: json['total_paid'] as String?,
      notes: json['notes'] as String?,
      soldAt: json['sold_at'] as String?,
      createdAt: json['created_at'] as String?,
      customer: json['customer'] == null
          ? null
          : CustomerModel.fromJson(json['customer'] as Map<String, dynamic>),
      lines:
          (json['lines'] as List<dynamic>?)
              ?.map((e) => SaleLineModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      payments:
          (json['payments'] as List<dynamic>?)
              ?.map((e) => SalePaymentModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      offline: json['offline'] as bool? ?? false,
    );

Map<String, dynamic> _$SaleResponseModelToJson(_SaleResponseModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sale_number': instance.saleNumber,
      'client_receipt_no': instance.clientReceiptNo,
      'branch_id': instance.branchId,
      'customer_id': instance.customerId,
      'table_id': instance.tableId,
      'sale_type': instance.saleType,
      'sale_status': instance.saleStatus,
      'register_shift_id': instance.registerShiftId,
      'subtotal': instance.subtotal,
      'total_discount': instance.totalDiscount,
      'total_tax': instance.totalTax,
      'net_amount': instance.netAmount,
      'exact_total': instance.exactTotal,
      'rounding_amount': instance.roundingAmount,
      'tax_inclusive': instance.taxInclusive,
      'tax_rounding_mode': instance.taxRoundingMode,
      'tax_label': instance.taxLabel,
      'show_tax_breakdown': instance.showTaxBreakdown,
      'tax_breakdown': instance.taxBreakdown,
      'total_amount': instance.totalAmount,
      'total_paid': instance.totalPaid,
      'notes': instance.notes,
      'sold_at': instance.soldAt,
      'created_at': instance.createdAt,
      'customer': instance.customer,
      'lines': instance.lines,
      'payments': instance.payments,
      'offline': instance.offline,
    };
