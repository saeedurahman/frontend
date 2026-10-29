import 'package:dio/dio.dart';
import 'package:frantend/core/constants/api_constants.dart';
import 'package:frantend/core/error/api_error_parser.dart';
import 'package:frantend/core/error/exceptions.dart';
import 'package:frantend/features/auth/data/models/token_model.dart';
import 'package:frantend/features/auth/data/models/user_model.dart';
import 'package:injectable/injectable.dart';

abstract class AuthRemoteDataSource {
  Future<TokenModel> login({
    required String phone,
    required String password,
    String? businessSlug,
  });

  Future<TokenModel> pinLogin({
    required String businessSlug,
    required String userId,
    required String pinCode,
  });

  Future<TokenModel> registerBusiness(Map<String, dynamic> data);

  Future<UserModel> getCurrentUser();

  Future<void> logout();

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });
}

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<TokenModel> login({
    required String phone,
    required String password,
    String? businessSlug,
  }) async {
    try {
      final slug = businessSlug?.trim();
      final response = await _dio.post<Map<String, dynamic>>(
        ApiConstants.login,
        data: {
          'phone': phone,
          'password': password,
          if (slug != null && slug.isNotEmpty) 'business_slug': slug,
        },
        options: Options(),
      );
      return TokenModel.fromJson(response.data!);
    } on DioException catch (e) {
      throw _credentialError(e);
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
        options: Options(),
      );
      return TokenModel.fromJson(response.data!);
    } on DioException catch (e) {
      throw _credentialError(e);
    }
  }

  @override
  Future<TokenModel> registerBusiness(Map<String, dynamic> data) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiConstants.register,
        data: data,
        options: Options(),
      );
      return TokenModel.fromJson(response.data!);
    } on DioException {
      // The repository maps 409/422/429/network to typed failures.
      rethrow;
    }
  }

  @override
  Future<UserModel> getCurrentUser() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(ApiConstants.me);
      return UserModel.fromJson(response.data!);
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    await _dio.post<void>(
      ApiConstants.logout,
      options: Options(),
    );
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await _dio.post<void>(
        ApiConstants.changePassword,
        data: {
          'current_password': currentPassword,
          'new_password': newPassword,
        },
        options: Options(),
      );
    } on DioException catch (e) {
      // 401 here means the *current password* was wrong (the session itself is
      // refreshed by the interceptor), so surface it as a credential error.
      if (e.response?.statusCode == 401 || e.response?.statusCode == 400) {
        throw AuthException(
          ApiErrorParser.message(
            e.response?.data,
            fallback: 'Current password is incorrect',
          ),
        );
      }
      rethrow;
    }
  }

  /// 401 on a credential endpoint is a bad password/PIN. Everything else
  /// (429, 409, 422, network) is rethrown so the repository can map it to a
  /// typed failure.
  Object _credentialError(DioException e) {
    if (e.response?.statusCode == 401) {
      return const AuthException('Invalid credentials');
    }
    return e;
  }
}
