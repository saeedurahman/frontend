import 'package:decimal/decimal.dart';
import 'package:frantend/core/utils/decimal_utils.dart';

import 'quick_add_flow.dart';
import 'quick_add_row.dart';

/// A product of this shop, as the lookup (local data or the server) knows it.
class KnownProduct {
  const KnownProduct({
    required this.id,
    required this.name,
    this.variationId,
    this.unitId,
    this.unitLabel,
    this.salePrice,
    this.costPrice,
    this.stockOnHand,
    this.trackExpiry = false,
    this.imageUrl,
    this.brand,
    this.categoryId,
  });

  final String id;
  final String name;
  final String? variationId;
  final String? unitId;
  final String? unitLabel;
  final Decimal? salePrice;
  final Decimal? costPrice;
  final Decimal? stockOnHand;
  final bool trackExpiry;
  final String? imageUrl;
  final String? brand;
  final String? categoryId;
}

/// Details a catalogue could give for an unknown barcode (the extension point
/// for a Master Catalogue / Open Food Facts). Every field is optional and the
/// owner can change all of them.
class ProductSuggestion {
  const ProductSuggestion({
    required this.source,
    this.name,
    this.brand,
    this.unitHint,
    this.packSize,
    this.categoryHint,
    this.imageUrl,
    this.mrp,
  });

  final String source;
  final String? name;
  final String? brand;
  final String? unitHint;
  final String? packSize;
  final String? categoryHint;
  final String? imageUrl;
  final Decimal? mrp;

  factory ProductSuggestion.fromJson(Map<String, dynamic> j) => ProductSuggestion(
        source: '${j['source'] ?? 'catalogue'}',
        name: _s(j['name']),
        brand: _s(j['brand']),
        unitHint: _s(j['unit_hint']),
        packSize: _s(j['pack_size']),
        categoryHint: _s(j['category_hint']),
        imageUrl: _s(j['image_url']),
        mrp: j['mrp'] == null ? null : Decimal.tryParse('${j['mrp']}'),
      );

  static String? _s(Object? v) {
    final t = v?.toString().trim();
    return t == null || t.isEmpty ? null : t;
  }
}

/// Answer of `GET /products/lookup` (or the local equivalent).
class ProductLookup {
  const ProductLookup({this.product, this.suggestion});

  static const notFound = ProductLookup();

  final KnownProduct? product;
  final ProductSuggestion? suggestion;

  bool get found => product != null;

  factory ProductLookup.fromJson(Map<String, dynamic> j) {
    final p = j['product'];
    KnownProduct? product;
    if (j['found'] == true && p is Map) {
      final unit = p['unit'] is Map ? Map<String, dynamic>.from(p['unit'] as Map) : null;
      Decimal? dec(Object? v) => v == null ? null : Decimal.tryParse('$v');
      product = KnownProduct(
        id: '${p['id']}',
        name: '${p['name'] ?? ''}',
        variationId: p['variation_id']?.toString(),
        unitId: unit?['id']?.toString(),
        unitLabel: (unit?['name'] ?? unit?['symbol'])?.toString(),
        salePrice: dec(p['sale_price']),
        costPrice: dec(p['cost_price']),
        stockOnHand: dec(p['stock_on_hand']),
        trackExpiry: p['track_expiry'] == true,
        imageUrl: p['image_url']?.toString(),
      );
    }
    final s = j['suggestion'];
    return ProductLookup(
      product: product,
      suggestion: s is Map ? ProductSuggestion.fromJson(Map<String, dynamic>.from(s)) : null,
    );
  }
}

/// One line of the `POST /products/quick-add` body.
Map<String, dynamic> quickAddLineJson(QuickAddRow r) {
  String? money(Decimal? d) => d == null ? null : DecimalUtils.format(d, fractionDigits: 2);
  return {
    'client_line_id': r.id,
    'barcode': r.barcode,
    'name': r.name.trim(),
    if (r.brand.trim().isNotEmpty) 'brand': r.brand.trim(),
    if (r.categoryId != null)
      'category_id': r.categoryId
    else if ((r.newCategoryName ?? '').trim().isNotEmpty)
      'category_name': r.newCategoryName!.trim(),
    if (r.unitId != null)
      'unit_id': r.unitId
    else if ((r.newUnitName ?? '').trim().isNotEmpty)
      'unit_name': r.newUnitName!.trim(),
    if (r.packSize.trim().isNotEmpty) 'pack_size': r.packSize.trim(),
    'qty': r.qty.toString(),
    'cost_price': money(r.cost) ?? '0',
    'sale_price': money(r.salePrice) ?? '0',
    if (r.mrp != null) 'mrp': money(r.mrp),
    if (r.taxRateId != null) 'tax_rate_id': r.taxRateId,
    'track_expiry': r.trackExpiry,
    if (r.batchNo.trim().isNotEmpty) 'batch_no': r.batchNo.trim(),
    if (r.expiry != null) 'expiry_date': isoDate(r.expiry),
    if (r.imageUrl != null && !r.isKnown) 'image_url': r.imageUrl,
    'update_existing_prices': r.isKnown && r.updatePrice,
  };
}

/// The whole request.
class QuickAddRequest {
  const QuickAddRequest({
    required this.mode,
    required this.rows,
    this.supplierId,
    this.branchId,
  });

