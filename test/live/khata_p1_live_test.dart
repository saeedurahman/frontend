// Khata P1 against a REAL backend (its TEST database), wired like the app: the
// real khata repository and cubits, a device store with its outbox and the real
// sync engine, one throw-away business.
//
//   LIVE_API_BASE=http://127.0.0.1:<port>/api/v1 flutter test test/live/khata_p1_live_test.dart
//
// Story: settings are saved -> customers and a supplier start with opening
// balances -> credit sales, a payment, a second payment that is reversed, a
// hand-written udhaar that is reversed -> the hub, the pending bills and the
// statement agree with the ledger -> the statement link opens as a PDF -> a
// reminder and a promise go out through the outbox -> the kept copies show with
// no connection. Sample PDFs are written to build/test_samples/khata_p1.
import 'dart:io';
import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:decimal/decimal.dart';
import 'package:dio/dio.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/connectivity/connectivity_probe.dart';
import 'package:frantend/core/data_changes/data_change_interceptor.dart';
import 'package:frantend/core/database/app_database.dart';
import 'package:frantend/core/error/error_handler.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/core/identity/id_generator.dart';
import 'package:frantend/core/offline/local_catalog.dart';
import 'package:frantend/core/offline/offline_writer.dart';
import 'package:frantend/core/permissions/permission_keys.dart';
import 'package:frantend/core/sync/http_sync_api.dart';
import 'package:frantend/core/sync/pull_service.dart';
import 'package:frantend/core/sync/push_service.dart';
import 'package:frantend/core/sync/sync_config.dart';
import 'package:frantend/core/sync/sync_engine.dart';
import 'package:frantend/core/sync/sync_store.dart';
import 'package:frantend/features/cash_register/data/datasources/cash_register_remote_datasource.dart';
import 'package:frantend/features/cash_register/data/repositories/cash_register_repository_impl.dart';
import 'package:frantend/features/customers/data/datasources/customers_remote_datasource.dart';
import 'package:frantend/features/customers/data/repositories/customers_repository_impl.dart';
import 'package:frantend/features/customers/domain/usecases/customer_usecases.dart';
import 'package:frantend/features/customers/domain/usecases/record_customer_payment_usecase.dart';
import 'package:frantend/features/khata/data/khata_remote_datasource.dart';
import 'package:frantend/features/khata/data/khata_repository.dart';
import 'package:frantend/features/khata/data/models/khata_p1_models.dart';
import 'package:frantend/features/khata/domain/khata_settings.dart';
import 'package:frantend/features/khata/domain/manual_entry.dart';
import 'package:frantend/features/khata/domain/message_template.dart';
import 'package:frantend/features/khata/domain/party_type.dart';
import 'package:frantend/features/khata/presentation/cubit/khata_hub_cubit.dart';
import 'package:frantend/features/khata/presentation/cubit/khata_message_cubit.dart';
import 'package:frantend/features/pos/data/models/cart_item_model.dart';
import 'package:frantend/features/pos/data/models/payment_line_model.dart';
import 'package:frantend/features/pos/domain/usecases/pos_local_usecases.dart';
import 'package:frantend/features/pos/domain/utils/pos_sale_request_builder.dart';
import 'package:frantend/features/settings/data/datasources/settings_remote_datasource.dart';

import '../helpers/khata_p1_fakes.dart' show FakeLauncher;
import '../helpers/sample_output.dart';
import 'live_backend.dart';

const _errors = ErrorHandler();

