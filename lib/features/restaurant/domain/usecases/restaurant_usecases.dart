import 'package:dartz/dartz.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/features/restaurant/data/models/floor_plan_model.dart';
import 'package:frantend/features/restaurant/data/models/kot_order_model.dart';
import 'package:frantend/features/restaurant/data/models/modifier_group_model.dart';
import 'package:frantend/features/restaurant/data/models/restaurant_requests.dart';
import 'package:frantend/features/restaurant/domain/repositories/restaurant_repository.dart';
import 'package:frantend/features/sales/data/models/sale_response_model.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetFloorPlansUseCase {
  const GetFloorPlansUseCase(this._repository);
  final RestaurantRepository _repository;

  Future<Either<Failure, List<FloorPlanModel>>> call({String? branchId}) =>
      _repository.getFloorPlans(branchId: branchId);
}

@injectable
class GetFloorLayoutUseCase {
  const GetFloorLayoutUseCase(this._repository);
  final RestaurantRepository _repository;

  Future<Either<Failure, FloorLayoutModel>> call({String? branchId}) =>
      _repository.getFloorLayout(branchId: branchId);
}

@injectable
class GetDiningTablesUseCase {
  const GetDiningTablesUseCase(this._repository);
  final RestaurantRepository _repository;

  Future<Either<Failure, List<DiningTableModel>>> call({
    String? branchId,
    String? floorPlanId,
    String? status,
  }) =>
      _repository.getTables(
        branchId: branchId,
        floorPlanId: floorPlanId,
        status: status,
      );
}

@injectable
class GetDiningTableByIdUseCase {
  const GetDiningTableByIdUseCase(this._repository);
  final RestaurantRepository _repository;

  Future<Either<Failure, DiningTableModel>> call(String tableId) =>
      _repository.getTableById(tableId);
}

@injectable
class GetModifierGroupsUseCase {
  const GetModifierGroupsUseCase(this._repository);
  final RestaurantRepository _repository;

  Future<Either<Failure, List<ModifierGroupModel>>> call() =>
      _repository.getModifierGroups();
}

@injectable
class GetProductModifierGroupsUseCase {
  const GetProductModifierGroupsUseCase(this._repository);
  final RestaurantRepository _repository;

  Future<Either<Failure, List<ModifierGroupModel>>> call(String productId) =>
      _repository.getProductModifierGroups(productId);
}

@injectable
class OpenTabUseCase {
  const OpenTabUseCase(this._repository);
  final RestaurantRepository _repository;

  Future<Either<Failure, SaleResponseModel>> call(OpenTabRequest request) =>
      _repository.openTab(request);
}

@injectable
class AddTabLinesUseCase {
  const AddTabLinesUseCase(this._repository);
  final RestaurantRepository _repository;

  Future<Either<Failure, SaleResponseModel>> call(
    String saleId,
    AddTabLinesRequest request,
  ) =>
      _repository.addTabLines(saleId, request);
}

@injectable
class FireTabUseCase {
  const FireTabUseCase(this._repository);
  final RestaurantRepository _repository;

  Future<Either<Failure, FireTabResponseModel>> call(
    String saleId, {
    FireTabRequest? request,
  }) =>
      _repository.fireTab(saleId, request: request);
}

@injectable
class RequestTabBillUseCase {
  const RequestTabBillUseCase(this._repository);
  final RestaurantRepository _repository;

  Future<Either<Failure, SaleResponseModel>> call(String saleId) =>
      _repository.requestBill(saleId);
}

@injectable
class CompleteTabUseCase {
  const CompleteTabUseCase(this._repository);
  final RestaurantRepository _repository;

  Future<Either<Failure, SaleResponseModel>> call(
    String saleId,
    CompleteTabRequest request,
  ) =>
      _repository.completeTab(saleId, request);
}

@injectable
class GetTabSaleUseCase {
  const GetTabSaleUseCase(this._repository);
  final RestaurantRepository _repository;

  Future<Either<Failure, SaleResponseModel>> call(String saleId) =>
      _repository.getTabSale(saleId);
}

@injectable
class GetActiveKotOrdersUseCase {
  const GetActiveKotOrdersUseCase(this._repository);
  final RestaurantRepository _repository;

  Future<Either<Failure, List<KotOrderModel>>> call({String? branchId}) =>
      _repository.getActiveKotOrders(branchId: branchId);
}

@injectable
class GetKotOrdersByTableUseCase {
  const GetKotOrdersByTableUseCase(this._repository);
  final RestaurantRepository _repository;

  Future<Either<Failure, List<KotOrderModel>>> call(String tableId) =>
      _repository.getKotOrdersByTable(tableId);
}

@injectable
class GetKotOrderByIdUseCase {
  const GetKotOrderByIdUseCase(this._repository);
  final RestaurantRepository _repository;

  Future<Either<Failure, KotOrderModel>> call(String kotId) =>
      _repository.getKotOrderById(kotId);
}

@injectable
class UpdateKotStatusUseCase {
  const UpdateKotStatusUseCase(this._repository);
  final RestaurantRepository _repository;

  Future<Either<Failure, KotOrderModel>> call(
    String kotId,
    UpdateKotStatusRequest request,
  ) =>
      _repository.updateKotStatus(kotId, request);
}
