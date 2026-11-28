import 'package:dartz/dartz.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/features/khata/data/models/khata_models.dart';
import 'package:frantend/features/khata/domain/khata_text.dart';
import 'package:frantend/features/khata/presentation/cubit/supplier_ledger_cubit.dart';
import 'package:frantend/features/khata/presentation/utils/ledger_line.dart';
import 'package:frantend/features/khata/presentation/widgets/khata_ledger_table.dart';
import 'package:frantend/features/khata/presentation/widgets/reverse_payment_dialog.dart';
import 'package:frantend/features/suppliers/data/models/supplier_model.dart';
import 'package:frantend/features/suppliers/domain/usecases/supplier_usecases.dart';

import '../helpers/khata_fakes.dart';

class _GetSupplier extends Fake implements GetSupplierUseCase {
  @override
  Future<Either<Failure, SupplierModel>> call(String id) async => const Right(
        SupplierModel(id: 's1', businessId: 'b', name: 'Haji Traders'),
      );
}

class _GetLedger extends Fake implements GetSupplierLedgerUseCase {
  List<SupplierLedgerEntry> all = [];
  Decimal balance = Decimal.zero;
  Decimal? opening;
  Decimal? closing;
  final calls =
      <({int skip, int limit, String? branch, DateTime? from, DateTime? to})>[];

  @override
  Future<Either<Failure, SupplierLedgerPage>> call(
    String supplierId, {
    String? branchId,
    int skip = 0,
    int limit = 50,
    DateTime? dateFrom,
    DateTime? dateTo,
  }) async {
    calls.add((
      skip: skip,
      limit: limit,
      branch: branchId,
      from: dateFrom,
      to: dateTo,
    ));
    final end = (skip + limit).clamp(0, all.length);
    return Right(SupplierLedgerPage(
      items: all.sublist(skip.clamp(0, all.length), end),
      total: all.length,
      balance: balance,
      openingBalance: opening,
      closingBalance: closing,
    ));
  }
}

class _Reverse extends Fake implements ReverseSupplierPaymentUseCase {
  final bodies = <Map<String, dynamic>>[];
  final keys = <String?>[];
  final ids = <String>[];
  Either<Failure, PaymentReversalResult>? result;

  @override
  Future<Either<Failure, PaymentReversalResult>> call(
    String paymentId,
    Map<String, dynamic> body, {
    String? idempotencyKey,
  }) async {
    ids.add(paymentId);
    bodies.add(body);
    keys.add(idempotencyKey);
    return result ??
        Right(PaymentReversalResult(
          reversalId: 'rev-1',
          originalId: paymentId,
          partyId: 's1',
          amount: Decimal.parse('300'),
          reason: body['reason'] as String,
          drawerReversed: true,
          balance: Decimal.parse('-1000'),
        ));
  }
}

SupplierLedgerEntry _entry(
  String id,
  String type,
  String amount, {
  DateTime? at,
  String? source,
  String? reversedBy,
  String? reversalOf,
  String? running,
  String? shift,
}) =>
    SupplierLedgerEntry(
      id: id,
      supplierId: 's1',
      entryType: type,
      amount: Decimal.parse(amount),
      entryAt: at ?? DateTime(2026, 3, 10, 12),
      paymentSource: source,
      reversedById: reversedBy,
      reversedAt: reversedBy == null ? null : DateTime(2026, 3, 11),
      reversalOfId: reversalOf,
      runningBalance: running == null ? null : Decimal.parse(running),
      registerShiftId: shift,
    );

