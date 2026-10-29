import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:frantend/core/connectivity/connectivity_probe.dart';
import 'package:frantend/core/identity/id_generator.dart';
import 'package:frantend/core/utils/decimal_utils.dart';
import 'package:frantend/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:frantend/features/auth/data/models/user_model.dart';
import 'package:frantend/features/auth/domain/utils/user_role_utils.dart';
import 'package:frantend/features/pos/data/models/cart_item_model.dart';
import 'package:frantend/features/pos/data/models/held_order_model.dart';
import 'package:frantend/features/pos/data/models/held_order_storage_mapper.dart';
import 'package:frantend/features/pos/domain/errors/pos_errors.dart';
import 'package:frantend/features/pos/data/models/payment_line_model.dart';
import 'package:frantend/features/pos/domain/repositories/barcode_cache_repository.dart';
import 'package:frantend/features/pos/domain/repositories/held_orders_repository.dart';
import 'package:frantend/features/pos/domain/usecases/pos_usecases.dart';
import 'package:frantend/features/products/data/models/product_model.dart';
import 'package:frantend/features/products/domain/usecases/get_product_by_id_usecase.dart';
import 'package:frantend/features/settings/data/models/tax_rate_model.dart';

// ── Session / permissions ────────────────────────────────────────────────

/// What the POS screen may do for the signed-in user, decided once.
class PosSession {
  const PosSession({
    required this.user,
    required this.canCreateSales,
    required this.canOpenShift,
    required this.canCloseShift,
    required this.canEditLineTax,
    required this.isOffline,
  });

  final UserModel? user;
  final bool canCreateSales;
  final bool canOpenShift;
  final bool canCloseShift;
  final bool canEditLineTax;
  final bool isOffline;
}

/// Loads the cached user and turns role + permission keys into the POS
/// capabilities, so neither the cubit nor the widgets evaluate permissions.
class ResolvePosSessionUseCase {
  const ResolvePosSessionUseCase(this._auth, this._probe);

  final AuthLocalDataSource _auth;
  final ConnectivityProbe _probe;

  Future<PosSession> call() async {
    final user = await _auth.getCachedUser();
    final keys = user?.permissionKeys ?? const <String>[];
    final role = user?.role;
    return PosSession(
      user: user,
      canCreateSales:
          UserRoleUtils.canCreateSales(role: role, permissionKeys: keys),
      canOpenShift:
          UserRoleUtils.canOpenShift(role: role, permissionKeys: keys),
      canCloseShift:
          UserRoleUtils.canCloseShift(role: role, permissionKeys: keys),
      canEditLineTax:
          UserRoleUtils.canEditLineTax(role: role, permissionKeys: keys),
      isOffline: !_probe.isReachable,
    );
  }
}

// ── Shift rules ──────────────────────────────────────────────────────────

abstract final class ShiftPolicy {
  static const noPermission = 'You do not have permission to open a shift.';
  static const noRegister = 'Select a cash register to open a shift.';

  /// Why a shift cannot be opened, or null when it can.
  static String? openBlocker({
    required bool canOpenShift,
    required String? registerId,
  }) {
    if (!canOpenShift) return noPermission;
    if (registerId == null) return noRegister;
    return null;
  }

  static Map<String, dynamic> openBody({
    required String registerId,
    required Decimal openingFloat,
    String? notes,
  }) =>
      {
        'cash_register_id': registerId,
        'opening_float': DecimalUtils.format(openingFloat),
        if (notes != null && notes.isNotEmpty) 'notes': notes,
      };
}

// ── Stock rules ──────────────────────────────────────────────────────────

abstract final class LowStockPolicy {
  static final Decimal defaultThreshold = Decimal.fromInt(5);

  /// Warning to show after adding, or null when stock is comfortable/unknown.
  static String? warning({
    required String productName,
    required String? minStockLevel,
    required Decimal? available,
    required Decimal requested,
  }) {
    if (available == null) return null;
    final min = Decimal.tryParse(minStockLevel ?? '');
    final threshold = min != null && min > Decimal.zero ? min : defaultThreshold;
    final remaining = available - requested;
    if (remaining > threshold) return null;
    final left = remaining < Decimal.zero ? Decimal.zero : remaining;
    return 'Low stock: $productName - '
        '${DecimalUtils.format(left, fractionDigits: 0)} left after this sale';
  }
}

// ── Payments ─────────────────────────────────────────────────────────────

abstract final class PaymentCoverage {
  /// Payment lines must add up to exactly what is due before anything is sent.
  static void assertCovers({
    required List<PaymentLineModel> payments,
    required Decimal due,
  }) {
    final paid = payments.fold(Decimal.zero, (sum, p) => sum + p.amount);
    if (paid != due) {
      throw PaymentMismatchException(
        'Payments (${DecimalUtils.format(paid)}) do not match the total '
        '(${DecimalUtils.format(due)}).',
      );
    }
  }
}

