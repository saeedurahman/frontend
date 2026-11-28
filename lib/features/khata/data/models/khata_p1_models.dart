/// Plain readers for the khata endpoints (hub, open items, follow-ups,
/// statements). Hand written on purpose: no code generation involved.
library;

import 'package:decimal/decimal.dart';
import 'package:frantend/features/khata/data/models/khata_models.dart';
import 'package:frantend/features/khata/domain/party_type.dart';

String? _text(Object? value) {
  if (value == null) return null;
  final s = '$value'.trim();
  return s.isEmpty ? null : s;
}

int _int(Object? value) =>
    value is num ? value.toInt() : int.tryParse('${value ?? ''}') ?? 0;

Decimal? _money(Object? value) =>
    value == null ? null : Decimal.tryParse('$value'.trim());

/// A calendar day (`2026-11-27`), with no time zone attached to it.
DateTime? khataDay(Object? value) {
  final text = _text(value);
  if (text == null) return null;
  final parsed = DateTime.tryParse(text.length > 10 ? text.substring(0, 10) : text);
  return parsed == null ? null : DateTime(parsed.year, parsed.month, parsed.day);
}

/// A moment in time, shown in the device's zone.
DateTime? khataMoment(Object? value) =>
    DateTime.tryParse('${value ?? ''}')?.toLocal();

Map<String, dynamic> _map(Object? value) => value is Map
    ? Map<String, dynamic>.from(value)
    : const <String, dynamic>{};

List<Map<String, dynamic>> _maps(Object? value) => value is List
    ? [for (final e in value.whereType<Map<dynamic, dynamic>>()) _map(e)]
    : const [];

/// The four aging buckets, oldest last. [apiValue] is the server's key.
enum AgeBucket {
  upTo30('0-30'),
  upTo60('31-60'),
  upTo90('61-90'),
  over90('90+');

  const AgeBucket(this.apiValue);

  final String apiValue;

  static AgeBucket of(int ageDays) => ageDays <= 30
      ? upTo30
      : ageDays <= 60
          ? upTo60
          : ageDays <= 90
              ? upTo90
              : over90;

  static AgeBucket? parse(Object? value) {
    for (final b in values) {
      if (b.apiValue == value) return b;
    }
    return null;
  }
}

/// Money per aging bucket.
class AgingBuckets {
  const AgingBuckets(this.amounts);

  static const empty = AgingBuckets(<AgeBucket, Decimal>{});

  factory AgingBuckets.fromJson(Object? json) {
    final map = _map(json);
    return AgingBuckets({
      for (final b in AgeBucket.values) b: khataDecimal(map[b.apiValue]),
    });
  }

  final Map<AgeBucket, Decimal> amounts;

  Decimal operator [](AgeBucket bucket) => amounts[bucket] ?? Decimal.zero;

  Decimal get total =>
      AgeBucket.values.fold(Decimal.zero, (sum, b) => sum + this[b]);

  Map<String, String> toJson() => {
        for (final b in AgeBucket.values) b.apiValue: this[b].toString(),
      };
}

/// One party in the hub list.
class HubRow {
  const HubRow({
    required this.id,
    required this.name,
    required this.balanceOwed,
    required this.oldestAgeDays,
    this.phone,
    this.oldestOpenDate,
    this.buckets = AgingBuckets.empty,
    this.lastPaymentAt,
    this.lastReminderAt,
    this.promiseDate,
    this.promiseAmount,
    this.openItemsCount = 0,
  });

  factory HubRow.fromJson(Map<String, dynamic> json) => HubRow(
        id: '${json['id']}',
        name: '${json['name'] ?? ''}',
        phone: _text(json['phone']),
        balanceOwed: khataDecimal(json['balance_owed']),
        oldestOpenDate: khataDay(json['oldest_open_date']),
        oldestAgeDays: _int(json['oldest_age_days']),
        buckets: AgingBuckets.fromJson(json['bucket_amounts']),
        lastPaymentAt: khataMoment(json['last_payment_at']),
        lastReminderAt: khataMoment(json['last_reminder_at']),
        promiseDate: khataDay(json['promise_date']),
        promiseAmount: _money(json['promise_amount']),
        openItemsCount: _int(json['open_items_count']),
      );

