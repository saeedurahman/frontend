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
import 'package:frantend/features/restaurant/data/models/modifier_group_model.dart';
import 'package:frantend/features/products/data/models/barcode_model.dart';
import 'package:frantend/features/products/data/models/brand_model.dart';
import 'package:frantend/features/products/data/models/category_model.dart';
import 'package:frantend/features/products/data/models/paginated_products_model.dart';
import 'package:frantend/features/products/data/models/product_list_item_model.dart';
import 'package:frantend/features/products/data/models/product_model.dart';
import 'package:frantend/features/products/data/models/unit_model.dart';
import 'package:frantend/features/products/data/models/variation_model.dart';
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
    bool needsAttention = false,
    int skip = 0,
    int limit = 50,
  }) async {
    if (needsAttention) {
      return _productsNeedingAttention(
        search: search,
        categoryId: categoryId,
        activeOnly: activeOnly,
        skip: skip,
        limit: limit,
      );
    }
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

  /// "Needs details": no category, no picture or no price in the default list.
  /// Worked out here (the server does the same online) over the whole local
  /// catalog, then paged.
  Future<PaginatedProductsModel> _productsNeedingAttention({
    String? search,
    String? categoryId,
    required bool activeOnly,
    required int skip,
    required int limit,
  }) async {
    final all = await products(
      search: search,
      categoryId: categoryId,
      activeOnly: activeOnly,
      skip: 0,
      limit: 1000000,
    );
    final defaultList = await _defaultPriceListId();
    final priced = <String>{};
    for (final row in await _store.entities('price_list_item')) {
      if (defaultList != null && '${row['price_list_id']}' != defaultList) continue;
      final price = Decimal.tryParse('${row['unit_price']}');
      if (price != null && price > Decimal.zero) priced.add('${row['product_id']}');
    }
    final flagged = <ProductListItemModel>[];
    for (final p in all.items) {
      final missing = <String>[
        if ((p.categoryId ?? '').isEmpty) 'category',
        if ((p.imageUrl ?? '').isEmpty) 'image',
        if (!priced.contains(p.id)) 'price',
      ];
      if (missing.isNotEmpty) {
        flagged.add(p.copyWith(needsAttention: true, missing: missing));
      }
    }
    final page = flagged.skip(skip).take(limit).toList();
    return PaginatedProductsModel(
      total: flagged.length,
      skip: skip,
      limit: limit,
      items: page,
    );
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

  /// Units pulled to this device (active ones), for pickers that must work
  /// offline.
  Future<List<UnitModel>> units() async {
    final rows = await _store.entities('unit', orderBy: 'search_text');
    return [
      for (final u in rows)
        if (u['is_active'] != false && u['name'] != null && u['symbol'] != null)
          UnitModel.fromJson(await _withBusiness(u)),
    ];
  }

  /// Quick Add writes a barcode row under a made-up id the moment a save
  /// succeeds (the response does not carry the barcode id). Once the pull has
  /// delivered the real row for the same code this removes the made-up twin.
  Future<void> dropSyntheticBarcodes(Iterable<String> productIds) async {
    await _store.transaction(() async {
      for (final pid in productIds) {
        final rows =
            await _store.entities('barcode', where: 'parent_id = ?', args: [pid]);
        final real = {
          for (final b in rows)
            if (!'${b['id']}'.startsWith(syntheticBarcodePrefix)) '${b['barcode']}',
        };
        for (final b in rows) {
          final id = '${b['id']}';
          if (id.startsWith(syntheticBarcodePrefix) && real.contains('${b['barcode']}')) {
            await _store.deleteEntity('barcode', id);
          }
        }
      }
    });
  }

  static const syntheticBarcodePrefix = 'qa:';

  // ── restaurant modifiers (pulled: modifier_group / modifier /
  //    product_modifier_group) ─────────────────────────────────────────────

  /// True once this device holds any pulled modifier data. Distinguishes
  /// "this product has no modifiers" from "modifiers were never synced".
  Future<bool> hasModifierData() async =>
      await _store.countEntities('modifier_group') > 0 ||
      await _store.countEntities('product_modifier_group') > 0;

  /// The product's usable modifier groups (active group, active modifiers),
  /// sorted, from the pulled copy only. Never touches the network.
  Future<List<ModifierGroupModel>> modifierGroupsFor(String productId) async {
    final links = await _store.entities(
      'product_modifier_group',
      where: 'parent_id = ?',
      args: [productId],
      orderBy: 'id',
    );
    final groups = <ModifierGroupModel>[];
    final seen = <String>{};
    for (final link in links) {
      if (link['deleted_at'] != null || link['is_active'] == false) continue;
      final groupId = '${link['modifier_group_id']}';
      if (!seen.add(groupId)) continue;
      final group = await _store.entity('modifier_group', groupId);
      if (group == null ||
          group['is_active'] == false ||
          group['deleted_at'] != null) {
        continue;
      }
      final rows = await _store.entities(
        'modifier',
        where: 'parent_id = ?',
        args: [groupId],
        orderBy: 'search_text',
      );
      final modifiers = [
        for (final m in rows)
          if (m['deleted_at'] == null && m['is_active'] != false)
            {...await _withBusiness(m), 'modifier_group_id': groupId},
      ]..sort((a, b) => _order(a).compareTo(_order(b)));
      final model = ModifierGroupModel.fromJson({
        ...await _withBusiness(group),
        'selection_type': group['selection_type'] ?? 'single',
        'modifiers': modifiers,
      });
      if (model.modifiers.isNotEmpty) groups.add(model);
    }
    groups.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    return groups;
  }

  static int _order(Map<String, dynamic> row) =>
      int.tryParse('${row['sort_order'] ?? 0}') ?? 0;

  // ── prices, tax, discounts ───────────────────────────────────────────

  /// Id of the default (else first active) price list in the pulled data.
  Future<String?> defaultPriceListId() => _defaultPriceListId();

  Future<String?> _defaultPriceListId() async {
    final lists = await _store.entities('price_list');
    Map<String, dynamic>? pick;
    for (final l in lists) {
      if (l['is_active'] == false) continue;
      if (l['is_default'] == true) return '${l['id']}';
      // A list this device only created a stub for (never pulled) must not
      // become "the default" just because it is the first one.
      if (l['_stub'] == true) continue;
      pick ??= l;
    }
    return pick == null ? null : '${pick['id']}';
  }

  bool _isPriceListValid(Map<String, dynamic> list, DateTime now) {
    if (list['is_active'] == false) return false;
    final validFromStr = list['valid_from']?.toString();
    if (validFromStr != null && validFromStr.isNotEmpty) {
      final from = DateTime.tryParse(validFromStr);
      if (from != null && now.isBefore(from)) return false;
    }
    final validToStr = list['valid_to']?.toString();
    if (validToStr != null && validToStr.isNotEmpty) {
      final to = DateTime.tryParse(validToStr);
      if (to != null && now.isAfter(to)) return false;
    }
    return true;
  }

  /// Resolves the effective price list id:
  /// 1. If [priceListId] is provided and valid, returns it.
  /// 2. Else if [customerId] is provided and has an assigned price list that is valid, returns it.
  /// 3. Fallback to default price list.
  Future<String?> effectivePriceListId({
    String? priceListId,
    String? customerId,
    DateTime? now,
  }) async {
    final currentTime = now ?? DateTime.now();
    if (priceListId != null && priceListId.isNotEmpty) {
      final list = await _store.entity('price_list', priceListId);
      if (list != null && _isPriceListValid(list, currentTime)) {
        return priceListId;
      }
    }
    if (customerId != null && customerId.isNotEmpty) {
      final cust = await _store.entity('customer', customerId);
      final custPriceListId = cust?['price_list_id']?.toString();
      if (custPriceListId != null && custPriceListId.isNotEmpty) {
        final list = await _store.entity('price_list', custPriceListId);
        if (list != null && _isPriceListValid(list, currentTime)) {
          return custPriceListId;
        }
      }
    }
    return _defaultPriceListId();
  }

  /// Unit price for [qty] from the effective price list (customer list or explicit list,
  /// with fallback to the default list if inactive, outside validity window, or has no price).
  Future<Decimal?> price(
    String productId, {
    String? variationId,
    Decimal? qty,
    String? priceListId,
    String? customerId,
    DateTime? now,
  }) async {
    final defaultId = await _defaultPriceListId();
    final effectiveId = await effectivePriceListId(
      priceListId: priceListId,
      customerId: customerId,
      now: now,
    );

    // First try the effective price list if available
    if (effectiveId != null) {
      final effectivePrice = await _priceInList(
        productId,
        effectiveId,
        variationId: variationId,
        qty: qty,
      );
      if (effectivePrice != null) return effectivePrice;
    }

    // Fall back to the default price list if effective price list had no price
    if (defaultId != null && defaultId != effectiveId) {
      return _priceInList(
        productId,
        defaultId,
        variationId: variationId,
        qty: qty,
      );
    }
    return null;
  }

  static String? _normalizeVarId(Object? v) {
    if (v == null) return null;
    final s = '$v'.trim();
    return s.isEmpty || s == 'null' ? null : s;
  }

  Future<Decimal?> _priceInList(
    String productId,
    String listId, {
    String? variationId,
    Decimal? qty,
  }) async {
    final items = [
      for (final i in await _store.entities('price_list_item',
          where: 'parent_id = ?', args: [productId]))
        if ('${i['price_list_id']}' == listId && i['deleted_at'] == null) i,
    ];
    if (items.isEmpty) return null;

    final targetVar = _normalizeVarId(variationId);
    final productLevel = [
      for (final i in items)
        if (_normalizeVarId(i['variation_id']) == null) i,
    ];
    var target = targetVar;
    if (target == null && productLevel.isEmpty) {
      target = await _defaultVariationId(productId, items);
    }
    final exact = [
      for (final i in items)
        if (target != null && _normalizeVarId(i['variation_id']) == target) i,
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

  static bool _isNewer(Map<String, dynamic> a, Map<String, dynamic> b) {
    final aId = '${a['id'] ?? ''}';
    final bId = '${b['id'] ?? ''}';
    final aIsPlaceholder = aId.contains('_');
    final bIsPlaceholder = bId.contains('_');
    if (!aIsPlaceholder && bIsPlaceholder) return true;
    if (aIsPlaceholder && !bIsPlaceholder) return false;

    final aTime = DateTime.tryParse('${a['updated_at'] ?? a['created_at'] ?? ''}');
    final bTime = DateTime.tryParse('${b['updated_at'] ?? b['created_at'] ?? ''}');
    if (aTime != null && bTime != null) {
      if (aTime.isAfter(bTime)) return true;
      if (bTime.isAfter(aTime)) return false;
    }
    return false;
  }

  /// Price of the highest tier whose `min_qty` is reached by [wanted].
  /// When multiple items match the same `min_qty`, the newer row is chosen.
  static Decimal? _tierPrice(List<Map<String, dynamic>> items, Decimal wanted) {
    Map<String, dynamic>? best;
    for (final i in items) {
      final min = _minQty(i);
      if (min > wanted) continue;
      if (best == null || min > _minQty(best) || (min == _minQty(best) && _isNewer(i, best))) {
        best = i;
      }
    }
    return best == null ? null : Decimal.tryParse('${best['unit_price']}');
  }

  /// Price of the lowest tier (used when the quantity reaches none).
  /// When multiple items match the same `min_qty`, the newer row is chosen.
  static Decimal? _basePrice(List<Map<String, dynamic>> items) {
    Map<String, dynamic>? base;
    for (final i in items) {
      final min = _minQty(i);
      if (base == null || min < _minQty(base) || (min == _minQty(base) && _isNewer(i, base))) {
        base = i;
      }
    }
    return base == null ? null : Decimal.tryParse('${base['unit_price']}');
  }

  /// The price list that applies to [customerId] (none = walk-in): the
  /// customer's assigned list while it is active and inside its validity
  /// window, else the default list. See [EffectivePriceList].
  Future<EffectivePriceList> effectivePriceList({
    String? customerId,
    DateTime? now,
  }) async {
    final defaultId = await _defaultPriceListId();
    final id = await effectivePriceListId(customerId: customerId, now: now) ??
        defaultId;
    final list = id == null ? null : await _store.entity('price_list', id);
    return EffectivePriceList(
      id: id,
      defaultId: defaultId,
      name: list?['name']?.toString(),
    );
  }

  /// Writes a price the server just accepted into the row of THAT list (a
  /// price saved for one list can never end up in another list's slot).
  ///
  /// The slot is (list, product, variation, min_qty): when a row for it
  /// already exists (pulled, with the server's id) it is updated in place;
  /// writing a second row next to it would leave the old price in play. The
  /// pull later replaces the row by id.
  Future<void> rememberPrice({
    required String listId,
    required String productId,
    String? variationId,
    required String price,
    String minQty = '1',
    String? id,
  }) async {
    final wanted = Decimal.tryParse(minQty) ?? Decimal.one;
    final targetVar = _normalizeVarId(variationId);
    await _store.transaction(() async {
      if (await _store.entity('price_list', listId) == null) {
        // The list itself has not been pulled yet (it was just created). It
        // is a stub: never the default, replaced by the pull.
        await _store.putEntity(
          'price_list',
          listId,
          await _withBusiness({
            'id': listId,
            'name': 'Price list',
            'list_type': 'custom',
            'is_default': false,
            'is_active': true,
            '_stub': true,
          }),
        );
      }

      String? existingId;
      final existingRows = await _store.entities('price_list_item',
          where: 'parent_id = ?', args: [productId]);
      for (final o in existingRows) {
        if ('${o['price_list_id']}' == listId &&
            _normalizeVarId(o['variation_id']) == targetVar &&
            (Decimal.tryParse('${o['min_qty'] ?? 1}') ?? Decimal.one) == wanted) {
          final oId = '${o['id']}';
          if (!oId.contains('_')) {
            existingId = oId;
            break;
          }
          existingId ??= oId;
        }
      }

      final rowId = id ?? existingId ?? '${listId}_${productId}_${targetVar ?? 'base'}_$minQty';

      // Drop any duplicate twin rows with different IDs
      for (final o in existingRows) {
        final oId = '${o['id']}';
        if (oId != rowId &&
            '${o['price_list_id']}' == listId &&
            _normalizeVarId(o['variation_id']) == targetVar &&
            (Decimal.tryParse('${o['min_qty'] ?? 1}') ?? Decimal.one) == wanted) {
          await _store.deleteEntity('price_list_item', oId);
        }
      }

      await _store.putEntity(
        'price_list_item',
        rowId,
        await _withBusiness({
          'id': rowId,
          'price_list_id': listId,
          'product_id': productId,
          'variation_id': targetVar,
          'unit_price': price,
          'min_qty': minQty,
          'updated_at': DateTime.now().toUtc().toIso8601String(),
        }),
      );
    });
  }

  /// [rememberPrice] for a price list item as the server returns it.
  Future<void> rememberPriceItem(Map<String, dynamic> item) async {
    final listId = item['price_list_id']?.toString();
    final productId = item['product_id']?.toString();
    if (listId == null || productId == null) return;
    await rememberPrice(
      listId: listId,
      productId: productId,
      variationId: item['variation_id']?.toString(),
      price: '${item['unit_price']}',
      minQty: '${item['min_qty'] ?? '1'}',
      id: item['id']?.toString(),
    );
  }

  /// Removes a price (the server deleted the item).
  Future<void> forgetPrice(String listId, String itemId) async {
    await _store.transaction(() async {
      final row = await _store.entity('price_list_item', itemId);
      if (row == null || '${row['price_list_id']}' != listId) return;
      _store.notePriceRemoved(row);
      await _store.deleteEntity('price_list_item', itemId);
    });
  }

  /// Writes a price list as the server returned it (create / edit / default /
  /// validity), keeping a single default list locally.
  Future<void> rememberPriceList(Map<String, dynamic> list) async {
    final id = list['id']?.toString();
    if (id == null) return;
    await _store.transaction(() async {
      if (list['is_default'] == true) {
        for (final o in await _store.entities('price_list')) {
          if ('${o['id']}' != id && o['is_default'] == true) {
            await _store.putEntity(
                'price_list', '${o['id']}', {...o, 'is_default': false});
          }
        }
      }
      final data = {
        for (final k in const [
          'id',
          'business_id',
          'name',
          'list_type',
          'is_default',
          'is_active',
          'valid_from',
          'valid_to',
        ])
          if (list.containsKey(k)) k: list[k],
      };
      await _store.putEntity('price_list', id, await _withBusiness(data));
    });
  }

  /// Removes a price list and its items (deleted on the server).
  Future<void> forgetPriceList(String listId) async {
    await _store.transaction(() async {
      for (final i in await _store.entities('price_list_item')) {
        if ('${i['price_list_id']}' == listId) {
          _store.notePriceRemoved(i);
          await _store.deleteEntity('price_list_item', '${i['id']}');
        }
      }
      _store.notePriceListRemoved(listId);
      await _store.deleteEntity('price_list', listId);
    });
  }

  // ── write-through of catalog changes made on this device ───────────────
  //
  // The products screens talk to the server, but the POS grid, pickers and
  // every offline read use this local copy. A change the server has accepted is
  // written here in the same shape a pull delivers (so the next pull simply
  // confirms it) and announced through [changes], so open screens update at
  // once instead of at the next scheduled pull.

  static Map<String, dynamic> _productRow(ProductModel p) => {
        'id': p.id,
        'business_id': p.businessId,
        'name': p.name,
        'sku': p.sku,
        'product_type': p.productType,
        'tracking_type': p.trackingType,
        'is_sellable': p.isSellable,
        'is_purchasable': p.isPurchasable,
        'is_active': p.isActive,
        'description': p.description,
        'image_url': p.imageUrl,
        'tax_rate_id': p.taxRateId,
        'is_tax_exempt': p.isTaxExempt,
        'track_expiry': p.trackExpiry,
        'name_secondary': p.nameSecondary,
        'shelf_life_days': p.shelfLifeDays,
        'min_stock_level': p.minStockLevel,
        'max_stock_level': p.maxStockLevel,
        'category_id': p.category?.id,
        'brand_id': p.brand?.id,
        'base_unit_id': p.baseUnit?.id,
        'created_at': p.createdAt,
        'updated_at': p.updatedAt,
      };

  static Map<String, dynamic> _variationRow(VariationModel v, String productId) => {
        'id': v.id,
        'business_id': v.businessId,
        'product_id': v.productId.isEmpty ? productId : v.productId,
        'name': v.name,
        'sku': v.sku,
        'unit_id': v.unitId,
        'is_default': v.isDefault,
        'is_active': v.isActive,
        'weight_grams': v.weightGrams,
      };

  static Map<String, dynamic> _barcodeRow(BarcodeModel b, String businessId) => {
        'id': b.id,
        'business_id': businessId,
        'product_id': b.productId,
        'variation_id': b.variationId,
        'barcode': b.barcode,
        'barcode_type': b.barcodeType,
        'is_primary': b.isPrimary,
      };

  Future<String> _bizId(String? fromRow) async =>
      (fromRow != null && fromRow.isNotEmpty) ? fromRow : (await _businessId()) ?? '';

  /// A whole product as the server returned it (create / edit / read): the
  /// product row, exactly its variations and exactly its barcodes.
  Future<void> rememberProduct(ProductModel p) async {
    final biz = await _bizId(p.businessId);
    await _store.transaction(() async {
      // Reference rows the product points at, if this device has not pulled
      // them yet (never over a pulled row: it may be fuller than the brief).
      final c = p.category;
      if (c != null && await _store.entity('category', c.id) == null) {
        await _store.putEntity('category', c.id, {
          'id': c.id,
          'business_id': biz,
          'parent_id': c.parentId,
          'name': c.name,
          'is_active': true,
        });
      }
      final b = p.brand;
      if (b != null && await _store.entity('brand', b.id) == null) {
        await _store.putEntity('brand', b.id,
            {'id': b.id, 'business_id': biz, 'name': b.name, 'is_active': b.isActive});
      }
      final u = p.baseUnit;
      if (u != null && await _store.entity('unit', u.id) == null) {
        await _store.putEntity('unit', u.id, {
          'id': u.id,
          'business_id': biz,
          'name': u.name,
          'symbol': u.symbol,
          'is_base_unit': u.isBaseUnit,
          'allows_decimal': u.allowsDecimal,
          'is_active': u.isActive,
        });
      }

      await _store.putEntity('product', p.id, {..._productRow(p), 'business_id': biz});

      final variationIds = <String>{};
      for (final v in p.variations) {
        variationIds.add(v.id);
        await _store.putEntity(
            'product_variation', v.id, {..._variationRow(v, p.id), 'business_id': biz});
      }
      for (final old in await _store.entities('product_variation',
          where: 'parent_id = ?', args: [p.id])) {
        final id = '${old['id']}';
        if (!variationIds.contains(id)) await _store.deleteEntity('product_variation', id);
      }

      final barcodes = <String, BarcodeModel>{
        for (final v in p.variations)
          for (final b in v.barcodes) b.id: b,
        for (final b in p.barcodes) b.id: b,
      };
      for (final b in barcodes.values) {
        await _store.putEntity('barcode', b.id, _barcodeRow(b, biz));
      }
      for (final old
          in await _store.entities('barcode', where: 'parent_id = ?', args: [p.id])) {
        final id = '${old['id']}';
        if (!barcodes.containsKey(id)) await _store.deleteEntity('barcode', id);
      }
    });
  }

  /// A product the server deleted, with its variations and barcodes.
  Future<void> forgetProduct(String productId) async {
    await _store.transaction(() async {
      for (final v in await _store.entities('product_variation',
          where: 'parent_id = ?', args: [productId])) {
        await _store.deleteEntity('product_variation', '${v['id']}');
      }
      for (final b
          in await _store.entities('barcode', where: 'parent_id = ?', args: [productId])) {
        await _store.deleteEntity('barcode', '${b['id']}');
      }
      await _store.deleteEntity('product', productId);
    });
  }

  /// One variation created or edited on its own.
  Future<void> rememberVariation(VariationModel v, String productId) async {
    final biz = await _bizId(v.businessId);
    await _store.transaction(() async {
      await _store.putEntity(
          'product_variation', v.id, {..._variationRow(v, productId), 'business_id': biz});
      for (final b in v.barcodes) {
        await _store.putEntity('barcode', b.id, _barcodeRow(b, biz));
      }
    });
  }

  /// One barcode added on its own.
  Future<void> rememberBarcode(BarcodeModel b) async {
    final biz = await _bizId(null);
    await _store.transaction(() async {
      await _store.putEntity('barcode', b.id, _barcodeRow(b, biz));
    });
  }

  Future<void> rememberCategory(CategoryModel c) async {
    final biz = await _bizId(c.businessId);
    await _store.transaction(() async {
      await _store.putEntity('category', c.id, {
        'id': c.id,
        'business_id': biz,
        'parent_id': c.parentId,
        'name': c.name,
        'slug': c.slug,
        'sort_order': c.sortOrder,
        'is_active': c.isActive,
      });
    });
  }

  Future<void> forgetCategory(String id) =>
      _store.transaction(() => _store.deleteEntity('category', id));

  Future<void> rememberBrand(BrandModel b) async {
    final biz = await _bizId(b.businessId);
    await _store.transaction(() async {
      await _store.putEntity('brand', b.id,
          {'id': b.id, 'business_id': biz, 'name': b.name, 'is_active': b.isActive});
    });
  }

  Future<void> forgetBrand(String id) =>
      _store.transaction(() => _store.deleteEntity('brand', id));

  Future<void> rememberUnit(UnitModel u) async {
    final biz = await _bizId(u.businessId);
    await _store.transaction(() async {
      await _store.putEntity('unit', u.id, {
        'id': u.id,
        'business_id': biz,
        'name': u.name,
        'symbol': u.symbol,
        'is_base_unit': u.isBaseUnit,
        'allows_decimal': u.allowsDecimal,
        'is_active': u.isActive,
      });
    });
  }

  /// Fires when prices in the local copy changed (a pull or a price saved on
  /// this device), with the list (and product) it concerned.
  Stream<PriceChange> get priceChanges => _store.priceChanges;

  /// Fires when the stock the POS shows changed: a pulled balance, a sale
  /// saved or synced on this device, a return or a void.
  Stream<void> get stockChanges => _store.stockChanges;

  /// Fires after every committed local change (badges, lists).
  Stream<void> get changes => _store.changes;

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

  /// Pulled balance minus what this device sold that the balance does not
  /// include yet (see `SyncStore.pendingSaleQuantities`).
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

  /// Customers created on this device that the server has not accepted yet.
  Future<Set<String>> unsyncedCustomerIds() => _store.unsyncedCustomerIds();

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
    return await pulledBalance(id) -
        await _store.pendingCreditFor(id) +
        await _store.pendingPaymentsFor(id);
  }

  /// The ledger balance exactly as the server last delivered it, in the
  /// app's convention (**negative = the customer owes us**).
  ///
  /// Backend contract (README "Customer Ledger Balance Convention"): `balance`
  /// is `payments - credit sales`, so `< 0` means the customer owes the shop,
  /// and `balance_owed` is the explicit positive amount owed (`-balance`).
  /// `balance_owed` is preferred when present (it cannot be misread); the
  /// dedicated `customer_balance` feed wins over the balance riding on the
  /// `customer` row.
  Future<Decimal> pulledBalance(String id) async {
    final row = await _store.entity('customer_balance', id) ??
        await _store.entity('customer', id);
    return balanceOf(row);
  }

  /// [pulledBalance] of one pulled row (`customer` or `customer_balance`).
  static Decimal balanceOf(Map<String, dynamic>? row) {
    if (row == null) return Decimal.zero;
    final owed = Decimal.tryParse('${row['balance_owed'] ?? ''}');
    if (owed != null) return -owed;
    return Decimal.tryParse('${row['balance'] ?? 0}') ?? Decimal.zero;
  }

  /// What the customer owes the shop right now (never negative).
  Future<Decimal> balanceOwed(String id) async {
    final balance = await customerBalance(id);
    return balance < Decimal.zero ? -balance : Decimal.zero;
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

  /// Shift history: the pulled shifts (`register_shift`) merged with the
  /// shifts opened on this device. A shift both sides know is shown from the
  /// local row (it has the device's own, newer, numbers until it syncs).
  Future<List<RegisterShiftModel>> shifts({
    String? branchId,
    String? registerId,
    String? status,
    int skip = 0,
    int limit = 50,
  }) async {
    final byId = <String, RegisterShiftModel>{};
    final registers = {for (final r in await this.registers()) r.id: r};
    for (final data in await _store.entities('register_shift')) {
      final m = _pulledShift(data, registers);
      if (m != null) byId[m.id] = m;
    }
    for (final row in await _store.shifts()) {
      byId['${row['id']}'] = await shiftModelWithTotals(
        row,
        register: registers['${row['register_id']}'],
      );
    }
    final all = byId.values.where((s) {
      if (branchId != null && s.branchId != branchId) return false;
      if (registerId != null && s.cashRegisterId != registerId) return false;
      if (status != null && s.status != status) return false;
      return true;
    }).toList()
      ..sort((a, b) => '${b.openedAt}'.compareTo('${a.openedAt}'));
    return all.skip(skip).take(limit).toList();
  }

  Future<RegisterShiftModel?> shiftById(String id) async {
    final registers = {for (final r in await this.registers()) r.id: r};
    final row = await _store.shift(id);
    if (row != null) {
      return shiftModelWithTotals(row, register: registers['${row['register_id']}']);
    }
    final data = await _store.entity('register_shift', id);
    return data == null ? null : _pulledShift(data, registers);
  }

  RegisterShiftModel? _pulledShift(
    Map<String, dynamic> data,
    Map<String, CashRegisterModel> registers,
  ) {
    final id = data['id']?.toString();
    final registerId = (data['cash_register_id'] ?? data['register_id'])?.toString();
    if (id == null || registerId == null) return null;
    String? str(String k) => data[k]?.toString();
    return RegisterShiftModel(
      id: id,
      cashRegisterId: registerId,
      branchId: str('branch_id') ?? registers[registerId]?.branchId,
      openedBy: str('opened_by'),
      closedBy: str('closed_by'),
      openedByName: str('opened_by_name'),
      closedByName: str('closed_by_name'),
      openingFloat: str('opening_float') ?? '0',
      expectedCash: str('expected_cash'),
      actualCash: str('actual_cash'),
      cashDifference: str('cash_difference'),
      openedAt: str('opened_at'),
      closedAt: str('closed_at'),
      status: str('status') ?? 'open',
      notes: str('notes'),
      register: registers[registerId],
    );
  }

  /// A local shift with its expected cash and (once closed) the difference.
  Future<RegisterShiftModel> shiftModelWithTotals(
    Map<String, Object?> row, {
    CashRegisterModel? register,
  }) async {
    final base = shiftModel(row, register: register);
    final summary = await shiftSummary('${row['id']}');
    return base.copyWith(
      expectedCash: summary.expectedCash,
      cashDifference: summary.cashDifference,
    );
  }

  /// Totals of a pulled shift (one this device holds no sales for): what the
  /// pulled record carries (opening float, expected, actual, difference and
  /// any per-method totals).
  Future<ShiftSummaryModel?> pulledShiftSummary(String shiftId) async {
    final data = await _store.entity('register_shift', shiftId);
    if (data == null) return null;
    String s(String k) => data[k]?.toString() ?? '0';
    return ShiftSummaryModel(
      shiftId: shiftId,
      status: data['status']?.toString(),
      openingFloat: s('opening_float'),
      totalCashSales: s('total_cash_sales'),
      totalCardSales: s('total_card_sales'),
      totalWalletSales: s('total_wallet_sales'),
      totalOtherSales: s('total_other_sales'),
      totalReturns: s('total_returns'),
      totalCashIn: s('total_cash_in'),
      totalCashOut: s('total_cash_out'),
      totalExpenses: s('total_expenses'),
      expectedCash: s('expected_cash'),
      actualCash: data['actual_cash']?.toString(),
      cashDifference: data['cash_difference']?.toString(),
    );
  }

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

/// The price list in force for a customer (see
/// [LocalCatalog.effectivePriceList]).
class EffectivePriceList {
  const EffectivePriceList({this.id, this.defaultId, this.name});

  final String? id;
  final String? defaultId;
  final String? name;

  /// True when a list other than the default one is in force.
  bool get isSpecial => id != null && id != defaultId;

  @override
  bool operator ==(Object other) =>
      other is EffectivePriceList &&
      other.id == id &&
      other.defaultId == defaultId &&
      other.name == name;

  @override
  int get hashCode => Object.hash(id, defaultId, name);
}
