import 'package:dartz/dartz.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/features/khata/data/models/khata_models.dart';
import 'package:frantend/features/suppliers/data/models/supplier_model.dart';

abstract class SuppliersRepository {
  Future<Either<Failure, List<SupplierModel>>> getSuppliers();

  Future<Either<Failure, SupplierModel>> getSupplier(String id);

  Future<Either<Failure, SupplierModel>> createSupplier(
    Map<String, dynamic> body,
  );

  Future<Either<Failure, SupplierModel>> updateSupplier(
    String id,
    Map<String, dynamic> body,
  );

  Future<Either<Failure, void>> deleteSupplier(String id);

  Future<Either<Failure, SupplierBalanceModel>> getSupplierBalance(
    String supplierId, {
    String? branchId,
  });

  Future<Either<Failure, SupplierLedgerPage>> getLedger(
    String supplierId, {
    String? branchId,
    int skip = 0,
    int limit = 50,
  });

  Future<Either<Failure, SupplierPaymentResult>> paySupplier(
    Map<String, dynamic> body, {
    String? idempotencyKey,
  });

  Future<Either<Failure, PaymentReversalResult>> reversePayment(
    String paymentId,
    Map<String, dynamic> body, {
    String? idempotencyKey,
  });
}
