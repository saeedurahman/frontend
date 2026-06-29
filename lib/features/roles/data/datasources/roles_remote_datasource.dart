import 'package:dio/dio.dart';
import 'package:frantend/core/constants/api_constants.dart';
import 'package:frantend/core/network/dio_client.dart';
import 'package:frantend/features/roles/data/models/permission_model.dart';
import 'package:frantend/features/roles/data/models/role_model.dart';
import 'package:injectable/injectable.dart';

abstract class RolesRemoteDataSource {
  Future<PermissionsCatalogModel> getPermissionsCatalog();

  Future<List<RoleModel>> getRoles();

  Future<RoleModel> getRole(String id);

  Future<RoleModel> createRole({
    required String name,
    String? description,
    required List<String> permissionKeys,
  });

  Future<RoleModel> updateRole({
    required String id,
    String? name,
    String? description,
  });

  Future<void> deleteRole(String id);

  Future<RoleModel> assignPermissions({
    required String id,
    required List<String> permissionKeys,
  });
}

@LazySingleton(as: RolesRemoteDataSource)
class RolesRemoteDataSourceImpl implements RolesRemoteDataSource {
  RolesRemoteDataSourceImpl(this._dioClient);

  final DioClient _dioClient;

  Dio get _dio => _dioClient.dio;

  @override
  Future<PermissionsCatalogModel> getPermissionsCatalog() async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiConstants.permissions,
    );
    return PermissionsCatalogModel.fromJson(response.data ?? const {});
  }

  @override
  Future<List<RoleModel>> getRoles() async {
    final response = await _dio.get<dynamic>(ApiConstants.roles);
    return _toModelList(response.data, RoleModel.fromJson);
  }

  @override
  Future<RoleModel> getRole(String id) async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiConstants.roleById(id),
    );
    return RoleModel.fromJson(response.data ?? const {});
  }

  @override
  Future<RoleModel> createRole({
    required String name,
    String? description,
    required List<String> permissionKeys,
  }) async {
    final body = <String, dynamic>{
      'name': name,
      if (description != null) 'description': description,
      'permission_keys': permissionKeys,
    };
    final response = await _dio.post<Map<String, dynamic>>(
      ApiConstants.roles,
      data: body,
    );
    return RoleModel.fromJson(response.data ?? const {});
  }

  @override
  Future<RoleModel> updateRole({
    required String id,
    String? name,
    String? description,
  }) async {
    final body = <String, dynamic>{
      if (name != null) 'name': name,
      if (description != null) 'description': description,
    };
    final response = await _dio.put<Map<String, dynamic>>(
      ApiConstants.roleById(id),
      data: body,
    );
    return RoleModel.fromJson(response.data ?? const {});
  }

  @override
  Future<void> deleteRole(String id) async {
    await _dio.delete<void>(ApiConstants.roleById(id));
  }

  @override
  Future<RoleModel> assignPermissions({
    required String id,
    required List<String> permissionKeys,
  }) async {
    final response = await _dio.put<Map<String, dynamic>>(
      ApiConstants.rolePermissions(id),
      data: {'permission_keys': permissionKeys},
    );
    return RoleModel.fromJson(response.data ?? const {});
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
