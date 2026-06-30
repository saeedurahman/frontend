import 'package:dio/dio.dart';
import 'package:frantend/core/constants/api_constants.dart';
import 'package:frantend/core/error/exceptions.dart';
import 'package:frantend/features/auth/data/models/token_model.dart';
import 'package:frantend/features/auth/data/models/user_model.dart';
import 'package:injectable/injectable.dart';

abstract class AuthRemoteDataSource {
  Future<TokenModel> login({
    required String phone,
    required String password,
  });

  Future<TokenModel> pinLogin({
    required String businessSlug,
    required String userId,
    required String pinCode,
  });

  Future<TokenModel> registerBusiness(Map<String, dynamic> data);

  Future<UserModel> getCurrentUser();

  Future<void> logout();
}

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<TokenModel> login({
    required String phone,
    required String password,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiConstants.login,
        data: {'phone': phone, 'password': password},
        options: Options(extra: {'skip_offline_queue': true}),
      );
      return TokenModel.fromJson(response.data!);
    } on DioException catch (e) {
      throw AuthException(_extractError(e));
    }
  }

  @override
  Future<TokenModel> pinLogin({
    required String businessSlug,
    required String userId,
    required String pinCode,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiConstants.pinLogin,
        data: {
          'business_slug': businessSlug,
          'user_id': userId,
          'pin_code': pinCode,
        },
        options: Options(extra: {'skip_offline_queue': true}),
      );
      return TokenModel.fromJson(response.data!);
    } on DioException catch (e) {
      throw AuthException(_extractError(e));
    }
  }

  @override
  Future<TokenModel> registerBusiness(Map<String, dynamic> data) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiConstants.register,
        data: data,
        options: Options(extra: {'skip_offline_queue': true}),
      );
      return TokenModel.fromJson(response.data!);
    } on DioException catch (e) {
      throw AuthException(_extractError(e));
    }
  }

  @override
  Future<UserModel> getCurrentUser() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(ApiConstants.me);
      return UserModel.fromJson(response.data!);
    } on DioException catch (e) {
      throw AuthException(_extractError(e));
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _dio.post<void>(
        ApiConstants.logout,
        options: Options(extra: {'skip_offline_queue': true}),
      );
    } on DioException catch (e) {
      throw AuthException(_extractError(e));
    }
  }

  String _extractError(DioException e) {
    final data = e.response?.data;
    if (data is Map<String, dynamic>) {
      final detail = data['detail'];
      if (detail is List) {
        final messages = detail
            .whereType<Map<dynamic, dynamic>>()
            .map((item) => item['msg']?.toString())
            .whereType<String>()
            .toList();
        if (messages.isNotEmpty) return messages.join('\n');
      }
      if (detail is String && detail.isNotEmpty) return detail;
      return data['message']?.toString() ?? 'Authentication failed';
    }
    return e.message ?? 'Authentication failed';
  }
}
