import 'package:dartz/dartz.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/features/settings/data/models/app_setting_model.dart';
import 'package:frantend/features/settings/data/models/business_profile_model.dart';
import 'package:frantend/features/settings/data/models/tax_rate_model.dart';
import 'package:frantend/features/settings/domain/repositories/settings_repository.dart';
import 'package:frantend/features/settings/presentation/utils/settings_value_utils.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetBusinessProfileUseCase {
  const GetBusinessProfileUseCase(this._repository);

  final SettingsRepository _repository;

  Future<Either<Failure, BusinessProfileModel>> call() =>
      _repository.getBusinessProfile();
}

@injectable
class UpdateBusinessProfileUseCase {
  const UpdateBusinessProfileUseCase(this._repository);

  final SettingsRepository _repository;

  Future<Either<Failure, BusinessProfileModel>> call(
    Map<String, dynamic> body,
  ) =>
      _repository.updateBusinessProfile(body);
}

@injectable
class GetSettingsUseCase {
  const GetSettingsUseCase(this._repository);

  final SettingsRepository _repository;

  Future<Either<Failure, List<AppSettingModel>>> call({String? branchId}) =>
      _repository.getSettings(branchId: branchId);
}

@injectable
class BulkUpdateSettingsUseCase {
  const BulkUpdateSettingsUseCase(this._repository);

  final SettingsRepository _repository;

  Future<Either<Failure, List<AppSettingModel>>> call(
    List<Map<String, dynamic>> settings,
  ) =>
      _repository.bulkUpdateSettings(settings);
}

@injectable
class DeleteSettingUseCase {
  const DeleteSettingUseCase(this._repository);

  final SettingsRepository _repository;

  Future<Either<Failure, void>> call(
    String settingKey, {
    String? branchId,
  }) =>
      _repository.deleteSetting(settingKey, branchId: branchId);
}

@injectable
class GetTaxRatesUseCase {
  const GetTaxRatesUseCase(this._repository);

  final SettingsRepository _repository;

  Future<Either<Failure, List<TaxRateModel>>> call() =>
      _repository.getTaxRates();
}

@injectable
class CreateTaxRateUseCase {
  const CreateTaxRateUseCase(this._repository);

  final SettingsRepository _repository;

  Future<Either<Failure, TaxRateModel>> call(Map<String, dynamic> body) =>
      _repository.createTaxRate(body);
}

@injectable
class UpdateTaxRateUseCase {
  const UpdateTaxRateUseCase(this._repository);

  final SettingsRepository _repository;

  Future<Either<Failure, TaxRateModel>> call(
    String id,
    Map<String, dynamic> body,
  ) =>
      _repository.updateTaxRate(id, body);
}

class ReceiptDisplaySettings {
  const ReceiptDisplaySettings({
    required this.footerText,
    required this.paperSize,
  });

  final String footerText;
  final String paperSize;
}

@injectable
class GetReceiptDisplaySettingsUseCase {
  const GetReceiptDisplaySettingsUseCase(this._repository);

  final SettingsRepository _repository;

  Future<Either<Failure, ReceiptDisplaySettings>> call({
    String? branchId,
  }) async {
    final result = await _repository.getSettings(branchId: branchId);
    return result.map((settings) {
      final footer = SettingsValueUtils.valueForKey(
            settings,
            SettingKeys.receiptFooterText,
            branchId: branchId,
          ) ??
          'Thank you for shopping with us!';
      final paper = SettingsValueUtils.valueForKey(
            settings,
            SettingKeys.receiptPaperSize,
            branchId: branchId,
          ) ??
          '80mm';
      return ReceiptDisplaySettings(
        footerText: footer,
        paperSize: paper,
      );
    });
  }
}
