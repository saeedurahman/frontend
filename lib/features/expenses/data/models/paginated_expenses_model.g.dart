// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paginated_expenses_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PaginatedExpensesModelImpl _$$PaginatedExpensesModelImplFromJson(
  Map<String, dynamic> json,
) => _$PaginatedExpensesModelImpl(
  total: (json['total'] as num).toInt(),
  skip: (json['skip'] as num).toInt(),
  limit: (json['limit'] as num).toInt(),
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => ExpenseListItemModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$PaginatedExpensesModelImplToJson(
  _$PaginatedExpensesModelImpl instance,
) => <String, dynamic>{
  'total': instance.total,
  'skip': instance.skip,
  'limit': instance.limit,
  'items': instance.items,
};
