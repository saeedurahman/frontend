import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frantend/features/products/data/models/product_list_item_model.dart';

part 'products_list_state.freezed.dart';

@Freezed()
sealed class ProductsListState with _$ProductsListState {
  const factory ProductsListState.initial() = ProductsListInitial;

  const factory ProductsListState.loading() = ProductsListLoading;

  const factory ProductsListState.loaded({
    required List<ProductListItemModel> items,
    required int total,
    required int skip,
    required int limit,
    String? currentSearch,
    String? currentCategoryId,
    String? currentBrandId,
    bool? currentIsActive,
    @Default(false) bool isLoadingMore,
  }) = ProductsListLoaded;

  const factory ProductsListState.error(String message) = ProductsListError;
}
