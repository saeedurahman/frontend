import 'package:dartz/dartz.dart';
import 'package:decimal/decimal.dart';
import 'package:frantend/core/error/error_handler.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/core/error/user_error_message.dart';
import 'package:frantend/core/offline/local_catalog.dart';
import 'package:frantend/core/offline/offline_writer.dart';
import 'package:frantend/core/offline/repos/local_sale_mapper.dart';
import 'package:frantend/core/sync/sync_store.dart';
import 'package:frantend/core/utils/decimal_utils.dart';
import 'package:frantend/features/cash_register/data/models/cash_register_model.dart';
import 'package:frantend/features/cash_register/data/models/register_shift_model.dart';
import 'package:frantend/features/cash_register/data/models/shift_summary_model.dart';
import 'package:frantend/features/customers/data/models/customer_model.dart';
import 'package:frantend/features/pos/data/datasources/pos_remote_datasource.dart';
import 'package:frantend/features/pos/data/models/discount_scheme_model.dart';
import 'package:frantend/features/pos/data/models/sale_price_preview_model.dart';
import 'package:frantend/features/pos/domain/repositories/pos_repository.dart';
import 'package:frantend/features/pos/domain/utils/pricing_engine.dart';
import 'package:frantend/features/products/data/models/product_model.dart';
import 'package:frantend/features/sales/data/models/sale_response_model.dart';

/// The POS data layer: **one path**. Reads come from the local database,
/// writes are a local record + an outbox op in one transaction. Nothing here
/// waits for, or fails because of, the network - a sale cannot fail for
/// connectivity reasons.
class OfflinePosRepository implements PosRepository {
  OfflinePosRepository({
    required LocalCatalog catalog,
    required OfflineWriter writer,
    required SyncStore store,
    required PosRemoteDataSource remote,
    required ErrorHandler errorHandler,
    required Future<String?> Function() userId,
  })  : _catalog = catalog,
        _writer = writer,
        _store = store,
        _remote = remote,
        _errors = errorHandler,
        _userId = userId;

  final LocalCatalog _catalog;
  final OfflineWriter _writer;
  final SyncStore _store;
  final PosRemoteDataSource _remote;
  final ErrorHandler _errors;
  final Future<String?> Function() _userId;

  @override
  Future<Either<Failure, SaleResponseModel>> createSale(
    Map<String, dynamic> body,
  ) async {
    try {
      final row = await _writer.saveSale(body);
      Map<String, dynamic>? customer;
      final cid = row['customer_id'] as String?;
      if (cid != null) {
        customer = (await _catalog.customer(cid))?.toJson();
      }
      return Right(LocalSaleMapper.toResponse(row, customer: customer));
    } catch (e) {
      // Only a local database problem can land here.
      return Left(CacheFailure(
        'The sale could not be saved on this device: '
        '${UserErrorMessage.clean('$e', fallback: 'storage error')}',
      ));
    }
  }

  @override
  Future<Either<Failure, ProductModel>> getProductByBarcode(String barcode) async {
    final p = await _catalog.productByBarcode(barcode);
    return p == null ? const Left(NotFoundFailure('Barcode not found')) : Right(p);
  }

  @override
  Future<Either<Failure, List<CustomerModel>>> searchCustomers(String query) async =>
      Right(await _catalog.customers(search: query));

  @override
  Future<Either<Failure, CustomerModel>> createCustomer(
    Map<String, dynamic> body,
  ) async {
    try {
      final entity = await _writer.createCustomer(body);
      return Right(CustomerModel.fromJson(entity).copyWith(balance: '0.00'));
    } catch (e) {
      return Left(CacheFailure(
        UserErrorMessage.clean('$e', fallback: 'Could not be saved on this device.'),
      ));
    }
  }

  @override
  Future<Either<Failure, List<CashRegisterModel>>> getRegisters({String? branchId}) async =>
      Right(await _catalog.registers(branchId: branchId));

