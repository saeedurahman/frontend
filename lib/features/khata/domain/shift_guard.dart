import 'package:dartz/dartz.dart';
import 'package:decimal/decimal.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/core/session/active_branch_resolver.dart';
import 'package:frantend/features/cash_register/domain/usecases/cash_register_usecases.dart';
import 'package:frantend/features/pos/domain/usecases/pos_local_usecases.dart';
import 'package:frantend/features/pos/domain/usecases/pos_usecases.dart';
import 'package:injectable/injectable.dart';

/// Finds the signed-in user's open shift and, on request, opens one with a
/// single tap (first register of the active branch, empty opening float).
///
/// Used wherever money touching the drawer is recorded outside the till:
/// paying a supplier in cash, receiving a customer's cash payment.
@injectable
class ShiftGuard {
  ShiftGuard(
    this._myShift,
    this._registers,
    this._createRegister,
    this._openShift,
    this._branch,
  );

  final GetMyActiveShiftUseCase _myShift;
  final GetRegistersUseCase _registers;
  final CreateRegisterUseCase _createRegister;
  final OpenShiftUseCase _openShift;
  final ActiveBranchResolver _branch;

  /// The id of the user's open shift, or null when there is none (or it cannot
  /// be checked).
  Future<String?> currentShiftId() async {
    final result = await _myShift();
    return result.fold((_) => null, (shift) => shift?.id);
  }

  /// Opens a shift with an empty drawer. Returns its id, or the reason it
  /// could not be done.
  Future<Either<Failure, String>> openNow({Decimal? openingFloat}) async {
    final branchId = await _branch.resolve();
    if (branchId == null) {
      return const Left(
        ValidationFailure('Branch not configured for your account. Please sign in again.'),
      );
    }
    final registers = await _registers(branchId: branchId);
    final list = registers.fold((_) => null, (r) => r);
    if (list == null) {
      return Left(registers.fold((f) => f, (_) => const ServerFailure()));
    }
    String? registerId = list.where((r) => r.isActive).map((r) => r.id).firstOrNull;
    if (registerId == null) {
      final created = await _createRegister({
        'name': 'Main Counter',
        'branch_id': branchId,
      });
      final register = created.fold((_) => null, (r) => r);
      if (register == null) {
        return Left(created.fold((f) => f, (_) => const ServerFailure()));
      }
      registerId = register.id;
    }
    final opened = await _openShift(
      ShiftPolicy.openBody(
        registerId: registerId,
        openingFloat: openingFloat ?? Decimal.zero,
      ),
    );
    return opened.fold(Left.new, (shift) => Right(shift.id));
  }
}
