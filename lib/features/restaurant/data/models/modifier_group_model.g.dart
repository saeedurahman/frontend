// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'modifier_group_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ModifierModelImpl _$$ModifierModelImplFromJson(Map<String, dynamic> json) =>
    _$ModifierModelImpl(
      id: json['id'] as String,
      businessId: json['business_id'] as String,
      modifierGroupId: json['modifier_group_id'] as String,
      name: json['name'] as String,
      priceDelta: json['price_delta'] as String? ?? '0',
      isActive: json['is_active'] as bool? ?? true,
      sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );

Map<String, dynamic> _$$ModifierModelImplToJson(_$ModifierModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'business_id': instance.businessId,
      'modifier_group_id': instance.modifierGroupId,
      'name': instance.name,
      'price_delta': instance.priceDelta,
      'is_active': instance.isActive,
      'sort_order': instance.sortOrder,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };

_$ModifierGroupModelImpl _$$ModifierGroupModelImplFromJson(
  Map<String, dynamic> json,
) => _$ModifierGroupModelImpl(
  id: json['id'] as String,
  businessId: json['business_id'] as String,
  name: json['name'] as String,
  selectionType: json['selection_type'] as String,
  minSelections: (json['min_selections'] as num?)?.toInt() ?? 0,
  maxSelections: (json['max_selections'] as num?)?.toInt(),
  isRequired: json['is_required'] as bool? ?? false,
  sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
  isActive: json['is_active'] as bool? ?? true,
  modifiers: json['modifiers'] == null
      ? const []
      : _modifierListFromJson(json['modifiers']),
  createdAt: json['created_at'] as String?,
  updatedAt: json['updated_at'] as String?,
);

Map<String, dynamic> _$$ModifierGroupModelImplToJson(
  _$ModifierGroupModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'business_id': instance.businessId,
  'name': instance.name,
  'selection_type': instance.selectionType,
  'min_selections': instance.minSelections,
  'max_selections': instance.maxSelections,
  'is_required': instance.isRequired,
  'sort_order': instance.sortOrder,
  'is_active': instance.isActive,
  'modifiers': instance.modifiers,
  'created_at': instance.createdAt,
  'updated_at': instance.updatedAt,
};
