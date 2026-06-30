// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'floor_plan_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FloorPlanModelImpl _$$FloorPlanModelImplFromJson(Map<String, dynamic> json) =>
    _$FloorPlanModelImpl(
      id: json['id'] as String,
      businessId: json['business_id'] as String,
      branchId: json['branch_id'] as String,
      name: json['name'] as String,
      sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
      isActive: json['is_active'] as bool? ?? true,
      layoutJson: json['layout_json'] == null
          ? const {}
          : _layoutJsonFromJson(json['layout_json']),
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );

Map<String, dynamic> _$$FloorPlanModelImplToJson(
  _$FloorPlanModelImpl instance,
) => <String, dynamic>{
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

_$FloorPlanWithTablesModelImpl _$$FloorPlanWithTablesModelImplFromJson(
  Map<String, dynamic> json,
) => _$FloorPlanWithTablesModelImpl(
  id: json['id'] as String,
  businessId: json['business_id'] as String,
  branchId: json['branch_id'] as String,
  name: json['name'] as String,
  sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
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

Map<String, dynamic> _$$FloorPlanWithTablesModelImplToJson(
  _$FloorPlanWithTablesModelImpl instance,
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

_$FloorLayoutModelImpl _$$FloorLayoutModelImplFromJson(
  Map<String, dynamic> json,
) => _$FloorLayoutModelImpl(
  branchId: json['branch_id'] as String,
  floorPlans: json['floor_plans'] == null
      ? const []
      : _floorPlanWithTablesListFromJson(json['floor_plans']),
  unassignedTables: json['unassigned_tables'] == null
      ? const []
      : _diningTableListFromJson(json['unassigned_tables']),
);

Map<String, dynamic> _$$FloorLayoutModelImplToJson(
  _$FloorLayoutModelImpl instance,
) => <String, dynamic>{
  'branch_id': instance.branchId,
  'floor_plans': instance.floorPlans,
  'unassigned_tables': instance.unassignedTables,
};

_$DiningTableModelImpl _$$DiningTableModelImplFromJson(
  Map<String, dynamic> json,
) => _$DiningTableModelImpl(
  id: json['id'] as String,
  businessId: json['business_id'] as String,
  branchId: json['branch_id'] as String,
  floorPlanId: json['floor_plan_id'] as String?,
  tableNumber: json['table_number'] as String,
  capacity: (json['capacity'] as num?)?.toInt() ?? 4,
  status: json['status'] as String,
  posX: json['pos_x'] as String?,
  posY: json['pos_y'] as String?,
  isActive: json['is_active'] as bool? ?? true,
  activeSaleId: json['active_sale_id'] as String?,
  createdAt: json['created_at'] as String?,
  updatedAt: json['updated_at'] as String?,
);

Map<String, dynamic> _$$DiningTableModelImplToJson(
  _$DiningTableModelImpl instance,
) => <String, dynamic>{
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
