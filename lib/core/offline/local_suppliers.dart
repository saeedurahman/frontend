import 'package:decimal/decimal.dart';
import 'package:frantend/core/sync/outbox_op.dart';
import 'package:frantend/core/sync/sync_store.dart';
import 'package:frantend/features/khata/data/models/khata_models.dart';
import 'package:frantend/features/khata/data/models/khata_p1_models.dart';
import 'package:frantend/features/khata/domain/khata_text.dart';
import 'package:frantend/features/suppliers/data/models/supplier_model.dart';

/// What this device knows about suppliers: the pulled suppliers (plus the ones
/// added or changed here), their pulled balances, bills and account lines
/// (read only, replaced by every pull), and the payments and new accounts
/// recorded here that the pulled figures do not include yet.
///
/// Balances and bills are over all branches, as the server sends them. Which
/// bill a payment settles is the server's to say, so bills are shown as
/// pulled and only the totals move.
class LocalSupplierBook {
  LocalSupplierBook(this._store);

  final SyncStore _store;

  static const supplierEntity = 'supplier';

  /// When the copy on this device was last brought up to date.
  Future<DateTime?> asOf() async =>
      DateTime.tryParse(await _store.meta(SyncStore.lastPullAtKey) ?? '')
          ?.toLocal();

  // ── suppliers ──────────────────────────────────────────────────────────

  /// A feed row as the app reads a supplier (the feed calls the first address
  /// line `address`).
  static SupplierModel _model(Map<String, dynamic> row) =>
      SupplierModel.fromJson({
        ...row,
        'business_id': '${row['business_id'] ?? ''}',
        'address_line1': row['address'] ?? row['address_line1'],
      });

  Future<SupplierModel?> supplier(String id) async {
    final row = await _store.entity(supplierEntity, id);
    return row == null ? null : _model(row);
  }

  /// Every supplier on this device, by name.
  Future<List<SupplierModel>> suppliers() async => [
        for (final row in await _store.entities(supplierEntity)) _model(row),
      ]..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

  /// Added or changed here and not accepted by the server yet.
  Future<Set<String>> unsyncedIds() => _store.unsyncedSupplierIds();

  /// Added here, and the server may not have it yet: what the server says
  /// about it would be incomplete.
  Future<bool> isNewHere(String id) async => (await _store.unfinishedSupplierOps(
        id,
        OpTypes.supplierCreate,
      ))
          .isNotEmpty;

  /// Puts a supplier the server has just saved on this device, so open lists
  /// show it before the next pull. One with changes waiting here is left as it
  /// is.
  Future<void> saveFromServer(SupplierModel supplier) => _store.transaction(
        () async {
          if ((await unsyncedIds()).contains(supplier.id)) return;
          final held = await _store.entity(supplierEntity, supplier.id);
          await _store.putFromServer(supplierEntity, supplier.id, {
            ...?held,
            ...supplier.toJson()..remove('address_line1'),
            'address': supplier.addressLine1,
          });
        },
      );

  /// The server has just deleted this supplier.
  Future<void> removeDeleted(String id) => _store.transaction(
        () => _store.removeFromServer(supplierEntity, id),
      );

  // ── new accounts ───────────────────────────────────────────────────────

  /// The `supplier.create` of a supplier whose account has not been pulled.
  Future<OutboxOp?> _newAccount(String supplierId) async =>
      (await _store.pendingSupplierCreates(supplierId: supplierId))
          .firstOrNull;

  static Map<String, dynamic>? _openingOf(OutboxOp create) {
    final raw = create.payload['opening_balance'];
    return raw is Map ? Map<String, dynamic>.from(raw) : null;
  }

  /// Ledger sign (negative = we owe) of a new supplier's opening balance.
  static Decimal _openingAmount(OutboxOp create) {
    final opening = _openingOf(create);
    if (opening == null) return Decimal.zero;
    final amount = khataDecimal(opening['amount']);
    return opening['direction'] == 'we_owe_them' ? -amount : amount;
  }

