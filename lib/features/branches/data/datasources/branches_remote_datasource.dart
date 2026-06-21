import 'package:dio/dio.dart';
import 'package:frantend/core/constants/api_constants.dart';
import 'package:frantend/core/network/dio_client.dart';
import 'package:frantend/features/settings/data/models/branch_model.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class BranchesRemoteDataSource {
  BranchesRemoteDataSource(this._dioClient);

  final DioClient _dioClient;

  Dio get _dio => _dioClient.dio;

  Future<List<BranchModel>> getBranches() async {
    final response = await _dio.get<dynamic>(
      ApiConstants.branches,
      options: Options(extra: {'skip_offline_queue': true}),
    );
    final raw = response.data;
    if (raw is! List) return const [];
    return raw
        .whereType<Map>()
        .map((e) => BranchModel.fromJson(Map<String, dynamic>.from(e)))
        .where((b) => b.isActive)
        .toList();
  }

  Future<BranchModel> getBranchById(String branchId) async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiConstants.branchById(branchId),
      options: Options(extra: {'skip_offline_queue': true}),
    );
    return BranchModel.fromJson(response.data ?? const {});
  }
}
