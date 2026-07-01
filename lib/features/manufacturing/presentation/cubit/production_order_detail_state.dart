import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frantend/features/manufacturing/data/models/bom_header_model.dart';
import 'package:frantend/features/manufacturing/data/models/bom_preview_model.dart';
import 'package:frantend/features/manufacturing/data/models/production_order_model.dart';
import 'package:frantend/features/manufacturing/domain/utils/production_availability.dart';

part 'production_order_detail_state.freezed.dart';

@freezed
class ProductionOrderDetailState with _$ProductionOrderDetailState {
  const factory ProductionOrderDetailState({
    ProductionOrderModel? order,
    @Default(false) bool isLoading,
    @Default(false) bool isUpdating,
    @Default(false) bool isEditingDraft,
    String? draftBomHeaderId,
    @Default('') String draftQtyToProduce,
    @Default('') String draftNotes,
    @Default([]) List<BomHeaderModel> activeBoms,
    @Default(false) bool isPreviewLoading,
    BomPreviewModel? completionPreview,
    @Default([]) List<IngredientAvailabilityRow> completionAvailability,
    @Default(false) bool allowNegativeStock,
    @Default(false) bool canCreate,
    @Default(false) bool canComplete,
    @Default(false) bool canCancel,
    @Default({}) Map<String, String> errors,
    String? loadError,
  }) = _ProductionOrderDetailState;
}
