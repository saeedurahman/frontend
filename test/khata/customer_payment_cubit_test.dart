import 'package:dartz/dartz.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/features/customers/data/models/customer_balance_model.dart';
import 'package:frantend/features/customers/data/models/customer_ledger_entry_model.dart';
import 'package:frantend/features/customers/data/models/customer_model.dart';
import 'package:frantend/features/customers/data/models/customer_payment_response_model.dart';
import 'package:frantend/features/customers/domain/usecases/customer_usecases.dart';
import 'package:frantend/features/customers/domain/usecases/record_customer_payment_usecase.dart';
import 'package:frantend/features/customers/presentation/cubit/customer_ledger_cubit.dart';
import 'package:frantend/features/customers/presentation/cubit/customer_ledger_state.dart';
import 'package:frantend/features/khata/data/models/khata_models.dart';
import 'package:frantend/features/khata/domain/khata_text.dart';
import 'package:frantend/features/pos/data/models/payment_line_model.dart';

import '../helpers/khata_fakes.dart';

class _GetCustomer extends Fake implements GetCustomerUseCase {
  @override
  Future<Either<Failure, CustomerModel>> call(String id) async => const Right(
        CustomerModel(id: 'c1', businessId: 'b', name: 'Ali'),
      );
}

class _GetBalance extends Fake implements GetCustomerBalanceUseCase {
  final branches = <String?>[];

  @override
  Future<Either<Failure, CustomerBalanceModel>> call(
    String customerId, {
    String? branchId,
  }) async {
    branches.add(branchId);
    return Right(CustomerBalanceModel(customerId: customerId, balance: '-800'));
  }
}

class _GetLedger extends Fake implements GetCustomerLedgerUseCase {
  List<CustomerLedgerEntryModel> rows = [];
  final branches = <String?>[];

  @override
  Future<Either<Failure, List<CustomerLedgerEntryModel>>> call(
    String customerId, {
    String? branchId,
    int? skip,
    int? limit,
  }) async {
    branches.add(branchId);
    return Right(rows);
  }
}

class _Record extends Fake implements RecordCustomerPaymentUseCase {
  final calls = <({
    String method,
    String? shift,
    String? branch,
    Decimal amount,
  })>[];
  Either<Failure, CustomerPaymentResponseModel>? result;

  @override
  Future<Either<Failure, CustomerPaymentResponseModel>> call(
    String customerId, {
    required Decimal amount,
    required String paymentMethod,
    String? referenceNo,
    String? notes,
    String? registerShiftId,
    String? branchId,
  }) async {
    calls.add((
      method: paymentMethod,
      shift: registerShiftId,
      branch: branchId,
      amount: amount,
    ));
    return result ??
        Right(CustomerPaymentResponseModel(
          ledgerEntryId: 'l1',
          customerId: customerId,
          amount: amount.toString(),
          newBalance: '-300',
          registerShiftId: registerShiftId,
        ));
  }
}

class _Reverse extends Fake implements ReverseCustomerPaymentUseCase {
  final bodies = <Map<String, dynamic>>[];
  final keys = <String?>[];
  Either<Failure, PaymentReversalResult>? result;

  @override
  Future<Either<Failure, PaymentReversalResult>> call(
    String paymentId,
    Map<String, dynamic> body, {
    String? idempotencyKey,
  }) async {
    bodies.add(body);
    keys.add(idempotencyKey);
    return result ??
        Right(PaymentReversalResult(
          reversalId: 'r1',
          originalId: paymentId,
          partyId: 'c1',
          amount: Decimal.parse('500'),
          reason: 'x',
          drawerReversed: false,
          balance: Decimal.parse('-800'),
        ));
  }
}

class _Rig {
  _Rig({String? shiftId, String? branch = 'branch-5'}) {
    shifts = FakeShiftGuard(shiftId: shiftId);
    cubit = CustomerLedgerCubit(
      getCustomerUseCase: _GetCustomer(),
      getCustomerBalanceUseCase: balance,
      getCustomerLedgerUseCase: ledger,
      recordCustomerPaymentUseCase: record,
      reverseCustomerPaymentUseCase: reverse,
      shiftGuard: shifts,
      branchResolver: FakeBranchResolver(branch),
      khataEvents: events,
    );
  }

  final balance = _GetBalance();
  final ledger = _GetLedger();
  final record = _Record();
  final reverse = _Reverse();
  final events = CountingKhataEvents();
  late final FakeShiftGuard shifts;
  late final CustomerLedgerCubit cubit;

  Future<void> start({String? branchId = 'branch-5'}) =>
      cubit.load('c1', branchId: branchId);
}

