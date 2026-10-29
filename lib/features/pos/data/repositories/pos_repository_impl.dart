import 'package:dartz/dartz.dart';
import 'package:decimal/decimal.dart';
import 'package:frantend/core/identity/client_ids.dart';
import 'package:frantend/core/connectivity/connectivity_probe.dart';
import 'package:frantend/core/error/error_handler.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/core/identity/id_generator.dart';
import 'package:frantend/features/pos/data/datasources/pos_remote_datasource.dart';
import 'package:frantend/features/pos/data/models/customer_model.dart';
import 'package:frantend/features/pos/data/models/register_shift_model.dart';
import 'package:frantend/features/pos/data/models/discount_scheme_model.dart';
import 'package:frantend/features/pos/data/models/sale_price_preview_model.dart';
import 'package:frantend/features/pos/data/models/sale_response_model.dart';
import 'package:frantend/features/pos/domain/repositories/pos_repository.dart';
import 'package:frantend/features/products/data/models/product_model.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: PosRepository)
class PosRepositoryImpl implements PosRepository {
  PosRepositoryImpl({
    required PosRemoteDataSource remoteDataSource,
    required ConnectivityProbe connectivityProbe,
    required ErrorHandler errorHandler,
    IdGenerator? ids,
  })  : _remote = remoteDataSource,
        _probe = connectivityProbe,
        _errorHandler = errorHandler,
        _ids = ids ?? UuidIdGenerator();

  final PosRemoteDataSource _remote;
  final ConnectivityProbe _probe;
  final ErrorHandler _errorHandler;
  final IdGenerator _ids;

  /// Creates the sale on the server. There is no local fallback: until the
  /// sync engine exists (Phase 4b) a sale that could not be sent is reported
  /// as a failure, never as a success. The client-generated sale id makes a
  /// manual retry idempotent.
  @override
  Future<Either<Failure, SaleResponseModel>> createSale(
    Map<String, dynamic> body,
  ) async {
    final saleId = body['id'] as String? ?? _ids.saleId();
    try {
      return Right(await _remote.createSale({...body, 'id': saleId}));
    } catch (e) {
      final failure = _errorHandler.mapExceptionToFailure(e);
      if (failure is NetworkFailure) {
        return Left(NetworkFailure(
          _probe.isReachable
              ? 'The server did not answer. The sale was NOT saved - '
                  'check the connection and try again.'
              : 'You are offline. The sale was NOT saved - '
                  'reconnect and try again.',
        ));
      }
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, ProductModel>> getProductByBarcode(
    String barcode,
  ) async {
    try {
      return Right(await _remote.getProductByBarcode(barcode));
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<CustomerModel>>> searchCustomers(
    String query,
  ) async {
    try {
      return Right(await _remote.searchCustomers(query));
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, CustomerModel>> createCustomer(
    Map<String, dynamic> body,
  ) async {
    try {
      return Right(await _remote.createCustomer(ClientIds.stamp(body)));
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<CashRegisterModel>>> getRegisters({
    String? branchId,
  }) async {
    try {
      return Right(await _remote.getRegisters(branchId: branchId));
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, CashRegisterModel>> createRegister(
    Map<String, dynamic> body,
  ) async {
    try {
      return Right(await _remote.createRegister(body));
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, RegisterShiftModel?>> getActiveShift(
    String registerId,
  ) async {
    try {
      return Right(await _remote.getActiveShift(registerId));
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, RegisterShiftModel>> openShift(
    Map<String, dynamic> body,
  ) async {
    try {
      return Right(await _remote.openShift(ClientIds.stamp(body)));
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, ShiftSummaryModel>> getShiftSummary(
    String shiftId,
  ) async {
    try {
      return Right(await _remote.getShiftSummary(shiftId));
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Decimal?>> getProductPrice(
    String productId,
    String? variationId,
  ) async {
    try {
      return Right(await _remote.getProductPrice(productId, variationId));
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, SalePricePreviewModel>> previewSalePrice(
    Map<String, dynamic> body,
  ) async {
    try {
      return Right(await _remote.previewSalePrice(body));
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<DiscountSchemeModel>>> getDiscountSchemes() async {
    try {
      return Right(await _remote.getDiscountSchemes());
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }
}
