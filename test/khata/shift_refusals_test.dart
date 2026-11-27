// `no_open_shift` and `shift_not_yours`: sales, returns and drawer cash answer
// them with the "Open shift first" prompt. Only the code is read.
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/core/permissions/permission_keys.dart';
import 'package:frantend/core/sync/sync_config.dart';
import 'package:frantend/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:frantend/features/auth/data/models/user_model.dart';
import 'package:frantend/features/cash_register/data/models/register_shift_model.dart';
import 'package:frantend/features/cash_register/domain/usecases/cash_register_usecases.dart';
import 'package:frantend/features/customers/domain/usecases/customer_usecases.dart';
import 'package:frantend/features/khata/domain/khata_text.dart';
import 'package:frantend/features/pos/domain/errors/pos_errors.dart';
import 'package:frantend/features/returns/data/models/sale_return_response_model.dart';
import 'package:frantend/features/returns/domain/usecases/returns_usecases.dart';
import 'package:frantend/features/returns/presentation/cubit/process_return_cubit.dart';
import 'package:frantend/features/returns/presentation/pages/process_return_page.dart';
import 'package:frantend/features/sales/data/models/sale_response_model.dart';
import 'package:frantend/features/sales/domain/usecases/sales_usecases.dart';

import '../helpers/khata_fakes.dart';

class _GetSale extends Fake implements GetSaleByIdUseCase {
  @override
  Future<Either<Failure, SaleResponseModel>> call(String id) async =>
      const Right(SaleResponseModel(
        id: 'sale-0001',
        branchId: 'branch-of-sale',
        saleType: 'pos',
        saleStatus: 'completed',
        totalAmount: '100',
        lines: [
          SaleLineModel(id: 'l1', productId: 'p1', qty: '1', unitPrice: '100'),
        ],
      ));
}

class _GetCustomer extends Fake implements GetCustomerUseCase {}

class _CreateReturn extends Fake implements CreateSaleReturnUseCase {
  Failure? failWith;
  final bodies = <Map<String, dynamic>>[];

  @override
  Future<Either<Failure, SaleReturnResponseModel>> call(
    Map<String, dynamic> body,
  ) async {
    bodies.add(body);
    if (failWith != null) return Left(failWith!);
    return const Right(SaleReturnResponseModel(
      id: 'ret-00001',
      businessId: 'b',
      branchId: 'branch-of-sale',
      returnNumber: 'R-1',
    ));
  }
}

class _MyShift extends Fake implements GetMyActiveShiftUseCase {
  String? id = 'shift-1';
  bool unreachable = false;

  @override
  Future<Either<Failure, RegisterShiftModel?>> call() async {
    if (unreachable) return const Left(NetworkFailure());
    final shiftId = id;
    return Right(shiftId == null
        ? null
        : RegisterShiftModel(id: shiftId, cashRegisterId: 'r1'));
  }
}

class _Auth extends Fake implements AuthLocalDataSource {
  @override
  Future<UserModel?> getCachedUser() async => const UserModel(
        id: 'u1',
        name: 'Cashier',
        role: 'cashier',
        permissionKeys: [Perm.returnsCreate, Perm.shiftsOpen],
      );
}

class _Rig {
  final shift = _MyShift();
  final create = _CreateReturn();
  final guard = FakeShiftGuard();

  late final cubit = ProcessReturnCubit(
    getSaleByIdUseCase: _GetSale(),
    getCustomerUseCase: _GetCustomer(),
    createSaleReturnUseCase: create,
    getMyActiveShiftUseCase: shift,
    authLocalDataSource: _Auth(),
    shiftGuard: guard,
  );

  /// A loaded return of the whole sale, refunded in cash.
  Future<void> ready() async {
    await cubit.load('sale-0001');
    cubit.returnAll(0);
    cubit.setReason('Damaged');
    cubit.addRefundLine(method: 'cash', label: 'Cash');
  }
}

