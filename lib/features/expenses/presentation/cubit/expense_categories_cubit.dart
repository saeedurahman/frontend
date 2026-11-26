import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/data_changes/auto_refresh.dart';
import 'package:frantend/core/data_changes/data_change_bus.dart';
import 'package:frantend/features/expenses/data/models/expense_category_model.dart';
import 'package:frantend/features/expenses/domain/usecases/expenses_usecases.dart';
import 'package:frantend/features/expenses/presentation/cubit/expense_categories_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class ExpenseCategoriesCubit extends Cubit<ExpenseCategoriesState>
    with AutoRefresh<ExpenseCategoriesState> {
  ExpenseCategoriesCubit({
    required GetExpenseCategoriesUseCase getExpenseCategoriesUseCase,
    required CreateExpenseCategoryUseCase createExpenseCategoryUseCase,
  })  : _getCategories = getExpenseCategoriesUseCase,
        _createCategory = createExpenseCategoryUseCase,
        super(const ExpenseCategoriesState.initial()) {
    watchData(const {DataTopic.expenseCategories}, _reload);
  }

  final GetExpenseCategoriesUseCase _getCategories;
  final CreateExpenseCategoryUseCase _createCategory;

  Future<void> load() async {
    if (isClosed) return;
    final read = beginRead();
    emit(const ExpenseCategoriesState.loading());
    final result = await _getCategories();
    if (isStale(read)) return;
    result.fold(
      (f) => emit(ExpenseCategoriesState.error(f.message)),
      (categories) => emit(ExpenseCategoriesState.loaded(categories: newestFirst(categories, (e) => e.id))),
    );
  }

  /// A quiet re-read after a change: the list stays on screen meanwhile.
  Future<void> _reload() async {
    final current = state;
    if (current is ExpenseCategoriesInitial) return;
    if (current is! ExpenseCategoriesLoaded) return load();
    final read = beginRead();
    final result = await _getCategories();
    if (isStale(read)) return;
    result.fold(
      (_) {},
      (categories) => emit(ExpenseCategoriesState.loaded(categories: newestFirst(categories, (e) => e.id))),
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
    markCreated(category.id);
    final current = state;
    final others = current is ExpenseCategoriesLoaded
        ? current.categories.where((e) => e.id != category.id)
        : const <ExpenseCategoryModel>[];
    emit(ExpenseCategoriesState.loaded(categories: [category, ...others]));
  }
}
