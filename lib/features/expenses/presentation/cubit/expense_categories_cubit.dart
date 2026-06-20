import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/features/expenses/data/models/expense_category_model.dart';
import 'package:frantend/features/expenses/domain/usecases/expenses_usecases.dart';
import 'package:frantend/features/expenses/presentation/cubit/expense_categories_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class ExpenseCategoriesCubit extends Cubit<ExpenseCategoriesState> {
  ExpenseCategoriesCubit({
    required GetExpenseCategoriesUseCase getExpenseCategoriesUseCase,
    required CreateExpenseCategoryUseCase createExpenseCategoryUseCase,
  })  : _getCategories = getExpenseCategoriesUseCase,
        _createCategory = createExpenseCategoryUseCase,
        super(const ExpenseCategoriesState.initial());

  final GetExpenseCategoriesUseCase _getCategories;
  final CreateExpenseCategoryUseCase _createCategory;

  Future<void> load() async {
    if (isClosed) return;
    emit(const ExpenseCategoriesState.loading());
    final result = await _getCategories();
    if (isClosed) return;
    result.fold(
      (f) => emit(ExpenseCategoriesState.error(f.message)),
      (categories) => emit(ExpenseCategoriesState.loaded(categories: categories)),
    );
  }

  Future<ExpenseCategoryModel?> create(String name, {String? parentId}) async {
    final body = <String, dynamic>{
      'name': name,
      if (parentId != null) 'parent_id': parentId,
    };
    final result = await _createCategory(body);
    return result.fold(
      (f) {
        if (!isClosed) emit(ExpenseCategoriesState.error(f.message));
        return null;
      },
      (category) {
        if (!isClosed) _appendCategory(category);
        return category;
      },
    );
  }

  void _appendCategory(ExpenseCategoryModel category) {
    final current = state;
    if (current is ExpenseCategoriesLoaded) {
      final exists = current.categories.any((c) => c.id == category.id);
      if (!exists) {
        emit(
          ExpenseCategoriesState.loaded(
            categories: [...current.categories, category],
          ),
        );
      }
    } else {
      emit(ExpenseCategoriesState.loaded(categories: [category]));
    }
  }
}
