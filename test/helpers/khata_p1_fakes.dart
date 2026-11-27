// A scriptable KhataRepository, the platform adapters the khata screens use,
// and builders for the server's shapes.
import 'dart:async';
import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/connectivity/connectivity_probe.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/core/platform/file_saver_service.dart';
import 'package:frantend/core/platform/file_share_service.dart';
import 'package:frantend/core/platform/printer_service.dart';
import 'package:frantend/core/platform/url_launcher_service.dart';
import 'package:frantend/core/session/access_cubit.dart';
import 'package:frantend/features/auth/domain/entities/user.dart';
import 'package:frantend/features/khata/data/khata_remote_datasource.dart';
import 'package:frantend/features/khata/data/khata_repository.dart';
import 'package:frantend/features/khata/data/models/khata_p1_models.dart';
import 'package:frantend/features/khata/domain/khata_settings.dart';
import 'package:frantend/features/khata/domain/party_type.dart';

import 'session_fixtures.dart';

/// "Today" for every khata screen test.
final khataNow = DateTime(2026, 11, 27, 10, 42);

Decimal dec(String v) => Decimal.parse(v);

// ── builders ─────────────────────────────────────────────────────────────

AgingBuckets buckets([
  String a = '0',
  String b = '0',
  String c = '0',
  String d = '0',
]) =>
    AgingBuckets({
      AgeBucket.upTo30: dec(a),
      AgeBucket.upTo60: dec(b),
      AgeBucket.upTo90: dec(c),
      AgeBucket.over90: dec(d),
    });

HubRow hubRow(
  String id,
  String name,
  String owed, {
  int age = 10,
  String? phone = '0300-1234567',
  DateTime? remindedAt,
  DateTime? promiseDate,
  String? promiseAmount,
}) {
  final bucket = AgeBucket.of(age);
  return HubRow(
    id: id,
    name: name,
    phone: phone,
    balanceOwed: dec(owed),
    oldestAgeDays: age,
    oldestOpenDate: khataNow.subtract(Duration(days: age)),
    buckets: AgingBuckets({bucket: dec(owed)}),
    lastReminderAt: remindedAt,
    promiseDate: promiseDate,
    promiseAmount: promiseAmount == null ? null : dec(promiseAmount),
    openItemsCount: 1,
  );
}

/// Applies the server's filter, sort and paging rules to [all].
HubPage hubPageOf(
  List<HubRow> all,
  HubQuery q, {
  int skip = 0,
  int limit = 50,
}) {
  final needle = q.search.trim().toLowerCase();
  final searched = [
    for (final r in all)
      if (needle.isEmpty ||
          r.name.toLowerCase().contains(needle) ||
          (r.phone ?? '').contains(needle))
        r,
  ];
  final rows = [
    for (final r in searched)
      if (q.bucket == null || r.buckets[q.bucket!] > Decimal.zero) r,
  ]..sort(
      (a, b) => switch (q.sort) {
        HubSort.amount => b.balanceOwed.compareTo(a.balanceOwed),
        HubSort.age => b.oldestAgeDays.compareTo(a.oldestAgeDays),
        HubSort.name => a.name.compareTo(b.name),
      },
    );
  return HubPage(
    items: rows.skip(skip).take(limit).toList(),
    total: rows.length,
    partyCount: rows.length,
    balanceOwed: rows.fold(Decimal.zero, (s, r) => s + r.balanceOwed),
    openItemsCount: rows.length,
    buckets: AgingBuckets({
      for (final b in AgeBucket.values)
        b: searched.fold(Decimal.zero, (s, r) => s + r.buckets[b]),
    }),
  );
}

KhataOverview overviewOf({
  String receive = '184500',
  int customers = 14,
  String pay = '62300',
  int suppliers = 5,
}) =>
    KhataOverview(
      receivable: KhataSide(
        total: dec(receive),
        count: customers,
        buckets: buckets('90000', '54500', '28000', '12000'),
      ),
      payable: KhataSide(
        total: dec(pay),
        count: suppliers,
        buckets: buckets('40000', '22300'),
      ),
    );

