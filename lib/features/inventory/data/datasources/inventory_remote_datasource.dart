import 'package:dio/dio.dart';
import 'package:frantend/core/constants/api_constants.dart';
import 'package:frantend/core/network/dio_client.dart';
import 'package:frantend/features/inventory/data/models/stock_model.dart';
import 'package:injectable/injectable.dart';

abstract class InventoryRemoteDataSource {
  Future<StockBalanceModel> getStockBalance({
    required String branchId,
    required String productId,
    String? variationId,
  });

  Future<List<StockBalanceModel>> getStockBalances({
    required String branchId,
    List<String>? productIds,
  });

  Future<PaginatedStockMovementsModel> getStockMovements({
    required String branchId,
    String? productId,
    String? movementType,
    int skip = 0,
    int limit = 50,
  });

  Future<StockAdjustmentModel> createAdjustment(Map<String, dynamic> body);
}

@LazySingleton(as: InventoryRemoteDataSource)
class InventoryRemoteDataSourceImpl implements InventoryRemoteDataSource {
  InventoryRemoteDataSourceImpl(this._dioClient);

  final DioClient _dioClient;

  Dio get _dio => _dioClient.dio;

  @override
  Future<StockBalanceModel> getStockBalance({
    required String branchId,
    required String productId,
    String? variationId,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiConstants.stockBalance,
      queryParameters: {
        'branch_id': branchId,
        'product_id': productId,
        if (variationId != null) 'variation_id': variationId,
      },
    );
    return StockBalanceModel.fromJson(response.data ?? const {});
  }

  @override
  Future<List<StockBalanceModel>> getStockBalances({
    required String branchId,
    List<String>? productIds,
  }) async {
    final response = await _dio.get<dynamic>(
      ApiConstants.stockBalances,
      queryParameters: {
        'branch_id': branchId,
        if (productIds != null && productIds.isNotEmpty)
          'product_ids': productIds,
      },
      options: Options(
        listFormat: ListFormat.multi,
      ),
    );
    return _toModelList(response.data, StockBalanceModel.fromJson);
  }

  @override
  Future<PaginatedStockMovementsModel> getStockMovements({
    required String branchId,
    String? productId,
    String? movementType,
    int skip = 0,
    int limit = 50,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiConstants.stockMovements,
      queryParameters: {
        'branch_id': branchId,
        if (productId != null) 'product_id': productId,
        if (movementType != null) 'movement_type': movementType,
        'skip': skip,
        'limit': limit,
      },
    );
    return PaginatedStockMovementsModel.fromJson(response.data ?? const {});
  }

  @override
  Future<StockAdjustmentModel> createAdjustment(
    Map<String, dynamic> body,
  ) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiConstants.adjustments,
      data: body,
    );
    return StockAdjustmentModel.fromJson(response.data ?? const {});
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
