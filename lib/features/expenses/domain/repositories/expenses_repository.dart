import 'package:dartz/dartz.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/features/expenses/data/models/expense_category_model.dart';
import 'package:frantend/features/expenses/data/models/expense_model.dart';
import 'package:frantend/features/expenses/data/models/expense_payment_response_model.dart';
import 'package:frantend/features/expenses/data/models/paginated_expenses_model.dart';

abstract class ExpensesRepository {
  Future<Either<Failure, List<ExpenseCategoryModel>>> getCategories();

  Future<Either<Failure, ExpenseCategoryModel>> createCategory(
    Map<String, dynamic> body,
  );

  Future<Either<Failure, ExpenseCategoryModel>> updateCategory(
    String id,
    Map<String, dynamic> body,
  );

  Future<Either<Failure, void>> deleteCategory(String id);

  Future<Either<Failure, PaginatedExpensesModel>> getExpenses({
    String? branchId,
    String? categoryId,
    String? supplierId,
    DateTime? dateFrom,
    DateTime? dateTo,
    int skip = 0,
    int limit = 50,
  });

  Future<Either<Failure, ExpenseModel>> getExpenseById(String id);

  Future<Either<Failure, ExpenseModel>> createExpense(
    Map<String, dynamic> body,
  );

  Future<Either<Failure, ExpenseModel>> updateExpense(
    String id,
    Map<String, dynamic> body,
  );

  Future<Either<Failure, void>> deleteExpense(String id);

  Future<Either<Failure, ExpensePaymentResponseModel>> addPayment(
    String expenseId,
    Map<String, dynamic> body,
  );
}
