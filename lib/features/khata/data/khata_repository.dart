import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:decimal/decimal.dart';
import 'package:frantend/core/error/error_handler.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/core/offline/local_catalog.dart';
import 'package:frantend/core/offline/offline_writer.dart';
import 'package:frantend/core/sync/outbox_op.dart';
import 'package:frantend/core/sync/sync_store.dart';
import 'package:frantend/features/khata/data/khata_remote_datasource.dart';
import 'package:frantend/features/khata/data/models/khata_p1_models.dart';
import 'package:frantend/features/khata/domain/khata_events.dart';
import 'package:frantend/features/khata/domain/khata_settings.dart';
import 'package:frantend/features/khata/domain/party_type.dart';
import 'package:frantend/features/settings/data/datasources/settings_remote_datasource.dart';

/// An answer, and whether it is the one kept on this device.
class KhataData<T> {
  const KhataData(this.value, {this.asOf, this.offline = false});

  final T value;

  /// When the server gave this answer.
  final DateTime? asOf;

  /// The server could not be reached: this is the last answer it gave.
  final bool offline;
}

/// Everything the khata screens read and write.
///
/// Reads are online-first; the last answer is kept in the local database and
/// shown (marked with its time) when the server can't be reached. Promises,
/// reminders and notes are written through the outbox, so they work without
/// internet. Anything that moves money needs the internet.
class KhataRepository {
  KhataRepository({
    required KhataRemoteDataSource remote,
    required SyncStore store,
    required OfflineWriter writer,
    required LocalCatalog catalog,
    required SettingsRemoteDataSource settingsRemote,
    ErrorHandler errorHandler = const ErrorHandler(),
    bool Function()? isReachable,
    KhataEvents? events,
    Future<void> Function()? refreshLocal,
  })  : _remote = remote,
        _store = store,
        _writer = writer,
        _catalog = catalog,
        _settingsRemote = settingsRemote,
        _errors = errorHandler,
        _isReachable = isReachable ?? (() => true),
        _events = events,
        _refreshLocal = refreshLocal;

  final KhataRemoteDataSource _remote;
  final SyncStore _store;
  final OfflineWriter _writer;
  final LocalCatalog _catalog;
  final SettingsRemoteDataSource _settingsRemote;
  final ErrorHandler _errors;
  final bool Function() _isReachable;
  final KhataEvents? _events;
  final Future<void> Function()? _refreshLocal;

  bool get isOnline => _isReachable();

  static const offlineMessage =
      'You are offline. Connect to the internet and try again.';

  static String _branch(String? branchId) => branchId ?? 'all';

  // ── plumbing ───────────────────────────────────────────────────────────

  /// A call that only the server can answer.
  Future<Either<Failure, T>> _online<T>(Future<T> Function() call) async {
    if (!_isReachable()) return const Left(NetworkFailure(offlineMessage));
    try {
      return Right(await call());
    } catch (e) {
      return Left(_errors.mapExceptionToFailure(e));
    }
  }

  /// Asks the server, keeps the answer under [key] and falls back to the
  /// kept one when the server can't be reached.
  Future<Either<Failure, KhataData<T>>> _cached<T>({
    required String key,
    required Future<Map<String, dynamic>> Function() fetch,
    required T Function(Map<String, dynamic> body) read,
  }) async {
    Failure failure = const NetworkFailure(offlineMessage);
    if (_isReachable()) {
      try {
        final body = await fetch();
        final value = read(body);
        final now = _store.now();
        await _keep(key, body, now);
        return Right(KhataData(value, asOf: now));
      } catch (e) {
        failure = _errors.mapExceptionToFailure(e);
        if (failure is! NetworkFailure) return Left(failure);
      }
    }
    final kept = await _kept(key);
    if (kept == null) return Left(failure);
    return Right(
      KhataData(read(kept.body), asOf: kept.at, offline: true),
    );
  }

