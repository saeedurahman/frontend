import 'package:frantend/core/utils/json_num.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'category_model.freezed.dart';
part 'category_model.g.dart';

@freezed
abstract class CategoryModel with _$CategoryModel {
  const factory CategoryModel({
    required String id,
    // A product embeds only {id, name, parent_id} (the backend's CategoryBrief),
    // so everything beyond the id and the name may be missing.
    @JsonKey(name: 'business_id') @Default('') String businessId,
    @JsonKey(name: 'parent_id') String? parentId,
    required String name,
    String? slug,
    @JsonKey(name: 'sort_order', fromJson: JsonNum.intOrNull) int? sortOrder,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
    @Default([]) List<CategoryModel> children,
  }) = _CategoryModel;

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);
}
