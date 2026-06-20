// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase_order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PurchaseLineModelImpl _$$PurchaseLineModelImplFromJson(
  Map<String, dynamic> json,
) => _$PurchaseLineModelImpl(
  id: json['id'] as String,
  businessId: json['business_id'] as String,
  purchaseOrderId: json['purchase_order_id'] as String,
  productId: json['product_id'] as String,
  variationId: json['variation_id'] as String?,
  orderedQty: json['ordered_qty'] as String,
  receivedQty: json['received_qty'] as String,
  qtyRemaining: json['qty_remaining'] as String,
  costPerUnit: json['cost_per_unit'] as String,
  taxRate: json['tax_rate'] as String? ?? '0',
  batchNumber: json['batch_number'] as String?,
  expiryDate: json['expiry_date'] as String?,
  productName: json['productName'] as String?,
  variationName: json['variationName'] as String?,
  sku: json['sku'] as String?,
);

Map<String, dynamic> _$$PurchaseLineModelImplToJson(
  _$PurchaseLineModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'business_id': instance.businessId,
  'purchase_order_id': instance.purchaseOrderId,
  'product_id': instance.productId,
  'variation_id': instance.variationId,
  'ordered_qty': instance.orderedQty,
  'received_qty': instance.receivedQty,
  'qty_remaining': instance.qtyRemaining,
  'cost_per_unit': instance.costPerUnit,
  'tax_rate': instance.taxRate,
  'batch_number': instance.batchNumber,
  'expiry_date': instance.expiryDate,
  'productName': instance.productName,
  'variationName': instance.variationName,
  'sku': instance.sku,
};

_$PurchaseOrderModelImpl _$$PurchaseOrderModelImplFromJson(
  Map<String, dynamic> json,
) => _$PurchaseOrderModelImpl(
  id: json['id'] as String,
  businessId: json['business_id'] as String,
  branchId: json['branch_id'] as String,
  supplierId: json['supplier_id'] as String,
  poNumber: json['po_number'] as String,
  status: json['status'] as String,
  orderedAt: json['ordered_at'] as String?,
  expectedAt: json['expected_at'] as String?,
  notes: json['notes'] as String?,
  createdAt: json['created_at'] as String?,
  updatedAt: json['updated_at'] as String?,
  supplier: json['supplier'] == null
      ? null
      : SupplierModel.fromJson(json['supplier'] as Map<String, dynamic>),
  lines:
      (json['lines'] as List<dynamic>?)
          ?.map((e) => PurchaseLineModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$PurchaseOrderModelImplToJson(
  _$PurchaseOrderModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'business_id': instance.businessId,
  'branch_id': instance.branchId,
  'supplier_id': instance.supplierId,
  'po_number': instance.poNumber,
  'status': instance.status,
  'ordered_at': instance.orderedAt,
  'expected_at': instance.expectedAt,
  'notes': instance.notes,
  'created_at': instance.createdAt,
  'updated_at': instance.updatedAt,
  'supplier': instance.supplier,
  'lines': instance.lines,
};

_$PurchaseReceiptLineModelImpl _$$PurchaseReceiptLineModelImplFromJson(
  Map<String, dynamic> json,
) => _$PurchaseReceiptLineModelImpl(
  id: json['id'] as String,
  purchaseReceiptId: json['purchase_receipt_id'] as String,
  purchaseLineId: json['purchase_line_id'] as String?,
  productId: json['product_id'] as String,
  variationId: json['variation_id'] as String?,
  qtyReceived: json['qty_received'] as String,
  costPerUnit: json['cost_per_unit'] as String,
  batchNumber: json['batch_number'] as String?,
  expiryDate: json['expiry_date'] as String?,
);

Map<String, dynamic> _$$PurchaseReceiptLineModelImplToJson(
  _$PurchaseReceiptLineModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'purchase_receipt_id': instance.purchaseReceiptId,
  'purchase_line_id': instance.purchaseLineId,
  'product_id': instance.productId,
  'variation_id': instance.variationId,
  'qty_received': instance.qtyReceived,
  'cost_per_unit': instance.costPerUnit,
  'batch_number': instance.batchNumber,
  'expiry_date': instance.expiryDate,
};

_$PurchaseReceiptModelImpl _$$PurchaseReceiptModelImplFromJson(
  Map<String, dynamic> json,
) => _$PurchaseReceiptModelImpl(
  id: json['id'] as String,
  branchId: json['branch_id'] as String,
  supplierId: json['supplier_id'] as String,
  purchaseOrderId: json['purchase_order_id'] as String?,
  receiptNumber: json['receipt_number'] as String,
  receivedAt: json['received_at'] as String,
  supplierInvoiceNo: json['supplier_invoice_no'] as String?,
  notes: json['notes'] as String?,
  lines:
      (json['lines'] as List<dynamic>?)
          ?.map(
            (e) => PurchaseReceiptLineModel.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
);

Map<String, dynamic> _$$PurchaseReceiptModelImplToJson(
  _$PurchaseReceiptModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'branch_id': instance.branchId,
  'supplier_id': instance.supplierId,
  'purchase_order_id': instance.purchaseOrderId,
  'receipt_number': instance.receiptNumber,
  'received_at': instance.receivedAt,
  'supplier_invoice_no': instance.supplierInvoiceNo,
  'notes': instance.notes,
  'lines': instance.lines,
};
