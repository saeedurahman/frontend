import 'package:dartz/dartz.dart';
import 'package:decimal/decimal.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/features/customers/data/models/customer_balance_model.dart';
import 'package:frantend/features/khata/data/models/khata_models.dart';
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
    String customerId, {
    String? branchId,
  });

  Future<Either<Failure, List<CustomerLedgerEntryModel>>> getCustomerLedger(
    String customerId, {
    String? branchId,
    int? skip,
    int? limit,
  });

  Future<Either<Failure, CustomerPaymentResponseModel>> recordPayment(
    String customerId, {
    required Decimal amount,
    required String paymentSource,
    String? referenceNo,
    String? notes,
    String? registerShiftId,
    String? branchId,
  });

  /// Online only. [body] carries the reason (and the active branch).
  Future<Either<Failure, PaymentReversalResult>> reversePayment(
    String paymentId,
    Map<String, dynamic> body, {
    String? idempotencyKey,
  });
}