  Future<void> _keep(String key, Map<String, dynamic> body, DateTime at) =>
      _store.setMetaJson(key, {
        'saved_at': at.toUtc().toIso8601String(),
        'body': body,
      });

  Future<({Map<String, dynamic> body, DateTime at})?> _kept(String key) async {
    final saved = await _store.metaJson(key);
    final body = saved?['body'];
    final at = khataMoment(saved?['saved_at']);
    if (body is! Map || at == null) return null;
    return (body: Map<String, dynamic>.from(body), at: at);
  }

  // ── hub ────────────────────────────────────────────────────────────────

  static String _hubKey(HubQuery q) =>
      'khata_hub|${q.party.apiValue}|${_branch(q.branchId)}';

  static String _overviewKey(String? branchId) =>
      'khata_overview|${_branch(branchId)}';

  /// Both sides at a glance (hub header and dashboard).
  Future<Either<Failure, KhataData<KhataOverview>>> overview({
    String? branchId,
  }) =>
      _cached(
        key: _overviewKey(branchId),
        fetch: () async =>
            (await _remote.overview(branchId: branchId)).toJson(),
        read: KhataOverview.fromJson,
      );

  /// One page of the hub list. Offline, the pages seen so far are searched,
  /// filtered and sorted on this device (all at once, so [skip] is ignored).
  Future<Either<Failure, KhataData<HubPage>>> hub(
    HubQuery q, {
    int skip = 0,
    int limit = 50,
  }) async {
    Failure failure = const NetworkFailure(offlineMessage);
    if (_isReachable()) {
      try {
        final page = await _remote.hub(q, skip: skip, limit: limit);
        final now = _store.now();
        if (q.isUnfiltered) await _keepHub(q, page, skip, now);
        return Right(KhataData(await _withPending(q.party, page), asOf: now));
      } catch (e) {
        failure = _errors.mapExceptionToFailure(e);
        if (failure is! NetworkFailure) return Left(failure);
      }
    }
    final kept = await _kept(_hubKey(q));
    if (kept == null) return Left(failure);
    final local = _filterLocally(HubPage.fromJson(kept.body), q);
    return Right(
      KhataData(
        await _withPending(q.party, local, since: kept.at),
        asOf: kept.at,
        offline: true,
      ),
    );
  }

  Future<void> _keepHub(
    HubQuery q,
    HubPage page,
    int skip,
    DateTime now,
  ) async {
    var rows = page.items;
    if (skip > 0) {
      final kept = await _kept(_hubKey(q));
      if (kept != null) {
        final ids = {for (final r in page.items) r.id};
        rows = [
          ...HubPage.fromJson(kept.body)
              .items
              .where((r) => !ids.contains(r.id)),
          ...page.items,
        ];
      }
    }
    await _keep(
      _hubKey(q),
      HubPage(
        items: rows,
        total: page.total,
        partyCount: page.partyCount,
        balanceOwed: page.balanceOwed,
        openItemsCount: page.openItemsCount,
        buckets: page.buckets,
      ).toJson(),
      now,
    );
  }

  /// The server's filtering and ordering rules, over the rows kept here.
  static HubPage _filterLocally(HubPage page, HubQuery q) {
    final needle = q.search.trim().toLowerCase();
    final searched = [
      for (final r in page.items)
        if (needle.isEmpty ||
            r.name.toLowerCase().contains(needle) ||
            (r.phone ?? '').toLowerCase().contains(needle))
          r,
    ];
    final rows = [
      for (final r in searched)
        if (q.bucket == null || r.buckets[q.bucket!] > Decimal.zero) r,
    ];
    rows.sort((a, b) {
      final order = switch (q.sort) {
        HubSort.amount => b.balanceOwed.compareTo(a.balanceOwed),
        HubSort.age => b.oldestAgeDays.compareTo(a.oldestAgeDays),
        HubSort.name => 0,
      };
      return order != 0
          ? order
          : a.name.toLowerCase().compareTo(b.name.toLowerCase());
    });
    // Unfiltered, the server's own figures cover every party, including
    // pages this device never loaded.
    if (needle.isEmpty && q.bucket == null) {
      return HubPage(
        items: rows,
        total: rows.length,
        partyCount: page.partyCount,
        balanceOwed: page.balanceOwed,
        openItemsCount: page.openItemsCount,
        buckets: page.buckets,
      );
    }
    final buckets = needle.isEmpty
        ? page.buckets
        : AgingBuckets({
            for (final b in AgeBucket.values)
              b: searched.fold(Decimal.zero, (sum, r) => sum + r.buckets[b]),
          });
    return HubPage(
      items: rows,
      total: rows.length,
      partyCount: rows.length,
      balanceOwed: rows.fold(Decimal.zero, (sum, r) => sum + r.balanceOwed),
      openItemsCount: rows.fold(0, (sum, r) => sum + r.openItemsCount),
      buckets: buckets,
    );
  }

