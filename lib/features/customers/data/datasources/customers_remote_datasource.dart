import 'package:dio/dio.dart';
import 'package:frantend/core/constants/api_constants.dart';
import 'package:frantend/core/network/dio_client.dart';
import 'package:frantend/features/customers/data/models/customer_balance_model.dart';
import 'package:frantend/features/khata/data/models/khata_models.dart';
import 'package:frantend/features/customers/data/models/customer_ledger_entry_model.dart';
import 'package:frantend/features/customers/data/models/customer_model.dart';
import 'package:frantend/features/customers/data/models/customer_payment_response_model.dart';
import 'package:injectable/injectable.dart';

abstract class CustomersRemoteDataSource {
  Future<List<CustomerModel>> getCustomers({String? search});

  Future<CustomerModel> getCustomer(String id);

  Future<CustomerModel> createCustomer(Map<String, dynamic> body);

  Future<CustomerModel> updateCustomer(String id, Map<String, dynamic> body);

  Future<CustomerBalanceModel> getCustomerBalance(
    String customerId, {
    String? branchId,
  });

  Future<List<CustomerLedgerEntryModel>> getCustomerLedger(
    String customerId, {
    String? branchId,
    int? skip,
    int? limit,
  });

  Future<CustomerPaymentResponseModel> recordPayment(
    String customerId,
    Map<String, dynamic> body,
  );

  /// Undoes a customer payment: a new row is added, the original stays.
  Future<PaymentReversalResult> reversePayment(
    String paymentId,
    Map<String, dynamic> body, {
    String? idempotencyKey,
  });
}

@LazySingleton(as: CustomersRemoteDataSource)
class CustomersRemoteDataSourceImpl implements CustomersRemoteDataSource {
  CustomersRemoteDataSourceImpl(this._dioClient);

  final DioClient _dioClient;

  Dio get _dio => _dioClient.dio;

  @override
  Future<List<CustomerModel>> getCustomers({String? search}) async {
    final response = await _dio.get<dynamic>(
      ApiConstants.customers,
      queryParameters:
          search != null && search.isNotEmpty ? {'search': search} : null,
    );
    return _toModelList(response.data, CustomerModel.fromJson);
  }

  @override
  Future<CustomerModel> getCustomer(String id) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '${ApiConstants.customers}/$id',
    );
    return CustomerModel.fromJson(response.data ?? const {});
  }

  @override
  Future<CustomerModel> createCustomer(Map<String, dynamic> body) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiConstants.customers,
      data: body,
    );
    return CustomerModel.fromJson(response.data ?? const {});
  }

  @override
  Future<CustomerModel> updateCustomer(
    String id,
    Map<String, dynamic> body,
  ) async {
    final response = await _dio.put<Map<String, dynamic>>(
      '${ApiConstants.customers}/$id',
      data: body,
    );
    return CustomerModel.fromJson(response.data ?? const {});
  }

  @override
  Future<CustomerBalanceModel> getCustomerBalance(
    String customerId, {
    String? branchId,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiConstants.customerBalance(customerId),
      queryParameters: branchId != null ? {'branch_id': branchId} : null,
    );
    return CustomerBalanceModel.fromJson(response.data ?? const {});
  }

  @override
  Future<List<CustomerLedgerEntryModel>> getCustomerLedger(
    String customerId, {
    String? branchId,
    int? skip,
    int? limit,
  }) async {
    final queryParams = <String, dynamic>{};
    if (branchId != null) queryParams['branch_id'] = branchId;
    if (skip != null) queryParams['skip'] = skip;
    if (limit != null) queryParams['limit'] = limit;

    final response = await _dio.get<dynamic>(
      ApiConstants.customerLedger(customerId),
      queryParameters: queryParams.isEmpty ? null : queryParams,
    );
    return _toModelList(response.data, CustomerLedgerEntryModel.fromJson);
  }

  @override
  Future<CustomerPaymentResponseModel> recordPayment(
    String customerId,
    Map<String, dynamic> body,
  ) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiConstants.customerPayments(customerId),
      data: body,
    );
    return CustomerPaymentResponseModel.fromJson(response.data ?? const {});
  }

  @override
  Future<PaymentReversalResult> reversePayment(
    String paymentId,
    Map<String, dynamic> body, {
    String? idempotencyKey,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiConstants.customerPaymentReverse(paymentId),
      data: body,
      options: idempotencyKey == null
          ? null
          : Options(headers: {'Idempotency-Key': idempotencyKey}),
    );
    return PaymentReversalResult.fromJson(response.data ?? const {});
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
