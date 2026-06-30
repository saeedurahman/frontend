import 'package:freezed_annotation/freezed_annotation.dart';

part 'floor_plan_model.freezed.dart';
part 'floor_plan_model.g.dart';

List<DiningTableModel> _diningTableListFromJson(Object? json) {
  if (json is! List) return const [];
  return json
      .whereType<Map>()
      .map((item) => DiningTableModel.fromJson(Map<String, dynamic>.from(item)))
      .toList();
}

List<FloorPlanWithTablesModel> _floorPlanWithTablesListFromJson(Object? json) {
  if (json is! List) return const [];
  return json
      .whereType<Map>()
      .map(
        (item) =>
            FloorPlanWithTablesModel.fromJson(Map<String, dynamic>.from(item)),
      )
      .toList();
}

Map<String, dynamic> _layoutJsonFromJson(Object? json) {
  if (json is Map) return Map<String, dynamic>.from(json);
  return const {};
}

@freezed
class FloorPlanModel with _$FloorPlanModel {
  const factory FloorPlanModel({
    required String id,
    @JsonKey(name: 'business_id') required String businessId,
    @JsonKey(name: 'branch_id') required String branchId,
    required String name,
    @JsonKey(name: 'sort_order') @Default(0) int sortOrder,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'layout_json', fromJson: _layoutJsonFromJson)
    @Default({})
    Map<String, dynamic> layoutJson,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
  }) = _FloorPlanModel;

  factory FloorPlanModel.fromJson(Map<String, dynamic> json) =>
      _$FloorPlanModelFromJson(json);
}

@freezed
class FloorPlanWithTablesModel with _$FloorPlanWithTablesModel {
  const factory FloorPlanWithTablesModel({
    required String id,
    @JsonKey(name: 'business_id') required String businessId,
    @JsonKey(name: 'branch_id') required String branchId,
    required String name,
    @JsonKey(name: 'sort_order') @Default(0) int sortOrder,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'layout_json', fromJson: _layoutJsonFromJson)
    @Default({})
    Map<String, dynamic> layoutJson,
    @JsonKey(fromJson: _diningTableListFromJson)
    @Default([])
    List<DiningTableModel> tables,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
  }) = _FloorPlanWithTablesModel;

  factory FloorPlanWithTablesModel.fromJson(Map<String, dynamic> json) =>
      _$FloorPlanWithTablesModelFromJson(json);
}

@freezed
class FloorLayoutModel with _$FloorLayoutModel {
  const factory FloorLayoutModel({
    @JsonKey(name: 'branch_id') required String branchId,
    @JsonKey(name: 'floor_plans', fromJson: _floorPlanWithTablesListFromJson)
    @Default([])
    List<FloorPlanWithTablesModel> floorPlans,
    @JsonKey(name: 'unassigned_tables', fromJson: _diningTableListFromJson)
    @Default([])
    List<DiningTableModel> unassignedTables,
  }) = _FloorLayoutModel;

  factory FloorLayoutModel.fromJson(Map<String, dynamic> json) =>
      _$FloorLayoutModelFromJson(json);
}

@freezed
class DiningTableModel with _$DiningTableModel {
  const factory DiningTableModel({
    required String id,
    @JsonKey(name: 'business_id') required String businessId,
    @JsonKey(name: 'branch_id') required String branchId,
    @JsonKey(name: 'floor_plan_id') String? floorPlanId,
    @JsonKey(name: 'table_number') required String tableNumber,
    @Default(4) int capacity,
    required String status,
    @JsonKey(name: 'pos_x') String? posX,
    @JsonKey(name: 'pos_y') String? posY,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'active_sale_id') String? activeSaleId,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
  }) = _DiningTableModel;

  factory DiningTableModel.fromJson(Map<String, dynamic> json) =>
      _$DiningTableModelFromJson(json);
}
