// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'floor_plan_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FloorPlanModel _$FloorPlanModelFromJson(Map<String, dynamic> json) =>
    _FloorPlanModel(
      id: json['id'] as String,
      businessId: json['business_id'] as String,
      branchId: json['branch_id'] as String,
      name: json['name'] as String,
      sortOrder: json['sort_order'] == null
          ? 0
          : JsonNum.intOr(json['sort_order']),
      isActive: json['is_active'] as bool? ?? true,
      layoutJson: json['layout_json'] == null
          ? const {}
          : _layoutJsonFromJson(json['layout_json']),
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );

Map<String, dynamic> _$FloorPlanModelToJson(_FloorPlanModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'business_id': instance.businessId,
      'branch_id': instance.branchId,
      'name': instance.name,
      'sort_order': instance.sortOrder,
      'is_active': instance.isActive,
      'layout_json': instance.layoutJson,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };

_FloorPlanWithTablesModel _$FloorPlanWithTablesModelFromJson(
  Map<String, dynamic> json,
) => _FloorPlanWithTablesModel(
  id: json['id'] as String,
  businessId: json['business_id'] as String,
  branchId: json['branch_id'] as String,
  name: json['name'] as String,
  sortOrder: json['sort_order'] == null ? 0 : JsonNum.intOr(json['sort_order']),
  isActive: json['is_active'] as bool? ?? true,
  layoutJson: json['layout_json'] == null
      ? const {}
      : _layoutJsonFromJson(json['layout_json']),
  tables: json['tables'] == null
      ? const []
      : _diningTableListFromJson(json['tables']),
  createdAt: json['created_at'] as String?,
  updatedAt: json['updated_at'] as String?,
);

Map<String, dynamic> _$FloorPlanWithTablesModelToJson(
  _FloorPlanWithTablesModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'business_id': instance.businessId,
  'branch_id': instance.branchId,
  'name': instance.name,
  'sort_order': instance.sortOrder,
  'is_active': instance.isActive,
  'layout_json': instance.layoutJson,
  'tables': instance.tables,
  'created_at': instance.createdAt,
  'updated_at': instance.updatedAt,
};

_FloorLayoutModel _$FloorLayoutModelFromJson(Map<String, dynamic> json) =>
    _FloorLayoutModel(
      branchId: json['branch_id'] as String,
      floorPlans: json['floor_plans'] == null
          ? const []
          : _floorPlanWithTablesListFromJson(json['floor_plans']),
      unassignedTables: json['unassigned_tables'] == null
          ? const []
          : _diningTableListFromJson(json['unassigned_tables']),
    );

Map<String, dynamic> _$FloorLayoutModelToJson(_FloorLayoutModel instance) =>
    <String, dynamic>{
      'branch_id': instance.branchId,
      'floor_plans': instance.floorPlans,
      'unassigned_tables': instance.unassignedTables,
    };

_DiningTableModel _$DiningTableModelFromJson(Map<String, dynamic> json) =>
    _DiningTableModel(
      id: json['id'] as String,
      businessId: json['business_id'] as String,
      branchId: json['branch_id'] as String,
      floorPlanId: json['floor_plan_id'] as String?,
      tableNumber: json['table_number'] as String,
      capacity: json['capacity'] == null ? 4 : JsonNum.intOr(json['capacity']),
      status: json['status'] as String,
      posX: json['pos_x'] as String?,
      posY: json['pos_y'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      activeSaleId: json['active_sale_id'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );

Map<String, dynamic> _$DiningTableModelToJson(_DiningTableModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'business_id': instance.businessId,
      'branch_id': instance.branchId,
      'floor_plan_id': instance.floorPlanId,
      'table_number': instance.tableNumber,
      'capacity': instance.capacity,
      'status': instance.status,
      'pos_x': instance.posX,
      'pos_y': instance.posY,
      'is_active': instance.isActive,
      'active_sale_id': instance.activeSaleId,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
