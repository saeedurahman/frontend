import 'package:dartz/dartz.dart';
import 'package:frantend/core/error/error_handler.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/features/settings/data/datasources/settings_remote_datasource.dart';
import 'package:frantend/features/settings/data/models/app_setting_model.dart';
import 'package:frantend/features/settings/data/models/business_profile_model.dart';
import 'package:frantend/features/settings/data/models/tax_rate_model.dart';
import 'package:frantend/features/settings/domain/repositories/settings_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: SettingsRepository)
class SettingsRepositoryImpl implements SettingsRepository {
  SettingsRepositoryImpl({
    required SettingsRemoteDataSource remoteDataSource,
    required ErrorHandler errorHandler,
  })  : _remote = remoteDataSource,
        _errorHandler = errorHandler;

  final SettingsRemoteDataSource _remote;
  final ErrorHandler _errorHandler;

  @override
  Future<Either<Failure, BusinessProfileModel>> getBusinessProfile() async {
    try {
      return Right(await _remote.getBusinessProfile());
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, BusinessProfileModel>> updateBusinessProfile(
    Map<String, dynamic> body,
  ) async {
    try {
      return Right(await _remote.updateBusinessProfile(body));
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<AppSettingModel>>> getSettings({
    String? branchId,
  }) async {
    try {
      return Right(await _remote.getSettings(branchId: branchId));
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, AppSettingModel>> updateSetting(
    Map<String, dynamic> body,
  ) async {
    try {
      return Right(await _remote.updateSetting(body));
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<AppSettingModel>>> bulkUpdateSettings(
    List<Map<String, dynamic>> settings,
  ) async {
    try {
      return Right(await _remote.bulkUpdateSettings(settings));
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> deleteSetting(
    String settingKey, {
    String? branchId,
  }) async {
    try {
      await _remote.deleteSetting(settingKey, branchId: branchId);
      return const Right(null);
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<TaxRateModel>>> getTaxRates() async {
    try {
      return Right(await _remote.getTaxRates());
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, TaxRateModel>> createTaxRate(
    Map<String, dynamic> body,
  ) async {
    try {
      return Right(await _remote.createTaxRate(body));
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, TaxRateModel>> updateTaxRate(
    String id,
    Map<String, dynamic> body,
  ) async {
    try {
      return Right(await _remote.updateTaxRate(id, body));
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }
}
