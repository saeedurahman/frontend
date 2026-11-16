// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paginated_products_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PaginatedProductsModel _$PaginatedProductsModelFromJson(
  Map<String, dynamic> json,
) => _PaginatedProductsModel(
  total: JsonNum.intOr(json['total']),
  skip: JsonNum.intOr(json['skip']),
  limit: JsonNum.intOr(json['limit']),
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => ProductListItemModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$PaginatedProductsModelToJson(
  _PaginatedProductsModel instance,
) => <String, dynamic>{
  'total': instance.total,
  'skip': instance.skip,
  'limit': instance.limit,
  'items': instance.items,
};
