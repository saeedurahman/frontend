// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paginated_products_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PaginatedProductsModelImpl _$$PaginatedProductsModelImplFromJson(
  Map<String, dynamic> json,
) => _$PaginatedProductsModelImpl(
  total: (json['total'] as num).toInt(),
  skip: (json['skip'] as num).toInt(),
  limit: (json['limit'] as num).toInt(),
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => ProductListItemModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$PaginatedProductsModelImplToJson(
  _$PaginatedProductsModelImpl instance,
) => <String, dynamic>{
  'total': instance.total,
  'skip': instance.skip,
  'limit': instance.limit,
  'items': instance.items,
};