  static String _openingId(String supplierId) => 'opening-$supplierId';

  SupplierLedgerEntry? _openingEntry(String supplierId, OutboxOp create) {
    final opening = _openingOf(create);
    if (opening == null) return null;
    return SupplierLedgerEntry.fromJson({
      'id': _openingId(supplierId),
      'supplier_id': supplierId,
      'branch_id': opening['branch_id'],
      'entry_type': 'opening_balance',
      'amount': '${_openingAmount(create)}',
      'source': 'opening',
      'reference_type': 'manual',
      'entry_at': opening['as_of_date'],
    }).onDevice(needsAttention: create.needsAttention);
  }

  // ── payments recorded here ─────────────────────────────────────────────

  /// This device's payments the figures do not include yet. [unsentOnly]
  /// leaves out the ones the server has already accepted (for adding on top
  /// of an answer asked from the server just now).
  Future<List<OutboxOp>> payments({
    String? supplierId,
    String? branchId,
    bool unsentOnly = false,
  }) async => [
        for (final o
            in await _store.pendingSupplierPayments(supplierId: supplierId))
          if ((!unsentOnly || o.status != OutboxStatus.applied) &&
              (branchId == null || '${o.payload['branch_id']}' == branchId))
            o,
      ];

  /// The money of [payments], per supplier.
  Future<Map<String, Decimal>> paidHere({
    String? branchId,
    bool unsentOnly = false,
  }) async {
    final out = <String, Decimal>{};
    for (final o
        in await payments(branchId: branchId, unsentOnly: unsentOnly)) {
      final id = '${o.payload['supplier_id']}';
      out[id] = (out[id] ?? Decimal.zero) + SyncStore.paymentTotal([o]);
    }
    return out;
  }

  Future<Decimal> pendingPaid(
    String supplierId, {
    String? branchId,
    bool unsentOnly = false,
  }) async =>
      SyncStore.paymentTotal(
        await payments(
          supplierId: supplierId,
          branchId: branchId,
          unsentOnly: unsentOnly,
        ),
      );

  /// The account lines of [payments], oldest first. One the server's own row
  /// has already arrived for is left out.
  Future<List<SupplierLedgerEntry>> pendingEntries(
    String supplierId, {
    String? branchId,
    bool unsentOnly = false,
  }) async {
    final out = <SupplierLedgerEntry>[];
    for (final o in await payments(
      supplierId: supplierId,
      branchId: branchId,
      unsentOnly: unsentOnly,
    )) {
      final p = o.payload;
      final row = await _store.entity('supplier_ledger', '${p['id']}');
      if (row != null && row[SyncStore.localRowKey] != true) continue;
      out.add(
        SupplierLedgerEntry.fromJson({
          'id': p['id'],
          'supplier_id': p['supplier_id'],
          'branch_id': p['branch_id'],
          'entry_type': 'payment',
          'amount': p['amount'],
          'payment_source': p['payment_source'],
          'reference_no': p['reference'],
          'reference_type': 'manual',
          'notes': p['note'],
          'register_shift_id': p['register_shift_id'],
          'entry_at': p['paid_at'],
        }).onDevice(needsAttention: o.needsAttention),
      );
    }
    out.sort(_oldestFirst);
    return out;
  }

  static int _oldestFirst(SupplierLedgerEntry a, SupplierLedgerEntry b) {
    final epoch = DateTime.fromMillisecondsSinceEpoch(0);
    final byTime = (a.entryAt ?? epoch).compareTo(b.entryAt ?? epoch);
    return byTime != 0 ? byTime : a.id.compareTo(b.id);
  }

  // ── balance ────────────────────────────────────────────────────────────

  static String _supplierId(Map<String, dynamic> row) =>
      '${row['supplier_id'] ?? row['id']}';

