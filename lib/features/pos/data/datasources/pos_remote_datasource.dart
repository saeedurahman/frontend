import 'package:decimal/decimal.dart';
import 'package:dio/dio.dart';
import 'package:frantend/core/constants/api_constants.dart';
import 'package:frantend/core/utils/api_json_utils.dart';
import 'package:frantend/core/network/dio_client.dart';
import 'package:frantend/features/pos/data/models/customer_model.dart';
import 'package:frantend/features/pos/data/models/register_shift_model.dart';
import 'package:frantend/features/pos/data/models/sale_response_model.dart';
import 'package:frantend/features/products/data/models/product_model.dart';
import 'package:injectable/injectable.dart';

abstract class PosRemoteDataSource {
  Future<SaleResponseModel> createSale(Map<String, dynamic> body);
  Future<ProductModel> getProductByBarcode(String barcode);
  Future<List<CustomerModel>> searchCustomers(String query);
  Future<CustomerModel> createCustomer(Map<String, dynamic> body);
  Future<List<CashRegisterModel>> getRegisters({String? branchId});
  Future<CashRegisterModel> createRegister(Map<String, dynamic> body);
  Future<RegisterShiftModel?> getActiveShift(String registerId);
  Future<RegisterShiftModel> openShift(Map<String, dynamic> body);
  Future<ShiftSummaryModel> getShiftSummary(String shiftId);
  Future<Decimal?> getProductPrice(String productId, String? variationId);
}

@LazySingleton(as: PosRemoteDataSource)
class PosRemoteDataSourceImpl implements PosRemoteDataSource {
  PosRemoteDataSourceImpl(this._dioClient);

  final DioClient _dioClient;

  @override
  Future<SaleResponseModel> createSale(Map<String, dynamic> body) async {
    final response = await _dioClient.dio.post<Map<String, dynamic>>(
      ApiConstants.sales,
      data: body,
      options: Options(extra: {'entity_id': body['id']}),
    );
    final data = response.data ?? const {};
    if (data['offline'] == true) {
      return SaleResponseModel.fromJson(ApiJsonUtils.normalizeSaleResponse({
        ...body,
        'id': data['entity_id'] ?? body['id'],
        'sale_number': 'OFFLINE-${DateTime.now().millisecondsSinceEpoch}',
        'sale_type': body['sale_type'] ?? 'pos',
        'sale_status': 'draft',
        'total_amount': _estimateTotal(body),
        'offline': true,
        'lines': body['lines'] ?? [],
        'payments': body['payments'] ?? [],
      }));
    }
    return SaleResponseModel.fromJson(ApiJsonUtils.normalizeSaleResponse(data));
  }

  String _estimateTotal(Map<String, dynamic> body) {
    final lines = body['lines'] as List<dynamic>? ?? [];
    var total = Decimal.zero;
    for (final line in lines) {
      if (line is! Map) continue;
      final qty = Decimal.tryParse('${line['qty']}') ?? Decimal.zero;
      final price = Decimal.tryParse('${line['unit_price']}') ?? Decimal.zero;
      total += qty * price;
    }
    return total.toStringAsFixed(2);
  }

  @override
  Future<ProductModel> getProductByBarcode(String barcode) async {
    final response = await _dioClient.dio.get<Map<String, dynamic>>(
      '${ApiConstants.products}/barcode/$barcode',
    );
    return ProductModel.fromJson(response.data ?? const {});
  }

  @override
  Future<List<CustomerModel>> searchCustomers(String query) async {
    final response = await _dioClient.dio.get<dynamic>(
      ApiConstants.customers,
      queryParameters: {'search': query, 'limit': 20},
    );
    return _toModelList(response.data, CustomerModel.fromJson);
  }

  @override
  Future<CustomerModel> createCustomer(Map<String, dynamic> body) async {
    final response = await _dioClient.dio.post<Map<String, dynamic>>(
      ApiConstants.customers,
      data: body,
    );
    return CustomerModel.fromJson(response.data ?? const {});
  }

  @override
  Future<List<CashRegisterModel>> getRegisters({String? branchId}) async {
    final response = await _dioClient.dio.get<dynamic>(
      ApiConstants.registers,
      queryParameters: branchId == null ? null : {'branch_id': branchId},
    );
    return _toModelList(response.data, CashRegisterModel.fromJson);
  }

  @override
  Future<CashRegisterModel> createRegister(Map<String, dynamic> body) async {
    final response = await _dioClient.dio.post<Map<String, dynamic>>(
      ApiConstants.registers,
      data: body,
    );
    return CashRegisterModel.fromJson(response.data ?? const {});
  }

  @override
  Future<RegisterShiftModel?> getActiveShift(String registerId) async {
    try {
      final response = await _dioClient.dio.get<Map<String, dynamic>>(
        ApiConstants.registerActiveShift(registerId),
      );
      if (response.data == null || response.data!.isEmpty) return null;
      return RegisterShiftModel.fromJson(response.data!);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return null;
      rethrow;
    }
  }

  @override
  Future<RegisterShiftModel> openShift(Map<String, dynamic> body) async {
    final response = await _dioClient.dio.post<Map<String, dynamic>>(
      ApiConstants.shiftsOpen,
      data: body,
    );
    return RegisterShiftModel.fromJson(response.data ?? const {});
  }

  @override
  Future<ShiftSummaryModel> getShiftSummary(String shiftId) async {
    final response = await _dioClient.dio.get<Map<String, dynamic>>(
      ApiConstants.shiftSummary(shiftId),
    );
    return ShiftSummaryModel.fromJson(response.data ?? const {});
  }

  @override
  Future<Decimal?> getProductPrice(
    String productId,
    String? variationId,
  ) async {
    final response = await _dioClient.dio.get<Map<String, dynamic>>(
      ApiConstants.productPrice(productId),
      queryParameters:
          variationId == null ? null : {'variation_id': variationId},
    );
    final price = response.data?['unit_price'];
    if (price == null) return null;
    return Decimal.tryParse(price.toString());
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
