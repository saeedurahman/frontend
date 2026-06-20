import 'package:dartz/dartz.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/features/suppliers/data/models/supplier_model.dart';
import 'package:frantend/features/suppliers/domain/repositories/suppliers_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetSuppliersUseCase {
  const GetSuppliersUseCase(this._repository);

  final SuppliersRepository _repository;

  Future<Either<Failure, List<SupplierModel>>> call() =>
      _repository.getSuppliers();
}

@injectable
class GetSupplierUseCase {
  const GetSupplierUseCase(this._repository);

  final SuppliersRepository _repository;

  Future<Either<Failure, SupplierModel>> call(String id) =>
      _repository.getSupplier(id);
}

@injectable
class CreateSupplierUseCase {
  const CreateSupplierUseCase(this._repository);

  final SuppliersRepository _repository;

  Future<Either<Failure, SupplierModel>> call(Map<String, dynamic> body) =>
      _repository.createSupplier(body);
}

@injectable
class UpdateSupplierUseCase {
  const UpdateSupplierUseCase(this._repository);

  final SuppliersRepository _repository;

  Future<Either<Failure, SupplierModel>> call(
    String id,
    Map<String, dynamic> body,
  ) =>
      _repository.updateSupplier(id, body);
}

@injectable
class DeleteSupplierUseCase {
  const DeleteSupplierUseCase(this._repository);

  final SuppliersRepository _repository;

  Future<Either<Failure, void>> call(String id) =>
      _repository.deleteSupplier(id);
}

@injectable
class GetSupplierBalanceUseCase {
  const GetSupplierBalanceUseCase(this._repository);

  final SuppliersRepository _repository;

  Future<Either<Failure, SupplierBalanceModel>> call(String supplierId) =>
      _repository.getSupplierBalance(supplierId);
}
