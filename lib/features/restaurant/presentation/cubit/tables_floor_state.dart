import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frantend/features/restaurant/data/models/floor_plan_model.dart';

part 'tables_floor_state.freezed.dart';

enum TablesFloorStatus { initial, loading, loaded, error }

@freezed
class TablesFloorState with _$TablesFloorState {
  const TablesFloorState._();

  const factory TablesFloorState({
    @Default(TablesFloorStatus.initial) TablesFloorStatus status,
    FloorLayoutModel? layout,
    String? selectedFloorPlanId,
    @Default(false) bool isRefreshing,
    @Default(false) bool accessDenied,
    String? errorMessage,
  }) = _TablesFloorState;

  FloorPlanWithTablesModel? get selectedFloorPlan {
    final plans = layout?.floorPlans ?? const [];
    if (plans.isEmpty) return null;
    if (selectedFloorPlanId == null) return plans.first;
    for (final plan in plans) {
      if (plan.id == selectedFloorPlanId) return plan;
    }
    return plans.first;
  }

  List<DiningTableModel> get visibleTables {
    final plan = selectedFloorPlan;
    if (plan != null) return plan.tables;
    return layout?.unassignedTables ?? const [];
  }

  bool get hasMultipleFloorPlans => (layout?.floorPlans.length ?? 0) > 1;
}
