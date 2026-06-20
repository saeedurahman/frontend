import 'package:decimal/decimal.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/utils/decimal_utils.dart';
import 'package:frantend/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:frantend/features/expenses/data/models/expense_category_model.dart';
import 'package:frantend/features/expenses/domain/usecases/expenses_usecases.dart';
import 'package:frantend/features/expenses/presentation/cubit/expense_detail_state.dart';
import 'package:frantend/features/pos/domain/usecases/pos_usecases.dart';
import 'package:frantend/features/suppliers/domain/usecases/supplier_usecases.dart';
import 'package:injectable/injectable.dart';

@injectable
class ExpenseDetailCubit extends Cubit<ExpenseDetailState> {
  ExpenseDetailCubit({
    required GetExpenseByIdUseCase getExpenseByIdUseCase,
    required GetExpenseCategoriesUseCase getExpenseCategoriesUseCase,
    required GetSupplierUseCase getSupplierUseCase,
    required DeleteExpenseUseCase deleteExpenseUseCase,
    required AddExpensePaymentUseCase addExpensePaymentUseCase,
    required GetActiveShiftUseCase getActiveShiftUseCase,
    required GetRegistersUseCase getRegistersUseCase,
    required AuthLocalDataSource authLocalDataSource,
  })  : _getExpense = getExpenseByIdUseCase,
        _getCategories = getExpenseCategoriesUseCase,
        _getSupplier = getSupplierUseCase,
        _deleteExpense = deleteExpenseUseCase,
        _addPayment = addExpensePaymentUseCase,
        _getActiveShift = getActiveShiftUseCase,
        _getRegisters = getRegistersUseCase,
        _authLocal = authLocalDataSource,
        super(const ExpenseDetailState.initial());

  final GetExpenseByIdUseCase _getExpense;
  final GetExpenseCategoriesUseCase _getCategories;
  final GetSupplierUseCase _getSupplier;
  final DeleteExpenseUseCase _deleteExpense;
  final AddExpensePaymentUseCase _addPayment;
  final GetActiveShiftUseCase _getActiveShift;
  final GetRegistersUseCase _getRegisters;
  final AuthLocalDataSource _authLocal;

  String? _expenseId;

  void clearPaymentError() {
    final current = state;
    if (current is ExpenseDetailLoaded) {
      emit(current.copyWith(paymentError: null));
    }
  }

  Future<void> load(String expenseId) async {
    _expenseId = expenseId;
    emit(const ExpenseDetailState.loading());

    final expenseResult = await _getExpense(expenseId);
    await expenseResult.fold(
      (f) async => emit(ExpenseDetailState.error(f.message)),
      (expense) async {
        final categoriesResult = await _getCategories();
        final categories = categoriesResult.fold(
          (_) => <ExpenseCategoryModel>[],
          (c) => c,
        );

        if (expense.supplierId != null) {
          final supplierResult = await _getSupplier(expense.supplierId!);
          supplierResult.fold(
            (_) => emit(
              ExpenseDetailState.loaded(
                expense: expense,
                categories: categories,
              ),
            ),
            (supplier) => emit(
              ExpenseDetailState.loaded(
                expense: expense,
                categories: categories,
                supplier: supplier,
              ),
            ),
          );
        } else {
          emit(
            ExpenseDetailState.loaded(
              expense: expense,
              categories: categories,
            ),
          );
        }
      },
    );
  }

  Future<void> checkPaymentShift() async {
    final current = state;
    if (current is! ExpenseDetailLoaded) return;

    emit(
      current.copyWith(
        isCheckingPaymentShift: true,
        activePaymentShiftId: null,
      ),
    );

    final shiftId = await _resolveActiveShiftId();
    final updated = state;
    if (updated is ExpenseDetailLoaded) {
      emit(
        updated.copyWith(
          isCheckingPaymentShift: false,
          activePaymentShiftId: shiftId,
        ),
      );
    }
  }

  Future<String?> _resolveActiveShiftId() async {
    final user = await _authLocal.getCachedUser();
    final branchId = user?.branchId;
    if (branchId == null) return null;

    final registersResult = await _getRegisters(branchId: branchId);
    return registersResult.fold(
      (_) async => null,
      (registers) async {
        if (registers.isEmpty) return null;
        final shiftResult = await _getActiveShift(registers.first.id);
        return shiftResult.fold((_) => null, (shift) => shift?.id);
      },
    );
  }

  Future<bool> recordPayment({
    required Decimal amount,
    required String paymentMethod,
    String? referenceNo,
  }) async {
    final current = state;
    if (current is! ExpenseDetailLoaded || _expenseId == null) return false;

    emit(
      current.copyWith(
        isRecordingPayment: true,
        paymentError: null,
      ),
    );

    final body = <String, dynamic>{
      'amount': DecimalUtils.format(amount),
      'payment_method': paymentMethod,
      if (referenceNo != null && referenceNo.isNotEmpty)
        'reference_no': referenceNo,
    };

    final result = await _addPayment(_expenseId!, body);

    return await result.fold<Future<bool>>(
      (failure) async {
        emit(
          current.copyWith(
            isRecordingPayment: false,
            paymentError: failure.message,
          ),
        );
        return false;
      },
      (response) async {
        await _reloadAfterPayment(current);
        return true;
      },
    );
  }

  Future<void> _reloadAfterPayment(ExpenseDetailLoaded previous) async {
    if (_expenseId == null) return;

    final expenseResult = await _getExpense(_expenseId!);
    expenseResult.fold(
      (failure) {
        emit(
          previous.copyWith(
            isRecordingPayment: false,
            paymentError: failure.message,
          ),
        );
      },
      (expense) {
        emit(
          previous.copyWith(
            expense: expense,
            isRecordingPayment: false,
            paymentError: null,
          ),
        );
      },
    );
  }

  Future<bool> deleteExpense() async {
    final current = state;
    if (current is! ExpenseDetailLoaded) return false;

    emit(current.copyWith(isDeleting: true));
    final result = await _deleteExpense(current.expense.id);
    return result.fold(
      (f) {
        emit(ExpenseDetailState.error(f.message));
        return false;
      },
      (_) => true,
    );
  }
}
