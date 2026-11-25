// Khata P0 against a REAL backend (its TEST database): the app's real cubits
// and repositories over a real Dio, one throw-away business.
//
//   LIVE_API_BASE=http://127.0.0.1:<port>/api/v1 flutter test test/live/khata_live_test.dart
//
// Story: receive goods on credit -> owner tries to pay from the drawer with no
// shift (blocked) -> opens a shift -> pays from the drawer (expected cash
// drops) -> pays from the bank (no drawer effect) -> reverses the drawer
// payment (cash returns, original row stays) -> closes the shift -> customer
// payments (cash needs a shift, branch always sent, reversal) -> the customer
// ledger export holds one customer only.
import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:decimal/decimal.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/error/error_handler.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/core/services/export_service.dart';
import 'package:frantend/features/cash_register/data/datasources/cash_register_remote_datasource.dart';
import 'package:frantend/features/cash_register/data/repositories/cash_register_repository_impl.dart';
import 'package:frantend/features/customers/data/datasources/customers_remote_datasource.dart';
import 'package:frantend/features/customers/data/repositories/customers_repository_impl.dart';
import 'package:frantend/features/customers/domain/usecases/customer_usecases.dart';
import 'package:frantend/features/customers/domain/usecases/record_customer_payment_usecase.dart';
import 'package:frantend/features/customers/presentation/cubit/customer_ledger_cubit.dart';
import 'package:frantend/features/customers/presentation/cubit/customer_ledger_state.dart';
import 'package:frantend/features/khata/domain/khata_events.dart';
import 'package:frantend/features/khata/domain/khata_text.dart';
import 'package:frantend/features/khata/domain/payment_source.dart';
import 'package:frantend/features/khata/domain/shift_guard.dart';
import 'package:frantend/features/khata/presentation/cubit/supplier_ledger_cubit.dart';
import 'package:frantend/features/khata/presentation/cubit/supplier_payment_cubit.dart';
import 'package:frantend/features/pos/data/models/payment_line_model.dart';
import 'package:frantend/features/pos/domain/usecases/pos_local_usecases.dart';
import 'package:frantend/features/products/domain/usecases/get_product_by_id_usecase.dart';
import 'package:frantend/features/purchases/data/datasources/purchases_remote_datasource.dart';
import 'package:frantend/features/purchases/data/repositories/purchases_repository_impl.dart';
import 'package:frantend/features/purchases/domain/services/purchase_order_line_enricher.dart';
import 'package:frantend/features/purchases/domain/usecases/purchase_usecases.dart';
import 'package:frantend/features/suppliers/data/datasources/suppliers_remote_datasource.dart';
import 'package:frantend/features/suppliers/data/repositories/suppliers_repository_impl.dart';
import 'package:frantend/features/suppliers/domain/usecases/supplier_usecases.dart';

import '../helpers/khata_fakes.dart';
import 'live_backend.dart';

/// The app's [ShiftGuard] logic over the real cash-register repository.
class _LiveShiftGuard extends Fake implements ShiftGuard {
  _LiveShiftGuard(this._repo, this._branch);

  final CashRegisterRepositoryImpl _repo;
  final String _branch;

  @override
  Future<String?> currentShiftId() async =>
      (await _repo.getMyActiveShift()).fold((_) => null, (s) => s?.id);

  @override
  Future<Either<Failure, String>> openNow({Decimal? openingFloat}) async {
    final registers = await _repo.getRegisters(branchId: _branch);
    final list = registers.getOrElse(() => []);
    var id = list.where((r) => r.isActive).map((r) => r.id).firstOrNull;
    if (id == null) {
      final created = await _repo.createRegister({
        'name': 'Main Counter',
        'branch_id': _branch,
      });
      id = created.fold((_) => null, (r) => r.id);
    }
    if (id == null) return const Left(ServerFailure('no register'));
    final opened = await _repo.openShift(ShiftPolicy.openBody(
      registerId: id,
      openingFloat: openingFloat ?? Decimal.zero,
    ));
    return opened.fold(Left.new, (s) => Right(s.id));
  }
}

class _NoProducts extends Fake implements GetProductByIdUseCase {}

T _ok<T>(Either<Failure, T> r, [String what = 'call']) => r.fold(
      (f) => fail('$what failed: ${f.message}'),
      (v) => v,
    );