  final String id;
  final String name;
  final String? phone;
  final Decimal balanceOwed;
  final DateTime? oldestOpenDate;
  final int oldestAgeDays;
  final AgingBuckets buckets;
  final DateTime? lastPaymentAt;
  final DateTime? lastReminderAt;
  final DateTime? promiseDate;
  final Decimal? promiseAmount;
  final int openItemsCount;

  /// With [paid] (less than what is owed) taken off the balance.
  HubRow lessPaid(Decimal paid) => HubRow(
        id: id,
        name: name,
        phone: phone,
        balanceOwed: balanceOwed - paid,
        oldestOpenDate: oldestOpenDate,
        oldestAgeDays: oldestAgeDays,
        buckets: buckets,
        lastPaymentAt: lastPaymentAt,
        lastReminderAt: lastReminderAt,
        promiseDate: promiseDate,
        promiseAmount: promiseAmount,
        openItemsCount: openItemsCount,
      );

  /// With the newer follow-ups saved on this device on top.
  HubRow withFollowups({
    DateTime? reminderAt,
    DateTime? promiseOn,
    Decimal? promiseValue,
    bool replacePromise = false,
  }) =>
      HubRow(
        id: id,
        name: name,
        phone: phone,
        balanceOwed: balanceOwed,
        oldestOpenDate: oldestOpenDate,
        oldestAgeDays: oldestAgeDays,
        buckets: buckets,
        lastPaymentAt: lastPaymentAt,
        lastReminderAt: reminderAt != null &&
                (lastReminderAt == null || reminderAt.isAfter(lastReminderAt!))
            ? reminderAt
            : lastReminderAt,
        promiseDate: replacePromise ? promiseOn : promiseDate,
        promiseAmount: replacePromise ? promiseValue : promiseAmount,
        openItemsCount: openItemsCount,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'phone': phone,
        'balance_owed': balanceOwed.toString(),
        'oldest_open_date': oldestOpenDate?.toIso8601String(),
        'oldest_age_days': oldestAgeDays,
        'bucket_amounts': buckets.toJson(),
        'last_payment_at': lastPaymentAt?.toUtc().toIso8601String(),
        'last_reminder_at': lastReminderAt?.toUtc().toIso8601String(),
        'promise_date': promiseDate?.toIso8601String(),
        'promise_amount': promiseAmount?.toString(),
        'open_items_count': openItemsCount,
      };
}

/// A page of `GET /khata/receivables` or `/khata/payables`.
class HubPage {
  const HubPage({
    required this.items,
    required this.total,
    required this.partyCount,
    required this.balanceOwed,
    required this.buckets,
    this.openItemsCount = 0,
  });

  factory HubPage.fromJson(Map<String, dynamic> json) {
    final totals = _map(json['totals']);
    return HubPage(
      items: [for (final e in _maps(json['items'])) HubRow.fromJson(e)],
      total: _int(json['total']),
      partyCount: _int(totals['party_count']),
      balanceOwed: khataDecimal(totals['balance_owed']),
      openItemsCount: _int(totals['open_items_count']),
      buckets: AgingBuckets.fromJson(json['bucket_totals']),
    );
  }

  final List<HubRow> items;

  /// Rows matching the search and bucket (for paging).
  final int total;

  /// Totals over the rows matching the search and bucket.
  final int partyCount;
  final Decimal balanceOwed;
  final int openItemsCount;

  /// Per bucket, over the rows matching the search whatever the bucket.
  final AgingBuckets buckets;

  Map<String, dynamic> toJson() => {
        'total': total,
        'totals': {
          'party_count': partyCount,
          'balance_owed': balanceOwed.toString(),
          'open_items_count': openItemsCount,
        },
        'bucket_totals': buckets.toJson(),
        'items': [for (final r in items) r.toJson()],
      };
}

/// One side of `GET /khata/summary`.
class KhataSide {
  const KhataSide({
    required this.total,
    required this.count,
    required this.buckets,
    this.known = true,
  });

  static final empty =
      KhataSide(total: Decimal.zero, count: 0, buckets: AgingBuckets.empty);

