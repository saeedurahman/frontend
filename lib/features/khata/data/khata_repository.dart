import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:decimal/decimal.dart';
import 'package:frantend/core/error/error_handler.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/core/offline/local_catalog.dart';
import 'package:frantend/core/offline/local_suppliers.dart';
import 'package:frantend/core/offline/offline_writer.dart';
import 'package:frantend/core/sync/outbox_op.dart';
import 'package:frantend/core/sync/sync_store.dart';
import 'package:frantend/core/utils/logger.dart';
import 'package:frantend/features/suppliers/data/models/supplier_model.dart';
import 'package:frantend/features/khata/data/khata_remote_datasource.dart';
import 'package:frantend/features/khata/data/models/khata_models.dart';
import 'package:frantend/features/khata/data/models/khata_p1_models.dart';
import 'package:frantend/features/khata/domain/khata_events.dart';
import 'package:frantend/features/khata/domain/khata_settings.dart';
import 'package:frantend/features/khata/domain/party_type.dart';
import 'package:frantend/features/settings/data/datasources/settings_remote_datasource.dart';

/// An answer, and whether it is the one kept on this device.
class KhataData<T> {
  const KhataData(
    this.value, {
    this.asOf,
    this.offline = false,
    this.allBranches = false,
  });

  final T value;

  /// When the server gave this answer (or the device's copy was updated).
  final DateTime? asOf;

  /// The server could not be reached: this comes from the device.
  final bool offline;

  /// One branch was asked for, but the supplier figures kept on the device
  /// are over all branches.
  final bool allBranches;
}

