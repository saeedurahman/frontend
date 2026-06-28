import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:drift/drift.dart';
import 'package:frantend/core/database/app_database.dart';
import 'package:frantend/features/pos/data/models/cart_item_model.dart';
import 'package:frantend/features/pos/data/models/held_order_model.dart';

abstract final class HeldOrderStorageMapper {
  static HeldOrderModel fromRow(HeldOrdersTableData row) {
    final itemsJson = jsonDecode(row.cartItemsJson) as List<dynamic>;
    final cartItems = itemsJson
        .map((e) => CartItemModel.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();

    return HeldOrderModel(
      id: row.id,
      label: row.label,
      createdAt: row.createdAt,
      cartItems: cartItems,
      customerId: row.customerId,
      customerName: row.customerName,
      cartDiscountType: row.cartDiscountType,
      cartDiscountValue: row.cartDiscountValue != null
          ? Decimal.tryParse(row.cartDiscountValue!)
          : null,
      itemCount: row.itemCount,
      totalAmount: Decimal.tryParse(row.totalAmount) ?? Decimal.zero,
    );
  }

  static HeldOrdersTableCompanion toCompanion(HeldOrderModel order) {
    return HeldOrdersTableCompanion.insert(
      id: order.id,
      label: order.label,
      createdAt: order.createdAt,
      cartItemsJson: jsonEncode(order.cartItems.map((e) => e.toJson()).toList()),
      customerId: Value(order.customerId),
      customerName: Value(order.customerName),
      cartDiscountType: Value(order.cartDiscountType),
      cartDiscountValue: Value(order.cartDiscountValue?.toString()),
      itemCount: order.itemCount,
      totalAmount: order.totalAmount.toString(),
    );
  }
}
