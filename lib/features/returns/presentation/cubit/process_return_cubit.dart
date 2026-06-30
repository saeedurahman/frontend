import 'package:decimal/decimal.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/utils/decimal_utils.dart';
import 'package:frantend/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:frantend/features/auth/domain/utils/user_role_utils.dart';
import 'package:frantend/features/cash_register/domain/usecases/cash_register_usecases.dart';
import 'package:frantend/features/customers/domain/usecases/customer_usecases.dart';
import 'package:frantend/features/pos/data/models/payment_line_model.dart';
import 'package:frantend/features/returns/data/models/refund_line_model.dart';
import 'package:frantend/features/returns/data/models/sale_return_response_model.dart';
import 'package:frantend/features/returns/domain/usecases/returns_usecases.dart';
import 'package:frantend/features/returns/presentation/cubit/process_return_state.dart';
import 'package:frantend/features/sales/data/models/sale_response_model.dart';
import 'package:frantend/features/sales/domain/usecases/sales_usecases.dart';
import 'package:frantend/features/sales/presentation/utils/sale_calculations.dart';
import 'package:injectable/injectable.dart';

@injectable
class ProcessReturnCubit extends Cubit<ProcessReturnState> {
  ProcessReturnCubit({
    required GetSaleByIdUseCase getSaleByIdUseCase,
    required GetCustomerUseCase getCustomerUseCase,
    required CreateSaleReturnUseCase createSaleReturnUseCase,
    required GetMyActiveShiftUseCase getMyActiveShiftUseCase,
    required AuthLocalDataSource authLocalDataSource,
  })  : _getSale = getSaleByIdUseCase,
        _getCustomer = getCustomerUseCase,
        _createReturn = createSaleReturnUseCase,
        _getMyActiveShift = getMyActiveShiftUseCase,
        _authLocal = authLocalDataSource,
        super(const ProcessReturnState());

  final GetSaleByIdUseCase _getSale;
  final GetCustomerUseCase _getCustomer;
  final CreateSaleReturnUseCase _createReturn;
  final GetMyActiveShiftUseCase _getMyActiveShift;
  final AuthLocalDataSource _authLocal;

  Future<void> load(String saleId) async {
    final user = await _authLocal.getCachedUser();
    if (!UserRoleUtils.canCreateReturns(
      role: user?.role,
      permissionKeys: user?.permissionKeys ?? const [],
    )) {
      emit(const ProcessReturnState(accessDenied: true));
      return;
    }

    emit(state.copyWith(isLoading: true, error: null, submitError: null));

    final result = await _getSale(saleId);
    await result.fold(
      (failure) async {
        emit(
          state.copyWith(
            isLoading: false,
            error: failure.message,
          ),
        );
      },
      (sale) async {
        if (!SaleStatus.canReturn(sale.saleStatus)) {
          emit(
            state.copyWith(
              isLoading: false,
              error: 'Returns are only allowed for completed or partially paid sales',
            ),
          );
          return;
        }

        var customer = sale.customer;
        final customerId = sale.customerId;
        if (customer == null && customerId != null) {
          final customerResult = await _getCustomer(customerId);
          customerResult.fold((_) {}, (c) => customer = c);
        }

        emit(
          state.copyWith(
            isLoading: false,
            originalSale: sale,
            customer: customer,
            returnLines: _buildReturnLines(sale),
          ),
        );
        await checkActiveShift();
      },
    );
  }

  List<ReturnLineFormItem> _buildReturnLines(SaleResponseModel sale) {
    return sale.lines.map((line) {
      return ReturnLineFormItem(
        originalSaleLineId: line.id,
        productId: line.productId,
        variationId: line.variationId,
        productName: line.productName ?? 'Product',
        variationName: line.variationName,
        originalQty: line.qty,
        alreadyReturnedQty: line.returnedQty,
        unitPrice: line.unitPrice,
        originalTaxAmount: line.taxAmount ?? '0',
        originalDiscountAmount: line.discountAmount,
      );
    }).toList();
  }

  void updateReturnQty(int lineIndex, Decimal qty) {
    final lines = [...state.returnLines];
    if (lineIndex < 0 || lineIndex >= lines.length) return;

    final line = lines[lineIndex];
    if (line.maxReturnableQty <= Decimal.zero) return;

    final maxQty = line.maxReturnableQty;
    final clamped = qty < Decimal.zero
        ? Decimal.zero
        : (qty > maxQty ? maxQty : qty);

    lines[lineIndex] = line.copyWith(
      returnQty: DecimalUtils.format(clamped),
    );
    emit(state.copyWith(returnLines: lines, submitError: null));
  }