  /// No figure for this side on the device.
  static final unknown = KhataSide(
    total: Decimal.zero,
    count: 0,
    buckets: AgingBuckets.empty,
    known: false,
  );

  /// False when the figures are not on the device: nothing is shown for them.
  final bool known;
  final Decimal total;
  final int count;
  final AgingBuckets buckets;
}

/// `GET /khata/summary`: both sides, for the hub header and the dashboard.
class KhataOverview {
  const KhataOverview({required this.receivable, required this.payable});

  factory KhataOverview.fromJson(Map<String, dynamic> json) {
    final counts = _map(json['counts']);
    final buckets = _map(json['buckets']);
    return KhataOverview(
      receivable: KhataSide(
        total: khataDecimal(json['receivable_total']),
        count: _int(counts['receivable']),
        buckets: AgingBuckets.fromJson(buckets['receivable']),
      ),
      payable: KhataSide(
        total: khataDecimal(json['payable_total']),
        count: _int(counts['payable']),
        buckets: AgingBuckets.fromJson(buckets['payable']),
      ),
    );
  }

  final KhataSide receivable;
  final KhataSide payable;

  KhataSide side(PartyType type) => type.isCustomer ? receivable : payable;

  Map<String, dynamic> toJson() => {
        'receivable_total': receivable.total.toString(),
        'payable_total': payable.total.toString(),
        'counts': {'receivable': receivable.count, 'payable': payable.count},
        'buckets': {
          'receivable': receivable.buckets.toJson(),
          'payable': payable.buckets.toJson(),
        },
      };
}

/// A bill that is not fully paid yet.
class OpenItem {
  const OpenItem({
    required this.documentType,
    required this.documentId,
    required this.total,
    required this.allocated,
    required this.remaining,
    required this.ageDays,
    this.number,
    this.date,
    this.dueDate,
    this.overdueDays = 0,
  });

  factory OpenItem.fromJson(Map<String, dynamic> json) => OpenItem(
        documentType: '${json['document_type'] ?? ''}',
        documentId: '${json['document_id'] ?? ''}',
        number: _text(json['number']),
        date: khataDay(json['date']),
        dueDate: khataDay(json['due_date']),
        total: khataDecimal(json['total']),
        allocated: khataDecimal(json['allocated']),
        remaining: khataDecimal(json['remaining']),
        ageDays: _int(json['age_days']),
        overdueDays: _int(json['overdue_days']),
      );

  /// `sale | grn | expense | opening_balance | udhaar_given | manual_payable |
  /// adjustment`.
  final String documentType;
  final String documentId;
  final String? number;
  final DateTime? date;
  final DateTime? dueDate;
  final Decimal total;
  final Decimal allocated;
  final Decimal remaining;
  final int ageDays;
  final int overdueDays;

  AgeBucket get bucket => AgeBucket.of(ageDays);
}

/// `GET /{customers|suppliers}/{id}/open-items`.
class OpenItems {
  const OpenItems({
    required this.name,
    required this.balanceOwed,
    required this.advance,
    required this.items,
    required this.buckets,
    this.phone,
    this.asOf,
    this.termsDays = 0,
    this.pendingPaid,
  });

  factory OpenItems.fromJson(Map<String, dynamic> json) => OpenItems(
        name: '${json['name'] ?? ''}',
        phone: _text(json['phone']),
        asOf: khataDay(json['as_of']),
        termsDays: _int(json['terms_days']),
        balanceOwed: khataDecimal(json['balance_owed']),
        advance: khataDecimal(json['advance_amount']),
        buckets: AgingBuckets.fromJson(json['bucket_totals']),
        items: [for (final e in _maps(json['items'])) OpenItem.fromJson(e)],
      );

  final String name;
  final String? phone;
  final DateTime? asOf;
  final int termsDays;

  /// Never negative.
  final Decimal balanceOwed;
  final Decimal advance;

  /// Oldest first.
  final List<OpenItem> items;
  final AgingBuckets buckets;

  /// Paid on this device and not yet in the bills: already taken off
  /// [balanceOwed], but not given to any bill.
  final Decimal? pendingPaid;

