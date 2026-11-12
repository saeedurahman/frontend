import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:frantend/core/sync/sync_store.dart';
import 'package:frantend/core/utils/decimal_utils.dart';
import 'package:frantend/features/cash_register/data/models/cash_register_model.dart';
import 'package:frantend/features/cash_register/data/models/register_shift_model.dart';
import 'package:frantend/features/cash_register/data/models/shift_summary_model.dart';
import 'package:frantend/features/customers/data/models/customer_model.dart';
import 'package:frantend/features/inventory/data/models/stock_model.dart';
import 'package:frantend/features/pos/data/models/discount_scheme_model.dart';
import 'package:frantend/features/products/data/models/category_model.dart';
import 'package:frantend/features/products/data/models/paginated_products_model.dart';
import 'package:frantend/features/products/data/models/product_list_item_model.dart';
import 'package:frantend/features/products/data/models/product_model.dart';
import 'package:frantend/features/settings/data/models/tax_rate_model.dart';

/// Everything the POS reads, from the local database only (no network).
///
/// Prices and tax come from pulled data; totals are computed on the device
/// with the existing `PricingEngine`; costing, ledgers and official numbers
/// stay the server's job.
class LocalCatalog {
  LocalCatalog(this._store, {required Future<String?> Function() businessId})
      : _businessId = businessId;

  final SyncStore _store;
  final Future<String?> Function() _businessId;

  Future<Map<String, dynamic>> _withBusiness(Map<String, dynamic> data) async {
    if (data['business_id'] != null) return data;
    return {...data, 'business_id': await _businessId() ?? ''};
  }

  // ── products ─────────────────────────────────────────────────────────

  /// Search by name / SKU / barcode, optional category; paged. Uses the
  /// indexed `search_text`, `barcode` and `category_id` columns (never JSON).
  Future<PaginatedProductsModel> products({
    String? search,
    String? categoryId,
    bool activeOnly = true,
    int skip = 0,
    int limit = 50,
  }) async {
    final q = search?.trim().toLowerCase() ?? '';
    final where = <String>[];
    final args = <Object?>[];
    if (activeOnly) where.add('active = 1');
    if (categoryId != null && categoryId.isNotEmpty) {
      where.add('category_id = ?');
      args.add(categoryId);
    }
    if (q.isNotEmpty) {
      where.add(
        "(search_text LIKE ? OR id IN (SELECT parent_id FROM entities "
        "WHERE entity = 'barcode' AND is_deleted = 0 AND barcode LIKE ?))",
      );
      args..add('%$q%')..add('$q%');
    }
    final clause = where.isEmpty ? null : where.join(' AND ');
    final total = await _store.countEntities('product', where: clause, args: args);
    final rows = await _store.entities(
      'product',
      where: clause,
      args: args,
      limit: limit,
      offset: skip,
    );
    final categories = await _categoryNames();
    final items = <ProductListItemModel>[];
    for (final p in rows) {
      final data = await _withBusiness(p);
      items.add(ProductListItemModel.fromJson({
        ...data,
        'product_type': data['product_type'] ?? 'standard',
        'tracking_type': data['tracking_type'] ?? 'none',
      }).copyWith(categoryName: categories['${data['category_id']}']));
    }
    return PaginatedProductsModel(total: total, skip: skip, limit: limit, items: items);
  }

  Future<Map<String, String>> _categoryNames() async {
    final all = await _store.entities('category');
    return {for (final c in all) '${c['id']}': '${c['name']}'};
  }

  Future<ProductModel?> product(String id) async {
    final p = await _store.entity('product', id);
    if (p == null) return null;
    final variations = await _store.entities('product_variation',
        where: 'parent_id = ?', args: [id], orderBy: 'search_text');
    final barcodes = await _store.entities('barcode',
        where: 'parent_id = ?', args: [id], orderBy: 'barcode');
    final data = await _withBusiness(p);
    final category =
        data['category_id'] == null ? null : await _store.entity('category', '${data['category_id']}');
    final byVariation = <String, List<Map<String, dynamic>>>{};
    final productBarcodes = <Map<String, dynamic>>[];
    for (final b in barcodes) {
      final v = b['variation_id'];
      if (v == null) {
        productBarcodes.add(b);
      } else {
        (byVariation['$v'] ??= []).add(b);
      }
    }
    // Units decide whether the POS sells fractions (kg, litre) of the item.
    final units = <String, Map<String, dynamic>?>{};
    Future<Map<String, dynamic>?> unit(Object? id) async {
      if (id == null) return null;
      if (!units.containsKey('$id')) {
        final u = await _store.entity('unit', '$id');
        units['$id'] = u == null || u['name'] == null || u['symbol'] == null
            ? null
            : await _withBusiness(u);
      }
      return units['$id'];
    }

    final baseUnit = await unit(data['base_unit_id']);
    return ProductModel.fromJson({
      ...data,
      'product_type': data['product_type'] ?? 'standard',
      'tracking_type': data['tracking_type'] ?? 'none',
      if (category != null) 'category': await _withBusiness(category),
      if (baseUnit != null) 'base_unit': baseUnit,
      'variations': [
        for (final v in variations)
          {
            ...await _withBusiness(v),
            'barcodes': byVariation['${v['id']}'] ?? const [],
            if (await unit(v['unit_id']) != null) 'unit': await unit(v['unit_id']),
          },
      ],
      'barcodes': productBarcodes,
    });
  }

