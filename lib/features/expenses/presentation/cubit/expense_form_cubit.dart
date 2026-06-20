import 'package:decimal/decimal.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/utils/decimal_utils.dart';
import 'package:frantend/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:frantend/features/expenses/data/models/expense_category_model.dart';
import 'package:frantend/features/expenses/data/models/expense_model.dart';
import 'package:frantend/features/suppliers/data/models/supplier_model.dart';
import 'package:frantend/features/expenses/domain/usecases/expenses_usecases.dart';
import 'package:frantend/features/expenses/presentation/cubit/expense_form_state.dart';
import 'package:frantend/features/pos/data/models/payment_line_model.dart';
import 'package:frantend/features/pos/domain/usecases/pos_usecases.dart';
import 'package:frantend/features/suppliers/domain/usecases/supplier_usecases.dart';
import 'package:injectable/injectable.dart';

@injectable
class ExpenseFormCubit extends Cubit<ExpenseFormState> {
  ExpenseFormCubit({
    required GetExpenseCategoriesUseCase getExpenseCategoriesUseCase,
    required GetSuppliersUseCase getSuppliersUseCase,
    required GetExpenseByIdUseCase getExpenseByIdUseCase,
    required CreateExpenseUseCase createExpenseUseCase,
    required UpdateExpenseUseCase updateExpenseUseCase,
    required GetActiveShiftUseCase getActiveShiftUseCase,
    required GetRegistersUseCase getRegistersUseCase,
    required AuthLocalDataSource authLocalDataSource,
  })  : _getCategories = getExpenseCategoriesUseCase,
        _getSuppliers = getSuppliersUseCase,
        _getExpense = getExpenseByIdUseCase,
        _createExpense = createExpenseUseCase,
        _updateExpense = updateExpenseUseCase,
        _getActiveShift = getActiveShiftUseCase,
        _getRegisters = getRegistersUseCase,
        _authLocal = authLocalDataSource,
        super(const ExpenseFormState());

  final GetExpenseCategoriesUseCase _getCategories;
  final GetSuppliersUseCase _getSuppliers;
  final GetExpenseByIdUseCase _getExpense;
  final CreateExpenseUseCase _createExpense;
  final UpdateExpenseUseCase _updateExpense;
  final GetActiveShiftUseCase _getActiveShift;
  final GetRegistersUseCase _getRegisters;
  final AuthLocalDataSource _authLocal;

  Future<void> init({String? expenseId}) async {
    emit(state.copyWith(isLoading: true, expenseId: expenseId, errors: {}));

    final user = await _authLocal.getCachedUser();
    final branchId = user?.branchId;

    final categoriesResult = await _getCategories();
    final suppliersResult = await _getSuppliers();

    final categories = categoriesResult.fold(
      (_) => <ExpenseCategoryModel>[],
      (c) => c,
    );
    final suppliers = suppliersResult.fold(
      (_) => <SupplierModel>[],
      (s) => s,
    );

    if (expenseId != null) {
      final expenseResult = await _getExpense(expenseId);
      expenseResult.fold(
        (f) => emit(
          state.copyWith(isLoading: false, errors: {'_general': f.message}),
        ),
        (expense) {
          emit(
            state.copyWith(
              isLoading: false,
              expenseId: expenseId,
              branchId: expense.branchId,
              categoryId: expense.expenseCategoryId,
              supplierId: expense.supplierId,
              amount: expense.amount,
              taxAmount: expense.taxAmount,
              description: expense.description ?? '',
              expenseDate: _parseDate(expense.expenseDate),
              categories: categories,
              suppliers: suppliers,
            ),
          );
        },
      );
    } else {
      emit(
        state.copyWith(
          isLoading: false,
          branchId: branchId,
          expenseDate: DateTime.now(),
          categories: categories,
          suppliers: suppliers,
        ),
      );
    }
  }

  DateTime _parseDate(String value) {
    try {
      return DateTime.parse(value);
    } catch (_) {
      return DateTime.now();
    }
  }

  void setCategoryId(String? value) =>
      emit(state.copyWith(categoryId: value, errors: {}));

  void setSupplierId(String? value) =>
      emit(state.copyWith(supplierId: value, errors: {}));

  void setAmount(String value) => emit(state.copyWith(amount: value, errors: {}));

  void setTaxAmount(String value) =>
      emit(state.copyWith(taxAmount: value, errors: {}));

  void setDescription(String value) =>
      emit(state.copyWith(description: value, errors: {}));

  void setExpenseDate(DateTime value) =>
      emit(state.copyWith(expenseDate: value, errors: {}));

  void setRecordPaymentNow(bool value) =>
      emit(state.copyWith(recordPaymentNow: value, errors: {}));

  void setPaymentMethod(String value) =>
      emit(state.copyWith(paymentMethod: value, errors: {}));

  void setPaymentAmount(String value) =>
      emit(state.copyWith(paymentAmount: value, errors: {}));