/// Gives a retried sale the same id.
///
/// A failed attempt keeps its id, so tapping "Complete Sale" again for the
/// same cart + payments re-sends the *same* sale and the API dedupes on it. A
/// changed cart or payment is a new sale with a new id.
class SaleAttemptTracker {
  SaleAttemptTracker(this._ids);

  final IdGenerator _ids;
  String? _fingerprint;
  String? _saleId;
  List<String> _paymentIds = const [];

  String idFor(Map<String, dynamic> body) {
    final fingerprint = jsonEncode(body);
    if (_fingerprint != fingerprint || _saleId == null) {
      _fingerprint = fingerprint;
      _saleId = _ids.saleId();
      final payments = body['payments'];
      _paymentIds = [
        if (payments is List) for (final _ in payments) _ids.paymentId(),
      ];
    }
    return _saleId!;
  }

  /// [body] with the sale id and one id per payment line. A retry of the same
  /// cart + payments gets the *same* ids; anything else gets fresh ones.
  Map<String, dynamic> stamp(Map<String, dynamic> body) {
    final saleId = idFor(body);
    final payments = body['payments'];
    return {
      ...body,
      'id': saleId,
      if (payments is List)
        'payments': [
          for (var i = 0; i < payments.length; i++)
            if (payments[i] is Map<String, dynamic>)
              {
                ...payments[i] as Map<String, dynamic>,
                'id': _paymentIds[i],
              }
            else
              payments[i],
        ],
    };
  }

  /// The sale went through; the next one is a fresh sale.
  void completed() {
    _fingerprint = null;
    _saleId = null;
    _paymentIds = const [];
  }
}

// ── Barcode ──────────────────────────────────────────────────────────────

class ResolveBarcodeUseCase {
  const ResolveBarcodeUseCase(this._cache, this._lookup, this._getProduct);

  final BarcodeCacheRepository _cache;
  final LookupBarcodeUseCase _lookup;
  final GetProductByIdUseCase _getProduct;

  static ProductModel? findInMemory(
    Iterable<ProductModel> products,
    String barcode,
  ) {
    for (final product in products) {
      final inProduct = product.barcodes.any((b) => b.barcode == barcode);
      final inVariation = product.variations.any(
        (v) => v.barcodes.any((b) => b.barcode == barcode),
      );
      if (inProduct || inVariation) return product;
    }
    return null;
  }

  /// memory -> local cache -> server. A hit from memory/cache is returned
  /// immediately with [fromCache] set so the caller can refresh it quietly.
  Future<({ProductModel? product, bool fromCache})> call({
    required String barcode,
    required String tenantKey,
    required Iterable<ProductModel> memory,
  }) async {
    final code = barcode.trim();
    if (code.isEmpty) return (product: null, fromCache: false);

    final cached =
        findInMemory(memory, code) ?? await _cache.find(tenantKey, code);
    if (cached != null) return (product: cached, fromCache: true);

    final result = await _lookup(code);
    return result.fold(
      (_) => (product: null, fromCache: false),
      (product) {
        // Not awaited on purpose: remembering must not slow the scan.
        _cache.remember(tenantKey, code, product);
        return (product: product, fromCache: false);
      },
    );
  }

  /// Re-fetches [productId] and refreshes the cache entry; null on failure.
  Future<ProductModel?> refresh({
    required String barcode,
    required String tenantKey,
    required String productId,
  }) async {
    final result = await _getProduct(productId);
    return result.fold((_) => null, (fresh) async {
      await _cache.remember(tenantKey, barcode, fresh);
      return fresh;
    });
  }
}

// ── Held orders ──────────────────────────────────────────────────────────

abstract final class HeldOrderLabels {
  /// `Order 14:32:05`, or the cashier's own label; a numeric suffix keeps it
  /// unique among the parked orders.
  static String unique(String? custom, DateTime now, Iterable<String> existing) {
    String two(int v) => v.toString().padLeft(2, '0');
    final trimmed = custom?.trim();
    final base = trimmed != null && trimmed.isNotEmpty
        ? trimmed
        : 'Order ${two(now.hour)}:${two(now.minute)}:${two(now.second)}';
    final taken = existing.map((l) => l.toLowerCase()).toSet();
    if (!taken.contains(base.toLowerCase())) return base;
    var n = 2;
    while (taken.contains('$base ($n)'.toLowerCase())) {
      n++;
    }
    return '$base ($n)';
  }
}

