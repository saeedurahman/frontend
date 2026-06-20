import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frantend/features/purchases/data/models/purchase_order_model.dart';

part 'purchase_order_detail_state.freezed.dart';

@Freezed()
sealed class PurchaseOrderDetailState with _$PurchaseOrderDetailState {
  const factory PurchaseOrderDetailState.initial() =
      PurchaseOrderDetailInitial;

  const factory PurchaseOrderDetailState.loading() =
      PurchaseOrderDetailLoading;

  const factory PurchaseOrderDetailState.loaded({
    required PurchaseOrderModel order,
    @Default(false) bool isUpdating,
  }) = PurchaseOrderDetailLoaded;

  const factory PurchaseOrderDetailState.error(String message) =
      PurchaseOrderDetailError;
}
