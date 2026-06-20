import 'package:dartz/dartz.dart';
import 'package:decimal/decimal.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/features/pos/data/models/customer_model.dart';
import 'package:frantend/features/pos/data/models/register_shift_model.dart';
import 'package:frantend/features/pos/data/models/sale_response_model.dart';
import 'package:frantend/features/products/data/models/product_model.dart';

abstract class PosRepository {
  Future<Either<Failure, SaleResponseModel>> createSale(
    Map<String, dynamic> body,
  );

  Future<Either<Failure, ProductModel>> getProductByBarcode(String barcode);

  Future<Either<Failure, List<CustomerModel>>> searchCustomers(String query);

  Future<Either<Failure, CustomerModel>> createCustomer(
    Map<String, dynamic> body,
  );

  Future<Either<Failure, List<CashRegisterModel>>> getRegisters({
    String? branchId,
  });

  Future<Either<Failure, CashRegisterModel>> createRegister(
    Map<String, dynamic> body,
  );

  Future<Either<Failure, RegisterShiftModel?>> getActiveShift(
    String registerId,
  );

  Future<Either<Failure, RegisterShiftModel>> openShift(
    Map<String, dynamic> body,
  );

  Future<Either<Failure, ShiftSummaryModel>> getShiftSummary(String shiftId);

  Future<Either<Failure, Decimal?>> getProductPrice(
    String productId,
    String? variationId,
  );
}