  final QuickAddMode mode;
  final String? supplierId;
  final String? branchId;
  final List<QuickAddRow> rows;

  Map<String, dynamic> toJson() => {
        'mode': mode.apiValue,
        'supplier_id': mode == QuickAddMode.purchase ? supplierId : null,
        if (branchId != null) 'branch_id': branchId,
        'lines': [for (final r in rows) quickAddLineJson(r)],
      };
}

enum LineOutcome { created, updated, failed }

/// The server's answer for one line.
class QuickAddLineResult {
  const QuickAddLineResult({
    required this.clientLineId,
    required this.outcome,
    this.productId,
    this.variationId,
    this.errorCode,
    this.errorMessage,
    this.note,
  });

  final String clientLineId;
  final LineOutcome outcome;
  final String? productId;
  final String? variationId;
  final String? errorCode;
  final String? errorMessage;
  final String? note;

  bool get ok => outcome != LineOutcome.failed;

  factory QuickAddLineResult.fromJson(Map<String, dynamic> j) {
    final err = j['error'] is Map ? Map<String, dynamic>.from(j['error'] as Map) : null;
    return QuickAddLineResult(
      clientLineId: '${j['client_line_id']}',
      outcome: switch (j['status']) {
        'created' => LineOutcome.created,
        'updated' => LineOutcome.updated,
        _ => LineOutcome.failed,
      },
      productId: j['product_id']?.toString(),
      variationId: j['variation_id']?.toString(),
      errorCode: err?['code']?.toString(),
      errorMessage: err?['message']?.toString(),
      note: j['note']?.toString(),
    );
  }
}

class QuickAddResponse {
  const QuickAddResponse({
    required this.created,
    required this.updated,
    required this.failed,
    required this.lines,
    this.purchaseId,
    this.receiptId,
    this.adjustmentId,
    this.quickAddId,
    this.replayed = false,
  });

  final int created;
  final int updated;
  final int failed;
  final List<QuickAddLineResult> lines;
  final String? purchaseId;
  final String? receiptId;
  final String? adjustmentId;
  final String? quickAddId;

  /// The server answered from a stored response (a retry of a finished save).
  final bool replayed;

  factory QuickAddResponse.fromJson(Map<String, dynamic> j, {bool replayed = false}) =>
      QuickAddResponse(
        created: (j['created'] as num?)?.toInt() ?? 0,
        updated: (j['updated'] as num?)?.toInt() ?? 0,
        failed: (j['failed'] as num?)?.toInt() ?? 0,
        purchaseId: j['purchase_id']?.toString(),
        receiptId: j['receipt_id']?.toString(),
        adjustmentId: j['adjustment_id']?.toString(),
        quickAddId: j['quick_add_id']?.toString(),
        replayed: replayed,
        lines: [
          for (final l in (j['lines'] as List? ?? const []))
            QuickAddLineResult.fromJson(Map<String, dynamic>.from(l as Map)),
        ],
      );
}

/// Plain-words versions of the server's per-line error codes.
abstract final class QuickAddMessages {
  static String forCode(String? code, {String? fallback}) => switch (code) {
        'name_required' => 'Type a name for this item.',
        'invalid_name' => 'This name cannot be used. Please change it.',
        'barcode_required' => 'The barcode is missing.',
        'invalid_barcode' => 'This barcode is not valid.',
        'invalid_qty' => 'The quantity is not valid.',
        'invalid_cost_price' => 'The cost price is not valid.',
        'invalid_sale_price' => 'The sale price is not valid.',
        'invalid_mrp' => 'The printed price (MRP) is not valid.',
        'invalid_expiry_date' => 'The expiry date is not valid.',
        'expiry_required' => 'This item has an expiry date. Type it in.',
        'batch_required' => 'Your shop needs a batch number for stock. Type it in.',
        'invalid_category' => 'That category no longer exists. Pick another.',
        'invalid_unit' => 'That unit no longer exists. Pick another.',
        'invalid_tax_rate' => 'That tax rate no longer exists.',
        'barcode_deleted' =>
          'This barcode belonged to a product you deleted. Restore it or use a new barcode.',
        'forbidden' => 'You do not have permission to do this for this item.',
        'conflict' => 'Another change got in the way. Try again.',
        'stock_failed' =>
          'The item was saved but its stock was not added. Scan it again to add the stock.',
        'internal_error' => 'Something went wrong on our side. Try again.',
        _ => fallback ?? 'This line could not be saved.',
      };

  /// Which cell to point at for a server error code.
  static QuickAddField? fieldFor(String? code) => switch (code) {
        'name_required' || 'invalid_name' => QuickAddField.name,
        'barcode_required' || 'invalid_barcode' || 'barcode_deleted' => QuickAddField.barcode,
        'invalid_qty' => QuickAddField.qty,
        'invalid_cost_price' => QuickAddField.cost,
        'invalid_sale_price' || 'invalid_mrp' => QuickAddField.salePrice,
        'invalid_expiry_date' || 'expiry_required' => QuickAddField.expiry,
        'batch_required' => QuickAddField.batch,
        'invalid_category' => QuickAddField.category,
        'invalid_unit' => QuickAddField.unit,
        _ => null,
      };
}
