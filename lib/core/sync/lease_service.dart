import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:typed_data';

import 'package:ed25519_edwards/ed25519_edwards.dart' as ed;
import 'package:frantend/core/sync/sync_store.dart';

/// Subscription lease (backend README, "Subscription lease"):
/// `{"v":1,"business_id","valid_until","server_time","signature"}` where the
/// signature is Ed25519 over the canonical JSON (sorted keys, no whitespace)
/// of the four other fields. Public key: `--dart-define=LEASE_PUBLIC_KEY=...`
/// (32 raw bytes, unpadded base64url). Without a key nothing is enforced
/// (the server also sends `lease: null` then).
enum LeaseState {
  /// No public key configured: the lease is not used.
  notRequired,

  /// Enforced, but no lease has been received yet.
  none,
  valid,

  /// Expired, but inside the `GRACE_DAYS` window: POS keeps working, warn.
  grace,

  /// Past the grace window: route to /subscription-expired.
  lapsed,

  /// Bad signature / malformed / another business: not trusted.
  invalid,

  /// The device clock is behind the lease or behind what was already seen.
  clockRolledBack,
}

class LeaseVerdict {
  const LeaseVerdict(this.state, {this.validUntil, this.graceEndsAt});

  final LeaseState state;
  final DateTime? validUntil;
  final DateTime? graceEndsAt;

  /// POS must stop (route to the subscription screen).
  bool get blocksApp =>
      state == LeaseState.lapsed ||
      state == LeaseState.invalid ||
      state == LeaseState.clockRolledBack;

  /// Show the "renew / reconnect" warning but keep selling.
  bool get warns => state == LeaseState.grace;

  Duration? graceLeft(DateTime now) =>
      graceEndsAt == null ? null : graceEndsAt!.difference(now);
}

class LeaseException implements Exception {
  const LeaseException(this.state, this.message);
  final LeaseState state;
  final String message;
  @override
  String toString() => 'LeaseException($state: $message)';
}

class ParsedLease {
  const ParsedLease(this.businessId, this.validUntil, this.serverTime);
  final String businessId;
  final DateTime validUntil;
  final DateTime serverTime;
}

abstract final class LeaseVerifier {
  /// Tolerated device clock behind the server when the lease was issued.
  static const clockSkew = Duration(minutes: 5);

  static Uint8List _b64uDecode(String text) =>
      Uint8List.fromList(base64Url.decode(base64Url.normalize(text)));

  static String canonicalJson(Map<String, dynamic> document) {
    final sorted = SplayTreeMap<String, dynamic>.from(document);
    return jsonEncode(sorted);
  }

  static DateTime _time(Object? value) {
    if (value is! String || !value.endsWith('Z')) {
      throw const LeaseException(LeaseState.invalid, 'Bad timestamp');
    }
    final parsed = DateTime.tryParse(value);
    if (parsed == null) {
      throw const LeaseException(LeaseState.invalid, 'Bad timestamp');
    }
    return parsed.toUtc();
  }

  /// Checks shape, signature and business. Expiry and clock are judged
  /// separately by [LeaseService.evaluate].
  static ParsedLease verifySignature(
    Map<String, dynamic> lease,
    String publicKeyB64, {
    String? businessId,
  }) {
    final signature = lease['signature'];
    if (signature is! String || signature.isEmpty) {
      throw const LeaseException(LeaseState.invalid, 'Lease has no signature');
    }
    final document = {
      for (final e in lease.entries)
        if (e.key != 'signature') e.key: e.value,
    };
    if (document.keys.toSet().difference(
          {'v', 'business_id', 'valid_until', 'server_time'},
        ).isNotEmpty ||
        document.length != 4) {
      throw const LeaseException(LeaseState.invalid, 'Unexpected lease fields');
    }
    bool ok;
    try {
      ok = ed.verify(
        ed.PublicKey(_b64uDecode(publicKeyB64)),
        Uint8List.fromList(utf8.encode(canonicalJson(document))),
        _b64uDecode(signature),
      );
    } catch (_) {
      ok = false;
    }
    if (!ok) {
      throw const LeaseException(LeaseState.invalid, 'Lease signature does not match');
    }
    if (document['v'] != 1) {
      throw const LeaseException(LeaseState.invalid, 'Unsupported lease version');
    }
    final parsed = ParsedLease(
      '${document['business_id']}',
      _time(document['valid_until']),
      _time(document['server_time']),
    );
    if (businessId != null && businessId != parsed.businessId) {
      throw const LeaseException(LeaseState.invalid, 'Lease is for another business');
    }
    return parsed;
  }
}

