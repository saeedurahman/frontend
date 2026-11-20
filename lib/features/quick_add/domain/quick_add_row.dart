import 'package:decimal/decimal.dart';

/// The columns of the grid (and the focus targets of the keyboard flow).
enum QuickAddField {
  barcode,
  name,
  brand,
  unit,
  category,
  qty,
  cost,
  salePrice,
  batch,
  expiry,
}

/// The colour state of a row.
enum RowStatus {
  /// Already a product of this shop (green).
  known,

  /// New product with a name, ready to save (blue).
  newReady,

  /// New product that still needs a name (amber).
  needsName,

  /// Something is wrong, see [QuickAddRow.error] (red).
  error,
}

/// What the plain-words screen says about one problem.
class RowError {
  const RowError({required this.message, this.code, this.field});

  final String message;

  /// Server error code (`expiry_required`...) or null for a local check.
  final String? code;
  final QuickAddField? field;

  Map<String, dynamic> toJson() =>
      {'message': message, 'code': code, 'field': field?.name};

  factory RowError.fromJson(Map<String, dynamic> j) => RowError(
        message: '${j['message'] ?? ''}',
        code: j['code'] as String?,
        field: QuickAddField.values.asNameMap()[j['field']],
      );
}

Decimal? _dec(Object? v) {
  if (v == null) return null;
  final s = '$v'.trim();
  return s.isEmpty ? null : Decimal.tryParse(s);
}

String? _date(DateTime? d) => d == null
    ? null
    : '${d.year.toString().padLeft(4, '0')}-'
        '${d.month.toString().padLeft(2, '0')}-'
        '${d.day.toString().padLeft(2, '0')}';

/// `YYYY-MM-DD` of [d] (the API's date format).
String? isoDate(DateTime? d) => _date(d);

/// One line of the Quick Add grid. Immutable; the cubit swaps rows.
class QuickAddRow {
  QuickAddRow({
    required this.id,
    required this.barcode,
    this.rawBarcode = '',
    this.barcodeWarning = false,
    this.name = '',
    this.nameTouched = false,
    this.brand = '',
    this.packSize = '',
    this.unitId,
    this.unitLabel,
    this.categoryId,
    this.categoryLabel,
    Decimal? qty,
    this.cost,
    this.salePrice,
    this.salePriceSuggested = false,
    this.updatePrice = false,
    this.mrp,
    this.batchNo = '',
    this.expiry,
    this.trackExpiry = false,
    this.taxRateId,
    this.productId,
    this.variationId,
    this.currentStock,
    this.imageUrl,
    this.suggestionSource,
    this.lookupPending = false,
    this.error,
    this.pulse = 0,
    this.seq = 0,
  }) : qty = qty ?? Decimal.one;

  final String id;

  /// The code that is saved (normalised like the server does).
  final String barcode;

  /// The code as the scanner sent it (kept for support).
  final String rawBarcode;

  /// The check digit does not add up (shown as a warning, never blocks).
  final bool barcodeWarning;
  final String name;

  /// The owner typed the name (a late lookup must not overwrite it).
  final bool nameTouched;
  final String brand;
  final String packSize;

  /// Null = the business default unit.
  final String? unitId;
  final String? unitLabel;
  final String? categoryId;
  final String? categoryLabel;
  final Decimal qty;
  final Decimal? cost;
  final Decimal? salePrice;

  /// The sale price is a suggestion the owner has not confirmed yet.
  final bool salePriceSuggested;

  /// The owner changed the price of a product the shop already has: the save
  /// sends it with `update_existing_prices`.
  final bool updatePrice;
  final Decimal? mrp;
  final String batchNo;
  final DateTime? expiry;
  final bool trackExpiry;
  final String? taxRateId;

  /// Set when the barcode already belongs to a product of this shop.
  final String? productId;
  final String? variationId;
  final Decimal? currentStock;
  final String? imageUrl;

  /// Where pre-filled details came from (`catalogue`, `server`...).
  final String? suggestionSource;

  /// A lookup for this barcode is still running (never blocks typing).
  final bool lookupPending;
  final RowError? error;

  /// Bumped on every re-scan: the row pulses.
  final int pulse;

  /// Insertion order, highest = newest.
  final int seq;

  bool get isKnown => productId != null;
  bool get hasName => name.trim().isNotEmpty;

  RowStatus get status {
    if (error != null) return RowStatus.error;
    if (isKnown) return RowStatus.known;
    return hasName ? RowStatus.newReady : RowStatus.needsName;
  }

