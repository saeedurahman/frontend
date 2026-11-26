import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/data_changes/auto_refresh.dart';
import 'package:frantend/core/data_changes/data_change_bus.dart';
import 'package:frantend/features/products/data/models/brand_model.dart';
import 'package:frantend/features/products/domain/usecases/create_brand_usecase.dart';
import 'package:frantend/features/products/domain/usecases/get_brands_usecase.dart';
import 'package:frantend/features/products/presentation/cubit/brands_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class BrandsCubit extends Cubit<BrandsState>
    with AutoRefresh<BrandsState> {
  BrandsCubit({
    required GetBrandsUseCase getBrandsUseCase,
    required CreateBrandUseCase createBrandUseCase,
  })  : _getBrands = getBrandsUseCase,
        _createBrand = createBrandUseCase,
        super(const BrandsState.initial()) {
    watchData(const {DataTopic.brands}, _reload);
  }

  final GetBrandsUseCase _getBrands;
  final CreateBrandUseCase _createBrand;

  Future<void> load() async {
    if (isClosed) return;
    final read = beginRead();
    emit(const BrandsState.loading());
    final result = await _getBrands();
    if (isStale(read)) return;
    result.fold(
      (f) => emit(BrandsState.error(f.message)),
      (brands) => emit(BrandsState.loaded(newestFirst(brands, (e) => e.id))),
    );
  }

  /// A quiet re-read after a change: the list stays on screen meanwhile.
  Future<void> _reload() async {
    final current = state;
    if (current is BrandsInitial) return;
    if (current is! BrandsLoaded) return load();
    final read = beginRead();
    final result = await _getBrands();
    if (isStale(read)) return;
    result.fold(
      (_) {},
      (brands) => emit(BrandsState.loaded(newestFirst(brands, (e) => e.id))),
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
    markCreated(brand.id);
    final current = state;
    final others = current is BrandsLoaded
        ? current.brands.where((e) => e.id != brand.id)
        : const <BrandModel>[];
    emit(BrandsState.loaded([brand, ...others]));
  }
}
