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
    @Default({}) Map<String, String> stockCache,
    @Default({}) Map<String, ProductModel> productDetailsCache,
  }) = _PosCatalogState;
}
