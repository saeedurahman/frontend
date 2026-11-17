import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/utils/decimal_utils.dart';
import 'package:frantend/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:frantend/features/products/domain/usecases/get_product_by_id_usecase.dart';
import 'package:frantend/features/purchases/data/models/purchase_order_model.dart';
import 'package:frantend/features/purchases/domain/usecases/purchase_usecases.dart';
import 'package:frantend/features/purchases/presentation/cubit/goods_receipt_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class GoodsReceiptCubit extends Cubit<GoodsReceiptState> {
  GoodsReceiptCubit({
    required AuthLocalDataSource authLocalDataSource,
    required GetPurchaseOrderUseCase getPurchaseOrderUseCase,
    required CreatePurchaseReceiptUseCase createPurchaseReceiptUseCase,
    required GetProductByIdUseCase getProductByIdUseCase,
  })  : _authLocal = authLocalDataSource,
        _getProduct = getProductByIdUseCase,
        _getOrder = getPurchaseOrderUseCase,
        _createReceipt = createPurchaseReceiptUseCase,
        super(const GoodsReceiptState());

  final AuthLocalDataSource _authLocal;
  final GetPurchaseOrderUseCase _getOrder;
  final CreatePurchaseReceiptUseCase _createReceipt;
  final GetProductByIdUseCase _getProduct;

  /// Whether a product tracks expiry (read from the device's products).
  Future<bool> _tracksExpiry(String productId) async {
    try {
      final result = await _getProduct(productId);
      return result.fold<bool>((_) => false, (p) => p.trackExpiry);
    } catch (_) {
      return false;
    }
  }

  Future<void> load(String purchaseOrderId) async {
    emit(state.copyWith(isLoading: true));

    final user = await _authLocal.getCachedUser();
    final branchId = user?.branchId;

    final result = await _getOrder(purchaseOrderId);
    final order = result.fold<PurchaseOrderModel?>((failure) {
      emit(
        state.copyWith(
          isLoading: false,
          errors: {'_general': failure.message},
        ),
      );
      return null;
    }, (o) => o);
    if (order == null) return;

    final receivable = order.lines
        .where((l) => (double.tryParse(l.qtyToReceive) ?? 0) > 0)
        .toList();
    final tracked = await Future.wait([
      for (final l in receivable) _tracksExpiry(l.productId),
    ]);
    if (isClosed) return;
    final receivableLines = [
      for (var i = 0; i < receivable.length; i++)
        GoodsReceiptLineItem(
          line: receivable[i],
          qtyReceived: receivable[i].qtyToReceive,
          costPerUnit: receivable[i].costPerUnit,
          batchNumber: receivable[i].batchNumber ?? '',
          expiryDate: DateTime.tryParse(receivable[i].expiryDate ?? ''),
          trackExpiry: tracked[i],
        ),
    ];

    emit(
      GoodsReceiptState(
        branchId: branchId,
        order: order,
        lines: receivableLines,
        receivedAt: DateTime.now(),
      ),
    );
  }

  void updateReceivedAt(DateTime value) =>
      emit(state.copyWith(receivedAt: value));

  void updateSupplierInvoiceNo(String value) =>
      emit(state.copyWith(supplierInvoiceNo: value));

  void updateNotes(String value) => emit(state.copyWith(notes: value));

  void updateLine(int index, GoodsReceiptLineItem item) {
    final lines = [...state.lines];
    if (index < lines.length) {
      lines[index] = item;
      emit(state.copyWith(lines: lines));
    }
  }

  /// Items that track expiry must say which batch and when it expires.
  static String? batchProblem(GoodsReceiptLineItem item) {
    if (!item.trackExpiry) return null;
    final noBatch = item.batchNumber.trim().isEmpty;
    final noExpiry = item.expiryDate == null;
    if (noBatch && noExpiry) {
      return 'Batch number and expiry date are required for this item';
    }
    if (noBatch) return 'Batch number is required for this item';
    if (noExpiry) return 'Expiry date is required for this item';
    return null;
  }

  bool validate() {
    final errors = <String, String>{};
    if (state.branchId == null) {
      errors['_general'] = 'Branch not found. Please log in again.';
    }
    if (state.order == null) {
      errors['_general'] = 'Purchase order not loaded';
    }

    var hasReceipt = false;
    for (var i = 0; i < state.lines.length; i++) {
      final item = state.lines[i];
      final qty = double.tryParse(item.qtyReceived) ?? 0;
      if (qty > 0) {
        hasReceipt = true;
        if (qty > item.maxQty) {
          errors['line_$i'] = 'Cannot exceed ${item.maxQty}';
        }
        if (item.costPerUnit.trim().isEmpty) {
          errors['line_$i'] = 'Cost is required';
        }
        final missing = batchProblem(item);
        if (missing != null) {
          errors['line_$i'] = errors.containsKey('line_$i')
              ? '${errors['line_$i']}; $missing'
              : missing;
        }
      }
    }

    if (!hasReceipt) {
      errors['lines'] = 'Enter quantity for at least one line';
    }

    emit(state.copyWith(errors: errors));
    return errors.isEmpty;
  }

  Future<String?> confirmReceipt() async {
    if (!validate()) return 'Validation failed';

    emit(state.copyWith(isSubmitting: true, errors: {}));

    final receiptLines = state.lines
        .where((item) => (double.tryParse(item.qtyReceived) ?? 0) > 0)
        .map(
          (item) => CreatePurchaseReceiptLineParams(
            purchaseLineId: item.line.id,
            productId: item.line.productId,
            variationId: item.line.variationId,
            qtyReceived: DecimalUtils.parse(item.qtyReceived),
            costPerUnit: DecimalUtils.parse(item.costPerUnit),
            batchNumber: item.batchNumber.trim().isEmpty
                ? null
                : item.batchNumber.trim(),
            expiryDate: item.expiryDate,
          ),
        )
        .toList();

    final params = CreatePurchaseReceiptParams(
      branchId: state.branchId!,
      supplierId: state.order!.supplierId,
      purchaseOrderId: state.order!.id,
      receivedAt: state.receivedAt ?? DateTime.now(),
      supplierInvoiceNo: state.supplierInvoiceNo.trim().isEmpty
          ? null
          : state.supplierInvoiceNo.trim(),
      notes: state.notes.trim().isEmpty ? null : state.notes.trim(),
      lines: receiptLines,
    );

    final result = await _createReceipt(params);
    return result.fold(
      (failure) {
        emit(state.copyWith(isSubmitting: false));
        return failure.message;
      },
      (_) {
        emit(state.copyWith(isSubmitting: false));
        return null;
      },
    );
  }
}
