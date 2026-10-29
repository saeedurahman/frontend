import 'package:frantend/core/database/app_database.dart';
import 'package:frantend/core/platform/secure_key_store.dart';
import 'package:frantend/features/auth/domain/offline/offline_credential_verifier.dart';

/// Number of local changes that have not reached the server yet.
///
/// Logout is refused while this is above zero, because wiping the local
/// database would destroy that work. The sync engine (Phase 4b) provides the
/// real implementation; until then [NoPendingWorkGuard] answers 0.
abstract class PendingWorkGuard {
  Future<int> pendingCount();
}

class NoPendingWorkGuard implements PendingWorkGuard {
  const NoPendingWorkGuard();

  @override
  Future<int> pendingCount() async => 0;
}

/// Decides what local data survives a change of who is using the device.
///
/// | event          | Drift tables | caches | offline verifiers | PIN roster |
/// |----------------|--------------|--------|-------------------|------------|
/// | logout         | wiped        | wiped  | wiped             | kept       |
/// | tenant switch  | wiped        | wiped  | wiped             | wiped      |
/// | branch switch  | kept         | wiped  | kept              | kept       |
///
/// The PIN roster (who may sign in by PIN on this shared till) deliberately
/// outlives a logout; the next cashier needs it. It belongs to one business,
/// so a different business clears it.
class LocalDataLifecycle {
  LocalDataLifecycle({
    required AppDatabase database,
    required OfflineCredentialVerifier offlineCredentials,
    required SecureKeyStore secureStore,
    Future<void> Function()? clearPinRoster,
  })  : _database = database,
        _offlineCredentials = offlineCredentials,
        _secureStore = secureStore,
        _clearPinRoster = clearPinRoster;

  static const lastTenantKey = 'last_tenant_id';

  final AppDatabase _database;
  final OfflineCredentialVerifier _offlineCredentials;
  final SecureKeyStore _secureStore;
  final Future<void> Function()? _clearPinRoster;

  /// Everything tenant-scoped goes; the device identity stays.
  Future<void> wipeOnLogout() async {
    await _database.wipeTenantData();
    await _offlineCredentials.wipe();
  }

  Future<void> wipeOnTenantSwitch() async {
    await wipeOnLogout();
    await _clearPinRoster?.call();
  }

  /// A different branch means different prices/stock: drop cached reads.
  Future<void> wipeOnBranchSwitch() => _database.masterDataCacheDao.clearAll();

  /// Call after every successful online login with the tenant just signed
  /// into. Returns true when it differs from the previous tenant on this
  /// device (in which case the old tenant's data was wiped first).
  Future<bool> onTenantSignedIn(String? tenantId) async {
    if (tenantId == null || tenantId.isEmpty) return false;
    final previous = await _secureStore.read(lastTenantKey);
    final switched = previous != null && previous.isNotEmpty && previous != tenantId;
    if (switched) await wipeOnTenantSwitch();
    await _secureStore.write(lastTenantKey, tenantId);
    return switched;
  }
}