/// Stores the lease, judges it against the clock and tells the app whether to
/// keep running. Only the *server* time inside a signed lease is trusted.
class LeaseService {
  LeaseService({
    required SyncStore store,
    required this.publicKey,
    this.graceDays = const int.fromEnvironment('GRACE_DAYS', defaultValue: 3),
    DateTime Function()? clock,
    this.businessId,
  })  : _store = store,
        _clock = clock ?? DateTime.now;

  static const configuredPublicKey =
      String.fromEnvironment('LEASE_PUBLIC_KEY', defaultValue: '');

  final SyncStore _store;
  final String publicKey;
  final int graceDays;
  final DateTime Function() _clock;

  /// Business the signed-in user belongs to (null: do not check).
  final Future<String?> Function()? businessId;

  final StreamController<LeaseVerdict> _verdicts =
      StreamController<LeaseVerdict>.broadcast();
  Stream<LeaseVerdict> get verdicts => _verdicts.stream;
  LeaseVerdict _last = const LeaseVerdict(LeaseState.none);
  LeaseVerdict get last => _last;

  bool get enforced => publicKey.isNotEmpty;

  /// Verifies and keeps a lease received from the server (status, sign-in...).
  /// Returns false when it was missing or not genuine (the old one is kept).
  Future<bool> ingest(Object? raw) async {
    if (!enforced || raw is! Map) return false;
    final lease = Map<String, dynamic>.from(raw);
    final ParsedLease parsed;
    try {
      parsed = LeaseVerifier.verifySignature(
        lease,
        publicKey,
        businessId: await businessId?.call(),
      );
    } on LeaseException {
      return false;
    }
    // Online contact: the server's clock is the reference from now on.
    await _store.setMetaJson(SyncStore.leaseKey, lease);
    await _store.setMeta(
      SyncStore.monotonicKey,
      parsed.serverTime.millisecondsSinceEpoch.toString(),
    );
    await evaluate();
    return true;
  }

  Future<LeaseVerdict> evaluate() async {
    final verdict = await _evaluate();
    _last = verdict;
    if (!_verdicts.isClosed) _verdicts.add(verdict);
    return verdict;
  }

  Future<LeaseVerdict> _evaluate() async {
    if (!enforced) return const LeaseVerdict(LeaseState.notRequired);
    final stored = await _store.metaJson(SyncStore.leaseKey);
    if (stored == null) return const LeaseVerdict(LeaseState.none);

    final ParsedLease lease;
    try {
      lease = LeaseVerifier.verifySignature(
        stored,
        publicKey,
        businessId: await businessId?.call(),
      );
    } on LeaseException {
      return const LeaseVerdict(LeaseState.invalid);
    }

    final now = _clock().toUtc();
    final seen = int.tryParse(await _store.meta(SyncStore.monotonicKey) ?? '');
    final lastSeen = seen == null ? null : DateTime.fromMillisecondsSinceEpoch(seen, isUtc: true);

    final behindLease = now.isBefore(lease.serverTime.subtract(LeaseVerifier.clockSkew));
    final behindSeen = lastSeen != null && now.isBefore(lastSeen.subtract(LeaseVerifier.clockSkew));
    final validUntil = lease.validUntil;
    final graceEnds = validUntil.add(Duration(days: graceDays));
    if (behindLease || behindSeen) {
      return LeaseVerdict(LeaseState.clockRolledBack, validUntil: validUntil, graceEndsAt: graceEnds);
    }
    if (lastSeen == null || now.isAfter(lastSeen)) {
      await _store.setMeta(SyncStore.monotonicKey, now.millisecondsSinceEpoch.toString());
    }

    if (now.isBefore(validUntil)) {
      return LeaseVerdict(LeaseState.valid, validUntil: validUntil, graceEndsAt: graceEnds);
    }
    if (now.isBefore(graceEnds)) {
      return LeaseVerdict(LeaseState.grace, validUntil: validUntil, graceEndsAt: graceEnds);
    }
    return LeaseVerdict(LeaseState.lapsed, validUntil: validUntil, graceEndsAt: graceEnds);
  }

  void dispose() => unawaited(_verdicts.close());
}
