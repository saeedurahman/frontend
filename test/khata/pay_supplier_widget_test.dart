import 'package:dartz/dartz.dart' show Left;
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/core/permissions/permission_keys.dart';
import 'package:frantend/core/session/access_cubit.dart';
import 'package:frantend/features/auth/domain/entities/user.dart';
import 'package:frantend/features/cash_register/data/models/shift_summary_model.dart';
import 'package:frantend/features/cash_register/presentation/widgets/shift_summary_widgets.dart';
import 'package:frantend/features/khata/domain/drawer_payment_log.dart';
import 'package:frantend/features/khata/domain/khata_text.dart';
import 'package:frantend/features/khata/domain/payment_receipt_service.dart';
import 'package:frantend/features/khata/domain/payment_source.dart';
import 'package:frantend/features/khata/presentation/widgets/pay_supplier_dialog.dart';

import '../helpers/session_fixtures.dart';
import '../helpers/supplier_payment_rig.dart';

class _Receipts extends Fake implements PaymentReceiptService {
  final shared = <PaymentReceiptData>[];
  final printed = <PaymentReceiptData>[];

  @override
  Future<bool> shareOnWhatsApp(PaymentReceiptData data) async {
    shared.add(data);
    return true;
  }

  @override
  Future<bool> print(PaymentReceiptData data) async {
    printed.add(data);
    return true;
  }
}

AccessCubit _access(User u) => AccessCubit(
      fetchCurrentUser: () async => u,
      loadCachedUser: () async => u,
    )..apply(u);

User _owner() => makeUser(role: 'owner');