  /// These bills with [paid] (money waiting to sync) off the total.
  OpenItems withPayments(Decimal paid) {
    if (paid == Decimal.zero) return this;
    final balance = advance - balanceOwed + paid;
    return OpenItems(
      name: name,
      phone: phone,
      asOf: asOf,
      termsDays: termsDays,
      balanceOwed: balance < Decimal.zero ? -balance : Decimal.zero,
      advance: balance > Decimal.zero ? balance : Decimal.zero,
      items: items,
      buckets: buckets,
      pendingPaid: paid,
    );
  }
}

enum FollowupKind {
  promise,
  reminder,
  note;

  static FollowupKind parse(Object? value) =>
      values.firstWhere((k) => k.name == value, orElse: () => note);
}

/// A promise to pay, a reminder sent, or a note about a party.
class Followup {
  const Followup({
    required this.id,
    required this.partyType,
    required this.partyId,
    required this.kind,
    required this.createdAt,
    this.promiseDate,
    this.promiseAmount,
    this.channel,
    this.message,
    this.branchId,
    this.pending = false,
    this.needsAttention = false,
  });

  factory Followup.fromJson(
    Map<String, dynamic> json, {
    bool pending = false,
    bool needsAttention = false,
  }) =>
      Followup(
        id: '${json['id']}',
        partyType: PartyType.parse('${json['party_type']}'),
        partyId: '${json['party_id']}',
        kind: FollowupKind.parse(json['kind']),
        createdAt: khataMoment(json['created_at']) ??
            DateTime.fromMillisecondsSinceEpoch(0),
        promiseDate: khataDay(json['promise_date']),
        promiseAmount: _money(json['promise_amount']),
        channel: _text(json['channel']),
        message: _text(json['message_preview']),
        branchId: _text(json['branch_id']),
        pending: pending,
        needsAttention: needsAttention,
      );

  final String id;
  final PartyType partyType;
  final String partyId;
  final FollowupKind kind;
  final DateTime createdAt;
  final DateTime? promiseDate;
  final Decimal? promiseAmount;
  final String? channel;

  /// The reminder text, or the note itself.
  final String? message;
  final String? branchId;

  /// Saved on this device and not on the server yet.
  final bool pending;

  /// The server refused it; see the sync screen.
  final bool needsAttention;
}

/// How customers pay the business.
enum PaymentKind {
  bank('bank', 'Bank transfer'),
  easypaisa('easypaisa', 'Easypaisa'),
  jazzcash('jazzcash', 'JazzCash'),
  cheque('cheque', 'Cheque');

  const PaymentKind(this.apiValue, this.label);

  final String apiValue;

  /// The words used in messages and on statements (English, as the server).
  final String label;

  bool get needsAccountNumber => this != cheque;

  static PaymentKind parse(Object? value) =>
      values.firstWhere((k) => k.apiValue == value, orElse: () => bank);
}

/// One entry of the `business.payment_instructions` setting.
class PaymentInstruction {
  const PaymentInstruction({
    required this.kind,
    required this.title,
    this.accountNumber,
    this.bankName,
    this.note,
  });

  factory PaymentInstruction.fromJson(Map<String, dynamic> json) =>
      PaymentInstruction(
        kind: PaymentKind.parse(json['kind']),
        title: '${json['title'] ?? ''}'.trim(),
        accountNumber: _text(json['account_number']),
        bankName: _text(json['bank_name']),
        note: _text(json['note']),
      );

  static List<PaymentInstruction> list(Object? value) =>
      [for (final e in _maps(value)) PaymentInstruction.fromJson(e)];

  final PaymentKind kind;
  final String title;
  final String? accountNumber;
  final String? bankName;
  final String? note;

  static final _iban =
      RegExp(r'^[A-Z]{2}\d{2}[A-Z0-9]{11,30}$', caseSensitive: false);

