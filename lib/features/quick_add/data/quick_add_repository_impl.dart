import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/foundation.dart';
import 'package:frantend/core/connectivity/connectivity_probe.dart';
import 'package:frantend/core/error/error_handler.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/core/offline/local_catalog.dart';
import 'package:frantend/features/products/data/models/barcode_model.dart';
import 'package:frantend/features/products/data/models/category_model.dart';
import 'package:frantend/features/products/data/models/product_model.dart';
import 'package:frantend/features/products/data/models/unit_model.dart';
import 'package:frantend/features/products/data/models/variation_model.dart';
import 'package:frantend/features/quick_add/domain/barcode_normalizer.dart';
import 'package:frantend/features/quick_add/domain/quick_add_models.dart';
import 'package:frantend/features/quick_add/domain/quick_add_repository.dart';
import 'package:frantend/features/quick_add/domain/quick_add_row.dart';
import 'package:frantend/features/quick_add/domain/quick_add_settings.dart';

import 'quick_add_remote_datasource.dart';

/// Quick Add over the offline-first data layer: reads come from the local
/// copy, only the save (and the optional lookup) touch the network.
class QuickAddRepositoryImpl implements QuickAddRepository {
  QuickAddRepositoryImpl({
    required QuickAddRemoteDataSource remote,
    required LocalCatalog catalog,
    required ConnectivityProbe probe,
    required ErrorHandler errorHandler,
    required String? Function() branchId,
    required Future<void> Function() syncNow,
    Future<List<PickOption>> Function()? suppliers,
  })  : _remote = remote,
        _catalog = catalog,
        _probe = probe,
        _errors = errorHandler,
        _branchId = branchId,
        _syncNow = syncNow,
        _suppliers = suppliers;

  final QuickAddRemoteDataSource _remote;
  final LocalCatalog _catalog;
  final ConnectivityProbe _probe;
  final ErrorHandler _errors;
  final String? Function() _branchId;
  final Future<void> Function() _syncNow;
  final Future<List<PickOption>> Function()? _suppliers;

  List<PickOption>? _supplierCache;

  @override
  bool get isOnline => _probe.isReachable;

  @override
  Stream<bool> get onlineChanges =>
      _probe.status.map((s) => s != ReachabilityStatus.offline).distinct();

  @override
  String? get branchId => _branchId();

  // ── settings ─────────────────────────────────────────────────────────

  @override
  Future<QuickAddSettings> settings() async {
    try {
      final row = await _catalog.settings();
      final raw = row?['app_settings'];
      if (raw is Map) return QuickAddSettings.fromMap(raw.cast<String, dynamic>());
    } catch (e) {
      debugPrint('[QuickAdd] could not read local settings: $e');
    }
    return QuickAddSettings.defaults;
  }

  @override
  Stream<QuickAddSettings> get settingsChanges => _catalog.changes
      .asyncMap((_) => settings())
      .distinct((a, b) => mapEquals(a.toValueMap(), b.toValueMap()));

  // ── pickers ──────────────────────────────────────────────────────────

  @override
  Future<QuickAddOptions> options() async {
    final units = <PickOption>[];
    final categories = <PickOption>[];
    try {
      for (final u in await _catalog.units()) {
        units.add(PickOption(u.id, u.name));
      }
      final roots = await _catalog.categories();
      for (final c in roots) {
        categories.add(PickOption(c.id, c.name));
        for (final child in await _catalog.categories(parentId: c.id)) {
          categories.add(PickOption(child.id, '${c.name} › ${child.name}'));
        }
      }
    } catch (e) {
      debugPrint('[QuickAdd] could not read pickers: $e');
    }
    final suppliers = await _loadSuppliers();
    return QuickAddOptions(
      units: units,
      categories: categories,
      suppliers: suppliers,
      defaultUnit: _pickDefaultUnit(units),
    );
  }

  static PickOption? _pickDefaultUnit(List<PickOption> units) {
    for (final u in units) {
      if (u.label.trim().toLowerCase() == 'piece') return u;
    }
    return units.isEmpty ? null : units.first;
  }

  Future<List<PickOption>> _loadSuppliers() async {
    final load = _suppliers;
    if (load == null) return const [];
    if (!isOnline) return _supplierCache ?? const [];
    try {
      _supplierCache = await load().timeout(const Duration(seconds: 3));
    } catch (_) {
      // The picker is only needed for purchase mode, which needs the internet.
    }
    return _supplierCache ?? const [];
  }

  // ── lookup ───────────────────────────────────────────────────────────

  @override
  Future<KnownProduct?> findLocal(NormalizedBarcode barcode) async {
    if (barcode.isEmpty) return null;
    try {
      final candidates = <String>{
        barcode.canonical,
        ...barcode.forms,
        ...barcode.lookupForms,
      }.toList();
      ProductModel? product;
      String? matched;
      for (final code in candidates) {
        product = await _catalog.productByBarcode(code);
        if (product != null) {
          matched = code;
          break;
        }
      }
      if (product == null || !product.isActive) return null;

      final variation = _variationFor(product, matched!);
      final variationId = variation?.id;
      Decimal? price;
      try {
        price = await _catalog.price(product.id, variationId: variationId);
      } catch (_) {}
      Decimal? stock;
      final branch = _branchId();
      if (branch != null) {
        try {
          stock = await _catalog.availableStock(branch, product.id, variationId: variationId);
        } catch (_) {}
      }
      final unit = variation?.unit ?? product.baseUnit;
      return KnownProduct(
        id: product.id,
        name: product.name,
        variationId: variationId,
        unitId: unit?.id,
        unitLabel: unit?.name,
        salePrice: price,
        stockOnHand: stock,
        trackExpiry: product.trackExpiry,
        imageUrl: product.imageUrl,
        brand: product.brand?.name,
        categoryId: product.category?.id,
      );
    } catch (e) {
      debugPrint('[QuickAdd] local lookup failed: $e');
      return null;
    }
  }