void main() {
  if (liveSkip != false) {
    test('live khata test', () {}, skip: liveSkip);
    return;
  }

  final clock = Stopwatch();
  final timings = <String, int>{};
  Future<T> timed<T>(String label, Future<T> Function() body) async {
    final sw = Stopwatch()..start();
    final out = await body();
    timings[label] = sw.elapsedMilliseconds;
    return out;
  }

  late LiveTenant tenant;
  late String supplierId;
  late String productId;
  late SuppliersRepositoryImpl suppliersRepo;
  late CustomersRepositoryImpl customersRepo;
  late CashRegisterRepositoryImpl shiftsRepo;
  late _LiveShiftGuard shifts;
  late KhataEvents events;
  late FakeBranchResolver branch;

  SupplierPaymentCubit paymentCubit() => SupplierPaymentCubit(
        GetSupplierBalanceUseCase(suppliersRepo),
        GetSupplierUseCase(suppliersRepo),
        PaySupplierUseCase(suppliersRepo),
        shifts,
        branch,
        MemoryPaymentSourceStore(),
        events,
      );

  SupplierLedgerCubit ledgerCubit() => SupplierLedgerCubit(
        GetSupplierUseCase(suppliersRepo),
        GetSupplierLedgerUseCase(suppliersRepo),
        ReverseSupplierPaymentUseCase(suppliersRepo),
        branch,
        events,
      );

  CustomerLedgerCubit customerCubit() => CustomerLedgerCubit(
        getCustomerUseCase: GetCustomerUseCase(customersRepo),
        getCustomerBalanceUseCase: GetCustomerBalanceUseCase(customersRepo),
        getCustomerLedgerUseCase: GetCustomerLedgerUseCase(customersRepo),
        recordCustomerPaymentUseCase: RecordCustomerPaymentUseCase(customersRepo),
        reverseCustomerPaymentUseCase: ReverseCustomerPaymentUseCase(customersRepo),
        shiftGuard: shifts,
        branchResolver: branch,
        khataEvents: events,
      );

  Future<Map<String, dynamic>> shiftSummary(String shiftId) async {
    final s = _ok(await shiftsRepo.getShiftSummary(shiftId), 'shift summary');
    return {
      'expected': s.expectedCashDecimal,
      'cash_out': Decimal.parse(s.totalCashOut),
      'cash_in': Decimal.parse(s.totalCashIn),
    };
  }

  Future<Decimal> supplierBalance() async {
    final r = await tenant.get('/supplier-ledger/$supplierId/balance');
    return Decimal.parse('${r['balance']}');
  }

  setUpAll(() async {
    clock.start();
    tenant = await timed(
      'register business',
      () => LiveTenant.register(liveApiBase()!, label: 'Khata Live'),
    );
    final client = tenant.client;
    const errors = ErrorHandler();
    suppliersRepo = SuppliersRepositoryImpl(
      remoteDataSource: SuppliersRemoteDataSourceImpl(client),
      errorHandler: errors,
    );
    customersRepo = CustomersRepositoryImpl(
      remoteDataSource: CustomersRemoteDataSourceImpl(client),
      errorHandler: errors,
    );
    shiftsRepo = CashRegisterRepositoryImpl(
      remoteDataSource: CashRegisterRemoteDataSourceImpl(client),
      errorHandler: errors,
    );
    branch = FakeBranchResolver(tenant.branchId);
    shifts = _LiveShiftGuard(shiftsRepo, tenant.branchId);
    events = KhataEvents();

    supplierId = (await tenant.post('/suppliers', {
      'name': 'Haji Traders',
      'phone': '3001234567',
    }))['id'] as String;
    productId = (await tenant.post('/products', {
      'name': 'Rice ${DateTime.now().millisecondsSinceEpoch}',
      'base_unit_id': tenant.unitId,
      'product_type': 'standard',
      'tracking_type': 'none',
    }))['id'] as String;
  });

  test('supplier payments, shift cash, reversal and customer export', () async {
    // ── 1. Goods received on credit: we owe 1,000 ────────────────────────
    final purchases = PurchasesRepositoryImpl(
      remoteDataSource: PurchasesRemoteDataSourceImpl(tenant.client),
      errorHandler: const ErrorHandler(),
      lineEnricher: PurchaseOrderLineEnricher(_NoProducts()),
    );
    final receipt = _ok(
      await timed(
        'goods receipt (on credit)',
        () => CreatePurchaseReceiptUseCase(purchases)(
          CreatePurchaseReceiptParams(
            branchId: tenant.branchId,
            supplierId: supplierId,
            receivedAt: DateTime.now(),
            lines: [
              CreatePurchaseReceiptLineParams(
                productId: productId,
                qtyReceived: Decimal.fromInt(10),
                costPerUnit: Decimal.fromInt(100),
              ),
            ],
          ),
        ),
      ),
      'goods receipt',
    );
    expect(receipt.payment, isNull, reason: 'default is everything on credit');
    expect(await supplierBalance(), Decimal.parse('-1000'));

    // ── 2. Drawer with NO shift: blocked in the app, nothing is written ──
    final noShift = paymentCubit();
    await noShift.init(supplierId: supplierId);
    expect(noShift.state.owed, Decimal.parse('1000'));
    expect(noShift.state.source, PaymentSource.ownerPocket,
        reason: 'no shift: not the drawer');
    noShift.setSource(PaymentSource.drawer);
    noShift.setAmount('300');
    await Future<void>.delayed(const Duration(milliseconds: 300));
    expect(noShift.state.needsShift, isTrue);
    expect(await noShift.submit(), isFalse);
    expect(await supplierBalance(), Decimal.parse('-1000'),
        reason: 'a blocked payment must not reach the books');

    // And the server itself refuses (contract: 400 no_open_shift).
    final direct = await PaySupplierUseCase(suppliersRepo)({
      'supplier_id': supplierId,
      'amount': '300.00',
      'payment_source': 'drawer',
      'branch_id': tenant.branchId,
    });
    final directFailure = direct.fold((f) => f, (_) => null);
    expect(directFailure, isNotNull);
    // ignore: avoid_print
    print('direct drawer failure: ${directFailure.runtimeType} ${directFailure!.message}');
    // Contract mismatch: this endpoint sends plain text, no code. The app
    // still explains it in plain words.
    expect(KhataText.forCode(null, directFailure.message), KhataText.needsShiftBody);
    await noShift.close();

    // ── 3. Open a shift with 1,000 in the drawer ─────────────────────────
    final shiftId = _ok(
      await timed('open shift', () => shifts.openNow(openingFloat: Decimal.fromInt(1000))),
      'open shift',
    );
    var s = await shiftSummary(shiftId);
    expect(s['expected'], Decimal.parse('1000'));

    // ── 4. Pay 300 from the drawer through the real cubit ────────────────
    final pay = paymentCubit();
    await pay.init(supplierId: supplierId);
    expect(pay.state.source, PaymentSource.drawer,
        reason: 'a shift is open: drawer is the default');
    pay.setAmount('300');
    pay.setReference('slip-1');
    pay.setNote('rent day');
    expect(await timed('pay from drawer', pay.submit), isTrue);
    final drawerPayment = pay.state.result!;
    expect(drawerPayment.registerShiftId, shiftId);
    expect(drawerPayment.balance, Decimal.parse('-700'));
    expect(events.drawerPayments.totalForShift(shiftId), Decimal.parse('300'));

    s = await shiftSummary(shiftId);
    expect(s['cash_out'], Decimal.parse('300'));
    expect(s['expected'], Decimal.parse('700'),
        reason: 'expected cash dropped by the supplier payment');
    await pay.close();

    // ── 5. Pay 100 from the bank: no drawer effect ───────────────────────
    final bank = paymentCubit();
    await bank.init(supplierId: supplierId);
    bank.setSource(PaymentSource.bank);
    bank.setAmount('100');
    bank.setReference('TX-77');
    expect(await timed('pay from bank', bank.submit), isTrue);
    expect(bank.state.result!.registerShiftId, isNull);
    s = await shiftSummary(shiftId);
    expect(s['cash_out'], Decimal.parse('300'), reason: 'bank is not cash');
    expect(s['expected'], Decimal.parse('700'));
    expect(events.drawerPayments.totalForShift(shiftId), Decimal.parse('300'),
        reason: 'bank payments are never listed as drawer cash');
    expect(await supplierBalance(), Decimal.parse('-600'));
    await bank.close();

    // ── 6. Idempotency: the same key twice pays once ─────────────────────
    final key = 'live-key-${DateTime.now().microsecondsSinceEpoch}';
    final body = {
      'supplier_id': supplierId,
      'amount': '50.00',
      'payment_source': 'jazzcash',
      'branch_id': tenant.branchId,
    };
    final first = _ok(await PaySupplierUseCase(suppliersRepo)(body, idempotencyKey: key));
    final second = _ok(await PaySupplierUseCase(suppliersRepo)(body, idempotencyKey: key));
    expect(second.id, first.id, reason: 'a retry returns the same payment');
    expect(await supplierBalance(), Decimal.parse('-550'),
        reason: '50 was taken once, not twice');

    // ── 7. Ledger cubit: running balance, source, reference, shift ───────
    final ledger = ledgerCubit();
    await timed('load supplier ledger', () => ledger.load(supplierId));
    expect(ledger.state.balance, Decimal.parse('-550'));
    final rows = ledger.state.entries;
    final drawerRow = rows.firstWhere((e) => e.id == drawerPayment.id);
    expect(drawerRow.paymentSource, 'drawer');
    expect(drawerRow.referenceNo, 'slip-1');
    expect(drawerRow.registerShiftId, shiftId);
    expect(drawerRow.runningBalance, isNotNull);
    expect(drawerRow.canReverse, isTrue);

    // ── 8. Reverse the drawer payment ────────────────────────────────────
    expect(await ledger.reversePayment(drawerPayment.id, ''), isNotNull,
        reason: 'the server needs a reason of 3+ characters');
    expect(await timed('reverse payment', () => ledger.reversePayment(drawerPayment.id, 'Paid the wrong supplier')), isNull);
    expect(events.drawerPayments.forShift(shiftId), isEmpty);
    s = await shiftSummary(shiftId);
    expect(s['expected'], Decimal.parse('1000'),
        reason: 'the cash came back into the drawer');
    expect(await supplierBalance(), Decimal.parse('-850'));

    await ledger.refresh();
    final after = ledger.state.entries;
    final original = after.firstWhere((e) => e.id == drawerPayment.id);
    expect(original.isReversed, isTrue, reason: 'the original row stays visible');
    final reversal = after.firstWhere((e) => e.reversalOfId == drawerPayment.id);
    expect(reversal.isReversal, isTrue);
    expect(original.reversedById, reversal.id);
    expect(original.canReverse, isFalse);

    // A second reversal is a 409 with plain words.
    expect(await ledger.reversePayment(drawerPayment.id, 'Again'),
        KhataText.alreadyReversed);
    await ledger.close();

    // ── 9. Close the shift: counted cash matches ─────────────────────────
    final closed = _ok(
      await timed(
        'close shift',
        () => shiftsRepo.closeShift(shiftId, actualCash: '1000'),
      ),
      'close shift',
    );
    expect(closed.expectedCashDecimal, Decimal.parse('1000'));
    expect(closed.cashDifferenceDecimal, Decimal.zero);

    // ── 10. Customers: cash needs a shift, bank does not ─────────────────
    final aliId = (await tenant.post('/customers', {
      'name': 'Ali Raza Live',
      'phone': '3011111111',
      'credit_limit': '5000',
    }))['id'] as String;
    final saraId = (await tenant.post('/customers', {
      'name': 'Sara Noor Live',
      'phone': '3022222222',
      'credit_limit': '5000',
    }))['id'] as String;

    final ali = customerCubit();
    await ali.load(aliId, branchId: tenant.branchId);
    final cashNoShift = await ali.recordPayment(
      amount: Decimal.parse('200'),
      paymentMethod: PaymentMethods.cash,
    );
    expect(cashNoShift, isNull, reason: 'E14: cash with no shift is not recorded');
    expect((ali.state as CustomerLedgerLoaded).paymentError,
        KhataText.customerCashNeedsShiftTitle);
    expect(await tenant.getList('/customers/$aliId/ledger'), isEmpty,
        reason: 'nothing was written');

    final aliPayment = await timed(
      'customer bank payment',
      () => ali.recordPayment(
        amount: Decimal.parse('200'),
        paymentMethod: PaymentMethods.bankTransfer,
        referenceNo: 'TX-ALI',
      ),
    );
    expect(aliPayment, isNotNull);

    final sara = customerCubit();
    await sara.load(saraId, branchId: tenant.branchId);
    expect(
      await sara.recordPayment(
        amount: Decimal.parse('75'),
        paymentMethod: PaymentMethods.bankTransfer,
        referenceNo: 'TX-SARA',
      ),
      isNotNull,
    );

    // The branch always travels with a payment.
    final aliLedger = await tenant.getList('/customers/$aliId/ledger');
    final payRow = aliLedger.cast<Map>().firstWhere((e) => e['entry_type'] == 'payment');
    expect(payRow['branch_id'], tenant.branchId);
    expect(payRow['payment_source'], isNotNull);

    // Customer reversal: reason, then "already reversed" in plain words.
    expect(await ali.reversePayment(aliPayment!.ledgerEntryId, 'Typed on the wrong customer'), isNull);
    expect(await ali.reversePayment(aliPayment.ledgerEntryId, 'Again'),
        KhataText.alreadyReversed);

    // ── 11. Customer ledger export holds ONE customer ────────────────────
    Future<String> export(String customerId) async {
      final response = await tenant.dio.get<List<int>>(
        '/export/customer_ledger',
        queryParameters: ExportService.buildQuery(
          format: 'csv',
          filters: {'customer_id': customerId},
        ),
        options: Options(responseType: ResponseType.bytes),
      );
      return utf8.decode(response.data!, allowMalformed: true);
    }

    final aliCsv = await timed('export customer ledger', () => export(aliId));
    expect(aliCsv, contains('TX-ALI'));
    expect(aliCsv, isNot(contains('TX-SARA')), reason: 'only Ali is in Ali\'s file');
    expect(aliCsv, isNot(contains('Sara Noor Live')));
    final saraCsv = await export(saraId);
    expect(saraCsv, contains('TX-SARA'));
    expect(saraCsv, isNot(contains('TX-ALI')));

    await ali.close();
    await sara.close();

    // ignore: avoid_print
    print('\nLIVE KHATA TIMINGS (ms): $timings  total=${clock.elapsedMilliseconds}');
  }, timeout: const Timeout(Duration(minutes: 3)));
}