  /// Ledger sign (negative = we owe) of a pulled balance or open-items row.
  static Decimal _balanceOf(Map<String, dynamic> row) =>
      khataDecimal(row['advance_amount']) - khataDecimal(row['balance_owed']);

  /// The balance as shown offline (ledger sign): the pulled one (for a supplier
  /// added here, its opening balance) with this device's payments on top. Null
  /// when the account is not on this device.
  Future<Decimal?> balance(String supplierId) async {
    final row = await _store.entity('supplier_balance', supplierId);
    final Decimal base;
    if (row != null) {
      if (await asOf() == null) return null;
      base = _balanceOf(row);
    } else {
      final create = await _newAccount(supplierId);
      if (create == null) return null;
      base = _openingAmount(create);
    }
    return base + await pendingPaid(supplierId);
  }

  // ── account lines ──────────────────────────────────────────────────────

  /// The account from this device, newest first: only the recent history the
  /// server sends, with what is waiting to sync on top. Null when the account
  /// is not on this device.
  Future<SupplierLedgerPage?> ledger(
    String supplierId, {
    int skip = 0,
    int limit = 50,
    DateTime? dateFrom,
    DateTime? dateTo,
  }) async {
    var at = await asOf();
    final account = await _store.entity('supplier_balance', supplierId);
    final create = account == null ? await _newAccount(supplierId) : null;
    if (account == null) {
      if (create == null) return null;
      at ??= DateTime.tryParse(create.occurredAt)?.toLocal() ?? _store.now();
    } else if (at == null) {
      return null;
    }
    final pulled = [
      for (final row in await _store.entities(
        'supplier_ledger',
        where: 'parent_id = ?',
        args: [supplierId],
        orderBy: 'id',
      ))
        if (row[SyncStore.localRowKey] != true)
          SupplierLedgerEntry.fromJson(row),
    ]..sort(_oldestFirst);

    final base = account == null ? Decimal.zero : _balanceOf(account);
    var running = base;
    final waiting = <SupplierLedgerEntry>[];
    final opened =
        create == null ? null : _openingEntry(supplierId, create);
    for (final e in [
      ?opened,
      ...await pendingEntries(supplierId),
    ]..sort(_oldestFirst)) {
      running += e.amount;
      waiting.add(
        e.onDevice(
          needsAttention: e.needsAttention,
          runningBalance: running,
        ),
      );
    }

    DateTime day(DateTime d) => DateTime(d.year, d.month, d.day);
    bool afterStart(SupplierLedgerEntry e) =>
        dateFrom == null ||
        (e.entryAt != null && !day(e.entryAt!).isBefore(day(dateFrom)));
    bool beforeEnd(SupplierLedgerEntry e) =>
        dateTo == null ||
        (e.entryAt != null && !day(e.entryAt!).isAfter(day(dateTo)));

    final shown = [
      for (final e in [...pulled, ...waiting].reversed)
        if (afterStart(e) && beforeEnd(e)) e,
    ];

    Decimal? opening;
    Decimal? closing;
    if (dateFrom != null || dateTo != null) {
      // Only what the rows held here can prove; the device may not have the
      // older ones.
      final before = [
        for (final e in pulled)
          if (!afterStart(e)) e,
      ];
      opening = dateFrom != null && before.isNotEmpty
          ? before.last.runningBalance
          : _startOf(pulled, account, base, dateFrom);
      if (account == null && dateFrom != null) {
        // A new account: everything it has is here.
        opening = waiting
            .where((e) => !afterStart(e))
            .fold<Decimal>(Decimal.zero, (sum, e) => sum + e.amount);
      }
      if (dateTo == null) {
        closing = running;
      } else {
        final upTo = [
          for (final e in pulled)
            if (beforeEnd(e)) e,
        ];
        final held = account == null
            ? Decimal.zero
            : (upTo.isEmpty ? opening : upTo.last.runningBalance);
        if (held != null) {
          closing = waiting
              .where(beforeEnd)
              .fold<Decimal>(held, (sum, e) => sum + e.amount);
        }
      }
    }

    final hasOlder = account?['has_older_entries'] == true;
    final oldest = khataMoment(account?['oldest_included_entry_at']);
    return SupplierLedgerPage(
      items: shown.skip(skip).take(limit).toList(),
      total: shown.length,
      skip: skip,
      limit: limit,
      balance: running,
      openingBalance: opening,
      closingBalance: closing,
      asOf: at,
      // The period asked for reaches back past what the server sent.
      olderNeedsInternet: hasOlder &&
          (dateFrom == null ||
              oldest == null ||
              !day(dateFrom).isAfter(day(oldest.toLocal()))),
    );
  }

