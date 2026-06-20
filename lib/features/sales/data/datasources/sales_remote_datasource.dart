import 'package:dio/dio.dart';
import 'package:frantend/core/constants/api_constants.dart';
import 'package:frantend/core/network/dio_client.dart';
import 'package:frantend/core/utils/api_json_utils.dart';
import 'package:frantend/features/sales/data/models/paginated_sales_model.dart';
import 'package:frantend/features/sales/data/models/sale_response_model.dart';
import 'package:injectable/injectable.dart';

abstract class SalesRemoteDataSource {
  Future<PaginatedSalesModel> getSales({
    String? branchId,
    String? customerId,
    String? status,
    String? saleType,
    DateTime? dateFrom,
    DateTime? dateTo,
    String? search,
    int skip = 0,
    int limit = 50,
  });

  Future<SaleResponseModel> getSaleById(String id);

  Future<SaleResponseModel> cancelSale(String id);
}

@LazySingleton(as: SalesRemoteDataSource)
class SalesRemoteDataSourceImpl implements SalesRemoteDataSource {
  SalesRemoteDataSourceImpl(this._dioClient);

  final DioClient _dioClient;

  Dio get _dio => _dioClient.dio;

  @override
  Future<PaginatedSalesModel> getSales({
    String? branchId,
    String? customerId,
    String? status,
    String? saleType,
    DateTime? dateFrom,
    DateTime? dateTo,
    String? search,
    int skip = 0,
    int limit = 50,
  }) async {
    final queryParams = <String, dynamic>{
      'skip': skip,
      'limit': limit,
    };
    if (branchId != null) queryParams['branch_id'] = branchId;
    if (customerId != null) queryParams['customer_id'] = customerId;
    if (status != null) queryParams['status'] = status;
    if (saleType != null) queryParams['sale_type'] = saleType;
    if (dateFrom != null) {
      queryParams['date_from'] = dateFrom.toUtc().toIso8601String();
    }
    if (dateTo != null) {
      queryParams['date_to'] = dateTo.toUtc().toIso8601String();
    }
    if (search != null && search.isNotEmpty) queryParams['search'] = search;

    final response = await _dio.get<Map<String, dynamic>>(
      ApiConstants.sales,
      queryParameters: queryParams,
    );
    return PaginatedSalesModel.fromJson(response.data ?? const {});
  }

  @override
  Future<SaleResponseModel> getSaleById(String id) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '${ApiConstants.sales}/$id',
    );
    return SaleResponseModel.fromJson(
      ApiJsonUtils.normalizeSaleResponse(response.data ?? const {}),
    );
  }

  @override
  Future<SaleResponseModel> cancelSale(String id) async {
    final response = await _dio.put<Map<String, dynamic>>(
      ApiConstants.saleCancel(id),
    );
    return SaleResponseModel.fromJson(
      ApiJsonUtils.normalizeSaleResponse(response.data ?? const {}),
    );
  }
}