  Future<ProductModel?> productByBarcode(String code) async {
    final rows = await _store.entities('barcode',
        where: 'barcode = ?', args: [code.trim()], limit: 1, orderBy: 'barcode');
    if (rows.isEmpty) return null;
    return product('${rows.first['product_id']}');
  }

  Future<List<CategoryModel>> categories({String? parentId}) async {
    final all = await _store.entities('category', orderBy: 'search_text');
    final list = <CategoryModel>[];
    for (final c in all) {
      if (c['is_active'] == false) continue;
      final pid = c['parent_id']?.toString();
      if (parentId == null ? pid != null : pid != parentId) continue;
      list.add(CategoryModel.fromJson({
        ...await _withBusiness(c),
        'slug': c['slug'] ?? '${c['name']}'.toLowerCase().replaceAll(' ', '-'),
      }));
    }
    return list;
  }

  // ── prices, tax, discounts ───────────────────────────────────────────

  /// Id of the default (else first active) price list in the pulled data.
  Future<String?> defaultPriceListId() => _defaultPriceListId();

  Future<String?> _defaultPriceListId() async {
    final lists = await _store.entities('price_list');
    Map<String, dynamic>? pick;
    for (final l in lists) {
      if (l['is_active'] == false) continue;
      if (l['is_default'] == true) return '${l['id']}';
      pick ??= l;
    }
    return pick == null ? null : '${pick['id']}';
  }

  /// Unit price for [qty] from the default price list; null when none is set.
  ///
  /// The backend stores a price per product or per variation, so:
  /// * the asked variation's own price wins, else the product-level price;
  /// * with no [variationId] and no product-level price, the default
  ///   variation's price is used (Product edit > Set Price saves it there);
  /// * among those, the highest `min_qty` tier that [qty] reaches, and when
  ///   no tier is reached, the base (lowest `min_qty`) price.
  Future<Decimal?> price(String productId, {String? variationId, Decimal? qty}) async {
    final listId = await _defaultPriceListId();
    if (listId == null) return null;
    final items = [
      for (final i in await _store.entities('price_list_item',
          where: 'parent_id = ?', args: [productId]))
        if ('${i['price_list_id']}' == listId && i['deleted_at'] == null) i,
    ];
    if (items.isEmpty) return null;

    final productLevel = [
      for (final i in items)
        if (i['variation_id'] == null) i,
    ];
    var target = variationId;
    if (target == null && productLevel.isEmpty) {
      target = await _defaultVariationId(productId, items);
    }
    final exact = [
      for (final i in items)
        if (target != null && '${i['variation_id']}' == target) i,
    ];

    final wanted = qty ?? Decimal.one;
    return _tierPrice(exact, wanted) ??
        _tierPrice(productLevel, wanted) ??
        _basePrice(exact) ??
        _basePrice(productLevel);
  }

  /// The product's default variation (else its only one) from pulled data;
  /// falls back to the single variation the price [items] point at.
  Future<String?> _defaultVariationId(
    String productId,
    List<Map<String, dynamic>> items,
  ) async {
    final variations = await _store.entities('product_variation',
        where: 'parent_id = ?', args: [productId]);
    for (final v in variations) {
      if (v['is_default'] == true) return '${v['id']}';
    }
    if (variations.length == 1) return '${variations.first['id']}';
    final priced = {for (final i in items) '${i['variation_id']}'};
    return priced.length == 1 ? priced.first : null;
  }

  static Decimal _minQty(Map<String, dynamic> item) =>
      Decimal.tryParse('${item['min_qty'] ?? 1}') ?? Decimal.one;