  /// The balance before the pulled rows of a period starting [dateFrom], when
  /// they prove it: nothing older exists and the account starts with them, or
  /// the period starts after the day of the oldest one.
  static Decimal? _startOf(
    List<SupplierLedgerEntry> pulled,
    Map<String, dynamic>? account,
    Decimal base,
    DateTime? dateFrom,
  ) {
    final hasOlder = account?['has_older_entries'];
    final first = pulled.firstOrNull;
    if (first == null) {
      return hasOlder == false && base == Decimal.zero ? Decimal.zero : null;
    }
    final after = first.runningBalance;
    if (after == null) return null;
    if (hasOlder != true && after == first.amount) return Decimal.zero;
    final oldest = khataMoment(account?['oldest_included_entry_at'])?.toLocal();
    if (dateFrom != null &&
        oldest != null &&
        DateTime(dateFrom.year, dateFrom.month, dateFrom.day)
            .isAfter(DateTime(oldest.year, oldest.month, oldest.day))) {
      return after - first.amount;
    }
    return null;
  }

  // ── bills ──────────────────────────────────────────────────────────────

  /// The unpaid bills as pulled, with their ages counted on this device and
  /// this device's payments taken off the total. Null when not on this device.
  Future<OpenItems?> openItems(String supplierId) async {
    var row = await _store.entity('supplier_open_items', supplierId);
    if (row != null && await asOf() == null) return null;
    row ??= await _newOpenItems(supplierId);
    if (row == null) return null;
    final who = await supplier(supplierId);
    final items = _bills(row);
    final balance = _balanceOf(row);
    return OpenItems(
      name: who?.name ?? KhataText.unnamedSupplier,
      phone: who?.phone,
      asOf: _today(),
      termsDays: int.tryParse('${row['terms_days']}') ?? 0,
      balanceOwed: balance < Decimal.zero ? -balance : Decimal.zero,
      advance: balance > Decimal.zero ? balance : Decimal.zero,
      items: items,
      buckets: _buckets(items),
    ).withPayments(await pendingPaid(supplierId));
  }

  /// A new supplier's open items, in the shape the feed sends: its opening
  /// balance is the only bill there can be.
  Future<Map<String, dynamic>?> _newOpenItems(String supplierId) async {
    if (await _store.entity('supplier_balance', supplierId) != null) {
      return null;
    }
    final create = await _newAccount(supplierId);
    if (create == null) return null;
    final terms = create.payload['payment_terms_days'] ?? 30;
    final opened = _openingAmount(create);
    final date = khataDay(_openingOf(create)?['as_of_date']);
    return {
      'terms_days': terms,
      'balance_owed': '${opened < Decimal.zero ? -opened : Decimal.zero}',
      'advance_amount': '${opened > Decimal.zero ? opened : Decimal.zero}',
      'items': [
        if (opened < Decimal.zero)
          {
            'document_type': 'opening_balance',
            'document_id': _openingId(supplierId),
            'date': _openingOf(create)?['as_of_date'],
            'due_date': date == null
                ? null
                : DateTime(
                    date.year,
                    date.month,
                    date.day + (int.tryParse('$terms') ?? 0),
                  ).toIso8601String().substring(0, 10),
            'total': '${-opened}',
            'allocated': '0',
            'remaining': '${-opened}',
          },
      ],
    };
  }

