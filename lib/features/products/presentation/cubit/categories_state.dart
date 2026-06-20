import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frantend/features/products/data/models/category_model.dart';

part 'categories_state.freezed.dart';

@freezed
class CategoriesState with _$CategoriesState {
  const factory CategoriesState.initial() = CategoriesInitial;
  const factory CategoriesState.loading() = CategoriesLoading;
  const factory CategoriesState.loaded(List<CategoryModel> categories) =
      CategoriesLoaded;
  const factory CategoriesState.error(String message) = CategoriesError;
}
