import 'package:frantend/core/database/app_database.dart';
import 'package:frantend/core/platform/secure_key_store.dart';
import 'package:frantend/features/auth/domain/offline/offline_credential_verifier.dart';

/// What would be lost by wiping this device.
class PendingWorkSummary {
  const PendingWorkSummary({this.unsynced = 0, this.failed = 0, this.held = 0});

  /// Outbox ops waiting or being sent.
  final int unsynced;

  /// Outbox ops the server rejected / that ran out of retries.
  final int failed;

  /// Parked (held) orders, which exist only on this device.
  final int held;

  int get total => unsynced + failed + held;

  static const none = PendingWorkSummary();

  @override
  bool operator ==(Object other) =>
      other is PendingWorkSummary &&
      other.unsynced == unsynced &&
      other.failed == failed &&
      other.held == held;

  @override
  int get hashCode => Object.hash(unsynced, failed, held);
}

/// Number of local changes that have not reached the server yet.
///
/// Logout and tenant switch are refused while this is above zero, because
/// wiping the local database would destroy that work.
abstract class PendingWorkGuard {
  Future<PendingWorkSummary> summary();

  Future<int> pendingCount() async => (await summary()).total;
}

class NoPendingWorkGuard implements PendingWorkGuard {
  const NoPendingWorkGuard();

  @override
  Future<PendingWorkSummary> summary() async => PendingWorkSummary.none;

  @override
  Future<int> pendingCount() async => 0;
}

/// Thrown when a tenant switch would wipe unsent work.
class PendingWorkException implements Exception {
  const PendingWorkException(this.summary);
  final PendingWorkSummary summary;
  @override
  String toString() => 'PendingWorkException(${summary.total})';
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
    PendingWorkGuard? pendingWork,
  })  : _pendingWork = pendingWork,
        _database = database,
        _offlineCredentials = offlineCredentials,
        _secureStore = secureStore,
        _clearPinRoster = clearPinRoster;

  static const lastTenantKey = 'last_tenant_id';

  final AppDatabase _database;
  final OfflineCredentialVerifier _offlineCredentials;
  final SecureKeyStore _secureStore;
  final Future<void> Function()? _clearPinRoster;
  final PendingWorkGuard? _pendingWork;

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
    if (switched) {
      // Never destroy another business's unsent sales without being asked.
      final pending = await _pendingWork?.summary();
      if (pending != null && pending.total > 0) throw PendingWorkException(pending);
      await wipeOnTenantSwitch();
    }
    await _secureStore.write(lastTenantKey, tenantId);
    return switched;
  }
}
