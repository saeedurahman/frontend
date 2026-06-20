import 'package:dartz/dartz.dart';
import 'package:frantend/core/error/error_handler.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/features/purchases/data/datasources/purchases_remote_datasource.dart';
import 'package:frantend/features/purchases/data/models/purchase_order_model.dart';
import 'package:frantend/features/purchases/domain/repositories/purchases_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: PurchasesRepository)
class PurchasesRepositoryImpl implements PurchasesRepository {
  PurchasesRepositoryImpl({
    required PurchasesRemoteDataSource remoteDataSource,
    required ErrorHandler errorHandler,
  })  : _remote = remoteDataSource,
        _errorHandler = errorHandler;

  final PurchasesRemoteDataSource _remote;
  final ErrorHandler _errorHandler;

  @override
  Future<Either<Failure, List<PurchaseOrderModel>>> getPurchaseOrders() async {
    try {
      final result = await _remote.getPurchaseOrders();
      return Right(result);
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, PurchaseOrderModel>> getPurchaseOrder(String id) async {
    try {
      final result = await _remote.getPurchaseOrder(id);
      return Right(result);
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, PurchaseOrderModel>> createPurchaseOrder(
    Map<String, dynamic> body,
  ) async {
    try {
      final result = await _remote.createPurchaseOrder(body);
      return Right(result);
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, PurchaseOrderModel>> updatePurchaseOrderStatus(
    String id,
    String status,
  ) async {
    try {
      final result = await _remote.updatePurchaseOrderStatus(id, status);
      return Right(result);
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, PurchaseReceiptModel>> createPurchaseReceipt(
    Map<String, dynamic> body,
  ) async {
    try {
      final result = await _remote.createPurchaseReceipt(body);
      return Right(result);
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, PurchaseReceiptModel>> getPurchaseReceipt(
    String id,
  ) async {
    try {
      final result = await _remote.getPurchaseReceipt(id);
      return Right(result);
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }
}