  /// Price of the highest tier whose `min_qty` is reached by [wanted].
  static Decimal? _tierPrice(List<Map<String, dynamic>> items, Decimal wanted) {
    Map<String, dynamic>? best;
    for (final i in items) {
      final min = _minQty(i);
      if (min > wanted) continue;
      if (best == null || min > _minQty(best)) best = i;
    }
    return best == null ? null : Decimal.tryParse('${best['unit_price']}');
  }

  /// Price of the lowest tier (used when the quantity reaches none).
  static Decimal? _basePrice(List<Map<String, dynamic>> items) {
    Map<String, dynamic>? base;
    for (final i in items) {
      if (base == null || _minQty(i) < _minQty(base)) base = i;
    }
    return base == null ? null : Decimal.tryParse('${base['unit_price']}');
  }

  /// Writes a price the server just accepted (`POST /prices/lists/{id}/items`)
  /// into the local copy, in the shape the pull delivers, so the POS has it
  /// before the next pull. The pull later replaces the row (same id).
  Future<void> rememberPrice(Map<String, dynamic> item) async {
    final id = item['id']?.toString();
    final listId = item['price_list_id']?.toString();
    if (id == null || listId == null || item['product_id'] == null) return;
    await _store.transaction(() async {
      if (await _store.entity('price_list', listId) == null) {
        // The list itself has not been pulled yet (it was just created).
        final hasDefault = (await _store.entities('price_list'))
            .any((l) => l['is_default'] == true && l['is_active'] != false);
        await _store.putEntity(
          'price_list',
          listId,
          await _withBusiness({
            'id': listId,
            'name': 'Retail',
            'list_type': 'retail',
            'is_default': !hasDefault,
            'is_active': true,
          }),
        );
      }
      await _store.putEntity(
        'price_list_item',
        id,
        await _withBusiness({
          'id': id,
          'price_list_id': listId,
          'product_id': '${item['product_id']}',
          'variation_id': item['variation_id']?.toString(),
          'unit_price': '${item['unit_price']}',
          'min_qty': '${item['min_qty'] ?? '1'}',
        }),
      );
    });
  }

  /// Fires when prices in the local copy changed (a pull or [rememberPrice]).
  Stream<void> get priceChanges => _store.priceChanges;

  Future<List<TaxRateModel>> taxRates() async {
    final rows = await _store.entities('tax_rate');
    return [
      for (final r in rows) TaxRateModel.fromJson(await _withBusiness(r)),
    ];
  }

  Future<List<DiscountSchemeModel>> discountSchemes() async {
    final rows = await _store.entities('discount_scheme');
    return [
      for (final r in rows)
        DiscountSchemeModel.fromJson({
          ...await _withBusiness(r),
          'discount_value': '${r['discount_value']}',
          'min_purchase_amount': r['min_purchase_amount']?.toString(),
        }),
    ];
  }

  Future<Map<String, dynamic>?> settings() async {
    final rows = await _store.entities('settings', limit: 1);
    return rows.isEmpty ? null : rows.first;
  }

  // ── stock ────────────────────────────────────────────────────────────

  /// Pulled balance minus what this device sold since (not yet confirmed).
  /// Null when the server never reported a balance (treated as "unknown").
  Future<Decimal?> availableStock(
    String branchId,
    String productId, {
    String? variationId,
  }) async {
    final pulled = await _store.stockLevel(branchId, productId, variationId: variationId);
    if (pulled == null) return null;
    final pending = await _store.pendingSaleQuantities(branchId);
    final key = variationId == null ? productId : '$productId:$variationId';
    return pulled - (pending[key] ?? Decimal.zero);
  }

  Future<List<StockBalanceModel>> stockBalances(
    String branchId, {
    List<String>? productIds,
  }) async {
    final rows = await _store.stockLevels(branchId, productIds: productIds);
    final pending = await _store.pendingSaleQuantities(branchId);
    return [
      for (final r in rows)
        StockBalanceModel(
          productId: '${r['product_id']}',
          variationId: r['variation_id'] as String?,
          branchId: branchId,
          currentQty: DecimalUtils.format(
            (Decimal.tryParse('${r['qty']}') ?? Decimal.zero) -
                (pending[r['variation_id'] == null
                        ? '${r['product_id']}'
                        : '${r['product_id']}:${r['variation_id']}'] ??
                    Decimal.zero),
            fractionDigits: 4,
          ),
          lastMovementAt: r['last_movement_at'] as String?,
        ),
    ];
  }

