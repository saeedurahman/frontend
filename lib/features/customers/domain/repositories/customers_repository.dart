import 'package:dartz/dartz.dart';
import 'package:decimal/decimal.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/core/utils/decimal_utils.dart';
import 'package:frantend/features/customers/data/models/customer_balance_model.dart';
import 'package:frantend/features/customers/data/models/customer_ledger_entry_model.dart';
import 'package:frantend/features/customers/data/models/customer_model.dart';
import 'package:frantend/features/customers/data/models/customer_payment_response_model.dart';

abstract class CustomersRepository {
  Future<Either<Failure, List<CustomerModel>>> getCustomers({String? search});

  Future<Either<Failure, CustomerModel>> getCustomer(String id);

  Future<Either<Failure, CustomerModel>> createCustomer(
    Map<String, dynamic> body,
  );

  Future<Either<Failure, CustomerModel>> updateCustomer(
    String id,
    Map<String, dynamic> body,
  );

  Future<Either<Failure, CustomerBalanceModel>> getCustomerBalance(
    String customerId,
  );

  Future<Either<Failure, List<CustomerLedgerEntryModel>>> getCustomerLedger(
    String customerId, {
    int? skip,
    int? limit,
  });

  Future<Either<Failure, CustomerPaymentResponseModel>> recordPayment(
    String customerId, {
    required Decimal amount,
    required String paymentMethod,
    String? referenceNo,
    String? notes,
    String? registerShiftId,
  });
}
