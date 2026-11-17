import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:frantend/features/auth/data/models/user_model.dart';
import 'package:frantend/features/inventory/data/expiry_report.dart';
import 'package:frantend/features/inventory/presentation/pages/expiry_report_page.dart';
import 'package:frantend/features/products/data/models/product_model.dart';
import 'package:frantend/features/products/domain/repositories/products_repository.dart';
import 'package:frantend/features/products/domain/usecases/get_product_by_id_usecase.dart';
import 'package:frantend/features/purchases/data/models/purchase_order_model.dart';
import 'package:frantend/features/purchases/domain/repositories/purchases_repository.dart';
import 'package:frantend/features/purchases/domain/usecases/purchase_usecases.dart';
import 'package:frantend/features/purchases/presentation/cubit/goods_receipt_cubit.dart';
import 'package:frantend/features/purchases/presentation/cubit/goods_receipt_state.dart';
import 'package:frantend/features/receipts/data/receipt_layout_api.dart';

// ── GRN fakes ───────────────────────────────────────────────────────────

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

  @override
  Future<Either<Failure, PurchaseOrderModel>> getPurchaseOrder(String id) async => Right(order);

  @override
  Future<Either<Failure, PurchaseReceiptModel>> createPurchaseReceipt(
    Map<String, dynamic> body,
  ) async {
    sent = body;
    return Right(PurchaseReceiptModel(
      id: 'r1',
      branchId: 'branch-1',
      supplierId: 's1',
      receiptNumber: 'GRN-1',
      receivedAt: '2026-11-17',
    ));
  }

  @override
  dynamic noSuchMethod(Invocation i) => super.noSuchMethod(i);
}

class _Products implements ProductsRepository {
  _Products(this.tracked);
  final Set<String> tracked;

  @override
  Future<Either<Failure, ProductModel>> getProductById(String id) async => Right(ProductModel(
        id: id,
        businessId: 'biz',
        name: 'P $id',
        productType: 'simple',
        trackingType: 'none',
        trackExpiry: tracked.contains(id),
      ));

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
        for (final id in ['med', 'soap'])
          PurchaseLineModel(
            id: 'l-$id',
            businessId: 'biz',
            purchaseOrderId: 'po1',
            productId: id,
            orderedQty: '10',
            receivedQty: '0',
            qtyRemaining: '10',
            costPerUnit: '5',
          ),
      ],
    );

Future<(GoodsReceiptCubit, _Purchases)> _make() async {
  final purchases = _Purchases(_order());
  final cubit = GoodsReceiptCubit(
    authLocalDataSource: _Auth(),
    getPurchaseOrderUseCase: GetPurchaseOrderUseCase(purchases),
    createPurchaseReceiptUseCase: CreatePurchaseReceiptUseCase(purchases),
    getProductByIdUseCase: GetProductByIdUseCase(_Products({'med'})),
  );
  await cubit.load('po1');
  return (cubit, purchases);
}

// ── expiry report fixtures ──────────────────────────────────────────────

ExpiryReport _report({bool empty = false}) => ExpiryReport.fromJson({
      'as_of': '2026-11-17',
      'within_days': 30,
      'expired': empty
          ? []
          : [
              {
                'product': 'Panadol',
                'variation': '500 mg',
                'batch_no': 'B1',
                'expiry_date': '2026-10-01',
                'days_to_expiry': -47,
                'qty': '10',
                'cost_per_unit': '5',
                'value': '50',
              },
            ],
      'near_expiry': empty
          ? []
          : [
              {
                'product': 'Brufen',
                'batch_no': 'B9',
                'expiry_date': '2026-12-01',
                'days_to_expiry': 14,
                'qty': '4',
                'cost_per_unit': '25',
                'value': '100',
              },
            ],
      'totals': {
        'expired_qty': empty ? '0' : '10',
        'expired_value': empty ? '0' : '50',
        'near_expiry_qty': empty ? '0' : '4',
        'near_expiry_value': empty ? '0' : '100',
      },
    });

