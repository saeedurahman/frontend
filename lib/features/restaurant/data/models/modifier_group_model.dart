import 'package:freezed_annotation/freezed_annotation.dart';

part 'modifier_group_model.freezed.dart';
part 'modifier_group_model.g.dart';

List<ModifierModel> _modifierListFromJson(Object? json) {
  if (json is! List) return const [];
  return json
      .whereType<Map>()
      .map((item) => ModifierModel.fromJson(Map<String, dynamic>.from(item)))
      .toList();
}

@freezed
class ModifierModel with _$ModifierModel {
  const factory ModifierModel({
    required String id,
    @JsonKey(name: 'business_id') required String businessId,
    @JsonKey(name: 'modifier_group_id') required String modifierGroupId,
    required String name,
    @JsonKey(name: 'price_delta') @Default('0') String priceDelta,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'sort_order') @Default(0) int sortOrder,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
  }) = _ModifierModel;

  factory ModifierModel.fromJson(Map<String, dynamic> json) =>
      _$ModifierModelFromJson(json);
}

@freezed
class ModifierGroupModel with _$ModifierGroupModel {
  const factory ModifierGroupModel({
    required String id,
    @JsonKey(name: 'business_id') required String businessId,
    required String name,
    @JsonKey(name: 'selection_type') required String selectionType,
    @JsonKey(name: 'min_selections') @Default(0) int minSelections,
    @JsonKey(name: 'max_selections') int? maxSelections,
    @JsonKey(name: 'is_required') @Default(false) bool isRequired,
    @JsonKey(name: 'sort_order') @Default(0) int sortOrder,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(fromJson: _modifierListFromJson)
    @Default([])
    List<ModifierModel> modifiers,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
  }) = _ModifierGroupModel;

  factory ModifierGroupModel.fromJson(Map<String, dynamic> json) =>
      _$ModifierGroupModelFromJson(json);
}