void main() {
  group('customer payment: cash needs a shift (audit E14)', () {
    test('cash with no shift is NOT recorded; the notice is shown', () async {
      final r = _Rig();
      await r.start();
      final result = await r.cubit.recordPayment(
        amount: Decimal.parse('500'),
        paymentMethod: PaymentMethods.cash,
      );
      expect(result, isNull);
      expect(r.record.calls, isEmpty, reason: 'nothing may be sent');
      final s = r.cubit.state as CustomerLedgerLoaded;
      expect(s.paymentError, KhataText.customerCashNeedsShiftTitle);
      expect(s.isRecordingPayment, isFalse);
    });

    test('one-tap Open shift, then the cash payment carries that shift',
        () async {
      final r = _Rig();
      await r.start();
      expect(await r.cubit.openShiftForPayment(), isTrue);
      expect(r.shifts.openCalls, 1);
      final result = await r.cubit.recordPayment(
        amount: Decimal.parse('500'),
        paymentMethod: PaymentMethods.cash,
      );
      expect(result, isNotNull);
      expect(r.record.calls.single.shift, 'opened-shift');
    });

    test('a failed Open shift shows the reason', () async {
      final r = _Rig();
      r.shifts.openResult = const Left(ServerFailure('Register is busy'));
      await r.start();
      expect(await r.cubit.openShiftForPayment(), isFalse);
      expect((r.cubit.state as CustomerLedgerLoaded).paymentError,
          'Register is busy');
    });

    test('with a shift open, cash sends the shift id', () async {
      final r = _Rig(shiftId: 'shift-7');
      await r.start();
      await r.cubit.recordPayment(
        amount: Decimal.parse('100'),
        paymentMethod: PaymentMethods.cash,
      );
      expect(r.record.calls.single.shift, 'shift-7');
    });

    test('bank / wallet payments need no shift and send none', () async {
      final r = _Rig();
      await r.start();
      await r.cubit.recordPayment(
        amount: Decimal.parse('100'),
        paymentMethod: PaymentMethods.bankTransfer,
      );
      expect(r.record.calls.single.shift, isNull);
      expect(r.shifts.checkCalls, 0);
    });
  });

  group('every payment and reversal carries the active branch', () {
    test('payment uses the branch the ledger shows', () async {
      final r = _Rig(shiftId: 's');
      await r.start(branchId: 'branch-A');
      await r.cubit.recordPayment(
        amount: Decimal.one,
        paymentMethod: PaymentMethods.bankTransfer,
      );
      expect(r.record.calls.single.branch, 'branch-A');
    });

    test('with no ledger branch it falls back to the user\'s active branch',
        () async {
      final r = _Rig(shiftId: 's', branch: 'branch-active');
      await r.start(branchId: null);
      await r.cubit.recordPayment(
        amount: Decimal.one,
        paymentMethod: PaymentMethods.bankTransfer,
      );
      expect(r.record.calls.single.branch, 'branch-active');
    });

    test('with no branch at all nothing is sent (it would be business-wide)',
        () async {
      final r = _Rig(shiftId: 's', branch: null);
      await r.start(branchId: null);
      final result = await r.cubit.recordPayment(
        amount: Decimal.one,
        paymentMethod: PaymentMethods.bankTransfer,
      );
      expect(result, isNull);
      expect(r.record.calls, isEmpty);
      expect((r.cubit.state as CustomerLedgerLoaded).paymentError,
          KhataText.branchMissing);
    });

    test('reversal sends the branch too', () async {
      final r = _Rig();
      await r.start(branchId: 'branch-A');
      expect(await r.cubit.reversePayment('p1', 'Typed twice'), isNull);
      expect(r.reverse.bodies.single['branch_id'], 'branch-A');
      expect(r.reverse.bodies.single['reason'], 'Typed twice');
    });

    test('ledger and balance are read for the same branch', () async {
      final r = _Rig();
      await r.start(branchId: 'branch-A');
      expect(r.ledger.branches.single, 'branch-A');
      expect(r.balance.branches.single, 'branch-A');
    });
  });

  group('reversing a customer payment', () {
    test('success refreshes other screens', () async {
      final r = _Rig();
      await r.start();
      expect(await r.cubit.reversePayment('p1', 'Typed twice'), isNull);
      expect(r.events.notified, 1);
    });

    test('a retry after a lost answer reuses the key', () async {
      final r = _Rig();
      await r.start();
      r.reverse.result = const Left(NetworkFailure());
      expect(await r.cubit.reversePayment('p1', 'Typed twice'),
          KhataText.offlineReverse);
      r.reverse.result = null;
      await r.cubit.reversePayment('p1', 'Typed twice');
      expect(r.reverse.keys[0], isNotNull);
      expect(r.reverse.keys[0], r.reverse.keys[1]);
    });

    for (final c in {
      'payment_already_reversed': KhataText.alreadyReversed,
      'open_shift_required_to_reverse': KhataText.needsShiftToReverse,
      'not_a_reversible_payment': KhataText.notAPayment,
    }.entries) {
      test('${c.key} is explained in plain words', () async {
        final r = _Rig();
        await r.start();
        r.reverse.result = Left(ConflictFailure('raw', c.key));
        expect(await r.cubit.reversePayment('p1', 'Because'), c.value);
      });
    }
  });
}
