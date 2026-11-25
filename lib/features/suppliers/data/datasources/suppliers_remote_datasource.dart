import 'package:dio/dio.dart';
import 'package:frantend/core/constants/api_constants.dart';
import 'package:frantend/core/network/dio_client.dart';
import 'package:frantend/features/khata/data/models/khata_models.dart';
import 'package:frantend/features/suppliers/data/models/supplier_model.dart';
import 'package:injectable/injectable.dart';

abstract class SuppliersRemoteDataSource {
  Future<List<SupplierModel>> getSuppliers();

  Future<SupplierModel> getSupplier(String id);

  Future<SupplierModel> createSupplier(Map<String, dynamic> body);

  Future<SupplierModel> updateSupplier(String id, Map<String, dynamic> body);

  Future<void> deleteSupplier(String id);

  Future<SupplierBalanceModel> getSupplierBalance(
    String supplierId, {
    String? branchId,
  });

  Future<SupplierLedgerPage> getLedger(
    String supplierId, {
    String? branchId,
    int skip = 0,
    int limit = 50,
  });

  /// `POST /suppliers/payments`. [idempotencyKey] is reused on a retry of the
  /// same payment so a lost answer never pays twice.
  Future<SupplierPaymentResult> paySupplier(
    Map<String, dynamic> body, {
    String? idempotencyKey,
  });

  Future<PaymentReversalResult> reversePayment(
    String paymentId,
    Map<String, dynamic> body, {
    String? idempotencyKey,
  });
}

@LazySingleton(as: SuppliersRemoteDataSource)
class SuppliersRemoteDataSourceImpl implements SuppliersRemoteDataSource {
  SuppliersRemoteDataSourceImpl(this._dioClient);

  final DioClient _dioClient;

  Dio get _dio => _dioClient.dio;

  @override
  Future<List<SupplierModel>> getSuppliers() async {
    final response = await _dio.get<dynamic>(ApiConstants.suppliers);
    return _toModelList(response.data, SupplierModel.fromJson);
  }

  @override
  Future<SupplierModel> getSupplier(String id) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '${ApiConstants.suppliers}/$id',
    );
    return SupplierModel.fromJson(response.data ?? const {});
  }

  @override
  Future<SupplierModel> createSupplier(Map<String, dynamic> body) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiConstants.suppliers,
      data: body,
    );
    return SupplierModel.fromJson(response.data ?? const {});
  }

  @override
  Future<SupplierModel> updateSupplier(
    String id,
    Map<String, dynamic> body,
  ) async {
    final response = await _dio.put<Map<String, dynamic>>(
      '${ApiConstants.suppliers}/$id',
      data: body,
    );
    return SupplierModel.fromJson(response.data ?? const {});
  }

  @override
  Future<void> deleteSupplier(String id) async {
    await _dio.delete<void>('${ApiConstants.suppliers}/$id');
  }

  @override
  Future<SupplierBalanceModel> getSupplierBalance(
    String supplierId, {
    String? branchId,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiConstants.supplierBalance(supplierId),
      queryParameters: branchId != null ? {'branch_id': branchId} : null,
    );
    return SupplierBalanceModel.fromJson(response.data ?? const {});
  }

  @override
  Future<SupplierLedgerPage> getLedger(
    String supplierId, {
    String? branchId,
    int skip = 0,
    int limit = 50,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiConstants.supplierLedger(supplierId),
      queryParameters: {
        'skip': skip,
        'limit': limit,
        if (branchId != null) 'branch_id': branchId,
      },
    );
    return SupplierLedgerPage.fromJson(response.data ?? const {});
  }

  @override
  Future<SupplierPaymentResult> paySupplier(
    Map<String, dynamic> body, {
    String? idempotencyKey,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiConstants.supplierPayments,
      data: body,
      options: _keyOptions(idempotencyKey),
    );
    return SupplierPaymentResult.fromJson(response.data ?? const {});
  }

  @override
  Future<PaymentReversalResult> reversePayment(
    String paymentId,
    Map<String, dynamic> body, {
    String? idempotencyKey,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiConstants.supplierPaymentReverse(paymentId),
      data: body,
      options: _keyOptions(idempotencyKey),
    );
    return PaymentReversalResult.fromJson(response.data ?? const {});
  }

  Options? _keyOptions(String? key) => key == null
      ? null
      : Options(headers: {'Idempotency-Key': key});

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
