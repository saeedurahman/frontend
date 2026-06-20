import 'package:dio/dio.dart';
import 'package:frantend/core/constants/api_constants.dart';
import 'package:frantend/core/network/dio_client.dart';
import 'package:frantend/features/suppliers/data/models/supplier_model.dart';
import 'package:injectable/injectable.dart';

abstract class SuppliersRemoteDataSource {
  Future<List<SupplierModel>> getSuppliers();

  Future<SupplierModel> getSupplier(String id);

  Future<SupplierModel> createSupplier(Map<String, dynamic> body);

  Future<SupplierModel> updateSupplier(String id, Map<String, dynamic> body);

  Future<void> deleteSupplier(String id);

  Future<SupplierBalanceModel> getSupplierBalance(String supplierId);
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
  Future<SupplierBalanceModel> getSupplierBalance(String supplierId) async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiConstants.supplierBalance(supplierId),
    );
    return SupplierBalanceModel.fromJson(response.data ?? const {});
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
