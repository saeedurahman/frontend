// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sale_list_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SaleListItemModelImpl _$$SaleListItemModelImplFromJson(
  Map<String, dynamic> json,
) => _$SaleListItemModelImpl(
  id: json['id'] as String,
  businessId: json['business_id'] as String,
  branchId: json['branch_id'] as String,
  customerId: json['customer_id'] as String?,
  saleNumber: json['sale_number'] as String,
  saleType: json['sale_type'] as String,
  status: json['status'] as String,
  soldAt: json['sold_at'] as String,
  totalAmount: json['total_amount'] as String?,
  totalPaid: json['total_paid'] as String?,
  balanceDue: json['balance_due'] as String?,
  customerName: json['customer_name'] as String?,
  cashierName: json['cashier_name'] as String?,
  itemCount: (json['item_count'] as num?)?.toInt(),
  productNames:
      (json['product_names'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  paymentMethods:
      (json['payment_methods'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
);

Map<String, dynamic> _$$SaleListItemModelImplToJson(
  _$SaleListItemModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'business_id': instance.businessId,
  'branch_id': instance.branchId,
  'customer_id': instance.customerId,
  'sale_number': instance.saleNumber,
  'sale_type': instance.saleType,
  'status': instance.status,
  'sold_at': instance.soldAt,
  'total_amount': instance.totalAmount,
  'total_paid': instance.totalPaid,
  'balance_due': instance.balanceDue,
  'customer_name': instance.customerName,
  'cashier_name': instance.cashierName,
  'item_count': instance.itemCount,
  'product_names': instance.productNames,
  'payment_methods': instance.paymentMethods,
};
