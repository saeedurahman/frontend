import 'package:frantend/features/expenses/data/models/expense_list_item_model.dart';

/// A repository that holds expenses the server does not have yet.
abstract interface class PendingExpensesSource {
  /// Newest first, narrowed the same way as the server's list.
  Future<List<ExpenseListItemModel>> pendingExpenses({
    String? branchId,
    String? categoryId,
    String? supplierId,
    DateTime? dateFrom,
    DateTime? dateTo,
  });
}
