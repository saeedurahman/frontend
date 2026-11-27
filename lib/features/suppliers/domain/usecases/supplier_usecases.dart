import 'package:dartz/dartz.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/features/khata/data/models/khata_models.dart';
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

  Future<Either<Failure, SupplierBalanceModel>> call(
    String supplierId, {
    String? branchId,
  }) =>
      _repository.getSupplierBalance(supplierId, branchId: branchId);
}

@injectable
class GetSupplierLedgerUseCase {
  const GetSupplierLedgerUseCase(this._repository);

  final SuppliersRepository _repository;

  Future<Either<Failure, SupplierLedgerPage>> call(
    String supplierId, {
    String? branchId,
    int skip = 0,
    int limit = 50,
    DateTime? dateFrom,
    DateTime? dateTo,
  }) =>
      _repository.getLedger(
        supplierId,
        branchId: branchId,
        skip: skip,
        limit: limit,
        dateFrom: dateFrom,
        dateTo: dateTo,
      );
}

@injectable
class PaySupplierUseCase {
  const PaySupplierUseCase(this._repository);

  final SuppliersRepository _repository;

  Future<Either<Failure, SupplierPaymentResult>> call(
    Map<String, dynamic> body, {
    String? idempotencyKey,
  }) =>
      _repository.paySupplier(body, idempotencyKey: idempotencyKey);
}

@injectable
class ReverseSupplierPaymentUseCase {
  const ReverseSupplierPaymentUseCase(this._repository);

  final SuppliersRepository _repository;

  Future<Either<Failure, PaymentReversalResult>> call(
    String paymentId,
    Map<String, dynamic> body, {
    String? idempotencyKey,
  }) =>
      _repository.reversePayment(
        paymentId,
        body,
        idempotencyKey: idempotencyKey,
      );
}
