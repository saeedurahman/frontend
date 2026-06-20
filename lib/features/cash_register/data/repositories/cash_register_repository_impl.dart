import 'package:dartz/dartz.dart';
import 'package:frantend/core/error/error_handler.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/features/cash_register/data/datasources/cash_register_remote_datasource.dart';
import 'package:frantend/features/cash_register/data/models/cash_register_model.dart';
import 'package:frantend/features/cash_register/data/models/register_shift_model.dart';
import 'package:frantend/features/cash_register/data/models/shift_summary_model.dart';
import 'package:frantend/features/cash_register/domain/repositories/cash_register_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: CashRegisterRepository)
class CashRegisterRepositoryImpl implements CashRegisterRepository {
  CashRegisterRepositoryImpl({
    required CashRegisterRemoteDataSource remoteDataSource,
    required ErrorHandler errorHandler,
  })  : _remote = remoteDataSource,
        _errorHandler = errorHandler;

  final CashRegisterRemoteDataSource _remote;
  final ErrorHandler _errorHandler;

  @override
  Future<Either<Failure, List<CashRegisterModel>>> getRegisters({
    String? branchId,
  }) async {
    try {
      return Right(await _remote.getRegisters(branchId: branchId));
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, CashRegisterModel>> createRegister(
    Map<String, dynamic> body,
  ) async {
    try {
      return Right(await _remote.createRegister(body));
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, RegisterShiftModel?>> getActiveShift(
    String registerId,
  ) async {
    try {
      return Right(await _remote.getActiveShift(registerId));
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, RegisterShiftModel>> openShift(
    Map<String, dynamic> body,
  ) async {
    try {
      return Right(await _remote.openShift(body));
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, ShiftSummaryModel>> getShiftSummary(
    String shiftId,
  ) async {
    try {
      return Right(await _remote.getShiftSummary(shiftId));
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, ShiftSummaryModel>> closeShift(
    String shiftId, {
    required String actualCash,
    String? notes,
  }) async {
    try {
      final body = <String, dynamic>{
        'actual_cash': actualCash,
        if (notes != null && notes.isNotEmpty) 'notes': notes,
      };
      return Right(await _remote.closeShift(shiftId, body));
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<RegisterShiftModel>>> getShifts({
    String? branchId,
    String? registerId,
    String? status,
    int skip = 0,
    int limit = 50,
  }) async {
    try {
      return Right(
        await _remote.getShifts(
          branchId: branchId,
          registerId: registerId,
          status: status,
          skip: skip,
          limit: limit,
        ),
      );
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, RegisterShiftModel>> getShiftById(
    String shiftId,
  ) async {
    try {
      return Right(await _remote.getShiftById(shiftId));
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }
}
