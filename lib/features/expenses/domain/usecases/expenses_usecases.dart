import 'package:dartz/dartz.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/features/expenses/data/models/expense_category_model.dart';
import 'package:frantend/features/expenses/data/models/expense_model.dart';
import 'package:frantend/features/expenses/data/models/expense_payment_response_model.dart';
import 'package:frantend/features/expenses/data/models/paginated_expenses_model.dart';
import 'package:frantend/features/expenses/domain/repositories/expenses_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetExpenseCategoriesUseCase {
  const GetExpenseCategoriesUseCase(this._repository);

  final ExpensesRepository _repository;

  Future<Either<Failure, List<ExpenseCategoryModel>>> call() =>
      _repository.getCategories();
}

@injectable
class CreateExpenseCategoryUseCase {
  const CreateExpenseCategoryUseCase(this._repository);

  final ExpensesRepository _repository;

  Future<Either<Failure, ExpenseCategoryModel>> call(
    Map<String, dynamic> body,
  ) =>
      _repository.createCategory(body);
}

@injectable
class DeleteExpenseCategoryUseCase {
  const DeleteExpenseCategoryUseCase(this._repository);

  final ExpensesRepository _repository;

  Future<Either<Failure, void>> call(String id) =>
      _repository.deleteCategory(id);
}

@injectable
class GetExpensesUseCase {
  const GetExpensesUseCase(this._repository);

  final ExpensesRepository _repository;

  Future<Either<Failure, PaginatedExpensesModel>> call({
    String? branchId,
    String? categoryId,
    String? supplierId,
    DateTime? dateFrom,
    DateTime? dateTo,
    int skip = 0,
    int limit = 50,
  }) =>
      _repository.getExpenses(
        branchId: branchId,
        categoryId: categoryId,
        supplierId: supplierId,
        dateFrom: dateFrom,
        dateTo: dateTo,
        skip: skip,
        limit: limit,
      );
}

@injectable
class GetExpenseByIdUseCase {
  const GetExpenseByIdUseCase(this._repository);

  final ExpensesRepository _repository;

  Future<Either<Failure, ExpenseModel>> call(String id) =>
      _repository.getExpenseById(id);
}

@injectable
class CreateExpenseUseCase {
  const CreateExpenseUseCase(this._repository);

  final ExpensesRepository _repository;

  Future<Either<Failure, ExpenseModel>> call(Map<String, dynamic> body) =>
      _repository.createExpense(body);
}

@injectable
class UpdateExpenseUseCase {
  const UpdateExpenseUseCase(this._repository);

  final ExpensesRepository _repository;

  Future<Either<Failure, ExpenseModel>> call(
    String id,
    Map<String, dynamic> body,
  ) =>
      _repository.updateExpense(id, body);
}

@injectable
class DeleteExpenseUseCase {
  const DeleteExpenseUseCase(this._repository);

  final ExpensesRepository _repository;

  Future<Either<Failure, void>> call(String id) =>
      _repository.deleteExpense(id);
}

@injectable
class AddExpensePaymentUseCase {
  const AddExpensePaymentUseCase(this._repository);

  final ExpensesRepository _repository;

  Future<Either<Failure, ExpensePaymentResponseModel>> call(
    String expenseId,
    Map<String, dynamic> body,
  ) =>
      _repository.addPayment(expenseId, body);
}
