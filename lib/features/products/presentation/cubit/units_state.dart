import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frantend/features/products/data/models/unit_model.dart';

part 'units_state.freezed.dart';

@freezed
class UnitsState with _$UnitsState {
  const factory UnitsState.initial() = UnitsInitial;
  const factory UnitsState.loading() = UnitsLoading;
  const factory UnitsState.loaded(List<UnitModel> units) = UnitsLoaded;
  const factory UnitsState.error(String message) = UnitsError;
}
