// The Khata follow-ups against a REAL backend (its TEST database): the app's
// own request builder, repositories, cubits and error mapping over a real Dio,
// one throw-away business.
//
//   LIVE_API_BASE=http://127.0.0.1:<port>/api/v1 flutter test test/live/khata_followups_live_test.dart
//
// Story: cash from a customer is refused with no shift -> a credit sale over
// the limit is refused -> the owner, who holds customers.credit.override, sends
// the same sale with the override -> the cash is accepted in a shift -> a drawer
// payment to a supplier shows in the shift's cash_movements and is marked
// reversed after the reversal -> the supplier account for some dates starts
// from the balance before them.
import 'package:dartz/dartz.dart';
import 'package:decimal/decimal.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/constants/api_constants.dart';
import 'package:frantend/core/error/error_handler.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/core/identity/id_generator.dart';
import 'package:frantend/core/permissions/permission_keys.dart';
import 'package:frantend/features/cash_register/data/datasources/cash_register_remote_datasource.dart';
import 'package:frantend/features/cash_register/data/models/shift_cash_movement.dart';
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
import 'package:frantend/features/pos/data/models/cart_item_model.dart';
import 'package:frantend/features/pos/data/models/payment_line_model.dart';
import 'package:frantend/features/pos/domain/errors/pos_errors.dart';
import 'package:frantend/features/pos/domain/usecases/pos_local_usecases.dart';
import 'package:frantend/features/pos/domain/utils/pos_sale_request_builder.dart';
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
  Future<Either<Failure, String>> openNow({
    Decimal? openingFloat,
    String? branchId,
  }) async {
    final created = await _repo.createRegister({
      'name': 'Main Counter',
      'branch_id': branchId ?? _branch,
    });
    return created.fold<Future<Either<Failure, String>>>(
      (f) async => Left(f),
      (register) async {
        final opened = await _repo.openShift(ShiftPolicy.openBody(
          registerId: register.id,
          openingFloat: openingFloat ?? Decimal.zero,
        ));
        return opened.fold(Left.new, (s) => Right(s.id));
      },
    );
  }
}

T _ok<T>(Either<Failure, T> r, [String what = 'call']) => r.fold(
      (f) => fail('$what failed: ${f.message}'),
      (v) => v,
    );

Decimal _d(Object? value) => Decimal.parse('$value');

