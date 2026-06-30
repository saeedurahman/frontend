import 'package:dartz/dartz.dart';
import 'package:decimal/decimal.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/features/pos/data/models/customer_model.dart';
import 'package:frantend/features/pos/data/models/discount_scheme_model.dart';
import 'package:frantend/features/pos/data/models/register_shift_model.dart';
import 'package:frantend/features/pos/data/models/sale_price_preview_model.dart';
import 'package:frantend/features/pos/data/models/sale_response_model.dart';
import 'package:frantend/features/pos/domain/repositories/pos_repository.dart';
import 'package:frantend/features/products/data/models/product_model.dart';
import 'package:injectable/injectable.dart';

@injectable
class CreateSaleUseCase {
  const CreateSaleUseCase(this._repository);
  final PosRepository _repository;

  Future<Either<Failure, SaleResponseModel>> call(Map<String, dynamic> body) =>
      _repository.createSale(body);
}

@injectable
class SearchCustomersUseCase {
  const SearchCustomersUseCase(this._repository);
  final PosRepository _repository;

  Future<Either<Failure, List<CustomerModel>>> call(String query) =>
      _repository.searchCustomers(query);
}

@injectable
class CreateCustomerUseCase {
  const CreateCustomerUseCase(this._repository);
  final PosRepository _repository;

  Future<Either<Failure, CustomerModel>> call(Map<String, dynamic> body) =>
      _repository.createCustomer(body);
}

@injectable
class GetActiveShiftUseCase {
  const GetActiveShiftUseCase(this._repository);
  final PosRepository _repository;

  Future<Either<Failure, RegisterShiftModel?>> call(String registerId) =>
      _repository.getActiveShift(registerId);
}

@injectable
class OpenShiftUseCase {
  const OpenShiftUseCase(this._repository);
  final PosRepository _repository;

  Future<Either<Failure, RegisterShiftModel>> call(Map<String, dynamic> body) =>
      _repository.openShift(body);
}

@injectable
class GetShiftSummaryUseCase {
  const GetShiftSummaryUseCase(this._repository);
  final PosRepository _repository;

  Future<Either<Failure, ShiftSummaryModel>> call(String shiftId) =>
      _repository.getShiftSummary(shiftId);
}

@injectable
class LookupBarcodeUseCase {
  const LookupBarcodeUseCase(this._repository);
  final PosRepository _repository;

  Future<Either<Failure, ProductModel>> call(String barcode) =>
      _repository.getProductByBarcode(barcode);
}

@injectable
class GetProductPriceUseCase {
  const GetProductPriceUseCase(this._repository);
  final PosRepository _repository;

  Future<Either<Failure, Decimal?>> call(
    String productId,
    String? variationId,
  ) =>
      _repository.getProductPrice(productId, variationId);
}

@injectable
class GetRegistersUseCase {
  const GetRegistersUseCase(this._repository);
  final PosRepository _repository;

  Future<Either<Failure, List<CashRegisterModel>>> call({String? branchId}) =>
      _repository.getRegisters(branchId: branchId);
}

@injectable
class CreateRegisterUseCase {
  const CreateRegisterUseCase(this._repository);
  final PosRepository _repository;

  Future<Either<Failure, CashRegisterModel>> call(Map<String, dynamic> body) =>
      _repository.createRegister(body);
}

@injectable
class PreviewSalePriceUseCase {
  const PreviewSalePriceUseCase(this._repository);
  final PosRepository _repository;

  Future<Either<Failure, SalePricePreviewModel>> call(
    Map<String, dynamic> body,
  ) =>
      _repository.previewSalePrice(body);
}

@injectable
class GetDiscountSchemesUseCase {
  const GetDiscountSchemesUseCase(this._repository);
  final PosRepository _repository;

  Future<Either<Failure, List<DiscountSchemeModel>>> call() =>
      _repository.getDiscountSchemes();
}
