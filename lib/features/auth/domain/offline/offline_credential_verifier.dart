import 'dart:convert';

import 'package:frantend/core/platform/secure_key_store.dart';
import 'package:frantend/features/auth/domain/offline/credential_hasher.dart';

/// What a stored verifier protects.
enum OfflineCredentialKind { password, pin }

sealed class OfflineVerifyResult {
  const OfflineVerifyResult();
}

/// The secret matches a hash created at a previous successful online login.
class OfflineVerified extends OfflineVerifyResult {
  const OfflineVerified(this.userId);
  final String userId;
}

/// Wrong secret; [attemptsLeft] tries remain before the lockout.
class OfflineWrongSecret extends OfflineVerifyResult {
  const OfflineWrongSecret(this.attemptsLeft);
  final int attemptsLeft;
}

/// Too many failures: only an online login can unlock this again.
class OfflineLockedOut extends OfflineVerifyResult {
  const OfflineLockedOut();
}

/// This device never saw an online login for that user.
class OfflineNotEnrolled extends OfflineVerifyResult {
  const OfflineNotEnrolled();
}

/// Verifies a password/PIN without the server.
///
/// A verifier is created only after a *successful online* login (see
/// [enroll]) and stores nothing reversible: a random salt and a PBKDF2 hash.
/// It is removed by [wipe] on logout / tenant switch and replaced (failure
/// counter reset) by the next online login. After [maxFailures] wrong
/// attempts the record is locked until an online login re-enrolls it.
class OfflineCredentialVerifier {
  OfflineCredentialVerifier({
    required SecureKeyStore store,
    required CredentialHasher hasher,
    this.maxFailures = 5,
  })  : _store = store,
        _hasher = hasher;

  static const storageKey = 'offline_credentials_v1';

  final SecureKeyStore _store;
  final CredentialHasher _hasher;
  final int maxFailures;

  static String recordKey(
    OfflineCredentialKind kind,
    String tenantKey,
    String identity,
  ) =>
      '${kind.name}|${tenantKey.trim().toLowerCase()}|${identity.trim()}';

  Future<Map<String, dynamic>> _load() async {
    final raw = await _store.read(storageKey);
    if (raw == null || raw.isEmpty) return {};
    try {
      final json = jsonDecode(raw);
      return json is Map<String, dynamic> ? json : {};
    } catch (_) {
      return {};
    }
  }

  Future<void> _save(Map<String, dynamic> records) => records.isEmpty
      ? _store.delete(storageKey)
      : _store.write(storageKey, jsonEncode(records));

  /// Stores (or replaces) the verifier after a successful online login.
  Future<void> enroll({
    required OfflineCredentialKind kind,
    required String tenantKey,
    required String identity,
    required String userId,
    required String secret,
  }) async {
    final salt = _hasher.newSalt();
    final hash = await _hasher.hash(secret, salt);
    final records = await _load();
    records[recordKey(kind, tenantKey, identity)] = {
      'user_id': userId,
      'salt': base64Encode(salt),
      'hash': hash,
      'iterations': _hasher.iterations,
      'failures': 0,
    };
    await _save(records);
  }

  /// Whether a verifier exists for this kind/tenant/identity.
  Future<bool> isEnrolled({
    required OfflineCredentialKind kind,
    required String tenantKey,
    required String identity,
  }) async =>
      (await _load()).containsKey(recordKey(kind, tenantKey, identity));

  /// Finds the single enrolled record of [kind] for [identity] when the tenant
  /// is not known (the login form's business id is optional).
  Future<String?> _findKey(
    Map<String, dynamic> records,
    OfflineCredentialKind kind,
    String? tenantKey,
    String identity,
  ) async {
    if (tenantKey != null && tenantKey.trim().isNotEmpty) {
      final key = recordKey(kind, tenantKey, identity);
      return records.containsKey(key) ? key : null;
    }
    final matches = records.keys.where((k) {
      final parts = k.split('|');
      return parts.length == 3 && parts[0] == kind.name && parts[2] == identity.trim();
    }).toList();
    return matches.length == 1 ? matches.single : null;
  }

  Future<OfflineVerifyResult> verify({
    required OfflineCredentialKind kind,
    required String identity,
    required String secret,
    String? tenantKey,
  }) async {
    final records = await _load();
    final key = await _findKey(records, kind, tenantKey, identity);
    if (key == null) return const OfflineNotEnrolled();

    final record = Map<String, dynamic>.from(records[key] as Map);
    final failures = (record['failures'] as num?)?.toInt() ?? 0;
    if (failures >= maxFailures) return const OfflineLockedOut();

    final salt = base64Decode(record['salt'] as String);
    final expected = record['hash'] as String;
    final actual = await _hasher.hash(
      secret,
      salt,
      iterations: (record['iterations'] as num?)?.toInt(),
    );

    if (constantTimeEquals(expected, actual)) {
      if (failures != 0) {
        record['failures'] = 0;
        records[key] = record;
        await _save(records);
      }
      return OfflineVerified(record['user_id'] as String);
    }

    final next = failures + 1;
    record['failures'] = next;
    records[key] = record;
    await _save(records);
    return next >= maxFailures
        ? const OfflineLockedOut()
        : OfflineWrongSecret(maxFailures - next);
  }

  /// Removes every verifier (logout, tenant switch).
  Future<void> wipe() => _store.delete(storageKey);
}