  static VariationModel? _variationFor(ProductModel p, String code) {
    for (final v in p.variations) {
      if (v.barcodes.any((b) => b.barcode == code)) return v;
    }
    for (final v in p.variations) {
      if (v.isDefault) return v;
    }
    return p.variations.isEmpty ? null : p.variations.first;
  }

  @override
  Future<ProductLookup?> lookupRemote(
    NormalizedBarcode barcode, {
    Duration timeout = const Duration(milliseconds: 1500),
  }) async {
    if (!isOnline || barcode.isEmpty) return null;
    try {
      return await _remote
          .lookup(barcode.canonical, timeout: timeout)
          .timeout(timeout + const Duration(milliseconds: 250));
    } catch (_) {
      return null; // slow, offline or an error: the barcode is simply new
    }
  }

  // ── save ─────────────────────────────────────────────────────────────

  @override
  Future<Either<Failure, QuickAddResponse>> submit(
    QuickAddRequest request, {
    required String idempotencyKey,
  }) async {
    try {
      return Right(await _remote.submit(request, idempotencyKey: idempotencyKey));
    } catch (e) {
      return Left(_errors.mapExceptionToFailure(e));
    }
  }

  @override
  Future<void> writeThrough(QuickAddRequest request, QuickAddResponse response) async {
    final byId = {for (final r in request.rows) r.id: r};
    final touched = <String>{};
    final createdProducts = <String>{};
    try {
      for (final line in response.lines) {
        final row = byId[line.clientLineId];
        final productId = line.productId;
        if (row == null || !line.ok || productId == null) continue;
        touched.add(productId);
        if (line.outcome == LineOutcome.created) {
          createdProducts.add(productId);
          await _rememberNew(row, line);
        } else if (row.updatePrice && row.salePrice != null) {
          await _rememberPrice(productId, line.variationId, row.salePrice!);
        }
        if (line.outcome == LineOutcome.created &&
            row.salePrice != null &&
            row.salePrice! > Decimal.zero) {
          await _rememberPrice(productId, line.variationId, row.salePrice!);
        }
      }
    } catch (e) {
      debugPrint('[QuickAdd] write-through failed (the pull will catch up): $e');
    }

    // Stock comes only from the server (its stock rows carry server ids), so
    // pull now instead of guessing. A failure here is harmless: the periodic
    // sync delivers the same data.
    try {
      await _syncNow();
      await _catalog.dropSyntheticBarcodes(createdProducts);
    } catch (e) {
      debugPrint('[QuickAdd] sync after save failed: $e');
    }
  }

  Future<void> _rememberNew(QuickAddRow row, QuickAddLineResult line) async {
    final productId = line.productId!;
    final variationId = line.variationId;
    final unit = row.unitId == null
        ? null
        : UnitModel(id: row.unitId!, name: row.unitLabel ?? '', symbol: row.unitLabel ?? '');
    final category = row.categoryId == null
        ? null
        : CategoryModel(id: row.categoryId!, name: row.categoryLabel ?? '');
    final barcode = BarcodeModel(
      id: '${LocalCatalog.syntheticBarcodePrefix}$productId:${row.barcode}',
      productId: productId,
      variationId: variationId,
      barcode: row.barcode,
      barcodeType: _barcodeType(row.barcode),
      isPrimary: true,
    );
    final now = DateTime.now().toUtc().toIso8601String();
    final product = ProductModel(
      id: productId,
      businessId: '',
      name: row.name.trim(),
      productType: 'standard',
      trackingType: 'none',
      imageUrl: row.imageUrl,
      taxRateId: row.taxRateId,
      trackExpiry: row.trackExpiry,
      createdAt: now,
      updatedAt: now,
      category: category,
      brand: null, // the pull brings the real brand row; a made-up id must not be stored
      baseUnit: unit,
      variations: variationId == null
          ? const []
          : [
              VariationModel(
                id: variationId,
                productId: productId,
                name: row.name.trim(),
                unitId: row.unitId,
                isDefault: true,
                barcodes: [barcode],
                unit: unit,
              ),
            ],
      barcodes: variationId == null ? [barcode] : const [],
    );
    await _catalog.rememberProduct(product);
  }

  static String _barcodeType(String code) => switch (code.length) {
        8 => 'EAN8',
        12 => 'UPCA',
        13 => 'EAN13',
        14 => 'GTIN14',
        _ => 'CUSTOM',
      };

  Future<void> _rememberPrice(String productId, String? variationId, Decimal price) async {
    final listId = await _catalog.defaultPriceListId();
    if (listId == null) return;
    await _catalog.rememberPrice(
      listId: listId,
      productId: productId,
      variationId: variationId,
      price: price.toString(),
    );
  }
}
