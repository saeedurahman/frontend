import 'package:dartz/dartz.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/features/manufacturing/data/models/bom_header_model.dart';
import 'package:frantend/features/manufacturing/data/models/bom_preview_model.dart';
import 'package:frantend/features/manufacturing/data/models/production_order_model.dart';

abstract class ManufacturingRepository {
  Future<Either<Failure, List<BomHeaderModel>>> listBoms({
    String? productId,
    bool activeOnly = false,
  });

  Future<Either<Failure, List<BomHeaderModel>>> listBomsByProduct(
    String productId, {
    String? variationId,
    bool activeOnly = false,
  });

  Future<Either<Failure, BomHeaderModel>> getBom(String id);

  Future<Either<Failure, BomHeaderModel>> createBom(Map<String, dynamic> body);

  Future<Either<Failure, BomHeaderModel>> updateBom(
    String id,
    Map<String, dynamic> body,
  );

  Future<Either<Failure, void>> deleteBom(String id);

  Future<Either<Failure, BomPreviewModel>> previewBom({
    required String bomHeaderId,
    required String qtyToProduce,
  });

  Future<Either<Failure, List<ProductionOrderModel>>> listProductionOrders({
    String? branchId,
    String? status,
    String? bomHeaderId,
    int skip = 0,
    int limit = 50,
  });

  Future<Either<Failure, ProductionOrderModel>> getProductionOrder(String id);

  Future<Either<Failure, ProductionOrderModel>> createProductionOrder(
    Map<String, dynamic> body,
  );

  Future<Either<Failure, ProductionOrderModel>> updateProductionOrder(
    String id,
    Map<String, dynamic> body,
  );

  Future<Either<Failure, ProductionOrderModel>> startProductionOrder(String id);

  Future<Either<Failure, ProductionOrderModel>> cancelProductionOrder(String id);

  Future<Either<Failure, ProductionOrderModel>> completeProductionOrder(
    String id, {
    required String qtyProduced,
  });
}
