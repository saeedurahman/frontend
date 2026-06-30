import 'package:dio/dio.dart';
import 'package:frantend/core/constants/api_constants.dart';
import 'package:frantend/core/network/dio_client.dart';
import 'package:frantend/features/users/data/models/staff_user_model.dart';
import 'package:injectable/injectable.dart';

abstract class UsersRemoteDataSource {
  Future<List<StaffUserModel>> getUsers({String? role});

  Future<StaffUserModel> getUser(String id);

  Future<StaffUserModel> createUser({
    required String fullName,
    required String phone,
    required String password,
    String? branchId,
    required List<String> roleIds,
  });

  Future<StaffUserModel> updateUser({
    required String id,
    String? fullName,
    String? branchId,
    bool? isActive,
  });

  Future<StaffUserModel> replaceUserRoles({
    required String id,
    required List<String> roleIds,
  });

  Future<void> deleteUser(String id);

  Future<void> resetUserPin({
    required String id,
    required String pinCode,
  });
}

@LazySingleton(as: UsersRemoteDataSource)
class UsersRemoteDataSourceImpl implements UsersRemoteDataSource {
  UsersRemoteDataSourceImpl(this._dioClient);

  final DioClient _dioClient;

  Dio get _dio => _dioClient.dio;

  @override
  Future<List<StaffUserModel>> getUsers({String? role}) async {
    final response = await _dio.get<dynamic>(
      ApiConstants.users,
      queryParameters: role == null ? null : {'role': role},
    );
    return _toModelList(response.data, StaffUserModel.fromJson);
  }

  @override
  Future<StaffUserModel> getUser(String id) async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiConstants.userById(id),
    );
    return StaffUserModel.fromJson(response.data ?? const {});
  }

  @override
  Future<StaffUserModel> createUser({
    required String fullName,
    required String phone,
    required String password,
    String? branchId,
    required List<String> roleIds,
  }) async {
    final body = <String, dynamic>{
      'full_name': fullName,
      'phone': phone,
      'password': password,
      'role_ids': roleIds,
      if (branchId != null) 'branch_id': branchId,
    };
    final response = await _dio.post<Map<String, dynamic>>(
      ApiConstants.users,
      data: body,
    );
    return StaffUserModel.fromJson(response.data ?? const {});
  }

  @override
  Future<StaffUserModel> updateUser({
    required String id,
    String? fullName,
    String? branchId,
    bool? isActive,
  }) async {
    final body = <String, dynamic>{
      if (fullName != null) 'full_name': fullName,
      if (branchId != null) 'branch_id': branchId,
      if (isActive != null) 'is_active': isActive,
    };
    final response = await _dio.put<Map<String, dynamic>>(
      ApiConstants.userById(id),
      data: body,
    );
    return StaffUserModel.fromJson(response.data ?? const {});
  }

  @override
  Future<StaffUserModel> replaceUserRoles({
    required String id,
    required List<String> roleIds,
  }) async {
    final response = await _dio.put<Map<String, dynamic>>(
      ApiConstants.userRoles(id),
      data: {'role_ids': roleIds},
    );
    return StaffUserModel.fromJson(response.data ?? const {});
  }

  @override
  Future<void> deleteUser(String id) async {
    await _dio.delete<void>(ApiConstants.userById(id));
  }

  @override
  Future<void> resetUserPin({
    required String id,
    required String pinCode,
  }) async {
    await _dio.put<void>(
      ApiConstants.userPin(id),
      data: {'pin_code': pinCode},
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