/// This computer: its database, outbox and sync engine, talking to the real
/// server. The engine is never started, so nothing is sent until [sync].
class _Device {
  _Device(this.tenant, this.userId) {
    final deviceId = _ids.newId();
    // What the app's own client adds to every request.
    tenant.dio.interceptors
      ..add(InterceptorsWrapper(
        onRequest: (options, handler) {
          options.headers['X-Device-ID'] = deviceId;
          options.headers['X-App-Version'] = '1.0.0';
          handler.next(options);
        },
      ))
      ..add(DataChangeInterceptor());

    store = SyncStore(db);
    writer = OfflineWriter(
      store: store,
      ids: _ids,
      deviceId: () async => deviceId,
      actingUser: () async => ActingUser(
        id: userId,
        name: 'Live Owner',
        businessId: tenant.businessId,
        branchId: tenant.branchId,
      ),
    );
    catalog = LocalCatalog(store, businessId: () async => tenant.businessId);
    final api = HttpSyncApi(
      dio: tenant.dio,
      deviceId: () async => deviceId,
      deviceName: () async => 'Live test PC',
      appVersion: '1.0.0',
    );
    const config = SyncConfig();
    engine = SyncEngine(
      store: store,
      push: PushService(store: store, api: api, ids: _ids, config: config),
      pull: PullService(
        store: store,
        api: api,
        config: config,
        currentUserId: () async => userId,
      ),
      probe: FixedConnectivityProbe(),
      config: config,
    );
  }

  final LiveTenant tenant;
  final String userId;
  final IdGenerator _ids = UuidIdGenerator();
  final AppDatabase db = AppDatabase.forTesting(NativeDatabase.memory());
  late final SyncStore store;
  late final OfflineWriter writer;
  late final LocalCatalog catalog;
  late final SyncEngine engine;

  /// One push-then-pull; everything queued must be accepted.
  Future<void> sync() async {
    await engine.syncNow(manual: true);
    expect(engine.state.lastError, isNull, reason: 'sync failed');
    final counts = await store.counts();
    expect(counts.unfinished, 0, reason: 'something was not accepted: $counts');
  }

  Future<void> dispose() async {
    engine.dispose();
    store.dispose();
    await db.close();
  }
}

T _ok<T>(Either<Failure, T> r, [String what = 'call']) => r.fold(
      (f) => fail('$what failed: ${f.code} ${f.message}'),
      (v) => v,
    );

Failure _refused<T>(Either<Failure, T> r, [String what = 'call']) =>
    r.fold((f) => f, (_) => fail('$what should have been refused'));

Decimal _d(Object? value) => Decimal.parse('$value');