void main() {
  if (liveSkip != false) {
    test('live khata follow-ups test', () {}, skip: liveSkip);
    return;
  }

  test(
      'credit override, customer cash in a shift, drawer movements and the '
      'dated supplier account', () async {
    final tenant =
        await LiveTenant.register(liveApiBase()!, label: 'Khata Next');
    const errors = ErrorHandler();
    final suppliersRepo = SuppliersRepositoryImpl(
      remoteDataSource: SuppliersRemoteDataSourceImpl(tenant.client),
      errorHandler: errors,
    );
    final customersRepo = CustomersRepositoryImpl(
      remoteDataSource: CustomersRemoteDataSourceImpl(tenant.client),
      errorHandler: errors,
    );
    final shiftsRepo = CashRegisterRepositoryImpl(
      remoteDataSource: CashRegisterRemoteDataSourceImpl(tenant.client),
      errorHandler: errors,
    );
    final branch = FakeBranchResolver(tenant.branchId);
    final shifts = _LiveShiftGuard(shiftsRepo, tenant.branchId);
    final events = KhataEvents();

    final customerId = (await tenant.post('/customers', {
      'name': 'Ali Raza Next',
      'phone': '3011111111',
      'credit_limit': '500',
    }))['id'] as String;
    final supplierId = (await tenant.post('/suppliers', {
      'name': 'Haji Traders Next',
      'phone': '3001234567',
    }))['id'] as String;
    final productId = (await tenant.post('/products', {
      'name': 'Rice ${DateTime.now().millisecondsSinceEpoch}',
      'base_unit_id': tenant.unitId,
      'product_type': 'standard',
      'tracking_type': 'none',
    }))['id'] as String;

    // ── 1. An old supplier payment (10 days ago), then goods on credit ───
    final now = DateTime.now();
    final tenDaysAgo = now.subtract(const Duration(days: 10));
    _ok(
      await PaySupplierUseCase(suppliersRepo)({
        'supplier_id': supplierId,
        'amount': '100.00',
        'payment_source': 'bank',
        'branch_id': tenant.branchId,
        'paid_at': tenDaysAgo.toUtc().toIso8601String(),
      }),
      'old bank payment',
    );
    await tenant.post('/purchases/receipts', {
      'branch_id': tenant.branchId,
      'supplier_id': supplierId,
      'received_at': now.toUtc().toIso8601String(),
      'lines': [
        {'product_id': productId, 'qty_received': '10', 'cost_per_unit': '100'},
      ],
    });

    // ── 2. Cash from a customer with no shift: refused ───────────────────
    final direct = await RecordCustomerPaymentUseCase(customersRepo)(
      customerId,
      amount: _d('200'),
      paymentSource: PaymentSource.drawer.apiValue,
      branchId: tenant.branchId,
    );
    final directFailure = direct.fold((f) => f, (_) => null);
    expect(directFailure, isNotNull, reason: 'the server needs an own shift');
    expect(directFailure!.code, KhataText.noOpenShiftCode);

    final ledger = CustomerLedgerCubit(
      getCustomerUseCase: GetCustomerUseCase(customersRepo),
      getCustomerBalanceUseCase: GetCustomerBalanceUseCase(customersRepo),
      getCustomerLedgerUseCase: GetCustomerLedgerUseCase(customersRepo),
      recordCustomerPaymentUseCase: RecordCustomerPaymentUseCase(customersRepo),
      reverseCustomerPaymentUseCase:
          ReverseCustomerPaymentUseCase(customersRepo),
      shiftGuard: shifts,
      branchResolver: branch,
      khataEvents: events,
    );
    await ledger.load(customerId, branchId: tenant.branchId);
    expect(
      await ledger.recordPayment(
        amount: _d('200'),
        source: PaymentSource.drawer,
      ),
      isNull,
    );
    expect((ledger.state as CustomerLedgerLoaded).paymentError,
        KhataText.customerCashNeedsShiftTitle);
    expect(await tenant.getList('/customers/$customerId/ledger'), isEmpty,
        reason: 'nothing was written');

    // ── 3. A credit sale over the limit is refused, with the numbers ─────
    final me = await tenant.get(ApiConstants.me);
    expect(me['permission_keys'], contains(Perm.customersCreditOverride),
        reason: 'the owner may pass a limit only because of this key');

    final saleId = UuidIdGenerator().saleId();
    String? shiftId;
    Map<String, dynamic> sale({bool creditOverride = false}) =>
        PosSaleRequestBuilder.buildBody(
          branchId: tenant.branchId,
          saleId: saleId,
          registerShiftId: shiftId,
          customerId: customerId,
          items: [
            CartItemModel(
              productId: productId,
              productName: 'Rice',
              unitPrice: Decimal.fromInt(300),
              qty: Decimal.fromInt(2),
              priceManual: true,
            ),
          ],
          payments: PosSaleRequestBuilder.paymentsJson([
            PaymentLineModel(
              paymentMethod: PaymentMethods.credit,
              amount: Decimal.fromInt(600),
            ),
          ]),
          creditOverride: creditOverride,
        );

    Future<(Failure?, Map<String, dynamic>?)> send(
      Map<String, dynamic> body,
    ) async {
      try {
        return (null, await tenant.post('/sales', body));
      } on DioException catch (e) {
        return (errors.mapExceptionToFailure(e), null);
      }
    }

    // A sale with no shift is refused with the code, and asks for one.
    final (shiftless, _) = await send(sale());
    expect(shiftless!.code, KhataText.noOpenShiftCode);
    expect(
      SaleFailureMapper.map(shiftless, hasCustomer: true),
      isA<ShiftRequiredException>(),
    );

    shiftId = _ok(
      await shifts.openNow(openingFloat: _d('1000')),
      'open shift',
    );

    final (refused, none) = await send(sale());
    expect(none, isNull);
    // ignore: avoid_print
    print('credit refusal: ${refused!.code} ${refused.message}');
    expect(refused.code, KhataText.creditLimitCode);
    final blocked = SaleFailureMapper.map(refused, hasCustomer: true)
        as CreditLimitExceededException;
    expect(blocked.numbers!.limit, _d('500'));
    expect(blocked.numbers!.balance, Decimal.zero);
    expect(blocked.numbers!.wouldBe, _d('-600'));

    // The SAME sale with credit_override: true succeeds.
    final (stillRefused, accepted) = await send(sale(creditOverride: true));
    expect(stillRefused, isNull, reason: stillRefused?.message);
    expect(accepted!['id'], isNotNull);
    expect(await tenant.getList('/sales'), hasLength(1),
        reason: 'the refused tries left no sale behind');
    final owes = await tenant.get('/customers/$customerId/balance');
    expect(_d(owes['balance']), _d('-600'));

    // ── 4. Inside the shift the cash is accepted; bank needs none ────────
    final cash = await ledger.recordPayment(
      amount: _d('200'),
      source: PaymentSource.drawer,
    );
    expect(cash, isNotNull,
        reason: (ledger.state as CustomerLedgerLoaded).paymentError);
    expect(cash!.registerShiftId, shiftId);
    final bank = await ledger.recordPayment(
      amount: _d('50'),
      source: PaymentSource.bank,
      referenceNo: 'TX-1',
    );
    expect(bank, isNotNull);
    expect(bank!.registerShiftId, isNull);
    await ledger.close();

    // ── 5. Supplier drawer payment: in cash_movements, then reversed ─────
    final paid = _ok(
      await PaySupplierUseCase(suppliersRepo)({
        'supplier_id': supplierId,
        'amount': '300.00',
        'payment_source': 'drawer',
        'branch_id': tenant.branchId,
      }),
      'drawer payment',
    );

    Future<List<ShiftCashMovement>> movements() async =>
        _ok(await shiftsRepo.getShiftSummary(shiftId!), 'shift summary')
            .cashMovements;

    var list = await movements();
    expect(list.map((m) => m.source), [
      'customer_payment',
      'supplier_payment',
    ], reason: 'oldest first, and the bank payments are not drawer cash');
    final out = list.last;
    expect(out.type, 'cash_out');
    expect(_d(out.amount), _d('300'));
    expect(out.partyName, 'Haji Traders Next');
    expect(out.ledgerEntryId, paid.id);
    expect(out.reversed, isFalse);

    final supplierLedger = SupplierLedgerCubit(
      GetSupplierUseCase(suppliersRepo),
      GetSupplierLedgerUseCase(suppliersRepo),
      ReverseSupplierPaymentUseCase(suppliersRepo),
      branch,
      events,
    );
    await supplierLedger.load(supplierId);
    expect(
      await supplierLedger.reversePayment(paid.id, 'Paid the wrong supplier'),
      isNull,
    );
    list = await movements();
    expect(list.map((m) => (m.source, m.reversed)), [
      ('customer_payment', false),
      ('supplier_payment', true),
      ('supplier_payment_reversal', false),
    ]);
    expect(
      _ok(await shiftsRepo.getShiftSummary(shiftId!)).expectedCashDecimal,
      _d('1200'),
      reason: '1000 float + 200 from the customer; the 300 came back',
    );

    // ── 6. The supplier account for some dates ───────────────────────────
    DateTime day(int daysAgo) =>
        DateTime(now.year, now.month, now.day - daysAgo);

    Future<void> showDates(DateTime from, DateTime to) async {
      await supplierLedger.setDates(from, to);
      expect(supplierLedger.state.error, isNull);
    }

    // Recent days: starts from the +100 advance paid ten days ago.
    await showDates(day(2), day(0));
    var state = supplierLedger.state;
    expect(state.openingBalance, _d('100'));
    expect(state.closingBalance, _d('-900'));
    expect(state.entries, hasLength(3),
        reason: 'goods, drawer payment, reversal; not the old payment');
    expect(state.entries.first.runningBalance, _d('-900'),
        reason: 'newest first, the server running balance');
    expect(state.entries.last.runningBalance, _d('-900'),
        reason: 'the goods: +100 - 1000');

    // Only the old days.
    await showDates(day(11), day(9));
    state = supplierLedger.state;
    expect(state.openingBalance, Decimal.zero);
    expect(state.closingBalance, _d('100'));
    expect(state.entries.single.runningBalance, _d('100'));
    await supplierLedger.close();
  }, timeout: const Timeout(Duration(minutes: 3)));
}
