import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/data_changes/auto_refresh.dart';
import 'package:frantend/core/data_changes/data_change_bus.dart';
import 'package:frantend/features/products/data/models/category_model.dart';
import 'package:frantend/features/products/domain/usecases/create_category_usecase.dart';
import 'package:frantend/features/products/domain/usecases/get_categories_usecase.dart';
import 'package:frantend/features/products/presentation/cubit/categories_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class CategoriesCubit extends Cubit<CategoriesState>
    with AutoRefresh<CategoriesState> {
  CategoriesCubit({
    required GetCategoriesUseCase getCategoriesUseCase,
    required CreateCategoryUseCase createCategoryUseCase,
  })  : _getCategories = getCategoriesUseCase,
        _createCategory = createCategoryUseCase,
        super(const CategoriesState.initial()) {
    watchData(const {DataTopic.categories}, _reload);
  }

  final GetCategoriesUseCase _getCategories;
  final CreateCategoryUseCase _createCategory;

  Future<void> load() async {
    if (isClosed) return;
    final read = beginRead();
    emit(const CategoriesState.loading());
    final result = await _getCategories();
    if (isStale(read)) return;
    result.fold(
      (f) => emit(CategoriesState.error(f.message)),
      (categories) => emit(CategoriesState.loaded(newestFirst(categories, (e) => e.id))),
    );
  }

  /// A quiet re-read after a change: the list stays on screen meanwhile.
  Future<void> _reload() async {
    final current = state;
    if (current is CategoriesInitial) return;
    if (current is! CategoriesLoaded) return load();
    final read = beginRead();
    final result = await _getCategories();
    if (isStale(read)) return;
    result.fold(
      (_) {},
      (categories) => emit(CategoriesState.loaded(newestFirst(categories, (e) => e.id))),
    );
  }

  Future<CategoryModel?> create(String name, {String? parentId}) async {
    final body = <String, dynamic>{
      'name': name,
      if (parentId != null) 'parent_id': parentId,
    };
    final result = await _createCategory(body);
    return result.fold(
      (f) {
        if (!isClosed) emit(CategoriesState.error(f.message));
        return null;
      },
      (category) {
        if (!isClosed) _appendCategory(category);
        return category;
      },
    );
  }

  void _appendCategory(CategoryModel category) {
    markCreated(category.id);
    final current = state;
    final others = current is CategoriesLoaded
        ? current.categories.where((e) => e.id != category.id)
        : const <CategoryModel>[];
    emit(CategoriesState.loaded([category, ...others]));
  }
}