/// Everything the khata screens read and write.
///
/// Reads are online-first. When the server can't be reached, supplier figures
/// come from the pulled copy on the device and the rest from the last answer
/// kept, both marked with their time. Payments recorded here and not on the
/// server yet are taken off what you owe. Promises, reminders and notes are
/// written through the outbox, so they work without internet.
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
  late final LocalSupplierBook _suppliers = LocalSupplierBook(_store);

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
  }) async {
    final answer = await _cached(
      key: _overviewKey(branchId),
      fetch: () async =>
          (await _remote.overview(branchId: branchId)).toJson(),
      read: KhataOverview.fromJson,
    );
    final failure = answer.fold((f) => f, (_) => null);
    if (failure != null && failure is! NetworkFailure) return answer;
    final server = answer.fold((_) => null, (d) => d);

    if (server != null && !server.offline) {
      final paid = await _suppliers.paidHere(
        branchId: branchId,
        unsentOnly: true,
      );
      if (paid.isEmpty) return answer;
      return Right(
        KhataData(
          KhataOverview(
            receivable: server.value.receivable,
            payable: await _lessPaid(server.value.payable, paid),
          ),
          asOf: server.asOf,
        ),
      );
    }

    final owed = await _suppliers.hubRows();
    final bookAt = await _suppliers.asOf();
    if (owed != null) {
      final kept = server?.asOf;
      return Right(
        KhataData(
          KhataOverview(
            // Nothing kept about customers: no figure is better than zero.
            receivable: server?.value.receivable ?? KhataSide.unknown,
            payable: KhataSide(
              total: _owedBy(owed),
              count: owed.length,
              buckets: _bucketsOf(owed),
            ),
          ),
          // Two sources: the older time is the honest one.
          asOf: kept != null && bookAt != null && kept.isBefore(bookAt)
              ? kept
              : bookAt,
          offline: true,
          allBranches: branchId != null,
        ),
      );
    }
    if (server == null) return answer;
    return Right(
      KhataData(
        KhataOverview(
          receivable: server.value.receivable,
          payable: await _lessPaid(
            server.value.payable,
            await _suppliers.paidHere(branchId: branchId),
          ),
        ),
        asOf: server.asOf,
        offline: true,
      ),
    );
  }

  static Decimal _owedBy(Iterable<HubRow> rows) =>
      rows.fold(Decimal.zero, (sum, r) => sum + r.balanceOwed);

  static AgingBuckets _bucketsOf(Iterable<HubRow> rows) => AgingBuckets({
        for (final b in AgeBucket.values)
          b: rows.fold(Decimal.zero, (sum, r) => sum + r.buckets[b]),
      });

  /// The server's payable figure with [paid] (per supplier, not on the server
  /// yet) taken off. An overpayment never reduces what others are owed: the
  /// pulled balance caps each supplier's share.
  Future<KhataSide> _lessPaid(
    KhataSide side,
    Map<String, Decimal> paid,
  ) async {
    var total = side.total;
    var count = side.count;
    for (final entry in paid.entries) {
      final account = await _store.entity('supplier_balance', entry.key);
      final owed = account == null
          ? null
          : khataDecimal(account['balance_owed']);
      if (owed == null) {
        total -= entry.value;
        continue;
      }
      total -= entry.value < owed ? entry.value : owed;
      if (owed > Decimal.zero && entry.value >= owed) count -= 1;
    }
    return KhataSide(
      total: total < Decimal.zero ? Decimal.zero : total,
      count: count < 0 ? 0 : count,
      buckets: side.buckets,
    );
  }

  /// [page] with [paid] (per supplier) taken off its rows and totals; a
  /// supplier paid in full leaves the list.
  static HubPage _lessPaidRows(HubPage page, Map<String, Decimal> paid) {
    if (paid.isEmpty) return page;
    var off = Decimal.zero;
    var settled = 0;
    final rows = <HubRow>[];
    for (final row in page.items) {
      final money = paid[row.id];
      if (money == null) {
        rows.add(row);
        continue;
      }
      if (money >= row.balanceOwed) {
        off += row.balanceOwed;
        settled++;
        continue;
      }
      off += money;
      rows.add(row.lessPaid(money));
    }
    return HubPage(
      items: rows,
      total: page.total - settled,
      partyCount: page.partyCount - settled,
      balanceOwed: page.balanceOwed - off,
      openItemsCount: page.openItemsCount,
      buckets: page.buckets,
    );
  }

  /// One page of the hub list. Offline, suppliers are listed from the pulled
  /// accounts on this device and customers from the pages seen so far; both
  /// are searched, filtered and sorted here (all at once, so [skip] is
  /// ignored).
  Future<Either<Failure, KhataData<HubPage>>> hub(
    HubQuery q, {
    int skip = 0,
    int limit = 50,
  }) async {
    Failure failure = const NetworkFailure(offlineMessage);
    final supplier = !q.party.isCustomer;
    if (_isReachable()) {
      try {
        // Read before asking the server: a payment sent in between is then
        // in its answer.
        final unsent = supplier
            ? await _suppliers.paidHere(
                branchId: q.branchId,
                unsentOnly: true,
              )
            : const <String, Decimal>{};
        final page = await _remote.hub(q, skip: skip, limit: limit);
        final now = _store.now();
        if (q.isUnfiltered) await _keepHub(q, page, skip, now);
        return Right(
          KhataData(
            await _withPending(q.party, _lessPaidRows(page, unsent)),
            asOf: now,
          ),
        );
      } catch (e) {
        failure = _errors.mapExceptionToFailure(e);
        if (failure is! NetworkFailure) return Left(failure);
      }
    }
    if (supplier) {
      final rows = await _suppliers.hubRows();
      if (rows != null) {
        final all = HubPage(
          items: rows,
          total: rows.length,
          partyCount: rows.length,
          balanceOwed: _owedBy(rows),
          openItemsCount: rows.fold(0, (sum, r) => sum + r.openItemsCount),
          buckets: _bucketsOf(rows),
        );
        return Right(
          KhataData(
            await _withPending(
              q.party,
              _filterLocally(all, q),
              // The rows carry no follow-ups: all saved ones apply.
              since: DateTime.fromMillisecondsSinceEpoch(0),
            ),
            asOf: await _suppliers.asOf(),
            offline: true,
            allBranches: q.branchId != null,
          ),
        );
      }
    }
    final kept = await _kept(_hubKey(q));
    if (kept == null) return Left(failure);
    var page = HubPage.fromJson(kept.body);
    if (supplier) {
      page = _lessPaidRows(
        page,
        await _suppliers.paidHere(branchId: q.branchId),
      );
    }
    return Right(
      KhataData(
        await _withPending(q.party, _filterLocally(page, q), since: kept.at),
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

  /// The unpaid bills. A supplier's are read from the pulled copy offline;
  /// money waiting to sync comes off the total, never off a bill (the server
  /// decides which bill it pays).
  Future<Either<Failure, KhataData<OpenItems>>> openItems(
    PartyType type,
    String id, {
    String? branchId,
  }) async {
    Future<Either<Failure, KhataData<OpenItems>>> ask() => _cached(
          key: 'khata_open|${type.apiValue}|$id|${_branch(branchId)}',
          fetch: () => _remote.openItems(type, id, branchId: branchId),
          read: OpenItems.fromJson,
        );
    if (type.isCustomer) return ask();
    final unsent = await _suppliers.pendingPaid(
      id,
      branchId: branchId,
      unsentOnly: true,
    );
    final answer = await ask();
    final failure = answer.fold((f) => f, (_) => null);
    if (failure != null && failure is! NetworkFailure) return answer;
    final server = answer.fold((_) => null, (d) => d);
    if (server != null && !server.offline) {
      return Right(
        KhataData(server.value.withPayments(unsent), asOf: server.asOf),
      );
    }
    final local = await _suppliers.openItems(id);
    if (local != null) {
      return Right(
        KhataData(
          local,
          asOf: await _suppliers.asOf(),
          offline: true,
          allBranches: branchId != null,
        ),
      );
    }
    if (server == null) return answer;
    final paid = await _suppliers.pendingPaid(id, branchId: branchId);
    return Right(
      KhataData(
        server.value.withPayments(paid),
        asOf: server.asOf,
        offline: true,
      ),
    );
  }

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
  }) async {
    final result = await _moneyWrite(
      () => _remote.createParty(
        type,
        body,
        idempotencyKey: idempotencyKey,
      ),
    );
    if (type == PartyType.supplier) {
      await result.fold((_) async {}, _keepSupplier);
    }
    return result;
  }

  /// The supplier lists read this device: a new one is put there at once.
  Future<void> _keepSupplier(Map<String, dynamic> created) async {
    try {
      await _suppliers.saveFromServer(SupplierModel.fromJson(created));
    } catch (e) {
      // The next sync brings it anyway.
      AppLogger.warning('Local supplier write failed (${e.runtimeType})');
    }
  }

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
