// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kot_order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$KotOrderLineModelImpl _$$KotOrderLineModelImplFromJson(
  Map<String, dynamic> json,
) => _$KotOrderLineModelImpl(
  id: json['id'] as String,
  kotOrderId: json['kot_order_id'] as String,
  saleLineId: json['sale_line_id'] as String?,
  productId: json['product_id'] as String,
  productName: json['product_name'] as String,
  variationId: json['variation_id'] as String?,
  qty: json['qty'] as String,
  modifiersJson: json['modifiers_json'] as List<dynamic>? ?? const [],
  kitchenNotes: json['kitchen_notes'] as String?,
  status: json['status'] as String,
);

Map<String, dynamic> _$$KotOrderLineModelImplToJson(
  _$KotOrderLineModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'kot_order_id': instance.kotOrderId,
  'sale_line_id': instance.saleLineId,
  'product_id': instance.productId,
  'product_name': instance.productName,
  'variation_id': instance.variationId,
  'qty': instance.qty,
  'modifiers_json': instance.modifiersJson,
  'kitchen_notes': instance.kitchenNotes,
  'status': instance.status,
};

_$KotOrderModelImpl _$$KotOrderModelImplFromJson(Map<String, dynamic> json) =>
    _$KotOrderModelImpl(
      id: json['id'] as String,
      businessId: json['business_id'] as String,
      branchId: json['branch_id'] as String,
      saleId: json['sale_id'] as String?,
      tableId: json['table_id'] as String?,
      tableNumber: json['table_number'] as String?,
      kotNumber: json['kot_number'] as String,
      status: json['status'] as String,
      firedAt: json['fired_at'] as String,
      readyAt: json['ready_at'] as String?,
      servedAt: json['served_at'] as String?,
      notes: json['notes'] as String?,
      lines:
          (json['lines'] as List<dynamic>?)
              ?.map(
                (e) => KotOrderLineModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$KotOrderModelImplToJson(_$KotOrderModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'business_id': instance.businessId,
      'branch_id': instance.branchId,
      'sale_id': instance.saleId,
      'table_id': instance.tableId,
      'table_number': instance.tableNumber,
      'kot_number': instance.kotNumber,
      'status': instance.status,
      'fired_at': instance.firedAt,
      'ready_at': instance.readyAt,
      'served_at': instance.servedAt,
      'notes': instance.notes,
      'lines': instance.lines,
    };

_$FireTabResponseModelImpl _$$FireTabResponseModelImplFromJson(
  Map<String, dynamic> json,
) => _$FireTabResponseModelImpl(
  id: json['id'] as String,
  kotNumber: json['kot_number'] as String,
  saleId: json['sale_id'] as String?,
  tableId: json['table_id'] as String?,
  status: json['status'] as String,
);

Map<String, dynamic> _$$FireTabResponseModelImplToJson(
  _$FireTabResponseModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'kot_number': instance.kotNumber,
  'sale_id': instance.saleId,
  'table_id': instance.tableId,
  'status': instance.status,
};
