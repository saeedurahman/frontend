import 'package:decimal/decimal.dart';
import 'package:frantend/core/utils/decimal_utils.dart';
import 'package:frantend/features/expenses/data/models/expense_category_model.dart';
import 'package:frantend/features/expenses/data/models/expense_model.dart';

abstract final class ExpenseStatus {
  static const pending = 'pending';
  static const partiallyPaid = 'partially_paid';
  static const paid = 'paid';
}

abstract final class ExpenseCalculations {
  static Decimal expenseTotal(ExpenseModel expense) {
    final amount = DecimalUtils.parse(expense.amount);
    final tax = DecimalUtils.parse(expense.taxAmount);
    return DecimalUtils.add(amount, tax);
  }

  static Decimal paidTotal(ExpenseModel expense) {
    var sum = Decimal.zero;
    for (final payment in expense.payments) {
      sum = DecimalUtils.add(sum, DecimalUtils.parse(payment.amount));
    }
    return sum;
  }

  static Decimal remainingBalance(ExpenseModel expense) {
    final total = expenseTotal(expense);
    final paid = paidTotal(expense);
    return DecimalUtils.subtract(total, paid);
  }

  static String deriveStatus(ExpenseModel expense) {
    final total = expenseTotal(expense);
    final paid = paidTotal(expense);
    if (paid <= Decimal.zero) return ExpenseStatus.pending;
    if (paid < total) return ExpenseStatus.partiallyPaid;
    return ExpenseStatus.paid;
  }

  static Decimal sumAmounts(Iterable<String> amounts) {
    var sum = Decimal.zero;
    for (final amount in amounts) {
      sum = DecimalUtils.add(sum, DecimalUtils.parse(amount));
    }
    return sum;
  }
}

List<ExpenseCategoryModel> flattenExpenseCategories(
  List<ExpenseCategoryModel> categories,
) {
  final seen = <String>{};
  final result = <ExpenseCategoryModel>[];

  void walk(List<ExpenseCategoryModel> nodes) {
    for (final category in nodes) {
      if (seen.add(category.id)) {
        result.add(category);
        if (category.children.isNotEmpty) {
          walk(category.children);
        }
      }
    }
  }

  walk(categories);
  return result;
}

String? categoryNameForId(
  List<ExpenseCategoryModel> categories,
  String? categoryId,
) {
  if (categoryId == null) return null;
  for (final c in flattenExpenseCategories(categories)) {
    if (c.id == categoryId) return c.name;
  }
  return null;
}

String paymentMethodLabel(String method) {
  return switch (method) {
    'cash' => 'Cash',
    'card' => 'Card',
    'bank_transfer' => 'Bank Transfer',
    'wallet' => 'Wallet',
    'cheque' => 'Cheque',
    'other' => 'Other',
    _ => method,
  };
}

String expenseStatusLabel(String status) {
  return switch (status) {
    ExpenseStatus.pending => 'Pending',
    ExpenseStatus.partiallyPaid => 'Partially Paid',
    ExpenseStatus.paid => 'Paid',
    _ => status,
  };
}

bool canEditExpense(ExpenseModel expense) => expense.payments.isEmpty;

bool canDeleteExpense(ExpenseModel expense) => true;
