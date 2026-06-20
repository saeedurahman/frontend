import 'package:dio/dio.dart';
import 'package:frantend/core/constants/api_constants.dart';
import 'package:frantend/core/network/dio_client.dart';
import 'package:frantend/features/purchases/data/models/purchase_order_model.dart';
import 'package:injectable/injectable.dart';

abstract class PurchasesRemoteDataSource {
  Future<List<PurchaseOrderModel>> getPurchaseOrders();

  Future<PurchaseOrderModel> getPurchaseOrder(String id);

  Future<PurchaseOrderModel> createPurchaseOrder(Map<String, dynamic> body);

  Future<PurchaseOrderModel> updatePurchaseOrderStatus(
    String id,
    String status,
  );

  Future<PurchaseReceiptModel> createPurchaseReceipt(Map<String, dynamic> body);

  Future<PurchaseReceiptModel> getPurchaseReceipt(String id);
}

@LazySingleton(as: PurchasesRemoteDataSource)
class PurchasesRemoteDataSourceImpl implements PurchasesRemoteDataSource {
  PurchasesRemoteDataSourceImpl(this._dioClient);

  final DioClient _dioClient;

  Dio get _dio => _dioClient.dio;

  @override
  Future<List<PurchaseOrderModel>> getPurchaseOrders() async {
    final response = await _dio.get<dynamic>(ApiConstants.purchaseOrders);
    return _toModelList(response.data, PurchaseOrderModel.fromJson);
  }

  @override
  Future<PurchaseOrderModel> getPurchaseOrder(String id) async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiConstants.purchaseOrder(id),
    );
    return PurchaseOrderModel.fromJson(response.data ?? const {});
  }

  @override
  Future<PurchaseOrderModel> createPurchaseOrder(
    Map<String, dynamic> body,
  ) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiConstants.purchaseOrders,
      data: body,
    );
    return PurchaseOrderModel.fromJson(response.data ?? const {});
  }

  @override
  Future<PurchaseOrderModel> updatePurchaseOrderStatus(
    String id,
    String status,
  ) async {
    final response = await _dio.put<Map<String, dynamic>>(
      ApiConstants.purchaseOrderStatus(id),
      data: {'status': status},
    );
    return PurchaseOrderModel.fromJson(response.data ?? const {});
  }

  @override
  Future<PurchaseReceiptModel> createPurchaseReceipt(
    Map<String, dynamic> body,
  ) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiConstants.purchaseReceipts,
      data: body,
    );
    return PurchaseReceiptModel.fromJson(response.data ?? const {});
  }

  @override
  Future<PurchaseReceiptModel> getPurchaseReceipt(String id) async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiConstants.purchaseReceipt(id),
    );
    return PurchaseReceiptModel.fromJson(response.data ?? const {});
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