OpenItem openItem(
  String id, {
  String type = 'sale',
  String? number,
  String total = '1000',
  String paid = '0',
  int age = 10,
  int overdue = 0,
}) =>
    OpenItem(
      documentType: type,
      documentId: id,
      number: number,
      date: khataNow.subtract(Duration(days: age)),
      total: dec(total),
      allocated: dec(paid),
      remaining: dec(total) - dec(paid),
      ageDays: age,
      overdueDays: overdue,
    );

OpenItems openItemsOf(
  List<OpenItem> items, {
  String name = 'Ahmed Khan',
  String advance = '0',
  int termsDays = 0,
}) =>
    OpenItems(
      name: name,
      balanceOwed: items.fold(Decimal.zero, (s, i) => s + i.remaining),
      advance: dec(advance),
      items: items,
      termsDays: termsDays,
      buckets: AgingBuckets({
        for (final b in AgeBucket.values)
          b: items
              .where((i) => i.bucket == b)
              .fold(Decimal.zero, (s, i) => s + i.remaining),
      }),
    );

/// The body of `GET .../statement?format=json`.
Map<String, dynamic> statementJson({
  String partyType = 'customer',
  String party = 'Ahmed Khan',
  String? phone = '0300-1234567',
  String detail = 'summary',
  String period = '01 Nov 2026 - 27 Nov 2026',
  String closing = '12500.00',
}) =>
    {
      'party_type': partyType,
      'detail': detail,
      'currency_label': 'Rs.',
      'generated_at': '2026-11-27T05:42:00Z',
      'business': {
        'name': 'Madina General Store',
        'address': 'Main Bazaar, Mardan',
        'phone': '0937-123456',
        'ntn': '1234567-8',
      },
      'party': {'name': party, 'phone': phone, 'address': 'Bank Road'},
      'period': {'label': period},
      'opening_balance': {'amount_due': '8000.00'},
      'closing_balance': {'balance': '-$closing', 'amount_due': closing},
      'totals': {'charges': '6500.00', 'payments': '2000.00'},
      'rows': [
        {
          'id': 'r1',
          'date': '2026-11-03',
          'document_number': 'INV-0012',
          'type_label': 'Credit sale',
          'debit': '6500.00',
          'credit': '0.00',
          'amount_due': '14500.00',
          if (detail == 'detailed')
            'items': [
              {
                'name': 'Basmati rice 5kg',
                'qty': '2',
                'unit_price': '2500.00',
                'line_total': '5000.00',
              },
              {
                'name': 'Cooking oil 1L',
                'qty': '3',
                'unit_price': '500.00',
                'line_total': '1500.00',
              },
            ],
        },
        {
          'id': 'r2',
          'date': '2026-11-20',
          'document_number': 'RCPT-0007',
          'type_label': 'Payment received',
          'payment_source': 'easypaisa',
          'debit': '0.00',
          'credit': '2000.00',
          'amount_due': closing,
        },
      ],
      'open_items': [
        {
          'document_type': 'opening_balance',
          'document_id': 'o1',
          'label': 'Opening balance',
          'date': '2026-10-13',
          'total': '8000.00',
          'allocated': '2000.00',
          'remaining': '6000.00',
          'age_days': 45,
        },
        {
          'document_type': 'sale',
          'document_id': 's1',
          'number': 'INV-0012',
          'label': 'Credit sale',
          'date': '2026-11-03',
          'total': '6500.00',
          'allocated': '0.00',
          'remaining': '6500.00',
          'age_days': 24,
        },
      ],
      'aging': {'0-30': '6500.00', '31-60': '6000.00'},
      'advance_amount': '0.00',
      'last_promise': {
        'promise_date': '2026-12-05',
        'promise_amount': '5000.00',
      },
      'payment_instructions': [
        {
          'kind': 'bank',
          'title': 'Madina General Store',
          'account_number': 'PK00MEZN0001234567',
          'bank_name': 'Meezan Bank',
        },
        {
          'kind': 'easypaisa',
          'title': 'Saleem',
          'account_number': '0345-1112223',
        },
      ],
      'show_powered_by': true,
    };

// ── adapters ─────────────────────────────────────────────────────────────

class FakeProbe extends Fake implements ConnectivityProbe {
  FakeProbe([this._current = ReachabilityStatus.online]);

  ReachabilityStatus _current;
  final _changes = StreamController<ReachabilityStatus>.broadcast();

