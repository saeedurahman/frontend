import 'package:dartz/dartz.dart';
import 'package:decimal/decimal.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/core/utils/decimal_utils.dart';
import 'package:frantend/features/purchases/data/models/purchase_order_model.dart';
import 'package:frantend/features/purchases/domain/repositories/purchases_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetPurchaseOrdersUseCase {
  const GetPurchaseOrdersUseCase(this._repository);

  final PurchasesRepository _repository;

  Future<Either<Failure, List<PurchaseOrderModel>>> call() =>
      _repository.getPurchaseOrders();
}

@injectable
class GetPurchaseOrderUseCase {
  const GetPurchaseOrderUseCase(this._repository);

  final PurchasesRepository _repository;

  Future<Either<Failure, PurchaseOrderModel>> call(String id) =>
      _repository.getPurchaseOrder(id);
}

@injectable
class CreatePurchaseOrderUseCase {
  const CreatePurchaseOrderUseCase(this._repository);

  final PurchasesRepository _repository;

  Future<Either<Failure, PurchaseOrderModel>> call(
    CreatePurchaseOrderParams params,
  ) =>
      _repository.createPurchaseOrder(params.toJson());
}

@injectable
class UpdatePurchaseOrderStatusUseCase {
  const UpdatePurchaseOrderStatusUseCase(this._repository);

  final PurchasesRepository _repository;

  Future<Either<Failure, PurchaseOrderModel>> call(
    String id,
    String status,
  ) =>
      _repository.updatePurchaseOrderStatus(id, status);
}

@injectable
class CreatePurchaseReceiptUseCase {
  const CreatePurchaseReceiptUseCase(this._repository);

  final PurchasesRepository _repository;

  Future<Either<Failure, PurchaseReceiptModel>> call(
    CreatePurchaseReceiptParams params,
  ) =>
      _repository.createPurchaseReceipt(params.toJson());
}

@injectable
class GetPurchaseReceiptUseCase {
  const GetPurchaseReceiptUseCase(this._repository);

  final PurchasesRepository _repository;

  Future<Either<Failure, PurchaseReceiptModel>> call(String id) =>
      _repository.getPurchaseReceipt(id);
}

class CreatePurchaseOrderParams {
  const CreatePurchaseOrderParams({
    required this.branchId,
    required this.supplierId,
    this.expectedAt,
    this.notes,
    required this.lines,
  });

  final String branchId;
  final String supplierId;
  final DateTime? expectedAt;
  final String? notes;
  final List<CreatePurchaseLineParams> lines;

  Map<String, dynamic> toJson() => {
        'branch_id': branchId,
        'supplier_id': supplierId,
        if (expectedAt != null) 'expected_at': expectedAt!.toIso8601String(),
        if (notes != null) 'notes': notes,
        'lines': lines.map((line) => line.toJson()).toList(),
      };
}

class CreatePurchaseLineParams {
  const CreatePurchaseLineParams({
    required this.productId,
    this.variationId,
    required this.orderedQty,
    required this.costPerUnit,
    this.taxRate,
    this.batchNumber,
    this.expiryDate,
  });

  final String productId;
  final String? variationId;
  final Decimal orderedQty;
  final Decimal costPerUnit;
  final Decimal? taxRate;
  final String? batchNumber;
  final DateTime? expiryDate;

  Map<String, dynamic> toJson() => {
        'product_id': productId,
        if (variationId != null) 'variation_id': variationId,
        'ordered_qty': DecimalUtils.format(orderedQty, fractionDigits: 4),
        'cost_per_unit': DecimalUtils.format(costPerUnit),
        if (taxRate != null)
          'tax_rate': DecimalUtils.format(taxRate!, fractionDigits: 4),
        if (batchNumber != null) 'batch_number': batchNumber,
        if (expiryDate != null)
          'expiry_date': expiryDate!.toIso8601String().split('T').first,
      };
}

class CreatePurchaseReceiptParams {
  const CreatePurchaseReceiptParams({
    required this.branchId,
    required this.supplierId,
    this.purchaseOrderId,
    required this.receivedAt,
    this.supplierInvoiceNo,
    this.notes,
    required this.lines,
  });

  final String branchId;
  final String supplierId;
  final String? purchaseOrderId;
  final DateTime receivedAt;
  final String? supplierInvoiceNo;
  final String? notes;
  final List<CreatePurchaseReceiptLineParams> lines;

  Map<String, dynamic> toJson() => {
        'branch_id': branchId,
        'supplier_id': supplierId,
        if (purchaseOrderId != null) 'purchase_order_id': purchaseOrderId,
        'received_at': receivedAt.toIso8601String(),
        if (supplierInvoiceNo != null) 'supplier_invoice_no': supplierInvoiceNo,
        if (notes != null) 'notes': notes,
        'lines': lines.map((line) => line.toJson()).toList(),
      };
}

class CreatePurchaseReceiptLineParams {
  const CreatePurchaseReceiptLineParams({
    this.purchaseLineId,
    required this.productId,
    this.variationId,
    required this.qtyReceived,
    required this.costPerUnit,
    this.batchNumber,
    this.expiryDate,
  });

  final String? purchaseLineId;
  final String productId;
  final String? variationId;
  final Decimal qtyReceived;
  final Decimal costPerUnit;
  final String? batchNumber;
  final DateTime? expiryDate;

  Map<String, dynamic> toJson() => {
        if (purchaseLineId != null) 'purchase_line_id': purchaseLineId,
        'product_id': productId,
        if (variationId != null) 'variation_id': variationId,
        'qty_received': DecimalUtils.format(qtyReceived, fractionDigits: 4),
        'cost_per_unit': DecimalUtils.format(costPerUnit),
        if (batchNumber != null) 'batch_number': batchNumber,
        if (expiryDate != null)
          'expiry_date': expiryDate!.toIso8601String().split('T').first,
      };
}
