import 'package:dartz/dartz.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:frantend/features/auth/data/models/user_model.dart';
import 'package:frantend/features/khata/data/models/khata_models.dart';
import 'package:frantend/features/khata/domain/khata_text.dart';
import 'package:frantend/features/khata/domain/payment_source.dart';
import 'package:frantend/features/khata/presentation/cubit/paid_now_cubit.dart';
import 'package:frantend/features/products/data/models/product_model.dart';
import 'package:frantend/features/products/domain/repositories/products_repository.dart';
import 'package:frantend/features/products/domain/usecases/get_product_by_id_usecase.dart';
import 'package:frantend/features/purchases/data/models/purchase_order_model.dart';
import 'package:frantend/features/purchases/domain/repositories/purchases_repository.dart';
import 'package:frantend/features/purchases/domain/usecases/purchase_usecases.dart';
import 'package:frantend/features/purchases/presentation/cubit/goods_receipt_cubit.dart';
import 'package:frantend/features/purchases/presentation/cubit/goods_receipt_state.dart';
import 'package:frantend/features/quick_add/data/shared_prefs_draft_store.dart';
import 'package:frantend/features/quick_add/domain/quick_add_flow.dart';
import 'package:frantend/features/quick_add/domain/quick_add_models.dart';
import 'package:frantend/features/quick_add/domain/quick_add_row.dart';
import 'package:frantend/features/quick_add/presentation/cubit/quick_add_cubit.dart';

import '../helpers/khata_fakes.dart';
import '../quick_add/quick_add_fakes.dart';

Decimal d(String v) => Decimal.parse(v);

// ── Goods receipt fakes ─────────────────────────────────────────────────

class _Auth implements AuthLocalDataSource {
  @override
  Future<UserModel?> getCachedUser() async =>
      const UserModel(id: 'u1', name: 'Owner', branchId: 'branch-1');

  @override
  dynamic noSuchMethod(Invocation i) => super.noSuchMethod(i);
}

class _Purchases implements PurchasesRepository {
  _Purchases(this.order);
  final PurchaseOrderModel order;
  Map<String, dynamic>? sent;
  int calls = 0;

  /// What the next receipt answers (a failure or a receipt).
  Either<Failure, PurchaseReceiptModel>? next;

  @override
  Future<Either<Failure, PurchaseOrderModel>> getPurchaseOrder(String id) async =>
      Right(order);

  @override
  Future<Either<Failure, PurchaseReceiptModel>> createPurchaseReceipt(
    Map<String, dynamic> body,
  ) async {
    calls++;
    sent = body;
    return next ??
        Right(
          PurchaseReceiptModel(
            id: 'r1',
            branchId: 'branch-1',
            supplierId: 's1',
            receiptNumber: 'GRN-1',
            receivedAt: '2026-11-17',
          ),
        );
  }

  @override
  dynamic noSuchMethod(Invocation i) => super.noSuchMethod(i);
}

class _Products implements ProductsRepository {
  @override
  Future<Either<Failure, ProductModel>> getProductById(String id) async =>
      Right(
        ProductModel(
          id: id,
          businessId: 'biz',
          name: 'P $id',
          productType: 'simple',
          trackingType: 'none',
        ),
      );

  @override
  dynamic noSuchMethod(Invocation i) => super.noSuchMethod(i);
}

PurchaseOrderModel _order() => PurchaseOrderModel(
      id: 'po1',
      businessId: 'biz',
      branchId: 'branch-1',
      supplierId: 's1',
      poNumber: 'PO-1',
      status: 'ordered',
      lines: [
        PurchaseLineModel(
          id: 'l1',
          businessId: 'biz',
          purchaseOrderId: 'po1',
          productId: 'soap',
          orderedQty: '10',
          receivedQty: '0',
          qtyRemaining: '10',
          costPerUnit: '100',
        ),
      ],
    );

Future<(GoodsReceiptCubit, _Purchases)> _grn() async {
  final purchases = _Purchases(_order());
  final cubit = GoodsReceiptCubit(
    authLocalDataSource: _Auth(),
    getPurchaseOrderUseCase: GetPurchaseOrderUseCase(purchases),
    createPurchaseReceiptUseCase: CreatePurchaseReceiptUseCase(purchases),
    getProductByIdUseCase: GetProductByIdUseCase(_Products()),
  );
  await cubit.load('po1');
  return (cubit, purchases);
}

ReceiptPaymentInput _input(String amount, PaymentSource source,
        {String? reference}) =>
    ReceiptPaymentInput(
      amount: d(amount),
      source: source,
      reference: reference,
    );

