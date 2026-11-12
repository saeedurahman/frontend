// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paginated_sales_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PaginatedSalesModelImpl _$$PaginatedSalesModelImplFromJson(
  Map<String, dynamic> json,
) => _$PaginatedSalesModelImpl(
  total: JsonNum.intOr(json['total']),
  skip: JsonNum.intOr(json['skip']),
  limit: JsonNum.intOr(json['limit']),
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => SaleListItemModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$PaginatedSalesModelImplToJson(
  _$PaginatedSalesModelImpl instance,
) => <String, dynamic>{
  'total': instance.total,
  'skip': instance.skip,
  'limit': instance.limit,
  'items': instance.items,
};
