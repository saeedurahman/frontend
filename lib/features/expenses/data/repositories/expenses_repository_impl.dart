import 'package:dartz/dartz.dart';
import 'package:frantend/core/error/error_handler.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/features/expenses/data/datasources/expenses_remote_datasource.dart';
import 'package:frantend/features/expenses/data/models/expense_category_model.dart';
import 'package:frantend/features/expenses/data/models/expense_model.dart';
import 'package:frantend/features/expenses/data/models/expense_payment_response_model.dart';
import 'package:frantend/features/expenses/data/models/paginated_expenses_model.dart';
import 'package:frantend/features/expenses/domain/repositories/expenses_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ExpensesRepository)
class ExpensesRepositoryImpl implements ExpensesRepository {
  ExpensesRepositoryImpl({
    required ExpensesRemoteDataSource remoteDataSource,
    required ErrorHandler errorHandler,
  })  : _remote = remoteDataSource,
        _errorHandler = errorHandler;

  final ExpensesRemoteDataSource _remote;
  final ErrorHandler _errorHandler;

  @override
  Future<Either<Failure, List<ExpenseCategoryModel>>> getCategories() async {
    try {
      return Right(await _remote.getCategories());
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, ExpenseCategoryModel>> createCategory(
    Map<String, dynamic> body,
  ) async {
    try {
      return Right(await _remote.createCategory(body));
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, ExpenseCategoryModel>> updateCategory(
    String id,
    Map<String, dynamic> body,
  ) async {
    try {
      return Right(await _remote.updateCategory(id, body));
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> deleteCategory(String id) async {
    try {
      await _remote.deleteCategory(id);
      return const Right(null);
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, PaginatedExpensesModel>> getExpenses({
    String? branchId,
    String? categoryId,
    String? supplierId,
    DateTime? dateFrom,
    DateTime? dateTo,
    int skip = 0,
    int limit = 50,
  }) async {
    try {
      final result = await _remote.getExpenses(
        branchId: branchId,
        categoryId: categoryId,
        supplierId: supplierId,
        dateFrom: dateFrom,
        dateTo: dateTo,
        skip: skip,
        limit: limit,
      );
      return Right(result);
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, ExpenseModel>> getExpenseById(String id) async {
    try {
      return Right(await _remote.getExpenseById(id));
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, ExpenseModel>> createExpense(
    Map<String, dynamic> body,
  ) async {
    try {
      return Right(await _remote.createExpense(body));
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, ExpenseModel>> updateExpense(
    String id,
    Map<String, dynamic> body,
  ) async {
    try {
      return Right(await _remote.updateExpense(id, body));
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> deleteExpense(String id) async {
    try {
      await _remote.deleteExpense(id);
      return const Right(null);
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, ExpensePaymentResponseModel>> addPayment(
    String expenseId,
    Map<String, dynamic> body,
  ) async {
    try {
      return Right(await _remote.addPayment(expenseId, body));
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }
}
