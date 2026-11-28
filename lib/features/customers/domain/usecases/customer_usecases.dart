import 'package:dartz/dartz.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/features/customers/data/models/customer_balance_model.dart';
import 'package:frantend/features/customers/data/models/customer_ledger_entry_model.dart';
import 'package:frantend/features/customers/data/models/customer_model.dart';
import 'package:frantend/features/customers/domain/pending_ledger.dart';
import 'package:frantend/features/customers/domain/repositories/customers_repository.dart';
import 'package:frantend/features/khata/data/models/khata_models.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetCustomersUseCase {
  const GetCustomersUseCase(this._repository);

  final CustomersRepository _repository;

  Future<Either<Failure, List<CustomerModel>>> call({String? search}) =>
      _repository.getCustomers(search: search);
}

@injectable
class GetCustomerUseCase {
  const GetCustomerUseCase(this._repository);

  final CustomersRepository _repository;

  Future<Either<Failure, CustomerModel>> call(String id) =>
      _repository.getCustomer(id);
}

@injectable
class CreateCustomerUseCase {
  const CreateCustomerUseCase(this._repository);

  final CustomersRepository _repository;

  Future<Either<Failure, CustomerModel>> call(Map<String, dynamic> body) =>
      _repository.createCustomer(body);
}

@injectable
class UpdateCustomerUseCase {
  const UpdateCustomerUseCase(this._repository);

  final CustomersRepository _repository;

  Future<Either<Failure, CustomerModel>> call(
    String id,
    Map<String, dynamic> body,
  ) =>
      _repository.updateCustomer(id, body);
}

@injectable
class GetCustomerBalanceUseCase {
  const GetCustomerBalanceUseCase(this._repository);

  final CustomersRepository _repository;

  Future<Either<Failure, CustomerBalanceModel>> call(
    String customerId, {
    String? branchId,
  }) =>
      _repository.getCustomerBalance(customerId, branchId: branchId);
}

/// Undoes a wrong customer payment (a new row; the original stays visible).
@injectable
class ReverseCustomerPaymentUseCase {
  const ReverseCustomerPaymentUseCase(this._repository);

  final CustomersRepository _repository;

  Future<Either<Failure, PaymentReversalResult>> call(
    String paymentId,
    Map<String, dynamic> body, {
    String? idempotencyKey,
  }) =>
      _repository.reversePayment(paymentId, body, idempotencyKey: idempotencyKey);
}

@injectable
class GetCustomerLedgerUseCase {
  const GetCustomerLedgerUseCase(this._repository);

  final CustomersRepository _repository;

  Future<Either<Failure, List<CustomerLedgerEntryModel>>> call(
    String customerId, {
    String? branchId,
    int? skip,
    int? limit,
  }) =>
      _repository.getCustomerLedger(
        customerId,
        branchId: branchId,
        skip: skip,
        limit: limit,
      );

  /// The account as this device holds it, when it does.
  Future<DeviceLedger?> device(String customerId) async {
    final Object repository = _repository;
    return repository is DeviceLedgerSource
        ? await repository.deviceLedger(customerId)
        : null;
  }

  /// Lines saved on this device that the server does not have yet.
  Future<List<CustomerLedgerEntryModel>> pending(
    String customerId, {
    String? branchId,
  }) async {
    final Object repository = _repository;
    return repository is PendingLedgerSource
        ? await repository.pendingLedger(customerId, branchId: branchId)
        : const [];
  }
}