  void returnAll(int lineIndex) {
    final lines = state.returnLines;
    if (lineIndex < 0 || lineIndex >= lines.length) return;
    if (lines[lineIndex].maxReturnableQty <= Decimal.zero) return;
    updateReturnQty(lineIndex, lines[lineIndex].maxReturnableQty);
  }

  void setReason(String? reason) {
    emit(state.copyWith(reason: reason, submitError: null));
  }

  void setNotes(String? notes) {
    emit(state.copyWith(notes: notes, submitError: null));
  }

  Future<void> checkActiveShift() async {
    emit(state.copyWith(isCheckingShift: true, activeShiftId: null));

    final shiftId = await _resolveActiveShiftId();
    emit(state.copyWith(isCheckingShift: false, activeShiftId: shiftId));
  }

  Future<String?> _resolveActiveShiftId() async {
    final shiftResult = await _getMyActiveShift();
    return shiftResult.fold((_) => null, (shift) => shift?.id);
  }

  void addRefundLine({
    required String method,
    required String label,
    String? walletLabel,
  }) {
    final remaining = state.remainingToRefund;
    final prefill = remaining > Decimal.zero ? remaining : Decimal.zero;
    final lines = [
      ...state.refundLines,
      RefundLineModel(
        paymentMethod: method,
        amount: prefill,
        label: label,
        walletLabel: walletLabel,
      ),
    ];
    emit(state.copyWith(refundLines: lines, submitError: null));
  }

  void updateRefundLineAmount(int index, Decimal amount) {
    final lines = [...state.refundLines];
    if (index < 0 || index >= lines.length) return;
    lines[index] = lines[index].copyWith(
      amount: amount < Decimal.zero ? Decimal.zero : amount,
    );
    emit(state.copyWith(refundLines: lines, submitError: null));
  }

  void removeRefundLine(int index) {
    final lines = [...state.refundLines];
    if (index < 0 || index >= lines.length) return;
    lines.removeAt(index);
    emit(state.copyWith(refundLines: lines, submitError: null));
  }

  Map<String, dynamic> _buildRequestBody() {
    final sale = state.originalSale!;
    final requestLines = <Map<String, dynamic>>[];

    for (final line in state.returnLines) {
      if (line.returnQtyDecimal <= Decimal.zero) continue;

      final netBeforeTax = (line.originalQtyDecimal * line.unitPriceDecimal) -
          line.originalDiscountAmountDecimal;
      final effectiveUnitPrice = line.originalQtyDecimal > Decimal.zero
          ? DecimalUtils.fromRational(
              netBeforeTax / line.originalQtyDecimal,
              fractionDigits: 4,
            )
          : line.unitPriceDecimal;
      final proratedTax = DecimalUtils.fromRational(
        line.originalTaxAmountDecimal *
            line.returnQtyDecimal /
            line.originalQtyDecimal,
        fractionDigits: 2,
      );

      requestLines.add({
        'product_id': line.productId,
        if (line.variationId != null) 'variation_id': line.variationId,
        'sale_line_id': line.originalSaleLineId,
        'qty': line.returnQty,
        'unit_price': DecimalUtils.format(effectiveUnitPrice),
        'tax_amount': DecimalUtils.format(proratedTax),
      });
    }

    final refundPayments = state.refundLines
        .where((line) => line.amount > Decimal.zero)
        .map(
          (line) => {
            'payment_method': line.paymentMethod,
            'amount': DecimalUtils.format(line.amount),
          },
        )
        .toList();

    String? registerShiftId;
    if (state.refundLines.any((l) => l.paymentMethod == PaymentMethods.cash)) {
      registerShiftId = state.activeShiftId;
    }

    return {
      'branch_id': sale.branchId,
      'sale_id': sale.id,
      if (sale.customerId != null) 'customer_id': sale.customerId,
      if (registerShiftId != null) 'register_shift_id': registerShiftId,
      if (state.reason != null && state.reason!.isNotEmpty)
        'reason': state.reason,
      'lines': requestLines,
      'refund_payments': refundPayments,
    };
  }

  Future<SaleReturnResponseModel?> submitReturn() async {
    if (!state.canSubmit) return null;

    emit(state.copyWith(isSubmitting: true, submitError: null));

    if (state.hasCashRefund && state.activeShiftId == null) {
      final shiftId = await _resolveActiveShiftId();
      emit(state.copyWith(activeShiftId: shiftId));
    }

    final result = await _createReturn(_buildRequestBody());

    return result.fold(
      (failure) {
        emit(
          state.copyWith(
            isSubmitting: false,
            submitError: failure.message,
          ),
        );
        return null;
      },
      (response) {
        emit(state.copyWith(isSubmitting: false, submitError: null));
        return response;
      },
    );
  }
}
