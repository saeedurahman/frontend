/// Detail models for Price List management (items, bulk upsert, adjust, import)
/// Hand-written without build_runner.

class PriceListItemDetailModel {
  const PriceListItemDetailModel({
    required this.id,
    required this.priceListId,
    required this.productId,
    this.variationId,
    required this.productName,
    this.variationName,
    this.sku,
    required this.unitPrice,
    required this.minQty,
    this.updatedAt,
  });

  final String id;
  final String priceListId;
  final String productId;
  final String? variationId;
  final String productName;
  final String? variationName;
  final String? sku;
  final String unitPrice;
  final String minQty;
  final String? updatedAt;

  factory PriceListItemDetailModel.fromJson(Map<String, dynamic> json) {
    return PriceListItemDetailModel(
      id: json['id']?.toString() ?? '',
      priceListId: json['price_list_id']?.toString() ?? '',
      productId: json['product_id']?.toString() ?? '',
      variationId: json['variation_id']?.toString(),
      productName: json['product_name']?.toString() ?? '',
      variationName: json['variation_name']?.toString(),
      sku: json['sku']?.toString(),
      unitPrice: json['unit_price']?.toString() ?? '0',
      minQty: json['min_qty']?.toString() ?? '1',
      updatedAt: json['updated_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'price_list_id': priceListId,
    'product_id': productId,
    if (variationId != null) 'variation_id': variationId,
    'product_name': productName,
    if (variationName != null) 'variation_name': variationName,
    if (sku != null) 'sku': sku,
    'unit_price': unitPrice,
    'min_qty': minQty,
    if (updatedAt != null) 'updated_at': updatedAt,
  };

  PriceListItemDetailModel copyWith({
    String? id,
    String? priceListId,
    String? productId,
    String? variationId,
    String? productName,
    String? variationName,
    String? sku,
    String? unitPrice,
    String? minQty,
    String? updatedAt,
  }) {
    return PriceListItemDetailModel(
      id: id ?? this.id,
      priceListId: priceListId ?? this.priceListId,
      productId: productId ?? this.productId,
      variationId: variationId ?? this.variationId,
      productName: productName ?? this.productName,
      variationName: variationName ?? this.variationName,
      sku: sku ?? this.sku,
      unitPrice: unitPrice ?? this.unitPrice,
      minQty: minQty ?? this.minQty,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class PaginatedPriceListItemsModel {
  const PaginatedPriceListItemsModel({
    required this.total,
    required this.skip,
    required this.limit,
    required this.items,
  });

  final int total;
  final int skip;
  final int limit;
  final List<PriceListItemDetailModel> items;

  factory PaginatedPriceListItemsModel.fromJson(Map<String, dynamic> json) {
    return PaginatedPriceListItemsModel(
      total: json['total'] as int? ?? 0,
      skip: json['skip'] as int? ?? 0,
      limit: json['limit'] as int? ?? 50,
      items: (json['items'] as List<dynamic>? ?? const [])
          .map((e) => PriceListItemDetailModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class AdjustPricesRequest {
  const AdjustPricesRequest({
    required this.percent,
    this.categoryId,
    this.roundTo,
    this.dryRun = false,
  });

  final String percent;
  final String? categoryId;
  final String? roundTo;
  final bool dryRun;

  Map<String, dynamic> toJson() => {
    'percent': percent,
    if (categoryId != null && categoryId!.isNotEmpty) 'category_id': categoryId,
    if (roundTo != null && roundTo!.isNotEmpty) 'round_to': roundTo,
    'dry_run': dryRun,
  };
}

class AdjustSampleModel {
  const AdjustSampleModel({
    required this.itemId,
    required this.productId,
    required this.oldPrice,
    required this.newPrice,
  });

  final String itemId;
  final String productId;
  final String oldPrice;
  final String newPrice;

  factory AdjustSampleModel.fromJson(Map<String, dynamic> json) => AdjustSampleModel(
    itemId: json['item_id']?.toString() ?? '',
    productId: json['product_id']?.toString() ?? '',
    oldPrice: json['old_price']?.toString() ?? '0',
    newPrice: json['new_price']?.toString() ?? '0',
  );
}

class AdjustPricesResponseModel {
  const AdjustPricesResponseModel({
    required this.dryRun,
    required this.updated,
    required this.unchanged,
    required this.sample,
  });

  final bool dryRun;
  final int updated;
  final int unchanged;
  final List<AdjustSampleModel> sample;

  factory AdjustPricesResponseModel.fromJson(Map<String, dynamic> json) =>
      AdjustPricesResponseModel(
        dryRun: json['dry_run'] as bool? ?? false,
        updated: json['updated'] as int? ?? 0,
        unchanged: json['unchanged'] as int? ?? 0,
        sample: (json['sample'] as List<dynamic>? ?? const [])
            .map((e) => AdjustSampleModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}

class BulkPriceItemModel {
  const BulkPriceItemModel({
    required this.productId,
    this.variationId,
    required this.price,
    this.minQty = '1',
  });

  final String productId;
  final String? variationId;
  final String price;
  final String minQty;

  Map<String, dynamic> toJson() => {
    'product_id': productId,
    if (variationId != null) 'variation_id': variationId,
    'price': price,
    'min_qty': minQty,
  };
}

class BulkPriceResponseModel {
  const BulkPriceResponseModel({
    required this.created,
    required this.updated,
    required this.unchanged,
    required this.total,
  });

  final int created;
  final int updated;
  final int unchanged;
  final int total;

  factory BulkPriceResponseModel.fromJson(Map<String, dynamic> json) =>
      BulkPriceResponseModel(
        created: json['created'] as int? ?? 0,
        updated: json['updated'] as int? ?? 0,
        unchanged: json['unchanged'] as int? ?? 0,
        total: json['total'] as int? ?? 0,
      );
}

