// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ExpenseCategoryModelImpl _$$ExpenseCategoryModelImplFromJson(
  Map<String, dynamic> json,
) => _$ExpenseCategoryModelImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  parentId: json['parent_id'] as String?,
  isActive: json['is_active'] as bool? ?? true,
  children:
      (json['children'] as List<dynamic>?)
          ?.map((e) => ExpenseCategoryModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$ExpenseCategoryModelImplToJson(
  _$ExpenseCategoryModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'parent_id': instance.parentId,
  'is_active': instance.isActive,
  'children': instance.children,
};
