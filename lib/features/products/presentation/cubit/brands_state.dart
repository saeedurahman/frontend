import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frantend/features/products/data/models/brand_model.dart';

part 'brands_state.freezed.dart';

@freezed
class BrandsState with _$BrandsState {
  const factory BrandsState.initial() = BrandsInitial;
  const factory BrandsState.loading() = BrandsLoading;
  const factory BrandsState.loaded(List<BrandModel> brands) = BrandsLoaded;
  const factory BrandsState.error(String message) = BrandsError;
}
