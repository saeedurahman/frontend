import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/features/products/data/models/brand_model.dart';
import 'package:frantend/features/products/domain/usecases/create_brand_usecase.dart';
import 'package:frantend/features/products/domain/usecases/get_brands_usecase.dart';
import 'package:frantend/features/products/presentation/cubit/brands_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class BrandsCubit extends Cubit<BrandsState> {
  BrandsCubit({
    required GetBrandsUseCase getBrandsUseCase,
    required CreateBrandUseCase createBrandUseCase,
  })  : _getBrands = getBrandsUseCase,
        _createBrand = createBrandUseCase,
        super(const BrandsState.initial());

  final GetBrandsUseCase _getBrands;
  final CreateBrandUseCase _createBrand;

  Future<void> load() async {
    if (isClosed) return;
    emit(const BrandsState.loading());
    final result = await _getBrands();
    if (isClosed) return;
    result.fold(
      (f) => emit(BrandsState.error(f.message)),
      (brands) => emit(BrandsState.loaded(brands)),
    );
  }

  Future<BrandModel?> create(String name) async {
    final result = await _createBrand({'name': name});
    return result.fold(
      (f) {
        if (!isClosed) emit(BrandsState.error(f.message));
        return null;
      },
      (brand) {
        if (!isClosed) _appendBrand(brand);
        return brand;
      },
    );
  }

  void _appendBrand(BrandModel brand) {
    final current = state;
    if (current is BrandsLoaded) {
      if (!current.brands.any((b) => b.id == brand.id)) {
        emit(BrandsState.loaded([...current.brands, brand]));
      }
    } else {
      emit(BrandsState.loaded([brand]));
    }
  }
}
