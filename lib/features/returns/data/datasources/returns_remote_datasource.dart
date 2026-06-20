import 'package:dio/dio.dart';
import 'package:frantend/core/constants/api_constants.dart';
import 'package:frantend/core/network/dio_client.dart';
import 'package:frantend/features/returns/data/models/sale_return_response_model.dart';
import 'package:injectable/injectable.dart';

abstract class ReturnsRemoteDataSource {
  Future<SaleReturnResponseModel> createReturn(Map<String, dynamic> body);

  Future<List<SaleReturnResponseModel>> getReturns({
    String? branchId,
    int skip = 0,
    int limit = 50,
  });

  Future<SaleReturnResponseModel> getReturnById(String id);
}

@LazySingleton(as: ReturnsRemoteDataSource)
class ReturnsRemoteDataSourceImpl implements ReturnsRemoteDataSource {
  ReturnsRemoteDataSourceImpl(this._dioClient);

  final DioClient _dioClient;

  Dio get _dio => _dioClient.dio;

  @override
  Future<SaleReturnResponseModel> createReturn(
    Map<String, dynamic> body,
  ) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiConstants.returns,
      data: body,
    );
    return SaleReturnResponseModel.fromJson(response.data ?? const {});
  }

  @override
  Future<List<SaleReturnResponseModel>> getReturns({
    String? branchId,
    int skip = 0,
    int limit = 50,
  }) async {
    final queryParams = <String, dynamic>{
      'skip': skip,
      'limit': limit,
    };
    if (branchId != null) queryParams['branch_id'] = branchId;

    final response = await _dio.get<List<dynamic>>(
      ApiConstants.returns,
      queryParameters: queryParams,
    );
    final list = response.data ?? const [];
    return list
        .whereType<Map<String, dynamic>>()
        .map(SaleReturnResponseModel.fromJson)
        .toList();
  }

  @override
  Future<SaleReturnResponseModel> getReturnById(String id) async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiConstants.returnById(id),
    );
    return SaleReturnResponseModel.fromJson(response.data ?? const {});
  }
}