void main() {
  group('GRN batch and expiry', () {
    test('batchProblem names what is missing, only for tracked items', () {
      final line = _order().lines.first;
      GoodsReceiptLineItem item({String batch = '', DateTime? expiry, bool tracked = true}) =>
          GoodsReceiptLineItem(
            line: line,
            qtyReceived: '5',
            costPerUnit: '5',
            batchNumber: batch,
            expiryDate: expiry,
            trackExpiry: tracked,
          );

      expect(GoodsReceiptCubit.batchProblem(item(tracked: false)), isNull);
      expect(GoodsReceiptCubit.batchProblem(item()), contains('Batch number and expiry date'));
      expect(GoodsReceiptCubit.batchProblem(item(expiry: DateTime(2027))), 'Batch number is required for this item');
      expect(GoodsReceiptCubit.batchProblem(item(batch: 'B1')), 'Expiry date is required for this item');
      expect(GoodsReceiptCubit.batchProblem(item(batch: 'B1', expiry: DateTime(2027))), isNull);
      expect(GoodsReceiptCubit.batchProblem(item(batch: '  ', expiry: DateTime(2027))), isNotNull);
    });

    test('load marks only products that track expiry', () async {
      final (cubit, _) = await _make();
      final byProduct = {for (final l in cubit.state.lines) l.line.productId: l.trackExpiry};
      expect(byProduct, {'med': true, 'soap': false});
      await cubit.close();
    });

    test('a tracked item without batch/expiry blocks the receipt', () async {
      final (cubit, purchases) = await _make();
      expect(cubit.validate(), isFalse);
      expect(cubit.state.errors['line_0'], contains('Batch number and expiry date'));
      expect(cubit.state.errors.containsKey('line_1'), isFalse); // soap: not tracked
      expect(await cubit.confirmReceipt(), 'Validation failed');
      expect(purchases.sent, isNull);
      await cubit.close();
    });

    test('with batch and expiry filled in the receipt goes through with both', () async {
      final (cubit, purchases) = await _make();
      cubit.updateLine(
        0,
        cubit.state.lines[0].copyWith(batchNumber: ' B2407 ', expiryDate: DateTime(2027, 5, 31)),
      );
      expect(cubit.validate(), isTrue);
      expect(await cubit.confirmReceipt(), isNull);

      final lines = purchases.sent!['lines'] as List;
      final med = lines.cast<Map>().firstWhere((l) => l['product_id'] == 'med');
      expect(med['batch_number'], 'B2407');
      expect(med['expiry_date'], '2027-05-31');
      final soap = lines.cast<Map>().firstWhere((l) => l['product_id'] == 'soap');
      expect(soap.containsKey('batch_number'), isFalse);
      await cubit.close();
    });

    test('an untracked item may still carry a batch and expiry', () async {
      final (cubit, purchases) = await _make();
      cubit.updateLine(
        0,
        cubit.state.lines[0].copyWith(batchNumber: 'B1', expiryDate: DateTime(2027)),
      );
      cubit.updateLine(
        1,
        cubit.state.lines[1].copyWith(batchNumber: 'S9', expiryDate: DateTime(2028, 2)),
      );
      expect(await cubit.confirmReceipt(), isNull);
      final soap = (purchases.sent!['lines'] as List)
          .cast<Map>()
          .firstWhere((l) => l['product_id'] == 'soap');
      expect(soap['batch_number'], 'S9');
      await cubit.close();
    });

    test('a line that is not being received is not validated', () async {
      final (cubit, _) = await _make();
      cubit.updateLine(0, cubit.state.lines[0].copyWith(qtyReceived: '0'));
      cubit.updateLine(1, cubit.state.lines[1].copyWith(qtyReceived: '3'));
      expect(cubit.validate(), isTrue);
      await cubit.close();
    });
  });

  group('expiry report model', () {
    test('parses rows and totals', () {
      final r = _report();
      expect(r.expired.single.product, 'Panadol');
      expect(r.expired.single.expired, isTrue);
      expect(r.nearExpiry.single.daysToExpiry, 14);
      expect(r.totals.expiredValue, '50');
      expect(r.isEmpty, isFalse);
    });

    test('tolerates missing fields', () {
      final r = ExpiryReport.fromJson({});
      expect(r.isEmpty, isTrue);
      expect(r.totals.nearExpiryQty, '0');
    });
  });

  group('expiry report page', () {
    Future<List<int>> open(
      WidgetTester t,
      ExpiryReportLoader loader, {
      int days = 30,
    }) async {
      final asked = <int>[];
      t.view.physicalSize = const Size(1400, 1000);
      t.view.devicePixelRatio = 1;
      addTearDown(t.view.reset);
      await t.pumpWidget(MaterialApp(
        home: ExpiryReportPage(
          branchId: 'branch-1',
          initialDays: days,
          loader: ({required int withinDays, String? branchId}) {
            asked.add(withinDays);
            return loader(withinDays: withinDays, branchId: branchId);
          },
        ),
      ));
      await t.pumpAndSettle();
      return asked;
    }

    testWidgets('shows expired and near-expiry stock with their value', (t) async {
      await open(t, ({required withinDays, branchId}) async => _report());
      expect(find.byKey(const Key('expiry-expired')), findsOneWidget);
      expect(find.byKey(const Key('expiry-near')), findsOneWidget);
      expect(find.text('Panadol (500 mg)'), findsOneWidget);
      expect(find.text('Brufen'), findsOneWidget);
      expect(find.text('Rs 50'), findsOneWidget);
      expect(find.text('Rs 100'), findsOneWidget);
      expect(find.text('47 ago'), findsOneWidget);
      expect(find.text('14'), findsOneWidget);
    });

    testWidgets('says so when nothing is expiring', (t) async {
      await open(t, ({required withinDays, branchId}) async => _report(empty: true));
      expect(find.byKey(const Key('expiry-empty')), findsOneWidget);
      expect(find.byKey(const Key('expiry-expired')), findsNothing);
    });

    testWidgets('changing the window asks the server again', (t) async {
      final asked = await open(t, ({required withinDays, branchId}) async => _report());
      expect(asked, [30]);
      await t.tap(find.text('90 days'));
      await t.pumpAndSettle();
      expect(asked, [30, 90]);
    });

    testWidgets('offline shows a plain message and can try again', (t) async {
      var offline = true;
      await open(t, ({required withinDays, branchId}) async {
        if (offline) throw const ReceiptApiException('x', offline: true);
        return _report();
      });
      expect(find.byKey(const Key('expiry-error')), findsOneWidget);
      expect(find.textContaining('offline'), findsOneWidget);
      offline = false;
      await t.tap(find.text('Try again'));
      await t.pumpAndSettle();
      expect(find.byKey(const Key('expiry-expired')), findsOneWidget);
    });

    testWidgets('a server error shows its message', (t) async {
      await open(t, ({required withinDays, branchId}) async {
        throw const ReceiptApiException('Server is busy', status: 500);
      });
      expect(find.text('Server is busy'), findsOneWidget);
    });

    testWidgets('has an export button (allowed when no access rules are present)', (t) async {
      await open(t, ({required withinDays, branchId}) async => _report());
      expect(find.byKey(const Key('expiry-export')), findsOneWidget);
    });
  });
}
