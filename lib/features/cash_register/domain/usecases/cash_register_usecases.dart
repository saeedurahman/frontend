import 'package:dartz/dartz.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/features/cash_register/data/models/cash_register_model.dart';
import 'package:frantend/features/cash_register/data/models/register_shift_model.dart';
import 'package:frantend/features/cash_register/data/models/shift_summary_model.dart';
import 'package:frantend/features/cash_register/domain/repositories/cash_register_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetCashRegistersUseCase {
  const GetCashRegistersUseCase(this._repository);
  final CashRegisterRepository _repository;

  Future<Either<Failure, List<CashRegisterModel>>> call({String? branchId}) =>
      _repository.getRegisters(branchId: branchId);
}

@injectable
class GetActiveRegisterShiftUseCase {
  const GetActiveRegisterShiftUseCase(this._repository);
  final CashRegisterRepository _repository;

  Future<Either<Failure, RegisterShiftModel?>> call(String registerId) =>
      _repository.getActiveShift(registerId);
}

@injectable
class GetMyActiveShiftUseCase {
  const GetMyActiveShiftUseCase(this._repository);
  final CashRegisterRepository _repository;

  Future<Either<Failure, RegisterShiftModel?>> call() =>
      _repository.getMyActiveShift();
}

@injectable
class GetRegisterShiftSummaryUseCase {
  const GetRegisterShiftSummaryUseCase(this._repository);
  final CashRegisterRepository _repository;

  Future<Either<Failure, ShiftSummaryModel>> call(String shiftId) =>
      _repository.getShiftSummary(shiftId);
}

@injectable
class CloseRegisterShiftUseCase {
  const CloseRegisterShiftUseCase(this._repository);
  final CashRegisterRepository _repository;

  Future<Either<Failure, ShiftSummaryModel>> call(
    String shiftId, {
    required String actualCash,
    String? notes,
  }) =>
      _repository.closeShift(
        shiftId,
        actualCash: actualCash,
        notes: notes,
      );
}

@injectable
class GetRegisterShiftsUseCase {
  const GetRegisterShiftsUseCase(this._repository);
  final CashRegisterRepository _repository;

  Future<Either<Failure, List<RegisterShiftModel>>> call({
    String? branchId,
    String? registerId,
    String? status,
    int skip = 0,
    int limit = 50,
  }) =>
      _repository.getShifts(
        branchId: branchId,
        registerId: registerId,
        status: status,
        skip: skip,
        limit: limit,
      );
}

@injectable
class GetRegisterShiftByIdUseCase {
  const GetRegisterShiftByIdUseCase(this._repository);
  final CashRegisterRepository _repository;

  Future<Either<Failure, RegisterShiftModel>> call(String shiftId) =>
      _repository.getShiftById(shiftId);
}