  void setReferenceNo(String? value) =>
      emit(state.copyWith(referenceNo: value, errors: {}));

  Future<void> checkPaymentShift() async {
    emit(
      state.copyWith(
        isCheckingPaymentShift: true,
        activePaymentShiftId: null,
      ),
    );
    final shiftId = await _resolveActiveShiftId();
    emit(
      state.copyWith(
        isCheckingPaymentShift: false,
        activePaymentShiftId: shiftId,
      ),
    );
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

  Map<String, String> _validate() {
    final errors = <String, String>{};
    if (state.categoryId == null || state.categoryId!.isEmpty) {
      errors['category'] = 'Category is required';
    }
    if (state.amount.trim().isEmpty) {
      errors['amount'] = 'Amount is required';
    } else {
      try {
        final amount = DecimalUtils.parse(state.amount);
        if (amount <= Decimal.zero) {
          errors['amount'] = 'Amount must be greater than zero';
        }
      } catch (_) {
        errors['amount'] = 'Invalid amount';
      }
    }
    if (state.description.trim().isEmpty) {
      errors['description'] = 'Description is required';
    }
    if (state.expenseDate == null) {
      errors['expenseDate'] = 'Date is required';
    }
    if (state.recordPaymentNow && state.expenseId == null) {
      final payAmount = state.paymentAmount.trim().isEmpty
          ? state.amount
          : state.paymentAmount;
      if (payAmount.isEmpty) {
        errors['paymentAmount'] = 'Payment amount is required';
      } else {
        try {
          final parsed = DecimalUtils.parse(payAmount);
          if (parsed <= Decimal.zero) {
            errors['paymentAmount'] = 'Payment amount must be greater than zero';
          }
        } catch (_) {
          errors['paymentAmount'] = 'Invalid payment amount';
        }
      }
      if (state.paymentMethod != PaymentMethods.cash &&
          (state.referenceNo == null || state.referenceNo!.trim().isEmpty)) {
        errors['referenceNo'] = 'Reference number is required';
      }
    }
    return errors;
  }

  String _formatDate(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }

  Future<ExpenseModel?> save() async {
    final errors = _validate();
    if (errors.isNotEmpty) {
      emit(state.copyWith(errors: errors));
      return null;
    }

    emit(state.copyWith(isSaving: true, errors: {}));

    if (state.expenseId != null) {
      final body = <String, dynamic>{
        'description': state.description.trim(),
        'expense_date': _formatDate(state.expenseDate!),
        'amount': DecimalUtils.format(DecimalUtils.parse(state.amount)),
        'tax_amount': DecimalUtils.format(
          DecimalUtils.parse(
            state.taxAmount.trim().isEmpty ? '0' : state.taxAmount,
          ),
        ),
      };
      final result = await _updateExpense(state.expenseId!, body);
      return result.fold(
        (f) {
          emit(state.copyWith(isSaving: false, errors: {'_general': f.message}));
          return null;
        },
        (expense) {
          emit(state.copyWith(isSaving: false));
          return expense;
        },
      );
    }

    final total = DecimalUtils.add(
      DecimalUtils.parse(state.amount),
      DecimalUtils.parse(state.taxAmount.trim().isEmpty ? '0' : state.taxAmount),
    );

    final payments = <Map<String, dynamic>>[];
    if (state.recordPaymentNow) {
      final payAmount = state.paymentAmount.trim().isEmpty
          ? DecimalUtils.format(total)
          : DecimalUtils.format(DecimalUtils.parse(state.paymentAmount));
      payments.add({
        'payment_method': state.paymentMethod,
        'amount': payAmount,
        if (state.paymentMethod != PaymentMethods.cash &&
            state.referenceNo != null &&
            state.referenceNo!.trim().isNotEmpty)
          'reference_no': state.referenceNo!.trim(),
      });
    }

    final body = <String, dynamic>{
      'branch_id': state.branchId,
      'expense_category_id': state.categoryId,
      'amount': DecimalUtils.format(DecimalUtils.parse(state.amount)),
      'tax_amount': DecimalUtils.format(
        DecimalUtils.parse(
          state.taxAmount.trim().isEmpty ? '0' : state.taxAmount,
        ),
      ),
      'description': state.description.trim(),
      'expense_date': _formatDate(state.expenseDate!),
      if (state.supplierId != null) 'supplier_id': state.supplierId,
      'payments': payments,
    };

    final result = await _createExpense(body);
    return result.fold(
      (f) {
        emit(state.copyWith(isSaving: false, errors: {'_general': f.message}));
        return null;
      },
      (expense) {
        emit(state.copyWith(isSaving: false));
        return expense;
      },
    );
  }

  void appendCategory(ExpenseCategoryModel category) {
    final exists = state.categories.any((c) => c.id == category.id);
    if (!exists) {
      emit(
        state.copyWith(
          categories: [...state.categories, category],
          categoryId: category.id,
        ),
      );
    } else {
      emit(state.copyWith(categoryId: category.id));
    }
  }
}