/// A parked order after re-pricing, with every change it went through.
class ResumedHeldOrder {
  const ResumedHeldOrder({
    required this.order,
    required this.items,
    required this.changes,
  });

  final HeldOrderModel order;
  final List<CartItemModel> items;
  final List<String> changes;
}

/// Park / list / resume / discard carts. All rules live here: the cubit only
/// passes state in and shows the result.
class HeldOrdersUseCases {
  HeldOrdersUseCases(
    this._repository,
    this._getProductPrice,
    this._ids, {
    DateTime Function()? clock,
  }) : _clock = clock ?? DateTime.now;

  final HeldOrdersRepository _repository;
  final GetProductPriceUseCase _getProductPrice;
  final IdGenerator _ids;
  final DateTime Function() _clock;

  Future<List<HeldOrderModel>> list(HeldOrderScope scope) =>
      _repository.list(scope);

  Future<HeldOrderModel> hold({
    required HeldOrderScope scope,
    required List<CartItemModel> items,
    required Iterable<String> existingLabels,
    required Decimal total,
    String? customLabel,
    String? customerId,
    String? customerName,
    String? discountType,
    Decimal? discountValue,
  }) async {
    final now = _clock();
    final order = HeldOrderModel(
      id: _ids.heldOrderId(),
      label: HeldOrderLabels.unique(customLabel, now, existingLabels),
      createdAt: now,
      cartItems: List<CartItemModel>.from(items),
      customerId: customerId,
      customerName: customerName,
      cartDiscountType: discountType,
      cartDiscountValue:
          discountValue != null && discountValue > Decimal.zero
              ? discountValue
              : null,
      itemCount: items.length,
      totalAmount: total,
    );
    await _repository.save(order, scope);
    return order;
  }

  Future<void> discard(String id, HeldOrderScope scope) async {
    final held = await _repository.find(id, scope);
    if (held != null) await _repository.delete(id);
  }

  /// Loads a parked order and re-prices it against today's prices and tax
  /// table. Does not delete it: call [discard] once the cart took it over.
  Future<ResumedHeldOrder?> resume({
    required String id,
    required HeldOrderScope scope,
    required List<TaxRateModel> taxRates,
    required TaxRateModel? defaultTaxRate,
  }) async {
    final held = await _repository.find(id, scope);
    if (held == null) return null;
    final (items, changes) = await refreshItems(
      held.cartItems,
      taxRates: taxRates,
      defaultTaxRate: defaultTaxRate,
    );
    return ResumedHeldOrder(order: held, items: items, changes: changes);
  }

  /// Re-prices items against today's prices and tax table and lists every
  /// change so the cashier is warned before selling them.
  Future<(List<CartItemModel>, List<String>)> refreshItems(
    List<CartItemModel> items, {
    required List<TaxRateModel> taxRates,
    required TaxRateModel? defaultTaxRate,
  }) async {
    final changes = <String>[];
    final refreshed = <CartItemModel>[];
    var priceLookupFailed = false;

    for (final item in items) {
      var next = item;

      // Tax: always the current tax table, never the parked snapshot.
      if (item.taxRateId != null) {
        TaxRateModel? current;
        for (final rate in taxRates) {
          if (rate.id == item.taxRateId) current = rate;
        }
        current ??= defaultTaxRate;
        if (current == null) {
          next = next.copyWith(clearTax: true);
          changes.add('${item.productName}: tax rate no longer exists, '
              'tax removed');
        } else {
          final rate = Decimal.tryParse(current.rate) ?? Decimal.zero;
          if (current.id != item.taxRateId || rate != item.effectiveTaxRate) {
            changes.add('${item.productName}: tax '
                '${DecimalUtils.format(item.effectiveTaxRate)}% -> '
                '${DecimalUtils.format(rate)}%');
          }
          next = next.copyWith(
            taxRateId: current.id,
            taxRateName: '${current.name} ${current.rate}%',
            taxRate: rate,
          );
        }
      }

      // Price: re-fetched unless the cashier typed it in by hand.
      if (!item.priceManual) {
        final result = await _getProductPrice(item.productId, item.variationId);
        result.fold((_) => priceLookupFailed = true, (price) {
          if (price == null || price <= Decimal.zero) return;
          final unit = price + item.modifierTotalPerUnit;
          if (unit != item.unitPrice) {
            changes.add('${item.productName}: price '
                '${DecimalUtils.format(item.unitPrice)} -> '
                '${DecimalUtils.format(unit)}');
            next = next.copyWith(unitPrice: unit);
          }
        });
      }

      refreshed.add(next);
    }

    if (priceLookupFailed) {
      changes.add('Some prices could not be refreshed; the held prices are '
          'kept. Check the total before payment.');
    }
    return (refreshed, changes);
  }
}