  @override
  ReachabilityStatus get current => _current;

  @override
  Stream<ReachabilityStatus> get status => _changes.stream;

  @override
  bool get isReachable => _current != ReachabilityStatus.offline;

  void set(ReachabilityStatus value) {
    _current = value;
    _changes.add(value);
  }
}

class FakeLauncher extends Fake implements UrlLauncherService {
  FakeLauncher({this.opens = true});

  bool opens;
  final launched = <Uri>[];

  @override
  Future<bool> launch(Uri uri, {bool externalApplication = true}) async {
    launched.add(uri);
    return opens;
  }
}

class FakeFiles extends Fake implements FileSaverService {
  /// What the save dialog answers; null: cancelled.
  String? chosen = r'C:\Users\shop\Documents\statement.pdf';
  final saved = <({String name, int bytes})>[];
  final opened = <String>[];

  @override
  Future<String?> saveFileWithDialog(
    String suggestedName,
    Uint8List bytes, {
    List<String> extensions = const [],
  }) async {
    if (chosen != null) {
      saved.add((name: suggestedName, bytes: bytes.length));
    }
    return chosen;
  }

  @override
  Future<String> saveBytes(String fileName, Uint8List bytes) async {
    saved.add((name: fileName, bytes: bytes.length));
    return 'C:\\Downloads\\$fileName';
  }

  @override
  Future<void> openFolder(String filePath) async => opened.add(filePath);
}

class FakePrinter extends Fake implements PrinterService {
  bool prints = true;
  final jobs = <({String name, String? paper, bool dialog})>[];

  @override
  Future<bool> printPdf(
    Uint8List pdfBytes, {
    String jobName = 'Receipt',
    PrinterConfig? config,
    bool forceDialog = false,
  }) async {
    jobs.add((name: jobName, paper: config?.paperSize, dialog: forceDialog));
    return prints;
  }
}

/// A phone: the file goes straight to another app.
class FakePhoneShare implements FileShareService {
  final shared = <String>[];

  @override
  bool get canShareFiles => true;

  @override
  Future<SharedFile> share(
    String fileName,
    Uint8List bytes, {
    String? text,
  }) async {
    shared.add(fileName);
    return const SharedFile(shared: true);
  }
}

// ── repository ───────────────────────────────────────────────────────────

typedef Answer<T> = Either<Failure, T>;

class StatementCall {
  const StatementCall(this.id, this.from, this.to, this.detail, this.branchId);

  final String id;
  final DateTime? from;
  final DateTime? to;
  final String detail;
  final String? branchId;
}

class FollowupCall {
  const FollowupCall(
    this.type,
    this.partyId,
    this.kind, {
    this.promiseDate,
    this.promiseAmount,
    this.channel,
    this.message,
    this.branchId,
  });

  final PartyType type;
  final String partyId;
  final FollowupKind kind;
  final DateTime? promiseDate;
  final String? promiseAmount;
  final String? channel;
  final String? message;
  final String? branchId;
}

class WriteCall {
  const WriteCall(this.type, this.id, this.body, this.key);

  final PartyType type;

  /// The party (or the entry being reversed).
  final String id;
  final Map<String, dynamic> body;
  final String? key;
}

class FakeKhataRepository extends Fake implements KhataRepository {
  FakeKhataRepository({
    List<HubRow>? customers,
    List<HubRow>? suppliers,
  }) {
    rows[PartyType.customer] = customers ?? [];
    rows[PartyType.supplier] = suppliers ?? [];
  }

  @override
  bool isOnline = true;

  /// When set, every read is the copy kept at this moment.
  DateTime? offlineSince;

  final rows = <PartyType, List<HubRow>>{};
  KhataOverview figures = overviewOf();
  Failure? overviewFailure;
  Failure? hubFailure;
  final hubCalls = <({HubQuery query, int skip, int limit})>[];
  final overviewCalls = <String?>[];

  OpenItems bills = openItemsOf(const []);
  Failure? billsFailure;
  final timeline = <Followup>[];
  final followupCalls = <FollowupCall>[];
  Failure? followupFailure;

