import 'package:dio/dio.dart';
import 'package:frantend/core/constants/api_constants.dart';
import 'package:frantend/core/network/dio_client.dart';
import 'package:frantend/features/expenses/data/models/expense_category_model.dart';
import 'package:frantend/features/expenses/data/models/expense_model.dart';
import 'package:frantend/features/expenses/data/models/expense_payment_response_model.dart';
import 'package:frantend/features/expenses/data/models/paginated_expenses_model.dart';
import 'package:injectable/injectable.dart';

abstract class ExpensesRemoteDataSource {
  Future<List<ExpenseCategoryModel>> getCategories();

  Future<ExpenseCategoryModel> createCategory(Map<String, dynamic> body);

  Future<ExpenseCategoryModel> updateCategory(
    String id,
    Map<String, dynamic> body,
  );

  Future<void> deleteCategory(String id);

  Future<PaginatedExpensesModel> getExpenses({
    String? branchId,
    String? categoryId,
    String? supplierId,
    DateTime? dateFrom,
    DateTime? dateTo,
    int skip = 0,
    int limit = 50,
  });

  Future<ExpenseModel> getExpenseById(String id);

  Future<ExpenseModel> createExpense(Map<String, dynamic> body);

  Future<ExpenseModel> updateExpense(String id, Map<String, dynamic> body);

  Future<void> deleteExpense(String id);

  Future<ExpensePaymentResponseModel> addPayment(
    String expenseId,
    Map<String, dynamic> body,
  );
}

@LazySingleton(as: ExpensesRemoteDataSource)
class ExpensesRemoteDataSourceImpl implements ExpensesRemoteDataSource {
  ExpensesRemoteDataSourceImpl(this._dioClient);

  final DioClient _dioClient;

  Dio get _dio => _dioClient.dio;

  @override
  Future<List<ExpenseCategoryModel>> getCategories() async {
    final response = await _dio.get<dynamic>(ApiConstants.expenseCategories);
    return _toModelList(response.data, ExpenseCategoryModel.fromJson);
  }

  @override
  Future<ExpenseCategoryModel> createCategory(Map<String, dynamic> body) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiConstants.expenseCategories,
      data: body,
    );
    return ExpenseCategoryModel.fromJson(response.data ?? const {});
  }

  @override
  Future<ExpenseCategoryModel> updateCategory(
    String id,
    Map<String, dynamic> body,
  ) async {
    final response = await _dio.put<Map<String, dynamic>>(
      ApiConstants.expenseCategoryById(id),
      data: body,
    );
    return ExpenseCategoryModel.fromJson(response.data ?? const {});
  }

  @override
  Future<void> deleteCategory(String id) async {
    await _dio.delete<void>(ApiConstants.expenseCategoryById(id));
  }

  @override
  Future<PaginatedExpensesModel> getExpenses({
    String? branchId,
    String? categoryId,
    String? supplierId,
    DateTime? dateFrom,
    DateTime? dateTo,
    int skip = 0,
    int limit = 50,
  }) async {
    final queryParams = <String, dynamic>{
      'skip': skip,
      'limit': limit,
    };
    if (branchId != null) queryParams['branch_id'] = branchId;
    if (categoryId != null) queryParams['category_id'] = categoryId;
    if (supplierId != null) queryParams['supplier_id'] = supplierId;
    if (dateFrom != null) {
      queryParams['date_from'] = _formatDate(dateFrom);
    }
    if (dateTo != null) {
      queryParams['date_to'] = _formatDate(dateTo);
    }

    final response = await _dio.get<Map<String, dynamic>>(
      ApiConstants.expenses,
      queryParameters: queryParams,
    );
    return PaginatedExpensesModel.fromJson(response.data ?? const {});
  }

  @override
  Future<ExpenseModel> getExpenseById(String id) async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiConstants.expenseById(id),
    );
    return ExpenseModel.fromJson(response.data ?? const {});
  }

  @override
  Future<ExpenseModel> createExpense(Map<String, dynamic> body) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiConstants.expenses,
      data: body,
    );
    return ExpenseModel.fromJson(response.data ?? const {});
  }

  @override
  Future<ExpenseModel> updateExpense(
    String id,
    Map<String, dynamic> body,
  ) async {
    final response = await _dio.put<Map<String, dynamic>>(
      ApiConstants.expenseById(id),
      data: body,
    );
    return ExpenseModel.fromJson(response.data ?? const {});
  }

  @override
  Future<void> deleteExpense(String id) async {
    await _dio.delete<void>(ApiConstants.expenseById(id));
  }

  @override
  Future<ExpensePaymentResponseModel> addPayment(
    String expenseId,
    Map<String, dynamic> body,
  ) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiConstants.expensePayments(expenseId),
      data: body,
    );
    return ExpensePaymentResponseModel.fromJson(response.data ?? const {});
  }

  String _formatDate(DateTime date) {
    final local = DateTime(date.year, date.month, date.day);
    return '${local.year.toString().padLeft(4, '0')}-'
        '${local.month.toString().padLeft(2, '0')}-'
        '${local.day.toString().padLeft(2, '0')}';
  }

  List<T> _toModelList<T>(
    dynamic payload,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    if (payload is List) {
      return payload
          .whereType<Map<dynamic, dynamic>>()
          .map((item) => fromJson(Map<String, dynamic>.from(item)))
          .toList();
    }
    if (payload is Map<String, dynamic>) {
      final list = payload['items'];
      if (list is List) {
        return list
            .whereType<Map<dynamic, dynamic>>()
            .map((item) => fromJson(Map<String, dynamic>.from(item)))
            .toList();
      }
    }
    return const [];
  }
}
