import 'package:dio/dio.dart';
import 'package:frantend/core/constants/api_constants.dart';
import 'package:frantend/core/network/dio_client.dart';
import 'package:frantend/features/manufacturing/data/models/bom_header_model.dart';
import 'package:frantend/features/manufacturing/data/models/bom_preview_model.dart';
import 'package:frantend/features/manufacturing/data/models/production_order_model.dart';
import 'package:injectable/injectable.dart';

abstract class ManufacturingRemoteDataSource {
  Future<List<BomHeaderModel>> listBoms({
    String? productId,
    bool activeOnly = false,
  });

  Future<List<BomHeaderModel>> listBomsByProduct(
    String productId, {
    String? variationId,
    bool activeOnly = false,
  });

  Future<BomHeaderModel> getBom(String id);

  Future<BomHeaderModel> createBom(Map<String, dynamic> body);

  Future<BomHeaderModel> updateBom(String id, Map<String, dynamic> body);

  Future<void> deleteBom(String id);

  Future<BomPreviewModel> previewBom({
    required String bomHeaderId,
    required String qtyToProduce,
  });

  Future<List<ProductionOrderModel>> listProductionOrders({
    String? branchId,
    String? status,
    String? bomHeaderId,
    int skip = 0,
    int limit = 50,
  });

  Future<ProductionOrderModel> getProductionOrder(String id);

  Future<ProductionOrderModel> createProductionOrder(Map<String, dynamic> body);

  Future<ProductionOrderModel> updateProductionOrder(
    String id,
    Map<String, dynamic> body,
  );

  Future<ProductionOrderModel> startProductionOrder(String id);

  Future<ProductionOrderModel> cancelProductionOrder(String id);

  Future<ProductionOrderModel> completeProductionOrder(
    String id, {
    required String qtyProduced,
  });
}

@LazySingleton(as: ManufacturingRemoteDataSource)
class ManufacturingRemoteDataSourceImpl
    implements ManufacturingRemoteDataSource {
  ManufacturingRemoteDataSourceImpl(this._dioClient);

  final DioClient _dioClient;

  Dio get _dio => _dioClient.dio;

  @override
  Future<List<BomHeaderModel>> listBoms({
    String? productId,
    bool activeOnly = false,
  }) async {
    final response = await _dio.get<dynamic>(
      ApiConstants.manufacturingBoms,
      queryParameters: {
        if (productId != null) 'product_id': productId,
        'active_only': activeOnly,
      },
    );
    return _toModelList(response.data, BomHeaderModel.fromJson);
  }

  @override
  Future<List<BomHeaderModel>> listBomsByProduct(
    String productId, {
    String? variationId,
    bool activeOnly = false,
  }) async {
    final response = await _dio.get<dynamic>(
      ApiConstants.manufacturingBomsByProduct(productId),
      queryParameters: {
        if (variationId != null) 'variation_id': variationId,
        'active_only': activeOnly,
      },
    );
    return _toModelList(response.data, BomHeaderModel.fromJson);
  }

  @override
  Future<BomHeaderModel> getBom(String id) async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiConstants.manufacturingBom(id),
    );
    return BomHeaderModel.fromJson(response.data ?? const {});
  }

  @override
  Future<BomHeaderModel> createBom(Map<String, dynamic> body) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiConstants.manufacturingBoms,
      data: body,
    );
    return BomHeaderModel.fromJson(response.data ?? const {});
  }

  @override
  Future<BomHeaderModel> updateBom(
    String id,
    Map<String, dynamic> body,
  ) async {
    final response = await _dio.put<Map<String, dynamic>>(
      ApiConstants.manufacturingBom(id),
      data: body,
    );
    return BomHeaderModel.fromJson(response.data ?? const {});
  }

  @override
  Future<void> deleteBom(String id) async {
    await _dio.delete<dynamic>(ApiConstants.manufacturingBom(id));
  }

  @override
  Future<BomPreviewModel> previewBom({
    required String bomHeaderId,
    required String qtyToProduce,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiConstants.manufacturingBomsPreview,
      data: {
        'bom_header_id': bomHeaderId,
        'qty_to_produce': qtyToProduce,
      },
    );
    return BomPreviewModel.fromJson(response.data ?? const {});
  }

  @override
  Future<List<ProductionOrderModel>> listProductionOrders({
    String? branchId,
    String? status,
    String? bomHeaderId,
    int skip = 0,
    int limit = 50,
  }) async {
    final response = await _dio.get<dynamic>(
      ApiConstants.manufacturingProductionOrders,
      queryParameters: {
        if (branchId != null) 'branch_id': branchId,
        if (status != null) 'status': status,
        if (bomHeaderId != null) 'bom_header_id': bomHeaderId,
        'skip': skip,
        'limit': limit,
      },
    );
    return _toModelList(response.data, ProductionOrderModel.fromJson);
  }

  @override
  Future<ProductionOrderModel> getProductionOrder(String id) async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiConstants.manufacturingProductionOrder(id),
    );
    return ProductionOrderModel.fromJson(response.data ?? const {});
  }

  @override
  Future<ProductionOrderModel> createProductionOrder(
    Map<String, dynamic> body,
  ) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiConstants.manufacturingProductionOrders,
      data: body,
    );
    return ProductionOrderModel.fromJson(response.data ?? const {});
  }

  @override
  Future<ProductionOrderModel> updateProductionOrder(
    String id,
    Map<String, dynamic> body,
  ) async {
    final response = await _dio.put<Map<String, dynamic>>(
      ApiConstants.manufacturingProductionOrder(id),
      data: body,
    );
    return ProductionOrderModel.fromJson(response.data ?? const {});
  }

  @override
  Future<ProductionOrderModel> startProductionOrder(String id) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiConstants.manufacturingProductionOrderStart(id),
    );
    return ProductionOrderModel.fromJson(response.data ?? const {});
  }

  @override
  Future<ProductionOrderModel> cancelProductionOrder(String id) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiConstants.manufacturingProductionOrderCancel(id),
    );
    return ProductionOrderModel.fromJson(response.data ?? const {});
  }

  @override
  Future<ProductionOrderModel> completeProductionOrder(
    String id, {
    required String qtyProduced,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiConstants.manufacturingProductionOrderComplete(id),
      data: {'qty_produced': qtyProduced},
    );
    return ProductionOrderModel.fromJson(response.data ?? const {});
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
