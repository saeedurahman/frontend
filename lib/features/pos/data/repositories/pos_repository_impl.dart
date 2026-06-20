import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:decimal/decimal.dart';
import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
import 'package:frantend/core/database/app_database.dart';
import 'package:frantend/core/database/daos/pending_sales_dao.dart';
import 'package:frantend/core/database/daos/products_dao.dart';
import 'package:frantend/core/error/error_handler.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/core/network/network_info.dart';
import 'package:frantend/core/sync/sync_queue.dart';
import 'package:frantend/core/utils/api_json_utils.dart';
import 'package:frantend/core/utils/uuid_utils.dart';
import 'package:frantend/features/pos/data/datasources/pos_remote_datasource.dart';
import 'package:frantend/features/pos/data/models/customer_model.dart';
import 'package:frantend/features/pos/data/models/register_shift_model.dart';
import 'package:frantend/features/pos/data/models/sale_response_model.dart';
import 'package:frantend/features/pos/domain/repositories/pos_repository.dart';
import 'package:frantend/features/products/data/models/product_model.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: PosRepository)
class PosRepositoryImpl implements PosRepository {
  PosRepositoryImpl({
    required PosRemoteDataSource remoteDataSource,
    required PendingSalesDao pendingSalesDao,
    required ProductsDao productsDao,
    required SyncQueue syncQueue,
    required NetworkInfo networkInfo,
    required ErrorHandler errorHandler,
  })  : _remote = remoteDataSource,
        _pendingSalesDao = pendingSalesDao,
        _productsDao = productsDao,
        _syncQueue = syncQueue,
        _networkInfo = networkInfo,
        _errorHandler = errorHandler;

  final PosRemoteDataSource _remote;
  final PendingSalesDao _pendingSalesDao;
  final ProductsDao _productsDao;
  final SyncQueue _syncQueue;
  final NetworkInfo _networkInfo;
  final ErrorHandler _errorHandler;

  bool _isOfflineError(Object e) {
    if (e is DioException) {
      return e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout ||
          (e.response == null && e.type != DioExceptionType.badResponse);
    }
    return false;
  }

  @override
  Future<Either<Failure, SaleResponseModel>> createSale(
    Map<String, dynamic> body,
  ) async {
    final saleId = body['id'] as String? ?? UuidUtils.v4();
    final payload = {...body, 'id': saleId};

    try {
      final connected = await _networkInfo.isConnected;
      if (!connected) {
        return Right(await _saveOfflineSale(saleId, payload));
      }

      final result = await _remote.createSale(payload);
      if (result.offline) {
        await _persistPendingSale(saleId, payload);
        await _applyOptimisticStock(payload);
      }
      return Right(result);
    } catch (e) {
      if (_isOfflineError(e) || !await _networkInfo.isConnected) {
        try {
          return Right(await _saveOfflineSale(saleId, payload));
        } catch (offlineError) {
          return Left(_errorHandler.mapExceptionToFailure(offlineError));
        }
      }
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  Future<SaleResponseModel> _saveOfflineSale(
    String saleId,
    Map<String, dynamic> payload,
  ) async {
    await _persistPendingSale(saleId, payload);
    await _applyOptimisticStock(payload);

    await _syncQueue.enqueue(
      entityType: 'sales',
      entityId: saleId,
      operation: SyncOperation.create,
      payloadJson: jsonEncode(payload),
      endpoint: '/sales',
      method: 'POST',
    );

    return SaleResponseModel.fromJson(ApiJsonUtils.normalizeSaleResponse({
      ...payload,
      'id': saleId,
      'sale_number': 'OFFLINE-${DateTime.now().millisecondsSinceEpoch}',
      'sale_type': payload['sale_type'] ?? 'pos',
      'sale_status': 'draft',
      'total_amount': _estimateTotal(payload),
      'offline': true,
      'lines': payload['lines'] ?? [],
      'payments': payload['payments'] ?? [],
    }));
  }

  Future<void> _persistPendingSale(
    String saleId,
    Map<String, dynamic> payload,
  ) async {
    await _pendingSalesDao.insertPendingSale(
      PendingSalesTableCompanion.insert(
        id: saleId,
        payloadJson: jsonEncode(payload),
        status: const Value('pending_sync'),
        createdAt: DateTime.now(),
      ),
    );
  }

  Future<void> _applyOptimisticStock(Map<String, dynamic> payload) async {
    final lines = payload['lines'] as List<dynamic>? ?? [];
    for (final line in lines) {
      if (line is! Map<String, dynamic>) continue;
      final productId = line['product_id'] as String?;
      final qtyStr = line['qty']?.toString();
      if (productId == null || qtyStr == null) continue;

      final qty = double.tryParse(qtyStr) ?? 0;
      final existing = await _productsDao.getProductById(productId);
      if (existing != null) {
        await _productsDao.upsertProduct(
          ProductsTableCompanion(
            id: Value(existing.id),
            tenantId: Value(existing.tenantId),
            name: Value(existing.name),
            sku: Value(existing.sku),
            barcode: Value(existing.barcode),
            price: Value(existing.price),
            cost: Value(existing.cost),
            stock: Value((existing.stock - qty).clamp(0, double.infinity)),
            category: Value(existing.category),
            imageUrl: Value(existing.imageUrl),
            isActive: Value(existing.isActive),
            updatedAt: Value(DateTime.now()),
          ),
        );
      }
    }
  }

  String _estimateTotal(Map<String, dynamic> body) {
    final lines = body['lines'] as List<dynamic>? ?? [];
    var total = Decimal.zero;
    for (final line in lines) {
      if (line is! Map) continue;
      final qty = Decimal.tryParse('${line['qty']}') ?? Decimal.zero;
      final price = Decimal.tryParse('${line['unit_price']}') ?? Decimal.zero;
      total += qty * price;
    }
    return total.toStringAsFixed(2);
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
      return Right(await _remote.createCustomer(body));
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
      return Right(await _remote.openShift(body));
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
}