void main() {
  group('supplier ledger cubit', () {
    late _GetLedger ledger;
    late _Reverse reverse;
    late CountingKhataEvents events;
    late SupplierLedgerCubit cubit;

    setUp(() {
      ledger = _GetLedger();
      reverse = _Reverse();
      events = CountingKhataEvents();
      cubit = SupplierLedgerCubit(
        _GetSupplier(),
        ledger,
        reverse,
        FakeBranchResolver('branch-3'),
        events,
      );
    });
    tearDown(() => cubit.close());

    test('loads the rows, balance and the active branch', () async {
      ledger.balance = Decimal.parse('-1000');
      ledger.all = [
        _entry('e2', 'payment', '300', source: 'drawer', running: '-1000'),
        _entry('e1', 'purchase', '-1300', running: '-1300'),
      ];
      await cubit.load('s1');
      expect(cubit.state.entries, hasLength(2));
      expect(cubit.state.owed, Decimal.parse('1000'));
      expect(cubit.state.supplier?.name, 'Haji Traders');
      expect(ledger.calls.single.branch, 'branch-3');
    });

    test('an advance is shown as an advance, not as owed', () async {
      ledger.balance = Decimal.parse('250');
      await cubit.load('s1');
      expect(cubit.state.owed, Decimal.zero);
      expect(cubit.state.advance, Decimal.parse('250'));
    });

    test('the chosen dates are sent to the server; its balances are shown',
        () async {
      ledger.all = [
        for (var i = 0; i < 120; i++)
          _entry('e$i', 'purchase', '-10', running: '-${1200 - i * 10}'),
      ];
      await cubit.load('s1');
      expect(cubit.state.entries, hasLength(SupplierLedgerCubit.pageSize));
      expect(ledger.calls.single.from, isNull);

      ledger.all = [_entry('d1', 'purchase', '-10', running: '-510')];
      ledger.opening = Decimal.parse('-500');
      ledger.closing = Decimal.parse('-510');
      final from = DateTime(2026, 3, 5);
      final to = DateTime(2026, 3, 6);
      await cubit.setDates(from, to);
      expect(ledger.calls.last.from, from);
      expect(ledger.calls.last.to, to);
      expect(ledger.calls.last.skip, 0);
      expect(cubit.state.entries.single.id, 'd1');
      expect(cubit.state.openingBalance, Decimal.parse('-500'));
      expect(cubit.state.closingBalance, Decimal.parse('-510'));
      expect(cubit.state.entries.single.runningBalance, Decimal.parse('-510'));
      expect(ledger.calls, hasLength(2), reason: 'one page, not every row');

      ledger.opening = null;
      ledger.closing = null;
      await cubit.clearDates();
      expect(ledger.calls.last.from, isNull);
      expect(ledger.calls.last.to, isNull);
      expect(cubit.state.openingBalance, isNull);
    });

    test('older rows of a date range ask for the same dates', () async {
      ledger.all = [
        for (var i = 0; i < 70; i++) _entry('e$i', 'purchase', '-10'),
      ];
      await cubit.load('s1');
      final from = DateTime(2026, 3, 1);
      await cubit.setDates(from, null);
      await cubit.loadMore();
      expect(ledger.calls.last.skip, SupplierLedgerCubit.pageSize);
      expect(ledger.calls.last.from, from);
      expect(cubit.state.entries, hasLength(70));
      expect(cubit.state.hasMore, isFalse);
    });

    group('reversing a payment', () {
      test('sends the reason and the active branch, then refreshes everyone',
          () async {
        ledger.all = [_entry('p1', 'payment', '300', source: 'drawer')];
        await cubit.load('s1');
        final error = await cubit.reversePayment('p1', 'Typed twice');
        expect(error, isNull);
        expect(reverse.ids.single, 'p1');
        expect(reverse.bodies.single['reason'], 'Typed twice');
        expect(reverse.bodies.single['branch_id'], 'branch-3');
        expect(reverse.keys.single, isNotNull);
        expect(events.notified, 1);
      });

      test('a retry of the same reversal reuses the same key', () async {
        await cubit.load('s1');
        reverse.result = const Left(NetworkFailure());
        final first = await cubit.reversePayment('p1', 'Typed twice');
        expect(first, KhataText.offlineReverse);
        reverse.result = null;
        await cubit.reversePayment('p1', 'Typed twice');
        expect(reverse.keys[0], reverse.keys[1]);
      });

      test('a different reason is a new request with a new key', () async {
        await cubit.load('s1');
        reverse.result = const Left(NetworkFailure());
        await cubit.reversePayment('p1', 'Typed twice');
        await cubit.reversePayment('p1', 'Wrong supplier');
        expect(reverse.keys[0], isNot(reverse.keys[1]));
      });

      for (final c in {
        'payment_already_reversed': KhataText.alreadyReversed,
        'open_shift_required_to_reverse': KhataText.needsShiftToReverse,
        'not_a_reversible_payment': KhataText.notAPayment,
      }.entries) {
        test('${c.key} is explained in plain words', () async {
          await cubit.load('s1');
          reverse.result = Left(ConflictFailure('raw server text', c.key));
          final msg = await cubit.reversePayment('p1', 'Because');
          expect(msg, c.value);
          expect(msg, isNot(contains('_')));
        });
      }
    });
  });

  group('ledger rows', () {
    List<LedgerLine> lines() => [
          LedgerLine.fromSupplier(_entry('rev', 'reversal', '-300',
              reversalOf: 'p1', source: 'drawer', running: '-1000')),
          LedgerLine.fromSupplier(_entry('p1', 'payment', '300',
              source: 'drawer', reversedBy: 'rev', running: '-1000')),
          LedgerLine.fromSupplier(_entry('p2', 'payment', '100',
              source: 'bank', running: '-700', shift: null)),
          LedgerLine.fromSupplier(_entry('b1', 'purchase', '-1300',
              running: '-1300')),
        ];

    Widget host(List<LedgerLine> l, {void Function(LedgerLine)? onReverse}) =>
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: KhataLedgerTable(lines: l, onReverse: onReverse),
            ),
          ),
        );

    test('only a live payment can be reversed', () {
      final l = lines();
      expect(l.firstWhere((x) => x.id == 'p2').canReverse, isTrue);
      expect(l.firstWhere((x) => x.id == 'p1').canReverse, isFalse,
          reason: 'already reversed');
      expect(l.firstWhere((x) => x.id == 'rev').canReverse, isFalse,
          reason: 'is itself a reversal');
      expect(l.firstWhere((x) => x.id == 'b1').canReverse, isFalse);
    });

    testWidgets('a reversed payment is struck through and links both ways',
        (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(1600, 1400);
      addTearDown(tester.view.reset);
      await tester.pumpWidget(host(lines(), onReverse: (_) {}));

      expect(find.text(KhataText.reversedTag), findsOneWidget);
      expect(find.text(KhataText.reversalTag), findsOneWidget);
      // Both rows have a jump link to each other.
      expect(find.byKey(const ValueKey('jump_p1')), findsOneWidget);
      expect(find.byKey(const ValueKey('jump_rev')), findsOneWidget);

      final struck = tester.widgetList<Text>(find.byType(Text)).where(
            (t) => t.style?.decoration == TextDecoration.lineThrough,
          );
      expect(struck, isNotEmpty);
    });

    testWidgets('Reverse shows on live payments only and calls back',
        (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(1600, 1400);
      addTearDown(tester.view.reset);
      LedgerLine? asked;
      await tester.pumpWidget(host(lines(), onReverse: (l) => asked = l));
      expect(find.byKey(const ValueKey('reverse_p2')), findsOneWidget);
      expect(find.byKey(const ValueKey('reverse_p1')), findsNothing);
      expect(find.byKey(const ValueKey('reverse_rev')), findsNothing);
      expect(find.byKey(const ValueKey('reverse_b1')), findsNothing);
      await tester.tap(find.byKey(const ValueKey('reverse_p2')));
      expect(asked?.id, 'p2');
    });

    testWidgets('no reverse button without a handler (no permission)',
        (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(1600, 1400);
      addTearDown(tester.view.reset);
      await tester.pumpWidget(host(lines()));
      expect(find.byKey(const ValueKey('reverse_p2')), findsNothing);
    });

    testWidgets('there is never a delete action on a payment', (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(1600, 1400);
      addTearDown(tester.view.reset);
      await tester.pumpWidget(host(lines(), onReverse: (_) {}));
      expect(find.textContaining('Delete'), findsNothing);
      expect(find.byIcon(Icons.delete), findsNothing);
      expect(find.byIcon(Icons.delete_outline), findsNothing);
    });

    testWidgets('shows source, reference and shift of a payment',
        (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(1600, 1400);
      addTearDown(tester.view.reset);
      final line = LedgerLine.fromSupplier(
        SupplierLedgerEntry(
          id: 'pp',
          supplierId: 's1',
          entryType: 'payment',
          amount: Decimal.parse('50'),
          paymentSource: 'easypaisa',
          referenceNo: 'TX-9',
          registerShiftId: 'sh',
          entryAt: DateTime(2026, 3, 10),
        ),
      );
      await tester.pumpWidget(host([line]));
      expect(find.textContaining('TX-9'), findsOneWidget);
      expect(find.text('In a shift'), findsOneWidget);
    });
  });

  group('reverse dialog', () {
    Future<void> open(
      WidgetTester tester,
      Future<String?> Function(String) onSubmit,
    ) async {
      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () => ReversePaymentDialog.show(
                context,
                summary: 'Rs. 300.00 paid to Haji Traders',
                onSubmit: onSubmit,
              ),
              child: const Text('open'),
            ),
          ),
        ),
      ));
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
    }

    testWidgets('explains that the original entry stays visible',
        (tester) async {
      await open(tester, (_) async => null);
      expect(find.byKey(const ValueKey('reverse_explain')), findsOneWidget);
      expect(find.textContaining('original entry stays visible'),
          findsOneWidget);
    });

    testWidgets('a reason is required: nothing is sent without one',
        (tester) async {
      var sent = 0;
      await open(tester, (_) async {
        sent++;
        return null;
      });
      await tester.tap(find.byKey(const ValueKey('reverse_confirm')));
      await tester.pump();
      expect(find.text(KhataText.reasonRequired), findsOneWidget);
      expect(sent, 0);
      await tester.enterText(find.byKey(const ValueKey('reverse_reason')), 'a');
      await tester.tap(find.byKey(const ValueKey('reverse_confirm')));
      await tester.pump();
      expect(sent, 0, reason: 'too short to be a reason');
    });

    testWidgets('submits the trimmed reason and closes on success',
        (tester) async {
      String? got;
      await open(tester, (r) async {
        got = r;
        return null;
      });
      await tester.enterText(
        find.byKey(const ValueKey('reverse_reason')),
        '  Typed twice  ',
      );
      await tester.tap(find.byKey(const ValueKey('reverse_confirm')));
      await tester.pumpAndSettle();
      expect(got, 'Typed twice');
      expect(find.byType(ReversePaymentDialog), findsNothing);
    });

    testWidgets('a server "no" stays on screen with the reason kept',
        (tester) async {
      await open(tester, (_) async => KhataText.alreadyReversed);
      await tester.enterText(
        find.byKey(const ValueKey('reverse_reason')),
        'Typed twice',
      );
      await tester.tap(find.byKey(const ValueKey('reverse_confirm')));
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('reverse_error')), findsOneWidget);
      expect(find.text(KhataText.alreadyReversed), findsOneWidget);
      expect(find.byType(ReversePaymentDialog), findsOneWidget);
      expect(find.text('Typed twice'), findsOneWidget);
    });

    testWidgets('"Keep payment" closes without sending', (tester) async {
      var sent = 0;
      await open(tester, (_) async {
        sent++;
        return null;
      });
      await tester.tap(find.text('Keep payment'));
      await tester.pumpAndSettle();
      expect(sent, 0);
      expect(find.byType(ReversePaymentDialog), findsNothing);
    });
  });
}