  /// Rows with the reminders and promises saved here but not on the server's
  /// answer yet.
  Future<HubPage> _withPending(
    PartyType type,
    HubPage page, {
    DateTime? since,
  }) async {
    final local = await _localFollowups(type);
    final fresh = [
      for (final f in local)
        if (f.pending || (since != null && f.createdAt.isAfter(since))) f,
    ]..sort((a, b) => a.createdAt.compareTo(b.createdAt));
    if (fresh.isEmpty) return page;
    return HubPage(
      total: page.total,
      partyCount: page.partyCount,
      balanceOwed: page.balanceOwed,
      openItemsCount: page.openItemsCount,
      buckets: page.buckets,
      items: [
        for (final row in page.items)
          fresh.where((f) => f.partyId == row.id).fold(
                row,
                (r, f) => switch (f.kind) {
                  FollowupKind.reminder =>
                    r.withFollowups(reminderAt: f.createdAt),
                  FollowupKind.promise => r.withFollowups(
                      replacePromise: true,
                      promiseOn: f.promiseDate,
                      promiseValue: f.promiseAmount,
                    ),
                  FollowupKind.note => r,
                },
              ),
      ],
    );
  }

  // ── one party ──────────────────────────────────────────────────────────

  Future<Either<Failure, KhataData<OpenItems>>> openItems(
    PartyType type,
    String id, {
    String? branchId,
  }) =>
      _cached(
        key: 'khata_open|${type.apiValue}|$id|${_branch(branchId)}',
        fetch: () => _remote.openItems(type, id, branchId: branchId),
        read: OpenItems.fromJson,
      );

  /// Follow-ups held on this device (pulled, or saved here).
  Future<List<Followup>> _localFollowups(
    PartyType type, {
    String? partyId,
  }) async {
    final rows = await _store.entities(
      'party_followup',
      where: partyId == null ? null : 'parent_id = ?',
      args: [if (partyId != null) partyId],
    );
    if (rows.isEmpty) return const [];
    final ops = await _store.ops(statuses: OutboxStatus.unfinished);
    final unsent = {
      for (final o in ops)
        if (o.type == OpTypes.followupCreate && o.entityId != null)
          o.entityId!: o.needsAttention,
    };
    return [
      for (final row in rows)
        if (PartyType.parse('${row['party_type']}') == type)
          Followup.fromJson(
            row,
            pending: unsent.containsKey('${row['id']}'),
            needsAttention: unsent['${row['id']}'] ?? false,
          ),
    ];
  }

