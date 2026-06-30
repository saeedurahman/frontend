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
    @Default({}) Map<String, String> priceCache,
    @Default({}) Map<String, String> stockCache,
    @Default({}) Map<String, ProductModel> productDetailsCache,
  }) = _PosCatalogState;
}
