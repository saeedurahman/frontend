import 'package:dartz/dartz.dart';
import 'package:decimal/decimal.dart';
import 'package:frantend/core/error/error_handler.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/core/utils/decimal_utils.dart';
import 'package:frantend/features/customers/data/datasources/customers_remote_datasource.dart';
import 'package:frantend/features/customers/data/models/customer_balance_model.dart';
import 'package:frantend/features/customers/data/models/customer_ledger_entry_model.dart';
import 'package:frantend/features/customers/data/models/customer_model.dart';
import 'package:frantend/features/customers/data/models/customer_payment_response_model.dart';
import 'package:frantend/features/customers/domain/repositories/customers_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: CustomersRepository)
class CustomersRepositoryImpl implements CustomersRepository {
  CustomersRepositoryImpl({
    required CustomersRemoteDataSource remoteDataSource,
    required ErrorHandler errorHandler,
  })  : _remote = remoteDataSource,
        _errorHandler = errorHandler;

  final CustomersRemoteDataSource _remote;
  final ErrorHandler _errorHandler;

  @override
  Future<Either<Failure, List<CustomerModel>>> getCustomers({
    String? search,
  }) async {
    try {
      final result = await _remote.getCustomers(search: search);
      return Right(result);
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, CustomerModel>> getCustomer(String id) async {
    try {
      final result = await _remote.getCustomer(id);
      return Right(result);
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, CustomerModel>> createCustomer(
    Map<String, dynamic> body,
  ) async {
    try {
      final result = await _remote.createCustomer(body);
      return Right(result);
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, CustomerModel>> updateCustomer(
    String id,
    Map<String, dynamic> body,
  ) async {
    try {
      final result = await _remote.updateCustomer(id, body);
      return Right(result);
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, CustomerBalanceModel>> getCustomerBalance(
    String customerId,
  ) async {
    try {
      final result = await _remote.getCustomerBalance(customerId);
      return Right(result);
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<CustomerLedgerEntryModel>>> getCustomerLedger(
    String customerId, {
    int? skip,
    int? limit,
  }) async {
    try {
      final result = await _remote.getCustomerLedger(
        customerId,
        skip: skip,
        limit: limit,
      );
      return Right(result);
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, CustomerPaymentResponseModel>> recordPayment(
    String customerId, {
    required Decimal amount,
    required String paymentMethod,
    String? referenceNo,
    String? notes,
    String? registerShiftId,
  }) async {
    try {
      final body = <String, dynamic>{
        'amount': DecimalUtils.format(amount),
        'payment_method': paymentMethod,
      };
      if (referenceNo != null && referenceNo.isNotEmpty) {
        body['reference_no'] = referenceNo;
      }
      if (notes != null && notes.isNotEmpty) {
        body['notes'] = notes;
      }
      if (registerShiftId != null && registerShiftId.isNotEmpty) {
        body['register_shift_id'] = registerShiftId;
      }
      final result = await _remote.recordPayment(customerId, body);
      return Right(result);
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }
}