  /// The reminders, promises and notes of one party, newest first.
  Future<List<Followup>> followups(
    PartyType type,
    String id, {
    String? branchId,
  }) async {
    final key = 'khata_followups|${type.apiValue}|$id|${_branch(branchId)}';
    var server = <Map<String, dynamic>>[];
    var asked = false;
    if (_isReachable()) {
      try {
        server = await _remote.followups(type, id, branchId: branchId);
        await _keep(key, {'items': server}, _store.now());
        asked = true;
      } catch (_) {/* the kept and local rows are shown */}
    }
    if (!asked) {
      final items = (await _kept(key))?.body['items'];
      if (items is List) {
        server = [
          for (final e in items.whereType<Map<dynamic, dynamic>>())
            Map<String, dynamic>.from(e),
        ];
      }
    }
    final byId = <String, Followup>{};
    for (final f in await _localFollowups(type, partyId: id)) {
      // A branch view shows its own entries and the business-wide ones.
      if (branchId == null || f.branchId == null || f.branchId == branchId) {
        byId[f.id] = f;
      }
    }
    for (final row in server) {
      final f = Followup.fromJson(row);
      byId[f.id] = f;
    }
    return byId.values.toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  /// Saves a promise, reminder or note. Works offline; it is sent with the
  /// next sync.
  Future<Either<Failure, Followup>> addFollowup(
    PartyType type,
    String partyId, {
    required FollowupKind kind,
    DateTime? promiseDate,
    String? promiseAmount,
    String? channel,
    String? message,
    String? branchId,
  }) async {
    final text = message?.trim();
    try {
      final row = await _writer.createFollowup({
        'party_type': type.apiValue,
        'party_id': partyId,
        'kind': kind.name,
        if (promiseDate != null) 'promise_date': khataIsoDay(promiseDate),
        if (promiseAmount != null && promiseAmount.isNotEmpty)
          'promise_amount': promiseAmount,
        if (channel != null) 'channel': channel,
        if (text != null && text.isNotEmpty)
          'message_preview':
              text.length > 1000 ? text.substring(0, 1000) : text,
        if (branchId != null) 'branch_id': branchId,
      });
      return Right(Followup.fromJson(row, pending: true));
    } catch (e) {
      return Left(_errors.mapExceptionToFailure(e));
    }
  }

  // ── statements ─────────────────────────────────────────────────────────

  static String _statementKey(PartyType type, String id, String? branchId) =>
      'khata_statement|${type.apiValue}|$id|${_branch(branchId)}';

  Future<Either<Failure, KhataData<Statement>>> statement(
    PartyType type,
    String id, {
    DateTime? from,
    DateTime? to,
    String detail = 'summary',
    String? branchId,
  }) =>
      _cached(
        key: _statementKey(type, id, branchId),
        fetch: () => _remote.statement(
          type,
          id,
          from: from,
          to: to,
          detail: detail,
          branchId: branchId,
        ),
        read: Statement.fromJson,
      );

  Future<Either<Failure, Uint8List>> statementPdf(
    PartyType type,
    String id, {
    DateTime? from,
    DateTime? to,
    String detail = 'summary',
    String? branchId,
  }) =>
      _online(
        () => _remote.statementPdf(
          type,
          id,
          from: from,
          to: to,
          detail: detail,
          branchId: branchId,
        ),
      );

  Future<Either<Failure, StatementLink>> createLink(
    PartyType type,
    String id, {
    DateTime? from,
    DateTime? to,
    String detail = 'summary',
    String? branchId,
    String? idempotencyKey,
  }) =>
      _online(
        () => _remote.createLink(
          type,
          id,
          from: from,
          to: to,
          detail: detail,
          branchId: branchId,
          idempotencyKey: idempotencyKey,
        ),
      );

  // ── money entries (internet only) ──────────────────────────────────────

  Future<Either<Failure, T>> _moneyWrite<T>(Future<T> Function() call) async {
    final result = await _online(call);
    if (result.isRight()) _announce();
    return result;
  }

  /// Tells the screens to re-read, and fetches the new balance for offline use.
  void _announce() {
    _events?.notifyChanged();
    _refreshLocal?.call().ignore();
  }

  Future<Either<Failure, LedgerEntryResult>> openingBalance(
    PartyType type,
    String id,
    Map<String, dynamic> body, {
    String? idempotencyKey,
  }) =>
      _moneyWrite(
        () => _remote.openingBalance(
          type,
          id,
          body,
          idempotencyKey: idempotencyKey,
        ),
      );

  Future<Either<Failure, LedgerEntryResult>> manualEntry(
    PartyType type,
    String id,
    Map<String, dynamic> body, {
    String? idempotencyKey,
  }) =>
      _moneyWrite(
        () => _remote.manualEntry(
          type,
          id,
          body,
          idempotencyKey: idempotencyKey,
        ),
      );

  Future<Either<Failure, Unit>> reverseEntry(
    PartyType type,
    String entryId, {
    required String reason,
    String? idempotencyKey,
  }) =>
      _moneyWrite(() async {
        await _remote.reverseEntry(
          type,
          entryId,
          {'reason': reason.trim()},
          idempotencyKey: idempotencyKey,
        );
        return unit;
      });

  /// A new party with its opening balance, made by the server in one step.
  Future<Either<Failure, Map<String, dynamic>>> createPartyWithOpening(
    PartyType type,
    Map<String, dynamic> body, {
    String? idempotencyKey,
  }) =>
      _moneyWrite(
        () => _remote.createParty(
          type,
          body,
          idempotencyKey: idempotencyKey,
        ),
      );

  Future<Either<Failure, Unit>> updatePhone(
    PartyType type,
    String id,
    String phone,
  ) async {
    final result = await _online(() async {
      await _remote.updatePhone(type, id, phone);
      return unit;
    });
    if (result.isRight()) _refreshLocal?.call().ignore();
    return result;
  }

  // ── settings ───────────────────────────────────────────────────────────

  static const _settingsKey = 'khata_settings';

  /// Message templates, payment details and statement choices: the server's
  /// when reachable, otherwise the copy on this device.
  Future<KhataSettings> settings() async {
    final synced = await _catalog.settings();
    final values = <String, dynamic>{};
    final app = synced?['app_settings'];
    if (app is Map) values.addAll(Map<String, dynamic>.from(app));

    var fromServer = false;
    if (_isReachable()) {
      try {
        values.addAll(await _fetchSettings());
        fromServer = true;
      } catch (_) {/* the device's copy is used */}
    }
    if (!fromServer) {
      final kept = await _kept(_settingsKey);
      if (kept != null) values.addAll(kept.body);
    }
    return _readSettings(values, synced);
  }

  /// The settings to edit. Online they must come from the server: saving over
  /// an old or default copy would undo someone's changes.
  Future<Either<Failure, KhataSettings>> settingsForEdit() async {
    if (!_isReachable()) return Right(await settings());
    final result = await _online(_fetchSettings);
    final failure = result.fold((f) => f, (_) => null);
    if (failure is NetworkFailure) return Right(await settings());
    if (failure != null) return Left(failure);
    final synced = await _catalog.settings();
    return Right(_readSettings(result.getOrElse(() => const {}), synced));
  }

  /// Saves settings by key. Internet only.
  Future<Either<Failure, Unit>> saveSettings(
    Map<String, Object?> changes,
  ) async {
    final result = await _online(() async {
      await _settingsRemote.bulkUpdateSettings([
        for (final e in changes.entries)
          {
            'setting_key': e.key,
            'setting_value': {'value': e.value},
          },
      ]);
      return unit;
    });
    if (result.isRight()) {
      // Keeps the offline copy current.
      try {
        await _fetchSettings();
      } catch (_) {/* refreshed with the next sync */}
      _refreshLocal?.call().ignore();
    }
    return result;
  }

  Future<Map<String, dynamic>> _fetchSettings() async {
    final rows = await _settingsRemote.getSettings();
    final map = <String, dynamic>{
      for (final s in rows)
        if (s.branchId == null) s.settingKey: s.settingValue,
    };
    await _keep(_settingsKey, map, _store.now());
    return map;
  }

  static KhataSettings _readSettings(
    Map<String, dynamic> values,
    Map<String, dynamic>? synced,
  ) =>
      KhataSettings.fromMap(
        values,
        businessName: '${synced?['business_name'] ?? ''}',
        businessPhone: synced?['phone'] as String?,
        countryCode: synced?['country_code'] as String?,
      );
}
