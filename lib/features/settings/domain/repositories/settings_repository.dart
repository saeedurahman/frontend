import 'package:dartz/dartz.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/features/settings/data/models/app_setting_model.dart';
import 'package:frantend/features/settings/data/models/business_profile_model.dart';
import 'package:frantend/features/settings/data/models/tax_rate_model.dart';

abstract class SettingsRepository {
  Future<Either<Failure, BusinessProfileModel>> getBusinessProfile();

  Future<Either<Failure, BusinessProfileModel>> updateBusinessProfile(
    Map<String, dynamic> body,
  );

  Future<Either<Failure, List<AppSettingModel>>> getSettings({
    String? branchId,
  });

  Future<Either<Failure, AppSettingModel>> updateSetting(
    Map<String, dynamic> body,
  );

  Future<Either<Failure, List<AppSettingModel>>> bulkUpdateSettings(
    List<Map<String, dynamic>> settings,
  );

  Future<Either<Failure, void>> deleteSetting(
    String settingKey, {
    String? branchId,
  });

  Future<Either<Failure, List<TaxRateModel>>> getTaxRates();

  Future<Either<Failure, TaxRateModel>> createTaxRate(
    Map<String, dynamic> body,
  );

  Future<Either<Failure, TaxRateModel>> updateTaxRate(
    String id,
    Map<String, dynamic> body,
  );
}
