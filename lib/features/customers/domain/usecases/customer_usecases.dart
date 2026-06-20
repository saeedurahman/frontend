import 'package:dartz/dartz.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/features/customers/data/models/customer_balance_model.dart';
import 'package:frantend/features/customers/data/models/customer_ledger_entry_model.dart';
import 'package:frantend/features/customers/data/models/customer_model.dart';
import 'package:frantend/features/customers/domain/repositories/customers_repository.dart';
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

  Future<Either<Failure, CustomerBalanceModel>> call(String customerId) =>
      _repository.getCustomerBalance(customerId);
}

@injectable
class GetCustomerLedgerUseCase {
  const GetCustomerLedgerUseCase(this._repository);

  final CustomersRepository _repository;

  Future<Either<Failure, List<CustomerLedgerEntryModel>>> call(
    String customerId, {
    int? skip,
    int? limit,
  }) =>
      _repository.getCustomerLedger(customerId, skip: skip, limit: limit);
}