  /// Overrides the default statement (e.g. to refuse one period).
  Answer<Map<String, dynamic>> Function(StatementCall call)? statementAnswer;
  final statementCalls = <StatementCall>[];
  Failure? pdfFailure;
  int pdfCalls = 0;
  Failure? linkFailure;
  final linkCalls = <({StatementCall call, String? key})>[];

  final openingCalls = <WriteCall>[];
  final entryCalls = <WriteCall>[];
  final reverseCalls = <WriteCall>[];
  final createCalls = <WriteCall>[];

  /// Failures handed out to the next money writes, in order.
  final writeFailures = <Failure>[];
  final phoneCalls = <({String id, String phone})>[];

  KhataSettings settingsValue = const KhataSettings(
    businessName: 'Madina General Store',
    businessPhone: '0937-123456',
    countryCode: 'PK',
  );
  Failure? settingsFailure;
  Failure? saveFailure;
  final savedSettings = <Map<String, Object?>>[];

  KhataData<T> _data<T>(T value) => KhataData(
        value,
        asOf: offlineSince ?? khataNow,
        offline: offlineSince != null,
      );

  @override
  Future<Answer<KhataData<KhataOverview>>> overview({String? branchId}) async {
    overviewCalls.add(branchId);
    final failure = overviewFailure;
    return failure != null ? Left(failure) : Right(_data(figures));
  }

  @override
  Future<Answer<KhataData<HubPage>>> hub(
    HubQuery q, {
    int skip = 0,
    int limit = 50,
  }) async {
    hubCalls.add((query: q, skip: skip, limit: limit));
    final failure = hubFailure;
    if (failure != null) return Left(failure);
    return Right(
      _data(
        hubPageOf(
          rows[q.party]!,
          q,
          skip: offlineSince != null ? 0 : skip,
          limit: offlineSince != null ? 100000 : limit,
        ),
      ),
    );
  }

  @override
  Future<Answer<KhataData<OpenItems>>> openItems(
    PartyType type,
    String id, {
    String? branchId,
  }) async {
    final failure = billsFailure;
    return failure != null ? Left(failure) : Right(_data(bills));
  }

  @override
  Future<List<Followup>> followups(
    PartyType type,
    String id, {
    String? branchId,
  }) async =>
      [...timeline]..sort((a, b) => b.createdAt.compareTo(a.createdAt));

  @override
  Future<Answer<Followup>> addFollowup(
    PartyType type,
    String partyId, {
    required FollowupKind kind,
    DateTime? promiseDate,
    String? promiseAmount,
    String? channel,
    String? message,
    String? branchId,
  }) async {
    followupCalls.add(
      FollowupCall(
        type,
        partyId,
        kind,
        promiseDate: promiseDate,
        promiseAmount: promiseAmount,
        channel: channel,
        message: message,
        branchId: branchId,
      ),
    );
    final failure = followupFailure;
    if (failure != null) return Left(failure);
    final saved = Followup(
      id: 'f${followupCalls.length}',
      partyType: type,
      partyId: partyId,
      kind: kind,
      createdAt: khataNow,
      promiseDate: promiseDate,
      promiseAmount: promiseAmount == null ? null : dec(promiseAmount),
      channel: channel,
      message: message?.trim().isEmpty ?? true ? null : message!.trim(),
      branchId: branchId,
      pending: !isOnline,
    );
    timeline.add(saved);
    return Right(saved);
  }

  Answer<Map<String, dynamic>> _statementBody(StatementCall call) =>
      statementAnswer?.call(call) ??
      Right(
        statementJson(detail: call.detail),
      );

  @override
  Future<Answer<KhataData<Statement>>> statement(
    PartyType type,
    String id, {
    DateTime? from,
    DateTime? to,
    String detail = 'summary',
    String? branchId,
  }) async {
    final call = StatementCall(id, from, to, detail, branchId);
    statementCalls.add(call);
    return _statementBody(call)
        .map((body) => _data(Statement.fromJson(body)));
  }

  @override
  Future<Answer<Uint8List>> statementPdf(
    PartyType type,
    String id, {
    DateTime? from,
    DateTime? to,
    String detail = 'summary',
    String? branchId,
  }) async {
    pdfCalls++;
    final failure = pdfFailure;
    if (failure != null) return Left(failure);
    return Right(Uint8List.fromList('%PDF-1.4 sample'.codeUnits));
  }

