import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frantend/features/suppliers/data/models/supplier_model.dart';

part 'purchase_order_model.freezed.dart';
part 'purchase_order_model.g.dart';

@freezed
class PurchaseLineModel with _$PurchaseLineModel {
  const PurchaseLineModel._();

  const factory PurchaseLineModel({
    required String id,
    @JsonKey(name: 'business_id') required String businessId,
    @JsonKey(name: 'purchase_order_id') required String purchaseOrderId,
    @JsonKey(name: 'product_id') required String productId,
    @JsonKey(name: 'variation_id') String? variationId,
    @JsonKey(name: 'ordered_qty') required String orderedQty,
    @JsonKey(name: 'received_qty') required String receivedQty,
    @JsonKey(name: 'qty_remaining') required String qtyRemaining,
    @JsonKey(name: 'cost_per_unit') required String costPerUnit,
    @JsonKey(name: 'tax_rate') @Default('0') String taxRate,
    @JsonKey(name: 'batch_number') String? batchNumber,
    @JsonKey(name: 'expiry_date') String? expiryDate,
    String? productName,
    String? variationName,
    String? sku,
  }) = _PurchaseLineModel;

  factory PurchaseLineModel.fromJson(Map<String, dynamic> json) =>
      _$PurchaseLineModelFromJson(json);

  /// Remaining qty to receive (ordered - received).
  String get qtyToReceive {
    final ordered = double.tryParse(orderedQty) ?? 0;
    final received = double.tryParse(receivedQty) ?? 0;
    final remaining = ordered - received;
    return remaining < 0 ? '0' : remaining.toStringAsFixed(4).replaceAll(RegExp(r'\.?0+$'), '');
  }

  String get lineSubtotal {
    final qty = double.tryParse(orderedQty) ?? 0;
    final cost = double.tryParse(costPerUnit) ?? 0;
    return (qty * cost).toStringAsFixed(2);
  }
}

@freezed
class PurchaseOrderModel with _$PurchaseOrderModel {
  const PurchaseOrderModel._();

  const factory PurchaseOrderModel({
    required String id,
    @JsonKey(name: 'business_id') required String businessId,
    @JsonKey(name: 'branch_id') required String branchId,
    @JsonKey(name: 'supplier_id') required String supplierId,
    @JsonKey(name: 'po_number') required String poNumber,
    required String status,
    @JsonKey(name: 'ordered_at') String? orderedAt,
    @JsonKey(name: 'expected_at') String? expectedAt,
    String? notes,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
    SupplierModel? supplier,
    @Default([]) List<PurchaseLineModel> lines,
  }) = _PurchaseOrderModel;

  factory PurchaseOrderModel.fromJson(Map<String, dynamic> json) =>
      _$PurchaseOrderModelFromJson(json);

  double get grandTotal {
    var total = 0.0;
    for (final line in lines) {
      final qty = double.tryParse(line.orderedQty) ?? 0;
      final cost = double.tryParse(line.costPerUnit) ?? 0;
      final tax = double.tryParse(line.taxRate) ?? 0;
      total += qty * cost * (1 + tax / 100);
    }
    return total;
  }
}

@freezed
class PurchaseReceiptLineModel with _$PurchaseReceiptLineModel {
  const factory PurchaseReceiptLineModel({
    required String id,
    @JsonKey(name: 'purchase_receipt_id') required String purchaseReceiptId,
    @JsonKey(name: 'purchase_line_id') String? purchaseLineId,
    @JsonKey(name: 'product_id') required String productId,
    @JsonKey(name: 'variation_id') String? variationId,
    @JsonKey(name: 'qty_received') required String qtyReceived,
    @JsonKey(name: 'cost_per_unit') required String costPerUnit,
    @JsonKey(name: 'batch_number') String? batchNumber,
    @JsonKey(name: 'expiry_date') String? expiryDate,
  }) = _PurchaseReceiptLineModel;

  factory PurchaseReceiptLineModel.fromJson(Map<String, dynamic> json) =>
      _$PurchaseReceiptLineModelFromJson(json);
}

@freezed
class PurchaseReceiptModel with _$PurchaseReceiptModel {
  const factory PurchaseReceiptModel({
    required String id,
    @JsonKey(name: 'branch_id') required String branchId,
    @JsonKey(name: 'supplier_id') required String supplierId,
    @JsonKey(name: 'purchase_order_id') String? purchaseOrderId,
    @JsonKey(name: 'receipt_number') required String receiptNumber,
    @JsonKey(name: 'received_at') required String receivedAt,
    @JsonKey(name: 'supplier_invoice_no') String? supplierInvoiceNo,
    String? notes,
    @Default([]) List<PurchaseReceiptLineModel> lines,
  }) = _PurchaseReceiptModel;

  factory PurchaseReceiptModel.fromJson(Map<String, dynamic> json) =>
      _$PurchaseReceiptModelFromJson(json);
}

/// Backend PO status values (PurchaseOrderStatusEnum).
abstract final class PurchaseOrderStatus {
  static const draft = 'draft';
  static const ordered = 'ordered';
  static const partial = 'partial';
  static const received = 'received';
  static const cancelled = 'cancelled';
}
