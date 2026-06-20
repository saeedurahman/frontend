import 'package:dio/dio.dart';
import 'package:frantend/core/constants/api_constants.dart';
import 'package:frantend/core/network/dio_client.dart';
import 'package:frantend/features/settings/data/models/app_setting_model.dart';
import 'package:frantend/features/settings/data/models/business_profile_model.dart';
import 'package:frantend/features/settings/data/models/tax_rate_model.dart';
import 'package:injectable/injectable.dart';

abstract class SettingsRemoteDataSource {
  Future<BusinessProfileModel> getBusinessProfile();

  Future<BusinessProfileModel> updateBusinessProfile(
    Map<String, dynamic> body,
  );

  Future<List<AppSettingModel>> getSettings({String? branchId});

  Future<AppSettingModel> updateSetting(Map<String, dynamic> body);

  Future<List<AppSettingModel>> bulkUpdateSettings(
    List<Map<String, dynamic>> settings,
  );

  Future<void> deleteSetting(String settingKey, {String? branchId});

  Future<List<TaxRateModel>> getTaxRates();

  Future<TaxRateModel> createTaxRate(Map<String, dynamic> body);

  Future<TaxRateModel> updateTaxRate(
    String id,
    Map<String, dynamic> body,
  );
}

@LazySingleton(as: SettingsRemoteDataSource)
class SettingsRemoteDataSourceImpl implements SettingsRemoteDataSource {
  SettingsRemoteDataSourceImpl(this._dioClient);

  final DioClient _dioClient;

  Dio get _dio => _dioClient.dio;

  @override
  Future<BusinessProfileModel> getBusinessProfile() async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiConstants.businessMe,
    );
    return BusinessProfileModel.fromJson(response.data ?? const {});
  }

  @override
  Future<BusinessProfileModel> updateBusinessProfile(
    Map<String, dynamic> body,
  ) async {
    final response = await _dio.put<Map<String, dynamic>>(
      ApiConstants.businessMe,
      data: body,
    );
    return BusinessProfileModel.fromJson(response.data ?? const {});
  }

  @override
  Future<List<AppSettingModel>> getSettings({String? branchId}) async {
    final response = await _dio.get<dynamic>(
      ApiConstants.settings,
      queryParameters: {
        if (branchId != null) 'branch_id': branchId,
      },
    );
    return _toModelList(response.data, AppSettingModel.fromJson);
  }

  @override
  Future<AppSettingModel> updateSetting(Map<String, dynamic> body) async {
    final response = await _dio.put<Map<String, dynamic>>(
      ApiConstants.settings,
      data: body,
    );
    return AppSettingModel.fromJson(response.data ?? const {});
  }

  @override
  Future<List<AppSettingModel>> bulkUpdateSettings(
    List<Map<String, dynamic>> settings,
  ) async {
    final response = await _dio.put<List<dynamic>>(
      ApiConstants.settingsBulk,
      data: {'settings': settings},
    );
    return _toModelList(response.data, AppSettingModel.fromJson);
  }

  @override
  Future<void> deleteSetting(
    String settingKey, {
    String? branchId,
  }) async {
    await _dio.delete<void>(
      ApiConstants.settingByKey(settingKey),
      queryParameters: {
        if (branchId != null) 'branch_id': branchId,
      },
    );
  }

  @override
  Future<List<TaxRateModel>> getTaxRates() async {
    final response = await _dio.get<dynamic>(ApiConstants.taxRates);
    return _toModelList(response.data, TaxRateModel.fromJson);
  }

  @override
  Future<TaxRateModel> createTaxRate(Map<String, dynamic> body) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiConstants.taxRates,
      data: body,
    );
    return TaxRateModel.fromJson(response.data ?? const {});
  }

  @override
  Future<TaxRateModel> updateTaxRate(
    String id,
    Map<String, dynamic> body,
  ) async {
    final response = await _dio.put<Map<String, dynamic>>(
      ApiConstants.taxRateById(id),
      data: body,
    );
    return TaxRateModel.fromJson(response.data ?? const {});
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
