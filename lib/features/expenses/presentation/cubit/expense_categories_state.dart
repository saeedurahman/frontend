import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frantend/features/expenses/data/models/expense_category_model.dart';

part 'expense_categories_state.freezed.dart';

@freezed
sealed class ExpenseCategoriesState with _$ExpenseCategoriesState {
  const factory ExpenseCategoriesState.initial() = ExpenseCategoriesInitial;

  const factory ExpenseCategoriesState.loading() = ExpenseCategoriesLoading;

  const factory ExpenseCategoriesState.loaded({
    required List<ExpenseCategoryModel> categories,
  }) = ExpenseCategoriesLoaded;

  const factory ExpenseCategoriesState.error(String message) =
      ExpenseCategoriesError;
}
