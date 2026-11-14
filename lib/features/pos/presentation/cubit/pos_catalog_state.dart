part of 'pos_state.dart';

@freezed
class PosCatalogState with _$PosCatalogState {
  const factory PosCatalogState({
    @Default([]) List<ProductListItemModel> products,
    @Default([]) List<CategoryModel> categories,
    String? selectedCategoryId,
    @Default('') String productSearchQuery,
    @Default(true) bool isLoadingProducts,
    String? productsError,
    @Default(false) bool hasMoreProducts,
    @Default(false) bool isLoadingMoreProducts,
    @Default(0) int productsTotal,
    String? stockError,
    String? categoriesError,
    String? taxError,
    @Default({}) Map<String, String> priceCache,
    @Default(PosPriceContext()) PosPriceContext priceContext,
    @Default({}) Map<String, String> stockCache,
    @Default({}) Map<String, ProductModel> productDetailsCache,
  }) = _PosCatalogState;
}

/// Which price list the POS prices come from right now, and a counter that
/// changes whenever prices were re-derived (so cards and the open quantity
/// popup rebuild even when the values happen to be equal).
class PosPriceContext {
  const PosPriceContext({
    this.effectiveListId,
    this.defaultListId,
    this.listName,
    this.customerId,
    this.version = 0,
  });

  /// The customer's assigned list while it applies, else the default list.
  final String? effectiveListId;
  final String? defaultListId;
  final String? listName;

  /// The customer this was resolved for (null = walk-in). When the selected
  /// customer is another one the context is stale and is not used.
  final String? customerId;
  final int version;

  /// True when a list other than the default one is in force.
  bool get isSpecial =>
      effectiveListId != null && effectiveListId != defaultListId;

  PosPriceContext bumped({
    String? effectiveListId,
    String? defaultListId,
    String? listName,
    String? customerId,
    bool keep = false,
  }) =>
      PosPriceContext(
        effectiveListId: keep ? this.effectiveListId : effectiveListId,
        defaultListId: keep ? this.defaultListId : defaultListId,
        listName: keep ? this.listName : listName,
        customerId: keep ? this.customerId : customerId,
        version: version + 1,
      );

  @override
  bool operator ==(Object other) =>
      other is PosPriceContext &&
      other.effectiveListId == effectiveListId &&
      other.defaultListId == defaultListId &&
      other.listName == listName &&
      other.customerId == customerId &&
      other.version == version;

  @override
  int get hashCode => Object.hash(
        effectiveListId,
        defaultListId,
        listName,
        customerId,
        version,
      );

  @override
  String toString() =>
      'PosPriceContext(list: $effectiveListId, default: $defaultListId, customer: $customerId, v$version)';
}
