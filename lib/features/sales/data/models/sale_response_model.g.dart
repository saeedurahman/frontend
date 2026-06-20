// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sale_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SaleLineModelImpl _$$SaleLineModelImplFromJson(Map<String, dynamic> json) =>
    _$SaleLineModelImpl(
      id: json['id'] as String,
      productId: json['product_id'] as String,
      variationId: json['variation_id'] as String?,
      qty: json['qty'] as String,
      unitPrice: json['unit_price'] as String,
      discountPct: json['discount_pct'] as String? ?? '0',
      discountAmount: json['discount_amount'] as String? ?? '0',
      taxRate: json['tax_rate'] as String? ?? '0',
      taxAmount: json['tax_amount'] as String?,
      lineTotal: json['line_total'] as String?,
      notes: json['notes'] as String?,
      lineOrder: (json['line_order'] as num?)?.toInt(),
      productName: json['product_name'] as String?,
      variationName: json['variation_name'] as String?,
      returnedQty: json['returned_qty'] as String? ?? '0',
    );

Map<String, dynamic> _$$SaleLineModelImplToJson(_$SaleLineModelImpl instance) =>
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
      'line_total': instance.lineTotal,
      'notes': instance.notes,
      'line_order': instance.lineOrder,
      'product_name': instance.productName,
      'variation_name': instance.variationName,
      'returned_qty': instance.returnedQty,
    };

_$SalePaymentModelImpl _$$SalePaymentModelImplFromJson(
  Map<String, dynamic> json,
) => _$SalePaymentModelImpl(
  id: json['id'] as String,
  paymentMethod: json['payment_method'] as String,
  amount: json['amount'] as String,
  referenceNo: json['reference_no'] as String?,
  paidAt: json['paid_at'] as String?,
);

Map<String, dynamic> _$$SalePaymentModelImplToJson(
  _$SalePaymentModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'payment_method': instance.paymentMethod,
  'amount': instance.amount,
  'reference_no': instance.referenceNo,
  'paid_at': instance.paidAt,
};

_$SaleResponseModelImpl _$$SaleResponseModelImplFromJson(
  Map<String, dynamic> json,
) => _$SaleResponseModelImpl(
  id: json['id'] as String,
  saleNumber: json['sale_number'] as String?,
  branchId: json['branch_id'] as String,
  customerId: json['customer_id'] as String?,
  saleType: json['sale_type'] as String,
  saleStatus: _readSaleStatus(json, 'sale_status') as String,
  registerShiftId: json['register_shift_id'] as String?,
  subtotal: json['subtotal'] as String?,
  totalDiscount: json['total_discount'] as String?,
  totalTax: json['total_tax'] as String?,
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

Map<String, dynamic> _$$SaleResponseModelImplToJson(
  _$SaleResponseModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'sale_number': instance.saleNumber,
  'branch_id': instance.branchId,
  'customer_id': instance.customerId,
  'sale_type': instance.saleType,
  'sale_status': instance.saleStatus,
  'register_shift_id': instance.registerShiftId,
  'subtotal': instance.subtotal,
  'total_discount': instance.totalDiscount,
  'total_tax': instance.totalTax,
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
