import 'package:dartz/dartz.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/core/utils/currency_formatter.dart';
import 'package:frantend/features/khata/data/models/khata_models.dart';
import 'package:frantend/features/khata/domain/khata_text.dart';
import 'package:frantend/features/khata/domain/payment_source.dart';
import 'package:frantend/features/khata/presentation/cubit/paid_now_cubit.dart';
import 'package:frantend/features/khata/presentation/widgets/paid_now_section.dart';

import '../helpers/khata_fakes.dart';

Decimal d(String v) => Decimal.parse(v);

void main() {
  late FakeShiftGuard shifts;
  late MemoryPaymentSourceStore last;
  late CountingKhataEvents events;

  PaidNowCubit make() => PaidNowCubit(shifts, last, events);

  setUp(() {
    shifts = FakeShiftGuard();
    last = MemoryPaymentSourceStore();
    events = CountingKhataEvents();
  });

  group('PaidNowCubit', () {
    test('starts as "None": everything on credit and nothing to send', () async {
      final cubit = make();
      await cubit.init();
      expect(cubit.state.chip, PaidChip.none);
      expect(cubit.inputFor(d('1000')), isNull);
      expect(cubit.state.onCredit(d('1000')), d('1000'));
      await cubit.close();
    });

    test('default source is the cash drawer while a shift is open', () async {
      shifts.shiftId = 'shift-1';
      last.value = PaymentSource.bank;
      final cubit = make();
      await cubit.init();
      expect(cubit.state.source, PaymentSource.drawer);
      expect(cubit.state.shiftId, 'shift-1');
      await cubit.close();
    });

    test('with no shift the last used source is the default', () async {
      last.value = PaymentSource.easypaisa;
      final cubit = make();
      await cubit.init();
      expect(cubit.state.source, PaymentSource.easypaisa);
      expect(cubit.state.shiftId, isNull);
      await cubit.close();
    });

    test('Full and Half follow the live bill total', () async {
      final cubit = make();
      await cubit.init();
      cubit.setChip(PaidChip.full);
      expect(cubit.state.amountFor(d('1000')), d('1000'));
      expect(cubit.state.amountFor(d('1500')), d('1500'));
      expect(cubit.state.onCredit(d('1500')), d('0'));

      cubit.setChip(PaidChip.half);
      expect(cubit.state.amountFor(d('1000')), d('500'));
      expect(cubit.state.amountFor(d('1001')), d('500.50'));
      expect(cubit.state.onCredit(d('1000')), d('500'));
      await cubit.close();
    });

    test('a typed amount is a sum too, and shows what stays on credit', () async {
      final cubit = make();
      await cubit.init();
      cubit.setAmount('300+100');
      expect(cubit.state.chip, PaidChip.custom);
      expect(cubit.state.amountFor(d('1000')), d('400'));
      expect(cubit.state.onCredit(d('1000')), d('600'));
      expect(cubit.inputFor(d('1000'))!.toJson()['amount'], '400.00');
      cubit.setAmount('');
      expect(cubit.state.chip, PaidChip.none);
      await cubit.close();
    });

    test('paying more than the bill is refused with plain words', () async {
      final cubit = make();
      await cubit.init();
      cubit.setAmount('1200');
      expect(cubit.state.problem(d('1000')), KhataText.paidMoreThanTotal);
      expect(cubit.blockingProblem(d('1000')), KhataText.paidMoreThanTotal);
      cubit.setAmount('12.345');
      expect(cubit.state.problem(d('1000')), KhataText.tooManyDecimals);
      await cubit.close();
    });

    test('drawer without a shift blocks until a shift is opened', () async {
      final cubit = make();
      await cubit.init();
      cubit.setChip(PaidChip.full);
      cubit.setSource(PaymentSource.drawer);
      await pumpEventQueue();
      expect(cubit.state.needsShift(d('500')), isTrue);
      expect(cubit.blockingProblem(d('500')), KhataText.needsShiftBody);

      expect(await cubit.openShift(), isTrue);
      expect(shifts.openCalls, 1);
      expect(cubit.state.shiftId, 'opened-shift');
      expect(cubit.blockingProblem(d('500')), isNull);
      await cubit.close();
    });

    test('a non-drawer source never needs a shift', () async {
      final cubit = make();
      await cubit.init();
      cubit.setChip(PaidChip.full);
      cubit.setSource(PaymentSource.bank);
      expect(cubit.state.needsShift(d('500')), isFalse);
      expect(cubit.blockingProblem(d('500')), isNull);
      await cubit.close();
    });

    test('no payment means no shift is needed', () async {
      final cubit = make();
      await cubit.init();
      cubit.setSource(PaymentSource.drawer);
      expect(cubit.state.needsShift(d('500')), isFalse);
      await cubit.close();
    });

    test('a failed "open shift" shows the reason', () async {
      shifts.openResult = const Left(ServerFailure('Not allowed'));
      final cubit = make();
      await cubit.init();
      expect(await cubit.openShift(), isFalse);
      expect(cubit.state.error, 'Not allowed');
      expect(cubit.state.openingShift, isFalse);
      await cubit.close();
    });

    test('the request carries reference and note only when typed', () async {
      final cubit = make();
      await cubit.init();
      cubit.setChip(PaidChip.full);
      cubit.setSource(PaymentSource.bank);
      var json = cubit.inputFor(d('400'))!.toJson();
      expect(json, {'amount': '400.00', 'payment_source': 'bank'});

      cubit.setReference(' TRX-9 ');
      cubit.setNote('door');
      json = cubit.inputFor(d('400'))!.toJson();
      expect(json['reference'], 'TRX-9');
      expect(json['note'], 'door');
      await cubit.close();
    });

    test('server codes become plain words under the section', () async {
      final cubit = make();
      await cubit.init();
      cubit.setChip(PaidChip.full);
      cubit.setSource(PaymentSource.drawer);
      shifts.shiftId = 'shift-1';
      await cubit.refreshShift();
      expect(cubit.state.shiftId, 'shift-1');

      cubit.explain('no_open_shift', 'raw');
      expect(cubit.state.error, KhataText.needsShiftBody);
      expect(cubit.state.shiftId, isNull);

      cubit.explain('payment_exceeds_receipt_total', 'raw');
      expect(cubit.state.error, KhataText.paidMoreThanTotal);
      cubit.explain('something_else', 'Plain fallback');
      expect(cubit.state.error, 'Plain fallback');
      await cubit.close();
    });

    test('after a paid save: source remembered, screens told, back to credit', () async {
      final cubit = make();
      await cubit.init();
      cubit.setChip(PaidChip.full);
      cubit.setSource(PaymentSource.jazzcash);
      cubit.setReference('r1');

      await cubit.saved(paid: true);
      expect(last.value, PaymentSource.jazzcash);
      expect(events.notified, 1);
      expect(cubit.state.chip, PaidChip.none);
      expect(cubit.state.reference, '');
      expect(cubit.state.source, PaymentSource.jazzcash);
      await cubit.close();
    });

    test('an all-credit save tells nobody and remembers nothing', () async {
      final cubit = make();
      await cubit.init();
      await cubit.saved(paid: false);
      expect(last.value, isNull);
      expect(events.notified, 0);
      await cubit.close();
    });
  });

  group('receivedMessage', () {
    SupplierPaymentResult pay(String amount) => SupplierPaymentResult(
          id: 'p1',
          amount: d(amount),
          paymentSource: PaymentSource.bank,
          balanceBefore: d('-1000'),
          balance: d('-600'),
        );

    test('plain "Goods received" without a payment', () {
      expect(receivedMessage(null, d('1000')), KhataText.goodsReceived);
    });

    test('shows paid and credit amounts', () {
      final text = receivedMessage(
        ReceiptPaymentResult(payment: pay('400'), totalAmount: d('1000')),
        d('999'),
      );
      expect(text, contains('400'));
      expect(text, contains('600'));
      expect(text, contains('on credit'));
    });

    test('says nothing is left when paid in full', () {
      final text = receivedMessage(
        ReceiptPaymentResult(payment: pay('1000'), totalAmount: d('1000')),
        d('1000'),
      );
      expect(text, contains('Nothing left on credit'));
    });
  });

  group('PaidNowSection', () {
    Future<PaidNowCubit> pump(WidgetTester t, {required Decimal total}) async {
      final cubit = make();
      await cubit.init();
      await t.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: BlocProvider<PaidNowCubit>.value(
                value: cubit,
                child: StatefulBuilder(
                  builder: (context, _) => PaidNowSection(total: total),
                ),
              ),
            ),
          ),
        ),
      );
      await t.pump();
      return cubit;
    }

    testWidgets('default: None, "On credit" equals the whole bill, no source cards',
        (t) async {
      t.view.physicalSize = const Size(1200, 1600);
      t.view.devicePixelRatio = 1;
      addTearDown(t.view.reset);
      final cubit = await pump(t, total: d('1000'));
      expect(find.text('Paid now'), findsOneWidget);
      expect(find.text(KhataText.onCredit(formatPKR(d('1000')))), findsOneWidget);
      expect(find.byKey(const ValueKey('source_bank')), findsNothing);
      await cubit.close();
    });

    testWidgets('Half shows source cards and the live credit amount', (t) async {
      t.view.physicalSize = const Size(1200, 1600);
      t.view.devicePixelRatio = 1;
      addTearDown(t.view.reset);
      final cubit = await pump(t, total: d('1000'));
      await t.tap(find.byKey(const ValueKey('paid_chip_half')));
      await t.pump();
      expect(find.text(KhataText.onCredit(formatPKR(d('500')))), findsOneWidget);
      expect(find.byKey(const ValueKey('source_bank')), findsOneWidget);
      expect(find.byKey(const ValueKey('source_drawer')), findsOneWidget);

      await t.tap(find.byKey(const ValueKey('source_bank')));
      await t.pump();
      expect(cubit.state.source, PaymentSource.bank);

      await t.tap(find.byKey(const ValueKey('paid_chip_full')));
      await t.pump();
      expect(find.text(KhataText.onCredit(formatPKR(d('0')))), findsOneWidget);
      await cubit.close();
    });

    testWidgets('drawer with no shift shows the one-tap Open shift notice', (t) async {
      t.view.physicalSize = const Size(1200, 1600);
      t.view.devicePixelRatio = 1;
      addTearDown(t.view.reset);
      final cubit = await pump(t, total: d('1000'));
      await t.tap(find.byKey(const ValueKey('paid_chip_full')));
      await t.pump();
      await t.tap(find.byKey(const ValueKey('source_drawer')));
      await t.pumpAndSettle();
      expect(find.byKey(const ValueKey('paid_needs_shift')), findsOneWidget);

      await t.tap(find.byKey(const ValueKey('paid_open_shift')));
      await t.pumpAndSettle();
      expect(shifts.openCalls, 1);
      expect(find.byKey(const ValueKey('paid_needs_shift')), findsNothing);
      await cubit.close();
    });

    testWidgets('typing more than the bill shows a plain problem', (t) async {
      t.view.physicalSize = const Size(1200, 1600);
      t.view.devicePixelRatio = 1;
      addTearDown(t.view.reset);
      final cubit = await pump(t, total: d('1000'));
      await t.enterText(find.byKey(const ValueKey('paid_amount_field')), '1500');
      await t.pump();
      expect(find.byKey(const ValueKey('paid_problem')), findsOneWidget);
      expect(find.text(KhataText.paidMoreThanTotal), findsOneWidget);
      await cubit.close();
    });
  });
}
