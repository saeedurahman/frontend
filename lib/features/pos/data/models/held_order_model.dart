import 'package:decimal/decimal.dart';
import 'package:frantend/features/pos/data/models/cart_item_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'held_order_model.freezed.dart';

@freezed
class HeldOrderModel with _$HeldOrderModel {
  const factory HeldOrderModel({
    required String id,
    required String label,
    required DateTime createdAt,
    required List<CartItemModel> cartItems,
    String? customerId,
    String? customerName,
    String? cartDiscountType,
    Decimal? cartDiscountValue,
    required int itemCount,
    required Decimal totalAmount,
  }) = _HeldOrderModel;
}
