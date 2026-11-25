import 'package:dartz/dartz.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/features/khata/data/models/khata_models.dart';
import 'package:frantend/features/khata/domain/payment_source.dart';
import 'package:frantend/features/khata/presentation/cubit/supplier_payment_cubit.dart';
import 'package:frantend/features/suppliers/data/models/supplier_model.dart';
import 'package:frantend/features/suppliers/domain/usecases/supplier_usecases.dart';

import 'khata_fakes.dart';

class FakeGetSupplierBalance extends Fake implements GetSupplierBalanceUseCase {
  Either<Failure, SupplierBalanceModel> result = const Right(
    SupplierBalanceModel(supplierId: 's1', balance: '-1000'),
  );
  String? lastBranch;

  @override
  Future<Either<Failure, SupplierBalanceModel>> call(
    String supplierId, {
    String? branchId,
  }) async {
    lastBranch = branchId;
    return result;
  }
}

class FakeGetSupplier extends Fake implements GetSupplierUseCase {}

class FakePaySupplier extends Fake implements PaySupplierUseCase {
  final bodies = <Map<String, dynamic>>[];
  final keys = <String?>[];
  Either<Failure, SupplierPaymentResult>? result;

  @override
  Future<Either<Failure, SupplierPaymentResult>> call(
    Map<String, dynamic> body, {
    String? idempotencyKey,
  }) async {
    bodies.add(body);
    keys.add(idempotencyKey);
    return result ??
        Right(supplierPaymentResult(
          amount: body['amount'] as String,
          source: body['payment_source'] as String,
          shift: body['payment_source'] == 'drawer' ? 'shift-1' : null,
        ));
  }
}

SupplierPaymentResult supplierPaymentResult({
  String id = 'pay-1',
  required String amount,
  String source = 'drawer',
  String? shift,
  String balance = '-500',
}) =>
    SupplierPaymentResult(
      id: id,
      amount: Decimal.parse(amount),
      paymentSource: PaymentSource.fromApi(source)!,
      balanceBefore: Decimal.parse('-1000'),
      balance: Decimal.parse(balance),
      registerShiftId: shift,
    );

class PayRig {
  PayRig({String? shiftId}) {
    shifts = FakeShiftGuard(shiftId: shiftId);
    cubit = SupplierPaymentCubit(
      balance,
      FakeGetSupplier(),
      pay,
      shifts,
      branch,
      store,
      events,
    );
  }

  final balance = FakeGetSupplierBalance();
  final pay = FakePaySupplier();
  final branch = FakeBranchResolver('branch-9');
  final store = MemoryPaymentSourceStore();
  final events = CountingKhataEvents();
  late final FakeShiftGuard shifts;
  late final SupplierPaymentCubit cubit;

  Future<void> start({String name = 'Haji Traders'}) =>
      cubit.init(supplierId: 's1', supplierName: name);
}

