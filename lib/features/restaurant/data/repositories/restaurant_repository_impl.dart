import 'package:dartz/dartz.dart';
import 'package:frantend/core/error/error_handler.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/features/restaurant/data/datasources/restaurant_remote_datasource.dart';
import 'package:frantend/features/restaurant/data/models/floor_plan_model.dart';
import 'package:frantend/features/restaurant/data/models/kot_order_model.dart';
import 'package:frantend/features/restaurant/data/models/modifier_group_model.dart';
import 'package:frantend/features/restaurant/data/models/restaurant_requests.dart';
import 'package:frantend/features/restaurant/domain/repositories/restaurant_repository.dart';
import 'package:frantend/features/sales/data/models/sale_response_model.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: RestaurantRepository)
class RestaurantRepositoryImpl implements RestaurantRepository {
  RestaurantRepositoryImpl({
    required RestaurantRemoteDataSource remoteDataSource,
    required ErrorHandler errorHandler,
  })  : _remote = remoteDataSource,
        _errorHandler = errorHandler;

  final RestaurantRemoteDataSource _remote;
  final ErrorHandler _errorHandler;

  @override
  Future<Either<Failure, List<FloorPlanModel>>> getFloorPlans({
    String? branchId,
  }) async {
    try {
      return Right(await _remote.getFloorPlans(branchId: branchId));
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, FloorLayoutModel>> getFloorLayout({
    String? branchId,
  }) async {
    try {
      return Right(await _remote.getFloorLayout(branchId: branchId));
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<DiningTableModel>>> getTables({
    String? branchId,
    String? floorPlanId,
    String? status,
  }) async {
    try {
      return Right(
        await _remote.getTables(
          branchId: branchId,
          floorPlanId: floorPlanId,
          status: status,
        ),
      );
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, DiningTableModel>> getTableById(String tableId) async {
    try {
      return Right(await _remote.getTableById(tableId));
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<ModifierGroupModel>>> getModifierGroups() async {
    try {
      return Right(await _remote.getModifierGroups());
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<ModifierGroupModel>>> getProductModifierGroups(
    String productId,
  ) async {
    try {
      return Right(await _remote.getProductModifierGroups(productId));
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, SaleResponseModel>> openTab(
    OpenTabRequest request,
  ) async {
    try {
      return Right(await _remote.openTab(request));
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, SaleResponseModel>> addTabLines(
    String saleId,
    AddTabLinesRequest request,
  ) async {
    try {
      return Right(await _remote.addTabLines(saleId, request));
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, FireTabResponseModel>> fireTab(
    String saleId, {
    FireTabRequest? request,
  }) async {
    try {
      return Right(await _remote.fireTab(saleId, request: request));
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, SaleResponseModel>> requestBill(String saleId) async {
    try {
      return Right(await _remote.requestBill(saleId));
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, SaleResponseModel>> completeTab(
    String saleId,
    CompleteTabRequest request,
  ) async {
    try {
      return Right(await _remote.completeTab(saleId, request));
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, SaleResponseModel>> getTabSale(String saleId) async {
    try {
      return Right(await _remote.getSaleById(saleId));
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<KotOrderModel>>> getActiveKotOrders({
    String? branchId,
  }) async {
    try {
      return Right(await _remote.getActiveKotOrders(branchId: branchId));
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<KotOrderModel>>> getKotOrdersByTable(
    String tableId,
  ) async {
    try {
      return Right(await _remote.getKotOrdersByTable(tableId));
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, KotOrderModel>> getKotOrderById(String kotId) async {
    try {
      return Right(await _remote.getKotOrderById(kotId));
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, KotOrderModel>> updateKotStatus(
    String kotId,
    UpdateKotStatusRequest request,
  ) async {
    try {
      return Right(await _remote.updateKotStatus(kotId, request));
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }
}
