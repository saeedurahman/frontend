import 'package:decimal/decimal.dart';
import 'package:frantend/features/restaurant/data/models/modifier_group_model.dart';

/// Selected modifier on a cart line — maps to backend modifier_ids.
class CartLineModifierModel {
  const CartLineModifierModel({
    required this.modifierId,
    required this.groupId,
    required this.groupName,
    required this.modifierName,
    required this.priceDelta,
  });

  final String modifierId;
  final String groupId;
  final String groupName;
  final String modifierName;
  final Decimal priceDelta;

  factory CartLineModifierModel.fromModels({
    required ModifierModel modifier,
    required ModifierGroupModel group,
  }) {
    return CartLineModifierModel(
      modifierId: modifier.id,
      groupId: group.id,
      groupName: group.name,
      modifierName: modifier.name,
      priceDelta:
          Decimal.tryParse(modifier.priceDelta) ?? Decimal.zero,
    );
  }

  Map<String, dynamic> toJson() => {
        'modifier_id': modifierId,
        'group_id': groupId,
        'group_name': groupName,
        'modifier_name': modifierName,
        'price_delta': priceDelta.toString(),
      };

  factory CartLineModifierModel.fromJson(Map<String, dynamic> json) {
    return CartLineModifierModel(
      modifierId: json['modifier_id'] as String,
      groupId: json['group_id'] as String,
      groupName: json['group_name'] as String,
      modifierName: json['modifier_name'] as String,
      priceDelta: Decimal.tryParse(json['price_delta']?.toString() ?? '') ??
          Decimal.zero,
    );
  }
}

Decimal cartModifierTotalPerUnit(List<CartLineModifierModel> modifiers) {
  return modifiers.fold(
    Decimal.zero,
    (sum, modifier) => sum + modifier.priceDelta,
  );
}

String buildCartLineKey({
  required String productId,
  String? variationId,
  List<CartLineModifierModel> modifiers = const [],
}) {
  final base =
      variationId != null ? '$productId:$variationId' : productId;
  if (modifiers.isEmpty) return base;
  final ids = modifiers.map((m) => m.modifierId).toList()..sort();
  return '$base:${ids.join(',')}';
}