Future<PayRig> _open(
  WidgetTester tester, {
  String? shiftId,
  User? user,
  _Receipts? receipts,
  void Function(PayRig)? beforeInit,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(1300, 1500);
  addTearDown(tester.view.reset);
  final rig = PayRig(shiftId: shiftId);
  beforeInit?.call(rig);
  await rig.start();
  await tester.pumpWidget(
    BlocProvider.value(
      value: _access(user ?? _owner()),
      child: MaterialApp(
        home: Scaffold(
          body: BlocProvider.value(
            value: rig.cubit,
            child: PaySupplierContent(receipts: receipts ?? _Receipts()),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
  return rig;
}

void main() {
  group('Pay a supplier screen', () {
    testWidgets('shows what is owed and every money source as a card',
        (tester) async {
      await _open(tester, shiftId: 'shift-1');
      expect(find.byKey(const ValueKey('payable_now')), findsOneWidget);
      for (final s in PaymentSource.values) {
        expect(find.byKey(ValueKey('source_${s.apiValue}')), findsOneWidget,
            reason: s.label);
      }
      // The six sources the owner expects.
      expect(PaymentSource.values.map((s) => s.apiValue).toSet(),
          containsAll(['drawer', 'owner_pocket', 'bank', 'easypaisa', 'jazzcash', 'cheque']));
    });

    testWidgets('the cash drawer is preselected when a shift is open',
        (tester) async {
      final rig = await _open(tester, shiftId: 'shift-1');
      expect(rig.cubit.state.source, PaymentSource.drawer);
      expect(find.byKey(const ValueKey('needs_shift_notice')), findsNothing);
    });

    testWidgets('keypad digits fill the amount and the result is shown',
        (tester) async {
      final rig = await _open(tester, shiftId: 'shift-1');
      await tester.tap(find.byKey(const ValueKey('chip_half')));
      await tester.pump();
      expect(rig.cubit.state.amount, Decimal.parse('500'));
      await tester.tap(find.byKey(const ValueKey('chip_full')));
      await tester.pump();
      expect(rig.cubit.state.amount, Decimal.parse('1000'));
      expect(find.byKey(const ValueKey('balance_after')), findsOneWidget);
    });

    testWidgets('drawer without a shift: notice + one-tap Open shift',
        (tester) async {
      final rig = await _open(tester);
      await tester.tap(find.byKey(const ValueKey('source_drawer')));
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const ValueKey('pay_amount')), '100');
      await tester.pump();
      expect(find.byKey(const ValueKey('needs_shift_notice')), findsOneWidget);
      // Pay is disabled until a shift exists.
      expect(
        tester.widget<FilledButton>(find.byKey(const ValueKey('pay_submit'))).onPressed,
        isNull,
      );
      await tester.tap(find.byKey(const ValueKey('open_shift_button')));
      await tester.pumpAndSettle();
      expect(rig.shifts.openCalls, 1);
      expect(find.byKey(const ValueKey('needs_shift_notice')), findsNothing);
      expect(
        tester.widget<FilledButton>(find.byKey(const ValueKey('pay_submit'))).onPressed,
        isNotNull,
      );
    });

    testWidgets('a cashier without shifts.open sees the notice, no button',
        (tester) async {
      await _open(
        tester,
        user: makeUser(role: 'cashier', keys: [
          Perm.suppliersPaymentsCreate,
        ]),
      );
      await tester.tap(find.byKey(const ValueKey('source_drawer')));
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const ValueKey('pay_amount')), '100');
      await tester.pump();
      expect(find.byKey(const ValueKey('needs_shift_notice')), findsOneWidget);
      expect(find.byKey(const ValueKey('open_shift_button')), findsNothing);
    });

    testWidgets('paying more than owed shows the advance notice',
        (tester) async {
      await _open(tester, shiftId: 'shift-1');
      await tester.enterText(find.byKey(const ValueKey('pay_amount')), '1500');
      await tester.pump();
      expect(find.byKey(const ValueKey('advance_notice')), findsOneWidget);
      expect(find.textContaining('500'), findsWidgets);
    });

    testWidgets('no advance notice when it is not an overpayment',
        (tester) async {
      await _open(tester, shiftId: 'shift-1');
      await tester.enterText(find.byKey(const ValueKey('pay_amount')), '400');
      await tester.pump();
      expect(find.byKey(const ValueKey('advance_notice')), findsNothing);
    });

    testWidgets('offline: a clear notice, and the draft is kept',
        (tester) async {
      final rig = await _open(tester, shiftId: 'shift-1');
      await tester.enterText(find.byKey(const ValueKey('pay_amount')), '400');
      await tester.pump();
      rig.pay.result = const Left(NetworkFailure());
      await tester.tap(find.byKey(const ValueKey('pay_submit')));
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('offline_notice')), findsOneWidget);
      expect(find.text(KhataText.offlineBody), findsOneWidget);
      expect(rig.cubit.state.amount, Decimal.parse('400'));
      expect(find.text('400'), findsWidgets);
      // The same screen can try again when the internet is back.
      rig.pay.result = null;
      await tester.tap(find.byKey(const ValueKey('pay_submit')));
      await tester.pumpAndSettle();
      expect(rig.pay.keys[0], rig.pay.keys[1], reason: 'same Idempotency-Key');
    });

    testWidgets('success shows a receipt with Share and Print',
        (tester) async {
      final receipts = _Receipts();
      await _open(tester, shiftId: 'shift-1', receipts: receipts);
      await tester.enterText(find.byKey(const ValueKey('pay_amount')), '400');
      await tester.pump();
      await tester.tap(find.byKey(const ValueKey('pay_submit')));
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('payment_receipt')), findsOneWidget);
      expect(find.text(KhataText.paymentDone), findsOneWidget);
      await tester.tap(find.byKey(const ValueKey('receipt_share')));
      await tester.tap(find.byKey(const ValueKey('receipt_print')));
      expect(receipts.shared, hasLength(1));
      expect(receipts.printed, hasLength(1));
      expect(receipts.shared.single.partyName, 'Haji Traders');
    });

    testWidgets('without suppliers.payments.create the Pay button is off',
        (tester) async {
      await _open(
        tester,
        shiftId: 'shift-1',
        user: makeUser(role: 'cashier', keys: cashierKeys),
      );
      await tester.enterText(find.byKey(const ValueKey('pay_amount')), '400');
      await tester.pump();
      expect(
        tester.widget<FilledButton>(find.byKey(const ValueKey('pay_submit'))).onPressed,
        isNull,
      );
    });
  });

  group('shift screens: supplier payments from the drawer (item 9)', () {
    ShiftSummaryModel summary() => const ShiftSummaryModel(
          shiftId: 'shift-1',
          openingFloat: '1000',
          totalCashSales: '5000',
          totalCashOut: '700',
          expectedCash: '5300',
        );

    Widget host(DrawerPaymentLog log) => MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: ShiftSummaryBreakdown(
                summary: summary(),
                drawerPayments: log,
              ),
            ),
          ),
        );

    testWidgets('lists drawer payments of this shift with the total',
        (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(1300, 1500);
      addTearDown(tester.view.reset);
      final log = DrawerPaymentLog()
        ..add(DrawerPayment(
          id: 'a',
          shiftId: 'shift-1',
          amount: Decimal.parse('500'),
          supplierName: 'Haji Traders',
          note: 'March bill',
        ))
        ..add(DrawerPayment(
          id: 'b',
          shiftId: 'shift-1',
          amount: Decimal.parse('200'),
        ))
        ..add(DrawerPayment(
          id: 'other',
          shiftId: 'shift-2',
          amount: Decimal.parse('999'),
        ));
      await tester.pumpWidget(host(log));
      expect(find.byKey(const ValueKey('supplier-drawer-payments')),
          findsOneWidget);
      expect(find.text(KhataText.supplierPaymentsFromDrawer), findsOneWidget);
      expect(find.text('Paid to Haji Traders · March bill'), findsOneWidget);
      expect(find.text('Paid to Supplier'), findsOneWidget);
      expect(
        tester.widget<Text>(find.byKey(const ValueKey('supplier-drawer-total'))).data,
        contains('700'),
      );
      expect(find.textContaining('999'), findsNothing,
          reason: 'another shift is not listed');
    });

    testWidgets('nothing is shown when no supplier was paid from the drawer',
        (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(1300, 1500);
      addTearDown(tester.view.reset);
      await tester.pumpWidget(host(DrawerPaymentLog()));
      expect(find.byKey(const ValueKey('supplier-drawer-payments')),
          findsNothing);
      // The totals the server computed are still there.
      expect(find.text('Cash Out'), findsOneWidget);
      expect(find.text('Expected Cash in Drawer'), findsOneWidget);
    });
  });
}
