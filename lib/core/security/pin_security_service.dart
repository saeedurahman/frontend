import 'package:frantend/core/storage/secure_storage.dart';
import 'package:frantend/features/auth/domain/offline/offline_credential_verifier.dart';

abstract class PinSecurityService {
  Future<bool> hasPin({required String userId, String? slug});
  Future<void> recordPinEnrolled({
    required String userId,
    required String slug,
    required String pin,
  });
  Future<void> clearPin({required String userId});
}

class PinSecurityServiceImpl implements PinSecurityService {
  const PinSecurityServiceImpl({
    required OfflineCredentialVerifier offlineVerifier,
    required SecureStorage secureStorage,
  })  : _offlineVerifier = offlineVerifier,
        _secureStorage = secureStorage;

  final OfflineCredentialVerifier _offlineVerifier;
  final SecureStorage _secureStorage;

  @override
  Future<bool> hasPin({required String userId, String? slug}) async {
    final flag = await _secureStorage.getUserHasPin(userId);
    if (flag) return true;
    if (slug != null && slug.isNotEmpty) {
      final enrolled = await _offlineVerifier.isEnrolled(
        kind: OfflineCredentialKind.pin,
        tenantKey: slug,
        identity: userId,
      );
      if (enrolled) return true;
    }
    return false;
  }

  @override
  Future<void> recordPinEnrolled({
    required String userId,
    required String slug,
    required String pin,
  }) async {
    await _secureStorage.setUserHasPin(userId, true);
    if (slug.isNotEmpty) {
      await _offlineVerifier.enroll(
        kind: OfflineCredentialKind.pin,
        tenantKey: slug,
        identity: userId,
        userId: userId,
        secret: pin,
      );
    }
  }

  @override
  Future<void> clearPin({required String userId}) async {
    await _secureStorage.setUserHasPin(userId, false);
  }
}
