import 'package:dio/dio.dart';
import 'package:frantend/core/constants/api_constants.dart';
import 'package:frantend/core/network/dio_client.dart';
import 'package:frantend/features/cash_register/data/models/cash_register_model.dart';
import 'package:frantend/features/cash_register/data/models/register_shift_model.dart';
import 'package:frantend/features/cash_register/data/models/shift_summary_model.dart';
import 'package:injectable/injectable.dart';

abstract class CashRegisterRemoteDataSource {
  Future<List<CashRegisterModel>> getRegisters({String? branchId});

  Future<CashRegisterModel> createRegister(Map<String, dynamic> body);

  Future<RegisterShiftModel?> getActiveShift(String registerId);

  Future<RegisterShiftModel?> getMyActiveShift();

  Future<RegisterShiftModel> openShift(Map<String, dynamic> body);

  Future<ShiftSummaryModel> getShiftSummary(String shiftId);

  Future<ShiftSummaryModel> closeShift(
    String shiftId,
    Map<String, dynamic> body,
  );

  Future<List<RegisterShiftModel>> getShifts({
    String? branchId,
    String? registerId,
    String? status,
    int skip = 0,
    int limit = 50,
  });

  Future<RegisterShiftModel> getShiftById(String shiftId);
}

@LazySingleton(as: CashRegisterRemoteDataSource)
class CashRegisterRemoteDataSourceImpl
    implements CashRegisterRemoteDataSource {
  CashRegisterRemoteDataSourceImpl(this._dioClient);

  final DioClient _dioClient;

  Dio get _dio => _dioClient.dio;

  @override
  Future<List<CashRegisterModel>> getRegisters({String? branchId}) async {
    final response = await _dio.get<dynamic>(
      ApiConstants.registers,
      queryParameters: branchId == null ? null : {'branch_id': branchId},
    );
    return _toModelList(response.data, CashRegisterModel.fromJson);
  }

  @override
  Future<CashRegisterModel> createRegister(Map<String, dynamic> body) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiConstants.registers,
      data: body,
    );
    return CashRegisterModel.fromJson(response.data ?? const {});
  }

  @override
  Future<RegisterShiftModel?> getActiveShift(String registerId) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
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
  Future<RegisterShiftModel?> getMyActiveShift() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        ApiConstants.shiftsMyActive,
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
    final response = await _dio.post<Map<String, dynamic>>(
      ApiConstants.shiftsOpen,
      data: body,
    );
    return RegisterShiftModel.fromJson(response.data ?? const {});
  }

  @override
  Future<ShiftSummaryModel> getShiftSummary(String shiftId) async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiConstants.shiftSummary(shiftId),
    );
    return ShiftSummaryModel.fromJson(response.data ?? const {});
  }

  @override
  Future<ShiftSummaryModel> closeShift(
    String shiftId,
    Map<String, dynamic> body,
  ) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiConstants.shiftClose(shiftId),
      data: body,
    );
    return ShiftSummaryModel.fromJson(response.data ?? const {});
  }

  @override
  Future<List<RegisterShiftModel>> getShifts({
    String? branchId,
    String? registerId,
    String? status,
    int skip = 0,
    int limit = 50,
  }) async {
    final queryParams = <String, dynamic>{
      'skip': skip,
      'limit': limit,
    };
    if (branchId != null) queryParams['branch_id'] = branchId;
    if (registerId != null) queryParams['register_id'] = registerId;
    if (status != null) queryParams['status'] = status;

    final response = await _dio.get<dynamic>(
      ApiConstants.shifts,
      queryParameters: queryParams,
    );
    return _toModelList(response.data, RegisterShiftModel.fromJson);
  }

  @override
  Future<RegisterShiftModel> getShiftById(String shiftId) async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiConstants.shiftById(shiftId),
    );
    return RegisterShiftModel.fromJson(response.data ?? const {});
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
    return const [];
  }
}
