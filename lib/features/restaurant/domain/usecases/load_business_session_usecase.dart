import 'package:frantend/core/session/business_session_cubit.dart';
import 'package:frantend/features/restaurant/domain/entities/business_feature_flags.dart';
import 'package:frantend/features/settings/domain/usecases/settings_usecases.dart';
import 'package:injectable/injectable.dart';

/// Loads business feature flags from GET /business/me after auth.
@injectable
class LoadBusinessSessionUseCase {
  const LoadBusinessSessionUseCase(
    this._getBusinessProfile,
    this._session,
  );

  final GetBusinessProfileUseCase _getBusinessProfile;
  final BusinessSessionCubit _session;

  Future<void> call() async {
    final result = await _getBusinessProfile();
    result.fold(
      (_) => _session.setFlags(BusinessFeatureFlags.disabled),
      (profile) => _session.setFlags(
        BusinessFeatureFlags.fromConfig(profile.config),
      ),
    );
  }

  void reset() => _session.reset();
}
