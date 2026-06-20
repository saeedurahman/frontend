import 'package:dartz/dartz.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/features/inventory/data/models/stock_model.dart';

abstract class InventoryRepository {
  Future<Either<Failure, StockBalanceModel>> getStockBalance({
    required String branchId,
    required String productId,
    String? variationId,
  });

  Future<Either<Failure, List<StockBalanceModel>>> getStockBalances({
    required String branchId,
    List<String>? productIds,
  });

  Future<Either<Failure, PaginatedStockMovementsModel>> getStockMovements({
    required String branchId,
    String? productId,
    String? movementType,
    int skip = 0,
    int limit = 50,
  });

  Future<Either<Failure, StockAdjustmentModel>> createAdjustment(
    Map<String, dynamic> body,
  );
}
