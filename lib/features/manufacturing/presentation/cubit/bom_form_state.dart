import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frantend/features/manufacturing/domain/utils/bom_qty_calculator.dart';
import 'package:frantend/features/products/data/models/product_list_item_model.dart';
import 'package:frantend/features/products/data/models/variation_model.dart';

part 'bom_form_state.freezed.dart';

@freezed
class BomLineFormItem with _$BomLineFormItem {
  const BomLineFormItem._();

  const factory BomLineFormItem({
    String? ingredientProductId,
    String? ingredientProductName,
    String? ingredientVariationId,
    String? ingredientVariationName,
    @Default('') String qtyRequired,
    @Default('0') String wastagePct,
    @Default([]) List<VariationModel> variations,
  }) = _BomLineFormItem;
}

@freezed
class BomFormState with _$BomFormState {
  const BomFormState._();

  const factory BomFormState({
    String? bomId,
    String? productId,
    String? productName,
    String? variationId,
    String? variationName,
    @Default([]) List<VariationModel> finishedVariations,
    @Default('') String name,
    @Default('1') String outputQty,
    @Default(true) bool isActive,
    @Default([]) List<BomLineFormItem> lines,
    @Default([]) List<ProductListItemModel> manufacturedProducts,
    @Default([]) List<ProductListItemModel> ingredientProducts,
    @Default('1') String previewBatchQty,
    @Default([]) List<BomQtyPreviewLine> previewLines,
    @Default(false) bool isLoading,
    @Default(false) bool isSubmitting,
    @Default(false) bool isDeleting,
    @Default({}) Map<String, String> errors,
  }) = _BomFormState;

  bool get isEdit => bomId != null;
}