void main() {
  group('the code alone decides', () {
    test('both codes become the shift prompt for a sale', () {
      for (final (failure, message) in <(Failure, String)>[
        (
          const ServerFailure('x', 'no_open_shift'),
          ShiftRequiredException.needsShift,
        ),
        (
          const PermissionDeniedFailure('x', 'shift_not_yours'),
          ShiftRequiredException.notYours,
        ),
      ]) {
        final e = SaleFailureMapper.map(failure, hasCustomer: false);
        expect((e! as ShiftRequiredException).message, message);
      }
    });

    test('a sentence without a code is not a shift refusal', () {
      expect(
        SaleFailureMapper.map(
          const ServerFailure('No open shift. Open a shift first'),
          hasCustomer: false,
        ),
        isNull,
      );
    });

    test('the sync queue asks for a shift for both codes', () {
      for (final code in ['no_open_shift', 'shift_not_yours']) {
        expect(SyncErrorText.explain(code), startsWith('Open shift first'));
      }
    });
  });

  group('returns', () {
    test('no shift on loading: the prompt shows for any refund method',
        () async {
      final r = _Rig()..shift.id = null;
      await r.cubit.load('sale-0001');
      expect(r.cubit.state.shiftMissing, isTrue);
    });

    test('a shift that cannot be looked up is not called missing', () async {
      final r = _Rig()..shift.unreachable = true;
      await r.cubit.load('sale-0001');
      expect(r.cubit.state.shiftMissing, isFalse);
    });

    test('no_open_shift: prompt, one-tap open in the sale branch, then sent',
        () async {
      final r = _Rig();
      await r.ready();
      r.create.failWith = const ServerFailure('words', 'no_open_shift');
      expect(await r.cubit.submitReturn(), isNull);
      expect(r.cubit.state.shiftMissing, isTrue);
      expect(r.cubit.state.activeShiftId, isNull);
      expect(r.cubit.state.submitError, isNull);
      expect(r.cubit.state.isSubmitting, isFalse);

      r.create.failWith = null;
      expect(await r.cubit.openShift(), isTrue);
      expect(r.guard.openedIn, 'branch-of-sale');
      expect(r.cubit.state.shiftMissing, isFalse);
      r.shift.id = 'opened-shift';
      expect(await r.cubit.submitReturn(), isNotNull);
      expect(r.create.bodies.last['register_shift_id'], 'opened-shift');
    });

    test('shift_not_yours without an own shift: message and prompt', () async {
      final r = _Rig();
      await r.ready();
      r.create.failWith =
          const PermissionDeniedFailure('words', 'shift_not_yours');
      r.shift.id = null;
      expect(await r.cubit.submitReturn(), isNull);
      expect(r.cubit.state.submitError, KhataText.returnShiftNotYours);
      expect(r.cubit.state.shiftMissing, isTrue);
    });

    test('shift_not_yours with an own shift: it is picked up', () async {
      final r = _Rig();
      await r.ready();
      r.create.failWith =
          const PermissionDeniedFailure('words', 'shift_not_yours');
      r.shift.id = 'mine';
      expect(await r.cubit.submitReturn(), isNull);
      expect(r.cubit.state.activeShiftId, 'mine');
      expect(r.cubit.state.shiftMissing, isFalse);
    });

    test('a failed Open shift shows the reason', () async {
      final r = _Rig()..shift.id = null;
      r.guard.openResult = const Left(ServerFailure('Register is busy'));
      await r.cubit.load('sale-0001');
      expect(await r.cubit.openShift(), isFalse);
      expect(r.cubit.state.submitError, 'Register is busy');
      expect(r.cubit.state.shiftMissing, isTrue);
    });

    testWidgets('the page offers Open shift and hides the prompt after it',
        (tester) async {
      tester.view.physicalSize = const Size(1600, 2000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      final r = _Rig()..shift.id = null;
      sl.registerFactory<ProcessReturnCubit>(() => r.cubit);
      addTearDown(() => sl.unregister<ProcessReturnCubit>());

      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(body: ProcessReturnPage(saleId: 'sale-0001')),
      ));
      await tester.pumpAndSettle();
      expect(find.text(KhataText.customerCashNeedsShiftTitle), findsOneWidget);
      expect(find.text(KhataText.returnNeedsShiftBody), findsOneWidget);

      await tester.tap(find.byKey(const ValueKey('open_shift_button')));
      await tester.pumpAndSettle();
      expect(r.guard.openCalls, 1);
      expect(find.byKey(const ValueKey('needs_shift_notice')), findsNothing);
    });
  });
}
