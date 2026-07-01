import 'package:dartz/dartz.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/features/manufacturing/data/models/bom_header_model.dart';
import 'package:frantend/features/manufacturing/data/models/bom_preview_model.dart';
import 'package:frantend/features/manufacturing/data/models/production_order_model.dart';
import 'package:frantend/features/manufacturing/domain/repositories/manufacturing_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class ListBomsUseCase {
  const ListBomsUseCase(this._repository);

  final ManufacturingRepository _repository;

  Future<Either<Failure, List<BomHeaderModel>>> call({
    String? productId,
    bool activeOnly = false,
  }) =>
      _repository.listBoms(productId: productId, activeOnly: activeOnly);
}

@injectable
class ListBomsByProductUseCase {
  const ListBomsByProductUseCase(this._repository);

  final ManufacturingRepository _repository;

  Future<Either<Failure, List<BomHeaderModel>>> call(
    String productId, {
    String? variationId,
    bool activeOnly = false,
  }) =>
      _repository.listBomsByProduct(
        productId,
        variationId: variationId,
        activeOnly: activeOnly,
      );
}

@injectable
class GetBomUseCase {
  const GetBomUseCase(this._repository);

  final ManufacturingRepository _repository;

  Future<Either<Failure, BomHeaderModel>> call(String id) =>
      _repository.getBom(id);
}

@injectable
class CreateBomUseCase {
  const CreateBomUseCase(this._repository);

  final ManufacturingRepository _repository;

  Future<Either<Failure, BomHeaderModel>> call(Map<String, dynamic> body) =>
      _repository.createBom(body);
}

@injectable
class UpdateBomUseCase {
  const UpdateBomUseCase(this._repository);

  final ManufacturingRepository _repository;

  Future<Either<Failure, BomHeaderModel>> call(
    String id,
    Map<String, dynamic> body,
  ) =>
      _repository.updateBom(id, body);
}

@injectable
class DeleteBomUseCase {
  const DeleteBomUseCase(this._repository);

  final ManufacturingRepository _repository;

  Future<Either<Failure, void>> call(String id) => _repository.deleteBom(id);
}

@injectable
class PreviewBomUseCase {
  const PreviewBomUseCase(this._repository);

  final ManufacturingRepository _repository;

  Future<Either<Failure, BomPreviewModel>> call({
    required String bomHeaderId,
    required String qtyToProduce,
  }) =>
      _repository.previewBom(
        bomHeaderId: bomHeaderId,
        qtyToProduce: qtyToProduce,
      );
}

@injectable
class ListProductionOrdersUseCase {
  const ListProductionOrdersUseCase(this._repository);

  final ManufacturingRepository _repository;

  Future<Either<Failure, List<ProductionOrderModel>>> call({
    String? branchId,
    String? status,
    String? bomHeaderId,
    int skip = 0,
    int limit = 50,
  }) =>
      _repository.listProductionOrders(
        branchId: branchId,
        status: status,
        bomHeaderId: bomHeaderId,
        skip: skip,
        limit: limit,
      );
}

@injectable
class GetProductionOrderUseCase {
  const GetProductionOrderUseCase(this._repository);

  final ManufacturingRepository _repository;

  Future<Either<Failure, ProductionOrderModel>> call(String id) =>
      _repository.getProductionOrder(id);
}

@injectable
class CreateProductionOrderUseCase {
  const CreateProductionOrderUseCase(this._repository);

  final ManufacturingRepository _repository;

  Future<Either<Failure, ProductionOrderModel>> call(
    Map<String, dynamic> body,
  ) =>
      _repository.createProductionOrder(body);
}

@injectable
class UpdateProductionOrderUseCase {
  const UpdateProductionOrderUseCase(this._repository);

  final ManufacturingRepository _repository;

  Future<Either<Failure, ProductionOrderModel>> call(
    String id,
    Map<String, dynamic> body,
  ) =>
      _repository.updateProductionOrder(id, body);
}

@injectable
class StartProductionOrderUseCase {
  const StartProductionOrderUseCase(this._repository);

  final ManufacturingRepository _repository;

  Future<Either<Failure, ProductionOrderModel>> call(String id) =>
      _repository.startProductionOrder(id);
}

@injectable
class CancelProductionOrderUseCase {
  const CancelProductionOrderUseCase(this._repository);

  final ManufacturingRepository _repository;

  Future<Either<Failure, ProductionOrderModel>> call(String id) =>
      _repository.cancelProductionOrder(id);
}

@injectable
class CompleteProductionOrderUseCase {
  const CompleteProductionOrderUseCase(this._repository);

  final ManufacturingRepository _repository;

  Future<Either<Failure, ProductionOrderModel>> call(
    String id, {
    required String qtyProduced,
  }) =>
      _repository.completeProductionOrder(id, qtyProduced: qtyProduced);
}