  /// Creating a register is administration, not counter work: needs the server.
  @override
  Future<Either<Failure, CashRegisterModel>> createRegister(
    Map<String, dynamic> body,
  ) async {
    try {
      return Right(await _remote.createRegister(body));
    } catch (e) {
      return Left(_errors.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, RegisterShiftModel?>> getActiveShift(String registerId) async {
    final user = await _userId();
    if (user == null) return const Right(null);
    final row = await _store.openShiftFor(user, registerId: registerId);
    return Right(row == null ? null : _catalog.shiftModel(row));
  }

  @override
  Future<Either<Failure, RegisterShiftModel>> openShift(
    Map<String, dynamic> body,
  ) async {
    final user = await _userId();
    if (user == null) return const Left(AuthFailure('Not signed in'));
    if (await _store.openShiftFor(user) != null) {
      return const Left(ConflictFailure('You already have an open shift'));
    }
    final registerId = '${body['cash_register_id']}';
    final registers = await _catalog.registers();
    CashRegisterModel? register;
    for (final r in registers) {
      if (r.id == registerId) register = r;
    }
    final row = await _writer.openShift(
      registerId: registerId,
      registerName: register?.name,
      branchId: register?.branchId,
      openingFloat: Decimal.tryParse('${body['opening_float'] ?? 0}') ?? Decimal.zero,
      notes: body['notes'] as String?,
    );
    return Right(_catalog.shiftModel(row, register: register));
  }

  @override
  Future<Either<Failure, ShiftSummaryModel>> getShiftSummary(String shiftId) async =>
      Right(await _catalog.shiftSummary(shiftId));

  @override
  Future<Either<Failure, Decimal?>> getProductPrice(
    String productId,
    String? variationId,
  ) async =>
      Right(await _catalog.price(productId, variationId: variationId));

  @override
  Future<Either<Failure, SalePricePreviewModel>> previewSalePrice(
    Map<String, dynamic> body,
  ) async {
    final schemes = await _catalog.discountSchemes();
    DiscountSchemeModel? scheme;
    for (final s in schemes) {
      if (s.id == body['discount_scheme_id']) scheme = s;
    }
    return Right(LocalPricePreview.compute(body, scheme));
  }

  @override
  Future<Either<Failure, List<DiscountSchemeModel>>> getDiscountSchemes() async {
    final now = _store.now();
    return Right([
      for (final s in await _catalog.discountSchemes())
        if (s.isActive && _withinDates(s, now)) s,
    ]);
  }

  bool _withinDates(DiscountSchemeModel s, DateTime now) {
    final from = DateTime.tryParse(s.validFrom ?? '');
    final to = DateTime.tryParse(s.validTo ?? '');
    if (from != null && now.isBefore(from)) return false;
    if (to != null && now.isAfter(to)) return false;
    return true;
  }
}

/// Discount-scheme preview computed on the device with `PricingEngine`.
abstract final class LocalPricePreview {
  static SalePricePreviewModel compute(
    Map<String, dynamic> body,
    DiscountSchemeModel? scheme,
  ) {
    final raw = [for (final l in (body['lines'] as List)) Map<String, dynamic>.from(l as Map)];
    final subtotals = [
      for (final l in raw)
        PricingEngine.round2(Decimal.parse('${l['qty']}') * Decimal.parse('${l['unit_price']}')),
    ];
    final cartSubtotal = subtotals.fold(Decimal.zero, (a, b) => a + b);
    final value = Decimal.tryParse(scheme?.discountValue ?? '0') ?? Decimal.zero;
    final min = Decimal.tryParse(scheme?.minPurchaseAmount ?? '') ?? Decimal.zero;
    final applies = scheme != null && value > Decimal.zero && cartSubtotal >= min;

    final lines = <SalePricePreviewLineModel>[];
    final amounts = <LineAmounts>[];
    for (var i = 0; i < raw.length; i++) {
      final l = raw[i];
      var pct = Decimal.tryParse('${l['discount_pct'] ?? 0}') ?? Decimal.zero;
      var amt = Decimal.tryParse('${l['discount_amount'] ?? 0}') ?? Decimal.zero;
      if (applies) {
        if (scheme.discountType == 'percentage') {
          pct += value;
        } else if (cartSubtotal > Decimal.zero) {
          amt += PricingEngine.round2(
            DecimalUtils.fromRational(value * subtotals[i] / cartSubtotal),
          );
        }
      }
      final rate = Decimal.tryParse('${l['tax_rate'] ?? 0}') ?? Decimal.zero;
      final calc = PricingEngine.calculateLineTotal(
        qty: Decimal.parse('${l['qty']}'),
        unitPrice: Decimal.parse('${l['unit_price']}'),
        discountPct: pct,
        discountAmount: amt,
        taxRate: rate,
      );
      amounts.add(calc);
      lines.add(SalePricePreviewLineModel(
        productId: '${l['product_id']}',
        variationId: l['variation_id'] as String?,
        qty: '${l['qty']}',
        unitPrice: '${l['unit_price']}',
        lineOrder: i + 1,
        lineSubtotal: DecimalUtils.format(calc.lineSubtotal),
        discountPct: DecimalUtils.format(pct),
        discountAmount: DecimalUtils.format(calc.effectiveDiscount),
        taxRate: DecimalUtils.format(rate),
        taxAmount: DecimalUtils.format(calc.taxAmount),
        lineTotal: DecimalUtils.format(calc.lineTotal),
      ));
    }
    final totals = PricingEngine.calculateSaleTotals(amounts);
    return SalePricePreviewModel(
      discountSchemeId: applies ? scheme.id : null,
      subtotal: DecimalUtils.format(totals['subtotal']!),
      totalDiscount: DecimalUtils.format(totals['total_discount']!),
      totalTax: DecimalUtils.format(totals['total_tax']!),
      totalAmount: DecimalUtils.format(totals['total_amount']!),
      lines: lines,
    );
  }
}
