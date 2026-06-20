import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/features/products/data/models/category_model.dart';
import 'package:frantend/features/products/domain/usecases/create_category_usecase.dart';
import 'package:frantend/features/products/domain/usecases/get_categories_usecase.dart';
import 'package:frantend/features/products/presentation/cubit/categories_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class CategoriesCubit extends Cubit<CategoriesState> {
  CategoriesCubit({
    required GetCategoriesUseCase getCategoriesUseCase,
    required CreateCategoryUseCase createCategoryUseCase,
  })  : _getCategories = getCategoriesUseCase,
        _createCategory = createCategoryUseCase,
        super(const CategoriesState.initial());

  final GetCategoriesUseCase _getCategories;
  final CreateCategoryUseCase _createCategory;

  Future<void> load() async {
    if (isClosed) return;
    emit(const CategoriesState.loading());
    final result = await _getCategories();
    if (isClosed) return;
    result.fold(
      (f) => emit(CategoriesState.error(f.message)),
      (categories) => emit(CategoriesState.loaded(categories)),
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
    final current = state;
    if (current is CategoriesLoaded) {
      final exists = current.categories.any((c) => c.id == category.id);
      if (!exists) {
        emit(CategoriesState.loaded([...current.categories, category]));
      }
    } else {
      emit(CategoriesState.loaded([category]));
    }
  }
}
