import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/features/products/data/models/unit_model.dart';
import 'package:frantend/features/products/domain/usecases/create_unit_usecase.dart';
import 'package:frantend/features/products/domain/usecases/get_units_usecase.dart';
import 'package:frantend/features/products/presentation/cubit/units_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class UnitsCubit extends Cubit<UnitsState> {
  UnitsCubit({
    required GetUnitsUseCase getUnitsUseCase,
    required CreateUnitUseCase createUnitUseCase,
  })  : _getUnits = getUnitsUseCase,
        _createUnit = createUnitUseCase,
        super(const UnitsState.initial());

  final GetUnitsUseCase _getUnits;
  final CreateUnitUseCase _createUnit;

  Future<void> load() async {
    if (isClosed) return;
    emit(const UnitsState.loading());
    final result = await _getUnits();
    if (isClosed) return;
    result.fold(
      (f) => emit(UnitsState.error(f.message)),
      (units) => emit(UnitsState.loaded(units)),
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
    final current = state;
    if (current is UnitsLoaded) {
      if (!current.units.any((u) => u.id == unit.id)) {
        emit(UnitsState.loaded([...current.units, unit]));
      }
    } else {
      emit(UnitsState.loaded([unit]));
    }
  }
}