  QuickAddRow copyWith({
    String? barcode,
    bool? barcodeWarning,
    String? name,
    bool? nameTouched,
    String? brand,
    String? packSize,
    String? unitId,
    String? unitLabel,
    bool clearUnit = false,
    String? categoryId,
    String? categoryLabel,
    bool clearCategory = false,
    Decimal? qty,
    Decimal? cost,
    bool clearCost = false,
    Decimal? salePrice,
    bool clearSalePrice = false,
    bool? salePriceSuggested,
    bool? updatePrice,
    Decimal? mrp,
    String? batchNo,
    DateTime? expiry,
    bool clearExpiry = false,
    bool? trackExpiry,
    String? taxRateId,
    String? productId,
    String? variationId,
    Decimal? currentStock,
    String? imageUrl,
    String? suggestionSource,
    bool? lookupPending,
    RowError? error,
    bool clearError = false,
    int? pulse,
    int? seq,
  }) =>
      QuickAddRow(
        id: id,
        barcode: barcode ?? this.barcode,
        rawBarcode: rawBarcode,
        barcodeWarning: barcodeWarning ?? this.barcodeWarning,
        name: name ?? this.name,
        nameTouched: nameTouched ?? this.nameTouched,
        brand: brand ?? this.brand,
        packSize: packSize ?? this.packSize,
        unitId: clearUnit ? null : (unitId ?? this.unitId),
        unitLabel: clearUnit ? null : (unitLabel ?? this.unitLabel),
        categoryId: clearCategory ? null : (categoryId ?? this.categoryId),
        categoryLabel:
            clearCategory ? null : (categoryLabel ?? this.categoryLabel),
        qty: qty ?? this.qty,
        cost: clearCost ? null : (cost ?? this.cost),
        salePrice: clearSalePrice ? null : (salePrice ?? this.salePrice),
        salePriceSuggested: salePriceSuggested ?? this.salePriceSuggested,
        updatePrice: updatePrice ?? this.updatePrice,
        mrp: mrp ?? this.mrp,
        batchNo: batchNo ?? this.batchNo,
        expiry: clearExpiry ? null : (expiry ?? this.expiry),
        trackExpiry: trackExpiry ?? this.trackExpiry,
        taxRateId: taxRateId ?? this.taxRateId,
        productId: productId ?? this.productId,
        variationId: variationId ?? this.variationId,
        currentStock: currentStock ?? this.currentStock,
        imageUrl: imageUrl ?? this.imageUrl,
        suggestionSource: suggestionSource ?? this.suggestionSource,
        lookupPending: lookupPending ?? this.lookupPending,
        error: clearError ? null : (error ?? this.error),
        pulse: pulse ?? this.pulse,
        seq: seq ?? this.seq,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'barcode': barcode,
        'raw': rawBarcode,
        'warn': barcodeWarning,
        'name': name,
        'touched': nameTouched,
        'brand': brand,
        'pack': packSize,
        'unit_id': unitId,
        'unit': unitLabel,
        'category_id': categoryId,
        'category': categoryLabel,
        'qty': qty.toString(),
        'cost': cost?.toString(),
        'sale': salePrice?.toString(),
        'suggested': salePriceSuggested,
        'update_price': updatePrice,
        'mrp': mrp?.toString(),
        'batch': batchNo,
        'expiry': _date(expiry),
        'track_expiry': trackExpiry,
        'tax_rate_id': taxRateId,
        'product_id': productId,
        'variation_id': variationId,
        'stock': currentStock?.toString(),
        'image_url': imageUrl,
        'source': suggestionSource,
        'error': error?.toJson(),
        'seq': seq,
      };

  factory QuickAddRow.fromJson(Map<String, dynamic> j) => QuickAddRow(
        id: '${j['id']}',
        barcode: '${j['barcode'] ?? ''}',
        rawBarcode: '${j['raw'] ?? ''}',
        barcodeWarning: j['warn'] == true,
        name: '${j['name'] ?? ''}',
        nameTouched: j['touched'] == true,
        brand: '${j['brand'] ?? ''}',
        packSize: '${j['pack'] ?? ''}',
        unitId: j['unit_id'] as String?,
        unitLabel: j['unit'] as String?,
        categoryId: j['category_id'] as String?,
        categoryLabel: j['category'] as String?,
        qty: _dec(j['qty']) ?? Decimal.one,
        cost: _dec(j['cost']),
        salePrice: _dec(j['sale']),
        salePriceSuggested: j['suggested'] == true,
        updatePrice: j['update_price'] == true,
        mrp: _dec(j['mrp']),
        batchNo: '${j['batch'] ?? ''}',
        expiry: j['expiry'] == null ? null : DateTime.tryParse('${j['expiry']}'),
        trackExpiry: j['track_expiry'] == true,
        taxRateId: j['tax_rate_id'] as String?,
        productId: j['product_id'] as String?,
        variationId: j['variation_id'] as String?,
        currentStock: _dec(j['stock']),
        imageUrl: j['image_url'] as String?,
        suggestionSource: j['source'] as String?,
        error: j['error'] is Map
            ? RowError.fromJson(Map<String, dynamic>.from(j['error'] as Map))
            : null,
        seq: (j['seq'] as num?)?.toInt() ?? 0,
      );
}
