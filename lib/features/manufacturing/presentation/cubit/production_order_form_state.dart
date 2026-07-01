import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frantend/features/manufacturing/data/models/bom_header_model.dart';
import 'package:frantend/features/manufacturing/data/models/bom_preview_model.dart';
import 'package:frantend/features/manufacturing/domain/utils/production_availability.dart';

part 'production_order_form_state.freezed.dart';

@freezed
class ProductionOrderFormState with _$ProductionOrderFormState {
  const factory ProductionOrderFormState({
    String? branchId,
    String? bomHeaderId,
    @Default('') String qtyToProduce,
    @Default('') String notes,
    @Default([]) List<BomHeaderModel> activeBoms,
    @Default(false) bool isPreviewLoading,
    BomPreviewModel? preview,
    @Default([]) List<IngredientAvailabilityRow> availability,
    @Default(false) bool hasShortfall,
    @Default(false) bool allowNegativeStock,
    @Default(false) bool isLoading,
    @Default(false) bool isSubmitting,
    @Default({}) Map<String, String> errors,
  }) = _ProductionOrderFormState;
}
