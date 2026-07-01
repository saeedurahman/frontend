import 'package:dartz/dartz.dart';
import 'package:frantend/core/error/error_handler.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/features/manufacturing/data/datasources/manufacturing_remote_datasource.dart';
import 'package:frantend/features/manufacturing/data/models/bom_header_model.dart';
import 'package:frantend/features/manufacturing/data/models/bom_preview_model.dart';
import 'package:frantend/features/manufacturing/data/models/production_order_model.dart';
import 'package:frantend/features/manufacturing/domain/repositories/manufacturing_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ManufacturingRepository)
class ManufacturingRepositoryImpl implements ManufacturingRepository {
  ManufacturingRepositoryImpl({
    required ManufacturingRemoteDataSource remoteDataSource,
    required ErrorHandler errorHandler,
  })  : _remote = remoteDataSource,
        _errorHandler = errorHandler;

  final ManufacturingRemoteDataSource _remote;
  final ErrorHandler _errorHandler;

  @override
  Future<Either<Failure, List<BomHeaderModel>>> listBoms({
    String? productId,
    bool activeOnly = false,
  }) async {
    try {
      final result = await _remote.listBoms(
        productId: productId,
        activeOnly: activeOnly,
      );
      return Right(result);
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<BomHeaderModel>>> listBomsByProduct(
    String productId, {
    String? variationId,
    bool activeOnly = false,
  }) async {
    try {
      final result = await _remote.listBomsByProduct(
        productId,
        variationId: variationId,
        activeOnly: activeOnly,
      );
      return Right(result);
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, BomHeaderModel>> getBom(String id) async {
    try {
      return Right(await _remote.getBom(id));
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, BomHeaderModel>> createBom(
    Map<String, dynamic> body,
  ) async {
    try {
      return Right(await _remote.createBom(body));
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, BomHeaderModel>> updateBom(
    String id,
    Map<String, dynamic> body,
  ) async {
    try {
      return Right(await _remote.updateBom(id, body));
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> deleteBom(String id) async {
    try {
      await _remote.deleteBom(id);
      return const Right(null);
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, BomPreviewModel>> previewBom({
    required String bomHeaderId,
    required String qtyToProduce,
  }) async {
    try {
      return Right(
        await _remote.previewBom(
          bomHeaderId: bomHeaderId,
          qtyToProduce: qtyToProduce,
        ),
      );
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<ProductionOrderModel>>> listProductionOrders({
    String? branchId,
    String? status,
    String? bomHeaderId,
    int skip = 0,
    int limit = 50,
  }) async {
    try {
      final result = await _remote.listProductionOrders(
        branchId: branchId,
        status: status,
        bomHeaderId: bomHeaderId,
        skip: skip,
        limit: limit,
      );
      return Right(result);
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, ProductionOrderModel>> getProductionOrder(
    String id,
  ) async {
    try {
      return Right(await _remote.getProductionOrder(id));
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, ProductionOrderModel>> createProductionOrder(
    Map<String, dynamic> body,
  ) async {
    try {
      return Right(await _remote.createProductionOrder(body));
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, ProductionOrderModel>> updateProductionOrder(
    String id,
    Map<String, dynamic> body,
  ) async {
    try {
      return Right(await _remote.updateProductionOrder(id, body));
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, ProductionOrderModel>> startProductionOrder(
    String id,
  ) async {
    try {
      return Right(await _remote.startProductionOrder(id));
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, ProductionOrderModel>> cancelProductionOrder(
    String id,
  ) async {
    try {
      return Right(await _remote.cancelProductionOrder(id));
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, ProductionOrderModel>> completeProductionOrder(
    String id, {
    required String qtyProduced,
  }) async {
    try {
      return Right(
        await _remote.completeProductionOrder(
          id,
          qtyProduced: qtyProduced,
        ),
      );
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }
}
