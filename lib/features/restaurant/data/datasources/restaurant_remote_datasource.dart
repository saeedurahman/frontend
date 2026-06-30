import 'package:dio/dio.dart';
import 'package:frantend/core/constants/api_constants.dart';
import 'package:frantend/core/network/dio_client.dart';
import 'package:frantend/core/utils/api_json_utils.dart';
import 'package:frantend/features/restaurant/data/models/floor_plan_model.dart';
import 'package:frantend/features/restaurant/data/models/kot_order_model.dart';
import 'package:frantend/features/restaurant/data/models/modifier_group_model.dart';
import 'package:frantend/features/restaurant/data/models/restaurant_requests.dart';
import 'package:frantend/features/sales/data/models/sale_response_model.dart';
import 'package:injectable/injectable.dart';

abstract class RestaurantRemoteDataSource {
  Future<List<FloorPlanModel>> getFloorPlans({String? branchId});

  Future<FloorLayoutModel> getFloorLayout({String? branchId});

  Future<List<DiningTableModel>> getTables({
    String? branchId,
    String? floorPlanId,
    String? status,
  });

  Future<DiningTableModel> getTableById(String tableId);

  Future<List<ModifierGroupModel>> getModifierGroups();

  Future<List<ModifierGroupModel>> getProductModifierGroups(String productId);

  Future<SaleResponseModel> openTab(OpenTabRequest request);

  Future<SaleResponseModel> addTabLines(
    String saleId,
    AddTabLinesRequest request,
  );

  Future<FireTabResponseModel> fireTab(
    String saleId, {
    FireTabRequest? request,
  });

  Future<SaleResponseModel> requestBill(String saleId);

  Future<SaleResponseModel> completeTab(
    String saleId,
    CompleteTabRequest request,
  );

  Future<SaleResponseModel> getSaleById(String saleId);

  Future<List<KotOrderModel>> getActiveKotOrders({String? branchId});

  Future<List<KotOrderModel>> getKotOrdersByTable(String tableId);

  Future<KotOrderModel> getKotOrderById(String kotId);

  Future<KotOrderModel> updateKotStatus(
    String kotId,
    UpdateKotStatusRequest request,
  );
}

@LazySingleton(as: RestaurantRemoteDataSource)
class RestaurantRemoteDataSourceImpl implements RestaurantRemoteDataSource {
  RestaurantRemoteDataSourceImpl(this._dioClient);

  final DioClient _dioClient;

  Dio get _dio => _dioClient.dio;

  @override
  Future<List<FloorPlanModel>> getFloorPlans({String? branchId}) async {
    final response = await _dio.get<dynamic>(
      ApiConstants.restaurantFloorPlans,
      queryParameters: {
        if (branchId != null) 'branch_id': branchId,
      },
    );
    return _toModelList(response.data, FloorPlanModel.fromJson);
  }

  @override
  Future<FloorLayoutModel> getFloorLayout({String? branchId}) async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiConstants.restaurantFloorLayout,
      queryParameters: {
        if (branchId != null) 'branch_id': branchId,
      },
    );
    return FloorLayoutModel.fromJson(response.data ?? const {});
  }

  @override
  Future<List<DiningTableModel>> getTables({
    String? branchId,
    String? floorPlanId,
    String? status,
  }) async {
    final response = await _dio.get<dynamic>(
      ApiConstants.restaurantTables,
      queryParameters: {
        if (branchId != null) 'branch_id': branchId,
        if (floorPlanId != null) 'floor_plan_id': floorPlanId,
        if (status != null) 'status': status,
      },
    );
    return _toModelList(response.data, DiningTableModel.fromJson);
  }

  @override
  Future<DiningTableModel> getTableById(String tableId) async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiConstants.restaurantTableById(tableId),
    );
    return DiningTableModel.fromJson(response.data ?? const {});
  }

  @override
  Future<List<ModifierGroupModel>> getModifierGroups() async {
    final response = await _dio.get<dynamic>(
      ApiConstants.restaurantModifierGroups,
    );
    return _toModelList(response.data, ModifierGroupModel.fromJson);
  }

  @override
  Future<List<ModifierGroupModel>> getProductModifierGroups(
    String productId,
  ) async {
    final response = await _dio.get<dynamic>(
      ApiConstants.restaurantProductModifierGroups(productId),
    );
    return _toModelList(response.data, ModifierGroupModel.fromJson);
  }

  @override
  Future<SaleResponseModel> openTab(OpenTabRequest request) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiConstants.salesOpenTab,
      data: request.toJson(),
    );
    return _parseSaleResponse(response.data);
  }

  @override
  Future<SaleResponseModel> addTabLines(
    String saleId,
    AddTabLinesRequest request,
  ) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiConstants.saleAddLines(saleId),
      data: request.toJson(),
    );
    return _parseSaleResponse(response.data);
  }

  @override
  Future<FireTabResponseModel> fireTab(
    String saleId, {
    FireTabRequest? request,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiConstants.saleFireTab(saleId),
      data: request?.toJson() ?? const {},
    );
    return FireTabResponseModel.fromJson(response.data ?? const {});
  }

  @override
  Future<SaleResponseModel> requestBill(String saleId) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiConstants.saleRequestBill(saleId),
      data: const {},
    );
    return _parseSaleResponse(response.data);
  }

  @override
  Future<SaleResponseModel> completeTab(
    String saleId,
    CompleteTabRequest request,
  ) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiConstants.saleCompleteTab(saleId),
      data: request.toJson(),
    );
    return _parseSaleResponse(response.data);
  }

  @override
  Future<SaleResponseModel> getSaleById(String saleId) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '${ApiConstants.sales}/$saleId',
    );
    return _parseSaleResponse(response.data);
  }

  @override
  Future<List<KotOrderModel>> getActiveKotOrders({String? branchId}) async {
    final response = await _dio.get<dynamic>(
      ApiConstants.restaurantKotActive,
      queryParameters: {
        if (branchId != null) 'branch_id': branchId,
      },
    );
    return _toModelList(response.data, KotOrderModel.fromJson);
  }

  @override
  Future<List<KotOrderModel>> getKotOrdersByTable(String tableId) async {
    final response = await _dio.get<dynamic>(
      ApiConstants.restaurantKotByTable(tableId),
    );
    return _toModelList(response.data, KotOrderModel.fromJson);
  }

  @override
  Future<KotOrderModel> getKotOrderById(String kotId) async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiConstants.restaurantKotById(kotId),
    );
    return KotOrderModel.fromJson(response.data ?? const {});
  }

  @override
  Future<KotOrderModel> updateKotStatus(
    String kotId,
    UpdateKotStatusRequest request,
  ) async {
    final response = await _dio.patch<Map<String, dynamic>>(
      ApiConstants.restaurantKotStatus(kotId),
      data: request.toJson(),
    );
    return KotOrderModel.fromJson(response.data ?? const {});
  }

  SaleResponseModel _parseSaleResponse(Map<String, dynamic>? data) {
    return SaleResponseModel.fromJson(
      ApiJsonUtils.normalizeSaleResponse(data ?? const {}),
    );
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
    if (payload is Map && payload['items'] is List) {
      return (payload['items'] as List)
          .whereType<Map<dynamic, dynamic>>()
          .map((item) => fromJson(Map<String, dynamic>.from(item)))
          .toList();
    }
    return const [];
  }
}