  DateTime _today() {
    final now = _store.now().toLocal();
    return DateTime(now.year, now.month, now.day);
  }

  /// The pulled bills, oldest first. Ages are derived from the dates (the feed
  /// leaves them out, as they change with the calendar alone).
  List<OpenItem> _bills(Map<String, dynamic> row) {
    final today = _today();
    int daysSince(DateTime? day) {
      if (day == null) return 0;
      final days = DateTime.utc(today.year, today.month, today.day)
          .difference(DateTime.utc(day.year, day.month, day.day))
          .inDays;
      return days < 0 ? 0 : days;
    }

    return [
      for (final e in (row['items'] as List? ?? const []))
        if (e is Map)
          OpenItem.fromJson({
            ...Map<String, dynamic>.from(e),
            'age_days': daysSince(khataDay(e['date'])),
            'overdue_days': daysSince(khataDay(e['due_date'])),
          }),
    ];
  }

  static AgingBuckets _buckets(Iterable<OpenItem> items) {
    final amounts = <AgeBucket, Decimal>{};
    for (final item in items) {
      amounts[item.bucket] =
          (amounts[item.bucket] ?? Decimal.zero) + item.remaining;
    }
    return AgingBuckets(amounts);
  }

  // ── everyone we owe ────────────────────────────────────────────────────

  /// One hub row per supplier we still owe, unsorted. Null when no supplier
  /// account is on this device.
  Future<List<HubRow>?> hubRows() async {
    final pulled = await asOf() == null
        ? <Map<String, dynamic>>[]
        : await _store.entities('supplier_balance', orderBy: 'id');
    final have = {for (final row in pulled) _supplierId(row)};
    // Suppliers added here have no pulled account yet.
    final added = <Map<String, dynamic>>[];
    final addedBills = <String, Map<String, dynamic>>{};
    for (final create in await _store.pendingSupplierCreates()) {
      final id = create.entityId;
      if (id == null || have.contains(id)) continue;
      final row = await _newOpenItems(id);
      if (row == null) continue;
      added.add({...row, 'supplier_id': id});
      addedBills[id] = row;
    }
    final accounts = [...pulled, ...added];
    if (accounts.isEmpty) return null;
    final paid = await paidHere();
    final names = {for (final s in await suppliers()) s.id: s};
    final bills = {
      for (final row
          in await _store.entities('supplier_open_items', orderBy: 'id'))
        _supplierId(row): row,
      ...addedBills,
    };
    final lastPaid = await _lastPayments();

    final rows = <HubRow>[];
    for (final account in accounts) {
      final id = _supplierId(account);
      final owed = -(_balanceOf(account) + (paid[id] ?? Decimal.zero));
      if (owed <= Decimal.zero) continue;
      final items = bills[id] == null ? <OpenItem>[] : _bills(bills[id]!);
      final oldest = items.firstOrNull;
      rows.add(
        HubRow(
          id: id,
          name: names[id]?.name ?? KhataText.unnamedSupplier,
          phone: names[id]?.phone,
          balanceOwed: owed,
          oldestOpenDate: oldest?.date,
          oldestAgeDays: oldest?.ageDays ?? 0,
          buckets: _buckets(items),
          lastPaymentAt: lastPaid[id],
          openItemsCount: items.length,
        ),
      );
    }
    return rows;
  }

  Future<Map<String, DateTime>> _lastPayments() async {
    final out = <String, DateTime>{};
    void note(SupplierLedgerEntry e) {
      final at = e.entryAt;
      if (!e.isPayment || e.isReversed || at == null) return;
      if (out[e.supplierId]?.isAfter(at) != true) out[e.supplierId] = at;
    }

    // Rows written here are among them: a payment waiting to sync counts.
    for (final row
        in await _store.entities('supplier_ledger', orderBy: 'id')) {
      note(SupplierLedgerEntry.fromJson(row));
    }
    return out;
  }
}
