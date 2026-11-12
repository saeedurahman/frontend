// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paginated_expenses_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PaginatedExpensesModelImpl _$$PaginatedExpensesModelImplFromJson(
  Map<String, dynamic> json,
) => _$PaginatedExpensesModelImpl(
  total: JsonNum.intOr(json['total']),
  skip: JsonNum.intOr(json['skip']),
  limit: JsonNum.intOr(json['limit']),
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