void main() {
  if (liveSkip != false) {
    test('live khata P1 test', () {}, skip: liveSkip);
    return;
  }

  test(
      'opening balances, sales, payments and reversals agree across the hub, '
      'pending bills, statement, link and reminder', () async {
    final timings = <String, int>{};
    Future<T> timed<T>(String label, Future<T> Function() body) async {
      final sw = Stopwatch()..start();
      final out = await body();
      timings[label] = sw.elapsedMilliseconds;
      return out;
    }

    final total = Stopwatch()..start();
    final tenant = await LiveTenant.register(liveApiBase()!, label: 'Khata P1');
    final me = await tenant.get('/auth/me');
    expect(
      me['permission_keys'],
      containsAll([
        Perm.khataView,
        Perm.khataStatementCreate,
        Perm.khataFollowupsCreate,
        Perm.customersLedgerManage,
        Perm.suppliersLedgerManage,
      ]),
    );
    final device =
        _Device(tenant, '${me['id'] ?? (me['user'] as Map)['id']}');
    addTearDown(device.dispose);

    var online = true;
    final remote = KhataRemoteDataSource(tenant.dio);
    final repo = KhataRepository(
      remote: remote,
      store: device.store,
      writer: device.writer,
      catalog: device.catalog,
      settingsRemote: SettingsRemoteDataSourceImpl(tenant.client),
      isReachable: () => online,
    );
    final customersRepo = CustomersRepositoryImpl(
      remoteDataSource: CustomersRemoteDataSourceImpl(tenant.client),
      errorHandler: _errors,
    );
    final branch = tenant.branchId;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    DateTime daysAgo(int n) => DateTime(today.year, today.month, today.day - n);

    // ── 1. Settings: saved by the app, read back, and pulled by sync ─────
    final instructions = [
      const PaymentInstruction(
        kind: PaymentKind.bank,
        title: 'Madina Store',
        accountNumber: 'PK36SCBL0000001123456702',
        bankName: 'Standard Chartered',
      ),
      const PaymentInstruction(
        kind: PaymentKind.easypaisa,
        title: 'Saleem',
        accountNumber: '0345-1112223',
        note: 'send a screenshot',
      ),
    ];
    const reminderTemplate =
        'Salam {party}, your balance with {business} is {amount}{oldest_bill}.'
        '\n{pending_bills}\n\nPay via\n{pay_methods}\n\nStatement: {link}';
    _ok(
      await repo.saveSettings({
        KhataSettings.paymentsKey: [for (final p in instructions) p.toJson()],
        KhataSettings.reminderTemplateKey: reminderTemplate,
        KhataSettings.showItemsKey: true,
        KhataSettings.termsKey: 15,
      }),
      'save khata settings',
    );
    var settings = _ok(await repo.settingsForEdit(), 'read settings');
    expect(settings.reminderTemplate, reminderTemplate);
    expect(settings.defaultTermsDays, 15);
    expect(
      [for (final p in settings.paymentInstructions) p.line],
      [for (final p in instructions) p.line],
    );
    final badTemplate = _refused(
      await repo.saveSettings(
        {KhataSettings.reminderTemplateKey: 'Salam {nobody}'},
      ),
      'unknown variable',
    );
    expect(badTemplate.code, 'unknown_template_variable');

    // ── 2. Parties with opening balances ─────────────────────────────────
    Map<String, dynamic> opening(
      PartyType type,
      String amount,
      int age, {
      OpeningDirection? direction,
    }) =>
        OpeningBalanceDraft(
          amountText: amount,
          direction: direction ?? OpeningDirection.defaultFor(type),
          date: daysAgo(age),
        ).toJson(branchId: branch);

    final createBody = {
      'name': 'Ahmed Khan P1',
      'phone': '0300-7654321',
      'credit_limit': '100000',
      'opening_balance': opening(PartyType.customer, '8000', 45),
    };
    final key = UuidIdGenerator().newId();
    final created = await timed(
      'create customer with opening balance',
      () async => _ok(
        await repo.createPartyWithOpening(
          PartyType.customer,
          createBody,
          idempotencyKey: key,
        ),
        'create customer',
      ),
    );
    final customerId = '${created['id']}';
    final again = _ok(
      await repo.createPartyWithOpening(
        PartyType.customer,
        createBody,
        idempotencyKey: key,
      ),
      'same create again',
    );
    expect(again['id'], customerId, reason: 'the retry made no second one');

    final twice = _refused(
      await repo.openingBalance(
        PartyType.customer,
        customerId,
        opening(PartyType.customer, '10', 1),
      ),
      'second opening balance',
    );
    expect(twice.code, 'opening_balance_exists');

    final oldId = '${_ok(await repo.createPartyWithOpening(PartyType.customer, {
          'name': 'Zahid Old',
          'phone': '0301-1111111',
          'opening_balance': opening(PartyType.customer, '150', 100),
        }), 'old customer')['id']}';

    final supplierId =
        '${_ok(await repo.createPartyWithOpening(PartyType.supplier, {
              'name': 'Haji Traders P1',
              'phone': '0300-1234567',
              'opening_balance': opening(PartyType.supplier, '2000', 70),
            }), 'supplier')['id']}';

    // ── 3. Credit sales (stock first, in an open shift) ──────────────────
    final productId = (await tenant.post('/products', {
      'name': 'Rice ${now.millisecondsSinceEpoch}',
      'base_unit_id': tenant.unitId,
      'product_type': 'standard',
      'tracking_type': 'none',
    }))['id'] as String;
    await tenant.post('/purchases/receipts', {
      'branch_id': branch,
      'supplier_id': supplierId,
      'received_at': DateTime.now().toUtc().toIso8601String(),
      'lines': [
        {'product_id': productId, 'qty_received': '10', 'cost_per_unit': '100'},
      ],
    });
    final shifts = CashRegisterRepositoryImpl(
      remoteDataSource: CashRegisterRemoteDataSourceImpl(tenant.client),
      errorHandler: _errors,
    );
    final register = _ok(
      await shifts.createRegister({'name': 'Counter', 'branch_id': branch}),
      'register',
    );
    final shift = _ok(
      await shifts.openShift(ShiftPolicy.openBody(
        registerId: register.id,
        openingFloat: _d('1000'),
      )),
      'open shift',
    );

    Future<void> creditSale(int qty, int price) async {
      final amount = Decimal.fromInt(qty * price);
      await tenant.post(
        '/sales',
        PosSaleRequestBuilder.buildBody(
          branchId: branch,
          saleId: UuidIdGenerator().saleId(),
          registerShiftId: shift.id,
          customerId: customerId,
          items: [
            CartItemModel(
              productId: productId,
              productName: 'Rice',
              unitPrice: Decimal.fromInt(price),
              qty: Decimal.fromInt(qty),
              priceManual: true,
            ),
          ],
          payments: PosSaleRequestBuilder.paymentsJson([
            PaymentLineModel(
              paymentMethod: PaymentMethods.credit,
              amount: amount,
            ),
          ]),
        ),
      );
    }

    await creditSale(2, 300);
    await creditSale(1, 500);

    // ── 4. A payment, another that is reversed, udhaar that is reversed ──
    Future<String> pay(String amount) async => _ok(
          await RecordCustomerPaymentUseCase(customersRepo)(
            customerId,
            amount: _d(amount),
            paymentSource: 'bank',
            branchId: branch,
          ),
          'payment $amount',
        ).ledgerEntryId;

    await pay('1000');
    final wrong = await pay('300');
    _ok(
      await ReverseCustomerPaymentUseCase(customersRepo)(
        wrong,
        {'reason': 'Entered twice'},
      ),
      'reverse payment',
    );

    final udhaar = _ok(
      await repo.manualEntry(PartyType.customer, customerId, {
        'kind': ManualKind.udhaarGiven.apiValue,
        'amount': '250.00',
        'note': 'Cash udhaar',
        'branch_id': branch,
      }),
      'udhaar',
    );
    expect(udhaar.balance, _d('-8350'));
    _ok(
      await repo.reverseEntry(
        PartyType.customer,
        udhaar.id,
        reason: 'Wrong customer',
      ),
      'reverse udhaar',
    );
    final reversedAgain = _refused(
      await repo.reverseEntry(
        PartyType.customer,
        udhaar.id,
        reason: 'Wrong customer',
      ),
      'second reversal',
    );
    expect(reversedAgain.code, 'entry_already_reversed');

    // The credit limit applies to udhaar, and the override passes it.
    final limitedId = (await tenant.post('/customers', {
      'name': 'Limit Lal',
      'credit_limit': '100',
    }))['id'] as String;
    final overBody = {
      'kind': ManualKind.udhaarGiven.apiValue,
      'amount': '150.00',
      'note': 'Over the limit',
      'branch_id': branch,
    };
    final over = _refused(
      await repo.manualEntry(PartyType.customer, limitedId, overBody),
      'over the limit',
    );
    expect(over.code, 'credit_limit_exceeded');
    final numbers = (over as ServerFailure).credit!;
    expect(numbers.limit, _d('100'));
    expect(numbers.balance, Decimal.zero);
    expect(numbers.wouldBe, _d('-150'));
    final forced = _ok(
      await repo.manualEntry(
        PartyType.customer,
        limitedId,
        {...overBody, 'credit_override': true},
      ),
      'override',
    );
    expect(forced.creditLimitOverridden, isTrue);
    _ok(
      await repo.reverseEntry(
        PartyType.customer,
        forced.id,
        reason: 'Only a check',
      ),
      'reverse the override',
    );

    // ── 5. The hub, summary and pending bills ────────────────────────────
    // Ahmed: 8000 + 600 + 500 - 1000 = 8100. Zahid: 150.
    final ledgerBalance = _d(
      (await tenant.get('/customers/$customerId/balance'))['balance'],
    );
    expect(ledgerBalance, _d('-8100'));

    final overview = await timed(
      'GET /khata/summary',
      () async => _ok(await repo.overview(), 'overview').value,
    );
    expect(overview.receivable.total, _d('8250'));
    expect(overview.receivable.count, 2);
    expect(overview.receivable.buckets[AgeBucket.upTo30], _d('1100'));
    expect(overview.receivable.buckets[AgeBucket.upTo60], _d('7000'));
    expect(overview.receivable.buckets[AgeBucket.over90], _d('150'));
    // Supplier: 2000 opening (70 days) + 1000 goods today.
    expect(overview.payable.total, _d('3000'));
    expect(overview.payable.count, 1);
    expect(overview.payable.buckets[AgeBucket.upTo90], _d('2000'));
    expect(overview.payable.buckets[AgeBucket.upTo30], _d('1000'));
    final branchOverview =
        _ok(await repo.overview(branchId: branch), 'branch overview').value;
    expect(branchOverview.receivable.total, _d('8250'));
    expect(branchOverview.payable.total, _d('3000'));

    final hub = KhataHubCubit(repo);
    addTearDown(hub.close);
    await timed('hub cubit first load', hub.load);
    List<String> shown() => [for (final r in hub.state.list!.rows) r.id];
    expect(hub.state.error, isNull);
    expect(shown(), [customerId, oldId], reason: 'largest first');
    expect(hub.state.list!.page.balanceOwed, _d('8250'));
    expect(hub.state.list!.rows.first.balanceOwed, _d('8100'));
    expect(hub.state.list!.rows.first.oldestAgeDays, inInclusiveRange(44, 46));
    await hub.setSort(HubSort.age);
    expect(shown(), [oldId, customerId]);
    await hub.setSort(HubSort.name);
    expect(shown(), [customerId, oldId]);
    await hub.setBucket(AgeBucket.over90);
    expect(shown(), [oldId], reason: '"90+" reaches the server intact');
    await hub.setBucket(AgeBucket.upTo60);
    expect(shown(), [customerId]);
    await hub.setBucket(null);
    await hub.setSearch('zahid');
    expect(shown(), [oldId]);
    await hub.setSearch('7654321');
    expect(shown(), [customerId], reason: 'search by phone');
    await hub.setSearch('');
    await hub.setTab(PartyType.supplier);
    expect(shown(), [supplierId]);
    expect(hub.state.list!.rows.single.balanceOwed, _d('3000'));

    final bills = await timed(
      'GET open items',
      () async => _ok(
        await repo.openItems(PartyType.customer, customerId),
        'open items',
      ).value,
    );
    expect(bills.balanceOwed, _d('8100'));
    expect(bills.advance, Decimal.zero);
    expect(bills.termsDays, 15);
    expect(
      [for (final i in bills.items) (i.documentType, i.remaining)],
      [
        ('opening_balance', _d('7000')),
        ('sale', _d('600')),
        ('sale', _d('500')),
      ],
      reason: 'the payment paid the oldest bill; reversed rows count nothing',
    );
    expect(bills.items.first.overdueDays, greaterThan(0));
    expect(bills.items.last.overdueDays, 0);
    expect(
      bills.items.fold(Decimal.zero, (sum, i) => sum + i.remaining),
      -ledgerBalance,
    );

    // ── 6. The statement agrees with the ledger ──────────────────────────
    final statement = await timed(
      'GET statement (detailed JSON)',
      () async => _ok(
        await repo.statement(
          PartyType.customer,
          customerId,
          detail: 'detailed',
        ),
        'statement',
      ).value,
    );
    expect(statement.closingBalance, ledgerBalance);
    expect(statement.closingDue, _d('8100'));
    expect(statement.charges - statement.payments, _d('8100'));
    expect(statement.paymentInstructions, hasLength(2));
    expect(
      statement.rows.where((r) => r.items.isNotEmpty),
      hasLength(2),
      reason: 'both sales carry their item lines',
    );
    expect(statement.rows.where((r) => r.reversed), hasLength(2));
    final month = _ok(
      await repo.statement(
        PartyType.customer,
        customerId,
        from: DateTime(today.year, today.month),
        to: today,
      ),
      'this month',
    ).value;
    expect(month.closingBalance, ledgerBalance);
    expect(month.openingDue + month.charges - month.payments, _d('8100'));
    final badDates = _refused(
      await repo.statement(
        PartyType.customer,
        customerId,
        from: today,
        to: daysAgo(5),
      ),
      'dates backwards',
    );
    expect(badDates.code, 'invalid_date_range');

    final samples = sampleOutputDir('khata_p1');
    Future<void> keepPdf(String name, Uint8List bytes) async {
      expect(String.fromCharCodes(bytes.take(5)), '%PDF-', reason: name);
      await File('${samples.path}/$name').writeAsBytes(bytes);
    }

    for (final detail in ['summary', 'detailed']) {
      await keepPdf(
        'statement_customer_$detail.pdf',
        await timed(
          'GET statement PDF ($detail)',
          () async => _ok(
            await repo.statementPdf(
              PartyType.customer,
              customerId,
              detail: detail,
            ),
            'pdf $detail',
          ),
        ),
      );
    }
    final supplierStatement = _ok(
      await repo.statement(PartyType.supplier, supplierId),
      'supplier statement',
    ).value;
    expect(supplierStatement.closingDue, _d('3000'));
    expect(supplierStatement.paymentInstructions, isEmpty);
    await keepPdf(
      'statement_supplier.pdf',
      _ok(
        await repo.statementPdf(PartyType.supplier, supplierId),
        'supplier pdf',
      ),
    );

    // ── 7. This device writes the same message as the server ─────────────
    settings = await repo.settings();
    for (final (template, text) in [
      ('reminder', settings.reminderTemplate),
      ('statement', settings.statementTemplate),
    ]) {
      final fromServer = (await tenant.dio.get<String>(
        '/customers/$customerId/statement',
        queryParameters: {'format': 'text', 'template': template},
        options: Options(responseType: ResponseType.plain),
      ))
          .data!;
      final plain = _ok(
        await repo.statement(PartyType.customer, customerId),
        'figures',
      ).value;
      final fromApp = MessageTemplate.render(
        text,
        MessageFacts.fromStatement(plain).values(),
      );
      expect(fromApp, fromServer.trim(), reason: '$template text');
    }

    // ── 8. The statement link opens for someone without an account ───────
    final launcher = FakeLauncher();
    final message = KhataMessageCubit(
      repository: repo,
      launcher: launcher,
      request: MessageRequest(
        partyType: PartyType.customer,
        partyId: customerId,
        name: 'Ahmed Khan P1',
        phone: '0300-7654321',
        branchId: branch,
      ),
    );
    addTearDown(message.close);
    await message.load();
    expect(message.state.stage, MessageStage.editing);
    expect(message.state.phoneNeeded, isFalse);
    expect(message.state.text, contains('Rs. 8,100.00'));
    expect(message.state.text, isNot(contains('Statement:')));
    await timed(
      'POST /statements/link',
      () => message.setIncludeLink(true),
    );
    final link = message.state.link!;
    expect(message.state.error, isNull);
    expect(message.state.text, contains(link.url));
    expect(link.message, contains(link.url));
    expect(link.expiresAt!.isAfter(DateTime.now()), isTrue);

    final public = Dio(BaseOptions(validateStatus: (_) => true));
    final page = await timed(
      'GET statement link (page)',
      () => public.get<String>(
        link.url,
        options: Options(responseType: ResponseType.plain),
      ),
    );
    expect(page.statusCode, 200);
    expect(page.data, contains('Ahmed Khan P1'));
    final linked = await timed(
      'GET statement link (PDF)',
      () => public.get<List<int>>(
        '${link.url}?format=pdf',
        options: Options(responseType: ResponseType.bytes),
      ),
    );
    expect(linked.statusCode, 200);
    expect(linked.headers.value('content-type'), contains('application/pdf'));
    await keepPdf(
      'statement_from_link.pdf',
      Uint8List.fromList(linked.data!),
    );

    // ── 9. The reminder and a promise, through the outbox ────────────────
    await message.openWhatsApp();
    expect(message.state.stage, MessageStage.confirming);
    final opened = launcher.launched.single;
    expect(opened.host, 'wa.me');
    expect(opened.path, '/923007654321');
    expect(opened.queryParameters['text'], message.state.text.trim());

    online = false;
    await message.confirmSent();
    expect(message.state.logged, isTrue);
    _ok(
      await repo.addFollowup(
        PartyType.customer,
        customerId,
        kind: FollowupKind.promise,
        promiseDate: daysAgo(-7),
        promiseAmount: '5000.00',
        branchId: branch,
      ),
      'promise',
    );
    var timeline = await repo.followups(PartyType.customer, customerId);
    expect(timeline, hasLength(2));
    expect(timeline.every((f) => f.pending), isTrue);

    online = true;
    await timed('sync: push 2 follow-ups and pull', device.sync);
    final onServer = await tenant.getList(
      '/khata/followups',
      query: {'party_type': 'customer', 'party_id': customerId},
    );
    expect(onServer, hasLength(2));
    final reminder = onServer
        .cast<Map<dynamic, dynamic>>()
        .singleWhere((f) => f['kind'] == 'reminder');
    expect(reminder['channel'], 'whatsapp');
    expect(reminder['message_preview'], contains(link.url));
    timeline = await repo.followups(PartyType.customer, customerId);
    expect(timeline, hasLength(2));
    expect(timeline.any((f) => f.pending), isFalse);

    await hub.setTab(PartyType.customer);
    await hub.setSort(HubSort.amount);
    await hub.refresh();
    final row = hub.state.list!.rows.first;
    expect(row.id, customerId);
    expect(row.lastReminderAt, isNotNull);
    expect(row.promiseDate, daysAgo(-7));
    expect(row.promiseAmount, _d('5000'));

    // ── 10. With no connection: the kept copies, with their time ─────────
    online = false;
    settings = await repo.settings();
    expect(settings.reminderTemplate, reminderTemplate);
    expect(settings.paymentInstructions, hasLength(2));
    final keptOverview = _ok(await repo.overview(), 'kept overview');
    expect(keptOverview.offline, isTrue);
    expect(keptOverview.asOf, isNotNull);
    expect(keptOverview.value.receivable.total, _d('8250'));
    final keptHub = _ok(
      await repo.hub(const HubQuery(party: PartyType.customer)),
      'kept hub',
    );
    expect(keptHub.offline, isTrue);
    expect(keptHub.value.items.map((r) => r.id), [customerId, oldId]);
    final keptStatement = _ok(
      await repo.statement(PartyType.customer, customerId),
      'kept statement',
    );
    expect(keptStatement.offline, isTrue);
    expect(keptStatement.value.closingDue, _d('8100'));
    expect(
      _refused(await repo.statementPdf(PartyType.customer, customerId)),
      isA<NetworkFailure>(),
    );

    // ignore: avoid_print
    print('khata P1 live timings (ms): $timings');
    // ignore: avoid_print
    print('khata P1 live story: ${total.elapsedMilliseconds} ms; '
        'samples in ${samples.path}');
  }, timeout: const Timeout(Duration(minutes: 4)));
}