  // ── customers ────────────────────────────────────────────────────────

  Future<List<CustomerModel>> customers({String? search, int limit = 50}) async {
    final q = search?.trim().toLowerCase() ?? '';
    final rows = await _store.entities(
      'customer',
      where: q.isEmpty ? 'active = 1' : 'active = 1 AND search_text LIKE ?',
      args: q.isEmpty ? const [] : ['%$q%'],
      limit: limit,
    );
    return [for (final r in rows) await _customer(r)];
  }

  Future<CustomerModel?> customer(String id) async {
    final row = await _store.entity('customer', id);
    return row == null ? null : _customer(row);
  }

  Future<CustomerModel> _customer(Map<String, dynamic> row) async {
    final data = await _withBusiness(row);
    final model = CustomerModel.fromJson(data);
    return model.copyWith(balance: DecimalUtils.format(await customerBalance(model.id)));
  }

  /// Ledger balance as the app uses it everywhere: **negative = the customer
  /// owes us**. Server balance, minus credit sold offline (they owe more),
  /// plus payments taken offline (they owe less).
  Future<Decimal> customerBalance(String id) async {
    final row = await _store.entity('customer', id);
    final server = Decimal.tryParse('${row?['balance'] ?? 0}') ?? Decimal.zero;
    return server -
        await _store.pendingCreditFor(id) +
        await _store.pendingPaymentsFor(id);
  }

  // ── registers & shifts ───────────────────────────────────────────────

  Future<List<CashRegisterModel>> registers({String? branchId}) async {
    final rows = await _store.entities(
      'cash_register',
      where: branchId == null ? null : 'branch_id = ?',
      args: branchId == null ? const [] : [branchId],
    );
    return [
      for (final r in rows)
        if (r['is_active'] != false) CashRegisterModel.fromJson(r),
    ];
  }

  RegisterShiftModel shiftModel(Map<String, Object?> row, {CashRegisterModel? register}) =>
      RegisterShiftModel(
        id: row['id']! as String,
        cashRegisterId: row['register_id']! as String,
        branchId: row['branch_id'] as String?,
        openedBy: row['user_id'] as String?,
        openingFloat: '${row['opening_float'] ?? '0'}',
        actualCash: row['actual_cash'] as String?,
        expectedCash: row['expected_cash'] as String?,
        openedAt: row['opened_at'] as String?,
        closedAt: row['closed_at'] as String?,
        status: '${row['status']}',
        notes: row['notes'] as String?,
        register: register ??
            (row['register_name'] == null
                ? null
                : CashRegisterModel(
                    id: row['register_id']! as String,
                    branchId: '${row['branch_id'] ?? ''}',
                    name: '${row['register_name']}',
                  )),
      );

  /// Cash drawer maths from what happened on this device for [shiftId].
  /// (Server totals replace this once the shift has synced and is re-read.)
  Future<ShiftSummaryModel> shiftSummary(String shiftId) async {
    final shift = await _store.shift(shiftId);
    final sales = await _store.sales(shiftId: shiftId, limit: 100000);
    var cash = Decimal.zero, card = Decimal.zero, wallet = Decimal.zero, other = Decimal.zero;
    for (final s in sales) {
      if (s['status'] != 'completed' || s['sync_state'] == 'discarded') continue;
      for (final p in jsonDecode(s['payments']! as String) as List) {
        final amount = Decimal.tryParse('${(p as Map)['amount']}') ?? Decimal.zero;
        switch ('${p['payment_method']}') {
          case 'cash':
            cash += amount;
          case 'card':
            card += amount;
          case 'wallet':
          case 'upi':
            wallet += amount;
          case 'credit':
            break;
          default:
            other += amount;
        }
      }
    }
    final opening = Decimal.tryParse('${shift?['opening_float'] ?? 0}') ?? Decimal.zero;
    final expected = opening + cash;
    final actual = shift?['actual_cash'] as String?;
    return ShiftSummaryModel(
      shiftId: shiftId,
      status: shift?['status'] as String?,
      openingFloat: DecimalUtils.format(opening),
      totalCashSales: DecimalUtils.format(cash),
      totalCardSales: DecimalUtils.format(card),
      totalWalletSales: DecimalUtils.format(wallet),
      totalOtherSales: DecimalUtils.format(other),
      expectedCash: DecimalUtils.format(expected),
      actualCash: actual,
      cashDifference: actual == null
          ? null
          : DecimalUtils.format(Decimal.parse(actual) - expected),
    );
  }
}