  @override
  Future<Answer<StatementLink>> createLink(
    PartyType type,
    String id, {
    DateTime? from,
    DateTime? to,
    String detail = 'summary',
    String? branchId,
    String? idempotencyKey,
  }) async {
    linkCalls.add(
      (
        call: StatementCall(id, from, to, detail, branchId),
        key: idempotencyKey,
      ),
    );
    final failure = linkFailure;
    if (failure != null) return Left(failure);
    return Right(
      StatementLink(
        id: 'l1',
        url: 'https://shop.example/st/abc123',
        message: 'Statement',
        expiresAt: khataNow.add(const Duration(days: 30)),
      ),
    );
  }

  Answer<T> _write<T>(T value) => writeFailures.isEmpty
      ? Right(value)
      : Left(writeFailures.removeAt(0));

  @override
  Future<Answer<LedgerEntryResult>> openingBalance(
    PartyType type,
    String id,
    Map<String, dynamic> body, {
    String? idempotencyKey,
  }) async {
    openingCalls.add(WriteCall(type, id, body, idempotencyKey));
    return _write(LedgerEntryResult(id: 'e1', balance: dec('-100')));
  }

  @override
  Future<Answer<LedgerEntryResult>> manualEntry(
    PartyType type,
    String id,
    Map<String, dynamic> body, {
    String? idempotencyKey,
  }) async {
    entryCalls.add(WriteCall(type, id, body, idempotencyKey));
    return _write(LedgerEntryResult(id: 'e2', balance: dec('-100')));
  }

  @override
  Future<Answer<Unit>> reverseEntry(
    PartyType type,
    String entryId, {
    required String reason,
    String? idempotencyKey,
  }) async {
    reverseCalls.add(
      WriteCall(type, entryId, {'reason': reason}, idempotencyKey),
    );
    return _write(unit);
  }

  @override
  Future<Answer<Map<String, dynamic>>> createPartyWithOpening(
    PartyType type,
    Map<String, dynamic> body, {
    String? idempotencyKey,
  }) async {
    createCalls.add(WriteCall(type, 'new', body, idempotencyKey));
    return _write(<String, dynamic>{'id': 'new-1'});
  }

  @override
  Future<Answer<Unit>> updatePhone(
    PartyType type,
    String id,
    String phone,
  ) async {
    phoneCalls.add((id: id, phone: phone));
    return const Right(unit);
  }

  @override
  Future<KhataSettings> settings() async => settingsValue;

  @override
  Future<Answer<KhataSettings>> settingsForEdit() async {
    final failure = settingsFailure;
    return failure != null ? Left(failure) : Right(settingsValue);
  }

  @override
  Future<Answer<Unit>> saveSettings(Map<String, Object?> changes) async {
    savedSettings.add(changes);
    final failure = saveFailure;
    return failure != null ? Left(failure) : const Right(unit);
  }
}

// ── pumping ──────────────────────────────────────────────────────────────

AccessCubit accessCubitFor(User user) => AccessCubit(
      fetchCurrentUser: () async => user,
      loadCachedUser: () async => user,
    )..apply(user);

User ownerUser() => makeUser(role: 'owner');

/// A user holding exactly [keys].
User userWith(List<String> keys) => makeUser(role: 'clerk', keys: keys);

void setWindow(WidgetTester tester, Size size) {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = size;
  addTearDown(tester.view.reset);
}

/// [child] in an app, signed in as [user] (an owner by default).
Future<void> pumpKhata(
  WidgetTester tester,
  Widget child, {
  User? user,
  Size size = const Size(1280, 900),
}) async {
  setWindow(tester, size);
  final access = accessCubitFor(user ?? ownerUser());
  addTearDown(access.close);
  await tester.pumpWidget(
    BlocProvider.value(
      value: access,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(body: child),
      ),
    ),
  );
}

/// Lets loads and the 200-300 ms motion finish. (`pumpAndSettle` never ends
/// while a shimmer is on screen.)
Future<void> settle(WidgetTester tester, [int steps = 6]) async {
  for (var i = 0; i < steps; i++) {
    await tester.pump(const Duration(milliseconds: 120));
  }
}
