import 'package:dartz/dartz.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/features/purchases/data/models/purchase_order_model.dart';

abstract class PurchasesRepository {
  Future<Either<Failure, List<PurchaseOrderModel>>> getPurchaseOrders();

  Future<Either<Failure, PurchaseOrderModel>> getPurchaseOrder(String id);

  Future<Either<Failure, PurchaseOrderModel>> createPurchaseOrder(
    Map<String, dynamic> body,
  );

  Future<Either<Failure, PurchaseOrderModel>> updatePurchaseOrderStatus(
    String id,
    String status,
  );

  Future<Either<Failure, PurchaseReceiptModel>> createPurchaseReceipt(
    Map<String, dynamic> body,
  );

  Future<Either<Failure, PurchaseReceiptModel>> getPurchaseReceipt(String id);
}
