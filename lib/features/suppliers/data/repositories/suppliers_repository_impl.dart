import 'package:dartz/dartz.dart';
import 'package:frantend/core/error/error_handler.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/features/suppliers/data/datasources/suppliers_remote_datasource.dart';
import 'package:frantend/features/suppliers/data/models/supplier_model.dart';
import 'package:frantend/features/suppliers/domain/repositories/suppliers_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: SuppliersRepository)
class SuppliersRepositoryImpl implements SuppliersRepository {
  SuppliersRepositoryImpl({
    required SuppliersRemoteDataSource remoteDataSource,
    required ErrorHandler errorHandler,
  })  : _remote = remoteDataSource,
        _errorHandler = errorHandler;

  final SuppliersRemoteDataSource _remote;
  final ErrorHandler _errorHandler;

  @override
  Future<Either<Failure, List<SupplierModel>>> getSuppliers() async {
    try {
      final result = await _remote.getSuppliers();
      return Right(result);
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, SupplierModel>> getSupplier(String id) async {
    try {
      final result = await _remote.getSupplier(id);
      return Right(result);
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, SupplierModel>> createSupplier(
    Map<String, dynamic> body,
  ) async {
    try {
      final result = await _remote.createSupplier(body);
      return Right(result);
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, SupplierModel>> updateSupplier(
    String id,
    Map<String, dynamic> body,
  ) async {
    try {
      final result = await _remote.updateSupplier(id, body);
      return Right(result);
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> deleteSupplier(String id) async {
    try {
      await _remote.deleteSupplier(id);
      return const Right(null);
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, SupplierBalanceModel>> getSupplierBalance(
    String supplierId,
  ) async {
    try {
      final result = await _remote.getSupplierBalance(supplierId);
      return Right(result);
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }
}
