import 'package:freezed_annotation/freezed_annotation.dart';

part 'expense_category_model.freezed.dart';
part 'expense_category_model.g.dart';

@freezed
class ExpenseCategoryModel with _$ExpenseCategoryModel {
  const factory ExpenseCategoryModel({
    required String id,
    required String name,
    @JsonKey(name: 'parent_id') String? parentId,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @Default([]) List<ExpenseCategoryModel> children,
  }) = _ExpenseCategoryModel;

  factory ExpenseCategoryModel.fromJson(Map<String, dynamic> json) =>
      _$ExpenseCategoryModelFromJson(json);
}
