import 'package:dartz/dartz.dart';
import 'package:decimal/decimal.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/core/utils/decimal_utils.dart';
import 'package:frantend/features/inventory/data/models/stock_model.dart';
import 'package:frantend/features/inventory/domain/repositories/inventory_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetStockBalanceUseCase {
  const GetStockBalanceUseCase(this._repository);

  final InventoryRepository _repository;

  Future<Either<Failure, StockBalanceModel>> call({
    required String branchId,
    required String productId,
    String? variationId,
  }) =>
      _repository.getStockBalance(
        branchId: branchId,
        productId: productId,
        variationId: variationId,
      );
}

@injectable
class GetStockBalancesUseCase {
  const GetStockBalancesUseCase(this._repository);

  final InventoryRepository _repository;

  Future<Either<Failure, List<StockBalanceModel>>> call({
    required String branchId,
    List<String>? productIds,
  }) =>
      _repository.getStockBalances(
        branchId: branchId,
        productIds: productIds,
      );
}

@injectable
class GetStockMovementsUseCase {
  const GetStockMovementsUseCase(this._repository);

  final InventoryRepository _repository;

  Future<Either<Failure, PaginatedStockMovementsModel>> call({
    required String branchId,
    String? productId,
    String? movementType,
    int skip = 0,
    int limit = 50,
  }) =>
      _repository.getStockMovements(
        branchId: branchId,
        productId: productId,
        movementType: movementType,
        skip: skip,
        limit: limit,
      );
}

@injectable
class CreateStockAdjustmentUseCase {
  const CreateStockAdjustmentUseCase(this._repository);

  final InventoryRepository _repository;

  Future<Either<Failure, StockAdjustmentModel>> call(
    CreateStockAdjustmentParams params,
  ) =>
      _repository.createAdjustment(params.toJson());
}

class CreateStockAdjustmentParams {
  const CreateStockAdjustmentParams({
    required this.branchId,
    required this.reason,
    this.notes,
    this.adjustedAt,
    required this.lines,
  });

  final String branchId;
  final String reason;
  final String? notes;
  final DateTime? adjustedAt;
  final List<CreateStockAdjustmentLineParams> lines;

  Map<String, dynamic> toJson() => {
        'branch_id': branchId,
        'reason': reason,
        if (notes != null) 'notes': notes,
        if (adjustedAt != null) 'adjusted_at': adjustedAt!.toIso8601String(),
        'lines': lines.map((line) => line.toJson()).toList(),
      };
}

class CreateStockAdjustmentLineParams {
  const CreateStockAdjustmentLineParams({
    required this.productId,
    this.variationId,
    required this.qtyDelta,
    required this.costPerUnit,
    this.notes,
  });

  final String productId;
  final String? variationId;
  final Decimal qtyDelta;
  final Decimal costPerUnit;
  final String? notes;

  Map<String, dynamic> toJson() => {
        'product_id': productId,
        if (variationId != null) 'variation_id': variationId,
        'qty_delta': DecimalUtils.format(qtyDelta, fractionDigits: 4),
        'cost_per_unit': DecimalUtils.format(costPerUnit),
        if (notes != null) 'notes': notes,
      };
}
