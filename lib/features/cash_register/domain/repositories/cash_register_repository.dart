import 'package:dartz/dartz.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/features/cash_register/data/models/cash_register_model.dart';
import 'package:frantend/features/cash_register/data/models/register_shift_model.dart';
import 'package:frantend/features/cash_register/data/models/shift_summary_model.dart';

abstract class CashRegisterRepository {
  Future<Either<Failure, List<CashRegisterModel>>> getRegisters({
    String? branchId,
  });

  Future<Either<Failure, CashRegisterModel>> createRegister(
    Map<String, dynamic> body,
  );

  Future<Either<Failure, RegisterShiftModel?>> getActiveShift(
    String registerId,
  );

  Future<Either<Failure, RegisterShiftModel?>> getMyActiveShift();

  Future<Either<Failure, RegisterShiftModel>> openShift(
    Map<String, dynamic> body,
  );

  Future<Either<Failure, ShiftSummaryModel>> getShiftSummary(String shiftId);

  Future<Either<Failure, ShiftSummaryModel>> closeShift(
    String shiftId, {
    required String actualCash,
    String? notes,
  });

  Future<Either<Failure, List<RegisterShiftModel>>> getShifts({
    String? branchId,
    String? registerId,
    String? status,
    int skip = 0,
    int limit = 50,
  });

  Future<Either<Failure, RegisterShiftModel>> getShiftById(String shiftId);
}
