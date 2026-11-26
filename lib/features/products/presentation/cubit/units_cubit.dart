import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/data_changes/auto_refresh.dart';
import 'package:frantend/core/data_changes/data_change_bus.dart';
import 'package:frantend/features/products/data/models/unit_model.dart';
import 'package:frantend/features/products/domain/usecases/create_unit_usecase.dart';
import 'package:frantend/features/products/domain/usecases/get_units_usecase.dart';
import 'package:frantend/features/products/presentation/cubit/units_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class UnitsCubit extends Cubit<UnitsState>
    with AutoRefresh<UnitsState> {
  UnitsCubit({
    required GetUnitsUseCase getUnitsUseCase,
    required CreateUnitUseCase createUnitUseCase,
  })  : _getUnits = getUnitsUseCase,
        _createUnit = createUnitUseCase,
        super(const UnitsState.initial()) {
    watchData(const {DataTopic.units}, _reload);
  }

  final GetUnitsUseCase _getUnits;
  final CreateUnitUseCase _createUnit;

  Future<void> load() async {
    if (isClosed) return;
    final read = beginRead();
    emit(const UnitsState.loading());
    final result = await _getUnits();
    if (isStale(read)) return;
    result.fold(
      (f) => emit(UnitsState.error(f.message)),
      (units) => emit(UnitsState.loaded(newestFirst(units, (e) => e.id))),
    );
  }

  /// A quiet re-read after a change: the list stays on screen meanwhile.
  Future<void> _reload() async {
    final current = state;
    if (current is UnitsInitial) return;
    if (current is! UnitsLoaded) return load();
    final read = beginRead();
    final result = await _getUnits();
    if (isStale(read)) return;
    result.fold(
      (_) {},
      (units) => emit(UnitsState.loaded(newestFirst(units, (e) => e.id))),
    );
  }

  Future<UnitModel?> create({
    required String name,
    required String symbol,
    bool isBaseUnit = false,
  }) async {
    final result = await _createUnit({
      'name': name,
      'symbol': symbol,
      'is_base_unit': isBaseUnit,
    });
    return result.fold(
      (f) {
        if (!isClosed) emit(UnitsState.error(f.message));
        return null;
      },
      (unit) {
        if (!isClosed) _appendUnit(unit);
        return unit;
      },
    );
  }

  void _appendUnit(UnitModel unit) {
    markCreated(unit.id);
    final current = state;
    final others = current is UnitsLoaded
        ? current.units.where((e) => e.id != unit.id)
        : const <UnitModel>[];
    emit(UnitsState.loaded([unit, ...others]));
  }
}