void main() {
  group('Goods receipt: Paid now', () {
    test('total is quantity x cost and follows edits live', () async {
      final (cubit, _) = await _grn();
      expect(cubit.state.total, d('1000'));
      cubit.updateLine(0, cubit.state.lines[0].copyWith(qtyReceived: '4'));
      expect(cubit.state.total, d('400'));
      cubit.updateLine(0, cubit.state.lines[0].copyWith(costPerUnit: '12.5'));
      expect(cubit.state.total, d('50'));
      cubit.updateLine(0, cubit.state.lines[0].copyWith(qtyReceived: ''));
      expect(cubit.state.total, d('0'));
      await cubit.close();
    });

    test('default sends no payment: everything on credit', () async {
      final (cubit, purchases) = await _grn();
      expect(await cubit.confirmReceipt(), isNull);
      expect(purchases.sent!.containsKey('payment'), isFalse);
      expect(cubit.lastPayment, isNull);
      await cubit.close();
    });

    test('a payment goes in the backend payment object', () async {
      final (cubit, purchases) = await _grn();
      final err = await cubit.confirmReceipt(
        payment: _input('400', PaymentSource.drawer, reference: 'cash at door'),
      );
      expect(err, isNull);
      expect(purchases.sent!['payment'], {
        'amount': '400.00',
        'payment_source': 'drawer',
        'reference': 'cash at door',
      });
      // The receipt itself is unchanged.
      expect(purchases.sent!['branch_id'], 'branch-1');
      expect((purchases.sent!['lines'] as List).single['product_id'], 'soap');
      await cubit.close();
    });

    test('the answer\'s payment and total are read for the success message',
        () async {
      final (cubit, purchases) = await _grn();
      purchases.next = Right(
        PurchaseReceiptModel.fromJson({
          'id': 'r1',
          'branch_id': 'branch-1',
          'supplier_id': 's1',
          'receipt_number': 'GRN-1',
          'received_at': '2026-11-17',
          'total_amount': '1000.00',
          'payment': {
            'id': 'pay1',
            'amount': '400.00',
            'payment_source': 'drawer',
            'register_shift_id': 'sh1',
            'balance_before': '-1000.00',
            'balance': '-600.00',
            'balance_owed': '600.00',
            'is_advance': false,
            'advance_amount': '0',
          },
        }),
      );
      expect(
        await cubit.confirmReceipt(payment: _input('400', PaymentSource.drawer)),
        isNull,
      );
      final result = cubit.lastPayment!;
      expect(result.payment.amount, d('400'));
      expect(result.payment.registerShiftId, 'sh1');
      expect(result.totalAmount, d('1000'));
      final text = receivedMessage(result, d('1000'));
      expect(text, contains('400'));
      expect(text, contains('600'));
      await cubit.close();
    });

    test('paying more than the bill never reaches the server', () async {
      final (cubit, purchases) = await _grn();
      final err =
          await cubit.confirmReceipt(payment: _input('1200', PaymentSource.bank));
      expect(err, KhataText.paidMoreThanTotal);
      expect(cubit.lastErrorCode, 'payment_exceeds_receipt_total');
      expect(purchases.calls, 0);
      expect(cubit.state.isSubmitting, isFalse);
      await cubit.close();
    });

    test('400 no_open_shift is explained in plain words', () async {
      final (cubit, purchases) = await _grn();
      purchases.next =
          const Left(ServerFailure('raw server text', 'no_open_shift'));
      final err =
          await cubit.confirmReceipt(payment: _input('400', PaymentSource.drawer));
      expect(err, KhataText.needsShiftBody);
      expect(cubit.lastErrorCode, 'no_open_shift');
      expect(cubit.lastPayment, isNull);
      expect(cubit.state.isSubmitting, isFalse);
      await cubit.close();
    });

    test('400 payment_exceeds_receipt_total from the server is plain too',
        () async {
      final (cubit, purchases) = await _grn();
      purchases.next = const Left(
        ServerFailure('raw', 'payment_exceeds_receipt_total'),
      );
      final err =
          await cubit.confirmReceipt(payment: _input('400', PaymentSource.bank));
      expect(err, KhataText.paidMoreThanTotal);
      await cubit.close();
    });

    test('an unknown error keeps the server text', () async {
      final (cubit, purchases) = await _grn();
      purchases.next = const Left(ServerFailure('Something else'));
      final err = await cubit.confirmReceipt();
      expect(err, 'Something else');
      await cubit.close();
    });
  });

  group('Quick Add purchase: Paid now', () {
    late FakeQuickAddRepository repo;
    late MemoryQuickAddDraftStore drafts;
    late QuickAddCubit cubit;
    late FakeShiftGuard shifts;
    late CountingKhataEvents events;
    late MemoryPaymentSourceStore last;
    late PaidNowCubit paid;

    setUp(() async {
      repo = FakeQuickAddRepository();
      drafts = MemoryQuickAddDraftStore();
      shifts = FakeShiftGuard(shiftId: 'shift-1');
      events = CountingKhataEvents();
      last = MemoryPaymentSourceStore();
      paid = PaidNowCubit(shifts, last, events);
      await paid.init();
      cubit = QuickAddCubit(
        repository: repo,
        draftStore: drafts,
        ids: SeqIds(),
        draftDebounce: Duration.zero,
      );
      await cubit.start();
      cubit.paidNow = paid;
      cubit.setMode(QuickAddMode.purchase);
      cubit.setSupplier('s-1', 'Ali Traders');
      // 4 x Rs 100 = Rs 400.
      await cubit.scan(barcodeN(1));
      final id = cubit.state.rows.first.id;
      cubit.setText(id, QuickAddField.name, 'Soap');
      cubit.setText(id, QuickAddField.cost, '100');
      cubit.setText(id, QuickAddField.qty, '4');
    });

    tearDown(() async {
      await cubit.close();
      await paid.close();
      await repo.dispose();
    });

    test('the live total is quantity x cost', () {
      expect(cubit.purchaseTotal, d('400'));
    });

    test('default sends no payment', () async {
      await cubit.save();
      expect(repo.requests, hasLength(1));
      expect(repo.requests.single.toJson().containsKey('payment'), isFalse);
    });

    test('Full sends the whole bill from the drawer (shift open)', () async {
      paid.setChip(PaidChip.full);
      expect(paid.state.source.apiValue, 'drawer');
      await cubit.save();
      final body = repo.requests.single.toJson();
      expect(body['payment'], {'amount': '400.00', 'payment_source': 'drawer'});
    });

    test('Half from the bank carries the reference', () async {
      paid.setChip(PaidChip.half);
      paid.setSource(PaymentSource.bank);
      paid.setReference('TRX-7');
      await cubit.save();
      expect(repo.requests.single.toJson()['payment'], {
        'amount': '200.00',
        'payment_source': 'bank',
        'reference': 'TRX-7',
      });
    });

    test('drawer without a shift stops the save before any request', () async {
      shifts.shiftId = null;
      await paid.refreshShift();
      paid.setChip(PaidChip.full);
      paid.setSource(PaymentSource.drawer);
      await cubit.save();
      expect(repo.requests, isEmpty);
      expect(cubit.state.banner, KhataText.needsShiftBody);
      expect(cubit.state.rows, hasLength(1)); // nothing lost
    });

    test('a typed amount above the bill stops the save', () async {
      paid.setAmount('500');
      await cubit.save();
      expect(repo.requests, isEmpty);
      expect(cubit.state.banner, KhataText.paidMoreThanTotal);
    });

    test('the payment is not sent in opening-stock mode', () async {
      paid.setChip(PaidChip.full);
      cubit.setMode(QuickAddMode.openingStock);
      await cubit.save();
      expect(repo.requests.single.toJson().containsKey('payment'), isFalse);
    });

    test('success: summary shows paid and credit, source remembered, screens told',
        () async {
      paid.setChip(PaidChip.half);
      paid.setSource(PaymentSource.easypaisa);
      repo.script.add(Right(
        QuickAddResponse.fromJson({
          'created': 1,
          'updated': 0,
          'failed': 0,
          'receipt_id': 'r1',
          'receipt_total': '400.00',
          'payment': {
            'id': 'pay1',
            'amount': '200.00',
            'payment_source': 'easypaisa',
            'balance_before': '-400.00',
            'balance': '-200.00',
            'balance_owed': '200.00',
          },
          'lines': [
            {
              'client_line_id': cubit.state.rows.first.id,
              'status': 'created',
              'product_id': 'p1',
            },
          ],
        }),
      ));
      await cubit.save();
      final note = cubit.state.summary!.paidNote!;
      expect(note, contains('200'));
      expect(note, contains('on credit'));
      expect(last.value, PaymentSource.easypaisa);
      expect(events.notified, 1);
      // The next list starts again on credit.
      expect(paid.state.chip, PaidChip.none);
    });

    test('400 no_open_shift: plain banner, section told, next try is a new key',
        () async {
      paid.setChip(PaidChip.full);
      repo.script.add(
        const Left(ServerFailure('raw', 'no_open_shift')),
      );
      await cubit.save();
      expect(cubit.state.banner, KhataText.needsShiftBody);
      expect(paid.state.error, KhataText.needsShiftBody);
      expect(paid.state.shiftId, isNull);

      // Shift opened, same list: a fresh attempt (the refusal wrote nothing).
      await paid.openShift();
      await cubit.save();
      expect(repo.requests, hasLength(2));
      expect(repo.keys[0], isNot(repo.keys[1]));
    });

    test('a network failure keeps the same key for the retry', () async {
      paid.setChip(PaidChip.full);
      repo.script.add(const Left(NetworkFailure()));
      await cubit.save();
      await cubit.save();
      expect(repo.requests, hasLength(2));
      expect(repo.keys[0], repo.keys[1]);
      expect(repo.requests[1].toJson()['payment'], isNotNull);
    });

    test('changing the payment between tries is a new request (new key)',
        () async {
      paid.setChip(PaidChip.full);
      repo.script.add(const Left(NetworkFailure()));
      await cubit.save();
      paid.setChip(PaidChip.half);
      await cubit.save();
      expect(repo.keys[0], isNot(repo.keys[1]));
    });
  });
}
