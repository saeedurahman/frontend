import 'package:dartz/dartz.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/features/restaurant/data/models/floor_plan_model.dart';
import 'package:frantend/features/restaurant/data/models/kot_order_model.dart';
import 'package:frantend/features/restaurant/data/models/modifier_group_model.dart';
import 'package:frantend/features/restaurant/data/models/restaurant_requests.dart';
import 'package:frantend/features/sales/data/models/sale_response_model.dart';

abstract class RestaurantRepository {
  Future<Either<Failure, List<FloorPlanModel>>> getFloorPlans({
    String? branchId,
  });

  Future<Either<Failure, FloorLayoutModel>> getFloorLayout({
    String? branchId,
  });

  Future<Either<Failure, List<DiningTableModel>>> getTables({
    String? branchId,
    String? floorPlanId,
    String? status,
  });

  Future<Either<Failure, DiningTableModel>> getTableById(String tableId);

  Future<Either<Failure, List<ModifierGroupModel>>> getModifierGroups();

  Future<Either<Failure, List<ModifierGroupModel>>> getProductModifierGroups(
    String productId,
  );

  Future<Either<Failure, SaleResponseModel>> openTab(OpenTabRequest request);

  Future<Either<Failure, SaleResponseModel>> addTabLines(
    String saleId,
    AddTabLinesRequest request,
  );

  Future<Either<Failure, FireTabResponseModel>> fireTab(
    String saleId, {
    FireTabRequest? request,
  });

  Future<Either<Failure, SaleResponseModel>> requestBill(String saleId);

  Future<Either<Failure, SaleResponseModel>> completeTab(
    String saleId,
    CompleteTabRequest request,
  );

  Future<Either<Failure, SaleResponseModel>> getTabSale(String saleId);

  Future<Either<Failure, List<KotOrderModel>>> getActiveKotOrders({
    String? branchId,
  });

  Future<Either<Failure, List<KotOrderModel>>> getKotOrdersByTable(
    String tableId,
  );

  Future<Either<Failure, KotOrderModel>> getKotOrderById(String kotId);

  Future<Either<Failure, KotOrderModel>> updateKotStatus(
    String kotId,
    UpdateKotStatusRequest request,
  );
}