  /// "Bank: HBL, Title: Madina Store, IBAN: PK36...", exactly as the server
  /// writes it into statements and messages.
  String get line {
    final number = accountNumber;
    final bank = bankName;
    final iban = number != null && _iban.hasMatch(number.replaceAll(' ', ''));
    final parts = switch (kind) {
      PaymentKind.bank => [
          bank == null ? kind.label : 'Bank: $bank',
          'Title: $title',
          if (number != null) '${iban ? 'IBAN' : 'Account'}: $number',
        ],
      PaymentKind.easypaisa || PaymentKind.jazzcash => [
          '${kind.label}: ${number ?? ''}',
          'Title: $title',
          if (bank != null) 'Bank: $bank',
        ],
      PaymentKind.cheque => [
          'Cheque payable to: $title',
          if (number != null) 'Account: $number',
          if (bank != null) 'Bank: $bank',
        ],
    };
    final text = parts.join(', ');
    return note == null ? text : '$text ($note)';
  }

  /// The server refuses unknown fields: only these are sent.
  Map<String, dynamic> toJson() => {
        'kind': kind.apiValue,
        'title': title,
        if (accountNumber != null) 'account_number': accountNumber,
        if (bankName != null) 'bank_name': bankName,
        if (note != null) 'note': note,
      };
}

/// A line of a statement's table.
class StatementRow {
  const StatementRow({
    required this.id,
    required this.typeLabel,
    required this.debit,
    required this.credit,
    required this.amountDue,
    this.date,
    this.documentNumber,
    this.description,
    this.paymentSource,
    this.reference,
    this.items = const [],
    this.reversed = false,
  });

  factory StatementRow.fromJson(Map<String, dynamic> json) => StatementRow(
        id: '${json['id']}',
        date: khataDay(json['date']),
        documentNumber: _text(json['document_number']),
        typeLabel: '${json['type_label'] ?? ''}',
        description: _text(json['description']),
        paymentSource: _text(json['payment_source']),
        reference: _text(json['reference']),
        debit: khataDecimal(json['debit']),
        credit: khataDecimal(json['credit']),
        amountDue: khataDecimal(json['amount_due']),
        reversed: json['reversed'] == true,
        items: [
          for (final e in _maps(json['items'])) StatementItem.fromJson(e),
        ],
      );

  final String id;
  final DateTime? date;
  final String? documentNumber;
  final String typeLabel;
  final String? description;
  final String? paymentSource;
  final String? reference;
  final Decimal debit;
  final Decimal credit;

  /// Running amount due after this line (negative: money in advance).
  final Decimal amountDue;
  final List<StatementItem> items;
  final bool reversed;
}

class StatementItem {
  const StatementItem({
    required this.name,
    required this.qty,
    required this.unitPrice,
    required this.lineTotal,
    required this.discount,
    required this.rounding,
    required this.tax,
    this.taxLabel,
    this.taxInclusive = false,
  });

  factory StatementItem.fromJson(Map<String, dynamic> json) => StatementItem(
        name: '${json['name'] ?? ''}',
        qty: '${json['qty'] ?? ''}',
        unitPrice: khataDecimal(json['unit_price']),
        lineTotal: khataDecimal(json['line_total']),
        // Absent on statements saved before the server sent them: zero.
        discount: khataDecimal(json['discount']),
        rounding: khataDecimal(json['rounding']),
        tax: khataDecimal(json['tax_amount']),
        taxLabel: _text(json['tax_label']),
        taxInclusive: json['tax_inclusive'] == true,
      );

  final String name;
  final String qty;
  final Decimal unitPrice;
  final Decimal lineTotal;
  final Decimal discount;
  final Decimal rounding;
  final Decimal tax;
  final String? taxLabel;

  /// The tax is already inside [unitPrice].
  final bool taxInclusive;
}

/// `GET /{customers|suppliers}/{id}/statement?format=json`.
class Statement {
  const Statement({
    required this.partyType,
    required this.detail,
    required this.currency,
    required this.businessName,
    required this.partyName,
    required this.periodLabel,
    required this.openingDue,
    required this.closingBalance,
    required this.closingDue,
    required this.charges,
    required this.payments,
    required this.rows,
    required this.openItems,
    required this.buckets,
    required this.advance,
    required this.paymentInstructions,
    this.generatedAt,
    this.businessAddress,
    this.businessPhone,
    this.businessNtn,
    this.logoBase64,
    this.partyPhone,
    this.partyAddress,
    this.promiseDate,
    this.promiseAmount,
    this.showPoweredBy = true,
  });

