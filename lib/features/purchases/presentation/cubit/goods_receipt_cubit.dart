import 'package:decimal/decimal.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/utils/decimal_utils.dart';
import 'package:frantend/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:frantend/features/purchases/domain/usecases/purchase_usecases.dart';
import 'package:frantend/features/purchases/presentation/cubit/goods_receipt_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class GoodsReceiptCubit extends Cubit<GoodsReceiptState> {
  GoodsReceiptCubit({
    required AuthLocalDataSource authLocalDataSource,
    required GetPurchaseOrderUseCase getPurchaseOrderUseCase,
    required CreatePurchaseReceiptUseCase createPurchaseReceiptUseCase,
  })  : _authLocal = authLocalDataSource,
        _getOrder = getPurchaseOrderUseCase,
        _createReceipt = createPurchaseReceiptUseCase,
        super(const GoodsReceiptState());

  final AuthLocalDataSource _authLocal;
  final GetPurchaseOrderUseCase _getOrder;
  final CreatePurchaseReceiptUseCase _createReceipt;

  Future<void> load(String purchaseOrderId) async {
    emit(state.copyWith(isLoading: true));

    final user = await _authLocal.getCachedUser();
    final branchId = user?.branchId;

    final result = await _getOrder(purchaseOrderId);
    result.fold(
      (failure) => emit(
        state.copyWith(
          isLoading: false,
          errors: {'_general': failure.message},
        ),
      ),
      (order) {
        final receivableLines = order.lines
            .where((l) => (double.tryParse(l.qtyToReceive) ?? 0) > 0)
            .map(
              (line) => GoodsReceiptLineItem(
                line: line,
                qtyReceived: line.qtyToReceive,
                costPerUnit: line.costPerUnit,
                batchNumber: line.batchNumber ?? '',
              ),
            )
            .toList();

        emit(
          GoodsReceiptState(
            branchId: branchId,
            order: order,
            lines: receivableLines,
            receivedAt: DateTime.now(),
          ),
        );
      },
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
