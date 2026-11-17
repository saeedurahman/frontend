import 'package:frantend/features/settings/domain/repositories/settings_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/features/auth/domain/entities/user.dart';
import 'package:frantend/features/auth/domain/repositories/auth_repository.dart';
import 'package:frantend/features/register/domain/entities/register_entity.dart';
import 'package:frantend/features/register/domain/repositories/register_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: RegisterRepository)
class RegisterRepositoryImpl implements RegisterRepository {
  RegisterRepositoryImpl(this._authRepository, this._settingsRepository);

  final AuthRepository _authRepository;
  final SettingsRepository _settingsRepository;

  @override
  Future<Either<Failure, User>> register(RegisterEntity entity) async {
    final result = await _authRepository.registerBusiness(entity.toJson());
    // "I don't charge tax": the server has no field for it at registration,
    // so switch tax off in settings now that the owner is signed in. A failure
    // here must not fail the registration; the owner can change it in
    // Settings > Tax & Prices.
    if (result.isRight() && entity.effectiveTaxChoice == TaxPricingChoice.noTax) {
      try {
        await _settingsRepository.bulkUpdateSettings([
          {
            'setting_key': 'tax.enabled',
            'setting_value': {'value': false},
          },
        ]);
      } catch (_) {}
    }
    return result;
  }
}