  factory Statement.fromJson(Map<String, dynamic> json) {
    final business = _map(json['business']);
    final party = _map(json['party']);
    final totals = _map(json['totals']);
    final promise = _map(json['last_promise']);
    final items = _maps(json['open_items']);
    return Statement(
      partyType: PartyType.parse('${json['party_type']}'),
      detail: '${json['detail'] ?? 'summary'}',
      currency: '${json['currency_label'] ?? 'Rs.'}',
      generatedAt: khataMoment(json['generated_at']),
      businessName: '${business['name'] ?? ''}',
      businessAddress: _text(business['address']),
      businessPhone: _text(business['phone']),
      businessNtn: _text(business['ntn']),
      logoBase64: _text(business['logo_base64']),
      partyName: '${party['name'] ?? ''}',
      partyPhone: _text(party['phone']),
      partyAddress: _text(party['address']),
      periodLabel: '${_map(json['period'])['label'] ?? ''}',
      openingDue: khataDecimal(_map(json['opening_balance'])['amount_due']),
      closingBalance: khataDecimal(_map(json['closing_balance'])['balance']),
      closingDue: khataDecimal(_map(json['closing_balance'])['amount_due']),
      charges: khataDecimal(totals['charges']),
      payments: khataDecimal(totals['payments']),
      rows: [for (final e in _maps(json['rows'])) StatementRow.fromJson(e)],
      openItems: [
        for (final e in items)
          (item: OpenItem.fromJson(e), label: '${e['label'] ?? 'Bill'}'),
      ],
      buckets: AgingBuckets.fromJson(json['aging']),
      advance: khataDecimal(json['advance_amount']),
      promiseDate: khataDay(promise['promise_date']),
      promiseAmount: _money(promise['promise_amount']),
      paymentInstructions:
          PaymentInstruction.list(json['payment_instructions']),
      showPoweredBy: json['show_powered_by'] != false,
    );
  }

  final PartyType partyType;
  final String detail;
  final String currency;
  final DateTime? generatedAt;
  final String businessName;
  final String? businessAddress;
  final String? businessPhone;
  final String? businessNtn;
  final String? logoBase64;
  final String partyName;
  final String? partyPhone;
  final String? partyAddress;
  final String periodLabel;

  /// Amounts due (positive: still to be paid; negative: held in advance).
  final Decimal openingDue;
  final Decimal closingDue;

  /// The ledger balance at the end (negative = owed).
  final Decimal closingBalance;
  final Decimal charges;
  final Decimal payments;
  final List<StatementRow> rows;
  final List<({OpenItem item, String label})> openItems;
  final AgingBuckets buckets;
  final Decimal advance;
  final DateTime? promiseDate;
  final Decimal? promiseAmount;
  final List<PaymentInstruction> paymentInstructions;
  final bool showPoweredBy;
}

/// `POST /statements/link`.
class StatementLink {
  const StatementLink({
    required this.id,
    required this.url,
    required this.message,
    this.expiresAt,
  });

  factory StatementLink.fromJson(Map<String, dynamic> json) => StatementLink(
        id: '${json['id']}',
        url: '${json['url'] ?? ''}',
        message: '${json['message'] ?? ''}',
        expiresAt: khataMoment(json['expires_at']),
      );

  final String id;
  final String url;

  /// The server's statement text, filled in, with this link.
  final String message;
  final DateTime? expiresAt;
}

/// The answer to an opening balance or a manual entry.
class LedgerEntryResult {
  const LedgerEntryResult({
    required this.id,
    required this.balance,
    this.creditLimitOverridden = false,
  });

  factory LedgerEntryResult.fromJson(Map<String, dynamic> json) =>
      LedgerEntryResult(
        id: '${json['id']}',
        balance: khataDecimal(json['balance']),
        creditLimitOverridden: json['credit_limit_overridden'] == true,
      );

  final String id;

  /// Ledger sign: negative = owed.
  final Decimal balance;
  final bool creditLimitOverridden;
}
